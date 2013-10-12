//
//  JudgingViewController.h
//  studentTrack
//
//  Created by Blake Elshire on 10/11/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "DIOSNode.h"

@interface JudgingViewController : UIViewController <RVCDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *nodeScrollView;
@property (weak, nonatomic) IBOutlet UIView *nodeContainerView;
@property (strong, nonatomic) CameraViewController *rvc;
@property (strong, nonatomic) NSString *node_medal;
@property (strong, nonatomic) NSArray *possibleMedals;

@end
