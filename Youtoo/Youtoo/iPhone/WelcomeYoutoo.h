//
//  WelcomeYoutoo.h
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class 	ASINetworkQueue;
@interface WelcomeYoutoo : UIViewController<NSXMLParserDelegate> {
    MPMoviePlayerController *videoPlayer;
	NSURL *url;
    NSString *videoURL;
    NSString *thumbnailVIdeo;
    NSString				*sendResult;
    NSXMLParser				*rssParser;
    BOOL isNetworkOperation;
    ASINetworkQueue			*networkQueue;
    NSString				*currentElement;
    UIImageView *imageView;
     UIActivityIndicatorView *activityIndicator;
    
    NSString *welcomeStr;
    UITextView *welcomeTextView;
    int bMoveScreenState;
    UIButton *skipdemobtn;
}
@property (nonatomic, retain)  IBOutlet UIButton *skipdemobtn;
@property BOOL isNetworkOperation;
@property (nonatomic, readwrite) int bMoveNextScreen;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *welcomeStr;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain)  NSString *videoURL;
@property (nonatomic, retain)  NSString *thumbnailVIdeo;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextView *welcomeTextView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
-(IBAction)skipDemoAction;
-(IBAction)demoVideoAction;
-(void) updateView;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
-(void)getUserProfile;
- (void)grabAuthProfileInfoBackground;

@end
