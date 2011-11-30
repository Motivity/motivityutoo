//
//  VideosShowDetailPageCell.h
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideosShowDetailPageCell : UITableViewCell {
    
@private
	UILabel					*_titleLabel;	
	UIImageView				*iconImageView;
}
- (void)createCellLabels;


@end
