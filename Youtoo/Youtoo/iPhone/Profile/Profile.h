//
//  Profile.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"
#import <MediaPlayer/MediaPlayer.h>

//@class 	ASINetworkQueue;
@class ItemStorage;
@interface Profile : UIViewController<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, CSMAdvertisingProtocol> {
    
    UITableView *tableview;
   
    //ASINetworkQueue			*networkQueue;
    UIActivityIndicatorView *activityIndicator;
    NSString				*sendResult;
    NSXMLParser				*rssParser;
    BOOL isNetworkOperation;
    NSString				*currentElement;
    UILabel *creditsLbl;
    UIImageView *profileImage;
    ItemStorage					*itemStorage;
    UILabel *profileName;
    NSMutableDictionary			*item;
    NSString *profNameStr;
     NSString *profImagePAthStr;
    NSString *creditStr;
    int myStreamCalled;
    UIButton *editButton;
    
    UIButton *myFameSpotButton;
    UIButton *mySHoutButton;
    UIButton *myFavoriteButton;
    UIButton *myFriendButton;
    NSTimer *reloadTImer;
    BOOL bGetProfile;
    MPMoviePlayerViewController *playerController;
    unsigned int currentOrientation;
}
@property BOOL bGetProfile;
@property (nonatomic, retain) IBOutlet UIButton *myFameSpotButton;
@property (nonatomic, retain) IBOutlet UIButton *mySHoutButton;
@property (nonatomic, retain) IBOutlet UIButton *myFavoriteButton;
@property (nonatomic, retain) IBOutlet UIButton *myFriendButton;
@property (nonatomic, retain) MPMoviePlayerViewController *playerController;
@property (nonatomic, retain) IBOutlet     UIButton *editButton;;
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) NSString *profNameStr;
@property (nonatomic, retain) NSString *profImagePAthStr;
@property (nonatomic, retain) NSString *creditStr;
@property (nonatomic, retain) NSMutableDictionary *item;
@property BOOL isNetworkOperation;
@property (nonatomic, readwrite) int myStreamCalled;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property(nonatomic, retain)IBOutlet  UILabel *creditsLbl;
@property(nonatomic, retain)IBOutlet UIImageView *profileImage;
@property(nonatomic, retain)IBOutlet   UILabel *profileName;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, retain)  IBOutlet  UIActivityIndicatorView *activityIndicator;

-(IBAction)editAct;
-(IBAction)profileFameSpot;
-(IBAction)profileTickerShouts;
-(IBAction)profileFavorites;
-(IBAction)profileFrnds;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
- (void)advertisingDidShow;
- (void)reloadPage;
-(void) myStreamAction;
-(void) updateUserCredentials;
-(void) getProfileInfo;
- (void)grabAuthProfileInfoBackground;
-(void) authAgain;
- (void)didStopLoadData;
-(void) callProfileFrienView;
-(IBAction)PlayVideo :(UIButton *) sender;
-(IBAction) buttonPressed: (id) sender;
- (void)didEndParsing;
- (void)reloadTable:(NSTimer*)timer;

@end
