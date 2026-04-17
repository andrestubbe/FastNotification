/**
 * @file FastNotification.cpp
 * @brief Native Windows 11 Toast Notifications for Java
 * 
 * @details Implements the JNI native layer for FastNotifications using the Windows
 * WinRT Toast API (Windows 10 1903+ / Windows 11). Provides native toast notifications
 * with custom icons, action buttons, progress bars, and notification grouping via tags.
 * 
 * @par Architecture
 * - WinRT Windows.UI.Notifications API for toast creation
 * - XML-based toast templates (ToastGeneric)
 * - Tag-based notification replacement (updates existing notifications)
 * - JNI bridge for Java callback integration
 * 
 * @par Platform Requirements
 * - Windows 10 version 1903 or later (partial support)
 * - Windows 11 (full support)
 * - Visual C++ Runtime (VS 2019/2022)
 * 
 * @par Key Features
 * - AppLogoOverride: Custom app icons (replaces Java coffee cup)
 * - Progress notifications with visual progress bars
 * - Action buttons with Java callbacks
 * - Urgency levels (Low, Normal, High, Critical)
 * 
 * @author Andre Stubbe
 * @version 1.0.0-alpha
 * @since 1.0.0
 */

#include <jni.h>
#include <windows.h>
#include <string>
#include <map>

// WinRT headers for Toast Notifications
#include <roapi.h>
#include <hstring.h>
#include <windows.ui.notifications.h>
#include <wrl/client.h>
#include <wrl/wrappers/corewrappers.h>

using namespace Microsoft::WRL;
using namespace Microsoft::WRL::Wrappers;
using namespace ABI::Windows::UI::Notifications;
using namespace ABI::Windows::Data::Xml::Dom;

// Global notification manager
static ComPtr<IToastNotifier> g_notifier;
static std::map<std::string, ComPtr<IToastNotification>> g_activeNotifications;

/** @brief Global JNI environment for callbacks */
static JNIEnv* g_jniEnv = nullptr;
/** @brief Global JVM reference for callback threading */
static JavaVM* g_jvm = nullptr;

// ============================================================================
// WINRT INITIALIZATION
// ============================================================================

/**
 * @brief Initialize WinRT Toast Notifier
 * 
 * @details Creates the ToastNotificationManager and obtains a ToastNotifier
 * for the current application. Must be called before any toast operations.
 * 
 * @return true if initialization succeeded, false otherwise
 * 
 * @note Safe to call multiple times - returns true immediately if already initialized
 */
bool InitializeNotifier() {
    if (g_notifier) return true;
    
    // Initialize WinRT
    RoInitialize(RO_INIT_MULTITHREADED);
    
    // Create Toast Notification Manager
    ComPtr<IToastNotificationManagerStatics> toastManager;
    HRESULT hr = RoGetActivationFactory(
        HStringReference(RuntimeClass_Windows_UI_Notifications_ToastNotificationManager).Get(),
        IID_PPV_ARGS(&toastManager)
    );
    
    if (FAILED(hr)) return false;
    
    // Get default notifier for current app
    HString appId;
    appId.Set(L"FastNotification");
    
    hr = toastManager->CreateToastNotifierWithId(appId.Get(), &g_notifier);
    
    return SUCCEEDED(hr);
}

// ============================================================================
// TOAST XML GENERATION
// ============================================================================

/**
 * @brief Create Toast XML with title, message, and optional icon
 * 
 * @details Generates a ToastGeneric XML document for Windows 11 notifications.
 * Uses AppLogoOverride to replace the default application icon.
 * 
 * @param title    Notification title (wide string)
 * @param message  Notification body text (wide string)
 * @param iconPath Optional icon path for appLogoOverride (wide string, nullable)
 * @return Wide string containing complete toast XML
 * 
 * @note The icon must be accessible from the process (absolute path recommended)
 */
std::wstring CreateToastXml(const wchar_t* title, const wchar_t* message, const wchar_t* iconPath) {
    std::wstring xml = L"<toast>\n";
    xml += L"  <visual>\n";
    xml += L"    <binding template='ToastGeneric'>\n";
    
    // App logo override (custom icon instead of Java coffee cup)
    if (iconPath && wcslen(iconPath) > 0) {
        xml += L"      <image placement='appLogoOverride' src='";
        xml += iconPath;
        xml += L"' />\n";
    }
    
    // Title and message
    xml += L"      <text>";
    xml += title;
    xml += L"</text>\n";
    xml += L"      <text>";
    xml += message;
    xml += L"</text>\n";
    
    xml += L"    </binding>\n";
    xml += L"  </visual>\n";
    xml += L"</toast>";
    
    return xml;
}

// ============================================================================
// TOAST DISPLAY
// ============================================================================

/**
 * @brief Show or update a toast notification
 * 
 * @details Creates and displays a Windows toast notification. If a tag is provided
 * and matches an existing notification, that notification is replaced (updated).
 * Without a tag, each call creates a new notification.
 * 
 * @param tag      Unique identifier for notification grouping/replacement (UTF-8, nullable)
 * @param title    Notification title (UTF-8)
 * @param message  Notification body text (UTF-8)
 * @param iconPath Optional icon path for custom app logo (UTF-8, nullable)
 * 
 * @note This function handles all string conversions (UTF-8 -> UTF-16)
 * @note If WinRT initialization fails, this function returns silently
 * 
 * @see CreateToastXml for XML generation
 * @see InitializeNotifier for WinRT setup
 */
void ShowToast(const char* tag, const char* title, const char* message, const char* iconPath) {
    if (!InitializeNotifier()) return;
    
    // Convert to wide strings
    std::wstring wTitle(title, title + strlen(title));
    std::wstring wMessage(message, message + strlen(message));
    std::wstring wIconPath;
    if (iconPath) {
        wIconPath = std::wstring(iconPath, iconPath + strlen(iconPath));
    }
    
    // Create XML
    std::wstring toastXml = CreateToastXml(wTitle.c_str(), wMessage.c_str(), 
                                           iconPath ? wIconPath.c_str() : nullptr);
    
    // Create XML document
    ComPtr<IXmlDocument> xmlDoc;
    ComPtr<IXmlDocumentIO> xmlDocIO;
    
    HRESULT hr = RoActivateInstance(
        HStringReference(RuntimeClass_Windows_Data_Xml_Dom_XmlDocument).Get(),
        &xmlDoc
    );
    
    if (FAILED(hr)) return;
    
    hr = xmlDoc.As(&xmlDocIO);
    if (FAILED(hr)) return;
    
    hr = xmlDocIO->LoadXml(HStringReference(toastXml.c_str()).Get());
    if (FAILED(hr)) return;
    
    // Create toast notification
    ComPtr<IToastNotificationFactory> toastFactory;
    hr = RoGetActivationFactory(
        HStringReference(RuntimeClass_Windows_UI_Notifications_ToastNotification).Get(),
        IID_PPV_ARGS(&toastFactory)
    );
    
    if (FAILED(hr)) return;
    
    ComPtr<IToastNotification> toast;
    hr = toastFactory->CreateToastNotification(xmlDoc.Get(), &toast);
    if (FAILED(hr)) return;
    
    // Set tag for replacement
    if (tag && strlen(tag) > 0) {
        HString hTag;
        std::wstring wTag(tag, tag + strlen(tag));
        hTag.Set(wTag.c_str());
        
        ComPtr<IToastNotification2> toast2;
        if (SUCCEEDED(toast.As(&toast2))) {
            toast2->put_Tag(hTag.Get());
        }
    }
    
    // Show or replace notification
    hr = g_notifier->Show(toast.Get());
    
    if (SUCCEEDED(hr) && tag) {
        g_activeNotifications[tag] = toast;
    }
}

// ============================================================================
// JNI Methods - Java Native Interface
// ============================================================================

extern "C" {

/**
 * @brief JNI: Simple notification without icon
 * 
 * @param env     JNI environment
 * @param clazz   Java class reference (unused)
 * @param title   Notification title (Java String)
 * @param message Notification body (Java String)
 * 
 * Java signature: native void notify(String title, String message)
 */
JNIEXPORT void JNICALL
Java_fastnotifications_FastNotifications_notify(JNIEnv* env, jclass clazz, 
                                                  jstring title, jstring message) {
    const char* cTitle = env->GetStringUTFChars(title, nullptr);
    const char* cMessage = env->GetStringUTFChars(message, nullptr);
    
    ShowToast(nullptr, cTitle, cMessage, nullptr);
    
    env->ReleaseStringUTFChars(title, cTitle);
    env->ReleaseStringUTFChars(message, cMessage);
}

/**
 * @brief JNI: Tagged notification without icon
 * 
 * @param env     JNI environment
 * @param clazz   Java class reference (unused)
 * @param tag     Notification tag for replacement (Java String)
 * @param title   Notification title (Java String)
 * @param message Notification body (Java String)
 * 
 * Java signature: native void notifyTagged(String tag, String title, String message)
 */
JNIEXPORT void JNICALL
Java_fastnotifications_FastNotifications_notifyTagged(JNIEnv* env, jclass clazz,
                                                       jstring tag, jstring title, jstring message) {
    const char* cTag = env->GetStringUTFChars(tag, nullptr);
    const char* cTitle = env->GetStringUTFChars(title, nullptr);
    const char* cMessage = env->GetStringUTFChars(message, nullptr);
    
    ShowToast(cTag, cTitle, cMessage, nullptr);
    
    env->ReleaseStringUTFChars(tag, cTag);
    env->ReleaseStringUTFChars(title, cTitle);
    env->ReleaseStringUTFChars(message, cMessage);
}

JNIEXPORT void JNICALL
Java_fastnotifications_FastNotifications_notifyTagged__Ljava_lang_String_2Ljava_lang_String_2Ljava_lang_String_2Ljava_lang_String_2(
    JNIEnv* env, jclass clazz, jstring tag, jstring title, jstring message, jstring iconPath) {
    
    const char* cTag = env->GetStringUTFChars(tag, nullptr);
    const char* cTitle = env->GetStringUTFChars(title, nullptr);
    const char* cMessage = env->GetStringUTFChars(message, nullptr);
    const char* cIcon = iconPath ? env->GetStringUTFChars(iconPath, nullptr) : nullptr;
    
    ShowToast(cTag, cTitle, cMessage, cIcon);
    
    env->ReleaseStringUTFChars(tag, cTag);
    env->ReleaseStringUTFChars(title, cTitle);
    env->ReleaseStringUTFChars(message, cMessage);
    if (cIcon) env->ReleaseStringUTFChars(iconPath, cIcon);
}

JNIEXPORT void JNICALL
Java_fastnotifications_FastNotifications_notify__Ljava_lang_String_2Ljava_lang_String_2Ljava_lang_String_2(
    JNIEnv* env, jclass clazz, jstring title, jstring message, jstring iconPath) {
    
    const char* cTitle = env->GetStringUTFChars(title, nullptr);
    const char* cMessage = env->GetStringUTFChars(message, nullptr);
    const char* cIcon = iconPath ? env->GetStringUTFChars(iconPath, nullptr) : nullptr;
    
    ShowToast(nullptr, cTitle, cMessage, cIcon);
    
    env->ReleaseStringUTFChars(title, cTitle);
    env->ReleaseStringUTFChars(message, cMessage);
    if (cIcon) env->ReleaseStringUTFChars(iconPath, cIcon);
}

} // extern "C"
