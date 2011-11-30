//
//  ScheduleEpisodeDetail.m
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ScheduleEpisodeDetail.h"
#import "YoutooAppDelegate.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "Constants.h"
#import "ScheduleDetailCell.h"
#import "RecordA15SecVideo.h"
#import "WriteAtickerShout.h"
#import "ProfileFriendView.h"
static const CGFloat kFeaturedRowHeight = 80.0;

@implementation ScheduleEpisodeDetail

@synthesize itemStorage;
@synthesize item;
@synthesize currentElement;
@synthesize rssParser;

@synthesize showEpiImage;
@synthesize showEpiTitle;
@synthesize showEpiBriefDesc;
@synthesize epiDescription;
@synthesize showEpiQuestion;
@synthesize activityIndicator;
@synthesize epiBriefDescStr;
@synthesize epiTitleStr;
@synthesize epiQuestStr;
@synthesize epiDetailDescStr;
@synthesize epiThumnailImg;
@synthesize dateLbl;
@synthesize fameSpotButton;
@synthesize socialShoutButton;
@synthesize lastKnownLocation;
@synthesize checkInButton;
@synthesize likeButton;
@synthesize favoritesButton;
@synthesize sendResult;
@synthesize epiQuesIDtStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myItemModel = aModel;
        
        self.sendResult = @"";
        self.currentElement = @"";
		//itemStorage = [[ItemStorage alloc] init];
		isNetworkOperation = NO;
    }
    return self;
}

- (void)dealloc
{
    [item release];
	self.currentElement = nil;
	self.rssParser= nil;
	//[itemStorage release];
    
    showEpiImage=nil;
    showEpiTitle=nil;
    showEpiBriefDesc=nil;
    epiDescription=nil;
    
    epiBriefDescStr=nil;
    epiTitleStr=nil;
    epiQuestStr=nil;
    epiDetailDescStr=nil;
    epiThumnailImg = nil;
    showEpiQuestion = nil;
    [dateLbl release];
    //[fameSpotButton release];
    //[socialShoutButton release];
    
    //[checkInButton release];
    //[likeButton release ];
    //[favoritesButton release];
    [epiQuesIDtStr release];
    [activityIndicator release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    // Release any cached data, images, etc that aren't in use.
    if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
        self.rssParser = nil;
	}
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
   // [self.itemStorage cleanImages];
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"Batman";
    epiDescription.backgroundColor = [UIColor clearColor];
    self.title = myItemModel.showName;
    showEpiQuestion.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate stopAdvertisingBar];
    //appDelegate.selectedController = self;
    //[appDelegate startAdvertisingBar];
    
    showEpiTitle.numberOfLines = 2;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSLog(@"date: %@", dateString);
    dateLbl.text = dateString;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    isNetworkOperation = YES;
    [activityIndicator startAnimating];
    [appDelegate didStartNetworking];
    // Get the current timezone in hours and send to server...
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
    NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/showDetails/%@", myItemModel.episodeid];
    
    // [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/showDetails/YBM0002"];
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopAdvertisingBar];
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
    
	
}

- (void)reloadPage
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    /*NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"ScheduleLastUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || -[pageLastUpdate timeIntervalSinceNow] > kUpdatePeriod))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"ScheduleLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/showDetails/%@", myItemModel.episodeid];
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
	}*/
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	isNetworkOperation = NO;
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	//appDelegate.selectedController = nil;
	[appDelegate didStopNetworking];
}


-(IBAction) fameSpotAction :(id) sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.epiQuestionID = self.epiQuesIDtStr;
    
    NSLog(@"myItemModel.showName: %@", myItemModel.showName);
    NSLog(@"self.epiQuestStr: %@", self.epiQuestStr);
    NSLog(@"self.epiQuesIDtStr: %@", self.epiQuesIDtStr);
    NSLog(@"appDelegate.epiQuestionID: %@", appDelegate.epiQuestionID);
    
    //appDelegate.episodeName = [NSString stringWithFormat:@"%@",(myItemModel.showName!=NULL) ? myItemModel.showName : @""];
   // appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:@": "];
    //appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:(self.epiQuestStr!=NULL)?self.epiQuestStr:@""];
    
    appDelegate.titleString = [NSString stringWithFormat:@"%@",(myItemModel.showName!=NULL) ? myItemModel.showName : @""];
    NSLog(@"appDelegate.titleString: %@", appDelegate.titleString);
    NSString *tempTxt = [NSString stringWithFormat:@"%@", @""];
    
    for (int i=0; i<[appDelegate.titleString length] ; i++)
    {
        tempTxt = [tempTxt stringByAppendingString:@"  "];
    }
    appDelegate.episodeName = [ NSString stringWithFormat:@"%@", tempTxt];
    appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:(self.epiQuestStr!=NULL)?self.epiQuestStr:@""];
    
    RecordA15SecVideo *recordViewContr = [[RecordA15SecVideo alloc] initWithNibName:@"RecordA15SecVideo" bundle:nil];
    [self.navigationController pushViewController:recordViewContr animated:YES];
    [recordViewContr release];
}

-(IBAction) socialShoutAction :(id) sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.epiQuestionID = myItemModel.questionID;
    appDelegate.episodeName= myItemModel.questionName;
    
    WriteAtickerShout *tickerSpotViewContr = [[WriteAtickerShout alloc] initWithNibName:@"WriteAtickerShout" bundle:nil :myItemModel];
    
    [self.navigationController pushViewController:tickerSpotViewContr animated:YES];
    //[self presentModalViewController:tickerSpotViewContr animated:YES];
    [tickerSpotViewContr release];
}

-(IBAction) checkInAction :(id) sender
{
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];

     YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/checkin/%@", myItemModel.showID]; // blog id here is nothing but video id.
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
}
-(IBAction) likeAction :(id) sender
{
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/like/%@", myItemModel.showID];
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
}
-(IBAction) favoritesAction :(id) sender
{
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/saveFav/%@", myItemModel.showID];
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
    
}
-(IBAction) followAction :(id) sender
{
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/follow/show/%@", myItemModel.showID];
    
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
    
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


# pragma mark -
# pragma mark LocationGetter Delegate Methods

- (void)newPhysicalLocation:(CLLocation *)location {
    
    // Store for later use
    self.lastKnownLocation = location;   
    
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
	//[self performSelectorOnMainThread:@selector(showAlertNoConnection:) 
	//					   withObject:parseError waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
	if ([elementName isEqualToString:@"episodedata"])
	{
		//[self.itemStorage cleanStorage];
        
        fameSpotButton.enabled = NO;
        socialShoutButton.enabled = NO;        
        checkInButton.enabled = NO;
        likeButton.enabled = NO;
        favoritesButton.enabled = NO;
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
    fameSpotButton.enabled = YES;
    socialShoutButton.enabled = YES;        
    checkInButton.enabled = YES;
    likeButton.enabled = YES;
    favoritesButton.enabled = YES;
}

- (BOOL)canShowAdvertising
{
	return YES;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSLog(@"trimmString: %@", trimmString);
    NSLog(@"self.currentElement:%@", self.currentElement);
    
	if ([trimmString length] > 0 && [self.currentElement isEqualToString:@"longepisodedescription"])
	{
        self.epiBriefDescStr = trimmString;
	}
	if ([trimmString length] > 0 && [self.currentElement isEqualToString:@"shortepisodedescription"])
	{
        self.epiTitleStr = trimmString;
	}
	if ([trimmString length] > 0 && [self.currentElement isEqualToString:@"showlongdescription"])
	{
        self.epiDetailDescStr = trimmString;
	}
	if ([trimmString length] > 0 && [self.currentElement isEqualToString:@"question"])
	{
        self.epiQuestStr = trimmString;
	}
	if ([trimmString length] > 0 && [self.currentElement isEqualToString:@"questionid"])
	{
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.epiQuestionID = trimmString;
        self.epiQuesIDtStr = trimmString;
	}
    if ([trimmString length] > 0 && [self.currentElement isEqualToString:@"thumbnail"])
	{
        self.epiThumnailImg = trimmString;
	}
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
	[activityIndicator stopAnimating];
    [self updateView];
}

- (void)updateView
{
   // YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;

    if ( self.epiTitleStr!=NULL )
        showEpiTitle.text = self.epiTitleStr;
    if ( self.epiBriefDescStr!=NULL )
        showEpiBriefDesc.text = self.epiBriefDescStr;
    if ( self.epiQuestStr!=NULL )
        showEpiQuestion.text = self.epiQuestStr;
    if ( self.epiDetailDescStr!=NULL )
        epiDescription.text = self.epiDetailDescStr;
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *encodedURL;
    
    if ( self.epiThumnailImg )
    {
        encodedURL = [appDeleagte encodeURL:self.epiThumnailImg];
        NSLog(@"Thumbnail encodedURL: %@",encodedURL);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedURL]];
        UIImage *image = [UIImage imageWithData:imageData]; 
        showEpiImage.image = image;
    }
    else
    {
        showEpiImage.image = [UIImage imageNamed:@"logo.png"];
    }
}

- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
				 description:@"Internet connection is must to run this product."];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
