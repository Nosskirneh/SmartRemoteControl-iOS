//
//  MViewController.m
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-16.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import "MViewController.h"

@interface MViewController ()

@end

@implementation MViewController

@dynamic view;

- (void)loadView {
    // Create scroll view
    UINavigationController *navigationController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    CGRect frame = CGRectMake(0, navigationController.navigationBar.frame.size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - navigationController.navigationBar.frame.size.height);
    self.view = [[UIScrollView alloc] initWithFrame:frame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGroupsUpdatedNotification:) name:GROUPS_UPDATED_EVENT object:nil];

    [[ModelManager sharedInstance] getGroups];
}

- (void)buttonClicked:(ActivityButton *)sender {
    NSString *body = [NSString stringWithFormat:@"name=%@&group=%@", sender.activity.name, sender.group.name];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/command", GetBaseURL()]];

    SendRequest(@"POST", body, url, ^(NSString *response) {
        // Show toast here
    });
}

- (void)handleGroupsUpdatedNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Create buttons
        int count = 0;
        for (Group *group in [ModelManager sharedInstance].groups) {
            for (Activity *activity in group.activities) {
                float x, y;
                if (count % 2 == 0) {
                    x = [[UIScreen mainScreen] bounds].size.width/4 - buttonWidth/2;
                    y = 20 + 30 * count;
                } else {
                    x = 3 * [[UIScreen mainScreen] bounds].size.width/4 - buttonWidth/2;
                    y = 20 + 30 * (count - 1);
                }
                ActivityButton *button = [ActivityButton buttonWithActivity:activity
                                                                      group:group
                                                                      frame:CGRectMake(x, y, buttonWidth, buttonHeight)];
                
                [button addTarget:self
                           action:@selector(buttonClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
                
                [self.view addSubview:button];
                count++;
            }
        }
        
        self.view.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 20 + 30 * count);
    });
}

@end
