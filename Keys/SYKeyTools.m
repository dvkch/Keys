//
//  SYKeyTools.m
//  Keys
//
//  Created by Stan Chevallier on 18/06/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import "SYKeyTools.h"

NSString *keyIdentifierForCharCode(unichar charCode);

@implementation SYKeyTools

+ (NSArray<NSNumber *> *)keysFromModifierFlags:(NSEventModifierFlags)modifierFlags
{
    NSMutableArray <NSNumber *> *keys = [[NSMutableArray alloc] init];
    
    // Left/Right Control
    if (modifierFlags & (1L << 0))
        [keys addObject:@(SYModifierKeyLeftControl)];
    
    // Left Shift
    if (modifierFlags & (1L << 1))
        [keys addObject:@(SYModifierKeyLeftShift)];
    
    // Right Shift
    if (modifierFlags & (1L << 2))
        [keys addObject:@(SYModifierKeyRightShift)];
    
    // Left Command
    if (modifierFlags & (1L << 3))
        [keys addObject:@(SYModifierKeyLeftCommand)];
    
    // Right Command
    if (modifierFlags & (1L << 4))
        [keys addObject:@(SYModifierKeyRightCommand)];
    
    // Left Alt
    if (modifierFlags & (1L << 5))
        [keys addObject:@(SYModifierKeyLeftAlt)];
    
    // Right Alt
    if (modifierFlags & (1L << 6))
        [keys addObject:@(SYModifierKeyRightAlt)];

    // Fn
    if (modifierFlags & NSFunctionKeyMask)
        [keys addObject:@(SYModifierKeyFn)];

    if (modifierFlags & (1L << 16))
        [keys addObject:@(SYModifierKeyLeftCapsLock)];
    
    [keys sortUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return [keys copy];
}

+ (NSArray <NSNumber *> *)modifierKeysInArray:(NSArray <NSNumber *> *)keys fromLeft:(BOOL)fromLeft
{
    NSMutableArray <NSNumber *> *leftKeys = [NSMutableArray array];
    NSMutableArray <NSNumber *> *rightKeys = [NSMutableArray array];
    for (NSNumber *key in keys)
    {
        switch ((SYModifierKey)key.unsignedIntegerValue) {
            case SYModifierKeyLeftAlt:
            case SYModifierKeyLeftShift:
            case SYModifierKeyLeftControl:
            case SYModifierKeyLeftCommand:
            case SYModifierKeyLeftCapsLock:
                [leftKeys addObject:key];
                break;
            case SYModifierKeyRightAlt:
            case SYModifierKeyRightShift:
            case SYModifierKeyRightControl:
            case SYModifierKeyRightCommand:
                [rightKeys addObject:key];
                break;
            case SYModifierKeyFn:
                [leftKeys addObject:key];
                break;
        }
    }
    return [(fromLeft ? leftKeys : rightKeys) copy];
}

+ (NSArray <NSString *> *)stringsForKeys:(NSArray <NSNumber *> *)keys
{
    NSMutableArray <NSString *> *strings = [NSMutableArray array];
    for (NSNumber *key in keys)
    {
        switch ((SYModifierKey)key.unsignedIntegerValue) {
            case SYModifierKeyLeftAlt:
            case SYModifierKeyRightAlt:
                [strings addObject:@"⌥"];
                break;
            case SYModifierKeyLeftShift:
            case SYModifierKeyRightShift:
                [strings addObject:@"⇧"];
                break;
            case SYModifierKeyLeftControl:
            case SYModifierKeyRightControl:
                [strings addObject:@"⌃"];
                break;
            case SYModifierKeyLeftCommand:
            case SYModifierKeyRightCommand:
                [strings addObject:@"⌘"];
                break;
            case SYModifierKeyFn:
                [strings addObject:@"Fn"];
                break;
            case SYModifierKeyLeftCapsLock:
                [strings addObject:@"⇪"];
                break;
        }
    }

    return [strings copy];
}

+ (NSString *)stringFromEvent:(NSEvent *)event
{
    NSString *text = event.characters.uppercaseString;
    
    if ([event.characters characterAtIndex:0] >= 0xF700)
        text = keyIdentifierForCharCode([event.characters characterAtIndex:0]);

    if ([text isEqualToString:@" "])
        text = @"␣";
    
    if ([text isEqualToString:@"\t"])
        text = @"⇥";
    
    if ([text isEqualToString:@"\n"] || [text isEqualToString:@"\r"])
        text = @"↩︎";

    if (event.keyCode == 51)
        text = @"⌫";
    
    if (event.keyCode == 53)
        text = @"Esc";
    
    if (event.keyCode == 0x3 || event.keyCode == 0xA || event.keyCode == 0xD || event.keyCode == 0x24 || event.keyCode == 0x4C)
        text = @"↩︎";

    return text;
}

@end

NSString *NSStringFromNSUIntegerBinary(NSUInteger number)
{
    NSMutableString *str = [NSMutableString string];
    NSInteger numberCopy = number;
    for(NSInteger i = 0; i < 32 ; i++) {
        // Prepend "0" or "1", depending on the bit
        [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
        numberCopy >>= 1;
    }
    
    return [str copy];
}

// https://opensource.apple.com/source/WebCore/WebCore-1298/platform/mac/KeyEventMac.mm

/*
 static bool isKeypadEvent(NSEvent* event)
 {
 // Check that this is the type of event that has a keyCode.
 switch ([event type]) {
 case NSKeyDown:
 case NSKeyUp:
 case NSFlagsChanged:
 break;
 default:
 return false;
 }
 
 if ([event modifierFlags] & NSNumericPadKeyMask)
 return true;
 
 switch ([event keyCode]) {
 case 71: // Clear
 case 81: // =
 case 75: // /
 case 67: // *
 case 78: // -
 case 69: // +
 case 76: // Enter
 case 65: // .
 case 82: // 0
 case 83: // 1
 case 84: // 2
 case 85: // 3
 case 86: // 4
 case 87: // 5
 case 88: // 6
 case 89: // 7
 case 91: // 8
 case 92: // 9
 return true;
 }
 
 return false;
 }
 
 static inline BOOL isKeyUpEvent(NSEvent *event)
 {
 if ([event type] != NSFlagsChanged)
 return [event type] == NSKeyUp;
 // FIXME: This logic fails if the user presses both Shift keys at once, for example:
 // we treat releasing one of them as keyDown.
 switch ([event keyCode]) {
 case 54: // Right Command
 case 55: // Left Command
 return ([event modifierFlags] & NSCommandKeyMask) == 0;
 
 case 57: // Capslock
 return ([event modifierFlags] & NSAlphaShiftKeyMask) == 0;
 
 case 56: // Left Shift
 case 60: // Right Shift
 return ([event modifierFlags] & NSShiftKeyMask) == 0;
 
 case 58: // Left Alt
 case 61: // Right Alt
 return ([event modifierFlags] & NSAlternateKeyMask) == 0;
 
 case 59: // Left Ctrl
 case 62: // Right Ctrl
 return ([event modifierFlags] & NSControlKeyMask) == 0;
 
 case 63: // Function
 return ([event modifierFlags] & NSFunctionKeyMask) == 0;
 }
 return false;
 }
 */

NSString *keyIdentifierForCharCode(unichar charCode)
{
    // Each identifier listed in the DOM spec is listed here.
    // Many are simply commented out since they do not appear on standard Macintosh keyboards
    // or are on a key that doesn't have a corresponding character.
    
    switch (charCode) {
        case NSMenuFunctionKey:
            return @"Alt";
        case NSClearLineFunctionKey:
            return @"Clear";
        case NSDownArrowFunctionKey:
            return @"↓";
        case NSEndFunctionKey:
            return @"End";
        case NSExecuteFunctionKey:
            return @"Execute";
        case NSF1FunctionKey:
            return @"F1";
        case NSF2FunctionKey:
            return @"F2";
        case NSF3FunctionKey:
            return @"F3";
        case NSF4FunctionKey:
            return @"F4";
        case NSF5FunctionKey:
            return @"F5";
        case NSF6FunctionKey:
            return @"F6";
        case NSF7FunctionKey:
            return @"F7";
        case NSF8FunctionKey:
            return @"F8";
        case NSF9FunctionKey:
            return @"F9";
        case NSF10FunctionKey:
            return @"F10";
        case NSF11FunctionKey:
            return @"F11";
        case NSF12FunctionKey:
            return @"F12";
        case NSF13FunctionKey:
            return @"F13";
        case NSF14FunctionKey:
            return @"F14";
        case NSF15FunctionKey:
            return @"F15";
        case NSF16FunctionKey:
            return @"F16";
        case NSF17FunctionKey:
            return @"F17";
        case NSF18FunctionKey:
            return @"F18";
        case NSF19FunctionKey:
            return @"F19";
        case NSF20FunctionKey:
            return @"F20";
        case NSF21FunctionKey:
            return @"F21";
        case NSF22FunctionKey:
            return @"F22";
        case NSF23FunctionKey:
            return @"F23";
        case NSF24FunctionKey:
            return @"F24";
        case NSFindFunctionKey:
            return @"Find";
        case NSHelpFunctionKey:
            return @"Help";
        case NSHomeFunctionKey:
            return @"Home";
        case NSInsertFunctionKey:
            return @"Insert";
        case NSLeftArrowFunctionKey:
            return @"→";
        case NSModeSwitchFunctionKey:
            return @"ModeChange";
        case NSPageDownFunctionKey:
            return @"⇟";
        case NSPageUpFunctionKey:
            return @"⇞";
        case NSPauseFunctionKey:
            return @"Pause";
        case NSPrintScreenFunctionKey:
            return @"PrintScreen";
        case NSRightArrowFunctionKey:
            return @"←";
        case NSScrollLockFunctionKey:
            return @"Scroll";
        case NSSelectFunctionKey:
            return @"Select";
        case NSStopFunctionKey:
            return @"Stop";
        case NSUpArrowFunctionKey:
            return @"↑";
        case NSUndoFunctionKey:
            return @"Undo";
        case NSF25FunctionKey:
            return @"F25";
        case NSF26FunctionKey:
            return @"F26";
        case NSF27FunctionKey:
            return @"F27";
        case NSF28FunctionKey:
            return @"F28";
        case NSF29FunctionKey:
            return @"F29";
        case NSF30FunctionKey:
            return @"F30";
        case NSF31FunctionKey:
            return @"F31";
        case NSF32FunctionKey:
            return @"F32";
        case NSF33FunctionKey:
            return @"F33";
        case NSF34FunctionKey:
            return @"F34";
        case NSF35FunctionKey:
            return @"F35";
        case 0x7F:
            return @"U+0008"; // Standard says that DEL becomes U+007F.
        case NSDeleteFunctionKey:
            return @"DEL";
        case NSBackTabCharacter:
            return @"U+0009";
        case NSBeginFunctionKey:
        case NSBreakFunctionKey:
        case NSClearDisplayFunctionKey:
        case NSDeleteCharFunctionKey:
        case NSDeleteLineFunctionKey:
        case NSInsertCharFunctionKey:
        case NSInsertLineFunctionKey:
        case NSNextFunctionKey:
        case NSPrevFunctionKey:
        case NSPrintFunctionKey:
        case NSRedoFunctionKey:
        case NSResetFunctionKey:
        case NSSysReqFunctionKey:
        case NSSystemFunctionKey:
        case NSUserFunctionKey:
        default:
            return [NSString stringWithFormat:@"U+%04d", charCode];
    }
}
