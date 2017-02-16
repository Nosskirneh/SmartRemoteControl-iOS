//
//  SettingsViewController.m
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-11-29.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import "SettingsViewController.h"
#import "ModelManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

BOOL urlOK;
BOOL authOK;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlTextField.delegate = self;
    self.urlTextField.text = GetBaseURL();
    
    self.userTextField.delegate = self;
    self.userTextField.text = GetUser();
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.text = GetPassword();
    
    [self initTextField:_urlTextField];
    [self initTextField:_userTextField];
    [self initTextField:_passwordTextField];
}

- (void)initTextField:(UITextField *)textField {
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0);
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor clearColor].CGColor;
}

- (IBAction)saveButtonAction:(id)sender {
    SetBaseURL(_urlTextField.text);
    SetUser(_userTextField.text);
    SetPassword(_passwordTextField.text);
    
    dispatch_group_t group = dispatch_group_create();
    [self validInput:@"status" forCells:@[@URL_CELL] dispatchGroup:group];
    [self validInput:@"checkAuth" forCells:@[@USER_CELL, @PASS_CELL] dispatchGroup:group];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (urlOK && authOK) { // Both fields are OK
            [[ModelManager sharedInstance] getGroups];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }
    });
}

// Return button on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // change this to next text input instead
    [textField resignFirstResponder]; // dismiss keyboard
    SetBaseURL(_urlTextField.text);
    SetUser(_userTextField.text);
    SetPassword(_passwordTextField.text);
    
    dispatch_group_t group = dispatch_group_create();
    
    if ([textField isEqual:_urlTextField]) {
        [self validInput:@"status" forCells:@[@URL_CELL] dispatchGroup:group];
    } else if (([textField isEqual:_passwordTextField] && ![_userTextField.text isEqualToString:@""]) ||
               ([textField isEqual:_userTextField] && ![_passwordTextField.text isEqualToString:@""])) {
        [self validInput:@"checkAuth" forCells:@[@USER_CELL, @PASS_CELL] dispatchGroup:group];
    }
    
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    UILabel *label = [UILabel new];
    
    if (section == 0) {
        label.text = @"SERVER";
    }
    
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(14, 32, tableView.frame.size.width, 20);
    
    [headerView addSubview:label];
    return headerView;
}

- (void)updateStatus:(BOOL)succeeded endURL:(NSString *)endURL {
    if ([endURL isEqualToString:@"status"]) {
        urlOK = succeeded;
    } else if([endURL isEqualToString:@"checkAuth"]) {
        authOK = succeeded;
    }
}

- (void)validInput:(NSString *)endURL forCells:(NSArray *)tableCellIndexes dispatchGroup:(dispatch_group_t)group {
    dispatch_group_enter(group);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", GetBaseURL(), endURL]];
    SendRequest(@"GET", nil, url, ^(NSString *response) {
        // Change color depending on response
        dispatch_async(dispatch_get_main_queue(), ^{
            UIColor *color;
            if ([response isEqualToString:@"OK"]) {
                color = [UIColor greenColor];
                [self updateStatus:YES endURL:endURL];
            } else {
                color = [UIColor redColor];
                [self updateStatus:NO endURL:endURL];
            }
            
            color = [color colorWithAlphaComponent:0.3];
            for (int i = 0; i < tableCellIndexes.count; i++) {
                NSNumber *index = (NSNumber *)[tableCellIndexes objectAtIndex:i];
                [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0]].backgroundColor = color;
            }
        });
        
        // Restore color after 0.5 s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations: ^{
                for (int i = 0; i < tableCellIndexes.count; i++) {
                    NSNumber *index = (NSNumber *)[tableCellIndexes objectAtIndex:i];
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0]].backgroundColor = [UIColor clearColor];
                }

            } completion:^(BOOL finished) {
                dispatch_group_leave(group);
            }];
            
        });
    });
}

@end

