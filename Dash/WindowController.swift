import Cocoa
import CoreGraphics

class FullScreenWindow: NSWindow {
    override func constrainFrameRect(frameRect: NSRect, toScreen screen: NSScreen?) -> NSRect {
        return NSScreen.mainScreen()!.frame
        
    }
}

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        guard let window = window else { preconditionFailure() }
        window.setFrame(NSScreen.mainScreen()!.frame, display: true)
        window.backgroundColor = NSColor.clearColor()
        window.opaque = false
        window.level = NSInteger(CGWindowLevelForKey(.DesktopWindowLevelKey))
        window.ignoresMouseEvents = true
    }
}
