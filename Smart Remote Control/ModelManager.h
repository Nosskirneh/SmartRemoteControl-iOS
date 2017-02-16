//
//  ModelManager.h
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-30.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"

#define GROUPS_UPDATED_EVENT @"GROUPS_UPDATED_EVENT"

@interface ModelManager : NSObject

@property (strong, nonatomic, readonly) NSArray<Group *> *groups;

+ (ModelManager *)sharedInstance;

- (void)getGroups;

@end
