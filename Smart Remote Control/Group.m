//
//  Group.m
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-30.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import "Group.h"

@implementation Group

- (id)init {
    self = [super init];
    
    _activities = [NSMutableArray new];
    
    return self;
}

@end
