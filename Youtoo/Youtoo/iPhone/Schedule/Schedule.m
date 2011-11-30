//
//  Schedule.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "Schedule.h"
#import "ScheduleCell.h"
#import "ScheduleEpisodeDetail.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "Constants.h"
#import "YoutooAppDelegate.h"
#import "UpcomingEpisodes.h"
#import "ProfileCell.h"
#import "ScheduleEpisodeDetail.h"
#import "ProfileCellSecondTab.h"
#import "ProfileFriendView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kFeaturedRowHeight = 125.0;
@interface Schedule (PrivateMethods)
- (void)createCellLabels;
- (void)didStopLoadData;
@end

@implementation Schedule
@synthesize tableview;
@synthesize rssParser;
@synthesize itemStorage;
@synthesize item;
@synthesize currentElement;
@synthesize showName;
@synthesize showImage;
@synthesize showTime;
@synthesize activityIndicator;
@synthesize dateLbl;
@synthesize tabSelected;
@synthesize viewByName;
@synthesize viewByTime;
@synthesize btnTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentElement = @"";
		itemStorage = [[ItemStorage alloc] init];
		isNetworkOperation = NO; 
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        //if ( appDelegate.showID )
          //  [appDelegate.showID release];
        appDelegate.showID = [[[NSMutableArray alloc] init ]autorelease];
        
        viewByName = [[UIButton alloc] init];
        [viewByName setImage:[UIImage imageNamed:@"25-ScheduleInitial-vbn.png"] forState:UIControlStateNormal];
        [viewByName setImage:[UIImage imageNamed:@"ViewByNamePressed.png"] forState:UIControlStateHighlighted];

        viewByTime = [[UIButton alloc] init];
        [viewByTime setImage:[UIImage imageNamed:@"ViewByTimeUnpressed.png"] forState:UIControlStateNormal];
        [viewByTime setImage:[UIImage imageNamed:@"25-ScheduleInitial-vbt"] forState:UIControlStateHighlighted];

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
    [listOfImages release];
    [listOfItems release];
   // [showName release];
   // [showImage release];
   // [showTime release];
    [viewByTime release];
    [viewByName release];
    [activityIndicator release];
    [super dealloc];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    tabSelected=1; 
    btnTag = 0;
    
    //self.title = @"What's on Youtoo";
    
    self.navigationController.navigationBarHidden = YES;

    [tableview setDelegate:self];
	[tableview setDataSource:self];
   // tableview.rowHeight = kFeaturedRowHeight;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSLog(@"date: %@", dateString);
    dateLbl.text = dateString;
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopAdvertisingBar];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tempImageView setFrame:self.tableview.frame]; 
    
    self.tableview.backgroundView = tempImageView;
    [tempImageView release];
}


- (BOOL)canShowAdvertising
{
	return YES;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    showName= [[[NSMutableArray alloc] init ]autorelease];
    showImage=[[[NSMutableArray alloc] init ]autorelease];
    showTime =[[[NSMutableArray alloc] init ]autorelease]; 
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"SchedulePageLastUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || elapsedTime < -definedTimeInterval))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"SchedulePageLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        // [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/blogs/1/0/ASC?offset=%d", timeZoneOffset];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingEpisodes"];
       // [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingepisodes/YSY0008"];
        
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
	NSDate *pageLastUpdate = [defaults objectForKey:@"BlogPageLastUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || -[pageLastUpdate timeIntervalSinceNow] > kUpdatePeriod))
	{
		isNetworkOperation = YES;
		[self.activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"SchedulePageLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        //[tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/blogs/1/0/ASC?offset=%d", timeZoneOffset];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingEpisodes", timeZoneOffset];
        //[tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/upcomingepisodes/YSY0008"];
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

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen: appDelegate.tickerUserID: %@", appDelegate.tickerUserID);
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
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
    [super didReceiveMemoryWarning];
}

/*viewByName = [[UIButton alloc] init];
[viewByName setImage:[UIImage imageNamed:@"25-ScheduleInitial-vbn.png"] forState:UIControlStateNormal];
[viewByName setImage:[UIImage imageNamed:@"ViewByNamePressed.png"] forState:UIControlStateHighlighted];

viewByTime = [[UIButton alloc] init];
[viewByTime setImage:[UIImage imageNamed:@"ViewByTimeUnpressed.png"] forState:UIControlStateNormal];
[viewByTime setImage:[UIImage imageNamed:@"25-ScheduleInitial-vbt"] forState:UIControlStateHighlighted];
*/

-(IBAction) viewByTimeAction
{
    [viewByTime setImage:[UIImage imageNamed:@"25-ScheduleInitial-vbt.png"] forState:UIControlStateNormal];
    [viewByName setImage:[UIImage imageNamed:@"25-ScheduleInitial-vbn.png"] forState:UIControlStateNormal];
    
    NSLog(@"viewByTimeAction");
    tabSelected=1;
    [self.tableview reloadData];
    
}
-(IBAction) viewByNameAction
{
    [viewByName setImage:[UIImage imageNamed:@"ViewByNamePressed.png"] forState:UIControlStateNormal];
    [viewByTime setImage:[UIImage imageNamed:@"ViewByTimeUnpressed.png"] forState:UIControlStateNormal];
    
    NSLog(@"viewByNameAction");
    tabSelected=2;
    [self.tableview reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger noOfrows=0;
    if ( tabSelected==2 )
    {
        //noOfrows = [self.itemStorage.storageList count]/2;
        if ( [self.itemStorage.storageList count]<2 )
            noOfrows = [self.itemStorage.storageList count];
        else
            noOfrows = ( [self.itemStorage.storageList count] %2 ==0 ) ? [self.itemStorage.storageList count]/2 : ( [self.itemStorage.storageList count]/2 )+ 1;   
    }
    else
        noOfrows = [self.itemStorage.storageList count];
    
    return noOfrows;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if ( tabSelected==2 )
    
        return 145;
        
        else
            return 110;
            
}

-(IBAction) buttonPressed: (id) sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag: %d", [sender tag]);
    
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:[sender tag]];
    
   /* ScheduleEpisodeDetail *selctdViewController = [ [ScheduleEpisodeDetail alloc] initWithNibName:@"ScheduleEpisodeDetail" bundle:nil :aModel];
    [[self navigationController] pushViewController:selctdViewController animated:YES];
    [selctdViewController release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	[self.tableview reloadData]; */
    
    UpcomingEpisodes * upcomingEpisodesViewController = [ [UpcomingEpisodes alloc] initWithNibName:@"UpcomingEpisodes" bundle:nil :aModel];    
    [[self navigationController] pushViewController:upcomingEpisodesViewController animated:YES];
    [upcomingEpisodesViewController release];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //UITableViewCell *cell=[[UITableViewCell alloc]init];
    //static NSString *CellIdentifier1 = @"Cell";
    static NSString *CellIdentifier1 = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

    //NSString *CellIdentifier1 = [NSString stringWithFormat:@"identifier_%d", indexPath.row];
  //  UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier1] autorelease];
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
    
    
    static NSString *CellIdentifier = @"ProfileCell";
    ProfileCell *profCell = (ProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (nil == profCell)
    {
        if ( tabSelected==1 )
        {
            profCell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:CellIdentifier :indexPath.row];
        }
    }
    //if (nil == profCellSecondTab)
    {
        if ( tabSelected==2 )
        {
            //profCellSecondTab = [[ProfileCellSecondTab alloc] initWithStyle:UITableViewCellStyleDefault 
                                              //          reuseIdentifier:CellIdentifier :indexPath.row] ;
        }
    }
    
    if ( tabSelected==1 )
    {        
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [profCell setCurrRow:indexPath.row];
        ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
        profCell.itemModel = aModel;        
        
    }
    else if ( tabSelected==2 )
    {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        tableView.backgroundColor = [UIColor clearColor];
        
        if ( indexPath.row==0 )
        {
            ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
            
            btn1 = [[UIButton alloc] initWithFrame:CGRectMake(39.0, 6.0, 100.0, 100.0)];
            //UIImageView *imageView = [UIImage imageNamed:@"avatar.png"];
            btn1.enabled = YES;
            //[btn1 setBackgroundColor:[UIColor blueColor]];
            btn1.tag = indexPath.row;
            NSLog(@"btn1.tag : %d", btn1.tag );
            
            if ( aModel.storageImage==NULL )
                [btn1 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
            else
                [btn1 setImage:aModel.storageImage forState:UIControlStateNormal];
            
            [btn1.layer setBorderColor: [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor]]; 
            [btn1.layer setBorderWidth: 5.0];

            [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
                        
            lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(39.0, 104.0, 100.0, 40.0)];
            lbl1.textAlignment = UITextAlignmentCenter;
            lbl1.backgroundColor = [UIColor clearColor];
            [lbl1 setFont:[UIFont systemFontOfSize:14.0]];
            lbl1.tag = indexPath.row;
            lbl1.text = aModel.showName;
            //lbl1.textColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.24 alpha:1];
            lbl1.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
            lbl1.numberOfLines = 2;
            [cell.contentView addSubview:lbl1];
            [lbl1 release];
            //[btn1 release];
            
            if ( [self.itemStorage.storageList count]>1 )
            {
            aModel = [self.itemStorage.storageList objectAtIndex:(indexPath.row)+1];
            
            btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180.0, 6.0, 100.0, 100.0)];  
            if ( aModel.storageImage==NULL )
                [btn2 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
            else
                [btn2 setImage:aModel.storageImage forState:UIControlStateNormal];
            
                [btn2.layer setBorderColor: [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor]]; 
                [btn2.layer setBorderWidth: 5.0];

                [btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            btn2.tag = (indexPath.row)+1;
            NSLog(@"btn1.tag : %d", btn2.tag );
            [cell.contentView addSubview:btn2];
                            
            lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 104.0, 100.0, 40.0)];
            lbl2.textAlignment = UITextAlignmentCenter;
            lbl2.backgroundColor = [UIColor clearColor];
                [lbl2 setFont:[UIFont systemFontOfSize:14.0]];
            lbl2.tag = indexPath.row+1;        
            lbl2.text = aModel.showName;
            lbl2.numberOfLines = 2;
            //lbl2.textColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.24 alpha:1];
                lbl2.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
            [cell.contentView addSubview:lbl2];
            [lbl2 release];
                //[btn2 release];
            }
        }
        else
        {
            NSUInteger val = (indexPath.row)+(indexPath.row); 
            ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:val];
            
            btn1 = [[UIButton alloc] initWithFrame:CGRectMake(39.0, 6.0, 100.0, 100.0)];
            //UIImageView *imageView = [UIImage imageNamed:@"avatar.png"];
            btn1.enabled = YES;
            //[btn1 setBackgroundColor:[UIColor blueColor]];
            btn1.tag = val;
            NSLog(@"btn1.tag : %d", btn1.tag );
            
            if ( aModel.storageImage==NULL )
                [btn1 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
            else
                [btn1 setImage:aModel.storageImage forState:UIControlStateNormal];
            
            [btn1.layer setBorderColor: [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor]]; 
            [btn1.layer setBorderWidth: 5.0];

            [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
                        
            lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(39.0, 104.0, 100.0, 40.0)];
            lbl1.textAlignment = UITextAlignmentCenter;
            lbl1.backgroundColor = [UIColor clearColor];
            [lbl1 setFont:[UIFont systemFontOfSize:14.0]];
            lbl1.tag = indexPath.row;
            lbl1.text = aModel.showName;
             lbl1.numberOfLines = 2;
            //lbl1.textColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.24 alpha:1];
            lbl1.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
            [cell.contentView addSubview:lbl1];
            [lbl1 release];
            //[btn1 release];
            
            BOOL dontExecute = FALSE;
            if ( ( [self.itemStorage.storageList count]%2 != 0 && indexPath.row==([self.itemStorage.storageList count]/2) ) ) // Finding last row second cell button is not needed to draw in case of odd count
            {
                dontExecute=TRUE;
            }
            
            if ( !dontExecute )
            {
            aModel = [self.itemStorage.storageList objectAtIndex:val+1];
            
            btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180.0, 6.0, 100.0, 100.0)];  
            if ( aModel.storageImage==NULL )
                [btn2 setImage:[UIImage imageNamed:@"logo.png"]forState:UIControlStateNormal];
            else
                [btn2 setImage:aModel.storageImage forState:UIControlStateNormal];
            
                [btn2.layer setBorderColor: [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor]]; 
                [btn2.layer setBorderWidth: 5.0];
                
                [btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            btn2.tag = val+1;
            NSLog(@"btn1.tag : %d", btn2.tag );
            [cell.contentView addSubview:btn2];
                            
            lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 104.0, 100.0, 40.0)];
            lbl2.textAlignment = UITextAlignmentCenter;
            lbl2.backgroundColor = [UIColor clearColor];
            [lbl2 setFont:[UIFont systemFontOfSize:14.0]];
            lbl2.tag = indexPath.row+1;        
            lbl2.text = aModel.showName;
            lbl2.numberOfLines = 2;
            //lbl2.textColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.24 alpha:1];
                lbl2.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
            [cell.contentView addSubview:lbl2];
            [lbl2 release]; 
              //  [btn2 release];
            }
        }
               
    }
    if ( tabSelected==1 )
        return profCell;
    else
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( tabSelected==1 )
    {
        ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
    
        //NSLog(@"aModel.questionName: %@", aModel.questionName);
        
        ScheduleEpisodeDetail *selctdViewController = [ [ScheduleEpisodeDetail alloc] initWithNibName:@"ScheduleEpisodeDetail" bundle:nil :aModel];
        [[self navigationController] pushViewController:selctdViewController animated:YES];
        [selctdViewController release];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
        [self.tableview reloadData];
    }
}

#pragma mark -
#pragma mark Notification selector
#pragma mark -

- (void)homeControlSelector:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSString *strKey = [dict objectForKey:@"1"];
        
    if ( tabSelected==1 )
    {
	if ([strKey isEqualToString:kNotifyReloadTable])
	{
		ItemModel *itemModel = [dict objectForKey:@"ItemModel"];
		NSArray *visibleCells = [self.tableview visibleCells];
		for (ProfileCell *cell in visibleCells)
		{
			if ([cell.itemModel.showID isEqualToString:itemModel.showID])
			{
				cell.itemModel = itemModel;
				break;
			}
		}
	}
	}
	if ([strKey isEqualToString:kNotifyImagesDidLoad])
	{
		[self didStopLoadData];
	}
    
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
    
    if ( tabSelected==1 )
    {
        [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(reloadTable:) userInfo:nil repeats:NO];
    }
}

- (void)reloadTable:(NSTimer*)timer
{
    [tableview reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reloadTableAgain:) userInfo:nil repeats:NO];
}

- (void)reloadTableAgain:(NSTimer*)timer
{
    [tableview reloadData];
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
