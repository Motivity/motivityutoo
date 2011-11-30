//
//  RecordA15SecVideo.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "RecordA15SecVideo.h"
#import "YoutooAppDelegate.h"
#import "UploadA15SecVideo.h"

@interface RecordA15SecVideo (PrivateMethods)

- (void)processVideoFile:(NSString *)videoPath;

#define kCameraScale 1.12412178 
#define kCameraOffset 26.5 


@end
@implementation RecordA15SecVideo

@synthesize myOwnOverlay;
@synthesize startCamClicked;
@synthesize mTimerSelectionForVideo;
@synthesize uploadViewContr;
@synthesize emptyButton;

@synthesize btn;
@synthesize toolBar;
@synthesize rotateImage;
@synthesize insideCamOverlay;
@synthesize logoImageView;
@synthesize timerLbl;
@synthesize pickerController;
@synthesize cameraFaceup;
@synthesize cameraLandscape; 
@synthesize rotateLandscapeImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [myOwnOverlay release];
    [toolbar release];
    //[rotateImage release];
    [insideCamOverlay release];
    [logoImageView release];
   // [cameraSelectionButton release];
    [counterImagView release];
    [timerLbl release];
    //[rotateLandscapeImage release];
    [titleLabel release];
    [questionLabel release];
    
    mTimerSelectionForVideo=0;
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;

    [self launchCustomCameraOverlay];
    
    //appDelegate.currentVideoPath = nil; 
    startCamClicked = NO;
    
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	[appDeleagte stopAdvertisingBar];
}
- (BOOL)canShowAdvertising
{
	return NO;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.mTimerSelectionForVideo = 0;
    timeSec = 0;
    
    mTimerSelectionForVideo = 0;
    bRecordingStarted = NO;
    
}
-(void) LaunchVideoRecording : (NSTimeInterval) maxDuration
{
	NSLog(@"youtoo: video recording for: %f mins...LaunchVideoRecording()", maxDuration);
	
    // Updated - overlay code.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
   // [appDelegate hideFloatingBar];
    [self setMyownOverlay];
    appDelegate.pickerController = [[UIImagePickerController alloc] init];
    appDelegate.pickerController.delegate = self;
    //appDelegate.pickerController.videoQuality = appDelegate.shareSettingsController.quality;
    appDelegate.pickerController.allowsEditing = NO;
    appDelegate.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    appDelegate.pickerController.showsCameraControls = NO;
    appDelegate.pickerController.navigationBarHidden = YES;
    appDelegate.pickerController.toolbarHidden = YES;
    appDelegate.pickerController.wantsFullScreenLayout =YES;
    appDelegate.pickerController.cameraViewTransform = CGAffineTransformMake(kCameraScale, 0.0f,
                                                                             0.0f,         kCameraScale,
                                                                             0.0f,         kCameraOffset);
    appDelegate.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    appDelegate.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    appDelegate.pickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    appDelegate.pickerController.delegate = self; 
    appDelegate.mTimerSelectionForVideo = maxDuration;
   // appDelegate.bInCameraView = TRUE;
    [self presentModalViewController:appDelegate.pickerController animated:YES];
    if ( nil!= myOwnOverlay )
        appDelegate.pickerController.cameraOverlayView = myOwnOverlay;
    
}
- (id)setMyownOverlay
{
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	[appDeleagte stopAdvertisingBar];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    myOwnOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (myOwnOverlay) {
        myOwnOverlay.backgroundColor = [UIColor clearColor];
        //isRecordingFlag = FALSE;    
        //textviewlaunch = TRUE;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceOrientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        //YoutooAppDelegate.bInCameraView = YES;
        cameraSelectionButton = [UIButton 
                                 buttonWithType:UIButtonTypeCustom];
        [cameraSelectionButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchDown];
        cameraSelectionButton.frame = CGRectMake(230, 20, 72, 37);
        cameraSelectionButton.enabled= YES;
        [cameraSelectionButton setImage:[UIImage imageNamed:@"cameratogglepressed.png"] forState:UIControlStateNormal];
        [self.myOwnOverlay addSubview:cameraSelectionButton];
        UIImage *image = [UIImage imageNamed:@"timerbackbig.png"];
        imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(230, 20, 72, 37);
        imageView.hidden = YES;
        [self.myOwnOverlay addSubview:imageView];
        [self.myOwnOverlay sendSubviewToBack:imageView];
        lbl = [ [UILabel alloc] init ];
        lbl.frame = CGRectMake(240, 20, 72, 37);
        lbl.textColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.hidden=YES;
        [self.myOwnOverlay addSubview:lbl];
        
        counterImagView = [[UIImageView alloc] init];
        [counterImagView setImage:[UIImage imageNamed:@""]];
        [counterImagView setFrame:CGRectMake(120, 170, 80, 100)];
        [self.myOwnOverlay addSubview:counterImagView];
        counterImagView.hidden = YES;
        
        questionLabel = [ [UITextView alloc] init ];
        questionLabel.frame = CGRectMake(10, 200, 320, 80);
        questionLabel.textColor = [UIColor clearColor];
        questionLabel.editable = NO;
        questionLabel.textColor = [UIColor lightGrayColor];
        questionLabel.text = appDelegate.episodeName;
        [questionLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        questionLabel.backgroundColor = [UIColor clearColor];
        questionLabel.hidden=NO;
        if ( appDelegate.episodeName!=NULL && [appDelegate.episodeName length]>0 )
            [self.myOwnOverlay addSubview:questionLabel];
        
        
        CGRect frame= CGRectMake(0, 443, 320,50);
        appDelegate.toolBar = [[UIToolbar alloc] initWithFrame:frame];
        emptyButton = [[UIBarButtonItem alloc] initWithTitle:@"       " style:UIBarButtonItemStyleBordered target:self action:nil];
        [emptyButton setStyle:UIBarButtonItemStylePlain];
        
        
        UIImage *buttonImage = [UIImage imageNamed:@"rec-red.png"];
        //create the button and assign the image
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        button.frame = CGRectMake(0, 0, 100, 55);
        //creates a UIBarButtonItem with the button as a custom view
        startBtnImg = [[UIBarButtonItem alloc] initWithCustomView:button ];
        startBtnImg.enabled = YES;
       
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        [imageView setFrame:CGRectMake(30, 20, 80, 100)];
        [self.myOwnOverlay addSubview:imageView];
        
        UIImage *buttonImageCancel = [UIImage imageNamed:@"cancel.png"];
        //create the button and assign the image
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:buttonImageCancel forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelButtonclicked:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        cancelBtn.frame = CGRectMake(0, 0, 65, 34);
        cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn ];
        cancelButton.enabled = YES;

        appDelegate.toolBar.frame = CGRectMake(0, 440, 320,40);
        [appDelegate.toolBar setItems:[NSArray arrayWithObjects:emptyButton,emptyButton, startBtnImg, /*teleprompterButton, collapseButton, cancelButton,*/  nil]];
        appDelegate.toolBar.barStyle = UIBarStyleBlackOpaque   ;
        frame = CGRectMake(0, 347, 320,96);
        view = [ [UIView alloc] initWithFrame:frame];
        view.backgroundColor=[UIColor lightGrayColor];
        frame = CGRectMake(0, 60, 320,438);
        //textview = [ [UITextView alloc] initWithFrame:frame ];
        //textview.backgroundColor=[UIColor clearColor];
        
        //[self.myOwnOverlay addSubview:textview];
        [self.myOwnOverlay addSubview:appDelegate.toolBar]; 
        //[self creatScrollTimer];
        //[self teleSettingsApplyTimer];
        [self.view addSubview:myOwnOverlay];
        
    }
    else
        myOwnOverlay = nil;
    
    return myOwnOverlay;
}
- (void)didDeviceOrientationChanged

{
  	currentOrientation = [[UIDevice currentDevice] orientation];
	if(currentOrientation != previousOrientation &&  (currentOrientation == UIDeviceOrientationPortrait || currentOrientation == UIDeviceOrientationLandscapeLeft) )
	{
		[self changeOrientation:currentOrientation];
    }	
    
}

- (void)changeOrientation: (int)orientation
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    if ( (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) )
        [appDelegate.toolBar setItems:[NSArray arrayWithObjects:emptyButton, emptyButton,emptyButton,startBtnImg,  /*teleprompterButton,collapseButton, cancelButton,*/ nil]];
    else
        [appDelegate.toolBar setItems:[NSArray arrayWithObjects:emptyButton,emptyButton, startBtnImg, /*teleprompterButton, collapseButton, cancelButton,*/ nil]];
    
    [emptyButton setStyle:UIBarButtonItemStylePlain];
    appDelegate.toolBar.barStyle = UIBarStyleBlack;
    [self.myOwnOverlay addSubview:appDelegate.toolBar];
   
    if(currentOrientation == UIDeviceOrientationPortrait)
	{
		[myOwnOverlay setTransform:CGAffineTransformMakeRotation(0.0)];
		
        [view setFrame:CGRectMake(0.0, 347.0, 320.0,96.0)];
        cameraSelectionButton.frame = CGRectMake(230, 20, 72, 37);
        lbl.frame = CGRectMake(230, 20, 72, 37);
        //imageView.frame = CGRectMake(230, 20, 72, 37);
        imageView.frame = CGRectMake(30, 20, 80, 100);
        appDelegate.toolBar.frame = CGRectMake(0, 440, 320,40);
	}
	else {
        
		[myOwnOverlay setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        view.frame = CGRectMake(-80.0, 280.0, 480.0,90.0);
        cameraSelectionButton.frame = CGRectMake(265, 90, 72, 37);
        lbl.frame = CGRectMake(256, 90, 72, 37);
        //imageView.frame = CGRectMake(256, 90, 72, 37);
        imageView.frame = CGRectMake(-20, 100, 80, 100);
        [appDelegate.toolBar setFrame:CGRectMake(-80.0, 360, 480,40)];
		
        startBtnImg.enabled = YES;
        
	}
	previousOrientation = currentOrientation;
    
	
}

/*-(void) LaunchVideoRecording : (NSTimeInterval) maxDuration
{
	//NSLog(@"youtoo: video recording for: %f mins...LaunchVideoRecording()", maxDuration);
	
    // Updated - overlay code.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    UIView* camCumtomOverlay = [self setMyownOverlay];
    appDelegate.pickerController = [[UIImagePickerController alloc] init];
    appDelegate.pickerController.delegate = self;
    appDelegate.pickerController.allowsEditing = NO;
    appDelegate.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    appDelegate.pickerController.showsCameraControls = NO;
    appDelegate.pickerController.navigationBarHidden = YES;
    appDelegate.pickerController.toolbarHidden = YES;
    appDelegate.pickerController.wantsFullScreenLayout =YES;
    appDelegate.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    appDelegate.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    appDelegate.pickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    appDelegate.pickerController.delegate = self; 
    appDelegate.mTimerSelectionForVideo = maxDuration;
    //appDelegate.bInCameraView = TRUE;
    [self presentModalViewController:appDelegate.pickerController animated:YES];
    if ( nil!= myOwnOverlay )
        appDelegate.pickerController.cameraOverlayView = camCumtomOverlay;
    
}*/

/*- (UIView*)setMyownOverlay
{
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ( myOwnOverlay )
    {
        [myOwnOverlay release];
        myOwnOverlay = NULL;
    }
    
    myOwnOverlay = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    
    if (myOwnOverlay) {
        myOwnOverlay.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDeviceOrientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];

        cameraSelectionButton = [UIButton 
                                 buttonWithType:UIButtonTypeCustom];
        [cameraSelectionButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchDown];
        cameraSelectionButton.frame = CGRectMake(230, 20, 72, 37);
        cameraSelectionButton.enabled= YES;
        [cameraSelectionButton setImage:[UIImage imageNamed:@"cameratogglepressed.png"] forState:UIControlStateNormal];
        [self.myOwnOverlay addSubview:cameraSelectionButton];
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        [imageView setFrame:CGRectMake(30, 20, 80, 100)];
        [self.myOwnOverlay addSubview:imageView];
        lbl = [ [UILabel alloc] init ];
        lbl.frame = CGRectMake(270, 20, 60, 40);
        lbl.textColor = [UIColor clearColor];
        lbl.textColor = [UIColor redColor];
        //lbl.text = appDelegate.epiQuestionID;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.hidden=NO;
        [self.myOwnOverlay addSubview:lbl];
        
        questionLabel = [ [UILabel alloc] init ];
        questionLabel.frame = CGRectMake(10, 200, 300, 60);
        questionLabel.textColor = [UIColor clearColor];
        questionLabel.textColor = [UIColor colorWithRed:0.25 green:0.8 blue:1.0 alpha:1];
        questionLabel.text = appDelegate.episodeName;
        questionLabel.backgroundColor = [UIColor whiteColor];
        questionLabel.hidden=NO;
        [self.myOwnOverlay addSubview:questionLabel];
        
        counterImagView = [[UIImageView alloc] init];
        [counterImagView setImage:[UIImage imageNamed:@""]];
        [counterImagView setFrame:CGRectMake(120, 170, 80, 100)];
        [self.myOwnOverlay addSubview:counterImagView];
        counterImagView.hidden = YES;

        toolBar = [[UIToolbar alloc] init];
        toolBar.frame = CGRectMake(0, 420, 320,54);
        UIImage *cancelImage = [UIImage imageNamed:@""];
        //create the button and assign the image
        
        cancelBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtnImg setImage:cancelImage forState:UIControlStateNormal];
        //[cancelBtnImg addTarget:self action:@selector(cancelButtonclicked:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        cancelBtnImg.frame = CGRectMake(0, 0, 100, 55);
        //creates a UIBarButtonItem with the button as a custom view
        cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtnImg ];
        cancelButton.enabled = YES;
        //        
        //creates a UIBarButtonItem with the button as a custom view
        //        emptyBtn = [[UIBarButtonItem alloc] init];
        //        emptyBtn.frame = CGRectMake(120, 0, 100, 54);
        UIImage *buttonImage = [UIImage imageNamed:@"rec-red.png"];
        //create the button and assign the image
        
        startBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtnImg setImage:buttonImage forState:UIControlStateNormal];
        [startBtnImg addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        startBtnImg.frame = CGRectMake(0, 10, 100, 55);
        //creates a UIBarButtonItem with the button as a custom view
        startButton = [[UIBarButtonItem alloc] initWithCustomView:startBtnImg ];
        startButton.enabled = YES;
        toolBar.barStyle = UIBarStyleBlackOpaque;
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton,startButton, nil]];
        [self.myOwnOverlay addSubview:toolBar];        
        
    }
    
    return myOwnOverlay;
}*/

/*-(IBAction)startAction:(id)sender
{
    [questionLabel removeFromSuperview];
    
     if(startCamClicked!=YES)
    {
      counterTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(counterTimerTick:) userInfo:nil repeats:NO];
    
    }
    else
    {
        [self startStopRecording];
    }
}
*/
/*- (void)counterTimerTick:(NSTimer*)timer
{	

	if ( counterImagView.image == [UIImage imageNamed:@""] )
    {
       [counterImagView setImage:[UIImage imageNamed:@"3.png"]];
        counterImagView.hidden = NO;
        [self.myOwnOverlay addSubview:counterImagView];
        
       counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(counterTimerTick:) userInfo:nil repeats:NO];
        
         
    }
    else if ( counterImagView.image == [UIImage imageNamed:@"3.png"] )
    {
       counterImagView.hidden = NO;
       [counterImagView setImage:[UIImage imageNamed:@"2.png"]];
        [self.myOwnOverlay addSubview:counterImagView];
        
       counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(counterTimerTick:) userInfo:nil repeats:NO];
        
    }
    else if ( counterImagView.image == [UIImage imageNamed:@"2.png"] )
    {
          counterImagView.hidden =NO;
        [counterImagView setImage:[UIImage imageNamed:@"1.png"]];
        [self.myOwnOverlay addSubview:counterImagView];
        
        [self startStopRecording];
        
       
    }
        
}

-(void)startStopRecording
{
    if(startCamClicked!=YES)
    {
        
        [self StartTimer];
        BOOL bStop = TRUE;
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        
        void (^hideControls)(void);
        hideControls = ^(void) {
            cameraSelectionButton.alpha = 0.0;
            currentOrientation = [[UIDevice currentDevice] orientation];
            
            [startBtnImg setImage:[UIImage imageNamed:@"rec-black.png"]]; 
            cancelButton.enabled = NO;
            lbl.hidden = NO;
            
        };
        
        void (^recordMovie)(BOOL finished);
        recordMovie = ^(BOOL finished) {
            // imageView.hidden = NO;
            [counterImagView removeFromSuperview];
            [appDelegate.pickerController  startVideoCapture];
        };
        
        // Hide controls
        [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:hideControls completion:recordMovie];
        
        if (appDelegate. mTimerSelectionForVideo==0 )
        {
            bStop = FALSE;
        }
        if ( bStop )
        {
            timer = [NSTimer scheduledTimerWithTimeInterval: (appDelegate.mTimerSelectionForVideo)+1 
                                                     target:self selector:@selector(stopCamera:) userInfo:nil repeats:NO];
            
        }
        startCamClicked = YES;   
    }
    else
    {
        
        [self stopCamera:0];  
        startCamClicked = NO;
        
    }
}*/

/*-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)timerTick:(NSTimer *)timer
{
    timeSec++;
    if (timeSec == 60)
    {
        timeSec = 0;
        timeMin++;
    }
    //Format the string 00:00
    NSString* timeNow = [NSString stringWithFormat:@":%02d",  timeSec];
    //Display on your label
    lbl.textColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    [lbl setFont:[UIFont boldSystemFontOfSize:25.0]];
    [lbl setText:timeNow];
    // isRecordingFlag = TRUE;
}
*/

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		NSLog(@"OK");
        
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.pickerController dismissModalViewControllerAnimated:YES];	
    }
}

-(void)stopCamera:(id)sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;

    startButton.enabled = YES;
    lbl.hidden = YES;
    cameraSelectionButton.enabled = YES;
    if ( timer )
    {
        [timer invalidate];
        timer = nil;    
    }    

     [appDelegate.pickerController  stopVideoCapture];
}
/*- (void)changeCamera:(id)sender {
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.pickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        appDelegate.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        appDelegate.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
}*/

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"youtoo: Recording finished...didFinishPickingMediaWithInfo()");
	
    bRecordingStarted = NO;
    [timerLbl removeFromSuperview];
    timeSec = 0;
    if ( timer )
    {
        [timer invalidate];
        timer = nil;
    }
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
	{
		NSLog(@"youtoo: mediaType is kUTTypeMovie...didFinishPickingMediaWithInfo()");
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSString *urlPath = [videoURL path];
		NSLog(@"youtoo: VideoURLPath: %@...didFinishPickingMediaWithInfo()", urlPath);
		if ([[urlPath lastPathComponent] isEqualToString:@"capturedvideo.MOV"])
		{
			if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (urlPath))
			{
				NSLog(@"youtoo: Process to Save Video To Saved Photos Album...if loop of lastPathComponent..didFinishPickingMediaWithInfo()");
				UISaveVideoAtPathToSavedPhotosAlbum (urlPath, self,
                                                     @selector(video:didFinishSavingWithError:contextInfo:), nil);
			}
			else
			{
				NSLog(@"youtoo: Video Capture Error: Captured video cannot be saved...didFinishPickingMediaWithInfo()");
				[appDelegate reportError:NSLocalizedString(@"Video Capture Error", @"Alert Title") 
                             description:NSLocalizedString(@"Captured video cannot be saved.", @"Alert Title")];
			}
		}
		
		else
		{
			NSLog(@"youtoo: Processing soon to saved photos album...else loop of lastPathComponent..didFinishPickingMediaWithInfo()");
            [self processVideoFile:urlPath];
		}
	}
    // remove notification
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
     
	[self dismissModalViewControllerAnimated:YES];
    
	
}
- (void)processVideoFile:(NSString *)videoPath
{
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.currentVideoPath = videoPath;
    uploadViewContr = [[UploadA15SecVideo alloc] initWithNibName:@"UploadA15SecVideo" bundle:nil];
    [self.navigationController pushViewController:uploadViewContr animated:NO];
    //[appDelegate.tabBarController presentModalViewController:uploadViewContr animated:YES];
    [uploadViewContr release];
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if (nil != error)
	{
        [appDelegate reportError:NSLocalizedString(@"Video Capture Error", @"Alert Title") 
                     description:[error localizedDescription]];
	}
	else
	{
		[self processVideoFile:videoPath];
	}
	
}
- (void)cancelButtonclicked:(id)sender
{
    [pickerController dismissModalViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:NO];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    //NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
    //[self.navigationController 
     //popToViewController:[self.navigationController.viewControllers 
       //                   objectAtIndex:(noOfViewControllers-2)] animated:YES];
}
/*- (void)didDeviceOrientationChanged

{
    
  	currentOrientation = [[UIDevice currentDevice] orientation];
	if(currentOrientation != previousOrientation &&  (currentOrientation == UIDeviceOrientationPortrait || currentOrientation == UIDeviceOrientationLandscapeLeft) )
	{
		[self changeOrientation:currentOrientation];
    }	

}
- (void)changeOrientation: (int)orientation
{
     if(currentOrientation == UIDeviceOrientationPortrait)
	{
        //toolBar.barStyle = UIBarStyleBlackOpaque;
        myOwnOverlay.transform = CGAffineTransformMakeRotation(0);
        CGRect frame = myOwnOverlay.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        frame.size.width = myOwnOverlay.frame.size.height;
        frame.size.height = myOwnOverlay.frame.size.width;
        myOwnOverlay.frame = frame;
        cameraSelectionButton.frame = CGRectMake(230, 20, 72, 37);
        imageView.frame = CGRectMake(30, 20, 72, 62);
        //startBtnImg.frame = CGRectMake(0, 0, 100, 55);
        UIImage *cancelImage = [UIImage imageNamed:@""];
        //create the button and assign the image
        
        [counterImagView setFrame:CGRectMake(120, 170, 80, 100)];
        
        cancelBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtnImg setImage:cancelImage forState:UIControlStateNormal];
        //[cancelBtnImg addTarget:self action:@selector(cancelButtonclicked:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        cancelBtnImg.frame = CGRectMake(0, 0, 100, 55);
        //creates a UIBarButtonItem with the button as a custom view
        cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtnImg ];
        
        UIImage *buttonImage = [UIImage imageNamed:@"rec-red.png"];
        //create the button and assign the image
        
        startBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtnImg setImage:buttonImage forState:UIControlStateNormal];
        [startBtnImg addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        startBtnImg.frame = CGRectMake(0, 0, 100, 55);
        startButton = [[UIBarButtonItem alloc] initWithCustomView:startBtnImg ];
        toolBar.frame = CGRectMake(0, 420, 320,54);
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, startButton, nil]];
	}
	else {
        
		//toolBar.barStyle = UIBarStyleDefault;
        
        [counterImagView setFrame:CGRectMake(180, 140, 80, 100)];
        
        myOwnOverlay.transform = CGAffineTransformMakeRotation(M_PI/2);
        CGRect frame = myOwnOverlay.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        frame.size.width = myOwnOverlay.frame.size.height;
        frame.size.height = myOwnOverlay.frame.size.width;
        myOwnOverlay.frame = frame;
        
        cameraSelectionButton.frame = CGRectMake(276, 22, 72, 37);
        imageView.frame = CGRectMake(20, 20, 72, 62);
        // startBtnImg.frame = CGRectMake(0, 0, 55, 100);
        UIImage *cancelImage = [UIImage imageNamed:@""];
        //create the button and assign the image
        
        cancelBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtnImg setImage:cancelImage forState:UIControlStateNormal];
        //[cancelBtnImg addTarget:self action:@selector(cancelButtonclicked:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        cancelBtnImg.frame = CGRectMake(0, 0, 55, 100);
        //creates a UIBarButtonItem with the button as a custom view
        cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtnImg ];
        UIImage *buttonImage;
        if(startCamClicked)
            buttonImage = [UIImage imageNamed:@"rec-black-vert.png"];
        else
            buttonImage = [UIImage imageNamed:@"rec-red-ver.png"];
        //create the button and assign the image
        
        startBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtnImg setImage:buttonImage forState:UIControlStateNormal];
        [startBtnImg addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        [startBtnImg setFrame:CGRectMake(-10, -10, 55, 100)];
        startButton = [[UIBarButtonItem alloc] initWithCustomView:startBtnImg ];
        toolBar.frame = CGRectMake(420, 0, 54,320);
        [toolBar setItems:[NSArray arrayWithObjects: startButton, nil]];
        //		
        //        startButton.enabled = YES;
        
	}
    [self.myOwnOverlay addSubview:toolBar];
	previousOrientation = currentOrientation;
    
	
}*/


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark NEW VIDEO CAMERA OVERLAY - PRABAKAR
-(void) launchCustomCameraOverlay
{
        
    [self customOverlay];
    
    pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.showsCameraControls = NO;
    pickerController.navigationBarHidden = YES;
    pickerController.toolbarHidden = YES;
    pickerController.wantsFullScreenLayout =YES;
    pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    pickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    pickerController.delegate = self; 
    mTimerSelectionForVideo = 15.0;
    pickerController.videoMaximumDuration = 15.0;
    
    // appDelegate.bInCameraView = TRUE;
    [self presentModalViewController:pickerController animated:YES];
    if ( nil!= myOwnOverlay )
        pickerController.cameraOverlayView = myOwnOverlay;
}

-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)timerTick:(NSTimer *)pTimer
{
    NSLog(@"timeSec: %d", timeSec);
   
    timeSec--;
    if (timeSec == 60)
    {
        timeSec = 0;
        timeMin--;
    }
    //Format the string 00:00
    if ( timeSec>=0 )
    {

    NSString* timeNow = [NSString stringWithFormat:@":%02d",  timeSec];
    //Display on your label
    timerLbl.textColor = [UIColor clearColor];
    timerLbl.textColor = [UIColor redColor];
    [timerLbl setFont:[UIFont boldSystemFontOfSize:30.0]];
    [timerLbl setText:timeNow];
    // isRecordingFlag = TRUE;
    }
}

-(void) customOverlay
{
    
    myOwnOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    if ( myOwnOverlay )
    {
        
        bRecordingStarted = NO;
        turnCameraImg = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        UIBarButtonItem *emptyButton = [[UIBarButtonItem alloc] initWithTitle:@"              " style:UIBarButtonItemStyleBordered target:self action:nil];
        [emptyButton setStyle:UIBarButtonItemStylePlain];
        
        UIImage *buttonImage = [UIImage imageNamed:@"rec-red.png"];
        //create the button and assign the image
        recButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recButton setImage:buttonImage forState:UIControlStateNormal];
        [recButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        recButton.frame = CGRectMake(0, 150, 100, 55);
        //creates a UIBarButtonItem with the button as a custom view
        startBtn = [[UIBarButtonItem alloc] initWithCustomView:recButton ];
        startBtn.enabled = NO;
        
        UIImage *canclButtonImage = [UIImage imageNamed:@"cancel.png"];
        //create the button and assign the image
        UIButton *canclButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [canclButton setImage:canclButtonImage forState:UIControlStateNormal];
        [canclButton addTarget:self action:@selector(cancelButtonclicked:) forControlEvents:UIControlEventTouchDown];
        //sets the frame of the button to the size of the image
        canclButton.frame = CGRectMake(180, 150, 100, 55);
        //creates a UIBarButtonItem with the button as a custom view
        cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:canclButton ];
        cancelBtn.enabled = YES;
               
        //toolBar.frame = CGRectMake(0, 300, 320,40);
        CGRect frame= CGRectMake(0, 425, 320,55);
        toolBar = [[UIToolbar alloc] initWithFrame:frame];
        [toolBar setItems:[NSArray arrayWithObjects: startBtn, emptyButton, cancelBtn, nil]];        
        toolBar.barStyle = UIBarStyleDefault;
        
       // logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        //[logoImageView setFrame:CGRectMake(30, 20, 80, 100)];       
        logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logonew.png"]];
        [logoImageView setFrame:CGRectMake(3, 5, 76, 82)];        
        [logoImageView setHidden:YES];
        
        socialimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"socialTV.png"]];
        [socialimageView setFrame:CGRectMake(2, 95, 86, 30)];
        //[self.myOwnOverlay addSubview:logoimageView];
        [socialimageView setHidden:YES];
        
        rotateImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rotatecam.png.png"]]autorelease];
        [rotateImage setFrame:CGRectMake(0, 0, 320, 440)];
        
        cameraSelectionButton = [UIButton 
                                 buttonWithType:UIButtonTypeCustom];
        [cameraSelectionButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchDown];
        cameraSelectionButton.frame = CGRectMake(230, 20, 72, 37);
        cameraSelectionButton.enabled= YES;
        [cameraSelectionButton setImage:[UIImage imageNamed:@"cameratogglepressed.png"] forState:UIControlStateNormal];        
        cameraSelectionButton.hidden = YES;
        
        counterImagView = [[UIImageView alloc] init];
        [counterImagView setImage:[UIImage imageNamed:@""]];
        [counterImagView setFrame:CGRectMake(120, 170, 80, 100)];
        [insideCamOverlay addSubview:counterImagView];
        counterImagView.hidden = YES;
        
        timerLbl = [ [UITextView alloc] init ];
        //timerLbl.frame = CGRectMake(200, 0, 72, 37);
        timerLbl.textColor = [UIColor clearColor];
        timerLbl.textColor = [UIColor redColor];
        timerLbl.backgroundColor = [UIColor clearColor];
        timerLbl.enabled = YES;
        //timerLbl.hidden=NO;
        timeSec = 15;
        [insideCamOverlay addSubview:timerLbl];
        
        questionLabel = [ [UITextView alloc] init ];
        questionLabel.frame = CGRectMake(14, 200, 320, 60);
        questionLabel.textColor = [UIColor clearColor];
        questionLabel.textColor = [UIColor colorWithRed:0.25 green:0.8 blue:1.0 alpha:1];
        //questionLabel.text = appDelegate.episodeName;
        [questionLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        questionLabel.backgroundColor = [UIColor whiteColor];
        questionLabel.hidden=NO;
        [insideCamOverlay addSubview:questionLabel];
        
        titleLabel = [ [UITextView alloc] init ];
        titleLabel.frame = CGRectMake(14, 200, 320, 80);
        titleLabel.textColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor darkGrayColor];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.hidden=YES;
        titleLabel.editable = NO;
        [insideCamOverlay addSubview:titleLabel];
        
        insideCamOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 440)];
        [insideCamOverlay addSubview:rotateImage]; 
        [insideCamOverlay addSubview:logoImageView]; 
        [insideCamOverlay addSubview:socialimageView]; 
        [insideCamOverlay addSubview:cameraSelectionButton]; 
        
        [myOwnOverlay addSubview:insideCamOverlay];         
        [myOwnOverlay addSubview:toolBar]; 
        
        [self.view addSubview:myOwnOverlay];
        
    }
    
}

- (void)changeCamera:(id)sender {
    
    if (pickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
}

- (void)didRotate

{
    if ( bRecordingStarted==YES )
        return;
    
    currentOrientation = [[UIDevice currentDevice] orientation];
    NSLog(@"currentOrientation: %d", currentOrientation);
    
    if ( currentOrientation==UIDeviceOrientationLandscapeLeft || currentOrientation==UIDeviceOrientationLandscapeRight)//||currentOrientation==UIDeviceOrientationUnknown)
    {   
        if(cameraFaceup==NO&& cameraLandscape==NO)
        {
            if (turnCameraImg==YES) {
                [rotateImage removeFromSuperview];
            }
            
            turnCameraImg=NO;
            cameraLandscape=YES;
            //timerLbl.hidden = NO;
            startBtn.enabled = YES;
            cameraSelectionButton.frame = CGRectMake(250, 80, 72, 37);
            cameraSelectionButton.hidden = NO;
            cameraSelectionButton.enabled = YES;
            
            [logoImageView setHidden:NO];
            [socialimageView setHidden:NO];
            
            [insideCamOverlay setTransform:CGAffineTransformMakeRotation(M_PI/2)];
            
            [logoImageView setFrame:CGRectMake(-52, 65, 76, 82)];
            [socialimageView setFrame:CGRectMake(-52, 147, 80, 30)];
            
            [timerLbl setFrame:CGRectMake(-55, 200, 72, 40)];
            timerLbl.textColor = [UIColor clearColor];
            timerLbl.textColor = [UIColor redColor];
            [timerLbl setFont:[UIFont boldSystemFontOfSize:30.0]];
            [timerLbl setText:@":15"];
            [insideCamOverlay addSubview:timerLbl];
            
            // TEMP
            YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
            //NSString *tempStr = @"Andrelina: ";
            
            //tempLabel.frame = CGRectMake(questionLabel.frame.size.width, questionLabel.frame.origin.y, questionLabel.frame.size.width, questionLabel.frame.size.height);
            titleLabel.hidden=NO;
            NSString *title = [NSString stringWithFormat:@"%@",(appDelegate.titleString!=NULL) ? appDelegate.titleString : @""];
            title = [ title stringByAppendingString:@":"];
            titleLabel.text = title;
            
            [insideCamOverlay addSubview:titleLabel];
            //[tempLabel release];
            // TEMP
            
            questionLabel.editable = NO;
           // [questionLabel setFrame:CGRectMake(10, 200, 320, 80)];
            
            [questionLabel setFrame:CGRectMake(14, 200, 320, 80)];            
            
            NSLog(@"appDelegate.episodeName: %@", appDelegate.episodeName);
            [questionLabel setBackgroundColor:[UIColor clearColor]];
            questionLabel.text = appDelegate.episodeName;
            [insideCamOverlay addSubview:questionLabel];
            cameraFaceup=NO;
            
            UIImage *buttonImage = [UIImage imageNamed:@"rec-red.png"];
            //create the button and assign the image
            recButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [recButton setImage:buttonImage forState:UIControlStateNormal];
            
            rotateLandscapeImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transparent.png"]]autorelease];
            [rotateLandscapeImage setFrame:CGRectMake(-80, 60, 480, 320)];
            [insideCamOverlay addSubview:rotateLandscapeImage];
            [insideCamOverlay sendSubviewToBack:rotateLandscapeImage];
        }
    }
    else if ( currentOrientation==UIDeviceOrientationPortrait||currentOrientation==UIDeviceOrientationPortraitUpsideDown )//||currentOrientation==UIDeviceOrientationUnknown ) 
    {
        // [self rotatePortrait];
        cameraFaceup=NO;
        cameraLandscape=NO; 
        [timerLbl removeFromSuperview];
        [questionLabel removeFromSuperview];
        
        [rotateLandscapeImage removeFromSuperview];
        
        titleLabel.hidden=YES;
        startBtn.enabled = NO;
        cameraSelectionButton.hidden = YES;
        cameraSelectionButton.enabled = NO;
        [logoImageView setHidden:YES];
        [socialimageView setHidden:YES];

        
        [insideCamOverlay setTransform:CGAffineTransformMakeRotation(0)];
        toolBar.frame= CGRectMake(0, 425, 320,55);
        if (turnCameraImg==NO) {
            
            rotateImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rotatecam.png"]]autorelease];
            [rotateImage setFrame:CGRectMake(0, 0, 320, 480)];
            [insideCamOverlay addSubview:rotateImage];
            turnCameraImg=YES;
        }
        
        [logoImageView setFrame:CGRectMake(3, 5, 76, 82)];
        [socialimageView setFrame:CGRectMake(2, 95, 86, 30)];
        [insideCamOverlay addSubview:logoImageView]; 
        [insideCamOverlay addSubview:socialimageView]; 
        
        UIImage *buttonImage = [UIImage imageNamed:@"rec-black.png"];
        //create the button and assign the image
        recButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recButton setImage:buttonImage forState:UIControlStateNormal];
    }

}

/*- (void)didRotate

{
    if ( bRecordingStarted==YES )
        return;
    
     
    currentOrientation = [[UIDevice currentDevice] orientation];
    NSLog(@"currentOrientation: %d", currentOrientation);
    
    if ( currentOrientation==5 )
        return;
   
    
    if ( currentOrientation==UIDeviceOrientationLandscapeLeft || currentOrientation==UIDeviceOrientationLandscapeRight)
	{
        [rotateImage removeFromSuperview];
        
        //timerLbl.hidden = NO;
        startBtn.enabled = YES;
        cameraSelectionButton.frame = CGRectMake(230, 80, 72, 37);
        cameraSelectionButton.hidden = NO;
        cameraSelectionButton.enabled = YES;
        
        
        [insideCamOverlay setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        //myOwnOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
        
        [logoImageView setFrame:CGRectMake(-40, 70, 80, 100)];
        
        [timerLbl setFrame:CGRectMake(-40, 210, 72, 37)];
        [insideCamOverlay addSubview:timerLbl];
        
        [questionLabel setFrame:CGRectMake(10, 200, 300, 80)];
        
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        [questionLabel setBackgroundColor:[UIColor clearColor]];
        questionLabel.text = appDelegate.episodeName;
        [insideCamOverlay addSubview:questionLabel];
    }
    else if ( currentOrientation==UIDeviceOrientationPortrait ) 
    {
        [timerLbl removeFromSuperview];
        [questionLabel removeFromSuperview];
        
        startBtn.enabled = NO;
        cameraSelectionButton.hidden = YES;
        cameraSelectionButton.enabled = NO;
        
        [insideCamOverlay setTransform:CGAffineTransformMakeRotation(0)];
        
        rotateImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rotatecam.png"]]autorelease];
        [rotateImage setFrame:CGRectMake(0, 0, 320, 440)];
        [insideCamOverlay addSubview:rotateImage]; 
        [logoImageView setFrame:CGRectMake(30, 20, 80, 100)];
        [insideCamOverlay addSubview:logoImageView]; 
    }
}
*/
-(IBAction)startAction:(id)sender
{
    [rotateLandscapeImage removeFromSuperview];
    [titleLabel removeFromSuperview];
    cancelBtn.enabled = NO;
    if ( bRecordingStarted==NO )
    {
        bRecordingStarted = YES;
        [questionLabel removeFromSuperview];
        
        counterTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(counterTimerTick:) userInfo:nil repeats:NO];
    }
    else
    {
        bRecordingStarted = NO;
        [pickerController startVideoCapture];
        
        startBtn.enabled = NO;
    }
}

-(void)startStopRecording
{
    BOOL bStop = TRUE;
    
    [self StartTimer];
    
    void (^hideControls)(void);
    hideControls = ^(void) {
        //cameraSelectionButton.alpha = 0.0;
        UIImage *buttonImage = [UIImage imageNamed:@"rec-red.png"];
        [startBtn setImage:buttonImage];
        [counterImagView removeFromSuperview];
        //cancelButton.enabled = NO;
        //timerLbl.hidden = NO;
        //imageView.hidden = NO;
    };
    
    void (^recordMovie)(BOOL finished);
    recordMovie = ^(BOOL finished) {
        //imageView.hidden = NO;
        UIImage *buttonImage = [UIImage imageNamed:@"rec-black.png"];
        [startBtn setImage:buttonImage];
        [pickerController startVideoCapture];
    };
    // Hide controls
    [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:hideControls completion:recordMovie];
}

- (void)counterTimerTick:(NSTimer*)timer
{	
    
	if ( counterImagView.image == [UIImage imageNamed:@""] )
    {
        startBtn.enabled = NO;
        
        [counterImagView setImage:[UIImage imageNamed:@"3.png"]];
        counterImagView.hidden = NO;
        [insideCamOverlay addSubview:counterImagView];
        
        counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(counterTimerTick:) userInfo:nil repeats:NO];
        
        
    }
    else if ( counterImagView.image == [UIImage imageNamed:@"3.png"] )
    {
        counterImagView.hidden = NO;
        [counterImagView setImage:[UIImage imageNamed:@"2.png"]];
        [insideCamOverlay addSubview:counterImagView];
        
        counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(counterTimerTick:) userInfo:nil repeats:NO];
        
    }
    else if ( counterImagView.image == [UIImage imageNamed:@"2.png"] )
    {
        counterImagView.hidden =NO;
        [counterImagView setImage:[UIImage imageNamed:@"1.png"]];
        [insideCamOverlay addSubview:counterImagView];
        //startBtn.enabled = YES;
        
//        [self startStopRecording];
        
     counterTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                     target:self selector:@selector(counterTimerTick:) userInfo:nil repeats:NO];   
    }
    else if ( counterImagView.image == [UIImage imageNamed:@"1.png"] )
    {

         [self startStopRecording];   
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end

@implementation UIToolbar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"16-TurnCamera-bottombar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
