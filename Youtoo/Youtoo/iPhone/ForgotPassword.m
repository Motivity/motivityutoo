//
//  ForgotPassword.m
//  Youtoo
//
//  Created by PRABAKAR MP on 15/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ForgotPassword.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "LogInScreen.h"
#define kOFFSET_FOR_KEYBOARD					160.0
#define MAX_LENGTH  300.0
@implementation ForgotPassword

@synthesize  emailFld;
@synthesize  newPasswordFld;
@synthesize  confrmPasswordFld;
@synthesize  changePasswdBtn;
@synthesize  isNetworkOperation;
@synthesize activityIndicator;
@synthesize sendResult;
@synthesize currentElement;
@synthesize rssParser;
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.title = @"Forgot Password?";
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];  

    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	//[appDeleagte stopAdvertisingBar];
    [appDeleagte startAdvertisingBar];
    
    emailFld.delegate = self;
    newPasswordFld.delegate = self;
    confrmPasswordFld.delegate = self;
    newPasswordFld.secureTextEntry = YES;
    confrmPasswordFld.secureTextEntry = YES;
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)canShowAdvertising
{
	return YES;
}
-(void) reloadPage
{
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	//[appDeleagte stopAdvertisingBar];
    [appDeleagte startAdvertisingBar];
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (theTextField == emailFld || theTextField == newPasswordFld || theTextField == confrmPasswordFld )
    {
        if ( bAlreadyMovedUp )
			[self setViewMovedUp:NO];
        
		[emailFld resignFirstResponder];
		[newPasswordFld resignFirstResponder];
        [confrmPasswordFld resignFirstResponder];
        
		
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
	[appDelegate stopAdvertisingBar];
    
    // watch the keyboard so we can adjust the user interface if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self setEditing:NO animated:YES];
	
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}


-(IBAction)conformPasswordAct:(id)sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // username, email, passowrd cofirm passowrd, zip code.
    email = NULL;
    newPassword = NULL;
    confirmPassword = NULL;
    email = emailFld.text;
    newPassword =  newPasswordFld.text;
    confirmPassword = confrmPasswordFld.text ;
   
    NSLog(@"Email: %@; Password: %@;ConformPassword:%@", email, newPassword, confirmPassword); 
    
    
    if ( (email!=NULL && [email length]>0 ) )// && (newPassword!=NULL && [newPassword length]>0 ) && (confirmPassword!=NULL && [confirmPassword length]>0 )  )
    {
               
       
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/forgotpw/%@", email ];
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
        [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:@"Email field is empty, make sure you entered your email!"]; 
    }

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
    else if ([self.currentElement isEqualToString:@"result"] && [trimmString length] > 0)
	{
		self.sendResult = string;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if ([self.sendResult length] > 0)
	{
		[appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Text") description:self.sendResult];
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
        LogInScreen *logInContr = [[LogInScreen alloc] initWithNibName:@"LogInScreen" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:logInContr  animated:YES];
        
        [logInContr release];
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
