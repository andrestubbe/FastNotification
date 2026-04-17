package fastnotifications;

import java.time.Duration;

/**
 * Demo class showing FastNotifications usage.
 */
public class Demo {
    
    public static void main(String[] args) throws Exception {
        System.out.println("FastNotifications Demo");
        System.out.println("======================\n");
        
        // Simple notification
        System.out.println("1. Sending simple notification...");
        FastNotifications.notify("Hello", "This is a native notification!");
        Thread.sleep(2000);
        
        // Notification with icon
        System.out.println("2. Sending notification with icon...");
        FastNotifications.notify(
            "Build Complete", 
            "Project compiled successfully",
            "icon.png"
        );
        Thread.sleep(2000);
        
        // Builder API
        System.out.println("3. Sending notification with builder...");
        FastNotifications.builder()
            .title("Download Complete")
            .message("File saved to Downloads")
            .urgency(FastNotifications.Urgency.NORMAL)
            .timeout(Duration.ofSeconds(5))
            .show();
        
        Thread.sleep(3000);
        System.out.println("\nDemo complete!");
    }
}
