//
//  AppDelegate.m
//  showTrack
//
//  Created by Blake Elshire on 7/22/13.
//  Copyright (c) 2013 Blake Elshire. All rights reserved.
//

#import "AppDelegate.h"
#import "DIOSSession.h"
#import "DIOSNode.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize oauthWebView;
@synthesize requestTokens;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.oauthWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight-20)];
    
    [DIOSSession sharedOauthSessionWithURL:@"https://dallas-show.dsvc.org" consumerKey:@"EvH5vzxWJGFGo5RD2gz8JPN6LiFuEBJV" secret:@"ATKr6jCtCCsZAsockYrQHysmc2944cDi"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults objectForKey:@"access_token"];
    NSString *access_secret = [defaults objectForKey:@"access_secret"];
    
    if (access_token != nil && access_secret != nil) {
        [[DIOSSession sharedSession] setAccessToken:access_token secret:access_secret];
    }
    else {
        [DIOSSession getRequestTokensWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.requestTokens = [NSMutableDictionary new];
            NSArray *arr = [operation.responseString componentsSeparatedByCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@"=&"]];
            if([arr count] == 4) {
                [self.requestTokens setObject:[arr objectAtIndex:1] forKey:[arr objectAtIndex:0]];
                [self.requestTokens setObject:[arr objectAtIndex:3] forKey:[arr objectAtIndex:2]];
            } else {
                NSLog(@"failed ahh");
            }
            [_window addSubview:self.oauthWebView];
            NSString *urlToLoad = [NSString stringWithFormat:@"%@/oauth/authorize?%@", [[DIOSSession sharedSession] baseURL], operation.responseString];
            NSURL *url = [NSURL URLWithString:urlToLoad];
            NSLog(@"loading url :%@", urlToLoad);
            //URL Requst Object
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            //Load the request in the UIWebView.
            [self.oauthWebView loadRequest:requestObj];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //If our request tokens were validated, this will get called.
    if ([[url absoluteString] rangeOfString:[requestTokens objectForKey:@"oauth_token"]].location != NSNotFound) {
        [DIOSSession getAccessTokensWithRequestTokens:requestTokens success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *arr = [operation.responseString componentsSeparatedByCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@"=&"]];
            if([arr count] == 4) {
                //Lets set our access tokens now
                [[DIOSSession sharedSession] setAccessToken:[arr objectAtIndex:1] secret:[arr objectAtIndex:3]];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:[arr objectAtIndex:1] forKey:@"access_token"];
                [defaults setObject:[arr objectAtIndex:3] forKey:@"access_secret"];
                [defaults synchronize];
            } else {
                NSLog(@"failed ahh");
            }
            NSLog(@"successfully added accessTokens");
            [oauthWebView removeFromSuperview];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"getting access tokens failed");
            [oauthWebView removeFromSuperview];
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
