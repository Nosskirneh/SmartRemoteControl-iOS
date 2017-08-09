//
//  ModelManager.m
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-30.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import "ModelManager.h"
#import "Utilities.h"

@implementation ModelManager

+ (ModelManager *)sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (id)init {
    self = [super init];
    
    _groups = [NSArray new];
    
    return self;
}

- (void)getGroups {
    LoadCommands(^(NSArray<Group *> *groups) {
        _groups = groups;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GROUPS_UPDATED_EVENT
                                                            object:nil];
    });
}

@end
