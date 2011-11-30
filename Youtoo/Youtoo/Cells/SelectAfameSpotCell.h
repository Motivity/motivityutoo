//
//  SelectAfameSpotCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;
@interface SelectAfameSpotCell : UITableViewCell {
    ItemModel				*itemModel; 
@private
	UILabel					*_titleLabel;	
	UILabel					*_questionLabel;	
	UIImageView				*iconImageView;
}
- (void)createCellLabels;
@property (nonatomic, retain) ItemModel *itemModel;
@end
