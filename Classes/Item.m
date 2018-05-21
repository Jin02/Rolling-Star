//
//  Item.m
//  Racing
//
//  Created by roden on 10. 7. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
/*
#import "Item.h"



@implementation Item

@synthesize Item = _Item;

-(id)initWithGame:(Game*)Scene Pos:(CGPoint)Pos
{
	if( (self = [super init]) )
	{
		_gameScene = Scene;
		
		//[self CreateSprite];
		
		_Item = [CCSprite spriteWithFile:@"Item.png"];
		_Item.position = Pos;
		
		[_Item runAction:
		 [CCSpawn actions:
		  [CCMoveBy actionWithDuration:3.0f position:ccp(0,-500)],
		  [CCScaleTo actionWithDuration:3.0f scale:1.5f],nil]];
		
		[self addChild:_Item z:mTag_Item tag:mTag_Item];
		
		
		//		[self schedule:@selector(step)];
	}
	
	return self;
}

-(void)CreateSprite
{
}

- (void)dealloc {
	
	[self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}


@end
*/
