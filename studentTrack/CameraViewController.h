//
//  ReceiveViewController.h
//  showTrack
//
//  Created by Blake Elshire on 7/31/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

@protocol RVCDelegate <NSObject>
@required
-(void) receiveViewControllerDismissedWithValue:(NSNumber *)nodeNumber;
@end

@interface CameraViewController : UIViewController
{
    __weak id <RVCDelegate> reviewDelegate;
}

@property (weak, nonatomic) id <RVCDelegate> reviewDelegate;
@property (assign) int barcodeIndex;
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) UIButton *scanButton;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain, nonatomic) CALayer *barcodeTargetLayer;
@property (strong, nonatomic) SessionManager *sessionManager;
@property (strong, nonatomic) NSTimer *stepTimer;
@property (nonatomic, retain) NSTimer *barcodeTimer;

@end
