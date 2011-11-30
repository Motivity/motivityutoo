//
//  VideosShowDetailPage.m
//  Youtoo
//
//  Created by PRABAKAR MP on 30/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "VideosShowDetailPage.h"
#import "VideosShowDetailPageCell.h"
#import "VideosDone.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "YoutooAppDelegate.h"
#import "Constants.h"
#import "VideoShowDetailsPage.h"
#import "ProfileFriendView.h"

static const CGFloat kFeaturedRowHeight = 80.0;

@implementation VideosShowDetailPage
@synthesize tableview;
@synthesize rssParser;
@synthesize itemStorage;
@synthesize item;
@synthesize currentElement;
@synthesize titleLabel;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myItemModel = aModel;
        self.currentElement = @"";
		itemStorage = [[ItemStorage alloc] init];
		isNetworkOperation = NO; 
    }
    return self;
}

- (void)dealloc
{
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.title = myItemModel.episodeName;
    titleLabel.text = myItemModel.episodeName;
    
    [tableview setDelegate:self];
	[tableview setDataSource:self];
    tableview.rowHeight = kFeaturedRowHeight;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];  
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tempImageView setFrame:self.tableview.frame]; 
    
    self.tableview.backgroundView = tempImageView;
    [tempImageView release];
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"BlogPageLastUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
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
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/famespots/x/%@", myItemModel.questionID];
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	[self.tableview reloadData];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
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
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/famespots/x/%@", myItemModel.questionID];
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
	}
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
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
    
   /* ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:[sender tag]];
    
    UpcomingEpisodes * upcomingEpisodesViewController = [ [UpcomingEpisodes alloc] initWithNibName:@"UpcomingEpisodes" bundle:nil :aModel];    
    [[self navigationController] pushViewController:upcomingEpisodesViewController animated:YES];
    [upcomingEpisodesViewController release];*/
 
     ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:[sender tag]];
 
    VideosDone *videosDoneViewController = [ [VideosDone alloc] initWithNibName:@"VideosDone" bundle:nil :aModel];
    [[self navigationController] pushViewController:videosDoneViewController animated:YES];
    [videosDoneViewController release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger retVal = 0;
    
    if ( [self.itemStorage.storageList count]<2 )
        retVal = [self.itemStorage.storageList count];
    else
        retVal = ( [self.itemStorage.storageList count] %2 ==0 ) ? [self.itemStorage.storageList count]/2 : ( [self.itemStorage.storageList count]/2 )+ 1;
      //  retVal = [self.itemStorage.storageList count]/2 ;
    
    NSLog(@"ROW VAL: %d",retVal);
    
    int oddEvenval = [self.itemStorage.storageList count] %2;
    NSLog(@"oddEvenval %d",oddEvenval);
    
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*static NSString *CellIdentifier = @"VideosShowDetailPageCell";
	VideosShowDetailPageCell *cell = (VideosShowDetailPageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell)
	{
		cell = [[[VideosShowDetailPageCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                    reuseIdentifier:CellIdentifier] autorelease];
	}*/
    
   /* UITableViewCell *cell=[[UITableViewCell alloc]init];
    //static NSString *CellIdentifier1 = @"Cell";
    NSString *CellIdentifier1 = [NSString stringWithFormat:@"identifier_%d", indexPath.row];
    cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier1];
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier1] autorelease];
    
    
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ( indexPath.row==0 )
    {
        ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
        
        btn1 = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 80.0, 65.0)];
        //UIImageView *imageView = [UIImage imageNamed:@"avatar.png"];
        btn1.enabled = YES;
        //[btn1 setBackgroundColor:[UIColor blueColor]];
        btn1.tag = indexPath.row;
        NSLog(@"btn1.tag : %d", btn1.tag );
        
        if ( aModel.storageImage==NULL )
            [btn1 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        else
            [btn1 setImage:aModel.storageImage forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn1];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 73.0, 160.0, 25.0)];
        lbl1.textAlignment = UITextAlignmentLeft;
        lbl1.backgroundColor = [UIColor clearColor];
        lbl1.font = [UIFont boldSystemFontOfSize:17.0];
        lbl1.tag = indexPath.row;
        lbl1.text = aModel.friendName;
        lbl1.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
        [cell.contentView addSubview:lbl1];
        [lbl1 release];
        
        if ( [self.itemStorage.storageList count]>1 )
        {
        aModel = [self.itemStorage.storageList objectAtIndex:(indexPath.row)+1];
        
        btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180.0, 6.0, 80.0, 65.0)];  
        if ( aModel.storageImage==NULL )
            [btn2 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        else
            [btn2 setImage:aModel.storageImage forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = (indexPath.row)+1;
        NSLog(@"btn1.tag : %d", btn2.tag );
        [cell.contentView addSubview:btn2];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 73.0, 160.0, 25.0)];
        lbl2.textAlignment = UITextAlignmentLeft;
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.font = [UIFont boldSystemFontOfSize:17.0];
        lbl2.tag = indexPath.row+1;        
        lbl2.text = aModel.friendName;
        lbl2.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
        [cell.contentView addSubview:lbl2];
        [lbl2 release];
            
        }
    }
    else
    {
        NSUInteger val = (indexPath.row)+(indexPath.row); 
        ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:val];
        
        btn1 = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 80.0, 65.0)];
        //UIImageView *imageView = [UIImage imageNamed:@"avatar.png"];
        btn1.enabled = YES;
        //[btn1 setBackgroundColor:[UIColor blueColor]];
        btn1.tag = val;
        NSLog(@"btn1.tag : %d", btn1.tag );
        
        if ( aModel.storageImage==NULL )
            [btn1 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        else
            [btn1 setImage:aModel.storageImage forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn1];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 73.0, 160.0, 25.0)];
        lbl1.textAlignment = UITextAlignmentLeft;
        lbl1.backgroundColor = [UIColor clearColor];
        lbl1.font = [UIFont boldSystemFontOfSize:17.0];
        lbl1.tag = indexPath.row;
        lbl1.text = aModel.friendName;
        lbl1.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
        [cell.contentView addSubview:lbl1];
        [lbl1 release];
        
        aModel = [self.itemStorage.storageList objectAtIndex:val+1];
        
        btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180.0, 6.0, 80.0, 65.0)];  
        if ( aModel.storageImage==NULL )
            [btn2 setImage:[UIImage imageNamed:@"logo.png"]forState:UIControlStateNormal];
        else
            [btn2 setImage:aModel.storageImage forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = val+1;
        NSLog(@"btn1.tag : %d", btn2.tag );
        [cell.contentView addSubview:btn2];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 73.0, 160.0, 25.0)];
        lbl2.textAlignment = UITextAlignmentLeft;
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.font = [UIFont boldSystemFontOfSize:17.0];
        lbl2.tag = indexPath.row+1;        
        lbl2.text = aModel.friendName;
        lbl2.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
        [cell.contentView addSubview:lbl2];
        [lbl2 release]; 
    }
    */
    
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
        {
            NSLog(@"[self.itemStorage.storageList count]: %d", [self.itemStorage.storageList count] );
            NSLog(@"[self.itemStorage.storageList count]%2: %d", [self.itemStorage.storageList count] );
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
    }
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
    VideosDone *videosDoneViewController = [ [VideosDone alloc] initWithNibName:@"VideosDone" bundle:nil :aModel];
    [[self navigationController] pushViewController:videosDoneViewController animated:YES];
    [videosDoneViewController release];
    */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
    [self.tableview reloadData];
}

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

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
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
    if ([elementName isEqualToString:@"featured"])
	{
		[self.itemStorage cleanStorage];
	}
	//else if ([elementName isEqualToString:@"item"])
    else if ([elementName isEqualToString:@"item"])
	{
        self.item = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//if ([elementName isEqualToString:@"item"])
    if ([elementName isEqualToString:@"item"])
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
    //[self.itemStorage downloadImages];
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
    // if ( btn1.tag == [self.itemStorage.storageList count]-1 )
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   // return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft);
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
