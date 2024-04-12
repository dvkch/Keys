//
//  AppDelegate.swift
//  Keys
//
//  Created by syan on 12/04/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window?.level = .init((window?.level.rawValue ?? 0) | NSWindow.Level.statusBar.rawValue)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
