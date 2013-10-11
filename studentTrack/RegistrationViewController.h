//
//  RegistrationViewController.h
//  studentTrack
//
//  Created by Blake Elshire on 10/11/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "DIOSNode.h"

@interface RegistrationViewController : UIViewController <RVCDelegate>

@property (strong, nonatomic) CameraViewController *rvc;

@end
