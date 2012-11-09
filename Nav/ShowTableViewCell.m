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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowPhoto:(NSString*)showPhotoURL {
	[self.imageView setImageWithURL:[NSURL URLWithString:showPhotoURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder_thumb"]];
}


@end
