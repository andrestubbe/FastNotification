package fastnotifications.integrations;

import fastnotifications.FastNotifications;

/**
 * Debug notification integration for FastRobot.
 * 
 * Shows real-time toast notifications for bot actions:
 * - Mouse clicks
 * - Key presses
 * - Screen captures
 * - Process detection
 * 
 * Usage:
 * <pre>
 * FastRobot robot = new FastRobot();
 * FastRobotDebug.enable(robot);  // Enable debug notifications
 * </pre>
 * 
 * @author Andre Stubbe
 * @version 1.0.0-alpha
 */
public class FastRobotDebug {
    
    private static final String TAG_STATUS = "fastrobot.status";
    private static final String TAG_CLICK = "fastrobot.click";
    private static final String TAG_KEY = "fastrobot.key";
    
    private static boolean enabled = false;
    private static int clickCount = 0;
    private static int keyCount = 0;
    private static long startTime;
    
    /**
     * Enable debug notifications for FastRobot.
     * Shows toast on every major action.
     */
    public static void enable() {
        if (enabled) return;
        enabled = true;
        startTime = System.currentTimeMillis();
        
        FastNotifications.notify(TAG_STATUS, "FastRobot Debug", "Debug mode enabled - watching bot actions");
    }
    
    /**
     * Disable debug notifications.
     */
    public static void disable() {
        enabled = false;
        FastNotifications.notify(TAG_STATUS, "FastRobot Debug", "Debug mode disabled");
    }
    
    /**
     * Report a mouse click action.
     * Call this from FastRobot.mousePress()/mouseClick()
     * 
     * @param x X coordinate
     * @param y Y coordinate
     * @param button Button number (1=left, 2=right, 3=middle)
     */
    public static void reportClick(int x, int y, int button) {
        if (!enabled) return;
        
        clickCount++;
        String buttonName = switch (button) {
            case 1 -> "Left";
            case 2 -> "Right";
            case 3 -> "Middle";
            default -> "Button " + button;
        };
        
        FastNotifications.builder()
            .tag(TAG_CLICK)
            .title("🖱️ Click #" + clickCount)
            .message(buttonName + " click at (" + x + ", " + y + ")")
            .urgency(FastNotifications.Urgency.LOW)
            .timeout(java.time.Duration.ofSeconds(2))
            .show();
    }
    
    /**
     * Report a key press action.
     * Call this from FastRobot.keyPress()
     * 
     * @param keyCode Java KeyEvent key code
     * @param keyText Human-readable key name
     */
    public static void reportKeyPress(int keyCode, String keyText) {
        if (!enabled) return;
        
        keyCount++;
        
        FastNotifications.builder()
            .tag(TAG_KEY)
            .title("⌨️ Key #" + keyCount)
            .message("Pressed: " + keyText)
            .urgency(FastNotifications.Urgency.LOW)
            .timeout(java.time.Duration.ofSeconds(2))
            .show();
    }
    
    /**
     * Report screen capture action.
     * Call this from FastRobot.createScreenCapture()
     * 
     * @param width Capture width
     * @param height Capture height
     * @param durationMs Capture duration in milliseconds
     */
    public static void reportScreenCapture(int width, int height, long durationMs) {
        if (!enabled) return;
        
        FastNotifications.notify(
            "fastrobot.capture",
            "📸 Screen Capture",
            width + "x" + height + " in " + durationMs + "ms"
        );
    }
    
    /**
     * Report process detection.
     * Call this from FastProcessWatch callbacks
     * 
     * @param processName Detected process name
     * @param started true if started, false if stopped
     */
    public static void reportProcess(String processName, boolean started) {
        if (!enabled) return;
        
        String action = started ? "started" : "stopped";
        FastNotifications.Urgency urgency = started 
            ? FastNotifications.Urgency.NORMAL 
            : FastNotifications.Urgency.LOW;
        
        FastNotifications.builder()
            .tag("fastrobot.process." + processName)
            .title("⚙️ Process " + action)
            .message(processName)
            .urgency(urgency)
            .show();
    }
    
    /**
     * Show session summary when bot finishes.
     */
    public static void showSummary() {
        if (!enabled) return;
        
        long duration = System.currentTimeMillis() - startTime;
        String durationText = String.format("%d:%02d", duration / 60000, (duration % 60000) / 1000);
        
        FastNotifications.builder()
            .tag(TAG_STATUS)
            .title("✅ Session Complete")
            .message(clickCount + " clicks, " + keyCount + " keys in " + durationText)
            .urgency(FastNotifications.Urgency.NORMAL)
            .action("View Log", () -> System.out.println("Opening log..."))
            .show();
    }
    
    /**
     * Check if debug mode is enabled.
     * 
     * @return true if debug notifications are active
     */
    public static boolean isEnabled() {
        return enabled;
    }
    
    /**
     * Reset counters.
     */
    public static void reset() {
        clickCount = 0;
        keyCount = 0;
        startTime = System.currentTimeMillis();
    }
}
