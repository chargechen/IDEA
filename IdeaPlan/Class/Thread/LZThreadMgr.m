//
//  LZThreadMgr.m
//  LizhiFM
//
//  Created by wzsam on 3/17/14.
//  Copyright (c) 2014 yibasan. All rights reserved.
//

#import "LZThreadMgr.h"

static NSThread *globalThread = nil;
static NSThread *netSceneQueueThread = nil;

@implementation LZThreadMgr

#pragma mark- send scene thread------------------------------------------------------------

+ (NSThread *)threadForSceneQueue
{
	if (!netSceneQueueThread) {
		netSceneQueueThread = [[NSThread alloc] initWithTarget:self selector:@selector(runRequestScenes) object:nil];
		[netSceneQueueThread start];
	}
	return netSceneQueueThread;
}

+ (void)runRequestScenes
{
	// Should keep the runloop from exiting
	CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
	CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    BOOL runAlways = YES; // Introduced to cheat Static Analyzer
	while (runAlways) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		CFRunLoopRun();
		[pool release];
	}
    
	// Should never be called, but anyway
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	CFRelease(source);
}




#pragma mark- global thread-----------------------------
+ (NSThread *)threadForGlobal
{
	if (!globalThread) {
		globalThread = [[NSThread alloc] initWithTarget:self selector:@selector(runGlobalFunc) object:nil];
		[globalThread start];
	}
	return globalThread;
}

+ (void)runGlobalFunc
{
	// Should keep the runloop from exiting
	CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
	CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    BOOL runAlways = YES; // Introduced to cheat Static Analyzer
	while (runAlways) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		CFRunLoopRun();
		[pool release];
	}
    
	// Should never be called, but anyway
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	CFRelease(source);
}


@end
