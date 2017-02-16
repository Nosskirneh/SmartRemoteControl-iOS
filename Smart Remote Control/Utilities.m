//
//  Utilities.m
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-10.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"

NSString *GetBaseURL() {
    return [[NSUserDefaults standardUserDefaults] stringForKey:URL_KEY];
}

void SetBaseURL(NSString *url) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:URL_KEY];
}

NSString *GetUser() {
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_KEY];
}

void SetUser(NSString *user) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:USER_KEY];
}

NSString *GetPassword() {
    return [[NSUserDefaults standardUserDefaults] stringForKey:PASS_KEY];
}

void SetPassword(NSString *pass) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pass forKey:PASS_KEY];
}

NSDictionary *GetCommandList() {
    return [[NSUserDefaults standardUserDefaults] objectForKey:COMMANDS_KEY];
}

void SetCommandList(NSDictionary *cmds) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cmds forKey:COMMANDS_KEY];
}

void SendRequest(NSString *method, NSString *body, NSURL *url, void (^callback)(NSString *response)) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:method];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", GetUser(), GetPassword()];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (callback != nil) {
            callback(newStr);
        }
    }];
    
    [postDataTask resume];
}


void LoadCommands(void (^callback)(NSArray<Group *> *groups)) {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/commands", GetBaseURL()]];
    SendRequest(@"GET", nil, url, ^(NSString *response) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        
        if (![jsonObject isEqual:GetCommandList()]) { // If nothing has changed, do nothing
            SetCommandList(jsonObject); // Save array
        }
            
        NSMutableArray<Group *> *groups = [NSMutableArray new]; // [[NSArray alloc] init]
        NSArray *groupsData = jsonObject[@"groups"];
        for (NSDictionary *groupData in groupsData) {
            Group *group = [Group new];
            group.name = groupData[@"name"];
            NSArray *activitiesData = groupData[@"activities"];
            for (NSDictionary *activityData in activitiesData) {
                Activity *activity = [Activity new];
                NSArray *codes = activityData[@"codes"];
                NSString *name = activityData[@"name"];
                activity.name = name;
                for (NSDictionary *codeData in codes) {
                    Code *code = [Code new];
                    NSString *channel = codeData[@"channel"];
                    NSString *data = codeData[@"data"];
                    code.channel = channel;
                    code.data = data;
                    [activity.codes addObject:code];
                }
                [group.activities addObject:activity];
            }
            [groups addObject:group];
        }
        
        callback(groups);
    });
}
