package fastnotification.examples;

import fastnotifications.FastNotifications;

/**
 * Basic FastNotification demo - Level 1 quick start.
 * 
 * Shows simple balloon-style notifications on Windows.
 */
public class BasicNotificationDemo {
    
    static {
        // Load DLL (Windows)
        System.loadLibrary("FastNotification");
    }
    
    public static void main(String[] args) throws Exception {
        System.out.println("FastNotification - Basic Demo");
        System.out.println("==============================\n");
        
        // 1. Simple notification
        System.out.println("1. Showing simple notification...");
        FastNotifications.notify("Hello", "This is a test notification!");
        Thread.sleep(2000);
        
        // 2. Notification with icon reference
        System.out.println("2. Showing tagged notification...");
        FastNotifications.notifyTagged("demo-1", "Download Progress", "Starting download...");
        Thread.sleep(1500);
        
        // 3. Update the tagged notification
        System.out.println("3. Updating tagged notification...");
        FastNotifications.notifyTagged("demo-1", "Download Progress", "50% complete...");
        Thread.sleep(1500);
        
        // 4. Final update
        System.out.println("4. Final update...");
        FastNotifications.notifyTagged("demo-1", "Download Complete", "File downloaded successfully!");
        Thread.sleep(2000);
        
        System.out.println("\nDemo complete!");
        System.out.println("\nNote: On Windows 11, balloon notifications may be suppressed.");
        System.out.println("For production apps, use Level 2 integration (WinRT/Toast notifications).");
    }
}
