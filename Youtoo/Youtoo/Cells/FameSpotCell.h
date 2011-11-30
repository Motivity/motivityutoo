//
//  FameSpotCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;
@interface FameSpotCell : UITableViewCell {
    ItemModel				*itemModel;
    ItemModel				*itemModel2;
@private
	UILabel					*_titleLabel;	
	UIImageView				*iconImageView;
    
    UILabel					*lbl1;	
	UILabel					*lbl2;	
	UIButton					*btn1;
	UIButton				*btn2;
    int currRow;
    NSUInteger dataCount;
    id					delegateController;
}
@property (nonatomic, retain) ItemModel *itemModel;
@property (nonatomic, retain) ItemModel *itemModel2;
@property (nonatomic, assign) id delegateController;

- (void)setItemModel2:(ItemModel *)aModel;

- (void)createCellLabels :(NSUInteger) storageCount;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(IBAction) buttonPressed: (id) sender;
-(void) getCurrRow :(int) row :(NSUInteger) storageCount;
@end
