//
//  WelcomeYoutoo.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "WelcomeYoutoo.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "PresentationController.h"

@implementation WelcomeYoutoo
@synthesize  isNetworkOperation;
@synthesize videoURL;
@synthesize thumbnailVIdeo;
@synthesize rssParser;
@synthesize sendResult;
@synthesize currentElement;
@synthesize imageView;
@synthesize activityIndicator;
@synthesize welcomeStr;
@synthesize welcomeTextView;
@synthesize bMoveNextScreen;
@synthesize skipdemobtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isNetworkOperation = NO;
        self.sendResult = @"";
        bMoveNextScreen = 0;
        //networkQueue = [[ASINetworkQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
 //   [networkQueue release];
    welcomeStr = nil;
    [welcomeTextView release];
    
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
    self.title = @"Welcome Note";
    self.videoURL = NULL;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];

       // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	[appDeleagte stopAdvertisingBar];
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/demovideo/"];
    NSLog(@"Constructed Login URL: %@", path);
    [activityIndicator startAnimating];
 /*   self.isNetworkOperation = YES;
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
    */
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    [tempURLStr appendFormat:path];
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
    welcomeTextView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.hidesBackButton = YES; 
    [[self navigationController] setNavigationBarHidden:YES];

}
-(void) updateView
{
    
    if (bMoveNextScreen==3)
    {
        bMoveNextScreen = 0;
        skipdemobtn.enabled = YES;
        [activityIndicator stopAnimating];
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate setupTabController];
    }
    else if (bMoveNextScreen==2)
    {
        [self getUserProfile];
    }
    else 
    {
        [activityIndicator stopAnimating];
        if (bMoveNextScreen==0)
        {
        NSLog(@"URLTHUMBNAIL: %@",self.thumbnailVIdeo); 
        YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
        NSString *encodedURL = [appDeleagte encodeURL:self.thumbnailVIdeo];
        NSLog(@"Thumbnail encodedURL: %@",encodedURL);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedURL]];
        UIImage *image = [UIImage imageWithData:imageData]; 
        imageView.image = image;
        
        welcomeTextView.text = self.welcomeStr;
        }
    }
    
}
-(IBAction)skipDemoAction
{
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate setupTabController];

    bMoveNextScreen = 1;
    
    //NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/"];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [appDelegate readUserName], [appDelegate readLoginPassword]];
    [activityIndicator startAnimating];
    NSLog(@"Constructed Login URL: %@", path);
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    [tempURLStr appendFormat:path];
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
    skipdemobtn.enabled = NO;
}
-(IBAction)demoVideoAction
{
	YoutooAppDelegate *appDeleagte = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    if ( self.isNetworkOperation==YES || self.videoURL==NULL )
    {
        [appDeleagte reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Network operation is happening, please try launching again!"];
        
        return;
    }
    NSLog(@"self.videoURL: %@", self.videoURL); 
    
    NSString *encodedURL = [appDeleagte encodeURL:self.videoURL];
    NSURL *vidurl = [NSURL URLWithString:encodedURL];    
    /*MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:vidurl];  
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {  
        // Use the new 3.2 style API  
        moviePlayer.controlStyle = MPMovieControlStyleDefault;  
        moviePlayer.shouldAutoplay = YES;  
        [self.view addSubview:moviePlayer.view];  
        [moviePlayer setFullscreen:YES animated:YES];  
    } else {  
        // Use the old 2.0 style API  
        moviePlayer.movieControlMode = MPMovieControlStyleDefault;  
        [moviePlayer play];  
    }  */
    
    MPMoviePlayerViewController * playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:vidurl];
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
    [playerController setWantsFullScreenLayout:YES];
    playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [playerController.moviePlayer play];
    [playerController release];
    playerController=nil;
    NSLog(@"playvideo");

}
-(void)getUserProfile
{
    
    bMoveNextScreen = 3;
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/"];
    
    NSLog(@"Constructed Login URL: %@", path);
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    [tempURLStr appendFormat:path];
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
    
    NSLog(@"self.currentElement: %@", self.currentElement);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *trimmString;
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if ( ![self.currentElement isEqualToString:@"text"] )
    {
        trimmString = [string stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Welcome: Doing Trimm: %@", trimmString);
    }
    else
    {
        trimmString = [string stringByTrimmingCharactersInSet:
                       [NSCharacterSet illegalCharacterSet]];
        NSLog(@"Welcome: Dont Trimm: %@", trimmString);
    }
    NSLog(@"Welcome: trimmString: %@", trimmString);
    
	if ([self.currentElement isEqualToString:@"videourl"] && [trimmString length] > 0)
	{
		self.videoURL = string;
	}
    else if ([self.currentElement isEqualToString:@"thumbnail"] && [trimmString length] > 0)
	{
		self.thumbnailVIdeo = string;
	}
    else if ([self.currentElement isEqualToString:@"text"] && [trimmString length] > 0)
	{
		self.welcomeStr = string;
	}
    
    else if ( ( [self.currentElement isEqualToString:@"name"] || [self.currentElement isEqualToString:@"username"]) && [trimmString length] > 0 )
    {
        appDelegate.userName = trimmString;
        NSLog(@"Welcome: appDelegate.userName: %@", appDelegate.userName);
    }
    if ([self.currentElement isEqualToString:@"user_image"] && [trimmString length] > 0)
    {
        appDelegate.userImage = trimmString;
        NSLog(@"Welcome: appDelegate.userImage: %@", appDelegate.userImage);
    }
    if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
    {
        appDelegate.creditStr = trimmString;
        NSLog(@"Welcome: appDelegate.creditStr: %@", appDelegate.creditStr);
    }
    
    if ([self.currentElement isEqualToString:@"auth"] && [trimmString length] > 0)
	{
		NSLog(@"Welcome: Auth success, go get the profile info, auth res: %@", string);
        bMoveNextScreen = 2;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{	
	//[self.itemStorage downloadImages];
	[self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
}

- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
    skipdemobtn.enabled = YES;
    bMoveNextScreen = 0;
	[activityIndicator stopAnimating];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
				 description:@"Internet connection is must to run this product (or) Server error."];
}

- (void)didStopLoadData
{
    self.isNetworkOperation = NO;
	//[activityIndicator stopAnimating];
	[self updateView];	
}

/*- (void)parseXMLFilewithData:(NSData *)data
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
    
    NSLog(@"self.currentElement: %@", self.currentElement);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *trimmString;
    
    if ( ![self.currentElement isEqualToString:@"text"] )
    {
        trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Welcome: Doing Trimm: %@", trimmString);
    }
    else
    {
        trimmString = [string stringByTrimmingCharactersInSet:
                       [NSCharacterSet illegalCharacterSet]];
        NSLog(@"Welcome: Dont Trimm: %@", trimmString);
    }
     NSLog(@"Welcome: trimmString: %@", trimmString);
    
	if ([self.currentElement isEqualToString:@"videourl"] && [trimmString length] > 0)
	{
		self.videoURL = string;
	}
    else if ([self.currentElement isEqualToString:@"thumbnail"] && [trimmString length] > 0)
	{
		self.thumbnailVIdeo = string;
	}
    else if ([self.currentElement isEqualToString:@"text"] && [trimmString length] > 0)
	{
		self.welcomeStr = string;
	}
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}

- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	[self updateView];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    bMoveNextScreen = 0;
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	[appDeleagte stopAdvertisingBar];    
}

- (BOOL)canShowAdvertising
{
	return NO;
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
   // return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft);
    //return YES;
}

#pragma mark -
#pragma mark end ASIHTTPRequest Request
#pragma mark -

- (void)requestDone:(ASIHTTPRequest *)request
{    
    [networkQueue setDelegate:nil];
	[request setDelegate:nil];
	[activityIndicator stopAnimating];
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

@end
