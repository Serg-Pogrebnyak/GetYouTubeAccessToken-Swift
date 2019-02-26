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

    // Add the sign-in button.
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.view addSubview:self.signInButton];

    // Create a UITextView to display output.
    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.output.editable = false;
    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.output.hidden = true;
    [self.view addSubview:self.output];

    // Initialize the service object.
    self.service = [[GTLRYouTubeService alloc] init];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.output.hidden = false;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        [self fetchChannelResource];
        [[user authentication] getTokensWithHandler:^(GIDAuthentication *authentication, NSError *error) {
            NSLog(@"token - %@", authentication.accessToken);

        }];

    }
}





// Construct a query and retrieve the channel resource for the GoogleDevelopers
// YouTube channel. Display the channel title, description, and view count.
- (void)fetchChannelResource {
    GTLRYouTubeQuery_ChannelsList *query =
    [GTLRYouTubeQuery_ChannelsList queryWithPart:@"snippet,statistics"];
    query.identifier = @"UC_x5XG1OV2P6uZZ5FSM9Ttw";
    // To retrieve data for the current user's channel, comment out the previous
    // line (query.identifier ...) and uncomment the next line (query.mine ...).
    // query.mine = true;

    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRYouTube_ChannelListResponse *)channels
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *output = [[NSMutableString alloc] init];
        if (channels.items.count > 0) {
            [output appendString:@"Channel information:\n"];
            for (GTLRYouTube_Channel *channel in channels) {
                NSString *title = channel.snippet.title;
                NSString *description = channel.snippet.description;
                NSNumber *viewCount = channel.statistics.viewCount;
                [output appendFormat:@"Title: %@\nDescription: %@\nViewCount: %@\n", title, description, viewCount];
            }
        } else {
            [output appendString:@"Channel not found."];
        }
        self.output.text = output;
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
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
