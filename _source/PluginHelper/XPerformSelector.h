//
//  Created by vontio on 8/19/14.
//  Copyright (c) 2014 Vontio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPerformSelector : NSObject

+(void) perform: (id)target selector:(SEL)selector;
+(void) perform: (id)target selector:(SEL)selector count:(int)count, ...;

+(void) perform: (id)target selector:(SEL)selector withObject:(id)arg1;
+(void) perform: (id)target selector:(SEL)selector withObject:(id)arg1 withObject:(id)arg2;

+(void) perform: (id)target selector:(SEL)selector afterDelay:(NSTimeInterval)delay;
+(void) perform: (id)target selector:(SEL)selector withObject:(id)arg1 afterDelay:(NSTimeInterval)delay;

+(void) performInBackground: (id)target selector:(SEL)selector withObject:(id)arg1;
+(void) performOnMainThread: (id)target selector:(SEL)selector withObject:(id)arg1 waitUntilDone:(BOOL)wait;
+(void) performOnMainThread: (id)target selector:(SEL)selector withObject:(id)arg1 waitUntilDone:(BOOL)wait modes:(NSArray*)modes;

@end
