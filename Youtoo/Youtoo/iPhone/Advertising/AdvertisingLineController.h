//
//  AdvertisingLineController.h
//  ALN
//
//  Created by Ihor Xom on 9/24/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdvModel;

@interface AdvertisingLineController : UIViewController
{
	UIImageView *profileImage;
	UILabel *nameLabel;
    UILabel *messgLabel;
	AdvModel	*advModel;
    IBOutlet UIButton *profileImgBtn;
}
@property (nonatomic, retain) AdvModel *advModel;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet  UILabel *messgLabel;
@property (nonatomic, retain) IBOutlet UIButton *profileImgBtn;

- (void)applyModel;
- (IBAction) ShowAdView :(id) sender;

@end
