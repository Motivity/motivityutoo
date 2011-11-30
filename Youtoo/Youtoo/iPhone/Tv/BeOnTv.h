//
//  BeOnTv.h
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "CSMAdvertisingProtocol.h"

@class UploadA15SecVideo;
@class 	ASINetworkQueue;

@interface BeOnTv : UIViewController <CSMAdvertisingProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate, NSXMLParserDelegate>{
    
    UIView *myOwnOverlay;
    UIButton *cameraSelectionButton;
    UIButton *startBtnImg;
    UIToolbar *toolBar;
    UIButton *startButton;
    UIButton *videosButton;
    UIButton *profileButton;
    UIButton *moreButton;
    
    UIButton *cancelBtnImg;
    UIButton *emptyBtn;
    BOOL startCamClicked;
    unsigned int currentOrientation;
    unsigned int previousOrientation;
    NSTimer *timer;
    UIImageView *imageView;
    UILabel *lbl;
    int timeSec;
    int timeMin;
    UploadA15SecVideo *uploadViewContr;
    
    UIImagePickerController *pickerController;
    BOOL bBeOnTvLaunched;
    BOOL beOnTvActionClicked;
    UIButton *fameSpotBtn;
    UIButton *tickerShoutBtn;
    UIButton *helpViewBtn;
    ASINetworkQueue			*networkQueue;
    BOOL					isNetworkOperation;
    NSString				*currentElement;
    NSString				*userIDCode;
    NSString				*sendResult;
    NSXMLParser				*rssParser;
    UIImageView *beontvImgView ;
    UIImageView *backTranspImage;
}

@property BOOL startCamClicked;
@property BOOL bBeOnTvLaunched;
@property BOOL beOnTvActionClicked;
@property (nonatomic, retain)   UIView *myOwnOverlay;
@property (nonatomic, retain) UploadA15SecVideo *uploadViewContr;
@property (nonatomic, retain)  UIImagePickerController *pickerController;
@property (nonatomic, retain)   UIImageView *backTranspImage;
@property BOOL isNetworkOperation;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, copy) NSString *userIDCode;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) NSXMLParser *rssParser;

- (id)setMyownOverlay;
-(void) LaunchVideoRecording;
-(IBAction)startAction:(id)sender;
-(void)stopCamera:(id)sender;
-(void) StartTimer;
- (void)changeOrientation: (int)orientation;
- (BOOL)canShowAdvertising;
- (void)advertisingWillHide;
- (void)advertisingDidShow;
- (void)reloadPage;
-(void) startAction :(id) sender;
- (void)changeCamera:(id)sender;
- (void)grabProfileInfoIntheBackgroud;
-(void) authAgain;

@end
