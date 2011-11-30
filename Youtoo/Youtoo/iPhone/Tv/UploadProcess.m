//
//  UploadProcess.m
//  Youtoo
//
//  Created by PRABAKAR MP on 06/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "UploadProcess.h"
#import "YoutooAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "SuccessUpload.h"
#import "ItemModel.h"

@interface UploadProcess (PrivateMethods)

- (NSString *)grenerateUploadName;

@end

@implementation UploadProcess

@synthesize currentVideoPath;
@synthesize selectedSpotNameStr;
@synthesize proceessVideoImg;
@synthesize fbOrTwitterCall;
@synthesize currentElement;
@synthesize rssParser;
@synthesize sendResult;
@synthesize statusActivity;
@synthesize networkQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [statusActivity release];
    
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
    self.title = @"Upload";
   proceessVideoImg = [[UIImageView alloc] init];
    [proceessVideoImg setImage:[UIImage imageNamed:@"18a-uploadingV+t_text.png"]];
    [proceessVideoImg setFrame:CGRectMake(23, 251, 273, 22)];
    [self.view addSubview:proceessVideoImg];
    
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate authenticateAtLaunchIfNeedBe];
    
    [self authLocallyIfNeedBe];
    
    statusActivity.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 
                                                   target:self selector:@selector(updateBottomLine:) userInfo:nil repeats:NO];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    fbOrTwitterCall = 0;
    //[self canFBandTwitterEnabled: YES];
    statusActivity.hidden = YES;
}
- (void)updateBottomLine:(NSTimer*)theTimer
{
	[self uploadProcessing];
}

-(void)uploadProcessing
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(32.0f, 350.0f, 250.0f, 90.0f)];
    [self.view addSubview:progressView];
    [progressView setProgressViewStyle: UIProgressViewStyleBar];
    [progressView setProgress:0.0f];
    NSString *userID = NULL;
    userID = [appDelegate readUserID];
    
   // NSLog(@"youtoo: ALNShareController file...submitFile(). userID:%@; blogTitle:%@", userID);
	if ( (userID!=nil && userID.length>0) )
	{
		NSLog(@"youtoo: ALNShareController..blogTitleField.text.length > 0...submitFile()");
        
		NSString *uploadName = [self grenerateUploadName];
        NSLog(@"youtoo: ALNShareController file...submitFile(). uploadName:%@", uploadName);
		//Reflect Activity on Device's Status Bar
		//[activityIndicator startAnimating];
		isNetworkOperation = YES;
		[appDelegate didStartNetworking];
        
		//submitButton.enabled = NO;
		// Create Post Request using Third party ASIFormDataRequest -> http://allseeing-i.com/ASIHTTPRequest
		NSURL *url = [NSURL URLWithString:@"http://www.youtoo.com/iphoneyoutoo/uploadVideo/"];
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
         [request setUploadProgressDelegate:progressView];
		[request setRequestMethod:@"POST"];
        NSLog(@"userID while uploading: %@", userID);
        [request setPostValue:userID forKey:@"userid"];
		[request setPostValue:userID forKey:@"bloguserid"];
        [request setPostValue:@"" forKey:@"blogtitle"];
        NSLog(@"appDelegate.epiQuestionID: %@", appDelegate.epiQuestionID);
		[request setPostValue:appDelegate.epiQuestionID forKey:@"questionid"];
       
        request.delegate= self;
        
        //		[request setPostValue:blogText forKey:@"blogtext"];
		// setting for spot name selected...
        /// SOCIAL STATUS
        NSString *typeStr=NULL;
        

        if ( appDelegate.tweetIsChecked )
        {
            [request setPostValue:@"1" forKey:@"twitter"]; 
            typeStr = @"Tweet is Checked";
        }
        else
        {
            [request setPostValue:@"0" forKey:@"twitter"]; 
            typeStr = @"Tweet is NOT Checked";    
        }
        if (appDelegate.fbIsChecked)
            [request setPostValue:@"1" forKey:@"facebook"];
        else
            [request setPostValue:@"0" forKey:@"facebook"];
        /*if (appDelegate.googleIsChecke)
         [request setPostValue:@"1" forKey:@"google"];
         else
         [request setPostValue:@"0" forKey:@"google"];*/
        if (appDelegate.mobileIsChecked)
            [request setPostValue:@"1" forKey:@"mobile"];
        else
            [request setPostValue:@"0" forKey:@"mobile"];
        if (appDelegate.tvIsChecke)
            [request setPostValue:@"1" forKey:@"tv"];
        else
            [request setPostValue:@"0" forKey:@"tv"];
        if (appDelegate.webIsChecked)
            [request setPostValue:@"1" forKey:@"web"];
        else
            [request setPostValue:@"0" forKey:@"web"];
        if (appDelegate.youtubeIsChecked)
            [request setPostValue:@"1" forKey:@"youtube"];
        else
            [request setPostValue:@"0" forKey:@"youtube"];

        
        //[NSString stringWithFormat:@"%@/%@/%@", three, two, one];
        
        NSLog(@"typeStr: %@", typeStr);
        
		[request setPostValue:selectedSpotNameStr forKey:@"spotname"];
		[request setTimeOutSeconds:5 * 60.0];
        NSString *logUploadURL = [NSString stringWithFormat:@"logUploadURL: %@", url];
		NSLog(@"youtoo: ALNShareController..just beofore uploading..submitFile()..logUploadURL: %@; self.currentVideoPath: %@", logUploadURL, appDelegate.currentVideoPath);
		[request setFile:appDelegate.currentVideoPath withFileName:uploadName andContentType:nil forKey:@"videofile"];
        appDelegate.bUploadHappening = YES;
        statusActivity.hidden = NO;
        [statusActivity startAnimating];
        
		[request startSynchronous];
        
		// Stop Activity
		[appDelegate didStopNetworking];
		//[activityIndicator stopAnimating];
		//submitButton.enabled = YES;
		isNetworkOperation = NO;
		NSError *error = [request error];
		if (nil == error)
		{
			[request setDelegate:self];
            [request setDidFinishSelector:@selector(postDone:)];
            NSString *resultString = [request responseString];
			NSLog(@"Server response after uploading: %@", resultString);
			appDelegate.bUploadHappening = NO;
            
            NSString *startTag = @"<points>";
            NSString *endTag = @"</points>";
            NSString *responseString=NULL;
            
            NSScanner *scanner = [[NSScanner alloc] initWithString:resultString];
            [scanner scanUpToString:startTag intoString:nil];
            scanner.scanLocation += [startTag length];
            [scanner scanUpToString:endTag intoString:&responseString];
            [scanner release];
            
            NSLog(@"points string is %@", responseString);
            if ( responseString )
            {
                appDelegate.earnCredit = responseString;
                 NSLog(@"appDelegate.earnCredit: %@", appDelegate.earnCredit);
            }
            
            /*NSRange start;
            NSRange end;
            start = [resultString rangeOfString: @"<points>"];
            end = [resultString rangeOfString: @"</points>"];
            if (start.location==NSNotFound && end.location==NSNotFound)
            {    
                
            }
            else
                appDelegate.creditStr = [resultString substringWithRange:(start.location, end.location)];
            */
            
         /*   UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Youtoo 2.0" 
                                                             message:@"Your video is successfully uploaded!" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"Ok" 
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
            */
            
            [statusActivity stopAnimating];
            statusActivity.hidden = YES;
            
            // Send facebook or twitter status to server
            YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate reportError:NSLocalizedString(@"Youtoo", @"Alert Title")
						 description:@"Your video is successfully uploaded!"];

           //[self parseXMLFilewithData:(NSString *)strURL];
            
            SuccessUpload *successViewContr = [[SuccessUpload alloc] initWithNibName:@"SuccessUpload" bundle:nil];
            [self.navigationController pushViewController:successViewContr animated:NO];
            [successViewContr release];
            
            [progressView setHidden:YES];
            [proceessVideoImg setHidden:YES];
            
           		}
		else
		{
			
            NSLog(@"Server error after uploading: %@", [error localizedDescription]);
            [statusActivity stopAnimating];
            statusActivity.hidden = YES;

			[appDelegate reportError:NSLocalizedString(@"Uploading video error occurred", @"Alert Title")
						 description:[error localizedDescription]];
		}
		
			}
	else
	{		
		NSLog(@"youtoo: Please fill the blog title...submitFile()");
                
		[appDelegate reportError:NSLocalizedString(@"Please fill the blog title (or) User ID is not valid", @"Alert Title")
					 description:@""];
	}

}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		NSLog(@"OK");
        SuccessUpload *successViewContr = [[SuccessUpload alloc] initWithNibName:@"SuccessUpload" bundle:nil];
        [self.navigationController pushViewController:successViewContr animated:NO];
        [successViewContr release];
        
		
	}
}
-(void) authLocallyIfNeedBe
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    networkQueue = [[ASINetworkQueue alloc] init];
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [appDelegate readUserName], [appDelegate readLoginPassword]];

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
}

/*-(void) sendFBTwitterStatus :(BOOL) bFBOnly
{
    NSLog(@"sendFBTwitterStatus start");
    NSString *urlString;
    NSMutableString *appendURLStr = [[NSMutableString alloc] init];
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    if ( bFBOnly==YES && appDelegate.bFbCheckEnabledByUser )
    {
        NSLog(@"sendFBTwitterStatus for FB share");
        [appendURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/facebookShare/%@", appDelegate.userIDCode];
    }
    else if ( bFBOnly==NO && appDelegate.bTwitterCheckEnabledByUser )
    {
        NSLog(@"sendFBTwitterStatus for twitter share");
        [appendURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/twitterShare/%@", appDelegate.userIDCode];
    }
    fbOrTwitterCall++;
    urlString = [appendURLStr copy];
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self withObject:urlString];
    NSLog(@"sendFBTwitterStatus end");
}*/
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
    NSLog(@"parseErrorOccurred in ClipController.m file, error: %@", parseError);
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
    
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([trimmString length] > 0)
	{
		NSLog(@"Clip controller.m xmlparser, Result:  %@; trimmString:%@", self.currentElement, trimmString);
        
        if ([self.currentElement isEqualToString:@"points"])
		{
            appDelegate.earnCredit =  trimmString;
        }
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self performSelectorOnMainThread:@selector(parsingDidStop) withObject:nil waitUntilDone:NO];
}

- (void)parsingDidStop
{
	//self.isPostOperation = NO;
	//self.isNetworkOperation = NO;
	
	//[activityIndicator stopAnimating];
	//[self updateView];
}
- (void)postDone:(ASIHTTPRequest *)request
{
	
	[request setDelegate:nil];
	NSLog(@"Post resultString = ", [request responseString]);
	[self parseXMLFilewithData:[request responseData]];
}

/*-(void) canFBandTwitterEnabled : (BOOL) forFBOnly // this flag is to differentiate whether it is a facebook call or twitter call
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if ( appDelegate.userIsSignedIn || (nil!=appDelegate.userIDCode) )
	{
        NSString *urlString = NULL;
        NSMutableString *appendURLStr = [[NSMutableString alloc] init];
        if ( forFBOnly==YES )
        {
            fbOrTwitterCall++;
            [appendURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/canFB/%@", appDelegate.userIDCode];
        }
        else
        {
            fbOrTwitterCall++;
            [appendURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/canTweet/%@", appDelegate.userIDCode];
        }
        urlString = [appendURLStr copy];
        NSLog(urlString);
        [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self withObject:urlString];
    }
}*/

- (NSString *)grenerateUploadName
{
	NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
	NSString *aFileName = [NSString stringWithFormat:@"%u.%@", (unsigned long)interval, @"MOV"];
    NSLog(@"youtoo: ALNShareController..grenerateUploadName(). aFileName:%@", aFileName);
	return aFileName;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
