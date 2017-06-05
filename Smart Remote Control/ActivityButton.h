//
//  ActivityButton.h
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2017-06-05.
//  Copyright © 2017 Andreas Henriksson. All rights reserved.
//

#ifndef ActivityButton_h
#define ActivityButton_h

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "Group.h"

@interface ActivityButton : UIButton

@property (strong) Group *group;
@property (strong) Activity *activity;

+ (instancetype)buttonWithActivity:(Activity *)activity group:(Group *)group frame:(CGRect)frame;

@end


#endif /* ActivityButton_h */
