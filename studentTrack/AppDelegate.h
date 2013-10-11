//
//  AppDelegate.h
//  studentTrack
//
//  Created by Blake Elshire on 10/11/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIOSSession.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWebView *oauthWebView;
@property (strong, nonatomic) NSMutableDictionary *requestTokens;
@property (strong, nonatomic) DIOSSession *session;

@end
