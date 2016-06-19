//
//  SYAppDelegate.m
//  Keys
//
//  Created by Stan Chevallier on 18/06/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import "SYAppDelegate.h"

@interface SYAppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation SYAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.level |= NSStatusWindowLevel;
}

@end
