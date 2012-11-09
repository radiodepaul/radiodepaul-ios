//
//  ShowTableViewCell.m
//  Radio DePaul
//
//  Created by Devon Blandin on 11/8/12.
//  Copyright (c) 2012 Devon Blandin. All rights reserved.
//

#import "ShowTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation ShowTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
	
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowPhoto:(NSString*)showPhoto {
	//self.imageView.image = [NSURL URLWithString:showPhoto];
}


@end
