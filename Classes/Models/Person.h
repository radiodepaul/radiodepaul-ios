//
//  Person.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/14/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Person : NSObject {
    NSNumber *identifier;
    NSString *fullName;
    NSString *nickname;
    NSArray *shows;
    NSString *bio;
    NSString *influences;
    NSString *major;
    NSString *hometown;
    NSString *class_year;
    NSString *facebook;
    NSString *twitter;
    NSString *linkedin;
    NSString *website;
    NSString *person_url;
    NSURL *photo_thumb;
    NSURL *photo_small;
    NSURL *photo_medium;
    NSURL *photo_large;
}

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSArray *shows;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *influences;
@property (nonatomic, retain) NSString *major;
@property (nonatomic, retain) NSString *hometown;
@property (nonatomic, retain) NSString *class_year;
@property (nonatomic, retain) NSString *facebook;
@property (nonatomic, retain) NSString *twitter;
@property (nonatomic, retain) NSString *linkedin;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *person_url;
@property (nonatomic, retain) NSURL *photo_thumb;
@property (nonatomic, retain) NSURL *photo_small;
@property (nonatomic, retain) NSURL *photo_medium;
@property (nonatomic, retain) NSURL *photo_large;

@end
