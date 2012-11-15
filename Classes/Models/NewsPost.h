//
//  NewsPost.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/14/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsPost : NSObject {
    NSNumber *identifier;
    NSString *headline;
    NSString *snippet;
    NSString *content;
    NSString *published_at;
}

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *headline;
@property (nonatomic, retain) NSString *snippet;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *published_at;

@end
