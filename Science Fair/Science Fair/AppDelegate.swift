//
//  AppDelegate.swift
//  Science Fair
//
//  Created by Alex H on 2/13/20.
//  Copyright © 2020 Holy Spirit High School. All rights reserved.
//


import Cocoa //The base framework

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func emission(_ sender: NSMenuItem) {
        var state : Bool
        switch sender.state {
        case .on :
            sender.state = .off
            state = false
        case .off:
            sender.state = .on
            state = true
        default: return
        }
        UserDefaults.standard.set(state, forKey: "emission")
    }
    @IBAction func exclusion(_ sender: NSMenuItem) {
           var state : Bool
           switch sender.state {
           case .on :
               sender.state = .off
               state = false
           case .off:
               sender.state = .on
               state = true
           default: return
           }
           UserDefaults.standard.set(state, forKey: "exclusion")
    }
    @IBAction func absorption(_ sender: NSMenuItem) {
           var state : Bool
           switch sender.state {
           case .on :
               sender.state = .off
               state = false
           case .off:
               sender.state = .on
               state = true
           default: return
           }
           UserDefaults.standard.set(state, forKey: "absorption")
    }
    
    @IBAction func play(_ sender: NSMenuItem) {
        var state : Bool
        switch sender.state {
        case .on :
            sender.state = .off
            state = false
        case .off:
            sender.state = .on
            state = true
        default: return
        }
        UserDefaults.standard.set(state, forKey: "paused")
    }
    
}
