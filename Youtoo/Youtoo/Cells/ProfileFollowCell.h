//
//  ProfileFollowCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileFollowCell : UITableViewCell {
   
@private
	UILabel					*_titleLabel;	
    UIImageView				*iconImageView;

}
- (void)createCellLabels;
@end
