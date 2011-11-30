//
//  VideoShowDetailsPage.h
//  Youtoo
//
//  Created by Subrahmanyam Chaturvedula's on 22/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemModel;
@interface VideoShowDetailsPage : UITableViewCell <UINavigationControllerDelegate>{
    ItemModel				*itemModel;
    ItemModel				*itemModel2;
@private
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
