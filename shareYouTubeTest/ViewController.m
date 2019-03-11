//
//  ViewController.m
//  shareYouTubeTest
//
//  Created by Sergey Pogrebnyak on 2/21/19.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure Google Sign-in.
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeYouTube, nil];
    [signIn signInSilently];

    // Initialize the service object.
    self.service = [[GTLRYouTubeService alloc] init];
}

- (void)signIn:(GIDSignIn *)signIn
        didSignInForUser:(GIDGoogleUser *)user
        withError:(NSError *)error {
    NSLog(@"current user is - %@", [[GIDSignIn sharedInstance] currentUser]); // get current user
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
        NSLog(@"user is not authorization");
        [self.signInMyButton setHidden: false];
        
    } else {
        NSLog(@"user is authorization");
        [self.signInMyButton setHidden: true];
        
        [[user authentication] getTokensWithHandler:^(GIDAuthentication *authentication, NSError *error) {
            self.signInButton.hidden = true;
            NSLog(@"token - %@", authentication.accessToken);//get access token for api call
            NSLog(@"user email - %@", user.profile.email);//get user email
            NSLog(@"user granted scope - %@", user.grantedScopes);//get scope

        }];
    }
}

-(void) signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    NSLog(@"user log out");
    [self.signInMyButton setHidden: false];
}

- (IBAction)signOut:(UIButton *)sender {
    [[GIDSignIn sharedInstance] disconnect];//sign out
}
- (IBAction)signInAction:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];//sign in action
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
