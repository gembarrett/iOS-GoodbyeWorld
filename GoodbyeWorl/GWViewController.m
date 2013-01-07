//
//  GWViewController.m
//  GoodbyeWorl
//
//  Created by Gem Barrett on 23/02/2012.
//  Copyright (c) 2012 Gem Designs. All rights reserved.
//

#import "GWViewController.h"

@interface GWViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *galaxyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *worldImageView;
@property (weak, nonatomic) IBOutlet UIImageView *explosionImageView;

@end

@implementation GWViewController
@synthesize galaxyImageView;
@synthesize worldImageView;
@synthesize explosionImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //animate galaxy
    CGRect galaxyFrame = self.galaxyImageView.frame;
    galaxyFrame.origin.x = -640.0f;
    
    //make it go backwards and forwards
    [UIView animateWithDuration:12.0f delay:0.0f options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.galaxyImageView.frame = galaxyFrame;    
    } completion:nil];
    
    //load the world images and animate them
    //set up changeable array with 11 spaces
    NSMutableArray *animationImages = [NSMutableArray arrayWithCapacity:11];
    //for each image add to array
    for (NSInteger i = 0; i < 11; i++) {
        NSString *nameOfImage = [NSString stringWithFormat:@"spinning-earth%04d.png", i+1];
        UIImage *image = [UIImage imageNamed:nameOfImage];
        [animationImages addObject:image];
    }
    
    self.worldImageView.animationImages = animationImages;
    
    //set speed of world snimation
    self.worldImageView.animationDuration = 1.3f;
    [self.worldImageView startAnimating];
}

- (void)viewDidUnload
{
    [self setGalaxyImageView:nil];
    [self setWorldImageView:nil];
    [self setExplosionImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //only need one touch
    UITouch *touch = [touches anyObject];
    
    //find out location of touch
    CGPoint touchLocation = [touch locationInView:self.view];
    NSLog(@"Touched: x = %f, y = %f", touchLocation.x, touchLocation.y);
    
    //circular hit testing
    //location of tap
    CGFloat tX = touchLocation.x;
    CGFloat tY = touchLocation.y;
    
    //location of center of the world
    CGPoint worldCenter = self.worldImageView.center;
    CGFloat wX = worldCenter.x;
    CGFloat wY = worldCenter.y;
    
    
    CGFloat deltaX = tX - wX;
    CGFloat deltaY = tY - wY;
    
    CGFloat d = sqrtf(deltaX*deltaX + deltaY*deltaY);
    CGFloat r = self.worldImageView.frame.size.width/2;
    
    if (d <=r) {
        //explosion
        self.explosionImageView.hidden = NO;
        
        //set starting point of explosion
        CGRect explosionFrame = self.explosionImageView.frame;
        explosionFrame.origin.x = explosionFrame.origin.y = -960.0f;
        explosionFrame.size.width = explosionFrame.size.height = 1920.0f;
        
        [UIView animateWithDuration:0.4f animations:^{
            //make it scale and come towards viewer
            self.explosionImageView.frame = explosionFrame;
        } completion:^(BOOL finished) {
            //hide explosion and world afterwards
            self.explosionImageView.hidden = YES;
            self.worldImageView.hidden = YES;
            //stop responding to taps after explosion
            self.view.userInteractionEnabled = NO;
        }];
    }
}


@end
