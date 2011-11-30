//
//  LogInScreen.m
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "LogInScreen.h"
#import "RegisterScreen.h"
#import "YoutooAppDelegate.h"
#import "WelcomeYoutoo.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ForgotPassword.h"

#define kOFFSET_FOR_KEYBOARD					100.0
#define MAX_LENGTH  50.0

@interface LogInScreen (PrivateMethods)
- (void)stopEditingForm;
- (void)requestDone:(ASIHTTPRequest *)request;
- (void)requestWentWrong:(ASIHTTPRequest *)request;
@end
@implementation LogInScreen

@synthesize createBtn, userNameField, passwordField;
@synthesize facebookBtn, twitterBtn, enterYoutooBtn, forgotPasswrdBtn;
@synthesize delegateController;
@synthesize isNetworkOperation;
@synthesize currentElement;
@synthesize userIDCode;
@synthesize sendResult;
@synthesize rssParser;
@synthesize isPostOperation;
@synthesize activityIndicator;
@synthesize getProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isNetworkOperation = NO;
        self.sendResult = @"";
        //networkQueue = [[ASINetworkQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [activityIndicator release];
    //[networkQueue release];
    self.currentElement = nil;
    self.sendResult = nil;
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
    self.title = @"Sign In";
    self.navigationController.navigationBarHidden = YES;
    passwordField.delegate = self;
    userNameField.delegate = self;
    passwordField.secureTextEntry = YES;
    bAlreadyMovedUp = NO;
    bTxtViewEditing = NO;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];  
    
    self.navigationItem.hidesBackButton = YES;
    getProfile = 0;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= MAX_LENGTH && range.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Exceed maximum limit " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //return NO; // return NO to not change text
    }
    else
    {return YES;}
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	bTxtViewEditing = NO;
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == userNameField || theTextField == passwordField) {
        if ( bAlreadyMovedUp )
			[self setViewMovedUp:NO];
		[userNameField resignFirstResponder];
		[passwordField resignFirstResponder];
		
    }
    return YES;
}
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp && !bAlreadyMovedUp)
	{
        bAlreadyMovedUp = YES;
		// If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else 
	{
		{
			// If moving down, not only increase the origin but decrease the height.
			rect.origin.y += kOFFSET_FOR_KEYBOARD;
			rect.size.height -= kOFFSET_FOR_KEYBOARD;
			bAlreadyMovedUp=NO;
		}
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
- (void)keyboardWillShow:(NSNotification *)notif
{
    
	if ( !bTxtViewEditing )
	{
        [self setViewMovedUp:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
    
}

- (void)reloadPage
{
	
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self setEditing:NO animated:YES];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

- (BOOL)canShowAdvertising
{
	return YES;
}


-(IBAction)goToRegiater
{
     YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.regstrViewContr = [[RegisterScreen alloc] initWithNibName:@"RegisterScreen" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:appDelegate.regstrViewContr  animated:YES];
   
}


-(IBAction) forGotPasswrd
{
    ForgotPassword *forgotPasswdViewContr = [[ForgotPassword alloc] initWithNibName:@"ForgotPassword" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:forgotPasswdViewContr  animated:YES];
    [forgotPasswdViewContr release];
}
-(IBAction) enterYoutooAction
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate; 
    appDelegate.loginName = NULL; 
    appDelegate.passwordString = NULL; 
    appDelegate.loginName = userNameField.text; 
    appDelegate.passwordString = passwordField.text; 
    NSLog(@"Email: %@; Password: %@", appDelegate.loginName, appDelegate.passwordString); 
    if ( ( appDelegate.loginName==NULL || [appDelegate.loginName length]<=0 ) || ( appDelegate.passwordString==NULL || [appDelegate.passwordString length]<=0 ) ) 
    { 
        [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Email and password fields cannot be empty!"];
    }
    else
    { 
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", appDelegate.loginName, appDelegate.passwordString];
        NSLog(@"Constructed Login URL: %@", path);
        if ( ![appDelegate connectedToNetwork :@"http://www.youtoo.com/"] )
        {
            [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Connectivity error!"]; 
            return;           
        }
        [activityIndicator startAnimating];
        self.isNetworkOperation = YES;
		NSLog(@"request auth: %@", path);
		/*[networkQueue cancelAllOperations];
		[networkQueue setDelegate:self];
		ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
										[NSURL URLWithString:path]] autorelease];
		[request setDelegate:self];
		[request setDidFinishSelector:@selector(requestDone:)];
		[request setDidFailSelector:@selector(requestWentWrong:)];
		[request setTimeOutSeconds:20];
		[networkQueue addOperation:request];
		[networkQueue go];*/
        
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
- (void)updateView
{
    /*YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.userName = NULL;
    appDelegate.creditStr = NULL;
    if ( appDelegate.userIsSignedIn )
    {
        WelcomeYoutoo *welcomeContr = [[WelcomeYoutoo alloc] initWithNibName:@"WelcomeYoutoo" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:welcomeContr  animated:YES];
        
        [welcomeContr release];
    }*/
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setupTabController];

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
		YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		appDelegate.userIsSignedIn = ![string isEqualToString:@"NULL"];
		appDelegate.userIDCode = appDelegate.userIsSignedIn ?  string : nil;
        getProfile = 1;
	}
    else if ([self.currentElement isEqualToString:@"result"] && [trimmString length] > 0)
	{
		self.sendResult = string;
	}
    
    if ( [self.currentElement isEqualToString:@"name"]  && [trimmString length] > 0 )
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
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (nil == appDelegate.userIDCode)
	{
		[appDelegate reportError:NSLocalizedString(@"Your e-mail or password is incorrect", @"Alert Text") description:self.sendResult];        
	}	
	else if ([self.sendResult length] > 0)
	{
        [appDelegate reportError:NSLocalizedString(@"Sign In", @"Alert Text") description:self.sendResult];
	}	
	else
	{
		// save login name and password to permenant storage bcoz it is being successful.
        [appDelegate SaveLoginData];
	}
    
	[self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
}

- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	//[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
	//			 description:@"Internet connection is must to run this product (or) Server error."];
}

- (void)didStopLoadData
{
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate didStopNetworking];

    if ( getProfile == 1 )
    {
        [self getUserProfile];
    }
    if ( getProfile == 2 && nil != appDelegate.userIDCode )
    {
        getProfile = 0;
        [self updateView];
    }
    else
        getProfile = 0;
		
}

-(void)getUserProfile
{    
    getProfile = 2;
 
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
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
/*
#pragma mark -
#pragma mark XMLParser
#pragma mark -

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
    
	if ([self.currentElement isEqualToString:@"auth"] && [trimmString length] > 0)
	{
		YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		appDelegate.userIsSignedIn = ![string isEqualToString:@"NULL"];
		appDelegate.userIDCode = appDelegate.userIsSignedIn ?  string : nil;
	}
    else if ([self.currentElement isEqualToString:@"result"] && [trimmString length] > 0)
	{
		self.sendResult = string;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (nil == appDelegate.userIDCode)
	{
		[appDelegate reportError:NSLocalizedString(@"Your e-mail or password is incorrect", @"Alert Text") description:self.sendResult];        
	}	
	else if ([self.sendResult length] > 0)
	{
		[appDelegate reportError:NSLocalizedString(@"Sign In", @"Alert Text") description:self.sendResult];
	}	
	else
	{
		// save login name and password to permenant storage bcoz it is being successful.
        [appDelegate SaveLoginData];
	}
    
	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}

- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	[self updateView];
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
*/

- (void)showAlertErrorParsing
{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Registration Error", @"Alert Title")
													 message:NSLocalizedString(@"Please navigate to Broadcast ticker and try again.", @"Alert Description") 
													delegate:self 
										   cancelButtonTitle:nil 
										   otherButtonTitles:nil] autorelease];
	
	[alert addButtonWithTitle:NSLocalizedString(@"OK", @"Button Title")];
	alert.tag = 1234;
	[alert show];
}

#pragma mark -
#pragma mark Text Field delegate
#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self setEditing:YES animated:YES];
}
- (void)viewDidUnload
{
    self.activityIndicator = nil;
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
