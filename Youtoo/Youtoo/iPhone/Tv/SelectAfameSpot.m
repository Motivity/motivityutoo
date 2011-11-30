//
//  SelectAfameSpot.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "SelectAfameSpot.h"
#import "SelectAfameSpotCell.h"
#import "UploadA15SecVideo.h"
#import "RecordA15SecVideo.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "YoutooAppDelegate.h"
#import "Constants.h"
#import "ProfileFriendView.h"

static const CGFloat kFeaturedRowHeight = 120.0;

@implementation SelectAfameSpot

@synthesize tableview;
@synthesize itemStorage;
@synthesize item;
@synthesize currentElement;
@synthesize rssParser;
@synthesize activityIndicator;
@synthesize titleLabel;
@synthesize uploadViewBtn;
@synthesize recordViewBtn;
@synthesize chooseImg;

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
    [activityIndicator release];
    [titleLabel release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = myItemModel.showName;
    
    [tableview setDelegate:self];
	[tableview setDataSource:self];
    tableview.rowHeight = kFeaturedRowHeight;
    
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
//    appDeleagte.selectedController = self;
//	[appDeleagte startAdvertisingBar];
    titleLabel.text = myItemModel.showName;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"SelectAFameSpotLastUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || elapsedTime < -definedTimeInterval))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"SelectAFameSpotLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/getEpisodes/%@", myItemModel.showID];
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
	NSDate *pageLastUpdate = [defaults objectForKey:@"SelectAFameSpotLastUpdate"];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if (!isNetworkOperation && ([self.itemStorage.storageList count] == 0 || -[pageLastUpdate timeIntervalSinceNow] > kUpdatePeriod))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
		[defaults setObject:[NSDate date] forKey:@"SelectAFameSpotLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/getEpisodes/%@", myItemModel.showID];
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
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = NULL;
	[appDeleagte stopAdvertisingBar];

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
        if (subview.tag == 44 || subview.tag == 55 || subview.tag == 66) 
        {
            [subview removeFromSuperview];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	[self.tableview reloadData];
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen: appDelegate.tickerUserID: %@", appDelegate.tickerUserID);
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.itemStorage.storageList count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"SelectAfameSpotCell";
	SelectAfameSpotCell *cell = (SelectAfameSpotCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell)
	{
		cell = [[[SelectAfameSpotCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                    reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
	cell.itemModel = aModel;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.epiQuestionID = aModel.questionID;
    
    NSLog(@"myItemModel.showName: %@", myItemModel.showName);
    
    //appDelegate.episodeName = [NSString stringWithFormat:@"%@",(myItemModel.showName!=NULL) ? myItemModel.showName : @""];
    //appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:@":"];
   // appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:(aModel.questionName!=NULL)?aModel.questionName:@""];
    
    appDelegate.titleString = [NSString stringWithFormat:@"%@",(myItemModel.showName!=NULL) ? myItemModel.showName : @""];
    
    NSString *tempTxt = [NSString stringWithFormat:@"%@", @""];
    
    for (int i=0; i<[appDelegate.titleString length] ; i++)
    {
        tempTxt = [tempTxt stringByAppendingString:@"  "];
    }
    NSLog(@"tempTxt: %@ ; %d", tempTxt, [tempTxt length]);
    
    appDelegate.episodeName = [ NSString stringWithFormat:@"%@", tempTxt];
    appDelegate.episodeName = [ appDelegate.episodeName stringByAppendingString:(aModel.questionName!=NULL)?aModel.questionName:@""];
    
    NSLog(@"appDelegate.episodeName: %@", appDelegate.episodeName);
    
    //appDelegate.episodeName= aModel.questionName;
    

    uploadViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadViewBtn setFrame:CGRectMake(29, 285, 130, 130)];
    [uploadViewBtn setBackgroundImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
    [uploadViewBtn addTarget:self action:@selector(uploadViewAct:) forControlEvents:UIControlEventTouchDown];
    uploadViewBtn.tag = 44;
    [self.view addSubview:uploadViewBtn];

    recordViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordViewBtn setFrame:CGRectMake(156, 285, 130, 130)];
    [recordViewBtn setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    [recordViewBtn addTarget:self action:@selector(recordViewAct:) forControlEvents:UIControlEventTouchDown];
    recordViewBtn.tag = 55;
    [self.view addSubview:recordViewBtn];    
    
    chooseImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"choose.png"]]; 
    [chooseImg setFrame:CGRectMake(58, 210, 200, 75)]; 
    chooseImg.tag = 66;
    [self.view addSubview:chooseImg];    
    [chooseImg release];

  /*  fameSpotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fameSpotBtn setFrame:CGRectMake(29, 267, 130, 130)];
    [fameSpotBtn setBackgroundImage:[UIImage imageNamed:@"record-a-fame-spot.png"] forState:UIControlStateNormal];
    [fameSpotBtn addTarget:self action:@selector(fameSoptAct:) forControlEvents:UIControlEventTouchDown];
    [self.myOwnOverlay addSubview:fameSpotBtn];
    
    tickerShoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tickerShoutBtn setFrame:CGRectMake(156, 269, 130, 130)];
    [tickerShoutBtn setBackgroundImage:[UIImage imageNamed:@"write-a-ticker-shout.png"] forState:UIControlStateNormal];
    [tickerShoutBtn addTarget:self action:@selector(tickerSpotAct:) forControlEvents:UIControlEventTouchDown];
    [self.myOwnOverlay addSubview:tickerShoutBtn];
    
    helpViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpViewBtn setFrame:CGRectMake(200, 192, 90, 80)];
    [helpViewBtn setBackgroundImage:[UIImage imageNamed:@"20-BeOnTV-help.png"] forState:UIControlStateNormal];
    [helpViewBtn addTarget:self action:@selector(helpViewAct:) forControlEvents:UIControlEventTouchDown];
    [self.myOwnOverlay addSubview:helpViewBtn];
*/
}
-(void)uploadViewAct:(id)sender
{
    //UploadA15SecVideo *uploadViewContr = [[UploadA15SecVideo alloc] initWithNibName:@"UploadA15SecVideo" bundle:nil];
    //[self.navigationController pushViewController:uploadViewContr animated:YES];
    //[uploadViewContr release];*/
  
    
    
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
		NSArray *visibleCells = [tableview visibleCells];
		for (SelectAfameSpotCell *cell in visibleCells)
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
	if ([elementName isEqualToString:@"shows"])
	{
		[self.itemStorage cleanStorage];
	}
	else if ([elementName isEqualToString:@"show"])
	{
        self.item = [NSMutableDictionary dictionary];
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
}

- (BOOL)canShowAdvertising
{
	return YES;
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
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
