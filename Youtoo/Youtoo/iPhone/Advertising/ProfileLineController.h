//
//  ProfileLineController.h
//  ALN
//
//  Created by Ihor Xom on 9/23/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdvModel;

@interface ProfileLineController : UIViewController <UINavigationControllerDelegate>
{
	AdvModel	*advModel;
    UIView *backImgView;
    IBOutlet UINavigationController *navigationController;
    UIButton *backButton;
}
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIView *backImgView;
@property (nonatomic, retain) AdvModel *advModel;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) UINavigationController *navigationController;

- (void)applyModel;
- (IBAction) tickerAdBackButtonAction;

@end
