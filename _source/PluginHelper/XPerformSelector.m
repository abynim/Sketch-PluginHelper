//
//  Created by vontio on 8/19/14.
//  Copyright (c) 2014 Vontio. All rights reserved.
//

#import <stdarg.h>
#import "XPerformSelector.h"

@implementation XPerformSelector
+(void) perform: (id)target selector:(SEL)selector
{
    [target performSelector:selector];
}

+(void) perform: (id)target selector:(SEL)selector withObject:(id)arg1
{
    [target performSelector:selector withObject:arg1];
}

+(void) perform: (id)target selector:(SEL)selector withObject:(id)arg1 withObject:(id)arg2
{
    [target performSelector:selector withObject:arg1 withObject:arg2];
    
}
+(void) perform: (id)target selector:(SEL)selector afterDelay:(NSTimeInterval)delay
{
    [target performSelector:selector withObject:nil afterDelay:delay];
}

+(void) perform: (id)target selector:(SEL)selector withObject:(id)arg1 afterDelay:(NSTimeInterval)delay
{
    [target performSelector:selector withObject:arg1 afterDelay:delay];
}
+(void) perform: (id)target selector:(SEL)selector count:(int)count,...;
{
    va_list args;
    va_start(args, count);
    NSMethodSignature *methodSig = [target methodSignatureForSelector: selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: methodSig];
    [invocation setSelector: selector];
    [invocation setTarget: target];
    
    //arguments start from 2
    for (int i=0; i<count; ++i) {
        id arg = va_arg(args, id);
        [invocation setArgument:&arg atIndex:i + 2];
    }
    [invocation invoke];
    va_end(args);
}

+(void) performInBackground: (id)target selector:(SEL)selector withObject:(id)arg1
{
    [target performSelectorInBackground:selector withObject:arg1];
}
+(void) performOnMainThread: (id)target selector:(SEL)selector withObject:(id)arg1 waitUntilDone:(BOOL)wait
{
    [target performSelectorOnMainThread:selector withObject:arg1 waitUntilDone:wait];
}
+(void) performOnMainThread: (id)target selector:(SEL)selector withObject:(id)arg1 waitUntilDone:(BOOL)wait modes:(NSArray*)modes
{
    [target performSelectorOnMainThread:selector withObject:arg1 waitUntilDone:wait modes:modes];
}

@end
