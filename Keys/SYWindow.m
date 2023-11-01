//
//  SYWindow.m
//  Keys
//
//  Created by Stan Chevallier on 18/06/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import "SYWindow.h"
#import "SYKeyTools.h"

@interface SYWindow ()
@property (nonatomic, weak) IBOutlet NSTextField *label;
@property (nonatomic, strong) NSMutableOrderedSet <NSString *> *pressedKeys;
@property (nonatomic, strong) NSArray<NSNumber *> *modifiers;
@property (nonatomic, strong) id eventMonitor;
@end

@implementation SYWindow

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)aStyle
                            backing:(NSBackingStoreType)bufferingType
                              defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag];
    if (self)
    {
        self.pressedKeys = [[NSMutableOrderedSet alloc] init];
        
        NSEvent *(^handler)(NSEvent *) = ^NSEvent *(NSEvent *theEvent) {
            
            if (theEvent.window == self && (theEvent.type == NSEventTypeKeyUp || theEvent.type == NSEventTypeKeyDown))
            {
                [self processEvent:theEvent];
                return nil;
            }
            
            return theEvent;
        };
        
        self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:(NSEventMaskKeyUp|NSEventMaskKeyDown)
                                                                  handler:handler];
    }
    return self;
}

- (void)dealloc
{
    [NSEvent removeMonitor:self.eventMonitor];
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)flagsChanged:(NSEvent *)event
{
    self.modifiers = [SYKeyTools keysFromModifierFlags:event.modifierFlags];
    [self updateText];
    
    // NSLog(@"--> %@", NSStringFromNSUIntegerBinary(event.modifierFlags));
}

- (void)processEvent:(NSEvent *)event
{
    NSString *text = [SYKeyTools stringFromEvent:event];
    
    switch (event.type) {
        case NSEventTypeKeyDown:
            [self.pressedKeys addObject:text];
            break;
        case NSEventTypeKeyUp:
            [self.pressedKeys removeObject:text];
            break;
        default:
            break;
    }
    
    self.modifiers = [SYKeyTools keysFromModifierFlags:event.modifierFlags];
    [self updateText];
}

- (void)updateText
{
    NSArray <NSNumber *> *leftModifiers = [SYKeyTools modifierKeysInArray:self.modifiers fromLeft:YES];
    NSArray <NSString *> *leftStrings = [SYKeyTools stringsForKeys:leftModifiers];
    
    NSArray <NSNumber *> *rightModifiers = [SYKeyTools modifierKeysInArray:self.modifiers fromLeft:NO];
    NSArray <NSString *> *rightStrings = [SYKeyTools stringsForKeys:rightModifiers];
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObjectsFromArray:leftStrings];
    [items addObjectsFromArray:self.pressedKeys.array];
    [items addObjectsFromArray:rightStrings];
    [self.label setStringValue:[items componentsJoinedByString:@" "]];
}

@end

