import Cocoa
import WebKit

private let defaultFileManager = NSFileManager.defaultManager()
private let supportDirectory = try! defaultFileManager
    .URLForDirectory(
        .ApplicationSupportDirectory,
        inDomain: .UserDomainMask,
        appropriateForURL: nil,
        create: true
    )
    .URLByAppendingPathComponent(NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as! String)
private let page = supportDirectory.URLByAppendingPathComponent("index.html")

class ViewController: NSViewController {

    @IBOutlet weak var webView: WebView!
    
    var fsWatcher: FSWatcher! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.drawsBackground = false
        fsWatcher = FSWatcher(paths: [supportDirectory.path!], cb: self.reload)
        reload()
    }
    
    private func reload() {
        try! defaultFileManager.createDirectoryAtURL(supportDirectory, withIntermediateDirectories: true, attributes: nil)
        if !defaultFileManager.fileExistsAtPath(page.path!) {
            NSApp.setActivationPolicy(.Regular)
            NSApp.activateIgnoringOtherApps(true)
            
            let alert = NSAlert()
            alert.messageText = "Missing index.html"
            alert.informativeText = "Dash needs a file called “index.html”."
            alert.addButtonWithTitle("Quit")
            alert.addButtonWithTitle("Show Folder")
            if alert.runModal() == NSAlertSecondButtonReturn {
                NSWorkspace.sharedWorkspace().openURL(supportDirectory)
            }
            NSApp.terminate(nil)
        }
        
        webView.mainFrame.loadRequest(NSURLRequest(URL: page))
    }
}

