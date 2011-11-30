//
//  ProfileFameSpot.m
//  Youtoo
//
//  Created by PRABAKAR MP on 25/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileFameSpot.h"
#import "ProfileFameSpotCell.h"
#import "ItemModel.h"
#import "ItemStorage.h"
#import "Constants.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ProfileFriendView.h"
static const CGFloat kFeaturedRowHeight = 80.0;
@implementation ProfileFameSpot

@synthesize tableview;
@synthesize rssParser;
@synthesize item;
@synthesize currentElement;
@synthesize isNetworkOperation;
@synthesize activityIndicator;
@synthesize sendResult;
@synthesize imageArray;
@synthesize videoURL;
@synthesize btnTag;
@synthesize profileImage;
@synthesize profileName;
@synthesize creditLbl;
@synthesize myOwnCalled;
@synthesize itemStorage;
@synthesize userid;

- (id)setupFSNib:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel :(BOOL) myOwn :(NSString *) userID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myOwnCalled = myOwn;
        self.userid = NULL;
        self.isNetworkOperation = NO;
        if ( aModel!=NULL )
            myItemModel = aModel;
        else
            myItemModel = nil;
        self.sendResult = @"";
        //networkQueue = [[ASINetworkQueue alloc] init];
        btnTag = 0;
         itemStorage = [[ItemStorage alloc] init];
        videoURL = [[NSMutableArray alloc] init];
        
        if ( userID!= NULL )
            self.userid = userID;
    }
    return self;
}

- (void)dealloc
{
  //  self.item = nil;
	self.currentElement = nil;
	self.rssParser= nil;
    [activityIndicator release];
    /*if (networkQueue) {
        [networkQueue release];
    }*/
    [videoURL release];
    if (item)
        [item release];
    
    [playerController release];
    playerController=nil;
    [itemStorage release];
    
    [super dealloc];
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
 /*   NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDate *pageLastUpdate = [defaults objectForKey:@"ProfileFameSpotUpdate"];
	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	if (!isNetworkOperation && ([self.item count] == 0 ||elapsedTime < - definedTimeInterval))
	{	
        
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myfamespots/%@", (myItemModel!=NULL)?(myItemModel.friendUserID):appDelegate.userIDCode];
    NSLog(@"Constructed Login URL: %@", path);    
    [activityIndicator startAnimating];
    self.isNetworkOperation = YES;
    NSLog(@"request auth: %@", path);
    [networkQueue cancelAllOperations];
    
        [defaults setObject:[NSDate date] forKey:@"ProfileFameSpotUpdate"];
        
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
    //creditLbl.text= [appDelegate.creditStr stringByAppendingString:@"  Credits"];
    
    
    /*if ( [self.item count]==0 )
	{	
        
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myfamespots/%@", (myItemModel!=NULL)?(myItemModel.friendUserID):appDelegate.userIDCode];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(homeControlSelector:) name:kBrowserNotification object:nil];
	[self.tableview reloadData];
    
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
   
    self.title = @"Fame Spots";
    [tableview setDelegate:self];
	[tableview setDataSource:self];
	//[self.view addSubview:tableview];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;

    tableview.rowHeight = kFeaturedRowHeight;
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

    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    if ( item )
        [item release];
    
    item = [[NSMutableArray alloc] init];
    
    reloadTImer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(reloadScreen:) userInfo:nil repeats:NO];
    [activityIndicator startAnimating];
 
    
    //[appDelegate authenticateAtLaunchIfNeedBe];

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
             NSLog(@"AuthRequest in ProfileFameS: %@", response);
             
             NSString *path = NULL;
             
             if ( self.userid!=NULL )
                 path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myfamespots/%@", self.userid];
             else       
                 path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/myfamespots/%@", (myItemModel!=NULL)?(myItemModel.friendUserID):appDelegate.userIDCode];
             NSLog(@"Constructed Login URL: %@", path);    
             NSString *featuredString;
             NSMutableString *tempURLStr = [[NSMutableString alloc] init];
             [tempURLStr appendFormat:path];
             //     NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/showHelp/aboutapp "];
             featuredString = [tempURLStr copy];
             NSLog(featuredString);
             [tempURLStr release];
             tempURLStr=nil;
             [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                                    withObject:featuredString];

         }
         else
             NSLog(@"AuthRequest in ProfileFameS: %@", [error localizedDescription]);
         
     
     }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//NSLog(@"self.item count: %d", [self.item count]);
   // return [self.item count];
     return [self.itemStorage.storageList count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"%d",indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell=[[UITableViewCell alloc]init];
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	//cell.shouldIndentWhileEditing = YES;
    //if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
      ItemModel *aModel = [self.itemStorage.storageList objectAtIndex:indexPath.row];

    NSLog(@"objectAtIndex:indexPath.row: %d", indexPath.row);
    
    //  Text
    
    videoTxtFld = [[UILabel alloc] initWithFrame:CGRectMake(133.0, 0.0, 200.0, 60.0)];
    [videoTxtFld setBackgroundColor:[UIColor clearColor]];
    //[videoTxtFld setFont:[UIFont systemFontOfSize:18.0]];
    videoTxtFld.font = [UIFont boldSystemFontOfSize:17.0];
    videoTxtFld.textColor = [UIColor colorWithRed:0.15 green:0.29 blue:0.43 alpha:1.0]; //colorWithRed:0.25 green:0.8 blue:1.0 alpha:1];
    [videoTxtFld setText:@""];
    videoTxtFld.numberOfLines = 2;
    
    [videoTxtFld setText:aModel.title];
    //friendTxtFld.tag = indexPath.row;
    //[videoTxtFld setEditable:NO];
    [cell.contentView addSubview:videoTxtFld];
    
    [videoTxtFld release]; 
    
    // Video Button

    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 100.0, 65.0)];	
	//[_playButton setTitle:NSLocalizedString(@"Watch Now", @"Button Title") forState:UIControlStateNormal];	
//	[_playButton setBackgroundImage:[UIImage imageNamed:@"watch-it-now.jpg"] forState:UIControlStateNormal];
    if (nil != aModel.storageImage)
	{
		[_playButton setBackgroundImage:aModel.storageImage forState:UIControlStateNormal];
	}
    else
       [_playButton setBackgroundImage:[UIImage imageNamed:@"watch-it-now.jpg"] forState:UIControlStateNormal];
    //[_playButton setBackgroundImage:aModel.storageImage forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(PlayVideo:) forControlEvents:UIControlEventTouchUpInside];
	//_playButton.backgroundColor = [UIColor blackColor];
	_playButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
    _playButton.enabled = YES;
   // btnTag = indexPath.row;
   _playButton.tag = indexPath.row;
    //[btnTag addObject:[NSNumber numberWithInt:indexPath.row]];

    NSLog(@"_playButton.tag: %d", _playButton.tag);
	[cell.contentView addSubview:_playButton];
    [_playButton release];
    
    UILabel *likeLbl = [[UILabel alloc] initWithFrame:CGRectMake(165.0, 34.0, 200.0, 60.0)];
    [likeLbl setBackgroundColor:[UIColor clearColor]];
    //[videoTxtFld setFont:[UIFont systemFontOfSize:18.0]];
    likeLbl.font = [UIFont boldSystemFontOfSize:18.0];
    likeLbl.textColor = [UIColor colorWithRed:0.08 green:0.19 blue:0.29 alpha:1]; 
    [likeLbl setText:aModel.likedCount];
    likeLbl.numberOfLines = 1;
    [cell.contentView addSubview:likeLbl];
    
    UIImageView *sepImg = [[UIImageView alloc] initWithFrame:CGRectMake(130.0, 44.0, 230.0, 6.0)];
	sepImg.image = [UIImage imageNamed:@"div.png"];
	sepImg.contentMode = UIViewContentModeScaleAspectFit;
	[cell.contentView addSubview:sepImg];
    
    UIImageView *likeImg = [[UIImageView alloc] initWithFrame:CGRectMake(130.0, 45.0, 30.0, 40.0)];
	likeImg.image = [UIImage imageNamed:@"38_profile_viewFS-heart.png"];
	likeImg.contentMode = UIViewContentModeScaleAspectFit;
	[cell.contentView addSubview:likeImg];
    
    UILabel *visitLbl = [[UILabel alloc] initWithFrame:CGRectMake(233.0, 34.0, 200.0, 60.0)];
    [visitLbl setBackgroundColor:[UIColor clearColor]];
    //[videoTxtFld setFont:[UIFont systemFontOfSize:18.0]];
    visitLbl.font = [UIFont boldSystemFontOfSize:18.0];
    visitLbl.textColor = [UIColor colorWithRed:0.08 green:0.19 blue:0.29 alpha:1]; //colorWithRed:0.25 green:0.8 blue:1.0 alpha:1];
    [visitLbl setText:aModel.followCount];
    visitLbl.numberOfLines = 1;
    [cell.contentView addSubview:visitLbl];
    
    UIImageView *eyeImg = [[UIImageView alloc] initWithFrame:CGRectMake(200.0, 45.0, 30.0, 40.0)];
	eyeImg.image = [UIImage imageNamed:@"38_profile_viewFS-eye.png"];
	eyeImg.contentMode = UIViewContentModeScaleAspectFit;
	[cell.contentView addSubview:eyeImg]; 

   // }
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
//    NSString *urlStr = [NSString stringWithFormat:[videoURL objectAtIndex:[indexPath row]]];
//    NSString *encodedURL = [appDeleagte encodeURL:urlStr];
//    NSLog(@"indexPath row: %d",[indexPath row]);
//    NSLog(@"encodedURL: %@",encodedURL);
//    //NSLog(@"Video URL: %@",self.videoURL); 
//	url = [NSURL fileURLWithPath:encodedURL];
//	videoPlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
//	[self.view addSubview:videoPlayer.view];
//	videoPlayer.view.frame = CGRectMake(0, 0, 320, 480);
//	[videoPlayer play];

    
	
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
    if ([elementName isEqualToString:@"famespots"])
	{
		[self.itemStorage cleanStorage];
	}
	//else if ([elementName isEqualToString:@"item"])
    else if ([elementName isEqualToString:@"famespot"])
	{
        self.item = [NSMutableDictionary dictionary];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//if ([elementName isEqualToString:@"item"])
    if ([elementName isEqualToString:@"famespot"])
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
    
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(reloadTable:) userInfo:nil repeats:NO];
}

- (void)reloadTable:(NSTimer*)timer
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

- (void)homeControlSelector:(NSNotification *)notification
{
    
        NSDictionary *dict = [notification userInfo];
        NSString *strKey = [dict objectForKey:@"1"];
        if ([strKey isEqualToString:kNotifyImagesDidLoad])
        {
            [self didStopLoadData];
        }
    
    
}


#pragma mark -
#pragma mark end ASIHTTPRequest Request
#pragma mark -

/*- (void)requestDone:(ASIHTTPRequest *)request
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
