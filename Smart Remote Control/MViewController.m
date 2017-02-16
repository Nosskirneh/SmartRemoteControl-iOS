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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGroupsUpdatedNotification:) name:GROUPS_UPDATED_EVENT object:nil];
    
    [[ModelManager sharedInstance] getGroups];
}

- (void)handleGroupsUpdatedNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ModelManager sharedInstance].groups.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Group *group = [ModelManager sharedInstance].groups[section];
    return group.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Group *group = [ModelManager sharedInstance].groups[section];
    return group.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"tableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    Group *group = [ModelManager sharedInstance].groups[indexPath.section];
    Activity *activity = group.activities[indexPath.row];
    
    cell.textLabel.text = activity.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Group *group = [ModelManager sharedInstance].groups[indexPath.section];
    Activity *activity = group.activities[indexPath.row];
    NSString *body = [NSString stringWithFormat:@"name=%@&group=%@", activity.name, group.name];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/command", GetBaseURL()]];
    
    SendRequest(@"POST", body, url, ^(NSString *response) {
        // Change color depending on response
        UIColor *previousColor = [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIColor *color;
            if ([response isEqualToString:@"OK"]) {
                color = [UIColor greenColor];
            } else {
                color = [UIColor redColor];
            }
            
            color = [color colorWithAlphaComponent:0.3];
            [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = color;
        });
        
        // Restore color after 0.5 s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations: ^{
                [self.tableView cellForRowAtIndexPath:indexPath].backgroundColor = previousColor;
            }];
            
        });
    });
}

// Implement following two functions to add buttons
// Should be called from viewDidLoad and SettingsViewController (upon save buton)
//- (void)CreateButton:(NSString *)text xPos:(NSInteger)x yPos:(NSInteger)y {
//    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [but addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [but setFrame:CGRectMake(x, y, 140, 46)];
//    [but setTitle:text forState:UIControlStateNormal];
//    [but.layer setBorderWidth:1.0];
//    [but.layer setBorderColor:[[UIColor grayColor] CGColor]];
//    [but.layer setCornerRadius:6];
//    // what is the difference between ^ and but.layer.cornerRadius = 6; ?
//    but.clipsToBounds = YES;
//    [but setExclusiveTouch:YES];
//    // add button tag
//    
//    [self.view addSubview:but];
//}

@end
