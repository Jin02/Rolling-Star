//
//  Interface.m
//  Racing
//
//  Created by roden on 10. 7. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Interface.h"
#import "Game.h"
#import "Common.h"
#import "CCGrid.h"
#import "NetWork.h"

@implementation Interface

@synthesize Character = _Character;
@synthesize Galxy = _GalaxyParticle;
@synthesize FirstRainParticle = _FirstRainParticle;
@synthesize OtherPlayerScore = _OtherPlayerScore;
@synthesize isSide = _isSide;

-(id)initWithGame:(Game*)Scene
{
	if( (self = [super init]) )
	{
		_gameScene			= Scene;
		_ChangeSpeed		= 0;
		_FirstRainParticle	= NO;
		
		_SpeedLabel = [[CCLabel alloc] initWithString:@"0" fontName:@"Marker Felt" fontSize:22];
		_SpeedLabel.position = ccp(60,300);
		[self addChild:_SpeedLabel z:10 tag:iTag_Font];
		
		[self CreateSprite];
		
		_rainParticle = [[CCParticleRain alloc] initWithTotalParticles:200];
		_rainParticle.texture = [[CCTextureCache sharedTextureCache] addImage:@"Star.png"];
		_rainParticle.visible = NO;
		[self addChild:_rainParticle z:10 tag:10];
		
		_GalaxyParticle = [[CCParticleGalaxy alloc] initWithTotalParticles:30];
		_GalaxyParticle.scale = 0.8f;
		_GalaxyParticle.texture = [[CCTextureCache sharedTextureCache] addImage:@"Item_1.png"];
		[self addChild:_GalaxyParticle z:0 tag:10];

		if( [[NetWork sharedNetWork] isMultiPlay] )
		{
			_OtherScore = [[CCLabel alloc] initWithString:@"Emeny Score : 0" fontName:@"Marker Felt" fontSize:22];
			[_OtherScore setPosition:ccp(70,270)];
			[self addChild:_OtherScore z:10];
		}
		
		[self schedule:@selector(step)];
		[self schedule:@selector(SpeedString) interval: 0.5f];
		
		_isSide = NO;
	}
	
	return self;
}

-(void)NetWorkSetString:(NSString*)str
{
	[_OtherScore setString:[NSString stringWithFormat:@"Emeny Score : %@",str]];
}

-(void)SpeedString
{
	NSString *str = [[NSString alloc]initWithFormat:@"%d km/s", (int)((int)(_gameScene.Speed * 100) - _ChangeSpeed*20) +5];
	[_SpeedLabel setString:str];
	[str release];
}

-(void)ResetRainParticle
{
	_rainParticle.visible = YES;
}

-(void)StopRainParticle
{
	[_rainParticle stopSystem];
}

-(void)FlowerParticleRemove
{
	[self removeChildByTag:12 cleanup:YES];
}

-(void)FlowerParticleNotSee
{
	[_FlowerParticle stopSystem];
	
	[self runAction:
	 [CCSequence actions:
	  [CCDelayTime actionWithDuration:2.0f],
	  [CCCallFunc actionWithTarget:self selector:@selector(FlowerParticleRemove)],nil]];
}

-(void)FlowerParticleSeeWithType:(NSInteger)Type
{
	_FlowerParticle = [[CCParticleFlower alloc] initWithTotalParticles:30];
	_FlowerParticle.texture = [[CCTextureCache sharedTextureCache] addImage:@"Item_1.png"];
	
	[self addChild:_FlowerParticle z:0 tag:12];
	
	[self runAction:
	 [CCSequence actions:
	  [CCDelayTime actionWithDuration:Type+1],
	  [CCCallFunc actionWithTarget:self selector:@selector(FlowerParticleNotSee)],nil]];
}

-(void)SunParticleRemove
{
	[self removeChildByTag:11 cleanup:YES];
}

-(void)LifeMinus
{
//	NSLog(@"%f", _LifeGageBar.scaleX);
	
	if( _LifeGageBar.scaleX <= 0.1 )
	{
		[_LifeGageBar runAction:[CCScaleTo actionWithDuration:1.0f scaleX:0.0f scaleY:1.f]];
		return;
	}

		[_LifeGageBar runAction:[CCScaleTo actionWithDuration:1.f scaleX:_LifeGageBar.scaleX-0.23f scaleY:1.0f]]; 
	
//	[_LifeGageBar setScaleX:0.08];
	   
//	[_LifeGageBar runAction:[CCScaleBy actionWithDuration:1.f scaleX:-0.333f scaleY:1.0f]];
}

-(void)SunParticleNotSee
{
	[_SunPartcle stopSystem];
	
	[self runAction:
	 [CCSequence actions:[CCDelayTime actionWithDuration:1.0f], 
	  [CCCallFunc actionWithTarget:self selector:@selector(SunParticleRemove)],nil]];
}

-(void)SunParticleSeeWithType:(NSInteger)Type
{
	_SunPartcle = [[CCParticleSun alloc] initWithTotalParticles:20];
	if( Type == oType_NPC_2) {_SunPartcle.scale = 2.f;}
	else if( Type == oType_NPC_3 ) {_SunPartcle.scale = 3.f;}
	else _SunPartcle.scale = 1.5f;

	_SunPartcle.texture = [[CCTextureCache sharedTextureCache] addImage:@"Item_1.png"];
	[self addChild:_SunPartcle z:10 tag:11];
	
//	[_SunPartcle stopSystem];
	
	[self runAction:
	 [CCSequence actions:
	 [CCDelayTime actionWithDuration:1.0f],
	  [CCCallFunc actionWithTarget:self selector:@selector(SunParticleNotSee)],nil]];
}

-(void)step
{
	float PosX = _Character.position.x - (_gameScene.vAccelomation.y*13);
	float PosY = _Character.position.y + (_gameScene.vAccelomation.x*13);
	
	if( PosY <= 20 )
		PosY = 20;
	
	if( PosY + _Character.textureRect.size.width >= 320 )
		PosY = 320-_Character.textureRect.size.width;
	
	if( _isSide == YES )
	{		
		if( PosX <= 60 )
		{
			PosX = 60;
		}
		
		if( PosX+_Character.textureRect.size.width >= 420 )
		{
			PosX = 420-_Character.textureRect.size.width;
		}
	}
	
	else
	{
		if( PosX <= 0)
			PosX = 0;
		
		if( PosX+_Character.textureRect.size.width >= 480 )
			PosX = 480-_Character.textureRect.size.width;
	}
	
//	NSString *str = [[NSString alloc] initWithFormat:@"%d km/s", (int)((int)(_gameScene.Speed * 100) - _ChangeSpeed*20) +5 ];
//	[str release];

	[_Character setPosition:ccp(PosX, PosY)];
	[_GalaxyParticle setPosition:ccp(PosX, PosY)];
	[_SunPartcle setPosition:ccp(PosX, PosY)];
	[_FlowerParticle setPosition:ccp(PosX, PosY)];
	[_FlowerParticle setGravity:_GalaxyParticle.gravity];
	
	[_BackGround  setPosition: ccp( 0, _BackGround.position.y - _gameScene.Speed - 2.f  + _ChangeSpeed)];

	[_LeftSide setPosition:ccp(_LeftSide.position.x, _BackGround.position.y - _gameScene.Speed - 2.f + _ChangeSpeed)];
	
	if( _BackGround.position.y <= -319 )
		[_BackGround setPosition:ccp(0, 0)];
	
	if( _LeftSide.position.y <= -319 )
		[_LeftSide setPosition:ccp(_LeftSide.position.x, 0)];
}

-(void)originSpeed
{
	_ChangeSpeed = 0.f;
	[_BoostString runAction:[CCFadeOut actionWithDuration:0.5f]];
	[_BoostGageBar runAction:[CCFadeOut actionWithDuration:0.5f]];
}

-(void)ChangeSpeedWithType:(NSInteger)Type
{
	id BoostGage = [CCSpawn actions:
					[CCFadeIn actionWithDuration:0.5f],
					[CCScaleTo actionWithDuration:Type+1 scaleX:0 scaleY:1.f],
					nil];
	
	id Speed     = [CCSequence actions:
					[CCDelayTime actionWithDuration:Type+1],
					[CCCallFunc actionWithTarget:self selector:@selector(originSpeed)],nil];
	
	
	if( _ChangeSpeed )
		return;
		
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
		{
			_ChangeSpeed = -Type * 2;
			
			_BoostGageBar.scaleX = 1.f;
			
			[_BoostGageBar runAction:BoostGage];
			
			[_BoostString runAction:[CCFadeIn actionWithDuration:0.5f]];
		}
		break;
	}
	
	[self runAction: Speed];
}

-(void)CreateSprite
{	
	_BackGround = [[CCSprite alloc] initWithFile:@"BackGround.png"];
	_BackGround.anchorPoint = CGPointZero;
	_BackGround.position = ccp(0,0);
	[self addChild:_BackGround z:0 tag:1];
	
	_BackGround2 = [[CCSprite alloc] initWithTexture:_BackGround.texture];
	_BackGround2.position = ccp(0,319);
	_BackGround2.anchorPoint = CGPointZero;
	[_BackGround addChild:_BackGround2 z:0 tag:2];
	
	_Character = [[CCSprite alloc] initWithFile:@"Star.png"];
	_Character.position		= ccp(160,40);
	
	[_Character runAction:
	 [CCRepeatForever actionWithAction:
	  [CCRotateTo actionWithDuration:0.5f angle:720]]];
	 
	[self addChild:_Character z:iTag_Character+2. tag:iTag_Character+2];

	_LifeString = [[CCSprite alloc] initWithFile:@"life.png"];
	_LifeString.anchorPoint = CGPointZero;
	_LifeString.position = ccp(300, 300);
	
	[self addChild:_LifeString z:0 tag:3];
	
	_LifeGageBar = [[CCSprite alloc] initWithFile:@"LifeGageBar.png"];
	_LifeGageBar.anchorPoint = CGPointZero;
	_LifeGageBar.position = ccp(330, 300);
	
	[self addChild:_LifeGageBar z:3 tag:3];
	
	_BoostString = [[CCSprite alloc] initWithFile:@"booster.png"];
	_BoostString.anchorPoint = CGPointZero;
	_BoostString.position = ccp(270, 272);
	_BoostString.opacity = 0;
	
	[self addChild:_BoostString z:3 tag:4];
	
	_BoostGageBar = [[CCSprite alloc] initWithFile:@"BoostGageBar.png"];
	_BoostGageBar.anchorPoint = CGPointZero;
	_BoostGageBar.position = ccp(330,270);
	_BoostGageBar.opacity = 0;
	
	[self addChild:_BoostGageBar z:3 tag:4];
	
	_Ready		  = [[CCSprite alloc] initWithFile:@"ready.png"];
	_Ready.opacity = 0;
	_Ready.position = ccp(240, 200);
	
	[self addChild:_Ready z:0 tag:5];
	
	_Go		  = [[CCSprite alloc] initWithFile:@"go.png"];
	_Go.opacity = 0;
	_Go.position = ccp(240, 200);
	
	[self addChild:_Go z:0 tag:5];
	
	[_Ready runAction:
	 [CCSequence actions:[CCFadeIn actionWithDuration:1.f],[CCFadeOut actionWithDuration:1.f],nil]];
	[_Go	runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.f], 
					   [CCFadeIn actionWithDuration:1.f],
					   [CCFadeOut actionWithDuration:1.f],
						nil]];
	
	_GameOver = [[CCSprite alloc] initWithFile:@"GameOver.png"];
	_GameOver.position = ccp(240, 420);
	_GameOver.visible = NO;
	[self addChild:_GameOver z:20 tag:20];
	
	_LeftSide = [[CCSprite alloc] initWithFile:@"LeftSide.png"];
	_LeftSide.position = ccp(-60-60, 0);
	_LeftSide.anchorPoint = ccp(0, 0.f);
	[self addChild:_LeftSide z:0 tag:11];
	
	_LeftSide2 = [[CCSprite alloc] initWithTexture:_LeftSide.texture];
	_LeftSide2.position = ccp(-60, 320);
	_LeftSide2.anchorPoint = ccp(0, 0.f);
	[_LeftSide addChild:_LeftSide2 z:0 tag:11];
	
	_RightSide = [[CCSprite alloc] initWithFile:@"RightSide.png"];
	_RightSide.position = ccp(480+60+60+60, 0);
	_RightSide.anchorPoint = ccp(1.0, 0.f);
	[_LeftSide addChild:_RightSide z:0 tag:11];
	
	_RightSide2 = [[CCSprite alloc] initWithTexture:_RightSide.texture];
	_RightSide2.position = ccp(480+60+60+60, 320);
	_RightSide2.anchorPoint = ccp(1.0, 0.f);
	[_LeftSide addChild:_RightSide2 z:0 tag:11];
	
//	_RightSide = [[CCSprite alloc] initWithFile:@"RightSide.png"];
//	_RightSide.position = ccp( 480, 0);
//	_RightSide.anchorPoint = ccp(1, 0.f);
//	[self addChild:_RightSide z:5 tag:22];
//	
//	_RightSide2 = [[CCSprite alloc] initWithTexture:_RightSide.texture];
//	_RightSide2.position = ccp( 480, 320);
//	_RightSide2.anchorPoint = ccp(1, 0.f);
//	[_RightSide addChild:_RightSide2 z:0 tag:22];

	
//	[_LeftSide setVisible:NO];
//	[_RightSide2 setVisible:NO];
//	[_RightSide setVisible:NO];
//	[_LeftSide2 setVisible:NO];
	
//	[self schedule:@selector(SideSee)];
}

-(void)SideSee
{
	[_RightSide runAction:[CCMoveBy actionWithDuration:1.0f position:ccp(-120-60,0)]];
	[_RightSide2 runAction:[CCMoveBy actionWithDuration:1.0f position:ccp(-120-60,0)]];
	
	[_LeftSide runAction:[CCMoveBy actionWithDuration:1.0f position:ccp(120,0)]];
	[_LeftSide2 runAction:[CCMoveBy actionWithDuration:0.5f position:ccp(60,0)]];
	
	_isSide = YES;
}

-(void)GameOverSee
{
	_GameOver.visible = YES;
	[_GameOver runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(240,180)]];
}

-(void)CharacterOriginActions
{
	[_Character stopAllActions];
	
	[_Character runAction:
	 [CCRepeatForever actionWithAction:
	  [CCRotateTo actionWithDuration:0.5f angle:720]]];
}

-(void)CharacterRotateWithType:(NSInteger)Type
{
	float SpeedValue = 0.f;
	
	[_Character stopAllActions];
	
	if( Type <= oType_NPC_3 )
		SpeedValue = 5.0f;
	else
		SpeedValue = -0.1f;
	
	[_Character runAction:
	 [CCRepeatForever actionWithAction:
		  [CCRotateBy actionWithDuration: SpeedValue + 0.5f angle:720]]];	
	
	[self runAction:
	 [CCSequence actions:
	  [CCDelayTime actionWithDuration:1.0f],
	  [CCCallFunc actionWithTarget:self selector:@selector(CharacterOriginActions)],nil]];
}

-(void)ChangeCharacterOriginScale
{
	_Character.scale = 1.f;
}

-(void)ChangeCharacterScaleWithType:(NSInteger)Type
{
	NSInteger Time;
	
	if( Type <= oType_Item_3 )
	{
		_Character.scale = 0.8f;
		Time = Type+1;
	}
	else
		Time = 2;

	if( Type == oType_Item_5 )
		_Character.scale = 0.5f;
	
	if( Type == oType_Item_4 )
		_Character.scale = 1.5f;
	
	
	[self performSelector:@selector(ChangeCharacterOriginScale) withObject:nil afterDelay:Time];
}

- (void)dealloc {
	
	[self unschedule:@selector(SpeedString)];
	[self unschedule:@selector(step)];
	
	[_BackGround removeAllChildrenWithCleanup:YES];
	[self removeAllChildrenWithCleanup:YES];
    
	[super dealloc];
}


@end
