import Foundation
import Cocoa
import SwiftUI

class SnapOverlay: NSWindow {
    var view = NSBox()
    
    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0), styleMask: .titled, backing: .buffered, defer: false)
        title = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String + "Overlay"
        level = .modalPanel
        alphaValue = 0
        
        isOpaque = false
        styleMask.insert(.fullSizeContentView)
        
        isReleasedWhenClosed = false
        ignoresMouseEvents = true
        hasShadow = false
        collectionBehavior.insert(.transient)
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        standardWindowButton(.toolbarButton)?.isHidden = true
        
        view.boxType = .custom
        colorUpdate()
        view.cornerRadius = 10
        view.wantsLayer = true
        contentView = view
    }
    
    override func orderFront(_ sender: Any?) {
        super.orderFront(sender)
        animator().alphaValue = SettingsData.shared.overlayAlpha.value / 100
    }
    
    override func orderOut(_ sender: Any?) {
        NSAnimationContext.runAnimationGroup { change in
            animator().alphaValue = 0.0
        } completionHandler: {
            super.orderOut(sender)
        }
    }
    
    func colorUpdate() {
        view.fillColor = NSColor(SettingsData.shared.overlayBackgroundColor.value)
        view.borderColor = NSColor(SettingsData.shared.overlayBorderColor.value)
    }
}
