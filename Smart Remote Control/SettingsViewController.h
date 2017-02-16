//
//  SettingsViewController.h
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-11-29.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface SettingsViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

#define URL_CELL  0
#define USER_CELL 1
#define PASS_CELL 2

@end
