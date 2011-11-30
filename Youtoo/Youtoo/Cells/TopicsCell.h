//
//  ScheduleCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemModel;
@interface TopicsCell : UITableViewCell {
    
    ItemModel				*itemModel;
@private
	UILabel					*_questionLabel;	
	UILabel					*_showLabel;	
	UILabel					*_episodeLabel;
	
  
}
@property (nonatomic, retain) ItemModel *itemModel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)createCellLabels;
@end
