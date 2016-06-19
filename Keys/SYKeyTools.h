//
//  SYKeyTools.h
//  Keys
//
//  Created by Stan Chevallier on 18/06/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import <AppKit/AppKit.h>

NSString *NSStringFromNSUIntegerBinary(NSUInteger number);

typedef enum : NSUInteger {
    SYModifierKeyFn,
    SYModifierKeyLeftCapsLock,
    SYModifierKeyLeftShift,
    SYModifierKeyLeftControl,
    SYModifierKeyLeftAlt,
    SYModifierKeyLeftCommand,
    SYModifierKeyRightCommand,
    SYModifierKeyRightAlt,
    SYModifierKeyRightControl,
    SYModifierKeyRightShift,
} SYModifierKey;

@interface SYKeyTools : NSObject

+ (NSArray <NSNumber *> *)keysFromModifierFlags:(NSEventModifierFlags)modifierFlags;

+ (NSArray <NSNumber *> *)modifierKeysInArray:(NSArray <NSNumber *> *)keys fromLeft:(BOOL)fromLeft;

+ (NSArray <NSString *> *)stringsForKeys:(NSArray <NSNumber *> *)keys;

+ (NSString *)stringFromEvent:(NSEvent *)event;

@end
