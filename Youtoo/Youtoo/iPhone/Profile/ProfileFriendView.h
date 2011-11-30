//
//  ProfileFriendView.h
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CSMAdvertisingProtocol.h"

//@class 	ASINetworkQueue;
@class ItemModel;
@class ItemStorage;

@interface ProfileFriendView : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, CSMAdvertisingProtocol>{
    
    UITableView *tableview;
    NSXMLParser					*rssParser;
    //NSMutableArray			*item;
    NSMutableArray			*imageArray;
	NSString					*currentElement;
    BOOL						isNetworkOperation;
    UILabel *creditsLbl;
    //ASINetworkQueue			*networkQueue;    
    UIActivityIndicatorView *activityIndicator;
    ItemModel *myItemModel;
    UILabel *friendName;
    UIButton *myFiends;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
    UIButton *follow;
    UIImageView *profileImage;
    
    UIButton *myFameSpotButton;
    UIButton *mySHoutButton;
    UIButton *myFavoriteButton;
    UIButton *myFriendButton;
    UILabel *friensStream;
    NSString *userid;
    MPMoviePlayerViewController *playerController;
    unsigned int currentOrientation;
    
    NSString *username;
    NSString *userimage;
    NSString *userpoints;
    
    int noOfCall;
}
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *userimage;
@property (nonatomic, retain) NSString *userpoints;

@property (nonatomic, retain) MPMoviePlayerViewController *playerController;
@property (nonatomic, retain) IBOutlet UILabel *friensStream;
@property (nonatomic, retain) IBOutlet UIButton *myFameSpotButton;
@property (nonatomic, retain) IBOutlet UIButton *mySHoutButton;
@property (nonatomic, retain) IBOutlet UIButton *myFavoriteButton;
@property (nonatomic, retain) IBOutlet UIButton *myFriendButton;

@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) IBOutlet     UIButton *follow;
@property (nonatomic, retain) IBOutlet     UILabel *friendName;
@property (nonatomic, retain) IBOutlet     UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UIButton *myFiends;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property BOOL isNetworkOperation;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) ItemStorage					*itemStorage;
//@property (nonatomic, retain) NSMutableArray *item;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property(nonatomic, retain) IBOutlet UILabel *creditLbl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
- (id)setupNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(NSString *) userID;
-(IBAction)follow;
-(IBAction) myFriends :(id) sender;
-(IBAction)profileFavorites;
-(IBAction)profileTickerShouts;
-(IBAction)profileFameSpot;
-(IBAction) followAction :(id) sender;
-(IBAction) backAction : (id) sender;
-(IBAction) buttonPressed: (id) sender;
-(void) updateUserCredentials;
-(void) callMyStream;
-(void) callProfileFrienView;

@end
