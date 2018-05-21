//
//  Menu.h
//  Rolling Star
//
//  Created by Sunas on 10. 8. 7..
//  Copyright 2010 집. All rights reserved.
//
#import "cocos2d.h"

@interface Menu : CCLayer {
	
	CCParticleSystem	*_GalaxyParticle;
	CCSprite			*_Star;
	CCSprite			*_Title;
}

+(id) scene;

@end
