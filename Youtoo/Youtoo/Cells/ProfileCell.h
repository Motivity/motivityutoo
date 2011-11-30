//
//  ProfileCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;

@interface ProfileCell : UITableViewCell {
    
@private
	UILabel					*_showTimeLabel;//*_titleLabel;	
	UILabel				*_showNameLbl; //*iconImageView;
    UIImageView         *_iconImageView;
    ItemModel				*itemModel;
    int getCurrRow;
    UILabel				*_onAirLbl;
}
- (void)createCellLabels :(int) currRow;
@property (nonatomic, retain) ItemModel *itemModel;
@property (nonatomic, readwrite) int getCurrRow;
-(void) setCurrRow :(int) currrow;
@end
