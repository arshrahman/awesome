//
//  customCell1.m
//  ToTe
//
//  Created by user on 19/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "customCell1.h"

@implementation customCell1

@synthesize customCellItemName;
@synthesize customCellItemPrice;
@synthesize customCellItemCategory;
@synthesize Star1;
@synthesize Star2;
@synthesize Star3;
@synthesize Star4;
@synthesize Star5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"customCell1" owner:self options:nil];
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
