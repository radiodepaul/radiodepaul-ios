//
//  Show.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/13/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject {
    NSNumber* identifier;
    NSString* title;
    NSString* genres;
    NSString* short_description;
    NSString* long_description;
    NSString* facebook;
    NSString* twitter;
    NSString* website;
    NSURL* show_url;
    NSURL* photo_thumb;
    NSURL* photo_small;
    NSURL* photo_medium;
    NSURL* photo_large;
    NSArray* hosts;
}

@property (nonatomic, retain) NSNumber* identifier;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* genres;
@property (nonatomic, retain) NSString* short_description;
@property (nonatomic, retain) NSString* long_description;
@property (nonatomic, retain) NSString* facebook;
@property (nonatomic, retain) NSString* twitter;
@property (nonatomic, retain) NSString* website;
@property (nonatomic, retain) NSURL* show_url;
@property (nonatomic, retain) NSURL* photo_thumb;
@property (nonatomic, retain) NSURL* photo_small;
@property (nonatomic, retain) NSURL* photo_medium;
@property (nonatomic, retain) NSURL* photo_large;
@property (nonatomic, retain) NSArray* hosts;

@end
