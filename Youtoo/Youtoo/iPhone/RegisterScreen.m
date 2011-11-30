//
//  RegisterScreen.m
//  Youtoo
//
//  Created by PRABAKAR MP on 19/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "RegisterScreen.h"
#import "YoutooAppDelegate.h"
#import "WelcomeYoutoo.h"
#import "ASINetworkQueue.h"
#import "ASIS3Request.h"
#import "WelcomeYoutoo.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "LogInScreen.h"

#define kOFFSET_FOR_KEYBOARD					150.0
#define MAX_LENGTH  300.0

@implementation RegisterScreen
@synthesize activityIndicator;
@synthesize isNetworkOperation;
@synthesize sendResult;
@synthesize currentElement;
@synthesize rssParser;

@synthesize emailFld, useNameFld, passwrdFld, confrmPasswrdFld, zipCodeFld, acceptBtn, registrBtn;
@synthesize accptIsClicked;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isNetworkOperation = NO;
         self.sendResult = @"";
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [activityIndicator release];
    [networkQueue release];
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
    self.title = @"Register";
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	[appDeleagte startAdvertisingBar];
    
    emailFld.delegate = self;
    useNameFld.delegate = self;
    passwrdFld.delegate = self;
    confrmPasswrdFld.delegate = self;
    zipCodeFld.delegate = self;
    passwrdFld.secureTextEntry = YES;
    confrmPasswrdFld.secureTextEntry = YES;
    
    // Do any additional setup after loading the view from its nib.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
        
}
- (BOOL)canShowAdvertising
{
	return YES;
}
- (void)reloadPage
{
	
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
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
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	bTxtViewEditing = NO;
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == emailFld || theTextField == useNameFld || theTextField == passwrdFld || theTextField == confrmPasswrdFld || theTextField == zipCodeFld )
    {
        if ( bAlreadyMovedUp )
			[self setViewMovedUp:NO];
        
		[emailFld resignFirstResponder];
		[useNameFld resignFirstResponder];
        [passwrdFld resignFirstResponder];
        [confrmPasswrdFld resignFirstResponder];
        [zipCodeFld resignFirstResponder];
		
    }
    return NO;
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

-(IBAction)goToTabBar;
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setupTabController];

}
-(IBAction)registerAction
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[[UIApplication sharedApplication] delegate];

    // username, email, passowrd cofirm passowrd, zip code.
    username = useNameFld.text;
    password =  passwrdFld.text;
    confirmPassword = confrmPasswrdFld.text ;
    zipcodeStr = zipCodeFld.text;
    email = emailFld.text;
    NSLog(@"Email: %@; Password: %@;ConformPassword:%@;ZipCode:%@, Username:%@", email, password, confirmPassword, zipcodeStr, username ); 
    
   
   if ( (username!=NULL && [username length]>0 ) && (password!=NULL && [password length]>0 ) && (confirmPassword!=NULL && [confirmPassword length]>0 ) && (email!=NULL && [email length]>0 ) && (zipcodeStr!=NULL && [zipcodeStr length]>0 ) 
       ) 
   {
       if ( accptIsClicked==NO ) 
       { 
           [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Please Accept Terms and Conditions!"]; 
           return; 
       }
       
       if ( [password isEqualToString:confirmPassword]==0 ) 
       { 
           [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Password and Confirm Password doesn't match!"]; 
           return; 
       }
       
       NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/register/?email=%@&username=%@&password=%@&password2=%@&zipcode=%@", email, username, password, confirmPassword, zipcodeStr ];
       NSLog(@"Constructed Login URL: %@", path);

       if ( ![appDelegate connectedToNetwork :@"http://www.youtoo.com/"] )
       {
           [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Please make sure the internet connectivity working!"]; 
           return;           
       }

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
   }
   else 
   { 
       [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Some of the fields are empty, make sure you entered all the fields!"]; 
   }
    
}
-(IBAction)acceptAction
{
    if(accptIsClicked)
    {
        [acceptBtn setImage:[UIImage imageNamed:@"check-box.png"] forState:UIControlStateNormal];
        accptIsClicked = NO;
        
    }
    else
    {
    [acceptBtn setImage:[UIImage imageNamed:@"check-box-tick.png"] forState:UIControlStateNormal];
    accptIsClicked = YES;
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];*/
    
    // watch the keyboard so we can adjust the user interface if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
}
-(IBAction) backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self setEditing:NO animated:YES];
	
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
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
    
	if ([self.currentElement isEqualToString:@"userid"] && [trimmString length] > 0)
	{
		YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		appDelegate.userIsSignedIn = ![string isEqualToString:@"NULL"];
		appDelegate.userIDCode = appDelegate.userIsSignedIn ?  string : nil;
        
	}
    else if ([self.currentElement isEqualToString:@"error"] && [trimmString length] > 0)
	{
		self.sendResult = string;
	}
    else if ([self.currentElement isEqualToString:@"result"] && [trimmString length] > 0)
	{
		self.sendResult = string;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	
	/*if ([self.sendResult length] > 0)
	{
		[appDelegate reportError:NSLocalizedString(@"Registration", @"Alert Text") description:self.sendResult];
	}	
	else*/ if ( [self.sendResult length] > 0 && [self.sendResult isEqualToString:@"logged in"] )
	{
		[appDelegate reportError:NSLocalizedString(@"Registration", @"Alert Text") description:@"Registered successfully, login using your new account!"];
        
        /*YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate; 
        appDelegate.loginName = NULL; 
        appDelegate.passwordString = NULL; 
        appDelegate.loginName = useNameFld.text;
        appDelegate.passwordString = passwrdFld.text;
        
        [appDelegate SaveLoginData]; */
	}
    else
    {
        if ( [self.sendResult length] > 0 )
            [appDelegate reportError:NSLocalizedString(@"Registration", @"Alert Text") description:self.sendResult];
    }
    
	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}

- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	[self updateView];
}
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
- (void)updateView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    if ( appDelegate.userIsSignedIn )
    {
        /*WelcomeYoutoo *welcomeContr = [[WelcomeYoutoo alloc] initWithNibName:@"WelcomeYoutoo" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:welcomeContr  animated:YES];
        
        [welcomeContr release];*/
        LogInScreen *loginViewContr = [[[LogInScreen alloc] initWithNibName:@"LogInScreen" bundle:[NSBundle mainBundle]] autorelease];
        [self.navigationController pushViewController:loginViewContr  animated:YES];
        
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

@end
