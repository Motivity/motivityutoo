//
//  ProfileEdit.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileEdit.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASINetworkQueue.h"
#import "LogInScreen.h"
#import "ProfileFriendView.h"
#import "Profile.h"
@implementation ProfileEdit
@synthesize editZipFld;

@synthesize activityIndicator;
@synthesize nameFld;
@synthesize emailFld;
@synthesize bioFld;
@synthesize creditsLbl;
@synthesize selectedImage;
@synthesize avatarImg;

@synthesize facebook;
@synthesize twitter;
@synthesize youtube;
@synthesize youtoo;
@synthesize logout;
@synthesize profileImage;
@synthesize profileName;
@synthesize imageData;
@synthesize isNetworkOperation;
@synthesize sendResult;
@synthesize rssParser;
@synthesize currentElement;
@synthesize networkQueue;
@synthesize name;
@synthesize bio;
@synthesize email;
@synthesize avatar;
@synthesize zip;
@synthesize receivedData;
@synthesize bUpdateProfile;
@synthesize scrollView;
#define kOFFSET_FOR_KEYBOARD					150.0
#define MAX_LENGTH  300.0


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
    [creditsLbl release];
    [nameFld release];
    [emailFld release];
    [bioFld release];
    [activityIndicator release];
    [selectedImage release];
    [avatarImg release];
    
    [facebook release];
    [twitter release];
    [youtube release];
    [youtoo release];
    [profileImage release];
    [profileName release];
    [imageData release];
    //if ( networkQueue )
      //  [networkQueue release]; 
    [receivedData release];
    
    for (ASIHTTPRequest *req in [networkQueue operations])
    {
        [req setDelegate:nil];
        [req cancel];
    }
    [networkQueue setDelegate:nil];
    
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
    // Do any additional setup after loading the view from its nib.
    editZipFld.delegate = self;
    nameFld.delegate = self;
    emailFld.delegate = self;
    bioFld.delegate = self;
    self.isNetworkOperation = NO;
    
    selectedImage=nil;
    
    self.imageData=NULL;
    bUpdateProfile = NO;
    
    [self updateProfile];
    
    reloadTImer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadScreen:) userInfo:nil repeats:NO];

    [activityIndicator startAnimating];
    scrollView.frame = CGRectMake(0, 142, 320, 340);
    [scrollView setContentSize:CGSizeMake(320, 430)];        
    [super viewDidLoad];
    
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate authenticateAtLaunchIfNeedBe];
}
    
-(void) updateProfile
{
    bUpdateProfile = NO;
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    creditsLbl.text= [appDelegate.creditStr stringByAppendingString:@"  Credits"];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    // Do any additional setup after loading the view from its nib.
    
    //if ( profileName.text==NULL )
    //    profileName.text = @"Name";
    //else
        profileName.text = appDelegate.userName;
    
    // NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:(appDelegate.userImage!=NULL)?appDelegate.userImage:@"image.png"]];
    
    // UIImage *image = [UIImage imageWithData:imageData]; 
    if ( appDelegate.userImage!=NULL )
    {
        NSString *encodedURL = [appDelegate encodeURL:appDelegate.userImage];
        NSLog(@"encodedURL: %@", encodedURL);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:encodedURL]];
        UIImage *image = [UIImage imageWithData:imageData]; 
        profileImage.image = image;
        avatarImg.image = image;
    }
    else
        profileImage.image = [UIImage imageNamed:@"image.png"];
}

-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)canShowAdvertising
{
	return YES;
}

-(void) reloadScreen:(NSTimer*)timer
{
    //[super viewDidAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    /*appDeleagte.selectedController = self;
	[appDeleagte startAdvertisingBar];
    */
    
    NSString *authpath = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [appDelegate readUserName], [appDelegate readLoginPassword]];
    NSLog(@"AuthRequest URL in ProfileEdit: %@", authpath);
    NSURL *url = [NSURL URLWithString:authpath];
    ASIHTTPRequest *authRequest = [ASIHTTPRequest requestWithURL:url];
    [authRequest startSynchronous];
    NSError *error = [authRequest error];
    if (!error) {
        NSString *response = [authRequest responseString];
        NSLog(@"AuthRequest in ProfileEdit: %@", response);
        
        // Authenticated, so Get Bio details now
        [self updateProfileEditScreen];

    }
    else
        NSLog(@"AuthRequest in ProfileEdit: %@", [error localizedDescription]);
    

    // watch the keyboard so we can adjust the user interface if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
}

-(void) updateProfileEditScreen
{
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/getBio/"];
    NSLog(@"Constructed Login URL: %@", path);
    self.isNetworkOperation = YES;
    //[activityIndicator startAnimating];
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
    
    NSLog(@"Constructed Login URL: %@", path);
 //   [activityIndicator startAnimating];
}
/*- (void)viewWillDisappear:(BOOL)animated {
    
    //[networkQueue cancelAllOperations]; 
    //[networkQueue waitUntilAllOperationsAreFinished];
    //[networkQueue setSuspended:YES];
    for (ASIHTTPRequest *req in [networkQueue operations])
    {
        [req setDelegate:nil];
        [req cancel];
    }
    [networkQueue setDelegate:nil];
    
    [super viewWillDisappear:animated];    
}*/

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
     
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = NULL;
    [appDelegate stopAdvertisingBar];
}

-(void) viewWillAppear:(BOOL)animated
{
    bUpdateProfile = NO;
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
    //[appDelegate stopAdvertisingBar];
	[appDelegate startAdvertisingBar];
}

-(IBAction) logout :(id) sender
{
    
NSString *signOutURL = @"http://www.youtoo.com/iphoneyoutoo/signout";
ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
                                [NSURL URLWithString:signOutURL]] autorelease];
[networkQueue addOperation:request];
[networkQueue go];
//appDelegate.userIsSignedIn = NO;
UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Youtoo" message:@"Do you really want to Log out?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];        
    logoutAlert.tag=1;
[logoutAlert show];

}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"Alert buttonIndex: %d", buttonIndex);
//    if ( alertView.tag !=1 )
//    {
//        return;    }
    // THIS is a temporary code for Log out, we need to handle it properly later..
    if(buttonIndex == 0) // 0 means Ok clicked in Logout alert
	{
        
        if(alertView.tag == 1)
        {
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate removeLoginDataPlistItems];
        appDelegate.userImage=NULL; // user avatar image
        
        LogInScreen *loginViewContr = [[[LogInScreen alloc] initWithNibName:@"LogInScreen" bundle:[NSBundle mainBundle]] autorelease];
        UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:loginViewContr];
        [appDelegate.window addSubview:navg.view];
        }
//        else if(alertView.tag == 2)
//        {
//            //[self.view dismissModalViewControllerAnimated:NO];
//            [self.navigationController popViewControllerAnimated:NO];
//        }
    }
//   else if(buttonIndex == 0 && alertView.tag== 2) // 0 means Ok clicked in Logout alert
//	{
////        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
////        
////        [appDelegate removeLoginDataPlistItems];
////        appDelegate.userImage=NULL; // user avatar image
//        
//        Profile *loginViewContr = [[Profile alloc] initWithNibName:@"Profile" bundle:nil];
//        [self.navigationController  pushViewController:loginViewContr animated:YES];
////        UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:loginViewContr];
////        [appDelegate.window addSubview:navg.view];
//    }

    
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


-(IBAction) saveEditUser :(id) sender
{
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    
    if ( (nameFld.text!=NULL && [nameFld.text length]>0 ) && (emailFld!=NULL && [emailFld.text length]>0 ) && (editZipFld!=NULL && [editZipFld.text length]>0) )
    {
            
    [appDeleagte didStartNetworking];
    
    //submitButton.enabled = NO;
    NSURL *url = [NSURL URLWithString:@"http://www.youtoo.com/iphoneyoutoo/edituser/"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate= self;
    
    [request setRequestMethod:@"POST"];
   
    [request setPostValue:(nameFld.text!=NULL)?nameFld.text :@"" forKey:@"Name"];
    [request setPostValue:(emailFld.text!=NULL)?emailFld.text :@"" forKey:@"Email"];
    //[request setPostValue:(bioFld.text!=NULL)?bioFld.text :@"" forKey:@"Bio"];
    [request setPostValue:(editZipFld.text!=NULL)?editZipFld.text :@"" forKey:@"Zip"];    
    [request setPostValue: (facebook.on==TRUE)?@"1":@"0" forKey:@"Facebook"];  
    [request setPostValue:(twitter.on==TRUE)?@"1":@"0" forKey:@"Tweet"];  
    [request setPostValue:(youtoo.on==TRUE)?@"1":@"0" forKey:@"Youtube"];  
    [request setPostValue:(youtube.on==TRUE)?@"1":@"0" forKey:@"Youtoo"]; 
    
        NSLog(@"FB: %@; Twitter: %@; Youtoo: %@; Youtube: %@", (facebook.on==TRUE)?@"1":@"0", (twitter.on==TRUE)?@"1":@"0", (youtoo.on==TRUE)?@"1":@"0", (youtube.on==TRUE)?@"1":@"0");
        
    // setting for spot name selected...
    [request setTimeOutSeconds:5 * 60.0];
   
    //NSString *logUploadURL = [NSString stringWithFormat:@"logUploadURL: %@", url];
    
    NSLog(@"selectedImage edit user: %@", selectedImage);
    
    NSLog(@"imageData when uploading..: %@", self.imageData);
    
    if ( self.imageData!=NULL )
        [request setFile:self.imageData withFileName:@"avatar.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    else
        NSLog(@"No Avatar Image has chosen to update!");
        
   // [request setData:self.imageData withFileName:@"avatar.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    
    appDeleagte.bUploadHappening = YES;
    [request startSynchronous];
    
    // Stop Activity
    [appDeleagte didStopNetworking];
    //[activityIndicator stopAnimating];
    //submitButton.enabled = YES;
    
    NSError *error = [request error];
    if (nil == error)
    {
        NSString *resultString = [request responseString];
        NSLog(@"Server response after uploading: %@", resultString);
        appDeleagte.bUploadHappening = NO;
        //			[appDelegate reportError:NSLocalizedString(@"Your video is successfully uploaded", @"Alert Title")
        //                         description:@""];
        if ( resultString==NULL || [resultString length]<=0 )
            resultString = @"Successfully updated!";
             
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Youtoo" 
                                                         message:@"Successfully updated!" 
                                                        delegate:self 
                                               cancelButtonTitle:@"Ok" 
                                               otherButtonTitles:nil] autorelease];
        alert.tag = 2;
        [alert show];
        bUpdateProfile = YES;
        
        appDeleagte.userName = NULL;
        [self grabProfileInfoIntheBackgroud];
                
    }
    else
    {
        
        NSLog(@"Server error after uploading: %@", [error localizedDescription]);
        [appDeleagte reportError:NSLocalizedString(@"Updating user info, error occurred", @"Alert Title")
                     description:[error localizedDescription]];
    }
    
    }
    else
    {
        [appDeleagte reportError:NSLocalizedString(@"Youtoo", @"Alert Title")
                     description:@"Name, Email address and Zip fields are mandatory to be entered!"];
        return;
    }


}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
	NSLog(@"youtoo: Recording finished...didFinishPickingMediaWithInfo(): %@", info);
	
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSURL *url = [info valueForKey:@"UIImagePickerControllerReferenceURL"];
    //appDelegate.currentVideoPath = [url path];
    appDelegate.currentVideoPath = [NSString stringWithFormat:@"logUploadURL: %@", url];
    
    NSLog(@"info: %@", info);
    
    //selectedImage = [imageUrl path];
    NSLog(@"appDelegate.currentVideoPath: %@", appDelegate.currentVideoPath);
    
   // avatarImg.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//	[self dismissModalViewControllerAnimated:YES];
    
    UIImage *im = [info objectForKey:@"UIImagePickerControllerOriginalImage"] ;
    avatarImg.image = im;
    UIGraphicsBeginImageContext(CGSizeMake(320,480)); 
    [im drawInRect:CGRectMake(0, 0,320,480)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext();
    self.imageData=UIImageJPEGRepresentation(newImage, 0.5); 
    NSLog(@"imageData: %@", self.imageData);
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) LaunchAlbum :(id) sender
{
    // Updated - overlay code.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
   
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.mediaTypes = [NSArray arrayWithObject:@"public.image"];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:pickerController animated:YES];
    [ pickerController release];
}

- (void)grabProfileInfoIntheBackgroud
{
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile/"];
    NSLog(@"To get new profile: %@", path);
    self.isNetworkOperation = YES;
    
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
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
   // if (theTextField == editZipFld) 
    if (theTextField == editZipFld )
    {
        if ( bAlreadyMovedUp )
			[self setViewMovedUp:NO];
        
		[editZipFld resignFirstResponder];
		
		
    }
    else
    {
        [theTextField resignFirstResponder];
    }
    return YES;
}
- (void)keyboardWillShow:(NSNotification *)notif
{
    
	if ( !bTxtViewEditing )
	{
        [self setViewMovedUp:YES];
    }
	
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == editZipFld )
        bTxtViewEditing = NO;
    else
        bTxtViewEditing = YES;
    
	return YES;
}

#pragma mark -
#pragma mark XMLParser
#pragma mark -

/*- (void)parseXMLFilewithData:(NSString *)strURL
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *dataURL = [NSURL URLWithString:strURL];
    NSData * dataXml = [[NSData alloc] initWithContentsOfURL:dataURL];
    self.rssParser = [[NSXMLParser alloc] initWithData:dataXml];
	//self.rssParser = [[NSXMLParser alloc] initWithContentsOfURL:dataURL] ;
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
	[pool release];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{	
	//[self performSelectorOnMainThread:@selector(showAlertNoConnection:) 
	//					   withObject:parseError waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
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
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    NSLog(@"Legal: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self.currentElement isEqualToString:@"name"] && [trimmString length] > 0)
    {
        //self.legalString = string;
        self.name = trimmString;
        NSLog(@"name: %@", self.name);
    }
    if ([self.currentElement isEqualToString:@"bio"] && [trimmString length] > 0)
    {
        //self.legalString = string;
        self.bio = trimmString;
        NSLog(@"bio: %@", self.bio);
    }
    if ([self.currentElement isEqualToString:@"email"] && [trimmString length] > 0)
    {
        self.email = trimmString;
    }
    if ([self.currentElement isEqualToString:@"avatar"] && [trimmString length] > 0)
    {
        self.avatar = trimmString;
    }
    if ([self.currentElement isEqualToString:@"zip"] && [trimmString length] > 0)
    {
        self.zip = trimmString;
    }
    
    if ( ( [self.currentElement isEqualToString:@"name"] || [self.currentElement isEqualToString:@"username"]) && [trimmString length] > 0 )
    {
        appDelegate.userName = trimmString;
    }
    if ([self.currentElement isEqualToString:@"user_image"] && [trimmString length] > 0)
    {
        appDelegate.userImage = trimmString;
    }
    if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
    {
        //self.creditStr = trimmString;
        appDelegate.creditStr = trimmString;
    }
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
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	
    NSLog(@"name: %@", self.name);
    NSLog(@"email: %@", self.email);
    NSLog(@"bio: %@", self.bio);
    NSLog(@"zip: %@", self.zip);
    
    nameFld.text = (self.name!=NULL)?self.name:@"";
    emailFld.text = (self.email!=NULL)?self.email:@"";
    bioFld.text = (self.bio!=NULL)?self.bio:@"";
    editZipFld.text = (self.zip!=NULL)?self.zip:@"";	
}*/


- (void)parseXMLFilewithData:(NSData *)data
{
    self.sendResult = @"";
    self.rssParser = [[[NSXMLParser alloc] initWithData:data] autorelease];		
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //[self performSelectorOnMainThread:@selector(showAlertErrorParsing) 
      //                     withObject:parseError waitUntilDone:NO];
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
	
    NSLog(@"Legal: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
   
    
    // 
    if ( bUpdateProfile==YES )
    {
        if ( [self.currentElement isEqualToString:@"name"] && [trimmString length] > 0 )
        {
            appDelegate.userName = trimmString;
        }
        else
        {
            if ( [self.currentElement isEqualToString:@"username"] && [trimmString length] > 0 && appDelegate.userName==NULL )
                appDelegate.userName = trimmString;
        }
        if ([self.currentElement isEqualToString:@"user_image"] && [trimmString length] > 0)
        {
            appDelegate.userImage = trimmString;
        }
        if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
        {
            //self.creditStr = trimmString;
            appDelegate.creditStr = trimmString;
        }
    }
    else
    {
        if ([self.currentElement isEqualToString:@"name"] && [trimmString length] > 0)
        {
            //self.legalString = string;
            self.name = trimmString;
            NSLog(@"name: %@", self.name);
        }
        if ([self.currentElement isEqualToString:@"bio"] && [trimmString length] > 0)
        {
            //self.legalString = string;
            self.bio = trimmString;
            NSLog(@"bio: %@", self.bio);
        }
        if ([self.currentElement isEqualToString:@"email"] && [trimmString length] > 0)
        {
            self.email = trimmString;
        }
        if ([self.currentElement isEqualToString:@"avatar"] && [trimmString length] > 0)
        {
            self.avatar = trimmString;
        }
        if ([self.currentElement isEqualToString:@"zip"] && [trimmString length] > 0)
        {
            self.zip = trimmString;
        }
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
	
     NSLog(@"name: %@", self.name);
     NSLog(@"email: %@", self.email);
     NSLog(@"bio: %@", self.bio);
     NSLog(@"zip: %@", self.zip);
    
    if ( bUpdateProfile==YES )
    {
        bUpdateProfile=NO;
        [self updateProfileEditScreen];
    }
    nameFld.text = (self.name!=NULL)?self.name:@"";
    emailFld.text = (self.email!=NULL)?self.email:@"";
    bioFld.text = (self.bio!=NULL)?self.bio:@"";
    editZipFld.text = (self.zip!=NULL)?self.zip:@"";
    
    [self updateProfile];
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
