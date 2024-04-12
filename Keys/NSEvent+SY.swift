//
//  NSEvent+SY.swift
//  Keys
//
//  Created by syan on 13/04/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import Cocoa

enum ModifierKey: Int {
    case fn
    case leftCapsLock
    case leftShift
    case leftControl
    case leftAlt
    case leftCommand
    case rightCommand
    case rightAlt
    case rightControl
    case rightShift
    
    var name: String {
        switch self {
        case .leftAlt, .rightAlt:           return "⌥"
        case .leftShift, .rightShift:       return "⇧"
        case .leftControl, .rightControl:   return "⌃"
        case .leftCommand, .rightCommand:   return "⌘"
        case .fn:                           return "Fn"
        case .leftCapsLock:                 return "⇪"
        }
    }
    
    enum Side {
        case left, right
    }
    var side: Side {
        switch self {
        case .fn:           return .left
        case .leftCapsLock: return .left
        case .leftShift:    return .left
        case .leftControl:  return .left
        case .leftAlt:      return .left
        case .leftCommand:  return .left
        case .rightCommand: return .right
        case .rightAlt:     return .right
        case .rightControl: return .right
        case .rightShift:   return .right
        }
    }
}

extension ModifierKey: Comparable {
    static func < (lhs: ModifierKey, rhs: ModifierKey) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension NSEvent {
    var modifierKeys: [ModifierKey] {
        var keys = [ModifierKey]()
        
        // Left/Right Control
        if ((modifierFlags.rawValue & (1 << 0)) != 0) {
            keys.append(.leftControl)
        }
        
        // Left Shift
        if ((modifierFlags.rawValue & (1 << 1)) != 0) {
            keys.append(.leftShift)
        }
        
        // Right Shift
        if ((modifierFlags.rawValue & (1 << 2)) != 0) {
            keys.append(.rightShift)
        }
        
        // Left Command
        if ((modifierFlags.rawValue & (1 << 3)) != 0) {
            keys.append(.leftCommand)
        }
        
        // Right Command
        if ((modifierFlags.rawValue & (1 << 4)) != 0) {
            keys.append(.rightCommand)
        }
        
        // Left Alt
        if ((modifierFlags.rawValue & (1 << 5)) != 0) {
            keys.append(.leftAlt)
        }
        
        // Right Alt
        if ((modifierFlags.rawValue & (1 << 6)) != 0) {
            keys.append(.rightAlt)
        }
        
        // Fn
        if modifierFlags.contains(.function) {
            keys.append(.fn)
        }
        
        if ((modifierFlags.rawValue & (1 << 16)) != 0) {
            keys.append(.leftCapsLock)
        }
        
        return keys
    }
    
    var keyString: String {
        if keyCode == 51 {
            return "⌫"
        }
        if keyCode == 53 {
            return "Esc"
        }
        if [0x3, 0xA, 0xD, 0x24, 0x4C].contains(keyCode) {
            return "↩︎"
        }
        
        let string = characters?.uppercased() ?? ""

        // https://developer.apple.com/documentation/appkit/nsevent/1535851-function-key_unicode_values
        if (0xF700...0xF8FF).contains(string.utf16.first ?? 0) {
            return NSEvent.keyIdentifier(for: Int(string.utf16.first ?? 0))
        }
        
        if string == " " {
            return "␣"
        }
        if string == "\t" {
            return "⇥"
        }
        if string == "\n" || string == "\r" {
            return "↩︎"
        }
        return string
    }
    
    private static func keyIdentifier(for charCode: Int) -> String {
        // https://opensource.apple.com/source/WebCore/WebCore-1298/platform/mac/KeyEventMac.mm
        let keys: [Int: String] = [
            NSMenuFunctionKey:          "Alt",
            NSClearLineFunctionKey:     "Clear",
            NSDownArrowFunctionKey:     "↓",
            NSEndFunctionKey:           "End",
            NSExecuteFunctionKey:       "Execute",
            NSF1FunctionKey:            "F1",
            NSF2FunctionKey:            "F2",
            NSF3FunctionKey:            "F3",
            NSF4FunctionKey:            "F4",
            NSF5FunctionKey:            "F5",
            NSF6FunctionKey:            "F6",
            NSF7FunctionKey:            "F7",
            NSF8FunctionKey:            "F8",
            NSF9FunctionKey:            "F9",
            NSF10FunctionKey:           "F10",
            NSF11FunctionKey:           "F11",
            NSF12FunctionKey:           "F12",
            NSF13FunctionKey:           "F13",
            NSF14FunctionKey:           "F14",
            NSF15FunctionKey:           "F15",
            NSF16FunctionKey:           "F16",
            NSF17FunctionKey:           "F17",
            NSF18FunctionKey:           "F18",
            NSF19FunctionKey:           "F19",
            NSF20FunctionKey:           "F20",
            NSF21FunctionKey:           "F21",
            NSF22FunctionKey:           "F22",
            NSF23FunctionKey:           "F23",
            NSF24FunctionKey:           "F24",
            NSFindFunctionKey:          "Find",
            NSHelpFunctionKey:          "Help",
            NSHomeFunctionKey:          "Home",
            NSInsertFunctionKey:        "Insert",
            NSLeftArrowFunctionKey:     "→",
            NSModeSwitchFunctionKey:    "ModeChange",
            NSPageDownFunctionKey:      "⇟",
            NSPageUpFunctionKey:        "⇞",
            NSPauseFunctionKey:         "Pause",
            NSPrintScreenFunctionKey:   "PrintScreen",
            NSRightArrowFunctionKey:    "←",
            NSScrollLockFunctionKey:    "Scroll",
            NSSelectFunctionKey:        "Select",
            NSStopFunctionKey:          "Stop",
            NSUpArrowFunctionKey:       "↑",
            NSUndoFunctionKey:          "Undo",
            NSF25FunctionKey:           "F25",
            NSF26FunctionKey:           "F26",
            NSF27FunctionKey:           "F27",
            NSF28FunctionKey:           "F28",
            NSF29FunctionKey:           "F29",
            NSF30FunctionKey:           "F30",
            NSF31FunctionKey:           "F31",
            NSF32FunctionKey:           "F32",
            NSF33FunctionKey:           "F33",
            NSF34FunctionKey:           "F34",
            NSF35FunctionKey:           "F35",
            0x7F:                       "U+0008", // Standard says that DEL becomes U+007F
            NSDeleteFunctionKey:        "DEL",
            NSBackTabCharacter:         "U+0009",
        ]
        return keys[charCode] ?? String(format: "U+%04d", charCode)
    }
}
