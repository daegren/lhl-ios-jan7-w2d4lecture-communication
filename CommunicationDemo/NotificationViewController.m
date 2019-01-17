//
//  NotificationViewController.m
//  CommunicationDemo
//
//  Created by David Mills on 2019-01-17.
//  Copyright © 2019 David Mills. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@property(weak, nonatomic) IBOutlet UILabel *tapLabel;
@property(assign, nonatomic) int numberOfTaps;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  // Register an observer through the notification center for the
  // "tapNotification" fired from the GestureViewController
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(notification:)
                                               name:@"tapNotification"
                                             object:nil];
  // Register an observer through the notification center for the
  // UIKeyboardWillShowNotification
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboard:)
             name:UIKeyboardWillShowNotification
           object:nil];
  // Register a Key-Value Observer for the "numberOfTaps" property on this
  // object Calls into -(void)observeValueForKeyPath:ofObject:change:context
  // method
  [self addObserver:self
         forKeyPath:@"numberOfTaps"
            options:(NSKeyValueObservingOptionInitial |
                     NSKeyValueObservingOptionNew)
            context:nil];
  self.numberOfTaps = 0;
}

// Notification handler for the UIKeyboardWillShowNotification
- (void)keyboard:(NSNotification *)notification {
  NSLog(@"%@", notification);
}

// Notification handler for the tapNotification
- (void)notification:(NSNotification *)notification {
  self.numberOfTaps += 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
  NSLog(@"Notification for %@, Change: %@", keyPath, change);

  if ([keyPath isEqualToString:@"numberOfTaps"]) {
    self.tapLabel.text = [NSString stringWithFormat:@"%i", self.numberOfTaps];
  }
}

@end
