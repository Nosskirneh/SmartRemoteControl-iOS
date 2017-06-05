//
//  ActivityButton.m
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2017-06-05.
//  Copyright © 2017 Andreas Henriksson. All rights reserved.
//

#import "ActivityButton.h"

@implementation ActivityButton

+ (instancetype)buttonWithActivity:(Activity *)activity group:(Group *)group frame:(CGRect)frame {
    ActivityButton *btn = [self buttonWithType:UIButtonTypeCustom];
    
    [btn setFrame:frame];
    btn.group = group;
    btn.activity = activity;
    [btn setTitle:activity.name forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    [btn.layer setBorderColor:[[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0] CGColor]];
    btn.layer.borderWidth = 1;
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    
    return btn;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0];
        [self.layer setBorderColor:[[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0] CGColor]];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setBorderColor:[[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0] CGColor]];
    }
}

@end
