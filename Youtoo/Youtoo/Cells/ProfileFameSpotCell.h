//
//  ProfileFameSpotCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 25/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileFameSpotCell : UITableViewCell {
@private
	UILabel					*_titleLabel;	
	UILabel					*likesLbl;
	UIImageView             *likesImgView;
	UILabel					*visitLbl;
    UIImageView             *visitImgView;
	UIImageView				*iconImageView;
    
}
-(void)createCellLabels;
@end
