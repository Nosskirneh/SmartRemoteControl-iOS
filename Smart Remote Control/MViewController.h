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
#import "ActivityButton.h"
#import "UIView+Toast.h"

#define buttonWidth 122
#define buttonHeight 46
#define TOAST_MAX_WIDTH_PORTRAIT 100
#define TOAST_MAX_WIDTH_LANDSCAPE 80

@interface MViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *view;
@property (strong, nonatomic) UIWindow *toastWindow;
@property (nonatomic, readwrite) int amountOfToastVisible;
@property (nonatomic, readwrite, strong) UIRefreshControl *refreshControl;

@end
