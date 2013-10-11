//
//  JudgingViewController.m
//  studentTrack
//
//  Created by Blake Elshire on 10/11/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import "JudgingViewController.h"
#import "DIOSNode.h"

@implementation JudgingViewController

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
    self.possibleMedals = [[NSArray alloc] initWithObjects:@"None",@"Bronze",@"Silver",@"Gold", nil];
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
    if ([segue.identifier isEqualToString:@"toCameraVCFromJudge"]) {
        CameraViewController *rvc = segue.destinationViewController;
        [rvc setReviewDelegate:self];
    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return [self.possibleMedals count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component {
    return [self.possibleMedals objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component {
    self.node_medal = [self.possibleMedals objectAtIndex:row];
}

@end
