//
//  MViewController.h
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-16.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>
#import "ModelManager.h"

@interface MViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
