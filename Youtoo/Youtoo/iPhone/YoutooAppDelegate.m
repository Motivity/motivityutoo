//
//  YoutooAppDelegate.m
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "YoutooAppDelegate.h"
#import "YoutooViewController.h"
#import "Schedule.h"
#import "Videos.h"
#import "BeOnTv.h"
#import "Profile.h"
#import "More.h"
#import "LogInScreen.h"
#import "RegisterScreen.h"
#import "RecordAfameSpot.h"
#import "WriteAtickerShout.h"
#import "WelcomeYoutoo.h"
#import "LineController.h"
#import "Constants.h"
#import "ProfileLineController.h"
#import "AdvertisingLineController.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"

@implementation YoutooAppDelegate


@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize schdlViewContr,videoViewContr, tvViewContr, ProfileViewContr, moreViewContr, logInViewContr, regstrViewContr; 
@synthesize tabBarController;
@synthesize pickerController;
@synthesize beOnClicked;
@synthesize userIsRegistered;
@synthesize  userIsSignedIn;
@synthesize loginName;
@synthesize passwordString;
@synthesize userIDCode;
@synthesize mTimerSelectionForVideo;
@synthesize currentVideoPath;
@synthesize bUploadHappening;
@synthesize bFbCheckEnabledByUser;
@synthesize selectedController;
@synthesize creditStr;
@synthesize bTwitterCheckEnabledByUser;
@synthesize bTwitterEnabled;
@synthesize bFacebookEnabled;
@synthesize showID;
@synthesize  selectedShow;
@synthesize epiQuestionID;
@synthesize getProfile;
@synthesize bEditUserTwitter;
@synthesize bEditUserFB;
@synthesize bEditUserYoutube;
@synthesize bEditUserYoutoo;
@synthesize userImage;
@synthesize userName;
@synthesize tweetIsChecked;  
@synthesize fbIsChecked; 
@synthesize googleIsChecke;
@synthesize mobileIsChecked;  
@synthesize webIsChecked; 
@synthesize tvIsChecke;
@synthesize youtubeIsChecked;
@synthesize episodeName;
@synthesize albumSelectedImg;
@synthesize toolBar;
@synthesize youtooIsChecked;
@synthesize earnCredit;
@synthesize videoURL;
@synthesize rssParser;
@synthesize currentElement;
@synthesize tickerUserID;
@synthesize tickerProfUsername;
@synthesize tickerProfUserImage;
@synthesize tickerProfUserPoints;
@synthesize titleString;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    userIsSignedIn = NO;
    [self LoginOrLaunchInitialScreen:TRUE];
    mTimerSelectionForVideo=0;
    currentVideoPath = nil; 
    networkingCount = 0;
    bUploadHappening = NO;
    bFbCheckEnabledByUser = NO;
    bFacebookEnabled = NO;
    bTwitterEnabled = NO;
    bTwitterCheckEnabledByUser = NO;
    self.userIDCode = [self readUserID];
    showID = NULL;
    epiQuestionID = NULL;
    
    bEditUserTwitter=NO;
    bEditUserFB=NO;
    bEditUserYoutube=NO;
    bEditUserYoutoo=NO;
    userImage=nil;
    userName=nil;
    episodeName=nil;
    albumSelectedImg= nil;
    youtooIsChecked = NO;
    earnCredit = nil;
    videoURL = NULL;
    getProfile = 0;
    tickerUserID = nil;
    tickerProfUsername = NULL;
    tickerProfUserImage = NULL;
    tickerProfUserPoints = NULL;
    titleString = NULL;
    
    [self.window makeKeyAndVisible];
    
    selectedShow = 0;

    return YES;
}
-(void)act
{
    
     [self setupTabController];
    
}
-(void) LoginOrLaunchInitialScreen:(BOOL )fromAppDidLaunch
{
    /*NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage]; 
    //NSHTTPCookieAcceptPolicy currentPolicy = [sharedHTTPCookieStorage cookieAcceptPolicy];
    [sharedHTTPCookieStorage setCookieAcceptPolicy: NSHTTPCookieAcceptPolicyAlways];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"cookie count: %i", [cookies count]);
    if ( [cookies count]==0 )
    {
        [self reportError:@"Youtoo" description:@"Cookie is empty now!"];
    }
    else
        [self reportError:@"Youtoo" description:@"Cookie is THERE!"];
    */
    
    // Override point for customization after application launch.
    if ( ( [self readUserName]!=NULL && ([[self readUserName] length]>0) ) &&
        ( [self readLoginPassword]!=NULL && ([[self readLoginPassword] length]>0) )
        )
    {        
        [self authenticateAtLaunchIfNeedBe];
        
      if( fromAppDidLaunch )
      {
          getProfile = 1;
          NSLog(@"LoginOrLaunchInitialScreen - get profile and luanch be on tv");
          
        /*WelcomeYoutoo *welcomeContr = [[WelcomeYoutoo alloc] initWithNibName:@"WelcomeYoutoo" bundle:[NSBundle mainBundle]];
         UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:welcomeContr];
         [self.window addSubview:navg.view];*/
          
          YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
          [appDelegate setupTabController];
        
      }
    }
    else
    {    
        LogInScreen *loginViewContr = [[[LogInScreen alloc] initWithNibName:@"LogInScreen" bundle:[NSBundle mainBundle]] autorelease];
        UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:loginViewContr];
        [self.window addSubview:navg.view];
    }
}

-(void)getUserProfile
{
    NSLog(@"getUserProfile called");
    
    getProfile = 2;
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/"];
    
    NSLog(@"Constructed Login URL: %@", path);
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

- (void)setupTabController
{	
	localControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    {
        
        Schedule *aController = [[Schedule alloc] init];
		UINavigationController *navigationController = [[UINavigationController alloc] 
                                                        initWithRootViewController:aController];
		self.schdlViewContr = aController;
        
		[aController release];
		
		navigationController.navigationBar.tintColor = [UIColor blackColor];
		navigationController.tabBarItem.image = [UIImage imageNamed:@"schedule-icon30.png"];
		navigationController.tabBarItem.title = @"Schedule";
		
		[localControllersArray addObject:navigationController];
        [tvViewContr dismissModalViewControllerAnimated:YES];
		[navigationController release];
    }
    
    {
		Videos *aController = [[Videos alloc] init];
        
		UINavigationController *navigationController = [[UINavigationController alloc] 
                                                        initWithRootViewController:aController];
		
		self.videoViewContr = aController;
		[aController release];
		
		navigationController.navigationBar.tintColor = [UIColor blackColor];
		navigationController.tabBarItem.image = [UIImage imageNamed:@"videos-icon.png"];
		navigationController.tabBarItem.title = @"Videos";
		
		[localControllersArray addObject:navigationController];
        [tvViewContr dismissModalViewControllerAnimated:YES];
		[navigationController release];
	}
    {
        BeOnTv *aController = [[BeOnTv alloc] init];
        
		UINavigationController *navigationController = [[UINavigationController alloc] 
                                                        initWithRootViewController:aController];
		
		self.tvViewContr = aController;
		[aController release];
		
		navigationController.navigationBar.tintColor = [UIColor blackColor];
		navigationController.tabBarItem.image = [UIImage imageNamed:@"be-on-tv-transparent.png"];
		navigationController.tabBarItem.title = @"BeOnTv";
		
		[localControllersArray addObject:navigationController];
		[navigationController release];
        
        
	}
    
	{
		Profile *aController = [[Profile alloc] init];
        
		UINavigationController *navigationController = [[UINavigationController alloc] 
                                                        initWithRootViewController:aController];
		
		self.ProfileViewContr = aController;
		[aController release];
		
		navigationController.navigationBar.tintColor = [UIColor blackColor];
        navigationController.tabBarItem.image = [UIImage imageNamed:@"profile-icon.png"];
		navigationController.tabBarItem.title = @"Profile";
		
		[localControllersArray addObject:navigationController];
        [tvViewContr dismissModalViewControllerAnimated:YES];
		[navigationController release];
	}
	{
        More *aController = [[More alloc] init];
        
		UINavigationController *navigationController = [[UINavigationController alloc] 
                                                        initWithRootViewController:aController];
		
		self.moreViewContr = aController;
		[aController release];
		
		navigationController.navigationBar.tintColor = [UIColor blackColor];
		navigationController.tabBarItem.image = [UIImage imageNamed:@"more-icon.png"];
		navigationController.tabBarItem.title = @"More";
		
		[localControllersArray addObject:navigationController];
        [tvViewContr dismissModalViewControllerAnimated:YES];
		[navigationController release];
        
        
    }    
    
	UITabBarController *aController = [[UITabBarController alloc] init];
    aController.viewControllers = localControllersArray;
	aController.delegate = self;
	self.tabBarController = aController;
    [self.window addSubview:self.tabBarController.view];    
    [aController setSelectedIndex:2];
    
    /*UIImageView* beOnTvImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"be-on-tv-transparent.png"]];
    [aController setSelectedIndex:2]; 
    [beOnTvImg setFrame:CGRectMake(120, 410, 80, 70)]; 
    [tabBarController.view addSubview:beOnTvImg];    
	[aController release];	
    */
    
    /*UIImageView *scheduleBtnImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule.png"] highlightedImage:[UIImage imageNamed:@"schedule_highlighted.png"]]; 
    scheduleBtnImg.highlighted = NO;
    scheduleBtnImg.tag = 1;
    scheduleBtnImg.userInteractionEnabled = YES;
    [scheduleBtnImg setFrame:CGRectMake(0, 425, 63, 62)]; 
    [tabBarController.view addSubview:scheduleBtnImg];
    */
    
    UIButton *beOnTvImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [beOnTvImgBtn setFrame:CGRectMake(120, 410, 80, 70)];
    [beOnTvImgBtn setBackgroundImage:[UIImage imageNamed:@"be-on-tv-transparent.png"] forState:UIControlStateNormal];
    [beOnTvImgBtn setImage:[UIImage imageNamed:@"BeOnTV_b-icon-blue.png"] forState:UIControlStateHighlighted];
    [beOnTvImgBtn addTarget:self action:@selector(beOnTvBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarController.view addSubview:beOnTvImgBtn];
    
	[localControllersArray release];
	//[beOnTvImg release];
    
	self.tabBarController.moreNavigationController.navigationBar.tintColor = [UIColor blackColor];		
}

-(void) beOnTvBtnAct:(id)sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate setupTabController];
}

-(void) scheduleBtnAct:(id)sender
{
    [tabBarController setSelectedIndex:0];
}

-(void) videoBtnAct:(id)sender
{
    [tabBarController setSelectedIndex:1];
}

-(void) profileBtnAct:(id)sender
{
    [tabBarController setSelectedIndex:3];
}

-(void) moreBtnAct:(id)sender
{
    [tabBarController setSelectedIndex:4];
}


- (void)reportError:(NSString *)aTitle description:(NSString *)aDescription
{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:aTitle 
													 message:aDescription 
													delegate:self 
										   cancelButtonTitle:nil 
										   otherButtonTitles:nil] autorelease];
	[alert addButtonWithTitle:NSLocalizedString(@"OK", @"Button Title")];
	alert.tag = 1234;
	[alert show];
}
- (void)removeLoginDataPlistItems
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"LoginData.plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];        
    }    
}

-(void) SaveLoginData
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    
    // get paths from root direcory
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"LoginData.plist"];
	
	// create dictionary with values in UITextFields
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: self.loginName, self.passwordString, appDelegate.userIDCode, nil] forKeys:[NSArray arrayWithObjects: @"Name", @"Password", @"UserID", nil]];
	
	NSString *error = nil;
	// create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	//NSLog(plistData);
    // check is plistData exists
	if(plistData) 
	{
		// write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else 
	{
        NSLog(@"Error in saveData: %@", error);
        [error release];
    }
}


-(NSString *) readUserName 
{
    NSString *outUsername=NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"LoginData.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"LoginData" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp) 
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    outUsername = [temp objectForKey:@"Name"];
    
    //NSLog(outUsername);
    
    return outUsername;
}
-(NSString *) readLoginPassword
{
    NSString *outPassword=NULL;
    // Data.plist code
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"LoginData.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"LoginData" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp) 
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    //userName= [temp objectForKey:@"Name"];
    outPassword=[temp objectForKey:@"Password"];
    
    //NSLog(outPassword);
    
    return outPassword;
}

-(NSString *) readUserID
{
    NSString *outUserID=NULL;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"LoginData.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"LoginData" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp) 
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    outUserID = [temp objectForKey:@"UserID"];
    
    //NSLog(outUsername);
    
    return outUserID;
}

/*-(void) authenticateAtLaunchIfNeedBe
{
    //networkQueue = [[ASINetworkQueue alloc] init];
    
    NSLog(@"LogIn again!!! self.loginName:%@ ; [self readUserName]: %@ ; [self readLoginPassword]: %@ ", self.loginName, [self readUserName], [self readLoginPassword]);
    
 
    //if ( (self.loginName==NULL || [self.loginName length]<=0 ) && [self readUserName]!=NULL && [self readLoginPassword]!=NULL )
    {
          
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [self readUserName], [self readLoginPassword]];
    
		NSLog(@"request auth: %@", path);
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
}
*/
-(void) authenticateAtLaunchIfNeedBe
{
    networkQueue = [[ASINetworkQueue alloc] init];
    
    NSLog(@"LogIn again!!! self.loginName:%@ ; [self readUserName]: %@ ; [self readLoginPassword]: %@ ", self.loginName, [self readUserName], [self readLoginPassword]);
    
    
    //if ( (self.loginName==NULL || [self.loginName length]<=0 ) && [self readUserName]!=NULL && [self readLoginPassword]!=NULL )
    {
        
        /*NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [self readUserName], [self readLoginPassword]];
        
        [networkQueue cancelAllOperations];
        [networkQueue setDelegate:self];
        ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
                                        [NSURL URLWithString:path]] autorelease];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        //[request setTimeOutSeconds:20];
        [networkQueue addOperation:request];
        [networkQueue go];
        */
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [self readUserName], [self readLoginPassword]];
        
		NSLog(@"request auth: %@", path);
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
    
    NSLog(@"self.currentElement: %@", self.currentElement);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    NSLog(@"Login: trimmString: %@", trimmString);
    
    
	if ([self.currentElement isEqualToString:@"auth"] && [trimmString length] > 0)
	{
		NSLog(@"Logged-in freshly from Appdelagate");
	}
    
	if ( [self.currentElement isEqualToString:@"name"] && [trimmString length] > 0 )
    {
        appDelegate.userName = trimmString;
        NSLog(@"Welcome: appDelegate.userName: %@", appDelegate.userName);
    }
    else
    {
        if ( [self.currentElement isEqualToString:@"username"] && [trimmString length] > 0 )
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
    [self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
}

- (void)showAlertNoConnection:(NSError *)anError
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	//[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
	//			 description:@"Internet connection is must to run this product (or) Server error."];
}

- (void)didStopLoadData
{
    NSLog(@"didStopLoadData called");
    
    if ( getProfile == 1 )
    {
        NSLog(@"AppDelegate auth is done and then get profile info");
        [self getUserProfile];
    }
    if ( getProfile == 2 )
    {
        NSLog(@"AppDelegate didStopLoadData after getting profile info.");
        
        getProfile = 0;
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate setupTabController];
    }
}

#pragma mark -
#pragma mark end ASIHTTPRequest Request
#pragma mark -

- (void)requestDone:(ASIHTTPRequest *)request
{    
    [networkQueue setDelegate:nil];
	[request setDelegate:nil];
	
	NSData *responseData = [request responseData];
	NSLog(@"LogIn Freshly..: %@", [request responseString]);
	
   
}

- (void)postDone:(ASIHTTPRequest *)request
{
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    
}


#pragma mark -

- (void)didStartNetworking
{
    networkingCount ++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didStopNetworking
{
	if (networkingCount > 0)
	{
		networkingCount --;
	}
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (networkingCount > 0);
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self LoginOrLaunchInitialScreen:FALSE];
    
    self.userIDCode = [self readUserID];
}

- (NSString*)encodeURL:(NSString *)string
{
	NSString *newString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("?#[]@!$ &'()*+,;=\"<>%{}|^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
	if (newString) {
		return newString;
	}
	return @"";
}

- (BOOL) connectedToNetwork :(NSString*) inURL
{
    //return ([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]]!=NULL)?YES:NO;
    return ([NSString stringWithContentsOfURL:[NSURL URLWithString:inURL]]!=NULL)?YES:NO;
}

#pragma mark Adverstisement Ticker
- (BOOL)isShownAdvertising
{
	return [[LineController sharedLineController] isShownAdvertising];
}

- (BOOL)canShowAdvertising
{
	return (nil != self.selectedController && 
            [self.selectedController conformsToProtocol:@protocol(CSMAdvertisingProtocol)] && 
			[self.selectedController canShowAdvertising]);
}

- (void)startAdvertisingBar
{
	//LineController *lineController = [LineController sharedLineController];
	if ([self canShowAdvertising])
	{
		//if (![lineController isShownAdvertising])
		{
			[[LineController sharedLineController] startAdvertising];
            
            [[LineController sharedLineController] selectedController:self.selectedController];
		}
	}
}

- (void)stopAdvertisingBar
{
	LineController *lineController = [LineController sharedLineController];
	if ([lineController isShownAdvertising])
	{
		[lineController stopAdvertising];
		[self hideAdvancedLine:lineController.profileLineController.view];
		[self hideAdvancedLine:lineController.advertisingLineController.view];
	}
}
- (void)changeAdvancedLine:(UIView *)prevLine toLine:(UIView *)newLine
{
	if (nil != self.selectedController && [self.selectedController respondsToSelector:@selector(advertisingWillHide)])
	{
		[self.selectedController performSelector:@selector(advertisingWillHide)];
	}
	if (nil != self.selectedController && [self.selectedController respondsToSelector:@selector(reloadPage)])
	{
		[self.selectedController performSelector:@selector(reloadPage)];
	}
	CGRect rect = prevLine.frame;
    [UIView beginAnimations:nil context:prevLine];
    [UIView setAnimationDuration:kDurationMovingViewInterval];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(changingAnimationDidStop:finished:context:)];
	rect.origin.y = 0.0;
	prevLine.frame = rect;
    [UIView commitAnimations]; 
}

- (void)showAdvancedLine:(UIView *)advLine
{
	if (nil == advLine.superview)
	{
		[self.window addSubview:advLine];
		
		CGRect windowRect = self.window.frame;
		advLine.frame = CGRectMake(0.0, 0, 
                                   windowRect.size.width, kAdvBarHeight);
		[UIView beginAnimations:nil context:advLine];
		[UIView setAnimationDuration:kDurationMovingViewInterval];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(showingAnimationDidStop:finished:context:)];
		CGRect advRect;
//        if ( self.selectedController==self.tvViewContr)
         //   advRect = CGRectMake(0.0, 0.0, windowRect.size.width, kAdvBarHeight);
//        else    
            //advRect = CGRectMake(0.0, kStatusBarHeight+kNavigationBarHeight, windowRect.size.width, kAdvBarHeight);
        advRect = CGRectMake(0.0, 0.0, windowRect.size.width, kAdvBarHeight);

		advLine.frame = advRect;
		[UIView commitAnimations];
	}
}


- (void)changingAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	UIView *removedView = (UIView *)context;
	[removedView removeFromSuperview];
	
	LineController *lineController = [LineController sharedLineController];
	if (lineController.isProfileAdvertising)
	{
		[self showAdvancedLine:lineController.profileLineController.view];
	}
	else
	{
		[self showAdvancedLine:lineController.advertisingLineController.view];
	}
}
- (void)showingAnimationDidStop:(NSString *)animationID 
					   finished:(NSNumber *)finished context:(void *)context
{	
	if (nil != self.selectedController && 
		[self.selectedController respondsToSelector:@selector(advertisingDidShow)])
	{
		[self.selectedController performSelector:@selector(advertisingDidShow)];
	}
	
	if (nil != self.selectedController && [self.selectedController respondsToSelector:@selector(reloadPage)])
	{
		[self.selectedController performSelector:@selector(reloadPage)];
	}
}

/*- (void)hideFloatingBar
{
	if (nil != self.floatingBar && nil != self.floatingBar.view.superview)
	{
		CGRect rect = self.window.bounds;
		self.floatingBar.view.frame = CGRectMake(0.0, rect.size.height, rect.size.width, kFloatingPanelHeight);
	}
}

- (void)showFloatingBar
{	
	if (nil == self.floatingBar.view.superview)
	{
		[self.window addSubview:self.floatingBar.view];
	}
	CGRect rect = self.window.bounds;
	self.floatingBar.view.frame = CGRectMake(0.0, rect.size.height - kFloatingPanelHeight,
                                             rect.size.width, kFloatingPanelHeight);
}*/
- (void)hideAdvancedLine:(UIView *)advLine
{
	if (nil != self.selectedController && 
		[self.selectedController respondsToSelector:@selector(advertisingWillHide)])
	{
		[self.selectedController performSelector:@selector(advertisingWillHide)];
	}
	
	if (nil != self.selectedController && [self.selectedController respondsToSelector:@selector(reloadPage)])
	{
		[self.selectedController performSelector:@selector(reloadPage)];
	}
	
	if (nil != advLine.superview)
	{		
		CGRect rect = advLine.frame;
		[UIView beginAnimations:nil context:advLine];
		[UIView setAnimationDuration:kDurationMovingViewInterval];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hiddingAnimationDidStop:finished:context:)];
		rect.origin.y = 0.0;
		advLine.frame = rect;
		[UIView commitAnimations];
	}
}
- (void)hiddingAnimationDidStop:(NSString *)animationID 
                       finished:(NSNumber *)finished context:(void *)context
{
	UIView *removedView = (UIView *)context;
	[removedView removeFromSuperview];
}
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [logInViewContr release];
    [creditStr release];
    [userIDCode release];
    [epiQuestionID release];
    /*if (networkQueue) {
        [networkQueue release];
    }*/
    self.rssParser= nil;
    self.currentElement = nil;
    titleString = nil;
    
    [super dealloc];
}

@end
