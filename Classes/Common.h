//
//  Common.h
//  Racing
//
//  Created by roden on 10. 7. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject {

	BOOL			_isMultiPlay;
}

@property(readwrite)BOOL	isMultiPlay;

+(Common*) sharedCommon;
-(BOOL) RectCheckWithAx1:(float)ax1 ay1:(float)ay1 ax2:(float)ax2 ay2:(float)ay2 bx1:(float)bx1 by1:(float)by1 bx2:(float)bx2 by2:(float)by2;
-(unsigned long)timeGetTime;
-(BOOL)CircleCrashCheck_X:(float)x1 x2:(float)x2 y1:(float)y1 y2:(float)y2 r:(float)r r2:(float)r2;

@end
