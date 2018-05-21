//
//  Game.h
//  Racing
//
//  Created by roden on 10. 7. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Interface.h"

@class Interface;

 NSInteger		MeteorNum;
 NSInteger		BustNum;
 float			Moving;

enum
{
	sTag_BackGround,
	sTag_Interface
};

enum Ojbect_Type {
	oType_NPC,
	oType_NPC_2,
	oType_NPC_3,
	oType_Item_1,
	oType_Item_2,
	oType_Item_3,
	oType_Item_4,
	oType_Item_5
};

@interface Game : CCLayer {
	
	Interface			*_Interface;	

	NSMutableArray		*_NPCObjectArray;
	NSInteger			_Life;
	float				_Moving;
	
	BOOL				_FirstBigMeteor;
	
	unsigned long		_Timer;
	
	float				_Speed;
	
	ccVertex3F		_vAccelomation;
	
	NSInteger		_MeteorNum;
	NSInteger		_BustNum;
}

@property(readonly)ccVertex3F vAccelomation;
@property(readonly)unsigned long Timer;
@property(readwrite)float Speed;

+(id) scene;

@end
