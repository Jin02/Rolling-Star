//
//  Menu.m
//  Rolling Star
//
//  Created by Sunas on 10. 8. 7..
//  Copyright 2010 집. All rights reserved.
//

#import "Menu.h"
#import "Game.h"
#import "Ranking.h"
#import "NetWork.h"
#import "Common.h"
#import "how.h"

@implementation Menu

+(id) scene
{
	CCScene *scene = [CCScene node];		
	Menu *layer = [Menu node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		CCSprite *BackGround = [CCSprite spriteWithFile:@"BackGround.png"];
		BackGround.anchorPoint = CGPointZero;
		[self addChild:BackGround z:0 tag:0];
		
		_Star = [CCSprite spriteWithFile:@"MenuStar.png"];
		_Star.position = ccp(520, 180);
		[_Star runAction:[CCMoveTo actionWithDuration:2.0f position:ccp(140, 180)]];
		[_Star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1.0f angle:360.0f]]];
		
		[self addChild:_Star z:2 tag:1];
		
		_GalaxyParticle = [[CCParticleGalaxy alloc] initWithTotalParticles:30];
		_GalaxyParticle.scale = 3.f;
		_GalaxyParticle.gravity = ccp(480, 0);
		_GalaxyParticle.texture = [[CCTextureCache sharedTextureCache] addImage:@"Item_1.png"];

		[self addChild:_GalaxyParticle z:0 tag:2];
		
		_Title = [CCSprite spriteWithFile:@"Title.png"];
		_Title.position = ccp(280, 180);
		_Title.opacity  = 0;
		
		[self performSelector:@selector(TitleActions) withObject:nil afterDelay:2.1f];
		
		[self addChild:_Title z:3 tag:3];
		
		[self CreateMenu];
		
		[self schedule:@selector(Step)];
	}
	
	return self;
}

-(void)CreateMenu
{
	CCMenuItem	*Single = [CCMenuItemImage itemFromNormalImage:@"Single.png" 
												selectedImage:@"SingleClick.png" 
													   target:self 
													 selector:@selector(Single)];
	
	CCMenuItem	*Multi = [CCMenuItemImage itemFromNormalImage:@"Multi.png" 
												selectedImage:@"MultiClick.png" 
													   target:self 
													 selector:@selector(Multi)];
	
	//Multi.visible = NO;
	
	CCMenuItem	*Ranking = [CCMenuItemImage itemFromNormalImage:@"Ranking.png" 
												selectedImage:@"RankingClick.png" 
													   target:self 
													 selector:@selector(Ranking)];
	
	CCMenuItem	*How = [CCMenuItemImage itemFromNormalImage:@"How.png"
												 selectedImage:@"HowClick.png" 
														target:self 
													  selector:@selector(How)];
	
//	[How setVisible:NO];
	
	CCMenu *menu = [CCMenu menuWithItems:Single,Multi,Ranking,How,nil];
//	[menu alignItemsHorizontally];
	[menu alignItemsHorizontallyWithPadding:20.0f];
//	[menu setPosition:ccp(235,20)];
	[menu setOpacity:0];
	[menu setPosition:ccp(235, -50)];

	[menu runAction:
	 [CCSpawn actions:
	  [CCFadeIn actionWithDuration:2.0f],
	  [CCMoveTo actionWithDuration:1.0f position:ccp(235,40)],nil]];
	
	
	[self addChild:menu z:0 tag:5];
}

-(void)Single
{
	[[Common sharedCommon] setIsMultiPlay:NO];
	[[CCDirector sharedDirector] pushScene:[Game scene]];
}

-(void)Multi
{
	[[Common sharedCommon] setIsMultiPlay:YES];
	[[NetWork sharedNetWork] FindButton];
}

-(void)Ranking
{
	[[CCDirector sharedDirector] pushScene:[Ranking scene]];
}

-(void)How
{
	[[CCDirector sharedDirector] pushScene:[how scene]];
}

-(void)TitleActions
{
	[_Title runAction:[CCRepeatForever actionWithAction:
					  [CCSequence actionOne:[CCFadeIn actionWithDuration:1.0f] two:[CCFadeOut actionWithDuration:1.0f]]]];
}

-(void)Step
{
	[_GalaxyParticle setPosition:_Star.position];
	
	if( [[NetWork sharedNetWork] isMultiPlay] )	[[CCDirector sharedDirector] pushScene:[Game scene]];
}

-(void)dealloc
{
	[self unschedule:@selector(Step)];
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
