//
//  LogViewController.m
//  PhotoUploader
//
//  Created by rahul nagpal on 22/06/13.
//  Copyright (c) 2013 rahul nagpal. All rights reserved.
//

#import "LogViewController.h"

@implementation LogViewController

@synthesize logTextView;
@synthesize logText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    logTextView = [[UITextView alloc]init];
	logTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	logTextView.backgroundColor = [UIColor clearColor];
    logTextView.textColor = [UIColor blackColor];
    logTextView.text = logText;
    logTextView.editable = NO;
	[self.view addSubview:logTextView];
	// Do any additional setup after loading the view, typically from a nib.
}

@end
