//
//  AdvertisingController.h
//  ALN
//
//  Created by Ihor Xom on 9/22/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdvModel;

@interface AdvertisingController : UIViewController < UIWebViewDelegate >
{
	id				delegateController;
	AdvModel		*model;
	
	@private
}
@property (nonatomic, retain) AdvModel *model;
@property (nonatomic, retain) IBOutlet UIWebView *advertisingView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) id delegateController;

- (IBAction)hideAction:(id)sender;
- (IBAction)jumpToAdvertisingSite:(id)sender;

@end
