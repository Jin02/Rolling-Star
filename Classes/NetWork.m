//
//  NetWork.m
//  ProJect
//
//  Created by roden on 10. 5. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetWork.h"


@implementation NetWork

@synthesize isRecive	= _isRecive;
@synthesize isMultiPlay = _isMultiPlay;
@synthesize ReciveData	= _ReciveData;

static NetWork *_sharedNetWork = nil;

+ (NetWork *) sharedNetWork {
	@synchronized([NetWork class]) {
		if (!_sharedNetWork)
			[[self alloc] init];
		
		return _sharedNetWork;
	}
    
	return nil;
}

+ (id) alloc{
	@synchronized([NetWork class]) {
		_sharedNetWork = [super alloc];
		return _sharedNetWork;
	}
    
	return nil;
}

-(id)init
{
	if( (self = [super init]) )
	{
		_isMultiPlay	= NO;
		_isRecive		= NO;
	}
	
	return self;
}


-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	_ReciveData		= data;
	_isRecive		= YES;
}

-(void)FindButton
{
	GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
	picker.delegate = self;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;

	[picker show];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session
{
	NSLog(@"여기 들어옴 여기 들어옴 여기 들어옴");
	
	_Session = session;
	_Session.delegate = self;
	[_Session retain];
	
	[session setDataReceiveHandler:self withContext:nil];
	
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	NSLog(@"캔슬");

	picker.delegate = nil;
	[picker autorelease];
	_isMultiPlay = NO;
}

-(void)mySendData:(NSData*)data
{
	if( _isMultiPlay == NO ) return;
	[_Session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	NSLog(@"연결상태");
	
	switch (state) {
		case GKPeerStateConnected:
			NSLog(@"연결완료");
			_isMultiPlay = YES;
			break;
		case GKPeerStateDisconnected:
			NSLog(@"연결이 해제 되었습니다");
			_isMultiPlay = NO;
			break;

		default:
			break;
	}
}

- (void)SessionDisConnect
{
	_Session = nil;
}

-(void)dealloc
{
	[super dealloc];
}

@end
