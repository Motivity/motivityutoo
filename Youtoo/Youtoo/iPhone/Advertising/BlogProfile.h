//
//  BlogProfile.h
//  ALN
//
//  Created by Ihor Xom on 10/17/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdvModel, ItemModel;

@interface BlogProfile : UIViewController < NSXMLParserDelegate, UIAlertViewDelegate >
{
	AdvModel				*model;
	ItemModel				*itemModel;
	
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
@property (nonatomic, retain) ItemModel *itemModel;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSXMLParser *rssParser;
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

@end
