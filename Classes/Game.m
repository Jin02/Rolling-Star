//
//  Game.m
//  Racing
//
//  Created by roden on 10. 7. 16..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "NPCObject.h"
//#import "Object.h"
#import "Common.h"
#import "SceneData.h"
#import "GameOver.h"
#import "NetWork.h"

@implementation Game

@synthesize vAccelomation = _vAccelomation;
@synthesize Timer = _Timer;
@synthesize Speed = _Speed;

+(id) scene
{
	CCScene *scene = [CCScene node];	
	
	Game *layer = [Game node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		
//		NSLog(@"adf")
		
//		self.isTouchEnabled = YES;
//		self.isAccelerometerEnabled = YES; //가속계를 사용합니다.
		
		//임시용 인터페이스 객체를 생성합니다
		Interface *tmp = [[Interface alloc] initWithGame:self];
		_Interface = tmp; //헤더에서 선언해준 멤버변수와 앞의 임시 인터페이스 객체의 주소를 넣습니다
		[self addChild:_Interface z:sTag_Interface tag:sTag_Interface]; //뷰에 등록합니다.
		[_Interface release]; //릴리즈하여 리테인 카운트 수를 하나 내립니다.
		
		memset(&_vAccelomation, 0, sizeof(ccVertex3F));
		
		_FirstBigMeteor = NO;
		
		MeteorNum = 0;
		BustNum = 0;
		Moving = 0;
		
		_Moving = 0;
		
		_Life = 5; //현재의 라이프
		_Timer = [[Common sharedCommon] timeGetTime];
		
		_NPCObjectArray = [[NSMutableArray alloc] initWithCapacity:20];
		[self performSelector:@selector(StartGame) withObject:nil afterDelay:5.f];
	}
	
	return self;
}

-(void)AcclerometerRun
{
	self.isAccelerometerEnabled = YES;
}

-(void)NextScene
{
	[[CCDirector sharedDirector] pushScene:[GameOver scene]];
}

-(void)step
{
	NSMutableArray *array = [NSMutableArray array];
	
	for(NPCObject *_Object in _NPCObjectArray) //아래로 내려간 오브젝트를 지워 줍니다.
	{
		
		if( [[Common sharedCommon] CircleCrashCheck_X:	[_Object GetPosition].x 
												    x2:	_Interface.Character.position.x
													y1:	[_Object GetPosition].y
												    y2:	_Interface.Character.position.y
													r:	[_Object GetContentSize].width/2 - 5
													r2:	(_Interface.Character.textureRect.size.width * _Interface.Character.scale) - 5 ]
		   && [_Object GetisLive] )
		{	
			NSLog(@"asf");
			
			if( [_Object GetType] <= oType_Item_3 && [_Object GetType] >= oType_Item_1 )
				BustNum++;
			
			if( [_Object GetType] <= oType_NPC_3 )
			{
				if( (--_Life) <= 0 ) {
					[self unschedule:@selector(step)];
					self.isAccelerometerEnabled = NO;
					[_Interface GameOverSee];
					
					[self performSelector:@selector(NextScene) withObject:nil afterDelay:3.f];
					
					NSLog(@"게임 오버");
				}
				
				self.isAccelerometerEnabled = NO;
				
				[self runAction:[CCSequence actions:
								 [CCDelayTime actionWithDuration:1.0f],
								 [CCCallFunc actionWithTarget:self selector:@selector(AcclerometerRun)],nil]];
				
				[_Interface SunParticleSeeWithType:[_Object GetType]];
				[_Interface LifeMinus];
			}
			else
			{
				[_Interface ChangeCharacterScaleWithType:[_Object GetType]];
				[_Interface FlowerParticleSeeWithType:[_Object GetType]];
			}
			
			[_Interface ChangeSpeedWithType:[_Object GetType]];
			[_Interface CharacterRotateWithType:[_Object GetType]];
			
			
			[array addObject:_Object];
			
			for(NPCObject *__Object in _NPCObjectArray)
				[__Object SetChangeSpeedWithType:[_Object GetType]];
			
			[self runAction:
			 [CCSequence actions:
			 [CCCallFunc actionWithTarget:_Object selector:@selector(RemoveObject)],
			  [CCDelayTime actionWithDuration:1.01f],
			  [CCCallFuncND actionWithTarget:self selector:@selector(removeObject:_Object:) data:(void*)_Object],nil]];
		}
		
		if( [_Object GetPosition].y < -200 )
		{
			[array addObject:_Object];
			[self removeChild:_Object cleanup:YES];
		}
	
			   
		[_Object step];
	}
	
	[array removeAllObjects];
	
	if( (_Speed = ((float)([[Common sharedCommon] timeGetTime] - _Timer)/1000)/50) >= 1.f && !_FirstBigMeteor )
	{
		NPCObject *tmp = [[NPCObject alloc]initWithGame:self Pos:ccp(rand()%350+100,500) Type:oType_NPC_3];	
		[_NPCObjectArray addObject:tmp];
		
		[self addChild:tmp z:sTag_Interface tag:sTag_Interface+1];
		
		_FirstBigMeteor = YES;
	}
	
	Moving = _Moving += _Speed/10;
	
	if ( _Speed >= 2 && !_Interface.FirstRainParticle)
	{
		[_Interface ResetRainParticle];
		_Interface.FirstRainParticle = YES;
	}
	
	if ( _Speed >= 3 && [_Interface isSide]==NO )
	{
		[_Interface SideSee];
	}
}

-(void)NetWorkstep
{
	[[NetWork sharedNetWork] mySendData:
	 [[NSString stringWithFormat:@"%d",(int)(Moving * 1.5f + BustNum * 200 + MeteorNum * 500)] 
	  dataUsingEncoding:NSASCIIStringEncoding]];
	
	if( [[NetWork sharedNetWork] isRecive] )
	{
		NSString *str = [[NSString alloc] initWithData:[NetWork sharedNetWork].ReciveData encoding:NSASCIIStringEncoding];
		[_Interface NetWorkSetString:str];
		[str release];
		[[NetWork sharedNetWork] setIsRecive:NO];
	}
}
			  
-(void)removeObject:(CCNode*)node _Object:(NPCObject*)_Object
{
	[self removeChild:_Object cleanup:YES];
}

-(void)CreateObject
{
	NSInteger randValue = rand()%(oType_Item_5+1);
	
	if (_Speed < 2 && randValue == oType_NPC_2) {
		randValue = rand()%oType_Item_5;
	}
	
	if (_Speed < 4 && randValue == oType_NPC_3)
	{
		randValue = rand() % oType_Item_5;
	}
	
	if( randValue <= oType_NPC_3 )
		MeteorNum++;
	
	NPCObject *tmp = [[NPCObject alloc]initWithGame:self Pos:ccp(rand()%350+100,500) Type:randValue];	
	[_NPCObjectArray addObject:tmp];

	[self addChild:tmp z:sTag_Interface tag:sTag_Interface+1];

}

-(void)StartGame
{
	self.isAccelerometerEnabled = YES;
	
	[self schedule:@selector(step)];
	[self schedule:@selector(CreateObject) interval:3.0f];
	if( [[NetWork sharedNetWork] isMultiPlay] ) [self schedule:@selector(NetWorkstep) interval:2.5f];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];	
	
	NSLog(@"%f",convertedLocation.y);
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
#define kFilterFactor 0.98f
	
	ccVertex3F accelV;
	
	accelV.x = ((float) acceleration.x * kFilterFactor + (1- kFilterFactor)*_vAccelomation.x);
	accelV.y = ((float) acceleration.y * kFilterFactor + (1- kFilterFactor)*_vAccelomation.y);
	accelV.z = ((float) acceleration.z * kFilterFactor + (1- kFilterFactor)*_vAccelomation.z);
	
	_vAccelomation = accelV;
	
	
	static float prevX=0, prevY=0;
	
#define kFilterFactor2 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor2 + (1- kFilterFactor2)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor2 + (1- kFilterFactor2)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	_Interface.Galxy.gravity = ccpMult(v, -500);
	
//	NSLog(@"x : %f y : %f z : %f",accelV.x,accelV.y,accelV.z);
}

-(ccVertex3F)GetAccelomation
{
	return _vAccelomation;
}

-(void)dealloc
{
	[_NPCObjectArray release];
	[self unschedule:@selector(NetWorkstep)];
	[self unschedule:@selector(CreateMonster)];
	[self unschedule:@selector(step)];
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
