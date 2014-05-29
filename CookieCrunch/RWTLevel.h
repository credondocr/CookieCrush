//
//  RWTLevel.h
//  CookieCrunch
//
//  Created by Cesar Redondo on 5/27/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTCookie.h"
#import "RWTTile.h"
#import "RWTSwap.h"
#import "RWTChain.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface RWTLevel : NSObject

@property (assign, nonatomic) NSUInteger targetScore;
@property (assign, nonatomic) NSUInteger maximumMoves;




-(NSSet *)shuffle;
- (void)resetComboMultiplier;
-(RWTCookie *)cookieAtColumn:(NSInteger) column row:(NSInteger) row;
-(instancetype) initWithFile:(NSString *)filename;
-(RWTTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)performSwap:(RWTSwap *)swap;
- (BOOL)isPossibleSwap:(RWTSwap *)swap;
-(NSSet *)removeMatches;
-(NSArray *)fillHoles;
- (NSArray *)topUpCookies;
- (void)detectPossibleSwaps;
@end
