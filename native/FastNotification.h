/**
 * FastNotification Native Header
 * Windows 11 WinRT Toast Notifications
 * 
 * @author Andre Stubbe
 * @version 1.0.0-alpha
 */

#ifndef FASTNOTIFICATION_H
#define FASTNOTIFICATION_H

#include <jni.h>
#include <windows.h>
#include <string>

// WinRT headers
#include <windows.ui.notifications.h>
#include <wrl/client.h>

using namespace Microsoft::WRL;
using namespace ABI::Windows::UI::Notifications;
using namespace ABI::Windows::Data::Xml::Dom;

/**
 * Initialize WinRT Toast Notifier
 * Must be called before showing any notifications
 * 
 * @return true if initialization succeeded
 */
bool InitializeNotifier();

/**
 * Create Toast XML string with title, message, and optional icon
 * 
 * @param title    Notification title (wide string)
 * @param message  Notification body (wide string)
 * @param iconPath Optional icon path for appLogoOverride (wide string)
 * @return Complete toast XML as wide string
 */
std::wstring CreateToastXml(const wchar_t* title, const wchar_t* message, const wchar_t* iconPath);

/**
 * Show or replace a toast notification
 * If tag matches existing notification, it will be replaced
 * 
 * @param tag      Unique identifier for notification grouping/replacement
 * @param title    Notification title (UTF-8)
 * @param message  Notification body (UTF-8)
 * @param iconPath Optional icon path (UTF-8)
 */
void ShowToast(const char* tag, const char* title, const char* message, const char* iconPath);

/**
 * Show toast notification with action buttons
 * 
 * @param tag      Unique identifier
 * @param title    Notification title
 * @param message  Notification body
 * @param iconPath Optional icon path
 * @param urgency  Urgency level (0=LOW, 1=NORMAL, 2=HIGH, 3=CRITICAL)
 * @param timeoutMs Auto-dismiss timeout in milliseconds (0 = use default)
 * @param actions  JSON array of action objects [{"label": "...", "actionId": "..."}]
 */
void ShowToastWithActions(const char* tag, const char* title, const char* message, 
                          const char* iconPath, int urgency, int timeoutMs, const char* actions);

/**
 * Create or update a progress notification
 * 
 * @param tag      Unique identifier
 * @param title    Progress dialog title
 * @param message  Current status message
 * @param percent  Progress percentage (0-100)
 * @return Native notification handle
 */
int64_t CreateProgressNotification(const char* tag, const char* title, const char* message);

/**
 * Update progress notification
 * 
 * @param handle   Notification handle from CreateProgressNotification
 * @param percent  New progress percentage (0-100)
 * @param message  Optional new message (nullptr to keep existing)
 */
void UpdateProgressNotification(int64_t handle, int percent, const char* message);

/**
 * Complete and dismiss progress notification
 * 
 * @param handle Notification handle
 * @param message Final completion message
 */
void CompleteProgressNotification(int64_t handle, const char* message);

/**
 * Dismiss notification by tag
 * 
 * @param tag Notification identifier to dismiss
 */
void DismissNotification(const char* tag);

/**
 * Cleanup WinRT resources
 * Call on application exit
 */
void CleanupNotifier();

// ============================================================================
// JNI Callbacks
// ============================================================================

/**
 * Called when user clicks an action button
 * Java callback: FastNotifications.onActionClicked(tag, actionId)
 * 
 * @param tag      Notification tag
 * @param actionId Action identifier from the actions JSON
 */
void FireActionCallback(JNIEnv* env, const char* tag, const char* actionId);

#endif // FASTNOTIFICATION_H
