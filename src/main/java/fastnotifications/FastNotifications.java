package fastnotifications;

import java.time.Duration;

/**
 * FastNotifications — Native Java notifications for Windows 11, macOS, Linux.
 * 
 * Replaces ugly java.awt.SystemTray with real OS-native Toasts.
 * 
 * @author Andre Stubbe
 * @version 1.0.0-alpha
 */
public class FastNotifications {
    
    static {
        // TODO: Load native library via FastCore
        System.loadLibrary("fastnotification");
    }
    
    /**
     * Display a simple notification.
     * 
     * @param title   Notification title
     * @param message Notification body text
     */
    public static native void notify(String title, String message);
    
    /**
     * Display a notification with custom icon.
     * 
     * @param title    Notification title
     * @param message  Notification body text
     * @param iconPath Path to icon file (PNG recommended)
     */
    public static native void notify(String title, String message, String iconPath);
    
    /**
     * Create a notification builder for advanced configuration.
     * 
     * @return new NotificationBuilder instance
     */
    public static NotificationBuilder builder() {
        return new NotificationBuilder();
    }
    
    /**
     * Create a progress notification.
     * 
     * @param title   Progress dialog title
     * @param message Initial message
     * @return ProgressNotification instance
     */
    public static native ProgressNotification progress(String title, String message);
    
    /**
     * Builder class for constructing notifications with advanced options.
     */
    public static class NotificationBuilder {
        private String title;
        private String message;
        private String iconPath;
        private Urgency urgency = Urgency.NORMAL;
        private Duration timeout;
        // TODO: Store actions for native callback
        
        public NotificationBuilder title(String title) {
            this.title = title;
            return this;
        }
        
        public NotificationBuilder message(String message) {
            this.message = message;
            return this;
        }
        
        public NotificationBuilder icon(String iconPath) {
            this.iconPath = iconPath;
            return this;
        }
        
        public NotificationBuilder urgency(Urgency urgency) {
            this.urgency = urgency;
            return this;
        }
        
        public NotificationBuilder timeout(Duration timeout) {
            this.timeout = timeout;
            return this;
        }
        
        public NotificationBuilder action(String label, Runnable callback) {
            // TODO: Register native callback
            return this;
        }
        
        /**
         * Display the configured notification.
         */
        public void show() {
            // TODO: Call native show with all parameters
            notify(title, message, iconPath);
        }
    }
    
    /**
     * Urgency levels for notifications.
     */
    public enum Urgency {
        LOW,
        NORMAL,
        HIGH,
        CRITICAL
    }
}
