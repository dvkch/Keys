//
//  Window.swift
//  Keys
//
//  Created by syan on 13/04/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import Cocoa

class Window: NSWindow {
    
    // MARK: Init
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        setup()
    }
    
    private func setup() {
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyUp, .keyDown]) { [weak self] event in
            if event.window == self && (event.type == .keyUp || event.type == .keyDown) {
                self?.processEvent(event)
                return nil
            }
            return event
        }
    }
    
    deinit {
        if let eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }
    
    // MARK: Properties
    @IBOutlet private var label: NSTextField!
    private var pressedKeys: [String] = []
    private var pressedModifiers: [ModifierKey] = []
    private var eventMonitor: Any?
    
    // MARK: Actions
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func flagsChanged(with event: NSEvent) {
        pressedModifiers = event.modifierKeys
        updateContent()
    }
    
    private func processEvent(_ event: NSEvent) {
        let key = event.keyString
        switch event.type {
        case .keyDown:
            if !pressedKeys.contains(key) {
                pressedKeys.append(key)
            }
            
        case .keyUp:
            pressedKeys.removeAll(where: { $0 == key })
            
        default:
            break
        }
        pressedModifiers = event.modifierKeys
        updateContent()
    }
    
    // MARK: Content
    private func updateContent() {
        let leftModifiers = pressedModifiers.filter({ $0.side == .left }).sorted().map(\.name).joined()
        let rightModifiers = pressedModifiers.filter({ $0.side == .right }).sorted().map(\.name).joined()
        label.stringValue = leftModifiers + pressedKeys.joined() + rightModifiers
    }
}
