//
//  RegistrationViewController.m
//  studentTrack
//
//  Created by Blake Elshire on 10/11/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveViewControllerDismissedWithValue:(NSNumber *)nodeNumber {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toCameraVCFromReg"]) {
        CameraViewController *rvc = segue.destinationViewController;
        [rvc setReviewDelegate:self];
    }
}

@end
