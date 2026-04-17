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
     * Display or update a notification by tag.
     * Same tag replaces previous notification (useful for progress updates).
     * 
     * @param tag     Unique identifier for this notification
     * @param title   Notification title
     * @param message Notification body text
     */
    public static native void notifyTagged(String tag, String title, String message);
    
    /**
     * Display or update notification with tag and icon.
     * 
     * @param tag      Unique identifier for this notification
     * @param title    Notification title
     * @param message  Notification body text
     * @param iconPath Path to icon file
     */
    public static native void notifyTagged(String tag, String title, String message, String iconPath);
    
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
        private String tag;
        private String title;
        private String message;
        private String iconPath;
        private Urgency urgency = Urgency.NORMAL;
        private Duration timeout;
        private final java.util.List<Action> actions = new java.util.ArrayList<>();
        
        /**
         * Set a unique tag for this notification.
         * Notifications with the same tag will replace each other.
         * 
         * @param tag Unique identifier (e.g., "download", "build", "status")
         */
        public NotificationBuilder tag(String tag) {
            this.tag = tag;
            return this;
        }
        
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
        
        /**
         * Add an action button to the notification.
         * 
         * @param label    Button text (e.g., "Open", "Dismiss")
         * @param callback Runnable to execute when clicked (null for dismiss-only)
         */
        public NotificationBuilder action(String label, Runnable callback) {
            actions.add(new Action(label, callback));
            return this;
        }
        
        /**
         * Display the configured notification.
         * Uses tag if set, otherwise generates unique ID.
         */
        public void show() {
            String effectiveTag = (tag != null) ? tag : java.util.UUID.randomUUID().toString();
            if (actions.isEmpty()) {
                notifyTagged(effectiveTag, title, message, iconPath);
            } else {
                // Register callbacks and show with actions
                showWithActions(effectiveTag, title, message, iconPath, urgency, timeout, actions);
            }
        }
        
        private static native void showWithActions(String tag, String title, String message, 
                                                   String iconPath, Urgency urgency, Duration timeout,
                                                   java.util.List<Action> actions);
        
        private record Action(String label, Runnable callback) {}
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
