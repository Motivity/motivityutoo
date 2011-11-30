//
//  VideosDone.h
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CSMAdvertisingProtocol.h"

@class ItemModel;
@class ItemStorage;

@class YoutooAppDelegate;

@interface VideosDone : UIViewController <NSXMLParserDelegate, CSMAdvertisingProtocol>{
    
    ItemModel *myItemModel;
    
    NSXMLParser					*rssParser;
    ItemStorage					*itemStorage;
    NSMutableDictionary			*item;
    NSString					*currentElement;
    BOOL						isNetworkOperation;
      NSString *sendResult;
    UIImageView *videoThumbnail;
    UIImageView *profileImage;
    UILabel *profileName;
    NSString *videoPath;
    
    UIButton *likeBTnAction;
    UIButton *shareeBTnAction;
    UIButton *favoritesBTnAction;
    UIView *shareActionSheetView;
    YoutooAppDelegate *appDelegate;
    UIButton *twitterButton;
    UIButton *fbButton;
    UIButton *youtubeButton;
    UIButton *youtooButton;
    UIButton *googleButton;
    unsigned int currentOrientation;
    UILabel *titleLabl;
    MPMoviePlayerViewController *playerController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel*) myItemModel;
@property (nonatomic, retain) IBOutlet  UILabel *titleLabl;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain)  NSString *videoPath;
@property (nonatomic, retain) ItemStorage *itemStorage;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;

@property (nonatomic, retain) IBOutlet UIImageView *videoThumbnail;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UILabel *profileName;

@property (nonatomic, retain) IBOutlet UIButton *likeBTnAction;
@property (nonatomic, retain) IBOutlet  UIButton *shareeBTnAction;
@property (nonatomic, retain) IBOutlet UIButton *favoritesBTnAction;
@property (nonatomic, copy) NSString *sendResult;
-(IBAction) likeAction  :(id) sender;
-(IBAction) shareAction :(id) sender;
-(IBAction) favoritesction  :(id) sender;
-(IBAction) shareCancelAction : (id) sender;
-(IBAction) applyeShareVideoAction : (id) sender;

-(IBAction)tweetBtnAction:(id)sender;
-(IBAction)fbBtnAction:(id)sender;
-(IBAction)googleBtnAction:(id)sender;
-(IBAction)youtubeBtnAction:(id)sender;
-(IBAction)youtooBtnAction:(id)sender;
- (void)didRotate;
- (BOOL)canShowAdvertising;
-(IBAction) backAction : (id) sender;
-(IBAction)demoVideoAction;
-(void) reloadPage;
-(void) callProfileFrienView;

@end
