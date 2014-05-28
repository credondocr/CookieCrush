//
//  RWTCookie.h
//  CookieCrunch
//
//  Created by Cesar Redondo on 5/27/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;
static const NSUInteger NumCookieTypes = 6;

@interface RWTCookie : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSUInteger cookieType;
@property (strong, nonatomic) SKSpriteNode *sprite;

- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;



@end
