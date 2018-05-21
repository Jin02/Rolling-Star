//
//  NetWork.h
//  ProJect
//
//  Created by roden on 10. 5. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

//#import "MusicSelectString.h"

@interface NetWork : NSObject {

	GKSession				*_Session;
	
	BOOL					_isMultiPlay;
	BOOL					_isRecive;
	
	NSData					*_ReciveData;
}

@property(readwrite)BOOL	isMultiPlay;
@property(readwrite)BOOL	isRecive;
@property(nonatomic, retain)NSData *ReciveData;

+ (NetWork *) sharedNetWork;
+ (id)alloc;

- (void)SessionDisConnect;

-(void)FindButton;
-(void)mySendData:(NSData*)data;

@end
