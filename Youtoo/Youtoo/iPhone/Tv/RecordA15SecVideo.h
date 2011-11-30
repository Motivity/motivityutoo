//
//  RecordA15SecVideo.h
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "CSMAdvertisingProtocol.h"
@class UploadA15SecVideo;
@interface RecordA15SecVideo : UIViewController <UINavigationControllerDelegate, 
                                    UIImagePickerControllerDelegate, CSMAdvertisingProtocol> 
{
    UIView *myOwnOverlay;
    UIButton *cameraSelectionButton;
    UIToolbar *toolBar;
    UIButton *startButton;
    UIBarButtonItem *startBtnImg;
    UIBarButtonItem *cancelButton;
    UIButton *cancelBtnImg;
    BOOL startCamClicked;
    BOOL 	mTimerSelectionForVideo;
    
    NSTimer *timer;
    unsigned int currentOrientation;
    unsigned int previousOrientation;
    UIImageView *imageView;
    UILabel *lbl;
    int timeSec;
    int timeMin;
    UploadA15SecVideo *uploadViewContr;
    UILabel *counterLabel;
    NSTimer  *counterTimer;
    UIImageView *counterImagView;
   
    UITextView *questionLabel;
    UIBarButtonItem *emptyButton;
    UIView *view;
    BOOL bRecordingStarted;
    UILabel *timerLbl;
    UIImageView *rotateImage;
    UIImageView *rotateLandscapeImage;
    UIBarButtonItem *startBtn;
    
    UIButton *btn;
    UIView *insideCamOverlay;
    UIImagePickerController *pickerController;
    UIToolbar *toolbar;
    UIImageView *logoImageView;
    BOOL cameraFaceup;
    BOOL cameraLandscape; 
    BOOL turnCameraImg;
    UIBarButtonItem *cancelBtn;
    UIImageView *socialimageView;
    UITextView *titleLabel;
    UIButton *recButton;
}
//@property (nonatomic, retain)  UITextView *titleLabel;
@property BOOL  mTimerSelectionForVideo;
@property (nonatomic, retain)   UILabel *timerLbl;
@property BOOL startCamClicked;
@property BOOL cameraFaceup;
@property BOOL cameraLandscape;
@property (nonatomic, retain)   UIView *myOwnOverlay;
@property (nonatomic, retain)  UploadA15SecVideo *uploadViewContr;
@property (readwrite, retain) IBOutlet UIBarButtonItem *emptyButton;
@property (nonatomic, retain) IBOutlet UIButton *btn;
@property (nonatomic, retain)   UIView *insideCamOverlay;
@property (nonatomic, retain)   UIImagePickerController *pickerController;
@property (nonatomic, retain)   UIToolbar *toolBar;
@property (nonatomic, retain)   UIImageView *logoImageView;
@property (nonatomic, retain)   UIImageView *rotateImage;
@property (nonatomic, retain)   UIImageView *rotateLandscapeImage;

- (UIView*)setMyownOverlay;
-(void) LaunchVideoRecording : (NSTimeInterval) maxDuration;
-(IBAction)startAction:(id)sender;
-(void)stopCamera:(id)sender;
- (void)changeOrientation: (int)orientation;
-(void) StartTimer;
-(void) startStopRecording;
- (BOOL)canShowAdvertising;
-(id) landscapeCameraOverlay;
- (void)didRotate;

-(IBAction) launchAlbum :(id) sender;
-(id) landscapeCameraOverlay;
- (void)didRotate;
- (void)changeCamera:(id)sender ;
-(void)startStopRecording;
-(void) StartTimer;
- (void)timerTick:(NSTimer *)timer;
-(void) launchCustomCameraOverlay;
-(void) customOverlay;

@end
