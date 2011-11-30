//
//  RecordAfameSpot.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "RecordAfameSpot.h"
#import "FameSpotCell.h"
#import "SelectAfameSpot.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "Constants.h"
#import "YoutooAppDelegate.h"
#import "ProfileCell.h"
#import "ProfileFriendView.h"
#import "RecordA15SecVideo.h"
#import "UploadA15SecVideo.h"
#import "TopicsCell.h"

static const CGFloat kFeaturedRowHeight = 80.0;
@interface RecordAfameSpot (PrivateMethods)
- (void)createCellLabels;
- (void)didStopLoadData;
@end

@implementation RecordAfameSpot

@synthesize tableview;
@synthesize rssParser;
@synthesize itemStorage;
@synthesize item;
@synthesize currentElement;
@synthesize activityIndicator;
@synthesize tabSelected;
@synthesize programs;
@synthesize topics;
@synthesize selectLbl;
@synthesize firsttimeProgramCalled;
@synthesize uploadViewBtn;
@synthesize recordViewBtn;
@synthesize chooseImg;
@synthesize topicitemStorage;
@synthesize topicitem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentElement = @"";
		itemStorage = [[ItemStorage alloc] init];
        topicitemStorage = [[ItemStorage alloc] init];
		isNetworkOperation = NO;     
        firsttimeProgramCalled = 0;
    }
    return self;
}

- (void)dealloc
{
    [self.item release];
    [topicitem release];
	self.currentElement = nil;
	//self.rssParser= nil;
	[itemStorage release];
    [topicitemStorage release];
    
    [activityIndicator release];
    
    //[uploadViewBtn release];
    //[recordViewBtn release];
    if ( chooseImg )
        [chooseImg release];
    
    [super dealloc];
}


//- (void)viewDidAppear:(BOOL)animated
-(void) DownloadRecordFameSpotImages
{
    //[super viewDidAppear:animated];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    isNetworkOperation = YES;
    [self.activityIndicator startAnimating];
    
    [appDelegate didStartNetworking];
    // Get the current timezone in hours and send to server...
    NSString *featuredString;
    
    programs.enabled = NO;
    topics.enabled = NO;
    self.tableview.scrollEnabled = NO;
    self.tableview.userInteractionEnabled = NO;
    
    if( tabSelected==1 )
    {
        //[tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/topics"];
        featuredString = @"http://www.youtoo.com/iphoneyoutoo/topics";
        NSLog(@"DownloadRecordFameSpotImages: %@", featuredString);
    }
    else
    {
        //[tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/getshows"];
        //firsttimeProgramCalled = 2;    
        featuredString = @"http://www.youtoo.com/iphoneyoutoo/getshows";
        NSLog(@"DownloadRecordFameSpotImages: %@", featuredString);
    }
    //featuredString = [tempURLStr copy];
    
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
}

- (void)reloadPage
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"RecordAFameSpotUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || -[pageLastUpdate timeIntervalSinceNow] > kUpdatePeriod))
	{
		isNetworkOperation = YES;
		[self.activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"RecordAFameSpotUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        //NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        if( tabSelected==1 )
        {
            //  [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/topics"];
            featuredString = @"http://www.youtoo.com/iphoneyoutoo/topics";
            NSLog(@"Reloadpage: %@", featuredString);
        }
        else
        {
            //   [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/getshows"];
            featuredString = @"http://www.youtoo.com/iphoneyoutoo/getshows";
            NSLog(@"Reloadpage: %@",featuredString);
        }
        //featuredString = [tempURLStr copy];
        //NSLog(featuredString);
        //[tempURLStr release];
        //tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
	}
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = NULL;
	[appDeleagte stopAdvertisingBar];
    
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
    
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 11 || subview.tag == 22 || subview.tag == 33) 
        {
            [subview removeFromSuperview];
        }
    }
    
    /* if ( uploadViewBtn )
     [uploadViewBtn removeFromSuperview];
     if ( recordViewBtn )
     [recordViewBtn removeFromSuperview];
     if ( chooseImg )
     [chooseImg removeFromSuperview];
     */
    
    [self DownloadRecordFameSpotImages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
    [self.tableview reloadData];
    
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"didReceiveMemoryWarning");
    
 	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	[self.activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    
    [self.itemStorage cleanImages];
    
    programs.enabled = YES;
    topics.enabled = YES;
    self.tableview.scrollEnabled = YES;
    self.tableview.userInteractionEnabled = YES;
    
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Record a Fame Spot";
    
	[tableview setDelegate:self];
	[tableview setDataSource:self];
    tableview.rowHeight = kFeaturedRowHeight;
    
    firsttimeProgramCalled = 0;

    
    // Do any additional setup after loading the view from its nib.
    //YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    //    appDeleagte.selectedController = self;
    //	[appDeleagte startAdvertisingBar];
    
    //activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];
    activityIndicator.frame = CGRectMake(138, 180, 40, 40);
    // [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    //[self.view addSubview:activityIndicator];
    tabSelected=1;
    selectLbl.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
    if(tabSelected==1)
        selectLbl.text = @"Please select a topic.";
    else
        selectLbl.text = @"Please select a program.";
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
}

- (BOOL)canShowAdvertising
{
	return YES;
}
-(IBAction) TopicsAction
{
    tabSelected=1;
    
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 11 || subview.tag == 22 || subview.tag == 33) 
        {
            [subview removeFromSuperview];
        }
    }
    
    [self DownloadRecordFameSpotImages];
    
    [topics setImage:[UIImage imageNamed:@"topics.png"] forState:UIControlStateNormal];
    [programs setImage:[UIImage imageNamed:@"prog.png"] forState:UIControlStateNormal];
    
    NSLog(@"viewByTimeAction");
    
    selectLbl.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
    selectLbl.text = @"Please select a topic.";
    
    //if ( [self.itemStorage.storageList count] == 0 )
    
    [self.tableview reloadData];
    
}
-(IBAction) programsAction
{
    tabSelected=2;
    
    /*if ( uploadViewBtn )
     [uploadViewBtn removeFromSuperview];
     if ( recordViewBtn )
     [recordViewBtn removeFromSuperview];
     if ( chooseImg )
     [chooseImg removeFromSuperview];
     */
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 11 || subview.tag == 22 || subview.tag == 33) 
        {
            [subview removeFromSuperview];
        }
    }
    
    
    [self DownloadRecordFameSpotImages];
    
    [topics setImage:[UIImage imageNamed:@"topics-1.png"] forState:UIControlStateNormal];
    [programs setImage:[UIImage imageNamed:@"prog-1.png"] forState:UIControlStateNormal];
    
    NSLog(@"viewByNameAction");    
    selectLbl.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
    selectLbl.text = @"Please select a program.";
    
    [self.tableview reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(tabSelected == 2)
        return 145;
    else
        return 125;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//return [self.itemStorage.storageList count];
    NSInteger noOfrows=0;
    
    if(tabSelected == 2)
    {
        //noOfrows = [self.itemStorage.storageList count]/2;
        if ( [self.itemStorage.storageList count]<2 )
            noOfrows = [self.itemStorage.storageList count];
        else
            noOfrows = ( [self.itemStorage.storageList count] %2 ==0 ) ? [self.itemStorage.storageList count]/2 : ( [self.itemStorage.storageList count]/2 )+ 1;  
    }
    else
        noOfrows = [self.topicitemStorage.storageList count];
    
    return noOfrows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*  static NSString *CellIdentifier = @"FameSpotCell";
     FameSpotCell *cell = (FameSpotCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     cell = [[[FameSpotCell alloc] initWithStyle:UITableViewCellStyleDefault 
     reuseIdentifier:CellIdentifier] autorelease];
     
     //    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
     //	cell.itemModel = aModel;
     tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     tableView.backgroundColor = [UIColor clearColor];
     
     if ( indexPath.row==0 )
     {
     ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
     
     btn1 = [[UIButton alloc] initWithFrame:CGRectMake(30.0, 6.0, 80.0, 65.0)];
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
     
     lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 73.0, 140.0, 25.0)];
     lbl1.textAlignment = UITextAlignmentLeft;
     lbl1.backgroundColor = [UIColor clearColor];
     lbl1.font = [UIFont boldSystemFontOfSize:15.0];
     lbl1.tag = indexPath.row;
     lbl1.text = aModel.showName;
     lbl1.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
     [cell.contentView addSubview:lbl1];
     [lbl1 release];
     
     if ( [self.itemStorage.storageList count]>1 )
     {
     aModel = [self.itemStorage.storageList objectAtIndex:(indexPath.row)+1];
     
     btn2 = [[UIButton alloc] initWithFrame:CGRectMake(195.0, 6.0, 80.0, 65.0)];  
     if ( aModel.storageImage==NULL )
     [btn2 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
     else
     [btn2 setImage:aModel.storageImage forState:UIControlStateNormal];
     [btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
     btn2.tag = (indexPath.row)+1;
     NSLog(@"btn1.tag : %d", btn2.tag );
     [cell.contentView addSubview:btn2];
     
     lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 73.0, 140.0, 25.0)];
     lbl2.textAlignment = UITextAlignmentLeft;
     lbl2.backgroundColor = [UIColor clearColor];
     lbl2.font = [UIFont boldSystemFontOfSize:15.0];
     lbl2.tag = indexPath.row+1;        
     lbl2.text = aModel.showName;
     lbl2.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
     [cell.contentView addSubview:lbl2];
     [lbl2 release];
     }
     }
     else
     {
     NSUInteger val = (indexPath.row)+(indexPath.row); 
     ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:val];
     
     btn1 = [[UIButton alloc] initWithFrame:CGRectMake(30.0, 6.0, 80.0, 65.0)];
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
     
     lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 73.0, 140.0, 25.0)];
     lbl1.textAlignment = UITextAlignmentLeft;
     lbl1.backgroundColor = [UIColor clearColor];
     lbl1.font = [UIFont boldSystemFontOfSize:15.0];
     lbl1.tag = indexPath.row;
     lbl1.text = aModel.showName;
     lbl1.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
     [cell.contentView addSubview:lbl1];
     [lbl1 release];
     
     BOOL dontExecute = FALSE;
     if ( ( [self.itemStorage.storageList count]%2 != 0 && indexPath.row==([self.itemStorage.storageList count]/2) ) ) // Finding last row second cell button is not needed to draw in case of odd count
     {
     dontExecute=TRUE;
     }
     
     if ( !dontExecute )
     {
     aModel = [self.itemStorage.storageList objectAtIndex:val+1];
     
     btn2 = [[UIButton alloc] initWithFrame:CGRectMake(195.0, 6.0, 80.0, 65.0)];  
     if ( aModel.storageImage==NULL )
     [btn2 setImage:[UIImage imageNamed:@"logo.png"]forState:UIControlStateNormal];
     else
     [btn2 setImage:aModel.storageImage forState:UIControlStateNormal];
     [btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
     btn2.tag = val+1;
     NSLog(@"btn1.tag : %d", btn2.tag );
     [cell.contentView addSubview:btn2];
     
     lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 73.0, 140.0, 25.0)];
     lbl2.textAlignment = UITextAlignmentLeft;
     lbl2.backgroundColor = [UIColor clearColor];
     lbl2.font = [UIFont boldSystemFontOfSize:15.0];
     lbl2.tag = indexPath.row+1;        
     lbl2.text = aModel.showName;
     lbl2.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
     [cell.contentView addSubview:lbl2];
     [lbl2 release]; 
     }
     }
     */
    /*static NSString *CellIdentifier1 = @"Cell";
     
     UITableViewCell *tcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
     
     tcell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
     */
    
    
    tableview.backgroundColor = [UIColor clearColor];
    
    if(tabSelected == 2)
    {
        
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        static NSString *CellIdentifier = @"FameSpotCell";
        FameSpotCell *cell = (FameSpotCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell)
        {
       		cell = [[[FameSpotCell alloc] initWithStyle:UITableViewCellStyleDefault 
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
    else 
    {
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
        static NSString *CellIdentifier2 = @"TopicsCell";
        
        TopicsCell *profCell = (TopicsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (nil == profCell)
        {
            //profCell = (TopicsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            profCell = [[[TopicsCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:CellIdentifier2] autorelease];
            
        }
        
        ItemModel *aModel = [self.topicitemStorage.storageList objectAtIndex:indexPath.row];
        profCell.itemModel = aModel;
        
        return profCell;
        
        //return topiccell;
    }
    
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tabSelected == 1)
    {
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
        //[self.tableview reloadData];
        ItemModel *aModel;
        //if(tabSelected == 1)
        aModel = [self.topicitemStorage.storageList objectAtIndex:indexPath.row];
        //else
        //  aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
        
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.epiQuestionID = aModel.questionID;
        
        NSLog(@"aModel.showName: %@ ", aModel.showName);
        NSLog(@"aModel.questionName: %@", aModel.questionName);
        NSLog(@"aModel.questionID: %@", aModel.questionID);
        
        //appDelegate.episodeName = [NSString stringWithFormat:@"%@",(aModel.showName!=NULL) ? aModel.showName : @""];
        //appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:@":"];
        //appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:(aModel.questionName!=NULL)?aModel.questionName:@""];
        //appDelegate.episodeName = [ NSString stringWithFormat:@"%@",(aModel.questionName!=NULL)?aModel.questionName:@""];
        
        //appDelegate.episodeName= aModel.questionName;
        
        appDelegate.titleString = [NSString stringWithFormat:@"%@",(aModel.showName!=NULL) ? aModel.showName : @""];
        NSLog(@"appDelegate.titleString: %@", appDelegate.titleString);
        NSString *tempTxt = [NSString stringWithFormat:@"%@", @""];
        
        for (int i=0; i<[appDelegate.titleString length] ; i++)
        {
            tempTxt = [tempTxt stringByAppendingString:@"  "];
        }
        //NSLog(@"tempTxt: %@ ; %d", tempTxt, [tempTxt length]);
        //appDelegate.episodeName = NULL;
        appDelegate.episodeName = [ NSString stringWithFormat:@"%@", tempTxt];
        appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:(aModel.questionName!=NULL)?aModel.questionName:@""];
        
        // [tempTxt release];
        
        NSLog(@"appDelegate.episodeName: %@", appDelegate.episodeName);
        
        uploadViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [uploadViewBtn setFrame:CGRectMake(29, 285, 130, 130)];
        [uploadViewBtn setBackgroundImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [uploadViewBtn addTarget:self action:@selector(uploadViewAct:) forControlEvents:UIControlEventTouchDown];
        uploadViewBtn.tag = 11;
        [self.view addSubview:uploadViewBtn];
        
        recordViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordViewBtn setFrame:CGRectMake(156, 285, 130, 130)];
        [recordViewBtn setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        [recordViewBtn addTarget:self action:@selector(recordViewAct:) forControlEvents:UIControlEventTouchDown];
        recordViewBtn.tag = 22;
        [self.view addSubview:recordViewBtn];    
        
        chooseImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose.png"]]; 
        [chooseImg setFrame:CGRectMake(58, 210, 200, 75)]; 
        chooseImg.tag = 33;
        [self.view addSubview:chooseImg];    
        
    }
    
	
}
-(IBAction) buttonPressed: (id) sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag: %d", [sender tag]);
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:[sender tag]];
    SelectAfameSpot *selctdViewController = [ [SelectAfameSpot alloc] initWithNibName:@"SelectAfameSpot" bundle:nil :aModel];
    [[self navigationController] pushViewController:selctdViewController animated:YES];
    [selctdViewController release];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	//[self.tableview reloadData];
    
}

-(void)uploadViewAct:(id)sender
{
    //UploadA15SecVideo *uploadViewContr = [[UploadA15SecVideo alloc] initWithNibName:@"UploadA15SecVideo" bundle:nil];
    //[self.navigationController pushViewController:uploadViewContr animated:YES];
    //[uploadViewContr release];*/
    
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	[appDeleagte stopAdvertisingBar];
    
    // Updated - overlay code.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.pickerController = [[UIImagePickerController alloc] init];
    appDelegate.pickerController.delegate = self;
    appDelegate.pickerController.allowsEditing = YES;
    appDelegate.pickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    
    appDelegate.pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:appDelegate.pickerController animated:YES];
    [ appDelegate.pickerController release];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"youtoo: Recording finished...didFinishPickingMediaWithInfo()");
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
	{
		NSLog(@"youtoo: mediaType is kUTTypeMovie...didFinishPickingMediaWithInfo()");
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSString *urlPath = [videoURL path];
		NSLog(@"youtoo: VideoURLPath: %@...didFinishPickingMediaWithInfo()", urlPath);
		if ([[urlPath lastPathComponent] isEqualToString:@"capturedvideo.MOV"])
		{
			if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (urlPath))
			{
				NSLog(@"youtoo: Process to Save Video To Saved Photos Album...if loop of lastPathComponent..didFinishPickingMediaWithInfo()");
				UISaveVideoAtPathToSavedPhotosAlbum (urlPath, self,
                                                     @selector(video:didFinishSavingWithError:contextInfo:), nil);
			}
			else
			{
				NSLog(@"youtoo: Video Capture Error: Captured video cannot be saved...didFinishPickingMediaWithInfo()");
				[appDelegate reportError:NSLocalizedString(@"Video Capture Error", @"Alert Title") 
                             description:NSLocalizedString(@"Captured video cannot be saved.", @"Alert Title")];
			}
		}
		
		else
		{
			NSLog(@"youtoo: Processing soon to saved photos album...else loop of lastPathComponent..didFinishPickingMediaWithInfo()");
            [self processVideoFile:urlPath];
		}
	}
    // remove notification
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
	[self dismissModalViewControllerAnimated:YES];
    
	
}
- (void)processVideoFile:(NSString *)videoPath
{
    
    
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.currentVideoPath = videoPath;
    UploadA15SecVideo *uploadViewContr = [[UploadA15SecVideo alloc] initWithNibName:@"UploadA15SecVideo" bundle:nil];
    [self.navigationController pushViewController:uploadViewContr animated:NO];
    [uploadViewContr release];
    
}
-(void)recordViewAct:(id)sender
{
    RecordA15SecVideo *recordViewContr = [[RecordA15SecVideo alloc] initWithNibName:@"RecordA15SecVideo" bundle:nil];
    [self.navigationController pushViewController:recordViewContr animated:YES];
    [recordViewContr release];
}
#pragma mark -
#pragma mark Notification selector
#pragma mark -

- (void)homeControlSelector:(NSNotification *)notification
{
    if(tabSelected == 2)
    {
        NSDictionary *dict = [notification userInfo];
        NSString *strKey = [dict objectForKey:@"1"];
        if ([strKey isEqualToString:kNotifyReloadTable])
        {
            ItemModel *itemModel = [dict objectForKey:@"ItemModel"];
            NSArray *visibleCells = [tableview visibleCells];
            for (FameSpotCell *cell in visibleCells)
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
	if ([elementName isEqualToString:@"shows"] )
	{
		[self.itemStorage cleanStorage];        
	}
    else if ([elementName isEqualToString:@"topics"] )
	{
        [self.topicitemStorage cleanStorage];
    }
	else if ([elementName isEqualToString:@"show"] )
	{
        self.item = [NSMutableDictionary dictionary];
    }
    else if ([elementName isEqualToString:@"topic"] )
	{
        self.topicitem = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"show"])
	{
		ItemModel *model = [[ItemModel alloc] initWithDict:self.item];
		model.isBlog = YES;
		[self.itemStorage.storageList addObject:model];
		[model release];
    }
    if ( [elementName isEqualToString:@"topic"] )
    {
        ItemModel *model = [[ItemModel alloc] initWithDict:self.topicitem];
		model.isBlog = YES;
		[self.topicitemStorage.storageList addObject:model];
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
	if ([trimmString length] > 0 && tabSelected==2)
	{
		[self.item setObject:trimmString forKey:self.currentElement];
	}
    if ([trimmString length] > 0 && tabSelected==1)
	{
		[self.topicitem setObject:trimmString forKey:self.currentElement];
	}
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{	
	[self.itemStorage downloadImages];
	[self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:YES];
}

#pragma mark -

- (void)didStopLoadData
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	[self.activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
	[tableview reloadData];
    
    programs.enabled = YES;
    topics.enabled = YES;
    self.tableview.scrollEnabled = YES;
    self.tableview.userInteractionEnabled = YES;
    
    if ( tabSelected==2 )
    {
        [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(reloadTable:) userInfo:nil repeats:NO];
    }
}
- (void)reloadTable:(NSTimer*)timer
{    
    if ( tabSelected==2 )
        [tableview reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reloadTableAgain:) userInfo:nil repeats:NO];
}

- (void)reloadTableAgain:(NSTimer*)timer
{    
    if ( tabSelected==2 )
        [tableview reloadData];
}


- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
	[self.activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    programs.enabled = YES;
    topics.enabled = YES;
    self.tableview.scrollEnabled = YES;
    self.tableview.userInteractionEnabled = YES;
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
