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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setSectionInset:UIEdgeInsetsMake(30, 0, 30, 0)];
    self.view = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self.view setDataSource:self];
    [self.view setDelegate:self];
    
    [self.view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGroupsUpdatedNotification:) name:GROUPS_UPDATED_EVENT object:nil];

    [[ModelManager sharedInstance] getGroups];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Group *group = [ModelManager sharedInstance].groups[section];
    return (group.activities.count + 0.5) / 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [ModelManager sharedInstance].groups.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    Group *group = [ModelManager sharedInstance].groups[indexPath.section];
    
    Activity *activity;
    ActivityButton *button;
    
    // First button
    activity = group.activities[indexPath.row * 2];
    button = [ActivityButton buttonWithActivity:activity
                                          group:group
                                          frame:CGRectMake([[UIScreen mainScreen] bounds].size.width/4 - buttonWidth/2, 0, buttonWidth, buttonHeight)];
    
    [button addTarget:self
               action:@selector(buttonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:button];
    
    // Second button
    activity = group.activities[indexPath.row * 2 + 1];
    button = [ActivityButton buttonWithActivity:activity
                                          group:group
                                          frame:CGRectMake(3 * [[UIScreen mainScreen] bounds].size.width/4 - buttonWidth/2, 0, buttonWidth, buttonHeight)];
    
    [button addTarget:self
               action:@selector(buttonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:button];

    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableView == nil) {
            reusableView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        }
        
        UILabel *label;
        if (reusableView.subviews.count == 0) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, reusableView.frame.size.width, 44)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [label.font fontWithSize:25];
            [reusableView addSubview:label];
        } else {
            label = (UILabel *)reusableView.subviews[0];
        }
        
        label.text = [ModelManager sharedInstance].groups[indexPath.section].name;
        return reusableView;
    }

    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, buttonHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
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
        [self.view reloadData];
    });
}

@end
