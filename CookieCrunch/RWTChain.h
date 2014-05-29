//
//  RWTChain.h
//  CookieCrunch
//
//  Created by Cesar Redondo on 5/28/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWTCookie;

typedef NS_ENUM(NSUInteger, ChainType) {
	ChainTypeHorizontal,
	ChainTypeVertical,
};
@interface RWTChain : NSObject

@property(strong, nonatomic, readonly) NSArray *cookies;
@property(assign, nonatomic) ChainType chainType;
@property(assign, nonatomic) NSUInteger score;

-(void)addCookie:(RWTCookie *)cookie;

@end
