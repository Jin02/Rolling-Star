//
//  how.m
//  Rolling Star
//
//  Created by Sunas on 10. 10. 5..
//  Copyright 2010 집. All rights reserved.
//

#import "how.h"
#import "Menu.h"

@implementation how

+(id) scene
{
	CCScene *scene = [CCScene node];		
	how *layer = [how node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		self.isTouchEnabled = YES;
		
		[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationPortrait];
		
		CCSprite *sprite = [CCSprite spriteWithFile:@"사용방법1.png"];
		sprite.anchorPoint = CGPointZero;
		[sprite setOpacity:0];
		[self addChild:sprite z:0 tag:0];
		
		CCSprite *sprite2 = [CCSprite spriteWithFile:@"사용방법그림.png"];
		sprite2.anchorPoint = CGPointZero;
		sprite2.visible = NO;
		[self addChild:sprite2 z:0 tag:1];
		
		CCSprite *sprite3 = [CCSprite spriteWithFile:@"사용방법 copy.png"];
		sprite3.anchorPoint = CGPointZero;
		sprite3.visible = NO;
		[self addChild:sprite3 z:0 tag:2];
		
		_index = 0;
		
		[sprite runAction:
		 [CCFadeIn actionWithDuration:1.0f]];
	}
	
	return self;
}

-(void)NextScreen
{
	CCSprite *nowSprite = (CCSprite*)[self getChildByTag:_index++];
	CCSprite *nextSprite = (CCSprite*)[self getChildByTag:_index];
	
	nowSprite.visible = NO;
	nextSprite.visible = YES;
	
	[nextSprite runAction:
	 [CCFadeIn actionWithDuration:1.0f]];
	

}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( _index == 2 )
	{
		[[CCDirector sharedDirector] pushScene:[Menu scene]];
			[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	}
	
	[self NextScreen];
}

-(void)dealloc
{
	[super dealloc];
}

@end
