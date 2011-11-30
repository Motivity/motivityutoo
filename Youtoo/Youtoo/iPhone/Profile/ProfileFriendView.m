//
//  ProfileFriendView.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFriendView.h"
#import "ProfileCell.h"
#import "ProfileFollowing.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "ProfileFrndCcell.h"
#import "Constants.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ProfileFameSpot.h"
#import "ProfileTickerShouts.h"
#import "ProfileFavorites.h"
#import "ProfileRealStreamCell.h"

static const CGFloat kFeaturedRowHeight = 80.0;

@interface ProfileFriendView (PrivateMethods)
- (void)createCellLabels;
- (void)didStopLoadData;
@end

@implementation ProfileFriendView

@synthesize tableview;
@synthesize rssParser;
@synthesize item;
@synthesize currentElement;
@synthesize creditLbl;
@synthesize isNetworkOperation;
@synthesize activityIndicator;
@synthesize sendResult;
@synthesize imageArray;
@synthesize friendName;
@synthesize myFiends;
@synthesize itemStorage;
@synthesize follow;
@synthesize profileImage;
@synthesize friensStream;
@synthesize myFameSpotButton;
@synthesize mySHoutButton;
@synthesize myFavoriteButton;
@synthesize myFriendButton;
@synthesize userid;
@synthesize playerController;
@synthesize username;
@synthesize userimage;
@synthesize userpoints;


- (id)setupNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(NSString *) userID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userid = nil;
        myItemModel = nil;
        noOfCall = 0;
        
        // Custom initialization
        itemStorage = [[ItemStorage alloc] init];
        
        if ( aModel!=NULL )
            myItemModel = aModel;
        
        self.isNetworkOperation = NO;
        self.sendResult = @"";
        //networkQueue = [[ASINetworkQueue alloc] init];   
        
        if ( userID!=NULL )
            self.userid = userID;
        
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.tickerProfUserImage = NULL;
        appDelegate.tickerProfUsername = NULL;
        appDelegate.tickerProfUserPoints = NULL;
        
    }
    return self;
}

- (void)dealloc
{
   // self.item = nil;
    [item release];
	self.currentElement = nil;
	//[rssParser release];
    self.rssParser= nil;
    [activityIndicator release];
    [creditLbl release];
    [imageArray release];
    [friendName release];
    [myFiends release];
    [itemStorage release];
    [follow release];
    [profileImage release];
    [friensStream release];
    self.userid = nil;
    
    [super dealloc];
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)canShowAdvertising
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
        
    [tableview setDelegate:self];
	[tableview setDataSource:self];
    
    if ( myItemModel!=NULL )
    {
    NSLog(@"myItemModel.friendCredit: %@", myItemModel.friendCredit);
    
    // Do any additional setup after loading the view from its nib.    
    NSString *credit = NULL;
    if ( myItemModel.friendCredit!=NULL )
    {
        credit = [NSString stringWithFormat:@"%@", myItemModel.friendCredit];
        credit = [credit stringByAppendingFormat:@" Credits"];
        //creditLbl.text= myItemModel.friendCredit; 
        creditLbl.text= credit; 
    }
    
    friendName.text = myItemModel.friendName;    
    profileImage.image = (myItemModel.storageImage!=NULL) ?myItemModel.storageImage:[UIImage imageNamed:@"image.png"];
    
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
    [self.tableview reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    
   /* NSString *authpath = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", appDelegate.loginName, appDelegate.passwordString];
    NSLog(@"AuthRequest URL in ProfileFameS: %@", authpath);
    NSURL *authurl = [NSURL URLWithString:authpath];
    ASIHTTPRequest *authRequest = [ASIHTTPRequest requestWithURL:authurl];
    [authRequest startSynchronous];
    NSError *error = [authRequest error];
    if (!error) {
        NSString *response = [authRequest responseString];
        NSLog(@"AuthRequest in ProfileFriendview: %@", response);
    }
    else
        NSLog(@"AuthRequest in ProfileFriendview: %@", [error localizedDescription]);
    */
    
    if ( self.userid==NULL && myItemModel!=NULL )
    {
        [self callMyStream];
    }
}

-(void) callMyStream
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"ProfileFriendViewUpdate"];
	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 ||elapsedTime < - definedTimeInterval))
	{		
        isNetworkOperation = YES;
        myFameSpotButton.enabled = NO;
        myFavoriteButton.enabled = NO;
        myFriendButton.enabled  = NO;
        mySHoutButton.enabled  = NO;
        
		[self.activityIndicator startAnimating];
		YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		[appDelegate didStartNetworking];
		[defaults setObject:[NSDate date] forKey:@"ProfileFriendViewUpdate"];
        // Get the current timezone in hours and send to server...
        
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        if ( myItemModel!=NULL && userid==NULL )
            [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/mystream/%@", myItemModel.friendUserID];
        else
            [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/mystream/%@", userid];
        
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];	
        
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	isNetworkOperation = NO;
	
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	//appDelegate.selectedController = nil;
	//[appDelegate didStopNetworking];
    
    
    
    //[appDelegate authenticateAtLaunchIfNeedBe];
}

- (void)didReceiveMemoryWarning
{
 	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
    [self.activityIndicator stopAnimating];
    
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [self.activityIndicator startAnimating];
    
    username = NULL;
    userimage = NULL;
    userpoints = NULL;

    self.navigationItem.hidesBackButton = YES;
    
    if ( myItemModel!=NULL )
    {
    self.title  = (myItemModel.friendName!=NULL)?myItemModel.friendName:@"";
    
    NSString *streamStr = myItemModel.friendName;
    streamStr = [streamStr stringByAppendingString:@"'s Stream"];
    friensStream.text = (myItemModel.friendName!=NULL)?streamStr:@"Stream";
    NSLog(@"myItemModel.friendUserID: %@", myItemModel.friendUserID);
    }
    else
    {
        if ( self.userid!=NULL )
        {
            noOfCall = 1;
            NSString *featuredString;
            NSMutableString *tempURLStr = [[NSMutableString alloc] init];
            [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/%@", userid];
            
            [self.activityIndicator startAnimating];
            
            featuredString = [tempURLStr copy];
            NSLog(featuredString);
            [tempURLStr release];
            tempURLStr=nil;
            [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                                   withObject:featuredString];	
        }
    }
    
    [tableview setDelegate:self];
	[tableview setDataSource:self];
    // Do any additional setup after loading the view from its nib.
    
     
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    if ( item )
        [item release];
    
    item = [[NSMutableArray alloc] init];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate authenticateAtLaunchIfNeedBe];


}
-(IBAction)follow
{
    /*ProfileFollowing *followViewContr = [ [ProfileFollowing alloc] initWithNibName:@"ProfileFollowing" bundle:nil];
    [[self navigationController] pushViewController:followViewContr animated:YES];
    [followViewContr release];
*/
    
}
-(IBAction)profileFameSpot
{
    
    ProfileFameSpot *fameSpotViewContr;
    if ( self.userid!=NULL )
        fameSpotViewContr = [ [ProfileFameSpot alloc] setupFSNib:@"ProfileFameSpot" bundle:nil :nil :NO :self.userid];
    else
        fameSpotViewContr = [ [ProfileFameSpot alloc] setupFSNib:@"ProfileFameSpot" bundle:nil :myItemModel :NO :NULL];
    [[self navigationController] pushViewController:fameSpotViewContr animated:YES];
    [fameSpotViewContr release];
}
-(IBAction)profileTickerShouts
{
    ProfileTickerShouts *tickerShoutsViewContr;
    if ( self.userid!=NULL )
        tickerShoutsViewContr = [ [ProfileTickerShouts alloc] setupTickerib:@"ProfileTickerShouts" bundle:nil :myItemModel :NO :self.userid];
    else    
        tickerShoutsViewContr = [ [ProfileTickerShouts alloc] setupTickerib:@"ProfileTickerShouts" bundle:nil :myItemModel :NO :NULL];
    [[self navigationController] pushViewController:tickerShoutsViewContr animated:YES];
    [tickerShoutsViewContr release];
}
-(IBAction)profileFavorites
{
    ProfileFavorites *favoritesViewContr;
    
    if ( self.userid!=NULL )
        favoritesViewContr = [ [ProfileFavorites alloc] setupFavNib:@"ProfileFavorites" bundle:nil :myItemModel :NO :self.userid];
    else
        favoritesViewContr = [ [ProfileFavorites alloc] setupFavNib:@"ProfileFavorites" bundle:nil :myItemModel :NO :NULL];
    
    [[self navigationController] pushViewController:favoritesViewContr animated:YES];
    [favoritesViewContr release];
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
-(IBAction) buttonPressed: (id) sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag: %d", [sender tag]);
    
    
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:[sender tag]];
    
    if ( aModel.videoPath==NULL )
        return;
    
    NSURL *vidurl = [NSURL URLWithString:aModel.videoPath];
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = nil;
    [appDeleagte stopAdvertisingBar];
    
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
}
-(IBAction)PlayVideo :(UIButton *) sender
{
    UIButton *button = (UIButton *)sender;
	//NSString *string = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDeleagte stopAdvertisingBar];
    
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:sender.tag];
    NSLog(aModel.videoPath);
    NSURL *vidurl = [NSURL URLWithString:aModel.videoPath];
    
    playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:vidurl];
    
    /*[self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
     
     playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
     [playerController.moviePlayer play];
     [playerController release];
     playerController=nil;
     NSLog(@"playvideo");
     */
    
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"self.item count: %d", [self.item count]);
    return [self.itemStorage.storageList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*static NSString *CellIdentifier = @"ProfileRealStreamCell";
	ProfileRealStreamCell *cell = (ProfileRealStreamCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell)
	{
		cell = [[ProfileRealStreamCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                            reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
    cell.delegateController = self;
    [cell getCurrRow :indexPath.row];
	cell.itemModel = aModel;
    */
    
    /*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
    
    UITextView* _showQuestionLabel = [[UITextView alloc] initWithFrame:CGRectMake(111.0, 17.0, 220.0, 50.0)];
	_showQuestionLabel.textAlignment = UITextAlignmentLeft;
	_showQuestionLabel.backgroundColor = [UIColor clearColor];
	_showQuestionLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _showQuestionLabel.editable = NO;
    _showQuestionLabel.scrollEnabled = NO;
    _showQuestionLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
    [_showQuestionLabel setText:aModel.myStreamContent];
	[cell.contentView addSubview:_showQuestionLabel];
    
    UIButton *_playButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];	
	//[_playButton setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:aModel.storageImage forState:UIControlStateNormal];
    _playButton.enabled = YES;
    _playButton.tag = indexPath.row;
    [_playButton addTarget:self action:@selector(PlayVideo:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:_playButton];
    */
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSLog(@"Storage count: %d", [self.itemStorage.storageList count]);
    
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
    
    NSLog(@"Profile:indexPath.row: %d", indexPath.row);
    
    UITextView* _showQuestionLabel = [[UITextView alloc] initWithFrame:CGRectMake(111.0, 17.0, 220.0, 50.0)];
	_showQuestionLabel.textAlignment = UITextAlignmentLeft;
	_showQuestionLabel.backgroundColor = [UIColor clearColor];
	_showQuestionLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _showQuestionLabel.editable = NO;
    _showQuestionLabel.scrollEnabled = NO;
    _showQuestionLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
    [_showQuestionLabel setText:aModel.myStreamContent];
	[cell.contentView addSubview:_showQuestionLabel];
    [_showQuestionLabel release];
    
    UIButton *_playButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];	
	//[_playButton setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    UIImage* logoImg = [UIImage imageNamed:@"logo.png"];
    [_playButton setBackgroundImage:(aModel.storageImage)?aModel.storageImage:logoImg forState:UIControlStateNormal];
    _playButton.enabled = YES;
    _playButton.tag = indexPath.row;
    [_playButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:_playButton];
    [_playButton release];
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    SelectAfameSpot *selctdViewController = [ [SelectAfameSpot alloc] initWithNibName:@"SelectAfameSpot" bundle:nil];
    //    [[self navigationController] pushViewController:selctdViewController animated:YES];
    //    [selctdViewController release];
    
	
}
-(IBAction) myFriends :(id) sender
{
     
    ProfileFollowing *frndViewContr;
    
    if ( self.userid!=NULL )
        frndViewContr = [ [ProfileFollowing alloc] setupFollowingNib:@"ProfileFollowing" bundle:nil :myItemModel :NO :self.userid];
    else
        frndViewContr = [ [ProfileFollowing alloc] setupFollowingNib:@"ProfileFollowing" bundle:nil :myItemModel :NO :NULL];
    [[self navigationController] pushViewController:frndViewContr animated:YES];
    [frndViewContr release];
}

-(void) callProfileFrienView
{
    NSLog(@"call profile friend view");
}

/*-(IBAction) followAction :(id) sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/follow/showid%@", (myItemModel!=NULL)?(myItemModel.showID):appDelegate.userIDCode];
    
    NSLog(@"Constructed Login URL: %@", path);    
    [activityIndicator startAnimating];
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

*/
#pragma mark -
#pragma mark XMLParser
#pragma mark -
//- (void)parseXMLFilewithData:(NSData *)data
//{
//    self.sendResult = @"";
//    self.rssParser = [[[NSXMLParser alloc] initWithData:data] autorelease];		
//	[self.rssParser setDelegate:self];
//	[self.rssParser parse];
//}

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

- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	//[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
	//			 description:@"Internet connection is must to run this product."];
}

//- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
//{
//    [self performSelectorOnMainThread:@selector(showAlertErrorParsing) 
//                           withObject:parseError waitUntilDone:NO];
//	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
//}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    
    self.currentElement = elementName;
    
    NSLog(@"self.currentElement: %@", self.currentElement);
    
    if ([elementName isEqualToString:@"mystream"])
        {
            [self.itemStorage cleanStorage];
        }
        else if ([elementName isEqualToString:@"feed"] || [elementName isEqualToString:@"username"] )
        {
            self.item = [NSMutableDictionary dictionary];
        }
    
}
- (void)reloadIndex:(NSNumber *)indexNumber
{
	NSIndexPath *itemPath = [NSIndexPath indexPathForRow:[indexNumber integerValue] inSection:0];
	NSArray *reloadArray = [NSArray arrayWithObject:itemPath];
	[tableview reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"feed"] )
	{
		ItemModel *model = [[ItemModel alloc] initWithDict:self.item];
		model.isBlog = YES;
		[self.itemStorage.storageList addObject:model];
		[model release];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    NSLog(@"Legal: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
    if ([trimmString length] > 0 )
	{
        if ( noOfCall == 2 && self.userid!=NULL )
            [self.item setObject:trimmString forKey:self.currentElement];
        else if (self.userid==NULL)
            [ self.item setObject:trimmString forKey:self.currentElement];
	}
    
    if ( self.userid!=NULL && noOfCall==1 )
    {
        
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    if ( [self.currentElement isEqualToString:@"name"] && [trimmString length] > 0 )
    {
        friendName.text = trimmString;
        //username = trimmString;
        appDelegate.tickerProfUsername = trimmString;
        NSString *streamStr = NULL;
        streamStr = trimmString;
        streamStr = [streamStr stringByAppendingString:@"'s Stream"];
        friensStream.text = (trimmString!=NULL)?streamStr:@"Stream";        
    }
    else
    {
        if ( [self.currentElement isEqualToString:@"username"] && [trimmString length] > 0 && appDelegate.userName==NULL )
        {
            friendName.text = trimmString;
            //username = trimmString;
            appDelegate.tickerProfUsername = trimmString;
            
            NSString *streamStr = NULL;
            streamStr = trimmString;
            streamStr = [streamStr stringByAppendingString:@"'s Stream"];
            friensStream.text = (trimmString!=NULL)?streamStr:@"Stream";
        }
    }
    if ([self.currentElement isEqualToString:@"user_image"] && [trimmString length] > 0)
    {
        appDelegate.tickerProfUserImage = trimmString;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:trimmString]];
        UIImage *image = [UIImage imageWithData:imageData]; 
        profileImage.image = image;
                
    }
    else if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
    {
        appDelegate.tickerProfUserPoints = trimmString;
        
        userpoints = trimmString;        
        userpoints= [userpoints stringByAppendingString:@"  Credits"];
        creditLbl.text = userpoints;
    }
        
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.itemStorage downloadImages];
    
    [self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}


- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
    
    if ( noOfCall ==2 && self.userid!=NULL )
    {
        myFameSpotButton.enabled = YES;
        myFavoriteButton.enabled = YES;
        myFriendButton.enabled  = YES;
        mySHoutButton.enabled  = YES;
        
        [activityIndicator stopAnimating];
    }
    else
    {
        if ( self.userid==NULL )
        {
            [activityIndicator stopAnimating];
        
            myFameSpotButton.enabled = YES;
            myFavoriteButton.enabled = YES;
            myFriendButton.enabled  = YES;
            mySHoutButton.enabled  = YES;
        }
    }
    
    [self.tableview reloadData];
    
    //if ( self.userid!=NULL )
      //  [self updateUserCredentials];
    
    if ( noOfCall==1 )
    {
        [self callMyStream];
        noOfCall = 2;
        
    }

}

- (void)homeControlSelector:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *strKey = [dict objectForKey:@"1"];
    
    if ([strKey isEqualToString:kNotifyImagesDidLoad])
     {
         [self didStopLoadData];
     }
    
}

- (void)didStopLoadData
{
	self.isNetworkOperation = NO;
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
    
	[self.tableview reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(reloadTable:) userInfo:nil repeats:NO];
}
- (void)reloadTable:(NSTimer*)timer
{
    [self.tableview reloadData];
}

-(void) updateUserCredentials
{
    
    if ( username!=NULL )
        friendName.text =  username;
    else
        friendName.text =  @"";
    
    if ( userimage!=NULL )
    {
        //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        //NSString *encodedURL = [appDelegate encodeURL:userimage];
        NSLog(@"userimage URL: %@",userimage);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userimage]];
        UIImage *image = [UIImage imageWithData:imageData]; 
        profileImage.image = image;
        
    }
    else
        profileImage.image = [UIImage imageNamed:@"image.png"];
    
    if ( userpoints!=NULL )
        creditLbl.text= [userpoints stringByAppendingString:@"  Credits"];
    else
        creditLbl.text =  @"";
    
}

#pragma mark -
#pragma mark end ASIHTTPRequest Request
#pragma mark -

/*- (void)requestDone:(ASIHTTPRequest *)request
{    
    [networkQueue setDelegate:nil];
	[request setDelegate:nil];
	//[activityIndicator stopAnimating];
	NSData *responseData = [request responseData];
	NSLog(@"Legal: %@", [request responseString]);
	
    [self parseXMLFilewithData:responseData];
}

- (void)postDone:(ASIHTTPRequest *)request
{
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    
}
*/
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
