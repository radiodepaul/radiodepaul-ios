//
//  ScheduleSlot.h
//  Radio DePaul
//
//  Created by Devon Blandin on 11/13/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Show;

@interface ScheduleSlot : NSObject {
    NSNumber *identifier;
    NSString* quarter;
    NSString* start_time;
    NSString* end_time;
    Show* show;
}


@property (nonatomic, retain) NSNumber* identifier;
@property (nonatomic, retain) NSString* quarter;
@property (nonatomic, retain) NSString* start_time;
@property (nonatomic, retain) NSString* end_time;
@property (nonatomic, retain) Show* show;

@end