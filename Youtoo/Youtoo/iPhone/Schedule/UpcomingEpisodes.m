//
//  UpcomingEpisodes.m
//  Youtoo
//
//  Created by PRABAKAR MP on 14/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "UpcomingEpisodes.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "Constants.h"
#import "YoutooAppDelegate.h"
#import "ScheduleEpisodeDetail.h"
#import "ItemModel.h"
#import "UpcomingEpisodesCell.h"
#import "ProfileFriendView.h"

static const CGFloat kFeaturedRowHeight = 80.0;
@interface UpcomingEpisodes (PrivateMethods)
- (void)createCellLabels;
- (void)didStopLoadData;
@end
@implementation UpcomingEpisodes
@synthesize itemModel;
@synthesize rssParser;
@synthesize currentElement;
@synthesize item;
@synthesize itemStorage;
@synthesize upcomingEpisodesTableview;
@synthesize str;
@synthesize showNameTitle;
@synthesize activityIndicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentElement = @"";
		itemStorage = [[ItemStorage alloc] init];
		isNetworkOperation = NO;    
        itemModelRetVal = aModel;
    }
    return self;
}

- (void)dealloc
{
     [item release];
	self.currentElement = nil;
	self.rssParser= nil;
	[itemStorage release];
    [showNameTitle release];
    [upcomingEpisodesTableview release];
    [showTime release];
    [showName release];
    [showImage release];
    [activityIndicator release];
    
    [super dealloc];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    showName= [[NSMutableArray alloc] init ];
    showImage=[[NSMutableArray alloc] init ];
    showTime=[[NSMutableArray alloc] init ];
   showNameTitle.textColor=[UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
    // self.title=@"Upcoming Episodes";
   // upcomingEpisodesTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,260,768,800) style:UITableViewStylePlain];
	[upcomingEpisodesTableview setDelegate:self];
	[upcomingEpisodesTableview setDataSource:self];
	//[self.view addSubview:upcomingEpisodesTableview];
    UIImage *bgImage= [UIImage imageNamed:@"background.png"];
    UIImageView *bgView= [[UIImageView alloc] initWithImage:bgImage];
    upcomingEpisodesTableview.backgroundView = bgView;
    [bgView release];
    upcomingEpisodesTableview.rowHeight = kFeaturedRowHeight;
    //  showNameTitle.text=@"hello";
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    str=itemModel.scheduleShowId;
    //NSLog(str);
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"BlogPageLastUpdate"];
	
	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || elapsedTime < -definedTimeInterval))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"BlogPageLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        //NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        // [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/blogs/1/0/ASC?offset=%d", timeZoneOffset];
        // [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingEpisodes/YAD", timeZoneOffset];
        //[tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/getEpisodes/", str, timeZoneOffset];
        //NSString *baseURL = @"http://www.youtoo.com/iphoneyoutoo/upcomingEpisodes/";
       // NSString *showID = [appDelegate.showID objectAtIndex:appDelegate.selectedShow];
        NSString *tempURL = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingEpisodes/%@", itemModelRetVal.showID];
        NSLog(@"tempURL: %@", tempURL);
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:tempURL];
	}

    // Do any additional setup after loading the view from its nib.
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopAdvertisingBar];
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];

	//[[NSNotificationCenter defaultCenter] addObserver:self 
                                            // selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
}
- (BOOL)canShowAdvertising
{
	return YES;
}
- (void)reloadPage
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"BlogPageLastUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || -[pageLastUpdate timeIntervalSinceNow] > kUpdatePeriod))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"BlogPageLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        //        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        //        //[tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/blogs/1/0/ASC?offset=%d", timeZoneOffset];
        //        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingEpisodes/YAD", timeZoneOffset];
        //      //  [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/getEpisodes/", str, timeZoneOffset];
        //        NSLog(tempURLStr);
        //        featuredString = [tempURLStr copy];
        //        NSLog(featuredString);
        //        [tempURLStr release];
        //        tempURLStr=nil;
        
        NSString *tempURL = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingEpisodes/%@", itemModelRetVal.showID];
        NSLog(@"tempURL: %@", tempURL);
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:tempURL];
	}
    
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
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
    [self.itemStorage cleanImages];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}
#pragma mark -
#pragma mark Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//return 5;
    return [self.itemStorage.storageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /* NSString *identifier = [NSString stringWithFormat:@"%d",indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    
	//cell.shouldIndentWhileEditing = YES;
    //if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    NSLog(@"objectAtIndex:indexPath.row: %d", indexPath.row);
    
    // Friend name
    // [[cell.contentView viewWithTag:indexPath.row ] removeFromSuperview];
    
    
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    
    UILabel* _showNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 8.0, 182.0, 17.0)];
	_showNameLabel.textAlignment = UITextAlignmentLeft;
	_showNameLabel.backgroundColor = [UIColor clearColor];
	_showNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
	_showNameLabel.textColor = [UIColor blackColor];
    // _titleLabel.text = @"Batman";
    _showNameLabel.text = [showName objectAtIndex:indexPath.row];
	[cell.contentView addSubview:_showNameLabel];
    [_showNameLabel release];
    
    
    UILabel* _showTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 30.0, 182.0, 17.0)];
	_showTimeLabel.textAlignment = UITextAlignmentLeft;
	_showTimeLabel.backgroundColor = [UIColor clearColor];
	_showTimeLabel.font = [UIFont boldSystemFontOfSize:17.0];
	_showTimeLabel.textColor = [UIColor blackColor];
    // _timeLabel.text = @"Time";
    _showTimeLabel.text = [showTime objectAtIndex:indexPath.row];
	[cell.contentView addSubview:_showTimeLabel];
    [_showTimeLabel release];
    
    
	UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];
	iconImageView.image = [UIImage imageNamed:@"avatar.png"];
    
    NSString *imageSrt=[showImage objectAtIndex:indexPath.row];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageSrt]];
    UIImage *image = [UIImage imageWithData:imageData]; 
    iconImageView.image = image;
    
	iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
	[cell.contentView addSubview:iconImageView];
    
    [iconImageView release];
    */
    
    static NSString *CellIdentifier = @"UpcomingEpisodesCell";
	UpcomingEpisodesCell *cell = (UpcomingEpisodesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell)
	{
		cell = [[[UpcomingEpisodesCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:CellIdentifier] autorelease];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
	cell.itemModel = aModel;
   
	return cell;

    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*ScheduleEpisodeDetail *selctdViewController = [ [ScheduleEpisodeDetail alloc] initWithNibName:@"ScheduleEpisodeDetail" bundle:nil];
    [[self navigationController] pushViewController:selctdViewController animated:YES];
    [selctdViewController release];
    */
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
    
    ScheduleEpisodeDetail *selctdViewController = [ [ScheduleEpisodeDetail alloc] initWithNibName:@"ScheduleEpisodeDetail" bundle:nil :aModel];
    [[self navigationController] pushViewController:selctdViewController animated:YES];
    [selctdViewController release];
   
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	//[self.tableview reloadData];
	
}



#pragma mark -
#pragma mark Notification selector
#pragma mark -

//- (void)homeControlSelector:(NSNotification *)notification
//{
//    NSDictionary *dict = [notification userInfo];
//    NSString *strKey = [dict objectForKey:@"1"];
//	if ([strKey isEqualToString:kNotifyReloadTable])
//	{
//		ItemModel *itemModel = [dict objectForKey:@"ItemModel"];
//		NSArray *visibleCells = [upcomingEpisodesTableview visibleCells];
//		for (UpcominEpisodesCell *cell in visibleCells)
//		{
//			if ([cell.itemModel.showID isEqualToString:itemModel.showID])
//			{
//				cell.itemModel = itemModel;
//				break;
//			}
//		}
//	}
//	else if ([strKey isEqualToString:kNotifyImagesDidLoad])
//	{
//		[self didStopLoadData];
//	}
//}



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
    if ([elementName isEqualToString:@"shows"])
	{
		[self.itemStorage cleanStorage];
	}
	//else if ([elementName isEqualToString:@"item"])
    else if ([elementName isEqualToString:@"show"])
	{
        self.item = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//if ([elementName isEqualToString:@"item"])
    if ([elementName isEqualToString:@"show"])
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
	[upcomingEpisodesTableview reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(trimmString);
    NSLog(self.currentElement);
    
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
    
    NSLog(@"itemModelRetVal.episodeName:%@",itemModelRetVal.showName);
    showNameTitle.text = itemModelRetVal.showName;
	
    
	[upcomingEpisodesTableview reloadData];
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
