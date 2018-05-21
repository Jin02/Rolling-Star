//
//  Ranking.m
//  Rolling Star
//
//  Created by Sunas on 10. 8. 9..
//  Copyright 2010 집. All rights reserved.
//

#import "Ranking.h"
#import "Data.h"
#import "Menu.h"

@implementation Ranking


+(id) scene
{
	CCScene *scene = [CCScene node];	
	
	Ranking *layer = [Ranking node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		CCSprite *BackGround = [CCSprite spriteWithFile:@"랭킹2.png"];
		BackGround.anchorPoint = CGPointZero;
		BackGround.position = CGPointZero;
		[self addChild: BackGround z:0 tag:0];
		
		self.isTouchEnabled = YES;
		
		[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationPortrait];
		
		[self performSelector:@selector(Check) withObject:nil afterDelay:0.5f];
		
		NSMutableArray *array = [[Data sharedData] DataLoadWithFilePath:@"Ranking"];
		
		NSLog(@"%d", [array count]);
		
		for( int i = 0; i < [array count]; i++)
		{
			CCLabel *label = [CCLabel labelWithString:[NSString stringWithFormat:@"%d", [[array objectAtIndex:i] intValue]]
											 fontName:@"Marker Felt" fontSize:22];
			
			[label setPosition:ccp(160, 480 - i*55 - 113)];
			[self addChild:label];
		}
		
		[array release];
 	}
	
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self NextScene];
}

-(void)Check
{
	NSMutableArray *array = [[Data sharedData] DataLoadWithFilePath:@"Ranking"];
	
	if( [array count] == 0 )
	{
		UIAlertView *alert	= [[UIAlertView alloc] initWithTitle:@"랭킹데이터가 비어있습니다" 
														message:nil 
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"확인", nil];
		[alert show];
		[alert release];
		
		[self performSelector:@selector(NextScene) withObject:nil afterDelay:1.0f];
	}
	
	[array release];
}

-(void)NextScene
{
	[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] pushScene:[Menu scene]];
}

-(void)dealloc
{
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
