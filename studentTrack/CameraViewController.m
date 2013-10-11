//
//  ReceiveViewController.m
//  showTrack
//
//  Created by Blake Elshire on 7/31/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import "CameraViewController.h"

CGMutablePathRef createPathForPoints(NSArray* points)
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPoint point;
	
	if ([points count] > 0) {
		CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[points objectAtIndex:0], &point);
		CGPathMoveToPoint(path, nil, point.x, point.y);
		
		int i = 1;
		while (i < [points count]) {
			CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[points objectAtIndex:i], &point);
			CGPathAddLineToPoint(path, nil, point.x, point.y);
			i++;
		}
		
		CGPathCloseSubpath(path);
	}
	
	return path;
}

@implementation CameraViewController

@synthesize reviewDelegate = reviewDelegate;

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
    
    if (self.sessionManager == nil) {
        self.sessionManager = [[SessionManager alloc] init];
        [self.sessionManager startRunning];
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.sessionManager.captureSession];
        [previewLayer setFrame:self.previewView.bounds];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        if ([[previewLayer connection] isVideoOrientationSupported]) {
            [[previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
        [self.previewView.layer addSublayer:previewLayer];
        [self.previewView.layer setMasksToBounds:YES];
        [self setPreviewLayer:previewLayer];
        CGRect bounds = [self.previewView bounds];
        CGRect previewRect = CGRectMake(0, 0, bounds.size.width, bounds.size.height-55);
        CGRect metadataRect = [self.previewLayer metadataOutputRectOfInterestForRect:previewRect];
        
        [self.sessionManager setMetadataRectOfInterest:metadataRect];
        
        // Configure barcode overlay
        CALayer* barcodeTargetLayer = [[CALayer alloc] init];
        CGRect r = self.view.layer.bounds;
        barcodeTargetLayer.frame = r;
        self.barcodeTargetLayer = barcodeTargetLayer;
        [self.view.layer addSublayer:self.barcodeTargetLayer];
        
        self.dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.dismissButton.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-55, CGRectGetWidth(self.view.frame)/2, 55);
        [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.dismissButton setTitle:@"close" forState:UIControlStateNormal];
        [self.dismissButton addTarget:self action:@selector(dismissButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.dismissButton.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.6];
        [self.dismissButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [self.view addSubview:self.dismissButton];
        
        self.scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.scanButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)-55, CGRectGetWidth(self.view.frame)/2, 55);
        [self.scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.scanButton setTitle:@"scan" forState:UIControlStateNormal];
        [self.scanButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.scanButton.backgroundColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.6];
        [self.scanButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [self.view addSubview:self.scanButton];
        
        self.stepTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(step) userInfo:nil repeats:YES];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.sessionManager stopRunning];
}

- (void)dismissButtonPressed {
    if (![self isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)scanButtonPressed {
    if ([self.sessionManager.barcodes count] > 0) {
        self.barcodeIndex = (self.barcodeIndex + 1) % [self.sessionManager.barcodes count];
        AVMetadataMachineReadableCodeObject *barcode = [self.sessionManager.barcodes objectAtIndex:self.barcodeIndex];
        AVMetadataMachineReadableCodeObject *transformedBarcode = (AVMetadataMachineReadableCodeObject*)[self.previewLayer transformedMetadataObjectForMetadataObject:barcode];
        if (reviewDelegate != nil && [self.reviewDelegate respondsToSelector:@selector(receiveViewControllerDismissedWithValue:)]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *nodeNumber = [f numberFromString:transformedBarcode.stringValue];
            
            [[self reviewDelegate] receiveViewControllerDismissedWithValue:nodeNumber];
        }
        if (![self isBeingDismissed]) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)step
{
	if ( [self.sessionManager.barcodes count] < 1 )
		return;
	
	@synchronized(self.sessionManager) {
		self.barcodeIndex = (self.barcodeIndex + 1) % [self.sessionManager.barcodes count];
		AVMetadataMachineReadableCodeObject *barcode = [self.sessionManager.barcodes objectAtIndex:self.barcodeIndex];
		
		// Draw overlay
		[self.barcodeTimer invalidate];
		self.barcodeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeDetectedBarcodeUI) userInfo:nil repeats:NO];
		AVMetadataMachineReadableCodeObject *transformedBarcode = (AVMetadataMachineReadableCodeObject*)[self.previewLayer transformedMetadataObjectForMetadataObject:barcode];
		CGPathRef barcodeBoundary = createPathForPoints(transformedBarcode.corners);
        
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		[self removeDetectedBarcodeUI];
		[self.barcodeTargetLayer addSublayer:[self barcodeOverlayLayerForPath:barcodeBoundary withColor:[UIColor greenColor]]];
		[CATransaction commit];
		CFRelease(barcodeBoundary);
	}
}

- (void)removeDetectedBarcodeUI
{
	[self removeAllSublayersFromLayer:self.barcodeTargetLayer];
}

- (CAShapeLayer*)barcodeOverlayLayerForPath:(CGPathRef)path withColor:(UIColor*)color
{
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	
	[maskLayer setPath:path];
	[maskLayer setLineJoin:kCALineJoinRound];
	[maskLayer setLineWidth:2.0];
	[maskLayer setStrokeColor:[color CGColor]];
	[maskLayer setFillColor:[[color colorWithAlphaComponent:0.20] CGColor]];
	
	return maskLayer;
}

- (void)removeAllSublayersFromLayer:(CALayer *)layer
{
	if (layer) {
		NSArray* sublayers = [[layer sublayers] copy];
		for( CALayer* l in sublayers ) {
			[l removeFromSuperlayer];
		}
	}
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
