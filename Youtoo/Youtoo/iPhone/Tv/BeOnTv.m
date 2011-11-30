//
//  BeOnTv.m
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "BeOnTv.h"
#import "YoutooAppDelegate.h"
#import "RecordAfameSpot.h"
#import "WriteAtickerShout.h"
#import "HelpScreen.h"
#import"UploadA15SecVideo.h"
#import "Schedule.h"
#import "Videos.h"
#import "Profile.h"
#import "More.h"
#import "HelpItemScreen.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"


@interface BeOnTv (PrivateMethods)

- (void)processVideoFile:(NSString *)videoPath;

- (void)requestDone:(ASIHTTPRequest *)request;
- (void)requestWentWrong:(ASIHTTPRequest *)request;

@end

@implementation BeOnTv

@synthesize startCamClicked;

@synthesize uploadViewContr;
@synthesize pickerController;
@synthesize bBeOnTvLaunched;
@synthesize myOwnOverlay;
@synthesize beOnTvActionClicked;
@synthesize isNetworkOperation;
@synthesize currentElement;
@synthesize userIDCode;
@synthesize sendResult;
@synthesize rssParser;
@synthesize backTranspImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        self.isNetworkOperation = NO;
        self.sendResult = @"";
        //networkQueue = [[ASINetworkQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    //[networkQueue release];
    self.currentElement = nil;
    self.sendResult = nil;
    if ( pickerController )
        [pickerController release];
    if ( myOwnOverlay )
        [myOwnOverlay release];
    
    [backTranspImage release];
    
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
    self.title =  @"Be on TV";
    self.navigationController.navigationBarHidden = YES;
    beOnTvActionClicked = NO;
    bBeOnTvLaunched = NO;
  
    
    

   UIButton *fameSpotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fameSpotBtn setFrame:CGRectMake(60, 250, 100, 100)];
    [fameSpotBtn setBackgroundImage:[UIImage imageNamed:@"record-a-fame-spot.png"] forState:UIControlStateNormal];
    [fameSpotBtn addTarget:self action:@selector(fameSoptAct:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:fameSpotBtn];
    UIButton *tickerShoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tickerShoutBtn setFrame:CGRectMake(160, 250, 100, 100)];
    [tickerShoutBtn setBackgroundImage:[UIImage imageNamed:@"write-a-ticker-shout.png"] forState:UIControlStateNormal];
    [tickerShoutBtn addTarget:self action:@selector(tickerSpotAct:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:tickerShoutBtn];
    UIButton *helpViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpViewBtn setFrame:CGRectMake(197, 205, 60, 50)];
    [helpViewBtn setBackgroundImage:[UIImage imageNamed:@"20-BeOnTV-help.png"] forState:UIControlStateNormal];
    [helpViewBtn addTarget:self action:@selector(helpViewAct:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:helpViewBtn];
    
    
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate authenticateAtLaunchIfNeedBe];
    
}

-(void) LaunchVideoRecording
{
	//NSLog(@"youtoo: video recording for: %f mins...LaunchVideoRecording()", maxDuration);
	
    // Updated - overlay code.
    UIView* camCumtomOverlay = [self setMyownOverlay];
    pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.showsCameraControls = NO;
    pickerController.navigationBarHidden = NO;
    pickerController.toolbarHidden = YES;
    pickerController.wantsFullScreenLayout =YES;
    pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    pickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    
   // pickerController.mTimerSelectionForVideo = maxDuration;
    //appDelegate.bInCameraView = TRUE;
    [self presentModalViewController:pickerController animated:NO];
   // [self.view addSubview:pickerController.view];
    if ( nil!= myOwnOverlay )
        pickerController.cameraOverlayView = camCumtomOverlay;
  
    
} 

-(void) startAction :(id) sender
{
    
    [self dismissModalViewControllerAnimated:YES];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    Schedule *logInContr = [[Schedule alloc] initWithNibName:@"Schedule" bundle:[NSBundle mainBundle]];
    bBeOnTvLaunched=NO;
    [appDelegate.tabBarController setSelectedIndex:0];
    //self.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:logInContr  animated:YES];    
    [logInContr release];
    
}

-(void) beOnTvAction :(id) sender
{
    //UIButton *currBtn = (UIButton*) sender;
    
    if ( beOnTvActionClicked==YES )
    {
        [fameSpotBtn removeFromSuperview];
        [tickerShoutBtn removeFromSuperview];        
        [helpViewBtn removeFromSuperview];
        [backTranspImage removeFromSuperview];
        
        beontvImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beontv.png"]];
        [beontvImgView setFrame:CGRectMake(60, 325, 200, 80)];
        [self.myOwnOverlay addSubview:beontvImgView];
        beOnTvActionClicked = NO;
        
        
    }
    else
    {    
        [beontvImgView  removeFromSuperview];
    fameSpotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fameSpotBtn setFrame:CGRectMake(29, 271, 130, 130)];
    [fameSpotBtn setBackgroundImage:[UIImage imageNamed:@"record-a-fame-spot.png"] forState:UIControlStateNormal];
    [fameSpotBtn addTarget:self action:@selector(fameSoptAct:) forControlEvents:UIControlEventTouchDown];
    [self.myOwnOverlay addSubview:fameSpotBtn];
   
    tickerShoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tickerShoutBtn setFrame:CGRectMake(156, 274, 130, 130)];
    [tickerShoutBtn setBackgroundImage:[UIImage imageNamed:@"write-a-ticker-shout.png"] forState:UIControlStateNormal];
    [tickerShoutBtn addTarget:self action:@selector(tickerSpotAct:) forControlEvents:UIControlEventTouchDown];
    [self.myOwnOverlay addSubview:tickerShoutBtn];
    
    helpViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpViewBtn setFrame:CGRectMake(217, 216, 70, 60)];
    [helpViewBtn setBackgroundImage:[UIImage imageNamed:@"20-BeOnTV-help.png"] forState:UIControlStateNormal];
    [helpViewBtn addTarget:self action:@selector(helpViewAct:) forControlEvents:UIControlEventTouchDown];
    [self.myOwnOverlay addSubview:helpViewBtn];
    
        
    backTranspImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transparent-pot.png"]]autorelease];
    [backTranspImage setFrame:CGRectMake(0, 0, 320, 480)];
    [self.myOwnOverlay addSubview:backTranspImage];
    [self.myOwnOverlay sendSubviewToBack:backTranspImage];
        
        beOnTvActionClicked = YES;
    }
    

}

-(void) startVideosAction :(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    Videos *logInContr = [[Videos alloc] initWithNibName:@"Videos" bundle:[NSBundle mainBundle]];
    bBeOnTvLaunched=NO;
    [appDelegate.tabBarController setSelectedIndex:1];
    //self.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:logInContr  animated:YES];    
    [logInContr release];

}

-(void) startProfileAction :(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    Profile *logInContr = [[Profile alloc] initWithNibName:@"Profile" bundle:[NSBundle mainBundle]];
    bBeOnTvLaunched=NO;
    [appDelegate.tabBarController setSelectedIndex:3];
    //self.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:logInContr  animated:YES];    
    [logInContr release];
    
}
-(void) startMoreAction :(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    More *logInContr = [[More alloc] initWithNibName:@"More" bundle:[NSBundle mainBundle]];
    bBeOnTvLaunched=NO;
    [appDelegate.tabBarController setSelectedIndex:4];
    //self.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:logInContr  animated:YES];    
    [logInContr release];
    
}


- (UIView*)setMyownOverlay
{
    
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
    [appDelegate stopAdvertisingBar];
	[appDelegate startAdvertisingBar];
    myOwnOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) ];
    
    if (myOwnOverlay) {
        myOwnOverlay.backgroundColor = [UIColor clearColor];
         
        cameraSelectionButton = [UIButton 
                                 buttonWithType:UIButtonTypeCustom];
        [cameraSelectionButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchDown];
        cameraSelectionButton.frame = CGRectMake(244, 35, 72, 37);
        cameraSelectionButton.enabled= YES;
        [cameraSelectionButton setImage:[UIImage imageNamed:@"cameratogglepressed.png"] forState:UIControlStateNormal];
        //cameraSelectionButton.alpha = 0.0;
        [self.myOwnOverlay addSubview:cameraSelectionButton];
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youtoo-logo-wbg.png"]];
        [imageView setFrame:CGRectMake(5, 35,95, 126)];
        [self.myOwnOverlay addSubview:imageView];
        [imageView release];
        
        UIImageView *logoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"socialTV.png"]];
        [logoimageView setFrame:CGRectMake(4, 122, 86, 30)];
        //[self.myOwnOverlay addSubview:logoimageView];
        [logoimageView release];
        beontvImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beontv.png"]];
        [beontvImgView setFrame:CGRectMake(58, 325, 200, 80)];
        [self.myOwnOverlay addSubview:beontvImgView];

        
        //create the button and assign the image
        
        // Schedule button
        cancelBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtnImg setImage:[UIImage imageNamed:@"schedule.png"] forState:UIControlStateNormal];
        [cancelBtnImg addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
        //sets the frame of the button to the size of the image
        cancelBtnImg.frame = CGRectMake(0, 425, 63, 62);
        cancelBtnImg.enabled= YES;
        [self.myOwnOverlay addSubview:cancelBtnImg];
        
        // Videos button
        videosButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [videosButton setImage:[UIImage imageNamed:@"videos.png"] forState:UIControlStateNormal];
        [videosButton addTarget:self action:@selector(startVideosAction:) forControlEvents:UIControlEventTouchUpInside];
        //sets the frame of the button to the size of the image
        videosButton.frame = CGRectMake(60, 425, 63, 62);
        videosButton.enabled= YES;
        [self.myOwnOverlay addSubview:videosButton];
        
        // Be On TV button
        startBtnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtnImg addTarget:self action:@selector(beOnTvAction:) forControlEvents:UIControlEventTouchUpInside];
        startBtnImg.frame = CGRectMake( 114, 400, 90, 80);
        startBtnImg.enabled= YES;
        [startBtnImg setImage:[UIImage imageNamed:@"be-on-tv-transparent.png"] forState:UIControlStateNormal];        
        [startBtnImg setImage:[UIImage imageNamed:@"BeOnTV_b-icon-blue.png"] forState:UIControlStateHighlighted];
        
        [self.myOwnOverlay addSubview:startBtnImg];
        //BeOnTV_b-icon-blue.png
        
        // Profile button
        profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [profileButton setImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
        [profileButton addTarget:self action:@selector(startProfileAction:) forControlEvents:UIControlEventTouchUpInside];
        //sets the frame of the button to the size of the image
        profileButton.frame = CGRectMake(195, 425, 63, 62);
        profileButton.enabled= YES;
        [self.myOwnOverlay addSubview:profileButton];
        
        // More button
        moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(startMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        //sets the frame of the button to the size of the image
        moreButton.frame = CGRectMake(258, 425, 63, 62);
        moreButton.enabled= YES;
        [self.myOwnOverlay addSubview:moreButton];
        
    }
    
    return myOwnOverlay;
}

- (void)changeCamera:(id)sender {
    
    if (pickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    beOnTvActionClicked = NO;
    
    if ( bBeOnTvLaunched==NO )
        [self LaunchVideoRecording];
    
    bBeOnTvLaunched = YES;
    
    //[self grabProfileInfoIntheBackgroud];
    
   // [self authAgain];
    
   /* YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ( appDelegate.userIsSignedIn==NO )
    {
        NSLog(@"User login session broken somehow, get it authenticated again");
     
    appDelegate.loginName = NULL; 
    appDelegate.passwordString = NULL; 
    appDelegate.loginName = [appDelegate readUserName];
    appDelegate.passwordString = [appDelegate readLoginPassword];
    NSLog(@"Email: %@; Password: %@", appDelegate.loginName, appDelegate.passwordString); 
    if ( ( appDelegate.loginName==NULL || [appDelegate.loginName length]<=0 ) || ( appDelegate.passwordString==NULL || [appDelegate.passwordString length]<=0 ) ) 
    { 
        //  [appDelegate reportError:NSLocalizedString(@"Youtoo 2.0", @"Alert Text") description:@"Email or password fields cannot be empty"];
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", appDelegate.loginName, appDelegate.passwordString];
        NSLog(@"Constructed Login URL: %@", path);
        
        self.isNetworkOperation = YES;
        NSLog(@"request auth: %@", path);
        [networkQueue cancelAllOperations];
        [networkQueue setDelegate:self];
        ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
                                        [NSURL URLWithString:path]] autorelease];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [request setTimeOutSeconds:20];
        [networkQueue addOperation:request];
        [networkQueue go];
    }
    }*/
    
}

/*-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( bBeOnTvLaunched==NO )
        [self LaunchVideoRecording];
        
    bBeOnTvLaunched = YES;
}*/
  
- (BOOL)canShowAdvertising
{
	return YES;
}
-(void)fameSoptAct:(id)sender

{
    [self dismissModalViewControllerAnimated:YES];
    bBeOnTvLaunched=NO;
    
    RecordAfameSpot *fameSpotViewContr = [[RecordAfameSpot alloc] initWithNibName:@"RecordAfameSpot" bundle:nil];
    [self.navigationController pushViewController:fameSpotViewContr animated:YES];
    [fameSpotViewContr release];
}
-(void)tickerSpotAct:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    bBeOnTvLaunched=NO;

    WriteAtickerShout *tickerSpotViewContr = [[WriteAtickerShout alloc] initWithNibName:@"WriteAtickerShout" bundle:nil :nil];
    
    [self.navigationController pushViewController:tickerSpotViewContr animated:YES];
    [tickerSpotViewContr release];
    
}
-(void)helpViewAct:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    bBeOnTvLaunched=NO;

    HelpItemScreen *helpViewContr = [[HelpItemScreen alloc] initWithNibName:@"HelpItemScreen" bundle:nil];
    [self.navigationController pushViewController:helpViewContr animated:YES];
    [helpViewContr release];
}



#pragma mark -
#pragma mark XMLParser
#pragma mark -

- (void)parseXMLFilewithData:(NSData *)data
{
    self.sendResult = @"";
    self.rssParser = [[[NSXMLParser alloc] initWithData:data] autorelease];		
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self performSelectorOnMainThread:@selector(showAlertErrorParsing) 
                           withObject:parseError waitUntilDone:NO];
	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	    
    
    NSLog(@"Login: trimmString: %@", trimmString);
    
	if ([self.currentElement isEqualToString:@"auth"] && [trimmString length] > 0)
	{
		
		appDelegate.userIsSignedIn = ![string isEqualToString:@"NULL"];
		appDelegate.userIDCode = appDelegate.userIsSignedIn ?  string : nil;
	}
    else if ([self.currentElement isEqualToString:@"result"] && [trimmString length] > 0)
	{
		self.sendResult = string;
	}
    
    
    if ( ( [self.currentElement isEqualToString:@"name"] || [self.currentElement isEqualToString:@"username"]) && [trimmString length] > 0 )
    {
        //self.profileName = trimmString;
        if ( ![trimmString isEqualToString:@"Not logged in"] )
            appDelegate.userName = @"";
        else
            appDelegate.userName = trimmString;
    }
    if ([self.currentElement isEqualToString:@"user_image"] && [trimmString length] > 0)
    {
        //self.profImagePAthStr = trimmString;x
        appDelegate.userImage = trimmString;
    }
    if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
    {
        //self.creditStr = trimmString;
        appDelegate.creditStr = trimmString;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (nil == appDelegate.userIDCode)
	{
		//[appDelegate reportError:NSLocalizedString(@"Your e-mail or password is incorrect", @"Alert Text") description:self.sendResult];        
	}	
	else if ([self.sendResult length] > 0)
	{
		//[appDelegate reportError:NSLocalizedString(@"Signing In", @"Alert Text") description:self.sendResult];
	}	
	else
	{
		// save login name and password to permenant storage bcoz it is being successful.
      //  [appDelegate SaveLoginData];
	}
    
	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}

- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	//[activityIndicator stopAnimating];
	//[self updateView];
}

#pragma mark -
#pragma mark end ASIHTTPRequest Request
#pragma mark -

- (void)requestDone:(ASIHTTPRequest *)request
{    
    [networkQueue setDelegate:nil];
	[request setDelegate:nil];
	//[activityIndicator stopAnimating];
	NSData *responseData = [request responseData];
	NSLog(@"Login Response: %@", [request responseString]);
	
    [self parseXMLFilewithData:responseData];
}

- (void)postDone:(ASIHTTPRequest *)request
{
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    
}

- (void)showAlertErrorParsing
{
    //	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Registration Error", @"Alert Title")
    //													 message:NSLocalizedString(@"Please navigate to Broadcast ticker and try again.", @"Alert Description") 
    //													delegate:self 
    //										   cancelButtonTitle:nil 
    //										   otherButtonTitles:nil] autorelease];
    //	
    //	[alert addButtonWithTitle:NSLocalizedString(@"OK", @"Button Title")];
    //	alert.tag = 1234;
    //	[alert show];
}

- (void)grabProfileInfoIntheBackgroud
{
    /*NSURL *url = [NSURL URLWithString:@"http://www.youtoo.com/iphoneyoutoo/profile/"];
    
    NSString *urlStr = [NSString stringWithFormat:@"To get new profile: %@", url];    
    NSLog(urlStr);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous]; */
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/"];
    NSLog(@"To get new profile: %@", path);
    self.isNetworkOperation = YES;

    [networkQueue cancelAllOperations];
    [networkQueue setDelegate:self];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
                                    [NSURL URLWithString:path]] autorelease];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request setTimeOutSeconds:20];
    [networkQueue addOperation:request];
    [networkQueue go];
}

-(void) authAgain
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", 
                      [appDelegate readUserName], [appDelegate readLoginPassword]];
    
    //ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
    //                          [NSURL URLWithString:path]] autorelease];
    NSLog(path);
    
    /* NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
     [request setURL:[NSURL URLWithString:path]];
     [request setHTTPMethod:@"GET"];
     
     NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     
     NSLog(returnString); */
    NSURL *url = [NSURL URLWithString:path];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    [self parseXMLFilewithData:responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

@implementation UITabBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"25-ScheduleInitial-tb1.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+5)];
}
@end
