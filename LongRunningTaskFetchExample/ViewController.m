//
//  ViewController.m
//  LongRunningTaskFetchExample
//
//  Created by Bob Dugan on 11/12/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Initialize start time to compute duration later
    _startTime = [NSDate date];
    
    // Initialize UI fields
    self.status.text = @"Downloading";
    self.time.text = @"0";
}
@end
