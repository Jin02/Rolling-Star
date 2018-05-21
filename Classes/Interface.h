//
//  Interface.h
//  Racing
//
//  Created by roden on 10. 7. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Game.h"

@class Game;

enum
{
	iTag_Character,
	iTag_Font
};

@interface Interface : CCLayer {

	Game				*_gameScene;
	
	CCSprite			*_Character;
	CCLabel				*_SpeedLabel;
	
	CCSprite			*_BackGround;
	CCSprite			*_BackGround2;
	
	CCParticleSystem	*_rainParticle;
	CCParticleSystem	*_GalaxyParticle;
	CCParticleSystem	*_SunPartcle;
	CCParticleSystem	*_FlowerParticle;
	
	CCSprite			*_LifeString;
	CCSprite			*_LifeGageBar;
	
	CCSprite			*_BoostString;
	CCSprite			*_BoostGageBar;
	
	CCSprite			*_Ready;
	CCSprite			*_Go;
	
	CCSprite			*_LeftSide;
	CCSprite			*_RightSide;

	CCSprite			*_LeftSide2;
	CCSprite			*_RightSide2;

	
	CCSprite			*_GameOver;
	CCLabel				*_OtherScore;
	
	float				_ChangeSpeed;
	BOOL				_FirstRainParticle;
	
	NSInteger			_OtherPlayerScore;
	
	BOOL				_isSide;
}

@property(nonatomic, readonly)CCSprite *Character;
@property(nonatomic, retain)CCParticleSystem *Galxy;
@property(readwrite)BOOL FirstRainParticle;
@property(readwrite)NSInteger OtherPlayerScore;
@property(readonly)BOOL isSide;

-(id)initWithGame:(Game*)Scene;
-(void)CreateSprite;
-(void)CharacterRotateWithType:(NSInteger)Type;

-(void)ChangeSpeedWithType:(NSInteger)Type;
-(void)ChangeCharacterScale;

-(void)SideSee;

@end
