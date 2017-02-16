//
//  Group.h
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-30.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"

@interface Group : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray<Activity *> *activities;

@end
