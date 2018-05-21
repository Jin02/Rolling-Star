//
//  Common.m
//  Racing
//
//  Created by roden on 10. 7. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import <sys/time.h>

@implementation Common

@synthesize isMultiPlay = _isMultiPlay;

static Common *_sharedCommon = nil;

+(Common*)sharedCommon
{
	@synchronized( [Common class] )
	{
		if( !_sharedCommon)
			[[self alloc] init];
		
		return _sharedCommon;
	}
	
	return nil;
}

+ (id) alloc{
	@synchronized([Common class]) {
		_sharedCommon = [super alloc];
		return _sharedCommon;
	}
    
	return nil;
}

-(BOOL) RectCheckWithAx1:(float)ax1 ay1:(float)ay1 
					 ax2:(float)ax2 ay2:(float)ay2 
					 bx1:(float)bx1 by1:(float)by1
					 bx2:(float)bx2 by2:(float)by2
{
	if (ay2 < by1) return NO; 
    if (ay1 > by2) return NO; 
    if (ax2 < bx1) return NO;  
    if (ax1 > bx2) return NO;   
	
	 return YES;
}

-(unsigned long)timeGetTime
{
	static struct timeval tv;
	static unsigned long time;
	gettimeofday(&tv, nil);
	
	time = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
	return time;
}

-(BOOL)CircleCrashCheck_X:(float)x1 x2:(float)x2 y1:(float)y1 y2:(float)y2 r:(float)r r2:(float)r2
{	
	return (pow(x2 - x1, 2) + pow(y2 - y1, 2) <= pow(r + r2, 2));
}



@end
