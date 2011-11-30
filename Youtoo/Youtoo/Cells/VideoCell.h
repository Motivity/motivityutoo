//
//  VideoCell.h
//  Youtoo
//
//  Created by CorpusMobileLabs on 27/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemModel;

@interface VideoCell : UITableViewCell {
    
    ItemModel				*itemModel;
@private
	UILabel					*_titleLabel;
	UILabel					*_countLabel;
	UIImageView				*iconImageView;
    UIButton *btn;
    UILabel *episodeName;
}
@property (nonatomic, retain) ItemModel *itemModel;
- (void)createCellLabels;


@end
