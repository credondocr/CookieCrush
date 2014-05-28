//
//  RWTMyScene.h
//  CookieCrunch
//

//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class RWTLevel;
@class RWTSwap;

@interface RWTMyScene : SKScene

@property (strong, nonatomic) RWTLevel *level;
@property(copy, nonatomic)void (^swipeHandler)(RWTSwap *swap);

- (void)animateSwap:(RWTSwap *)swap completion:(dispatch_block_t)completion;
-(void) addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;
- (void)animateInvalidSwap:(RWTSwap *)swap completion:(dispatch_block_t)completion;

@end
