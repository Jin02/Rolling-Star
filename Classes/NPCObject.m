//
//  Monster.m
//  Racing
//
//  Created by roden on 10. 7. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NPCObject.h"
#import "Game.h"
#import "Common.h"

@implementation NPCObject

//@synthesize Monster = _Monster;

-(id)initWithGame:(Game*)Scene Pos:(CGPoint)Pos Type:(NSInteger)Type
{
	if( (self = [super init]) )
	{
		_gameScene = Scene;
		_Type = Type;
		_isLive = YES;
		
		_ObjectDir = [[NSMutableArray alloc] initWithCapacity:oType_Item_3];
		[_ObjectDir addObject:@"Meteor_200.png"];
		[_ObjectDir addObject:@"Meteor_300.png"];
		[_ObjectDir addObject:@"Meteor_400.png"];
		
		[_ObjectDir addObject:@"Item_1.png"];
		[_ObjectDir addObject:@"Item_1.png"];
		[_ObjectDir addObject:@"Item_1.png"];
		
		[_ObjectDir addObject:@"ScalePlus.png"];
		[_ObjectDir addObject:@"ScaleMinus.png"];
		
		NSLog(@"%d", [_ObjectDir retainCount]);
		
		_ChangeSpeed = 0;

		[self CreateSprite:Pos];	
		
//		[self schedule:@selector(step)];
	}
	
	return self;
}

-(void)step
{
	[_Object setPosition:ccp(_Object.position.x,
							  _Object.position.y-2.f -_gameScene.Speed + _ChangeSpeed)];	
}

-(void)CreateSprite:(CGPoint)Pos
{
	_Object = [CCSprite spriteWithFile:[_ObjectDir objectAtIndex:_Type]];
	
//	float Scale = 2.5f;
	
//	if( [_ObjectDir objectAtIndex:_Type] != @"Me.png" )
	{
//		Scale = 1.5f;
		[_Object runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:3.5f angle:720.f]]];
	 }
		 
//	[_Object setScale:Scale];

	[_Object setPosition:Pos];
	
	[self addChild:_Object];
}

- (void)dealloc 
{
	NSLog(@"몹 해제");
	
	[_Object release];
	[self unschedule:@selector(step)];
	
	[self removeAllChildrenWithCleanup:YES];
    [super dealloc];
	
}

-(void)RemoveObject{
	
	id FadeOut = [CCFadeOut actionWithDuration:0.5f];
	id SpawnActions = [CCSpawn actions:[CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:1.5f],
										[CCScaleTo actionWithDuration:0.3f scale:0.5f],nil],
					   [CCFadeOut actionWithDuration:0.5f],nil];
	
	_isLive = NO;
	
	[self unschedule:@selector(step)];
	
	if( _Type > oType_NPC_3 )
		[_Object runAction:SpawnActions];
	else [_Object runAction:FadeOut];
}

-(CGPoint)GetPosition
{
	return _Object.position;
}

-(NSInteger)GetType
{
	return _Type;
}

-(CGSize)GetContentSize
{
	return _Object.contentSize;
}

-(CGRect)GetRect
{
	return _Object.textureRect;
}

-(BOOL)GetisLive
{
	return _isLive;
}

-(void)OriginSpeed
{
	_ChangeSpeed = 0.f;
}

-(void)SetChangeSpeedWithType:(NSInteger)Type
{		
	switch (Type) 
	{
		case oType_NPC_3:
		case oType_NPC:
		case oType_NPC_2:
			_ChangeSpeed = 1.5;
			break;
			
		case oType_Item_1:
		case oType_Item_2:
		case oType_Item_3:
			_ChangeSpeed = -Type * 2;
			break;
	}
	
	[self runAction:
	 [CCSequence actions:
	  [CCDelayTime actionWithDuration:Type+1],
	  [CCCallFunc actionWithTarget:self selector:@selector(OriginSpeed)],nil]];
}

-(float)GetScale
{
	NSLog(@"%f",_Object.textureRect.size.width);
	
	//어짜피 좌우가 동시에 증가 하기때문에 어느 한값만 넘겨도 상관이 없다.
	return _Object.scaleX;
}

@end
