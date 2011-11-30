//
//  YoutooAppDelegate.h
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class YoutooViewController;
@class Schedule, Videos, FloatingBar, BeOnTv, Profile, More, LogInScreen, RegisterScreen;
@class 	ASINetworkQueue;

@interface YoutooAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIImagePickerControllerDelegate, CSMAdvertisingProtocol,NSXMLParserDelegate>
{
    
    Schedule            *schdlViewContr;
    Videos              *videoViewContr;
    BeOnTv              *tvViewContr;
    Profile             *ProfileViewContr;
    More                *moreViewContr;
    LogInScreen         *logInViewContr;
    UITabBarController  *tabBarController;
    NSMutableArray      *localControllersArray;
    RegisterScreen      *regstrViewContr;
    UIImagePickerController *pickerController;
    UIButton            *beOnBtn;
    BOOL                 beOnClicked;
    BOOL				userIsRegistered;
    BOOL					userIsSignedIn;
    NSString              *loginName;
    NSString *passwordString;
     NSString				*userIDCode;
    NSTimeInterval mTimerSelectionForVideo;
    NSString				*currentVideoPath;
    NSInteger				networkingCount;
    BOOL                    bUploadHappening;
     BOOL bFbCheckEnabledByUser;
    FloatingBar				*floatingBar;
    UIViewController		*selectedController;
    NSString				*creditStr;
    BOOL bTwitterCheckEnabledByUser;
    BOOL bFacebookEnabled;
    BOOL bTwitterEnabled;
     NSMutableArray *showID;
    int selectedShow;
    NSString *epiQuestionID;
    
    BOOL bEditUserTwitter;
    BOOL bEditUserFB;
    BOOL bEditUserYoutube;
    BOOL bEditUserYoutoo;
    ASINetworkQueue			*networkQueue;
    NSString *userImage;
    NSString *userName;
    NSString				*currentElement;
    BOOL mobileIsChecked;  
    BOOL webIsChecked; 
    BOOL tvIsChecke;
    BOOL tweetIsChecked;  
    BOOL fbIsChecked; 
    BOOL googleIsChecke;
    BOOL youtubeIsChecked;
    BOOL youtooIsChecked;
    NSString *episodeName;
    UIToolbar	*toolBar;
    NSURL *albumSelectedImg;
    NSString *earnCredit;
    NSXMLParser				*rssParser;
    NSURL *videoURL;
    int getProfile;
    NSString *tickerUserID;
    
    NSString *tickerProfUsername;
    NSString *tickerProfUserImage;
    NSString *tickerProfUserPoints;
    
    NSString *titleString;
}
@property (nonatomic, copy)   NSString *tickerProfUsername;
@property (nonatomic, copy)   NSString *tickerProfUserImage;
@property (nonatomic, copy)   NSString *tickerProfUserPoints;
@property (nonatomic, retain)  NSString *titleString;
@property (nonatomic, retain) NSString *tickerUserID;
@property (nonatomic, readwrite) int getProfile;
@property (nonatomic, retain) NSURL *videoURL;
@property (nonatomic, readwrite) int selectedShow;
@property  BOOL beOnClicked;
@property BOOL userIsRegistered;
@property BOOL userIsSignedIn;
@property (nonatomic, copy) NSString *currentElement;
@property BOOL bEditUserTwitter;
@property BOOL bEditUserFB;
@property BOOL bEditUserYoutube;
@property BOOL bEditUserYoutoo;
@property BOOL youtubeIsChecked;
@property BOOL youtooIsChecked;
@property (nonatomic, retain) NSURL *albumSelectedImg;
@property (nonatomic, retain)   NSString              *loginName;
@property (nonatomic, copy)   NSString              *userName;
@property (nonatomic, retain)   NSString              *passwordString;
@property (nonatomic, retain)  IBOutlet UIWindow *window;
@property (nonatomic, retain)  IBOutlet YoutooViewController *viewController;
@property (nonatomic, retain)  Schedule *schdlViewContr;
@property (nonatomic, retain)  Videos *videoViewContr;
@property (nonatomic, retain)  BeOnTv *tvViewContr;
@property (nonatomic, retain)  Profile *ProfileViewContr;
@property (nonatomic, retain)  More *moreViewContr;
@property (nonatomic, retain)  UITabBarController *tabBarController;
@property (nonatomic, retain)  LogInScreen *logInViewContr;
@property (nonatomic, retain)  RegisterScreen *regstrViewContr;
@property (nonatomic, retain)  UIImagePickerController *pickerController;
@property (nonatomic, copy) NSString *userIDCode;
@property (assign) NSTimeInterval mTimerSelectionForVideo;
@property (nonatomic, retain) NSString *currentVideoPath;
@property BOOL bUploadHappening;
@property (nonatomic, readwrite) BOOL bFbCheckEnabledByUser;
@property (nonatomic, retain) FloatingBar *floatingBar;
@property (nonatomic, assign) UIViewController *selectedController;
@property (nonatomic, copy) NSString *creditStr;
@property (nonatomic, copy) NSString *earnCredit;
@property (nonatomic, readwrite) BOOL bTwitterCheckEnabledByUser;
@property (nonatomic, readwrite) BOOL bFacebookEnabled;
@property (nonatomic, readwrite) BOOL bTwitterEnabled;
@property (nonatomic, retain)  NSMutableArray *showID;
@property (nonatomic, copy)  NSString *userImage;
@property (nonatomic, retain)  NSString *epiQuestionID;
@property (nonatomic, retain)  NSString *episodeName;
@property(nonatomic, retain) UIToolbar	*toolBar;
@property   BOOL mobileIsChecked;
@property   BOOL webIsChecked; 
@property   BOOL tvIsChecke;
@property BOOL isPostOperation;
@property   BOOL tweetIsChecked; 
@property   BOOL fbIsChecked;
@property BOOL googleIsChecke;
@property (nonatomic, retain) NSXMLParser *rssParser;

-(void)fameSoptAct:(id)sender;
-(void)tickerSpotAct:(id)sender;
-(void)setupTabController;
- (void)reportError:(NSString *)aTitle description:(NSString *)aDescription;
- (void)removeLoginDataPlistItems;
-(void) SaveLoginData;
-(NSString *) readLoginPassword;
-(NSString *) readUserName ;
-(void) LoginOrLaunchInitialScreen:(BOOL )fromAppDidLaunch;
- (void)didStartNetworking;
- (void)didStopNetworking;
-(NSString *) readUserID;
- (NSString*)encodeURL:(NSString *)string;
- (BOOL) connectedToNetwork :(NSString*) inURL;
// Ad ticker
- (void)didStopNetworking;
- (BOOL)canShowAdvertising;
- (void)showAdvancedLine:(UIView *)advLine;
- (void)hideAdvancedLine:(UIView *)advLine;
- (void)changeAdvancedLine:(UIView *)prevLine toLine:(UIView *)newLine;
- (void)startAdvertisingBar;
- (void)stopAdvertisingBar;
- (BOOL)canShowAdvertising;
- (BOOL)isShownAdvertising;
- (void)changeAdvancedLine:(UIView *)prevLine toLine:(UIView *)newLine;
- (void)showAdvancedLine:(UIView *)advLine;
- (void)hiddingAnimationDidStop:(NSString *)animationID 
                       finished:(NSNumber *)finished context:(void *)context;
-(void) authenticateAtLaunchIfNeedBe;
-(void)getUserProfile;
-(void) beOnTvBtnAct:(id)sender;
@end
