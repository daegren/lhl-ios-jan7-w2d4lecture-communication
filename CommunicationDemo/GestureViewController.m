//
//  GestureViewController.m
//  CommunicationDemo
//
//  Created by David Mills on 2019-01-17.
//  Copyright © 2019 David Mills. All rights reserved.
//

#import "GestureViewController.h"

@interface GestureViewController ()

@property(weak, nonatomic) IBOutlet UIView *redBox;
@property(strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property(strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property(assign, nonatomic) CGPoint originalPosition;

@end

@implementation GestureViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  // Setup the UIPanGestureRecognizer
  self.panRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(pan:)];
  // Attach the UIPanGestureRecognizer to the redBox view
  [self.redBox addGestureRecognizer:self.panRecognizer];

  // Setup the UITapGestureRecognizer
  self.tapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tap:)];

  // Attach the UITapGestureRecognizer to the redBox view
  [self.redBox addGestureRecognizer:self.tapRecognizer];
}

// Fires when the UIPanGestureRecognizer starts recognizing touches
- (void)pan:(UIPanGestureRecognizer *)recog {
  switch (recog.state) {
  case UIGestureRecognizerStateBegan:
    // Set the original position of the redBox to compare against
    self.originalPosition = self.redBox.frame.origin;
    break;

  case UIGestureRecognizerStateChanged: {
    // Get the TOTAL translation in the superview
    CGPoint translation = [recog translationInView:self.view];
    // Make sure it doesn't go off the top or left edges
    CGFloat x = MAX(0, self.originalPosition.x + translation.x);
    CGFloat y = MAX(0, self.originalPosition.y + translation.y);
    // Make sure it doesn't go off the bottom or right edges
    x = MIN(self.view.bounds.size.width - self.redBox.frame.size.width, x);
    y = MIN(self.view.bounds.size.height - self.redBox.frame.size.height, y);
    // Create & set the new frame for our redBox
    CGRect newFrame = CGRectMake(x, y, self.redBox.frame.size.width,
                                 self.redBox.frame.size.height);
    self.redBox.frame = newFrame;
    break;
  }

  case UIGestureRecognizerStateEnded:
    // Gesture is finished, reset the original position to (0, 0)
    self.originalPosition = CGPointZero;

  default:
    break;
  }
}

// Handler for the UITapGestureRecognizer
- (void)tap:(UITapGestureRecognizer *)recog {
  // Calculate some random values for red (r), green (g) and blue (b)
  CGFloat r = arc4random_uniform(255) / 255.0;
  CGFloat g = arc4random_uniform(255) / 255.0;
  CGFloat b = arc4random_uniform(255) / 255.0;

  // Create a new color
  UIColor *newColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
  // Animate the change of the backgroundColor property on the redbox over 0.25s
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.redBox.backgroundColor = newColor;
                   }];

  // Post a notification to the notification center
  [[NSNotificationCenter defaultCenter] postNotificationName:@"tapNotification"
                                                      object:nil];
}

@end
