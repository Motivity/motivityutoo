//
//  UploadA15SecVideo.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

@class ProfileImage;
@class YoutooAppDelegate;

@interface UploadA15SecVideo : UIViewController {
    NSString				*currentVideoPath;
    NSString				*selectedSpotNameStr;
@private
    
    UIImagePickerController  *imagePicker;
    ProfileImage *thumbnailView;
    UIImage							*thumbnailImage;
    ProfileImage					*playIcon;
    MPMoviePlayerController			*videoPlayer;
    BOOL						isNetworkOperation;
    BOOL facebookIsChecked; 
    BOOL twitterkIsChecked;
    UIButton *mobile;
    UIButton *web;
    UIButton *tv;
     UIButton *twitterBtn;
    UIButton *fbBtn;
    UIButton *googleBtn;
    UIButton *youtubeBtn;
    YoutooAppDelegate *appDelegate;
    
    UIButton *playBtn1;
    UIButton *playBtn2;
}
@property (nonatomic, copy) NSString *selectedSpotNameStr;
@property(nonatomic, retain)  NSString *currentVideoPath1;
@property(nonatomic, retain )  ProfileImage *thumbnailView;
@property(nonatomic, retain )  UIImage	*thumbnailImage;
@property(nonatomic, retain )   MPMoviePlayerController			*videoPlayer;
@property(nonatomic, retain ) ProfileImage					*playIcon;
@property (nonatomic, copy) NSString *currentVideoPath;
@property BOOL facebookIsChecked;
@property BOOL twitterkIsChecked;

@property (nonatomic, retain) IBOutlet  UIButton *playBtn1;
@property (nonatomic, retain) IBOutlet  UIButton *playBtn2;

@property (nonatomic, retain) IBOutlet  UIButton *mobile;
@property (nonatomic, retain) IBOutlet  UIButton *web;
@property (nonatomic, retain) IBOutlet UIButton *tv;
@property (nonatomic, retain) IBOutlet  UIButton *twitterBtn;
@property (nonatomic, retain) IBOutlet  UIButton *fbBtn;
@property (nonatomic, retain) IBOutlet UIButton *googleBtn;
@property (nonatomic, retain) IBOutlet UIButton *youtubeBtn;

- (IBAction)touchIconAction:(id)sender;
-(IBAction)successAct:(id)sender;
-(IBAction)recordAct:(id)sender;
-(IBAction) uploadVideo :(id)sender;
- (IBAction)uploadToFacebookAction:(id)sender;
- (IBAction)uploadToTwitter:(id)sender;

-(IBAction)mobileAction:(id)sender;
-(IBAction)webAction:(id)sender;
-(IBAction)tvAction:(id)sender;


-(IBAction)tweetBtnAction:(id)sender;
-(IBAction)fbBtnAction:(id)sender;
-(IBAction)googleBtnAction:(id)sender;
-(IBAction)youtubeBtnAction:(id)sender;
- (BOOL)canShowAdvertising;
- (void)playVideoFile:(id)sender;
@end
