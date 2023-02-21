import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Set quit while window is minimized
        // return true
        return false
    }
    
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let channel = FlutterMethodChannel.init(name: "dipantau/channel", binaryMessenger: controller.engine.binaryMessenger)
        let eventChannel = FlutterEventChannel(name: "dipantau/event", binaryMessenger: controller.engine.binaryMessenger)
        
        channel.setMethodCallHandler({
            (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
            if ("quit_app" == call.method) {
                NSApp.terminate(self)
                result(true)
            } else if ("take_screenshot" == call.method) {
                let args: [String: Any] = call.arguments as! [String: Any]
                let path: String = args["path"] as! String
                self.takeScreenshots(folderName: path)
                result(true)
            }
        })
        
        eventChannel.setStreamHandler(self)
    }
    
    func takeScreenshots(folderName: String) {
        var displayCount: UInt32 = 0
        var result = CGGetActiveDisplayList(0, nil, &displayCount)
        if (result != CGError.success) {
            print("Error get active display list: \(result)")
            return
        }
        
        let allocated = Int(displayCount)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
        result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
        if (result != CGError.success) {
            print("Error get active display list 2: \(result)")
            return
        }
        
        for i in 1...displayCount {
            let unixTimestamp = createTimestamp()
            let fileUrl = URL(fileURLWithPath: folderName + "/\(unixTimestamp)" + "_" + "\(i)" + ".jpg", isDirectory: true)
            let screenshot:CGImage = CGDisplayCreateImage(activeDisplays[Int(i-1)])!
            let bitmapRep = NSBitmapImageRep(cgImage: screenshot)
            let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
            
            do {
                try jpegData.write(to: fileUrl, options: .atomic)
            } catch {
                print("Error in looping display count: \(error)")
            }
        }
    }
    
    func createTimestamp() -> Int32 {
        return Int32(Date().timeIntervalSince1970)
    }
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        setActivityListener()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    func setActivityListener() {
        NSEvent.addGlobalMonitorForEvents(matching: [NSEvent.EventTypeMask.keyDown, NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown, NSEvent.EventTypeMask.leftMouseDragged, NSEvent.EventTypeMask.rightMouseDragged], handler: {(event: NSEvent) in
            guard let eventSink = self.eventSink else {
                return
            }
            
            switch event.type {
            case .keyDown, .leftMouseDown, .rightMouseDown, .leftMouseDragged, .rightMouseDragged:
                // let strKeyCode = String(format: "key down \(event.characters)")
                // let strKeyCode = "key down \(event.characters as String?)"
                eventSink("triggered")
            default:
                break
            }
        })
    }
}
