//
//  Profile.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "Profile.h"
#import "ProfileCell.h"
#import "ProfileEdit.h"
#import "ProfileFameSpot.h"
#import "ProfileTickerShouts.h"
#import "ProfileFavorites.h"
#import "ProfileFriendView.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
//#import "ASINetworkQueue.h"
#import "ProfileFollowing.h"
#import "ProfileRealStreamCell.h"
#import "ItemStorage.h"
#import "ItemModel.h"
#import "Constants.h"

static const CGFloat kFeaturedRowHeight = 80.0;

@implementation Profile

@synthesize tableview;
@synthesize rssParser;
@synthesize sendResult;
@synthesize currentElement;
@synthesize isNetworkOperation;
@synthesize creditsLbl;
@synthesize profileImage;
@synthesize profileName;
@synthesize itemStorage;
@synthesize profNameStr;
@synthesize profImagePAthStr;
@synthesize creditStr;
@synthesize item;
@synthesize editButton;
@synthesize bGetProfile;
@synthesize playerController;
@synthesize myFameSpotButton;
@synthesize mySHoutButton;
@synthesize myFavoriteButton;
@synthesize myFriendButton;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        itemStorage = [[ItemStorage alloc] init];
        self.isNetworkOperation = NO;
        
        self.sendResult = @"";
        //networkQueue = [[ASINetworkQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    //[networkQueue release];
    [creditsLbl release];
    [profileImage release];
    [profileName release];
    [itemStorage release];
    [creditStr release];
    [profNameStr release];
    [profImagePAthStr release];
   // self.item = nil;
    [item release];
    self.rssParser= nil;
    [myFameSpotButton release];
     [mySHoutButton release];
     [myFavoriteButton release];
    [myFriendButton release];
    [playerController release];
    
    [super dealloc];
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
    [activityIndicator stopAnimating];
    [self.itemStorage cleanImages];
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Profile";
    self.navigationController.navigationBarHidden = YES;

    [tableview setDelegate:self];
	[tableview setDataSource:self];
	//[self.view addSubview:tableview];
    tableview.rowHeight = kFeaturedRowHeight;
   
    myStreamCalled = 0;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
   // YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //if ( appDelegate.userName==NULL )
        
    /*else
    {
        [self myStreamAction];
        myStreamCalled = 0;
    }*/
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
    //[appDelegate stopAdvertisingBar];
	[appDelegate startAdvertisingBar];
    
    bGetProfile = NO;
    //[self grabAuthProfileInfoBackground];
    
    [self grabAuthProfileInfoBackground];
    
    [self updateUserCredentials];

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
    [self.tableview reloadData];
}

/*- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self authAgain];
}*/

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


- (void)grabAuthProfileInfoBackground
{
    NSLog(@"grabAuthProfileInfoBackground called");
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate authenticateAtLaunchIfNeedBe];
    
    myStreamCalled = 1;
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile"];
    NSLog(@"Constructed Login URL: %@", path);
    [self.activityIndicator startAnimating];
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
    
   // NSString *responseStr = [NSString stringWithFormat:@"%@",responseData];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"responseStr: %@", responseString);
    if ( [responseString length]>0 )
        [request setDelegate:nil];
    
    if ( bGetProfile == NO )
        [self getProfileInfo];
    else
    {
       /* NSString *startTag = @"<username>";
        NSString *endTag = @"</username>";
        NSString *pulledStr=NULL;
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:responseString];
        [scanner scanUpToString:startTag intoString:nil];
        scanner.scanLocation += [startTag length];
        [scanner scanUpToString:endTag intoString:&pulledStr];
        [scanner release];
        
        NSLog(@"username string is %@", pulledStr);
        if ( pulledStr )
        {
            appDelegate.userName = pulledStr;
            profileName.text =  appDelegate.userName;
        }
        
        startTag = @"<user_image>";
        endTag = @"</user_image>";
        pulledStr=NULL;
        scanner = [[NSScanner alloc] initWithString:responseString];
        [scanner scanUpToString:startTag intoString:nil];
        scanner.scanLocation += [startTag length];
        [scanner scanUpToString:endTag intoString:&pulledStr];
        [scanner release];
        
        NSLog(@"username string is %@", pulledStr);
        if ( pulledStr )
        {
            appDelegate.userImage = pulledStr;
            NSLog(@"Welcome: appDelegate.userImage: %@", appDelegate.userImage);
            NSString *encodedURL = [appDelegate encodeURL:appDelegate.userImage];
            NSLog(@"Thumbnail encodedURL: %@",encodedURL);
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedURL]];
            UIImage *image = [UIImage imageWithData:imageData]; 
            profileImage.image = image;
        }
        
        startTag = @"<points>";
        endTag = @"</points>";
        pulledStr=NULL;
        scanner = [[NSScanner alloc] initWithString:responseString];
        [scanner scanUpToString:startTag intoString:nil];
        scanner.scanLocation += [startTag length];
        [scanner scanUpToString:endTag intoString:&pulledStr];
        [scanner release];
        
        NSLog(@"username string is %@", pulledStr);
        if ( pulledStr )
        {
            appDelegate.creditStr = pulledStr;
            NSLog(@"Welcome: appDelegate.creditStr: %@", appDelegate.creditStr);
            creditsLbl.text= [appDelegate.creditStr stringByAppendingString:@"  Credits"];
        }*/
    }
    
}
-(void) getProfileInfo
{
    bGetProfile=YES;
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile"];
    NSURL *url = [NSURL URLWithString:path];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    //[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
      //                     withObject:path];	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    NSLog(@"asynchronous request error: %@", error);
}

-(void) myStreamAction
{ 
    NSLog(@"myStreamAction function called");
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     NSDate *pageLastUpdate = [defaults objectForKey:@"ProfilePageLastUpdate"];
     NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
     NSTimeInterval definedTimeInterval = kUpdatePeriod;
     if ( !isNetworkOperation && ([self.itemStorage.storageList count] == 0 ||elapsedTime < - definedTimeInterval) )
     {		
         NSLog(@"myStreamAction called for getting data");
         
         
         
     editButton.enabled = NO;
     myFameSpotButton.enabled = NO;
     myFavoriteButton.enabled = NO;
     myFriendButton.enabled  = NO;
     mySHoutButton.enabled  = NO;
     
     isNetworkOperation = YES;
     [self.activityIndicator startAnimating];
     YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
     [appDelegate didStartNetworking];
     [defaults setObject:[NSDate date] forKey:@"ProfilePageLastUpdate"];
     // Get the current timezone in hours and send to server...
      
     NSString *featuredString;
     NSMutableString *tempURLStr = [[NSMutableString alloc] init];
     [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/mystream/%@", [appDelegate readUserID]];
     
     featuredString = [tempURLStr copy];
     NSLog(featuredString);
     [tempURLStr release];
     tempURLStr=nil;
     [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
     withObject:featuredString];	
     
     }
    
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
	
    
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:sender.tag];
    NSLog(@"aModel.videoPath: %@", aModel.videoPath);
    
    if ( aModel.videoPath==NULL )
        return;
    
    NSURL *vidurl = [NSURL URLWithString:aModel.videoPath];

    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = nil;
    [appDeleagte stopAdvertisingBar];
    
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

#pragma mark -
#pragma mark Notification selector
#pragma mark -

- (void)homeControlSelector:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *strKey = [dict objectForKey:@"1"];
    /*if ([strKey isEqualToString:kNotifyReloadTable])
    {
        ItemModel *itemModel = [dict objectForKey:@"ItemModel"];
        NSArray *visibleCells = [self.tableview visibleCells];
        for (ProfileRealStreamCell *cell in visibleCells)
        {
            if ([cell.itemModel.myStreamContent isEqualToString:itemModel.myStreamContent])
            {
                cell.itemModel = itemModel;
                break;
            }
        }
    }
    
    else*/ if ([strKey isEqualToString:kNotifyImagesDidLoad])
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
    
    editButton.enabled = YES;
    myFameSpotButton.enabled = YES;
    myFavoriteButton.enabled = YES;
    myFriendButton.enabled  = YES;
    mySHoutButton.enabled  = YES;

    
	[self.tableview reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(reloadTable:) userInfo:nil repeats:NO];
}

- (void)reloadTable:(NSTimer*)timer
{
    [self.tableview reloadData];
}

- (BOOL)canShowAdvertising
{
	return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
-(IBAction)editAct
{
    ProfileEdit *selctdViewController = [ [ProfileEdit alloc] initWithNibName:@"ProfileEdit" bundle:nil];
    [[self navigationController] pushViewController:selctdViewController animated:YES];
    [selctdViewController release];
}
-(IBAction)profileFameSpot
{
    ProfileFameSpot *fameSpotViewContr = [ [ProfileFameSpot alloc] setupFSNib:@"ProfileFameSpot" bundle:nil :nil :YES :NULL];
    [[self navigationController] pushViewController:fameSpotViewContr animated:YES];
    [fameSpotViewContr release];
}
-(IBAction)profileTickerShouts
{
    ProfileTickerShouts *tickerShoutsViewContr = [ [ProfileTickerShouts alloc] setupTickerib:@"ProfileTickerShouts" bundle:nil :nil :YES :NULL];
    [[self navigationController] pushViewController:tickerShoutsViewContr animated:YES];
    [tickerShoutsViewContr release];
}
-(IBAction)profileFavorites
{
    ProfileFavorites *favoritesViewContr = [ [ProfileFavorites alloc] setupFavNib:@"ProfileFavorites" bundle:nil :nil :YES :NULL];
    [[self navigationController] pushViewController:favoritesViewContr animated:YES];
    [favoritesViewContr release];
}
-(IBAction)profileFrnds
{
   /* ProfileFriendView *frndViewContr = [ [ProfileFriendView alloc] initWithNibName:@"ProfileFriendView" bundle:nil];
    [[self navigationController] pushViewController:frndViewContr animated:YES];
    [frndViewContr release];
*/

    ProfileFollowing *frndViewContr = [ [ProfileFollowing alloc] setupFollowingNib:@"ProfileFollowing" bundle:nil :nil :YES :NULL];
     [[self navigationController] pushViewController:frndViewContr animated:YES];
     [frndViewContr release];
      

    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    
    // commening this now because we are authenticating every time in respective their screens itself..
    //[appDelegate authenticateAtLaunchIfNeedBe];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	/*NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"ProfilePageLastUpdate"];
	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 ||elapsedTime < - definedTimeInterval))
	{		
		editButton.enabled = NO;
        myFameSpotButton.enabled = NO;
        myFavoriteButton.enabled = NO;
        myFriendButton.enabled  = NO;
        mySHoutButton.enabled  = NO;
        
        isNetworkOperation = YES;
		[self.activityIndicator startAnimating];
		YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		[appDelegate didStartNetworking];
		[defaults setObject:[NSDate date] forKey:@"ProfilePageLastUpdate"];
        // Get the current timezone in hours and send to server...

        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/mystream/%@", appDelegate.userIDCode];
        
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];	
        
	}*/
}

- (void)reloadPage
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"ProfilePageLastUpdate"];
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || 
                                -[pageLastUpdate timeIntervalSinceNow] > kUpdatePeriod))
	{	
        //[self grabAuthProfileInfoBackground];
        
		editButton.enabled = NO;
        myFameSpotButton.enabled = NO;
        myFavoriteButton.enabled = NO;
        myFriendButton.enabled  = NO;
        mySHoutButton.enabled  = NO;
        
        isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"ProfilePageLastUpdate"];
        
        // Get the current timezone in hours and send to server...        
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/mystream/%@", [appDelegate readUserID]];
        
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
							   withObject:featuredString];
        
	}
    
}

#pragma mark -
#pragma mark XMLParser
#pragma mark -
//- (void)parseXMLFilewithData:(NSData *)data
- (void)parseXMLFilewithData:(NSString *)strURL
{
   /* self.sendResult = @"";
    self.rssParser = [[[NSXMLParser alloc] initWithData:data] autorelease];		
	[self.rssParser setDelegate:self];
	[self.rssParser parse];*/
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *dataURL = [NSURL URLWithString:strURL];
	self.rssParser = [[[NSXMLParser alloc] initWithContentsOfURL:dataURL] autorelease];	
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
	[pool release];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{	
	isNetworkOperation = NO;
    [self performSelectorOnMainThread:@selector(showAlertNoConnection:) 
						   withObject:parseError waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
        
    self.currentElement = elementName;
    
    NSLog(@"self.currentElement: %@", self.currentElement);
    //if ( myStreamCalled == 2 )
    {
	if ([elementName isEqualToString:@"mystream"])
	{
		[self.itemStorage cleanStorage];
	}
	else if ([elementName isEqualToString:@"feed"])
	{
        self.item = [NSMutableDictionary dictionary];
    }
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"feed"] /*&& myStreamCalled == 1*/ )
	{
		ItemModel *model = [[ItemModel alloc] initWithDict:self.item];
		model.isBlog = YES;
		[self.itemStorage.storageList addObject:model];
		[model release];
    }
}
- (void)reloadIndex:(NSNumber *)indexNumber
{
	NSIndexPath *itemPath = [NSIndexPath indexPathForRow:[indexNumber integerValue] inSection:0];
	NSArray *reloadArray = [NSArray arrayWithObject:itemPath];
	[self.tableview reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *trimmString;
    
    //if ( ![self.currentElement isEqualToString:@"user_image"] )
        trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    /*else
    {
        trimmString = string;
        NSLog(@"Encoded trimmString for image: %@", trimmString);    
    }*/
	
    NSLog(@"Legal: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
    
    if ([trimmString length] > 0 && myStreamCalled==2 )
	{
		[self.item setObject:trimmString forKey:self.currentElement];
	}
    
    
        if ( [self.currentElement isEqualToString:@"name"] && [trimmString length] > 0 )
        {
            appDelegate.userName = trimmString;
            NSLog(@"Welcome: appDelegate.userName: %@", appDelegate.userName);
        }
        else
        {
            if ( [self.currentElement isEqualToString:@"username"] && [trimmString length] > 0 && appDelegate.userName==NULL )
            {
                appDelegate.userName = trimmString;
                NSLog(@"Welcome: appDelegate.userName: %@", appDelegate.userName);
            }
        }
        if ([self.currentElement isEqualToString:@"user_image"] && [trimmString length] > 0)
        {
            appDelegate.userImage = trimmString;
            NSLog(@"Welcome: appDelegate.userImage: %@", appDelegate.userImage);
        }
        else if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
        {
            appDelegate.creditStr = trimmString;
            NSLog(@"Welcome: appDelegate.creditStr: %@", appDelegate.creditStr);
        }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//if ( myStreamCalled == 1 )
    {
        [self.itemStorage downloadImages];
     //   [activityIndicator stopAnimating];
        //myStreamCalled = 2;
    }
    if ( myStreamCalled == 2 )
    {
        myStreamCalled = 3;
        
    }
    [self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}

- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	//[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
	//			 description:@"Internet connection is must to run this product."];
    
    NSLog(@"showAlertNoConnection in Profile");
}

- (void)didEndParsing
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
    
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	
    //[self.item release];
    
    [self updateUserCredentials];
    
    //reloadTImer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reloadTable:) userInfo:nil repeats:NO];
    if ( myStreamCalled == 1 )
    {
        myStreamCalled = 2;
        [self myStreamAction];        
    }
    
    if ( myStreamCalled == 3 )
    {
        myStreamCalled = 0;
        
        editButton.enabled = YES;
        myFameSpotButton.enabled = YES;
        myFavoriteButton.enabled = YES;
        myFriendButton.enabled  = YES;
        mySHoutButton.enabled  = YES;

    }
    [self.tableview reloadData];
}

/*- (void)reloadTable:(NSTimer*)timer
{
    editButton.enabled = YES;
    myFameSpotButton.enabled = YES;
    myFavoriteButton.enabled = YES;
    myFriendButton.enabled  = YES;
    mySHoutButton.enabled  = YES;
    
    [tableview reloadData];
    //[self reloadPage];
    
}*/

-(void) updateUserCredentials
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;  
    NSLog(@"appDelegate.userImage: %@",appDelegate.userImage);
    
     
    if ( appDelegate.userName!=NULL )
            profileName.text =  appDelegate.userName;
        else
            profileName.text =  @"";
        
        if ( appDelegate.userImage!=NULL )
        {
            
            NSString *encodedURL = [appDelegate encodeURL:appDelegate.userImage];
            NSLog(@"Thumbnail encodedURL: %@",encodedURL);
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedURL]];
            UIImage *image = [UIImage imageWithData:imageData]; 
            profileImage.image = image;
            
        }
        else
            profileImage.image = [UIImage imageNamed:@"image.png"];
        
        if ( appDelegate.creditStr!=NULL )
            creditsLbl.text= [appDelegate.creditStr stringByAppendingString:@"  Credits"];
        else
            creditsLbl.text =  @"0 Credit";
        
        
    
}

- (void)showAlertErrorParsing
{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile/Stream error", @"Alert Title")
													 message:NSLocalizedString(@"Please try Sign-out and Sign-in again.", @"Alert Description") 
													delegate:self 
										   cancelButtonTitle:nil 
										   otherButtonTitles:nil] autorelease];
	
	[alert addButtonWithTitle:NSLocalizedString(@"OK", @"Button Title")];
	alert.tag = 1234;
	[alert show];
}
#pragma mark -
#pragma mark end ASIHTTPRequest Request
#pragma mark -
/*
- (void)requestDone:(ASIHTTPRequest *)request
 
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
