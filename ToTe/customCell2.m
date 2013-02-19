//
//  customCell2.m
//  ToTe
//
//  Created by user on 19/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "customCell2.h"

@implementation customCell2

@synthesize customCellItemName;
@synthesize customCellItemPrice;
@synthesize customCellItemCategory;
@synthesize Star1;
@synthesize Star2;
@synthesize Star3;
@synthesize Star4;
@synthesize Star5;
@synthesize checkBox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"customCell2" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

