//
//  ProfileFavorites.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFavorites.h"
#import "ProfileFavoritesCell.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "ProfileFavoritesCell.h"
#import "Constants.h"
#import "ProfileFriendView.h"

static const CGFloat kFeaturedRowHeight = 80.0;
@implementation ProfileFavorites
@synthesize tableview;
@synthesize rssParser;
@synthesize item;
@synthesize currentElement;
@synthesize creditLbl;
@synthesize isNetworkOperation;
@synthesize activityIndicator;
@synthesize sendResult;
@synthesize imageArray;
@synthesize itemStorage;
@synthesize profileName;
@synthesize profileImage;
@synthesize userid;

- (id)setupFavNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(BOOL) myOwn :(NSString *) userID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        myOwnCalled = myOwn;
        self.userid = NULL;
        
        if ( aModel!=NULL )
            myItemModel = aModel;
        else
            myItemModel = nil;
        itemStorage = [[ItemStorage alloc] init];
        self.isNetworkOperation = NO;
        self.sendResult = @"";
        networkQueue = [[ASINetworkQueue alloc] init];  
        
        if ( userID!= NULL )
            self.userid = userID;
    }
    return self;
}

- (void)dealloc
{
   // self.item = nil;
    [item release];
	self.currentElement = nil;
	self.rssParser= nil;
    [activityIndicator release];
    [creditLbl release];
    [imageArray release];
    [itemStorage release];
    [profileName release];
    [profileImage release];
    
    for (ASIHTTPRequest *req in [networkQueue operations])
    {
        [req setDelegate:nil];
        [req cancel];
    }
    [networkQueue setDelegate:nil];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
    
    [tableview setDelegate:self];
	[tableview setDataSource:self];
    
    
    // Do any additional setup after loading the view from its nib.    
    /*creditLbl.text= [appDelegate.creditStr stringByAppendingString:@" Credits"];
    if ( profileName.text==NULL )
        profileName.text = @"Name";
    else
        profileName.text = appDelegate.userName;
    */
    
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
    
    reloadTImer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(reloadScreen:) userInfo:nil repeats:NO];
    
    [activityIndicator startAnimating];
     
    //[appDelegate authenticateAtLaunchIfNeedBe];

}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) reloadScreen:(NSTimer*)timer
{
    if ( [self.item count]==0 )
    {
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSString *authpath = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [appDelegate readUserName], [appDelegate readLoginPassword]];
        NSLog(@"AuthRequest URL in ProfileFameS: %@", authpath);
        NSURL *authurl = [NSURL URLWithString:authpath];
        ASIHTTPRequest *authRequest = [ASIHTTPRequest requestWithURL:authurl];
        [authRequest startSynchronous];
        NSError *error = [authRequest error];
        if (!error) {
            NSString *response = [authRequest responseString];
            NSLog(@"AuthRequest in ProfileFav: %@", response);
            
            // 
            NSString *path = NULL;
            
            if ( self.userid!=NULL )
                path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myfaves/%@", self.userid];
            else       
                path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myfaves/%@", (myItemModel!=NULL)?(myItemModel.friendUserID):appDelegate.userIDCode];
            
            NSLog(@"Constructed Login URL: %@", path);    
            [activityIndicator startAnimating];
            self.isNetworkOperation = YES;
            NSLog(@"request auth: %@", path);
            [networkQueue cancelAllOperations];
            [networkQueue waitUntilAllOperationsAreFinished];
            [networkQueue setSuspended:YES];
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
        else
            NSLog(@"AuthRequest in ProfileFav: %@", [error localizedDescription]);
        
        
        /*NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:path];
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
        [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString]; */
    }
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	[self.tableview reloadData];
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


-(void) viewDidAppear:(BOOL)animated
{
   /* if ( [self.item count]==0 )
    {
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myfaves/%@", (myItemModel!=NULL)?(myItemModel.friendUserID):appDelegate.userIDCode];
    
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
    
    }*/
    
}
- (BOOL)canShowAdvertising
{
	return YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
 	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Favorites";
    [tableview setDelegate:self];
	[tableview setDataSource:self];
	//[self.view addSubview:tableview];
    tableview.rowHeight = kFeaturedRowHeight;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    if ( item )
        [item release];
    
    item = [[NSMutableArray alloc] init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//NSLog(@"self.item count: %d", [self.item count]);
    return [self.itemStorage.storageList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ProfileFavoritesCell";
	ProfileFavoritesCell *cell = (ProfileFavoritesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell)
	{
		cell = [[[ProfileFavoritesCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                            reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
    ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];
	cell.itemModel = aModel;
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    SelectAfameSpot *selctdViewController = [ [SelectAfameSpot alloc] initWithNibName:@"SelectAfameSpot" bundle:nil];
    //    [[self navigationController] pushViewController:selctdViewController animated:YES];
    //    [selctdViewController release];
    
	
}
#pragma mark -
#pragma mark XMLParser
#pragma mark -
/*
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
     if ([elementName isEqualToString:@"favorites"])
     {
         [self.itemStorage cleanStorage];
     }     
     else if ([elementName isEqualToString:@"fav"])
     {
         self.item = [NSMutableDictionary dictionary];
     }
 }
 
 - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
 {
     if ([elementName isEqualToString:@"fav"])
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
     NSLog(trimmString);
     NSLog(@"self.currentElement: %@", self.currentElement);
     
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

 - (void)reloadIndex:(NSNumber *)indexNumber
 {
 NSIndexPath *itemPath = [NSIndexPath indexPathForRow:[indexNumber integerValue] inSection:0];
 NSArray *reloadArray = [NSArray arrayWithObject:itemPath];
 [tableview reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
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
 
 - (void)didStopLoadData
 {
 YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
 [appDelegate didStopNetworking];
 isNetworkOperation = NO;
 [activityIndicator stopAnimating];
 [tableview reloadData];
 }
 */

- (void)parseXMLFilewithData:(NSData *)data
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
	//if ([elementName isEqualToString:@"featured"])
    if ([elementName isEqualToString:@"favorites"])
	{
		[self.itemStorage cleanStorage];
	}
	
    else if ([elementName isEqualToString:@"fav"])
	{
         self.item = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//if ([elementName isEqualToString:@"item"])
    if ([elementName isEqualToString:@"fav"])
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

- (void)didStopLoadData
{
	self.isNetworkOperation = NO;
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	[tableview reloadData];
}

- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	[self.tableview reloadData];
}

- (void)reloadIndex:(NSNumber *)indexNumber
{
	NSIndexPath *itemPath = [NSIndexPath indexPathForRow:[indexNumber integerValue] inSection:0];
	NSArray *reloadArray = [NSArray arrayWithObject:itemPath];
	[tableview reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
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
            for (ProfileFavoritesCell *cell in visibleCells)
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
