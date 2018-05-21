//
//  Monster.h
//  Racing
//#import "Game.h"
//  Created by roden on 10. 7. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class Game;

@interface NPCObject : CCLayer {
	
	Game			*_gameScene;
	BOOL			_isLive;
	
	NSMutableArray	*_ObjectDir;
	NSInteger		_Type;
	
	float			_ChangeSpeed;
	CCSprite		*_Object;
}

//@property(nonatomic, retain)CCSprite		*Monster;

-(id)initWithGame:(Game*)Scene Pos:(CGPoint)Pos Type:(NSInteger)Type;
-(void)CreateSprite:(CGPoint)Pos;
-(void)RemoveObject;
-(void)SetChangeSpeedWithType:(NSInteger)Type;

-(float)GetScale;
-(NSInteger)GetType;
-(CGPoint)GetPosition;
-(CGRect)GetRect;
-(CGSize)GetContentSize;
-(BOOL)GetisLive;

-(void)step;

@end
