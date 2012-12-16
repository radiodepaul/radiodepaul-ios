//
//  AppHelpers.m
//  News
//
//  Created by Geoffrey Grosenbach on 8/26/09.
//  Copyright 2009 Topfunky Corporation. All rights reserved.
//

#import "AppHelpers.h"

void AlertWithMessageAndDelegate(NSString *message, id theDelegate)
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Radio DePaul" 
                                                  message:message
                                                 delegate:theDelegate 
                                        cancelButtonTitle:@"OK" 
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}

void AlertWithErrorAndDelegate(NSError *error, id theDelegate)
{
  NSString *message = [@"Sorry, " stringByAppendingString:[error localizedDescription]];
  AlertWithMessageAndDelegate(message, theDelegate);
}