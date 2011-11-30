//
//  ProfileTickerShouts.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileTickerShouts.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ProfileTickerShoutsCell.h"
#import "ItemStorage.h"
#import "ItemModel.h"
#import "Constants.h"
#import "ProfileFriendView.h"

@implementation ProfileTickerShouts

@synthesize creditLbl;
@synthesize rssParser;
@synthesize sendResult;
@synthesize currentElement;
@synthesize isNetworkOperation;
@synthesize activityIndicator;
@synthesize tableview;
@synthesize item;
@synthesize tickerShouts;
@synthesize profileName;
@synthesize profileImage;
@synthesize myOwnCalled;
@synthesize networkQueue;
@synthesize dateArr;
@synthesize timeArr;
@synthesize userid;

- (id)setupTickerib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(BOOL) myOwn :(NSString *) userID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dateArr = nil;
        timeArr = nil;
        self.userid = NULL;
        
        myOwnCalled = myOwn;
        if ( aModel!=NULL )
            myItemModel = aModel;
        else
            myItemModel = nil;
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
    [creditLbl release];
    [activityIndicator release];
    /*if (networkQueue) {
       [networkQueue release];
    }*/
   self.rssParser= nil;
    self.currentElement = nil;
    self.sendResult = nil;
    if (item)
        [item release];
    //item = nil;
    [tickerShouts release];
    [profileName release];
    [profileImage release];
    
    for (ASIHTTPRequest *req in [networkQueue operations])
    {
        [req setDelegate:nil];
        [req cancel];
    }
    [networkQueue setDelegate:nil];
    
    if ( dateArr )
        [dateArr release];
    if ( timeArr )
        [timeArr release];
    
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My Social Shouts";
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    //[appDelegate authenticateAtLaunchIfNeedBe];
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
    
    
    item = nil;
    item = [[NSMutableArray alloc] init];
    
    timeArr = nil;
    timeArr = [[NSMutableArray alloc] init];
    
    dateArr = nil;
    dateArr = [[NSMutableArray alloc] init];
    
    reloadTImer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(reloadScreen:) userInfo:nil repeats:NO];
    [activityIndicator startAnimating];
    
    //[appDelegate authenticateAtLaunchIfNeedBe];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSLog(@"appDelegate.userName: %@", appDelegate.userName);
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
    
    
    [tableview setDelegate:self];
	[tableview setDataSource:self];
    
    
    
    // Do any additional setup after loading the view from its nib.
    
    
    //creditLbl.text= [appDelegate.creditStr stringByAppendingString:@"  Credits"];
    
}

- (void)reloadPage
{
//    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.selectedController = self;
//	[appDelegate startAdvertisingBar];
}

-(void) reloadScreen:(NSTimer*)timer
{
    if ( [self.item count]==0 )
    {
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSString *authpath = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [appDelegate readUserName], [appDelegate readLoginPassword]];
        NSLog(@"AuthRequest URL in Profileshouts: %@", authpath);
        NSURL *authurl = [NSURL URLWithString:authpath];
        ASIHTTPRequest *authRequest = [ASIHTTPRequest requestWithURL:authurl];
        [authRequest startSynchronous];
        NSError *error = [authRequest error];
        if (!error) {
            NSString *response = [authRequest responseString];
            NSLog(@"AuthRequest in Profileshouts: %@", response);
            
            NSString *path = NULL;
            
            
            if ( self.userid!=NULL )
                path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myshouts/%@", self.userid];
            else       
                path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myshouts/%@",(myItemModel!=NULL)?(myItemModel.friendUserID):appDelegate.userIDCode];
            
            NSLog(@"Constructed Login URL: %@", path);
            self.isNetworkOperation = YES;
            [activityIndicator startAnimating];
            self.isNetworkOperation = YES;
            
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
            NSLog(@"AuthRequest in Profile: %@", [error localizedDescription]);
        
        
        
        
        
    }
    
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

#pragma mark - TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"self.item count: %d", [self.item count]);
    
    return [self.item count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"%d",indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell=[[UITableViewCell alloc]init];
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	//cell.shouldIndentWhileEditing = YES;
    //if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];    
    NSLog(@"objectAtIndex:indexPath.row: %d", indexPath.row);
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    tickerShouts = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 5.0, 320.0, 80.0)];
    [tickerShouts setBackgroundColor:[UIColor clearColor]];
    //[tickerShouts setFont:[UIFont systemFontOfSize:16.0]];
    tickerShouts.font = [UIFont boldSystemFontOfSize:17.0];
	//tickerShouts.textColor = [UIColor colorWithRed:0.15 green:0.29 blue:0.43 alpha:1.0];
    [tickerShouts setText:@""];
    if( [indexPath row] % 2 ) { 
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.07 green:0.18 blue:0.27 alpha:1]]; 
        tickerShouts.textColor = [UIColor whiteColor]; 
    }
    else 
        tickerShouts.textColor = [UIColor colorWithRed:0.15 green:0.29 blue:0.43 alpha:1.0];
    //NSString *tickerForRow = [item objectAtIndex:indexPath.row];
    //NSLog(@"Ticker for row: %@", tickerForRow);
    [tickerShouts setText: [item objectAtIndex:indexPath.row]];
    [tickerShouts setEditable:NO];
    [tickerShouts setScrollEnabled:YES];
    //[cell addSubview:usernameField];
    [cell.contentView addSubview:tickerShouts];
    
    [tickerShouts release]; 
    
UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 45.0, 100.0, 40.0)];
    [timeLbl setBackgroundColor:[UIColor clearColor]];
    timeLbl.font = [UIFont boldSystemFontOfSize:15.0];
    timeLbl.textColor = [UIColor lightGrayColor];
    [timeLbl setText:[timeArr objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:timeLbl];
    
UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 45.0, 100.0, 40.0)];
    [dateLbl setBackgroundColor:[UIColor clearColor]];
    dateLbl.font = [UIFont boldSystemFontOfSize:15.0];
    dateLbl.textColor = [UIColor lightGrayColor];
    [dateLbl setText:[dateArr objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:dateLbl];
    
UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(85.0f, 58.0f, 5.0f,17.0f)];
    separator.image = [UIImage imageNamed:@"separator.png"];
    separator.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:separator];
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    SelectAfameSpot *selctdViewController = [ [SelectAfameSpot alloc] initWithNibName:@"SelectAfameSpot" bundle:nil];
    //    [[self navigationController] pushViewController:selctdViewController animated:YES];
    //    [selctdViewController release];
    
	
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
    
    if ([elementName isEqualToString:@"shouts"])
    {
    }     
    else if ([elementName isEqualToString:@"shout"])
    {
        self.item = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
	if ([self.currentElement isEqualToString:@"text"] && [trimmString length]>0)
    {
        [self.item addObject:trimmString];
    }
    
}

- (void)reloadIndex:(NSNumber *)indexNumber
{
	NSIndexPath *itemPath = [NSIndexPath indexPathForRow:[indexNumber integerValue] inSection:0];
	NSArray *reloadArray = [NSArray arrayWithObject:itemPath];
	[tableview reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{	
	//[self.itemStorage downloadImages];
	[self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
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
} */


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
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    NSLog(@"Login: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
	if ([self.currentElement isEqualToString:@"shout"])
    {
       
    }
    else if ([self.currentElement isEqualToString:@"text"])
    {
        [item addObject:trimmString];
    }
    else if ([self.currentElement isEqualToString:@"time"])
    {
        [timeArr addObject:trimmString];
    }
    else if ([self.currentElement isEqualToString:@"date"])
    {
        [dateArr addObject:trimmString];
    }

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}


- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	[self.tableview reloadData];
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


@end
