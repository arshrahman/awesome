//
//  customCell.h
//  ToTe
//
//  Created by user on 21/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *customCellItemName;
@property (strong, nonatomic) IBOutlet UILabel *customCellItemPrice;
@property (strong, nonatomic) IBOutlet UILabel *customCellItemCategory;
@property (weak, nonatomic) IBOutlet UIImageView *Star5;
@property (weak, nonatomic) IBOutlet UIImageView *Star4;
@property (weak, nonatomic) IBOutlet UIImageView *Star3;
@property (weak, nonatomic) IBOutlet UIImageView *Star2;
@property (weak, nonatomic) IBOutlet UIImageView *Star1;


@end
