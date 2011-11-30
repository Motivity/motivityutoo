//
//  UploadA15SecVideo.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "UploadA15SecVideo.h"
#import "UploadProcess.h"
#import "RecordA15SecVideo.h"
#import "ProfileImage.h"
#import "YoutooAppDelegate.h"
#import "PresentationController.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

@interface UploadA15SecVideo (PrivateMethods)
- (void)createThumbnailAtPath:(NSString *)videoPath;
- (void)requestThumbnail;
- (void)playVideoFile:(id)sender;
- (NSString *)grenerateUploadName;
@end

@implementation UploadA15SecVideo
@synthesize  thumbnailView, thumbnailImage, videoPlayer, playIcon;
@synthesize currentVideoPath;
@synthesize selectedSpotNameStr;
@synthesize facebookIsChecked;  
@synthesize  twitterkIsChecked;;
@synthesize twitterBtn;
@synthesize fbBtn;
@synthesize googleBtn;
@synthesize mobile;
@synthesize web;
@synthesize tv;
@synthesize youtubeBtn;
@synthesize playBtn1;
@synthesize playBtn2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
isNetworkOperation = NO;
    }
    return self;
}

- (void)dealloc
{
    self.currentVideoPath = nil;
	self.selectedSpotNameStr = nil;
    self.videoPlayer = nil;
    [playIcon release];
    [thumbnailView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    if (nil != self.videoPlayer)
	{
		[self.videoPlayer setInitialPlaybackTime:-1];
		[self.videoPlayer pause];
		[self.videoPlayer stop];
		
		//On a 4.0 device
		if ([self.videoPlayer respondsToSelector:@selector(setContentURL:)])
		{
			//[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
			[self.videoPlayer.view removeFromSuperview];
			[self.tabBarController dismissModalViewControllerAnimated:NO];
			[self.videoPlayer cancelAllThumbnailImageRequests];
		}
		
    }
	self.videoPlayer = nil;

    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Review and Submit";
    
    appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.selectedController = self;
	[appDelegate stopAdvertisingBar];
    
    
    //thumbnailView = [[ProfileImage alloc] initWithFrame:CGRectMake(100.0, 25.0, 100.0, 100.0)];
  //  thumbnailView = [[ProfileImage alloc] initWithFrame:CGRectMake(110.0, 50.0, -180.0, 80.0)];
    thumbnailView = [[ProfileImage alloc] initWithFrame:CGRectMake(30.0, 50.0, 260.0, 120.0)];
   
    
	thumbnailView.delegate = self;
	//thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
	thumbnailView.backgroundColor = [UIColor clearColor];
	if (nil != self.thumbnailImage)
	{
		thumbnailView.image = self.thumbnailImage;
	}
	if ( appDelegate.albumSelectedImg!=NULL )
        thumbnailView.image = appDelegate.albumSelectedImg;
   
	[self.view addSubview:thumbnailView];
    
    playIcon = [[ProfileImage alloc] initWithFrame:CGRectMake(100.0, 10.0, 45.0, 30.0)];
	playIcon.image = [UIImage imageNamed:@"arow.png"];
	playIcon.delegate = self;
	playIcon.alpha = 0.45;
	playIcon.center = thumbnailView.center;
    [self.view addSubview:playIcon];
    
    
    /*UIImageView *playImgView = [ [UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    playImgView.frame = CGRectMake(100.0, 10.0, 45.0, 30.0);
    [self.view addSubview:playImgView];
    */
    
    appDelegate.tvIsChecke = NO;
    appDelegate.mobileIsChecked = NO;
    appDelegate.webIsChecked = NO;
    appDelegate.tvIsChecke = NO;
    appDelegate.tweetIsChecked= NO;
    appDelegate.fbIsChecked = NO;
    appDelegate.youtubeIsChecked=NO;
    appDelegate.googleIsChecke=NO;
    
    UIImage *markImage;    
    markImage = [UIImage imageNamed:@"uncheckmark.png"];
    [mobile setImage:markImage forState:UIControlStateNormal];
    [web setImage:markImage forState:UIControlStateNormal];
    [tv setImage:markImage forState:UIControlStateNormal];
    
    
    markImage = [UIImage imageNamed:@"twitterT.png"];
    [twitterBtn setImage:markImage forState:UIControlStateNormal];
    
    
    markImage = [UIImage imageNamed:@"Facebookf.png"];
    [fbBtn setImage:markImage forState:UIControlStateNormal];
    
    markImage = [UIImage imageNamed:@"google.png"];
    [googleBtn setBackgroundImage:markImage forState:UIControlStateNormal];
    
    markImage = [UIImage imageNamed:@"youtube.png"];
    [youtubeBtn setBackgroundImage:markImage forState:UIControlStateNormal];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    appDelegate.selectedController = self;
	[appDelegate stopAdvertisingBar];
    
    
    if ([MPMoviePlayerViewController class])
	{
		NSLog(@"youtoo: call requestThumbnail");
		[self requestThumbnail];
	}
	else
	{
		NSLog(@"youtoo: call createThumbnailAtPath");
		[self createThumbnailAtPath:appDelegate.currentVideoPath];
	}
    
    
}
- (BOOL)canShowAdvertising
{
	return NO;
}
- (void)playerNotificationSelector:(NSNotification *)notification
{
	if ([notification.name isEqualToString:MPMoviePlayerPlaybackDidFinishNotification])
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		
		
		if (nil != self.videoPlayer)
		{
			[self.videoPlayer setInitialPlaybackTime:-1];
			[self.videoPlayer pause];
			[self.videoPlayer stop];
			
			//On a 4.0 device
			if ([self.videoPlayer respondsToSelector:@selector(setContentURL:)])
			{
				//[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
				[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
				[self.videoPlayer.view removeFromSuperview];
				[self dismissModalViewControllerAnimated:NO];
			}
			
			
		}
		self.videoPlayer = nil;
	}	
}

- (void)createThumbnailAtPath:(NSString *)videoPath
{
	NSString *videoDirectory = [videoPath stringByDeletingLastPathComponent];
	// The thumbnail jpg should located in this directory.
	NSString *thumbnailDirectory = [videoDirectory stringByDeletingLastPathComponent];
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	
	// Find the thumbnail for the video just recorded.
	NSString *file = nil;
	NSString *latestFile = nil;
	NSDate *latestDate = [NSDate distantPast];
	
	NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:
                                      [videoDirectory stringByDeletingLastPathComponent]];
	
	// Enumerate all files in the ~/tmp directory
	while (file = [dirEnum nextObject])
	{
		// Only check files with jpg extension.
		if ([[file pathExtension] isEqualToString: @"jpg"])
		{
			// Check if current jpg file is the latest one.
			if ([(NSDate *)[[dirEnum fileAttributes] valueForKey:@"NSFileModificationDate"] 
				 compare:latestDate] == NSOrderedDescending)
			{
				latestDate = [[dirEnum fileAttributes] valueForKey:@"NSFileModificationDate"];
				latestFile = file;
			}
		}
	}
	
	NSString *thumbnailPath = [thumbnailDirectory stringByAppendingPathComponent:latestFile];
	BOOL success = [fileManager fileExistsAtPath:thumbnailPath];
	if (success)
	{
		UIImage *anImage = [UIImage imageWithContentsOfFile:thumbnailPath];
		thumbnailView.image = anImage;
	}
}
- (void)requestThumbnail
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;

	
	if (nil != appDelegate.currentVideoPath)
	{		
		if (nil != playIcon.superview)
		{
			[playIcon removeFromSuperview];
		}
		
        
		
		MPMoviePlayerController *aPlayer = [[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:appDelegate.currentVideoPath] /*videoURL*/] autorelease];
		self.thumbnailImage = [aPlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
		
        [aPlayer stop];
        
		
		thumbnailView.image = self.thumbnailImage;
		if (nil == playIcon.superview)
		{
			[self.view addSubview:playIcon];
		}
	}
}

-(IBAction)tweetBtnAction:(id)sender
{
    if ( !appDelegate.tweetIsChecked )
    {
        appDelegate.tweetIsChecked = YES;
        
		[twitterBtn setImage:[UIImage imageNamed:@"twitterselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.tweetIsChecked = NO;
		[twitterBtn setImage:[UIImage imageNamed:@"twitterT.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction)fbBtnAction:(id)sender
{
    if ( !appDelegate.fbIsChecked )
    {
        appDelegate.fbIsChecked = YES;
        
		[fbBtn setImage:[UIImage imageNamed:@"FacebookSelected.png.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.fbIsChecked = NO;
		[fbBtn setImage:[UIImage imageNamed:@"Facebookf.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction)googleBtnAction:(id)sender
{
    if ( !appDelegate.googleIsChecke )
    {
        appDelegate.googleIsChecke = YES;
        
		[googleBtn setBackgroundImage:[UIImage imageNamed:@"googleselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.googleIsChecke = NO;
		[googleBtn setBackgroundImage:[UIImage imageNamed:@"google.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction)mobileAction:(id)sender
{
    if ( !appDelegate.mobileIsChecked )
    {
        appDelegate.mobileIsChecked = YES;
        
		[mobile setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.mobileIsChecked = NO;
		[mobile setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
    
}
-(IBAction)webAction:(id)sender
{
    if ( !appDelegate.webIsChecked )
    {
        appDelegate.webIsChecked = YES;
        
		[web setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.webIsChecked = NO;
		[web setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
}
-(IBAction)tvAction:(id)sender
{
    if ( !appDelegate.tvIsChecke )
    {
        appDelegate.tvIsChecke = YES;
        
		[tv setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.tvIsChecke = NO;
		[tv setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
}
-(IBAction)youtubeBtnAction:(id)sender
{
    if ( !appDelegate.youtubeIsChecked )
    {
        appDelegate.youtubeIsChecked = YES;
        
		[youtubeBtn setImage:[UIImage imageNamed:@"youtubeselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.youtubeIsChecked = NO;
		[youtubeBtn setImage:[UIImage imageNamed:@"youtube.png"] forState:UIControlStateNormal];
	}
}
- (IBAction)touchIconAction:(id)sender
{
	[self playVideoFile:nil];
}

- (void)playVideoFile:(id)sender
{
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;

	if (nil != appDelegate.currentVideoPath)
	{
		NSURL *videoURL = [NSURL URLWithString:appDelegate.currentVideoPath];
		self.videoPlayer = [[[MPMoviePlayerController alloc] initWithContentURL:videoURL] autorelease];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerNotificationSelector:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		
		//On a 4.0 device, implement the add self.videoPlayer.view
		if ([self.videoPlayer respondsToSelector:@selector(setContentURL:)])
		{
            YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
			[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
			self.videoPlayer.controlStyle = MPMovieControlStyleFullscreen;
			self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			
			PresentationController *presentationController= [[[PresentationController alloc] init] autorelease];
			
			CGRect windowRect = appDelegate.window.bounds;
			[presentationController.view addSubview:self.videoPlayer.view];
			presentationController.view.frame = windowRect;
			self.videoPlayer.view.frame = windowRect;
			
            
			[self presentModalViewController:presentationController animated:NO];
		}
		
		[self.videoPlayer setInitialPlaybackTime:-1];
		[self.videoPlayer play];
	}
    
    /*
    NSURL *videoURL = [NSURL URLWithString:appDelegate.currentVideoPath];
    MPMoviePlayerViewController * uploadPlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)uploadPlayerController];
    [uploadPlayerController setWantsFullScreenLayout:YES];
    uploadPlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [uploadPlayerController.moviePlayer play];
    [uploadPlayerController release];
    uploadPlayerController=nil;
    NSLog(@"playvideo"); */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(IBAction)successAct:(id)sender
{
    //[self dismissModalViewControllerAnimated:YES];
    
    UploadProcess *successdViewContr = [[UploadProcess alloc] initWithNibName:@"UploadProcess" bundle:nil];
    [self.navigationController pushViewController:successdViewContr animated:NO];
    [successdViewContr release];

}
-(IBAction)recordAct:(id)sender
{
    //[self dismissModalViewControllerAnimated:YES];
    
    RecordA15SecVideo *recordViewContr = [[RecordA15SecVideo alloc] initWithNibName:@"RecordA15SecVideo" bundle:nil];
    [self.navigationController pushViewController:recordViewContr animated:YES];
    [recordViewContr release];
}
- (IBAction)uploadToFacebookAction:(id)sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    if( !facebookIsChecked )
    {
		facebookIsChecked = YES;
        appDelegate.bFbCheckEnabledByUser = YES;
		//[uploadToFacebookButton setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
	}
    else
    {
        appDelegate.bFbCheckEnabledByUser = NO;
        facebookIsChecked = NO;
		//[uploadToFacebookButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
}

- (IBAction)uploadToTwitter:(id)sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    if( !twitterkIsChecked )
    {
		twitterkIsChecked = YES;
        appDelegate.bTwitterCheckEnabledByUser = YES;
		//[uploadToTwitterButton setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];		
	}
    else
    {
		twitterkIsChecked = NO;
        appDelegate.bTwitterCheckEnabledByUser = NO;
		//[uploadToTwitterButton setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
