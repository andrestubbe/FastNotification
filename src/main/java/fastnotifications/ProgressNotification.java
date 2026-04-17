package fastnotifications;

/**
 * Represents a progress notification that can be updated.
 * 
 * Used for showing download progress, installation status, etc.
 */
public class ProgressNotification {
    
    private final long nativeHandle;
    
    ProgressNotification(long nativeHandle) {
        this.nativeHandle = nativeHandle;
    }
    
    /**
     * Update the progress percentage.
     * 
     * @param percent Progress from 0 to 100
     */
    public native void update(int percent);
    
    /**
     * Update progress with a new message.
     * 
     * @param percent Progress from 0 to 100
     * @param message New message to display
     */
    public native void update(int percent, String message);
    
    /**
     * Mark the progress as complete with a final message.
     * 
     * @param message Completion message
     */
    public native void complete(String message);
    
    /**
     * Dismiss/close the progress notification.
     */
    public native void dismiss();
}
