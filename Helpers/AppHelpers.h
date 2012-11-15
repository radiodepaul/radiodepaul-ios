//
//  AppHelpers.h
//  News
//
//  Created by Geoffrey Grosenbach on 8/26/09.
//  Copyright 2009 Topfunky Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

void AlertWithMessageAndDelegate(NSString *message, id theDelegate);
void AlertWithErrorAndDelegate(NSError *error, id theDelegate);