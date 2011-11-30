//
//  ScheduleEpisodeDetail.h
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"
#import "LocationGetter.h"
@class ItemModel;
@class ItemStorage;

@interface ScheduleEpisodeDetail : UIViewController <CSMAdvertisingProtocol, NSXMLParserDelegate>{
    
    IBOutlet UIImageView *showEpiImage;
    IBOutlet UILabel *showEpiTitle;
    IBOutlet UILabel *showEpiBriefDesc;
    IBOutlet UITextView *showEpiQuestion;
    IBOutlet UITextView *epiDescription;
    
    NSString *epiBriefDescStr;
    NSString *epiTitleStr;
    NSString *epiQuestStr;
    NSString *epiDetailDescStr;
    NSString *epiThumnailImg;
    NSString *epiQuesIDtStr;
    
    CLLocation                  *lastKnownLocation;
    ItemModel *myItemModel;
    
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
    NSString					*currentElement;
    BOOL						isNetworkOperation;
    UILabel *dateLbl;
    
    UIButton *fameSpotButton;
    UIButton *socialShoutButton;
    UIActivityIndicatorView *activityIndicator;
    UIButton *checkInButton;
    UIButton *likeButton;
    UIButton *favoritesButton;
    NSString *sendResult;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *epiQuesIDtStr;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) IBOutlet UIButton *fameSpotButton;
@property (nonatomic, retain) IBOutlet UIButton *socialShoutButton;
@property (nonatomic, retain) IBOutlet UIButton *checkInButton;
@property (nonatomic, retain) IBOutlet UIButton *favoritesButton;
@property (nonatomic, retain) IBOutlet UIButton *likeButton;
@property (nonatomic, retain) IBOutlet UIImageView *showEpiImage;
@property (nonatomic, retain) IBOutlet UILabel *showEpiTitle;
@property (nonatomic, retain) IBOutlet UILabel *showEpiBriefDesc;
@property (nonatomic, retain) IBOutlet UITextView *epiDescription;
@property (nonatomic, retain) IBOutlet UITextView *showEpiQuestion;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) CLLocation *lastKnownLocation;
@property (nonatomic, retain) NSString *epiBriefDescStr;
@property (nonatomic, retain) NSString *epiTitleStr;
@property (nonatomic, retain) NSString *epiQuestStr;
@property (nonatomic, retain) NSString *epiDetailDescStr;
@property (nonatomic, retain) NSString *epiThumnailImg;
@property (nonatomic, retain) IBOutlet     UILabel *dateLbl;

- (BOOL)canShowAdvertising;
- (void)updateView;
-(IBAction) fameSpotAction :(id) sender;
-(IBAction) socialShoutAction :(id) sender;
-(IBAction) checkInAction :(id) sender;
-(IBAction) likeAction :(id) sender;
-(IBAction) favoritesAction :(id) sender;
-(IBAction) backAction : (id) sender;
-(void) callProfileFrienView;
-(IBAction) followAction :(id) sender;

@end
