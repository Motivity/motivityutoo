//
//  ProfileCellSecondTab.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;

@interface ProfileCellSecondTab : UITableViewCell {
    
@private
	UIButton *btn1;	
	UIButton *btn2;
    UILabel *lbl1;
    UILabel *lbl2;
    
    int row;
    int incremBtnDataVal;
    int incremLblDataVal;
}
-(void)createCellLabels;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier :(int) indexPathRow;

@property (nonatomic, retain) ItemModel *itemModel;
-(IBAction) buttonPressed: (id) sender;

@end
