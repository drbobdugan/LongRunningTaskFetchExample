//
//  ViewController.h
//  LongRunningTaskFetchExample
//
//  Created by Bob Dugan on 11/12/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// State information
@property (nonatomic, weak) NSURLSession *session;
@property (nonatomic, strong) NSDate *startTime;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextField *URL;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *data;


- (IBAction)buttonPressed:(id)sender;

@end

