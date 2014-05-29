//
//  RWTViewController.m
//  CookieCrunch
//
//  Created by Cesar Redondo on 5/27/14.
//  Copyright (c) 2014 Casa. All rights reserved.
//

#import "RWTViewController.h"
#import "RWTMyScene.h"
#import "RWTLevel.h"
@import AVFoundation;

@interface RWTViewController ()

@property (strong, nonatomic) RWTLevel *level;
@property (strong, nonatomic) RWTMyScene *scene;

@property (assign, nonatomic) NSUInteger movesLeft;
@property (assign, nonatomic) NSUInteger score;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gameOverPanel;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation RWTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    // Create and configure the scene.
    self.scene = [RWTMyScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    // Load the level.
    self.level = [[RWTLevel alloc] initWithFile:@"Level_1"];
    self.scene.level = self.level;
    [self.scene addTiles];
    id block = ^(RWTSwap *swap) {
        self.view.userInteractionEnabled = NO;
        
        if ([self.level isPossibleSwap:swap]) {
            [self.level performSwap:swap];
            [self.scene animateSwap:swap completion:^{
				[self handleMatches];
			}];
        }else {
            [self.scene animateInvalidSwap:swap completion:^{
                self.view.userInteractionEnabled = YES;
            }];
        }
        
    };
    
    
    
    self.scene.swipeHandler = block;
    
    self.gameOverPanel.hidden = YES;
    // Present the scene.
    [skView presentScene:self.scene];
    
    
    // Let's start the game!
    [self beginGame];

	NSURL *url = [[NSBundle mainBundle] URLForResource:@"Mining by Moonlight" withExtension:@"mp3"];
	self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	self.backgroundMusic.numberOfLoops = -1;
	[self.backgroundMusic play];}

- (void)showGameOver {
	[self.scene animateGameOver];
	self.gameOverPanel.hidden = NO;
	self.shuffleButton.hidden = YES;
	self.scene.userInteractionEnabled = NO;
	
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGameOver)];
	[self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)hideGameOver {

	self.shuffleButton.hidden = NO;
	[self.view removeGestureRecognizer:self.tapGestureRecognizer];
	self.tapGestureRecognizer = nil;
	
	self.gameOverPanel.hidden = YES;
	self.scene.userInteractionEnabled = YES;
	
	[self beginGame];
}
- (BOOL)shouldAutorotate
{
    return YES;
}


- (IBAction)shuffleButtonPressed:(id)sender {
	[self shuffle];
	[self decrementMoves];
}


- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)beginGame {
	self.movesLeft = self.level.maximumMoves;
	self.score = 0;
	[self updateLabels];
	[self.scene animateBeginGame];
    [self shuffle];
	[self.level resetComboMultiplier];
}

- (void)shuffle {
	[self.scene removeAllCookieSprites];
    NSSet *newCookies = [self.level shuffle];
    [self.scene addSpritesForCookies:newCookies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


-(BOOL) prefersStatusBarHidden {
    return YES;
}



- (void)handleMatches {
	// This is the main loop that removes any matching cookies and fills up the
	// holes with new cookies. While this happens, the user cannot interact with
	// the app.
	
	// Detect if there are any matches left.
	NSSet *chains = [self.level removeMatches];
	
	// If there are no more matches, then the player gets to move again.
	if ([chains count] == 0) {
		[self beginNextTurn];
		return;
	}
	
	// First, remove any matches...
	[self.scene animateMatchedCookies:chains completion:^{
		
		
		
		// ...then shift down any cookies that have a hole below them...
		NSArray *columns = [self.level fillHoles];
		
		for (RWTChain *chain in chains) {
			self.score += chain.score;
		}
		[self updateLabels];
		
		[self.scene animateFallingCookies:columns completion:^{
			
			// ...and finally, add new cookies at the top.
			NSArray *columns = [self.level topUpCookies];
			[self.scene animateNewCookies:columns completion:^{
				
				// Keep repeating this cycle until there are no more matches.
				[self handleMatches];
			}];
		}];
	}];
}

- (void)decrementMoves{
	self.movesLeft--;
	[self updateLabels];
	if (self.score >= self.level.targetScore) {
		self.gameOverPanel.image = [UIImage imageNamed:@"LevelComplete"];
		[self showGameOver];
	} else if (self.movesLeft == 0) {
		self.gameOverPanel.image = [UIImage imageNamed:@"GameOver"];
		[self showGameOver];
	}
}



- (void)beginNextTurn {
	[self.level detectPossibleSwaps];
	[self.level resetComboMultiplier];
	[self decrementMoves];
	self.view.userInteractionEnabled = YES;
}

- (void)updateLabels {
	self.targetLabel.text = [NSString stringWithFormat:@"%lu", (long)self.level.targetScore];
	self.movesLabel.text = [NSString stringWithFormat:@"%lu", (long)self.movesLeft];
	self.scoreLabel.text = [NSString stringWithFormat:@"%lu", (long)self.score];
}

@end
