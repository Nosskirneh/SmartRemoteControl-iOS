//
//  Utilities.h
//  Smart Remote Control
//
//  Created by Andreas Henriksson on 2016-12-10.
//  Copyright © 2016 Andreas Henriksson. All rights reserved.
//

#ifndef Utilities_h
#define Utilities_h

#import "Group.h"

#define URL_KEY @"URL_KEY"
#define USER_KEY @"USER_KEY"
#define PASS_KEY @"PASS_KEY"
#define COMMANDS_KEY @"COMMANDS_KEY"

NSString *GetBaseURL();
void SetBaseURL(NSString *);
NSString *GetUser();
void SetUser(NSString *);
NSString *GetPassword();
void SetPassword(NSString *);
NSDictionary *GetCommandList();
void SetCommandList(NSDictionary *);

void SendRequest(NSString *method, NSString *body, NSURL *url, void (^callback)(NSString *response));
void LoadCommands(void (^callback)(NSArray<Group *> *groups));

#endif /* Utilities_h */
