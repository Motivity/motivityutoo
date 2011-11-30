//
//  WriteAtickerShout.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "WriteAtickerShout.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "BeOnTv.h"
#import "SuccessUpload.h"
#import "ItemModel.h"
#import "ProfileFriendView.h"

@implementation WriteAtickerShout

@synthesize textView;
@synthesize ticketSubmitBtn;
@synthesize currentElement;
@synthesize advertisingString;
@synthesize isNetworkOperation;
@synthesize sendResult;
@synthesize rssParser;
@synthesize activityIndicator;
@synthesize isPostOperation;
@synthesize mobile;
@synthesize web;
@synthesize tv;
@synthesize mobileIsChecked;  
@synthesize webIsChecked; 
@synthesize tvIsChecke;
@synthesize twitterBtn;
@synthesize fbBtn;
@synthesize googleBtn;
@synthesize tweetIsChecked;  
@synthesize fbIsChecked; 
@synthesize googleIsChecke;
@synthesize titleLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(ItemModel *)aModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ( aModel!=NULL )
            myItemModel = aModel;
        
        // Custom initialization
        self.advertisingString = @"";
        self.isPostOperation = NO;
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.advertisingString = nil;
    self.currentElement = nil;
    [activityIndicator release];
    [mobile release];
    [web release];
    [tv release];
    [twitterBtn release]; 
    [fbBtn release];
    [googleBtn  release];
    [titleLabel release];
    
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
    self.title = @"Social Shout";
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDefault;
    textFld.delegate = self;
    textFld.returnKeyType = UIReturnKeyDefault;
    mobileIsChecked=NO;  
    webIsChecked=NO; 
    tvIsChecke=NO;
     self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDeleagte.selectedController = self;
	[appDeleagte startAdvertisingBar];
    
    if ( myItemModel !=NULL )
    {
        NSLog(@"myItemModel.showName: %@", myItemModel.showName);
        
        NSString *onAirStr;
        onAirStr = [NSString stringWithFormat:@"On Air Now: " ];
        
        onAirStr = [onAirStr stringByAppendingFormat:myItemModel.showName];
        titleLabel.text = onAirStr;
     
    }
    UIImage *markImage;    
        markImage = [UIImage imageNamed:@"uncheckmark.png"];
    [mobile setImage:markImage forState:UIControlStateNormal];
    [web setImage:markImage forState:UIControlStateNormal];
    [tv setImage:markImage forState:UIControlStateNormal];

    
    markImage = [UIImage imageNamed:@"twitterT.png"];
    [twitterBtn setImage:markImage forState:UIControlStateNormal];
    
    
    markImage = [UIImage imageNamed:@"Facebookf.png"];
    [fbBtn setImage:markImage forState:UIControlStateNormal];
    
    markImage = [UIImage imageNamed:@"google.png"];
    [googleBtn setImage:markImage forState:UIControlStateNormal];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDeleagte authenticateAtLaunchIfNeedBe];
    
    appDeleagte.selectedController = self;
	[appDeleagte startAdvertisingBar];
}

- (BOOL)canShowAdvertising
{
	return YES;
}
-(void) reloadPage
{
   /* YoutooAppDelegate *appDeleagte = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDeleagte.selectedController = self;
	[appDeleagte startAdvertisingBar];*/
}
-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
}
-(IBAction)tweetBtnAction:(id)sender
{
    if ( !tweetIsChecked )
    {
        tweetIsChecked = YES;
        
		[twitterBtn setImage:[UIImage imageNamed:@"twitterselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        tweetIsChecked = NO;
		[twitterBtn setImage:[UIImage imageNamed:@"twitterT.png"] forState:UIControlStateNormal];
	}

}

-(IBAction)fbBtnAction:(id)sender
{
    if ( !fbIsChecked )
    {
        fbIsChecked = YES;
        
		[fbBtn setImage:[UIImage imageNamed:@"FacebookSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        fbIsChecked = NO;
		[fbBtn setImage:[UIImage imageNamed:@"Facebookf.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction)googleBtnAction:(id)sender
{
    if ( !googleIsChecke )
    {
        googleIsChecke = YES;
        
		[googleBtn setImage:[UIImage imageNamed:@"googleselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        googleIsChecke = NO;
		[googleBtn setImage:[UIImage imageNamed:@"google.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction)mobileAction:(id)sender
{
    if ( !mobileIsChecked )
    {
        mobileIsChecked = YES;
        
		[mobile setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        mobileIsChecked = NO;
		[mobile setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
    
}
-(IBAction)webAction:(id)sender
{
    if ( !webIsChecked )
    {
        webIsChecked = YES;
        
		[web setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        webIsChecked = NO;
		[web setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
}
-(IBAction)tvAction:(id)sender
{
    if ( !tvIsChecke )
    {
        tvIsChecke = YES;
        
		[tv setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }
    else
    {
        tvIsChecke = NO;
		[tv setImage:[UIImage imageNamed:@"uncheckmark.png"] forState:UIControlStateNormal];
	}
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen: appDelegate.tickerUserID: %@", appDelegate.tickerUserID);
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}


-(IBAction) submitTickerShout :(id) sender
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;

    NSString *authpath = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [appDelegate readUserName], [appDelegate readLoginPassword]];
    NSLog(@"AuthRequest URL in ProfileFameS: %@", authpath);
    NSURL *authurl = [NSURL URLWithString:authpath];
    ASIHTTPRequest *authRequest = [ASIHTTPRequest requestWithURL:authurl];
    [authRequest startSynchronous];
    NSError *autherror = [authRequest error];
    if (!autherror) {
        NSString *response = [authRequest responseString];
        NSLog(@"AuthRequest in Writetick: %@", response);
    }
    else
        NSLog(@"AuthRequest in Writetick: %@", [autherror localizedDescription]);
    
    if (textView.text ==NULL || [textView.text length]<=0)
        {
            [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Title")
                                      description:@"Please enter your social shout to submit!"];
            return;
        }
    
        NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                                (CFStringRef)textView.text, NULL, CFSTR(":/?#[]@$&’()*+,;="), kCFStringEncodingUTF8);
      /*  NSString *t = @"tweet";
        NSString *fb = @"fb";
        NSString *g = @"google";
        NSString *tvStr = @"tv";
        NSString *webStr = @"web";
        NSString *mob = @"mobile";
    */
        NSString *typeStr=NULL;
    // mobile    
    if (mobileIsChecked)
    {            
        typeStr = [NSString stringWithFormat:@"1" ];
    }
    else
        typeStr = [NSString stringWithFormat:@"0" ];
    //web
    typeStr = [typeStr stringByAppendingString:@"/"];
    if (webIsChecked)
    {
        typeStr = [typeStr stringByAppendingString:@"1"];
    }
    else
        typeStr = [typeStr stringByAppendingString:@"0" ];
    // tv
    typeStr = [typeStr stringByAppendingString:@"/"];    
    if (tvIsChecke)
    {            
        typeStr = [typeStr stringByAppendingString:@"1"  ];
    }
    else
        typeStr = [typeStr stringByAppendingString:@"0" ];
    // twitter
    typeStr = [typeStr stringByAppendingString:@"/"];
        if ( tweetIsChecked )
            typeStr = [typeStr stringByAppendingString:@"1"];
        else
            typeStr = [typeStr stringByAppendingString:@"0"];
     
        typeStr = [typeStr stringByAppendingString:@"/"];
    
    // facebook
         if (fbIsChecked)
         {            
            typeStr = [typeStr stringByAppendingString:@"1"];
         }
         else
             typeStr = [typeStr stringByAppendingString:@"0"];
        
        /*typeStr = [typeStr stringByAppendingString:@"/"];
        if (googleIsChecke)
        {            
            typeStr = [typeStr stringByAppendingString:@"1" ];
        }
        else
            typeStr = [typeStr stringByAppendingString:@"0" ];
        
        */
    
        //[NSString stringWithFormat:@"%@/%@/%@", three, two, one];
    
        NSLog(@"typeStr: %@", typeStr);
        NSLog(@"Social shout: %@", result);
    
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/createTicker/%@/%@/%@", appDelegate.userIDCode, result, typeStr];
        
        if (nil != result)
        {
            CFRelease((CFStringRef)result);
        }
        
        NSLog(@"Send post request: %@", path);
        [networkQueue cancelAllOperations];
        [networkQueue setDelegate:self];
        [activityIndicator startAnimating];
        self.isPostOperation = YES;
        ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
                                        [NSURL URLWithString:path]] autorelease];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(postDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [request setTimeOutSeconds:20];
        [networkQueue addOperation:request];
        [networkQueue go];
    [appDelegate didStopNetworking];
    //[activityIndicator stopAnimating];
    //submitButton.enabled = YES;
    isNetworkOperation = NO;
    NSError *error = [request error];
    if (nil == error)
    {
        NSString *resultString = [request responseString];
        NSLog(@"Server response after uploading: %@", resultString);
        appDelegate.bUploadHappening = NO;
        //			[appDelegate reportError:NSLocalizedString(@"Your video is successfully uploaded", @"Alert Title")
        //                         description:@""];
       /* UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil 
                                                         message:@"Your Social Shout is successfully uploaded!" 
                                                        delegate:self 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil] autorelease];
        [alert show];*/

    }
    else
    {
        
        NSLog(@"Server error after uploading: %@", [error localizedDescription]);
        [appDelegate reportError:NSLocalizedString(@"Uploading video error occurred", @"Alert Title")
                     description:[error localizedDescription]];
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		NSLog(@"OK");
        
        [self launchEarnScreen];
        
		
	}
}
-(void) launchEarnScreen
{
    SuccessUpload *successViewContr = [[SuccessUpload alloc] initWithNibName:@"SuccessUpload" bundle:nil];
    [self.navigationController pushViewController:successViewContr animated:NO];
    [successViewContr release];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    int limit = 39;
        
    if([text isEqualToString:@"\n"] || ([textView.text length]>limit && [text length] > range.length)) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
 
-(IBAction) Cancel:(id)sender
{
   
    [self.navigationController popViewControllerAnimated:YES];
   //[self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    self.activityIndicator = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    if (theTextField == textFld ) {
        
		[textFld resignFirstResponder];
		
    }
    return YES;
    
    
}
-(IBAction) textViewDidChange:(UITextView *)textView {
    //UITextField * textview = (UITextField *) sender;
    int maxChars = 40;
    int charsLeft = maxChars - [textView.text length];
    
    if(charsLeft == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Youtoo" 
                                                         message:[NSString stringWithFormat:@"You have reached the maximum number of characters to be entered %d.", maxChars] 
                                                        delegate:nil 
                                               cancelButtonTitle:@"Ok" 
                                               otherButtonTitles:nil];
        //  textView.;
        [alert show];
        [alert release];
        
        [textView resignFirstResponder];
    }
    if( charsLeft >= 0 )
        charCount.text = [NSString stringWithFormat:@"%d",charsLeft];
}

/*- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string;
{    
    int limit = 44;
    
    
    if(([textView.text length]>limit && [string length] > range.length))
    { 
        [textView resignFirstResponder];
        return  YES;
    }
    else
        [textView resignFirstResponder];
    
    
    return YES;
}*/

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
	[self performSelectorOnMainThread:@selector(parsingDidStop) withObject:nil waitUntilDone:NO];
	//[self performSelectorOnMainThread:@selector(showAlertErrorParsing) 
	//	withObject:parseError waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	
    
    NSString *sessionStr=NULL;
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    NSLog(@"trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
	if ([self.currentElement isEqualToString:@"result"] && [trimmString length] > 0)
	{
		self.sendResult = string;
	}
    if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
    {
        appDelegate.earnCredit =  trimmString;
    }
   
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{	
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	
	if (!self.isPostOperation)
	{
		
	}
	else
	{
		if ([self.sendResult length] > 0)
		{
			[appDelegate reportError:NSLocalizedString(@"Social Shout", @"Alert Text") description:self.sendResult];
            if ([self.sendResult isEqualToString:@"Your Shout has been sent"])
             [self launchEarnScreen];
		}
		
		else
		{
			[appDelegate reportError:NSLocalizedString(@"Your message was sent successfully", @"Alert Text") description:@""];		
		}
	}
	
	[self performSelectorOnMainThread:@selector(parsingDidStop) withObject:nil waitUntilDone:NO];
}

- (void)parsingDidStop
{
	self.isPostOperation = NO;
	self.isNetworkOperation = NO;
	
	[activityIndicator stopAnimating];
	//[self updateView];
}

#pragma mark -
#pragma mark end XMLParser
#pragma mark -

- (void)requestDone:(ASIHTTPRequest *)request
{
	
}


- (void)postDone:(ASIHTTPRequest *)request
{
	[networkQueue setDelegate:nil];
	[request setDelegate:nil];
	NSLog(@"Post resultString = ", [request responseString]);
	[self parseXMLFilewithData:[request responseData]];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	[networkQueue setDelegate:nil];
	[request setDelegate:nil];
	self.isNetworkOperation = NO;
	self.isPostOperation = NO;
	[self performSelectorOnMainThread:@selector(parsingDidStop) withObject:nil waitUntilDone:NO];
}


@end
