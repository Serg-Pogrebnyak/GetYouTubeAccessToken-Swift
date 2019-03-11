//
//  AppDelegate.h
//  shareYouTubeTest
//
//  Created by Sergey Pogrebnyak on 2/21/19.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleSignIn;
@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

