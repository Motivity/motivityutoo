//
//  ProfileCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;

@interface ProfileRealStreamCell : UITableViewCell {
    
@private
	UITextView					*_showQuestionLabel;//*_titleLabel;	
	UILabel				*_showNameLbl; //*iconImageView;
    UIImageView         *_iconImageView;
    ItemModel				*itemModel;
    UIButton *_playButton;
    id delegateController;
    int currRow;
}
-(void)createCellLabels;
@property (nonatomic, retain) ItemModel *itemModel;
@property (nonatomic, assign) id delegateController;
-(void) getCurrRow :(int) row;
-(IBAction) buttonPressed: (id) sender;

@end
