//
//  ProfileController.h
//  ALN
//
//  Created by Ihor Xom on 8/29/10.
//  Copyright 2010 americanlifetv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class AdvModel;

@interface ProfileController : UIViewController < NSXMLParserDelegate, UIAlertViewDelegate, CSMAdvertisingProtocol >
{
	id						delegateController;
	AdvModel				*model;
    
	@private
	NSXMLParser				*rssParser;
	NSString				*currentElement;
	UIActivityIndicatorView *activityIndicator;	
	UIImageView				*profilePhoto;
	UILabel					*nameLabel;
	UILabel					*birthdayLabel;
	UILabel					*cityLabel;
	UILabel					*movieGenreLabel;
	UILabel					*movieListLabel;
	UILabel					*interestsLabel;
	UILabel					*movieGenreTitle;
	UILabel					*moviesTitle;
}
@property (nonatomic, retain) AdvModel *model;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, assign) id delegateController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;	
@property (nonatomic, retain) IBOutlet UIImageView *profilePhoto;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *birthdayLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *movieGenreLabel;
@property (nonatomic, retain) IBOutlet UILabel *movieListLabel;
@property (nonatomic, retain) IBOutlet UILabel *interestsLabel;
@property (nonatomic, retain) IBOutlet UILabel *movieGenreTitle;
@property (nonatomic, retain) IBOutlet UILabel *moviesTitle;

- (IBAction)hideAction:(id)sender;
- (BOOL)canShowAdvertising;

@end
