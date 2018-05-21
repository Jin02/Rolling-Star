//
//  GameOver.m
//  Rolling Star
//
//  Created by Sunas on 10. 8. 8..
//  Copyright 2010 집. All rights reserved.
//

#import "GameOver.h"
#import "SceneData.h"
#import "Menu.h"
#import "Data.h"

@implementation GameOver

+(id) scene
{
	CCScene *scene = [CCScene node];		
	GameOver *layer = [GameOver node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		CCSprite	*_BackGround = [CCSprite spriteWithFile:@"Result.png"];
		_BackGround.anchorPoint = CGPointZero;
		_BackGround.position = CGPointZero;
		[self addChild:_BackGround z:0 tag:0];
		
		CCSprite	*_GameOver = [CCSprite spriteWithFile:@"GameOver.png"];
		_GameOver.anchorPoint = ccp(0,1.0);
		_GameOver.position = ccp(0,320);
		[self addChild:_GameOver z:1 tag:0];
		
		
		
		CCSprite	*_Star		= [CCSprite spriteWithFile:@"MenuStar.png"];
		_Star.position = ccp(86,125);
		[_Star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1.0f angle:40.f]]];
		[self addChild:_Star z:2 tag:0];
											  
		CCLabel		*_Label		 = [CCLabel labelWithString:@"0" fontName:@"Marker Felt" fontSize:22];
		NSString	*_Str		 = [NSString stringWithFormat:@"%d", (int)Moving];
		[_Label setString:_Str];
		[_Label setPosition:ccp(330, 320 - 75)];
		[self addChild:_Label z:1 tag:1];
		
		CCLabel		*_Label2	 = [CCLabel labelWithString:@"0" fontName:@"Marker Felt" fontSize:22];
		NSString	*_Str2		 = [NSString stringWithFormat:@"%d", (int)BustNum];
		[_Label2 setString:_Str2];
		[_Label2 setPosition:ccp(330, 320 - 122)];
		[self addChild:_Label2 z:1 tag:1];
		
		CCLabel		*_Label3	 = [CCLabel labelWithString:@"0" fontName:@"Marker Felt" fontSize:22];
		NSString	*_Str3		 = [NSString stringWithFormat:@"%d", (int)MeteorNum];
		[_Label3 setString:_Str3];
		[_Label3 setPosition:ccp(330, 320 - 163)];
		[self addChild:_Label3 z:1 tag:1];
		
		CCLabel		*_Label4	 = [CCLabel labelWithString:@"0" fontName:@"Marker Felt" fontSize:22];
		NSString	*_Str4		 = [NSString stringWithFormat:@"%d", (int)(Moving * 1.5f + BustNum * 200 + MeteorNum * 500)];
		[_Label4 setString:_Str4];
		[_Label4 setPosition:ccp(330, 320 - 207)];
		[self addChild:_Label4 z:1 tag:1];
				
		CCMenuItemImage *OK = [CCMenuItemImage itemFromNormalImage:@"확인.png" 
													 selectedImage:@"확인 click.png" 
															target:self 
														  selector:@selector(NextScene)];
		
		[OK setPosition:ccp(30,-140)];
		
		CCMenu *menu = [CCMenu menuWithItems:OK,nil];
		
		[self addChild:menu z:3 tag:0];
		
//		[menu setPosition:ccp(0,0)];
	}
	
	return self;
}

-(void)NextScene
{
	[[CCDirector sharedDirector] pushScene:[Menu scene]];
	
	NSMutableArray *array = [[Data sharedData] DataLoadWithFilePath:@"Ranking"];
	
	if(! [array count] )
	{
		[[Data sharedData] DataToSaveWithSaveFilePath:@"Ranking" 
											  Context:[NSString stringWithFormat:@"%d",
													   (int)(Moving * 1.5f + BustNum * 200 + MeteorNum * 500)]];
	}
}

-(void)dealloc
{
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
