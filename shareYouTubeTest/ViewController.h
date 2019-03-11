//
//  ViewController.h
//  shareYouTubeTest
//
//  Created by Sergey Pogrebnyak on 2/21/19.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GTLRYouTube.h>

@import GoogleSignIn;
@interface ViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRYouTubeService *service;
@property (weak, nonatomic) IBOutlet UIButton *butonShareOnFB;
@property (weak, nonatomic) IBOutlet UIButton *signInMyButton;

@end

