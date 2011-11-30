//
//  ProfileFavoritesCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;
@interface ProfileFavoritesCell : UITableViewCell {
    
@private
	UITextView					*_titleLabel;	
	UILabel					*subTitle;
	UILabel					*visitLbl;
    UILabel                 *dateLbl;
	UIImageView				*iconImageView;
    ItemModel				*itemModel;
    
}
-(void)createCellLabels;
@property (nonatomic, retain) ItemModel *itemModel;

@end
