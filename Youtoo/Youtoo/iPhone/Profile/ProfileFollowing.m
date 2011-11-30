//
//  ProfileFollowing.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFollowing.h"
#import "ProfileFollowCell.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "YoutooAppDelegate.h"
#import "Constants.h"
#import "ProfileFriendView.h"
#import "VideoShowDetailsPage.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"


static const CGFloat kFeaturedRowHeight = 80.0;
@implementation ProfileFollowing
@synthesize tableview;
@synthesize rssParser;
@synthesize itemStorage;
@synthesize item;
@synthesize currentElement;
@synthesize titleLabel;
@synthesize activityIndicator;
@synthesize profileImage;
@synthesize profileName;
@synthesize creditLbl;
@synthesize myOwnCalled;
@synthesize userid;
- (id)setupFollowingNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel:(BOOL) myOwn :(NSString *) userID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        myOwnCalled = myOwn;
        self.userid = NULL;
        if ( aModel!=NULL )
            myItemModel = aModel;
        else
            myItemModel = nil;
        
        self.currentElement = @"";
		itemStorage = [[ItemStorage alloc] init];
		isNetworkOperation = NO; 
        
        if ( userID!= NULL )
            self.userid = userID;
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Friends";
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;

    
    if ( myOwnCalled )
    {
        profileName.text = appDelegate.userName;
        
        if ( appDelegate.userImage!=NULL )
        {

        NSString *encodedURL = [appDelegate encodeURL:appDelegate.userImage];
        NSLog(@"encodedURL: %@", encodedURL);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedURL]];
        UIImage *image = [UIImage imageWithData:imageData]; 
        profileImage.image = image;
        }
        else
            profileImage.image = [UIImage imageNamed:@"image.png"];
        //avatarImg.image = image;
        creditLbl.text= [appDelegate.creditStr stringByAppendingString:@"  Credits"];
        
    }
    else
    {
        if ( self.userid !=NULL )
        {
            profileName.text = appDelegate.tickerProfUsername?appDelegate.tickerProfUsername:@"";
            
            if ( appDelegate.tickerProfUserImage!=NULL )
            {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:appDelegate.tickerProfUserImage]];
                UIImage *image = [UIImage imageWithData:imageData]; 
                profileImage.image = image;
            }
            else
                profileImage.image = [UIImage imageNamed:@"image.png"];
            
            creditLbl.text= [(appDelegate.tickerProfUserPoints!=NULL)?appDelegate.tickerProfUserPoints:@"0"  stringByAppendingString:@"  Credits"];            
        }
        else
        {
            profileName.text = myItemModel.friendName;
            profileImage.image = (myItemModel.storageImage!=NULL) ?myItemModel.storageImage:[UIImage imageNamed:@"image.png"];
            creditLbl.text= [(myItemModel.friendCredit!=NULL)?myItemModel.friendCredit:@"0"  stringByAppendingString:@"  Credits"];
        }
    }

    
    [tableview setDelegate:self];
	[tableview setDataSource:self];
  
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    [appDelegate authenticateAtLaunchIfNeedBe];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	[self.tableview reloadData];
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    //self.item = nil;
    [item release];
	self.currentElement = nil;
	self.rssParser= nil;
	[itemStorage release];
	[tableview release];
    [titleLabel release];
    [activityIndicator release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
        NSLog(@"AuthRequest in ProfileFollow: %@", response);
    }
    else
        NSLog(@"AuthRequest in ProfileFollow: %@", [error localizedDescription]);
    */
    
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"ProfileFollowingUpdate"];
	//YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || elapsedTime < -definedTimeInterval))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"ProfileFollowingUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        
        if ( self.userid!=NULL )
            [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/friends/%@", self.userid];
        else       
            [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/friends/%@", (myItemModel.friendUserID)?myItemModel.friendUserID:appDelegate.userIDCode];

        
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
	}
}

- (void)reloadPage
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"ProfileFollowingUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || -[pageLastUpdate timeIntervalSinceNow] > kUpdatePeriod))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"ProfileFollowingUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        //[tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/friends"];
        if ( self.userid!=NULL )
            [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/friends/%@", self.userid];
        else       
            [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/friends/%@", (myItemModel.friendUserID)?myItemModel.friendUserID:appDelegate.userIDCode];
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
	}
//    appDelegate.selectedController = self;
//	[appDelegate startAdvertisingBar];
}
- (BOOL)canShowAdvertising
{
	return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 145;
}

-(IBAction) buttonPressed: (id) sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag: %d", [sender tag]);
    
     ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:[sender tag]];
     /*
     UpcomingEpisodes * upcomingEpisodesViewController = [ [UpcomingEpisodes alloc] initWithNibName:@"UpcomingEpisodes" bundle:nil :aModel];    
     [[self navigationController] pushViewController:upcomingEpisodesViewController animated:YES];
     [upcomingEpisodesViewController release];*/
    ProfileFriendView *videosDoneViewController;
    
    if (self.userid!=NULL)
       videosDoneViewController = [ [ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:nil :aModel :self.userid];
    else
        videosDoneViewController = [ [ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:nil :aModel :nil];
    
    [[self navigationController] pushViewController:videosDoneViewController animated:YES];
    [videosDoneViewController release];
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*if ( [self.itemStorage.storageList count]<2 )
        return [self.itemStorage.storageList count];
    else
        return [self.itemStorage.storageList count]/2;
    */
    NSInteger retVal = 0;
    if ( [self.itemStorage.storageList count]<2 )
        retVal = [self.itemStorage.storageList count];
    else
        retVal = ( [self.itemStorage.storageList count] %2 ==0 ) ? [self.itemStorage.storageList count]/2 : ( [self.itemStorage.storageList count]/2 )+ 1;
    
    NSLog(@"ROW VAL: %d",retVal);
    
    int oddEvenval = [self.itemStorage.storageList count] %2;
    NSLog(@"oddEvenval %d",oddEvenval);
    
    return retVal;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    /*static NSString *CellIdentifier = @"VideosShowDetailPageCell";
     VideosShowDetailPageCell *cell = (VideosShowDetailPageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (nil == cell)
     {
     cell = [[[VideosShowDetailPageCell alloc] initWithStyle:UITableViewCellStyleDefault 
     reuseIdentifier:CellIdentifier] autorelease];
     }*/
    
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];

    
    static NSString *CellIdentifier = @"VideoShowDetailsPage";
	VideoShowDetailsPage *cell = (VideoShowDetailsPage *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell)
	{
		cell = [[[VideoShowDetailsPage alloc] initWithStyle:UITableViewCellStyleDefault 
                                            reuseIdentifier:CellIdentifier ] autorelease];
        
        [cell createCellLabels :[self.itemStorage.storageList count] ];
	}
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell getCurrRow :indexPath.row :[self.itemStorage.storageList count] ];
    
    cell.delegateController = self;
    ItemModel *aModel;
    
    if ( indexPath.row==0 )
    {
        aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
        cell.itemModel = aModel;
        
        if ( [self.itemStorage.storageList count]>1 )
        {
            aModel = [self.itemStorage.storageList objectAtIndex:(indexPath.row)+1];
            //cell.itemModel2 = aModel;             
            [cell setItemModel2:aModel];
        }
    }
    else
    {
        NSUInteger val = (indexPath.row)+(indexPath.row); 
        aModel = [self.itemStorage.storageList objectAtIndex:val];
        cell.itemModel = aModel;
        
        
        //if ( val<=indexPath.row )
        NSLog(@"[self.itemStorage.storageList count]: %d", [self.itemStorage.storageList count] );
        NSLog(@"[self.itemStorage.storageList count]: %d", [self.itemStorage.storageList count]%2 );
        NSLog(@"indexPath.row: %d", indexPath.row );
        BOOL dontExecute = FALSE;
        
        if ( ( [self.itemStorage.storageList count]%2 != 0 && indexPath.row==([self.itemStorage.storageList count]/2) ) ) // Finding last row second cell button is not needed to draw in case of odd count
        {
            dontExecute=TRUE;
        }
        
        if ( !dontExecute )
        {
            aModel = [self.itemStorage.storageList objectAtIndex:val+1];
            [cell setItemModel2:aModel];
        }
    }
    
	return cell;
}
#pragma mark -
#pragma mark Notification selector
#pragma mark -

- (void)homeControlSelector:(NSNotification *)notification
{
    
        NSDictionary *dict = [notification userInfo];
        NSString *strKey = [dict objectForKey:@"1"];
        if ([strKey isEqualToString:kNotifyReloadTable])
        {
            ItemModel *itemModel = [dict objectForKey:@"ItemModel"];
            NSArray *visibleCells = [self.tableview visibleCells];
            for (VideoShowDetailsPage *cell in visibleCells)
            {
                if ([cell.itemModel.showID isEqualToString:itemModel.showID])
                {
                    cell.itemModel = itemModel;
                    break;
                }
            }
        }
        
        else if ([strKey isEqualToString:kNotifyImagesDidLoad])
        {
            [self didStopLoadData];
        }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /* ProfileFriendView *videosDoneViewController = [ [ProfileFriendView alloc] initWithNibName:@"ProfileFriendView" bundle:nil];
    [[self navigationController] pushViewController:videosDoneViewController animated:YES];
    [videosDoneViewController release];
    */
	
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
	//if ([elementName isEqualToString:@"featured"])
    if ([elementName isEqualToString:@"friends"])
	{
		[self.itemStorage cleanStorage];
	}
	//else if ([elementName isEqualToString:@"item"])
    else if ([elementName isEqualToString:@"friend"])
	{
        self.item = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//if ([elementName isEqualToString:@"item"])
    if ([elementName isEqualToString:@"friend"])
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
	[tableview reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"self.currentElement: %@", self.currentElement);
    NSLog(@"trimmString: %@", trimmString);
    
	if ([trimmString length] > 0)
	{
		[self.item setObject:trimmString forKey:self.currentElement];
	}
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{	
	[self.itemStorage downloadImages];
	[self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
}

#pragma mark -

- (void)didStopLoadData
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	[tableview reloadData]; 
    //reloadTImer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reloadTable:) userInfo:nil repeats:NO];
    
}

- (void)reloadTable:(NSTimer*)timer
{
    [tableview reloadData];
    //[self reloadPage];
    
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
