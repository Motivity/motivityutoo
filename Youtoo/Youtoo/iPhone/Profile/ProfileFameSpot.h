//
//  ProfileFameSpot.h
//  Youtoo
//
//  Created by PRABAKAR MP on 25/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSMAdvertisingProtocol.h"
#import <MediaPlayer/MediaPlayer.h>
@class 	ASINetworkQueue;
@class ItemModel;
@class ItemStorage;

@interface ProfileFameSpot : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, CSMAdvertisingProtocol> {
    
    UITableView *tableview;
    NSXMLParser					*rssParser;
    NSMutableDictionary			*item;
    NSMutableArray			*imageArray;
	NSString					*currentElement;
    BOOL						isNetworkOperation;
    UILabel *creditsLbl;
    ASINetworkQueue			*networkQueue;    
    UIActivityIndicatorView *activityIndicator;
    NSURL *url;
    NSMutableArray *videoURL;
     MPMoviePlayerController *videoPlayer;
    NSMutableArray * btnTag;
    ItemModel *myItemModel;
    ItemStorage					*itemStorage;
    NSTimer *reloadTImer;
    UILabel *profileName;
    UIImageView *profileImage;
    UILabel *creditLbl;
    BOOL myOwnCalled;
    
    unsigned int currentOrientation;
    MPMoviePlayerViewController *playerController;
     UIButton *_playButton;
    UILabel *videoTxtFld ;
    NSString *userid;
}
@property (nonatomic, retain) ItemStorage *itemStorage;
@property BOOL myOwnCalled;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, retain) IBOutlet     UITableView *tableview;
@property (nonatomic, retain) NSMutableArray * btnTag;
@property (nonatomic, retain) IBOutlet UILabel *profileName;
@property (nonatomic, retain) IBOutlet  UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet   UILabel *creditLbl;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property BOOL isNetworkOperation;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain)  NSMutableArray *videoURL;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
- (id)setupFSNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(BOOL) myOwn :(NSString *) userID;
-(IBAction)PlayVideo :(id) sender;

-(void) reloadScreen:(NSTimer*)timer;
-(IBAction) backAction : (id) sender;
- (void)showAlertNoConnection:(NSError *)anError;
-(void) callProfileFrienView;
- (void)reloadTable:(NSTimer*)timer;

@end
