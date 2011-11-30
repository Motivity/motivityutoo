//
//  VideosDone.m
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "VideosDone.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "MoviePlayer.h"
#import "YoutooAppDelegate.h"
#import "ProfileFriendView.h"

@implementation VideosDone

@synthesize videoThumbnail;
@synthesize profileImage;
@synthesize profileName;
@synthesize likeBTnAction;
@synthesize shareeBTnAction;
@synthesize favoritesBTnAction;
@synthesize itemStorage;
@synthesize item;
@synthesize currentElement;
@synthesize rssParser;
@synthesize sendResult;
@synthesize videoPath;
@synthesize titleLabl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel*) aItemModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myItemModel = aItemModel;
        self.sendResult = @"";
        self.currentElement = @"";
		itemStorage = [[ItemStorage alloc] init];
		isNetworkOperation = NO;
    }
    return self;
}

- (void)dealloc
{
    [videoThumbnail release];
    [profileImage release];
    [profileName release];
    [videoPath release];
    [likeBTnAction release];;
    [shareeBTnAction release];
    [favoritesBTnAction release];
    [titleLabl release];
    [item release];
	self.currentElement = nil;
	self.rssParser= nil;
	[itemStorage release];
    [playerController release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"myItemModel.friendName:%@",myItemModel.friendName);
    NSLog(@"myItemModel.storageImage:%@",myItemModel.storageImage);
    NSLog(@"myItemModel.storageImage:%@",myItemModel.videoPath);
    
    self.title = (myItemModel.friendName!=NULL)?myItemModel.friendName:@"User";
    
    if ( myItemModel.storageImage==NULL )
    {
        [profileImage setImage:[UIImage imageNamed:@"img.png"]];
        [videoThumbnail setImage:[UIImage imageNamed:@"img.png"]];
    }
    else
    {
        [profileImage setImage:myItemModel.storageImage];
        [videoThumbnail setImage:myItemModel.storageImage];
    }
    
    profileName.text = (myItemModel.friendName!=NULL)?myItemModel.friendName:@"User";
    titleLabl.text = (myItemModel.friendName!=NULL)?myItemModel.friendName:@"User";
    self.videoPath = myItemModel.videoPath;
    
    appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.tvIsChecke = NO;
    appDelegate.mobileIsChecked = NO;
    appDelegate.webIsChecked = NO;
    appDelegate.tvIsChecke = NO;
    appDelegate.tweetIsChecked= NO;
    appDelegate.fbIsChecked = NO;
    appDelegate.youtubeIsChecked=NO;
    appDelegate.googleIsChecke=NO;
    appDelegate.youtooIsChecked = NO;
    
    //appDelegate.selectedController = self;
    //[appDelegate startAdvertisingBar];
    

}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
    
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    appDelegate.selectedController = NULL;
    [appDelegate stopAdvertisingBar];   
}
/*-(void) reloadPage
{
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
}*/
- (BOOL)canShowAdvertising
{
	return YES;
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


/* ORIGNAL FUNCTION
-(IBAction)demoVideoAction
{
	YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.selectedController = self;
    [appDelegate stopAdvertisingBar];
    
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Megamind" ofType:@"mov"]];
    NSURL *vidurl = [NSURL URLWithString:self.videoPath];
    MPMoviePlayerViewController * playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:vidurl];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedPlayback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
    [playerController setWantsFullScreenLayout:YES];
    playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [playerController.moviePlayer play];
    [playerController release];
    playerController=nil;
    NSLog(@"playvideo");
    [playerController didAnimateFirstHalfOfRotationToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];    
   
}*/

// TEST FUNCTION
-(IBAction)demoVideoAction
{
	//YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.selectedController = self;
    [appDelegate stopAdvertisingBar];
    
    
    NSURL *vidurl = [NSURL URLWithString:self.videoPath];
    playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:vidurl];
    
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
     [playerController setWantsFullScreenLayout:YES];
    currentOrientation = [[UIDevice currentDevice] orientation];
    
    if ( currentOrientation==UIDeviceOrientationPortrait )
    {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        [[playerController view] setFrame:CGRectMake(0, 0, 320, 480)];
    }
    else if ( currentOrientation==UIDeviceOrientationLandscapeLeft )
    {        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        [[playerController view] setFrame:CGRectMake(0, 0, 320, 480)];
    }
    else if ( currentOrientation==UIDeviceOrientationLandscapeRight )
    {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
        [[playerController view] setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    
    [playerController.moviePlayer play];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
 
}

- (void)didRotate
{
    currentOrientation = [[UIDevice currentDevice] orientation];
    NSLog(@"currentOrientation: %d", currentOrientation);
    
    if ( currentOrientation==UIDeviceOrientationLandscapeLeft)// || currentOrientation==UIDeviceOrientationLandscapeRight)
    {   
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];

        NSLog(@"Landscape mode"); 
        [playerController.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        [[playerController view] setFrame:CGRectMake(0, 0, 320, 480)];
    }
    else if(currentOrientation==UIDeviceOrientationLandscapeRight)
    {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

        NSLog(@"Landscape mode"); 
        [playerController.view setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
        [[playerController view] setFrame:CGRectMake(0, 0, 320, 480)];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];

        NSLog(@"Portrait mode");
        [playerController.view setTransform:CGAffineTransformMakeRotation(0)];
        [[playerController view] setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction) likeAction  :(id) sender
{
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/like/%@/%@", myItemModel.videoID,appDelegate.userIDCode];
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
}

-(IBAction) shareAction :(id) sender
{
    CGRect frame = CGRectMake(0, 160, 320, 300);
    shareActionSheetView = [ [UIView alloc] initWithFrame:frame];
    shareActionSheetView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"box-500x400.png"]]; 
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(80.0,10.0,110.0,30.0)] autorelease];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor]; 
    label.font = [UIFont fontWithName:@"Verdana" size:16.0];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"Share video file";
    [label sizeToFit];
    [shareActionSheetView addSubview:label];
    
    twitterButton = [UIButton buttonWithType: UIButtonTypeCustom];    
    [twitterButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
    [twitterButton addTarget: self action: @selector(tweetBtnAction:) forControlEvents: UIControlEventTouchUpInside];
    twitterButton.frame= CGRectMake( 40.0, 65.0, 33.0, 33.0);
    [shareActionSheetView addSubview:twitterButton];
    UIImageView *twitterImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitterT.png"]];
    twitterImage.frame= CGRectMake( 90.0, 65.0, 45.0, 45.0);
    [shareActionSheetView addSubview:twitterImage];
    
    fbButton = [UIButton buttonWithType: UIButtonTypeCustom];    
    [fbButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
    [fbButton addTarget: self action: @selector(fbBtnAction:) forControlEvents: UIControlEventTouchUpInside];
    fbButton.frame= CGRectMake( 40.0, 135.0, 33.0, 33.0);
    [shareActionSheetView addSubview:fbButton];
    UIImageView *fbImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Facebookf.png"]];
    fbImage.frame= CGRectMake( 90.0, 135.0, 45.0,45.0);
    [shareActionSheetView addSubview:fbImage];

    
    youtubeButton = [UIButton buttonWithType: UIButtonTypeCustom];    
    [youtubeButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
    [youtubeButton addTarget: self action: @selector(youtubeBtnAction:) forControlEvents: UIControlEventTouchUpInside];
    youtubeButton.frame= CGRectMake( 180.0, 65.0, 33.0, 33.0);
    [shareActionSheetView addSubview:youtubeButton];
    [shareActionSheetView addSubview:fbButton];
    UIImageView *youtubeImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youtube.png"]];
    youtubeImage.frame= CGRectMake( 225.0, 65.0, 45.0,45.0);
    [shareActionSheetView addSubview:youtubeImage];
    
    youtooButton = [UIButton buttonWithType: UIButtonTypeCustom];    
    [youtooButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
    [youtooButton addTarget: self action: @selector(youtooBtnAction:) forControlEvents: UIControlEventTouchUpInside];
    youtooButton.frame= CGRectMake( 180.0, 135.0, 33.0, 33.0);
    [shareActionSheetView addSubview:youtooButton];
    UIImageView *youtooImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    youtooImage.frame= CGRectMake( 225.0, 135.0, 45.0,45.0);
    [shareActionSheetView addSubview:youtooImage];
    
   googleButton = [UIButton buttonWithType: UIButtonTypeCustom];    
    [googleButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
    googleButton.frame= CGRectMake( 225.0, 65.0, 33.0, 33.0);
    [googleButton addTarget: self action: @selector(googleBtnAction:) forControlEvents: UIControlEventTouchUpInside];
   // [shareActionSheetView addSubview:googleButton];
    UIImageView *googleImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"google.png"]];
    googleImage.frame= CGRectMake( 265.0, 65.0, 45.0,45.0);
    //[shareActionSheetView addSubview:googleImage];
    
    UIButton *cancelBttn = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelBttn.frame = CGRectMake(55.0, 205.0, 90.0, 30.0);
    [cancelBttn setBackgroundImage:[UIImage imageNamed:@"cancel1.png"] forState:UIControlStateNormal];
    [cancelBttn addTarget: self action: @selector(shareCancelAction:) forControlEvents: UIControlEventTouchUpInside];
   	[shareActionSheetView addSubview:cancelBttn];
    [self.view addSubview:shareActionSheetView];
    
    UIButton *submitBttn = [UIButton buttonWithType: UIButtonTypeCustom];
    submitBttn.frame = CGRectMake(180.0, 205.0, 90.0, 30.0);
    [submitBttn setBackgroundImage:[UIImage imageNamed:@"apply.png"] forState:UIControlStateNormal];
    [submitBttn addTarget: self action: @selector(applyeShareVideoAction:) forControlEvents: UIControlEventTouchUpInside];
   	[shareActionSheetView addSubview:submitBttn];
    [self.view addSubview:shareActionSheetView];
    
    [self.view addSubview:shareActionSheetView];
}

-(IBAction) shareCancelAction : (id) sender
{
 	[shareActionSheetView removeFromSuperview];
}

-(IBAction) favoritesction  :(id) sender
{
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/saveFav/%@", myItemModel.videoID];
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
    
}

-(IBAction) applyeShareVideoAction : (id) sender
{
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    
   // YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
  /*  NSString *typeStr=NULL;
    
    
    NSString *t = @"tweet";
    NSString *fb = @"fb";
    NSString *g = @"google";
    NSString *youtube = @"youtube";
    NSString *youtoo = @"youtoo";
    */
    
    NSString *typeStr=NULL;
    // mobile    
    
    // twitter
    //typeStr = [NSString stringByAppendingString:@"/"];
    if (appDelegate.tvIsChecke )
        typeStr = [NSString stringWithFormat:@"1"];
    else
        typeStr = [NSString stringWithFormat:@"0"];
    
    typeStr = [typeStr stringByAppendingString:@"/"];
    
    // facebook
    if (appDelegate.fbIsChecked)
    {            
        typeStr = [typeStr stringByAppendingString:@"1"];
    }
    else
        typeStr = [typeStr stringByAppendingString:@"0"];
    typeStr = [typeStr stringByAppendingString:@"/"];
    
    if (appDelegate.youtubeIsChecked)
    {
        typeStr = [typeStr stringByAppendingString:@"1"];        
    }
    else
        typeStr = [typeStr stringByAppendingString:@"0"];

    typeStr = [typeStr stringByAppendingString:@"/"];

    if (appDelegate.youtooIsChecked)
    {
        typeStr = [typeStr stringByAppendingString:@"1"];        
    }
    else
        typeStr = [typeStr stringByAppendingString:@"0"];

    NSLog(@"typeStr: %@", typeStr);
    
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/share/%@/%@", myItemModel.videoID, typeStr];
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];

}

#pragma mark -
#pragma mark XMLParser
#pragma mark -

- (void)parseXMLFilewithData:(NSString *)strURL
{	
    self.sendResult = @"";
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *dataURL = [NSURL URLWithString:strURL];
	self.rssParser = [[[NSXMLParser alloc] initWithContentsOfURL:dataURL] autorelease];
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
	[pool release];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{	
	[self performSelectorOnMainThread:@selector(showAlertNoConnection:) 
						   withObject:parseError waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
	if ([elementName isEqualToString:@"episodedata"])
	{
		//[self.itemStorage cleanStorage];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([self.sendResult length] > 0)
	{
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:self.sendResult];
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"trimmString: %@", trimmString);
    NSLog(@"self.currentElement:%@", self.currentElement);
    
	
    if ( [trimmString length] > 0 && [self.currentElement isEqualToString:@"like"] )
    {
        self.sendResult = trimmString;
    }
    if ( [trimmString length] > 0 && [self.currentElement isEqualToString:@"result"] )
    {
        self.sendResult = trimmString;
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{	
	[self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
}

#pragma mark -

- (void)didStopLoadData
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	//[activityIndicator stopAnimating];
    //[self updateView];
}

#pragma mark - View lifecycle


-(IBAction)tweetBtnAction:(id)sender
{
    if ( !appDelegate.tvIsChecke )
    {
        appDelegate.tvIsChecke = YES;
        
		[twitterButton setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.tvIsChecke = NO;
		[twitterButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction)fbBtnAction:(id)sender
{
    if ( !appDelegate.fbIsChecked )
    {
        appDelegate.fbIsChecked = YES;
        
		[fbButton setImage:[UIImage imageNamed:@"checkmark.png.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.fbIsChecked = NO;
		[fbButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction)googleBtnAction:(id)sender
{
    if ( !appDelegate.googleIsChecke )
    {
        appDelegate.googleIsChecke = YES;
        
		[googleButton setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.googleIsChecke = NO;
		[googleButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
    
}


-(IBAction)youtubeBtnAction:(id)sender
{
    if ( !appDelegate.youtubeIsChecked )
    {
        appDelegate.youtubeIsChecked = YES;
        
		[youtubeButton setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.youtubeIsChecked = NO;
		[youtubeButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
}

-(IBAction)youtooBtnAction:(id)sender
{
    if ( !appDelegate.youtooIsChecked )
    {
        appDelegate.youtooIsChecked = YES;
        
		[youtooButton setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.youtooIsChecked = NO;
		[youtooButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
}

- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
	
	[appDelegate didStopNetworking];
	//[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
				 //description:@"Internet connection is must to run this product."];
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft);
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
