//
//  AppDelegate.h
//  iMacColorUnlocker
//
//  Created by Thomas Povinelli on 1/29/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : NSObject<NSApplicationDelegate>

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;

@end

NS_ASSUME_NONNULL_END
