//
//  ProfileFrndCcell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 08/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;
@interface ProfileFrndCcell : UITableViewCell {
    
    ItemModel				*itemModel;
@private
	UILabel					*_titleLabel;	
	UILabel					*subTitleLbl;	
	UILabel					*_timeLabel;
	UIImageView				*iconImageView;
    
}
@property (nonatomic, retain) ItemModel *itemModel;
- (void)createCellLabels;


@end
