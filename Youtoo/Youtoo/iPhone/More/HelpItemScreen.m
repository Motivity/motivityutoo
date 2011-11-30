//
//  HelpItemScreen.m
//  Youtoo
//
//  Created by PRABAKAR MP on 02/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "HelpItemScreen.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "YoutooAppDelegate.h"
@interface HelpItemScreen (PrivateMethods)

- (void)didStopLoadData;
@end


@implementation HelpItemScreen
@synthesize rssParser;
@synthesize item;
@synthesize currentElement;
@synthesize creditLbl;
@synthesize isNetworkOperation;
@synthesize activityIndicator;
@synthesize sendResult;
@synthesize imageArray;
@synthesize helpString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isNetworkOperation = NO;
        self.sendResult = @"";
        networkQueue = [[ASINetworkQueue alloc] init];        }
    return self;
}

- (void)dealloc
{
    self.item = nil;
	self.currentElement = nil;
	[rssParser release];
    [activityIndicator release];
    [creditLbl release];
    [imageArray release];
    [super dealloc];
}

- (BOOL)canShowAdvertising
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
    
    // Do any additional setup after loading the view from its nib.    
    
    NSString *path = [NSString stringWithFormat:@"http://dev.youtoo.com/iphoneyoutoo/showHelp/help"];
    NSLog(@"Constructed Help URL: %@", path);    
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
    self.title = @"Help";
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 200, 20, 20)];    
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator]; 
    UITextView  *helpTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 50.0, 310.0, 480.0)];
    [helpTextView setBackgroundColor:[UIColor clearColor]];
    [helpTextView setFont:[UIFont systemFontOfSize:16.0]];
    [helpTextView setText:@""];
    [helpTextView setText:self.helpString ];
    //friendTxtFld.tag = indexPath.row;
    [helpTextView setEditable:NO];
    [self.view addSubview:helpTextView];
    

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
	
    NSLog(@"Help: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
    if ([self.currentElement isEqualToString:@"content"] && [trimmString length] > 0)
    {
        self.helpString = string;
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
	NSLog(@"Help: %@", [request responseString]);
	
    [self parseXMLFilewithData:responseData];
}

- (void)postDone:(ASIHTTPRequest *)request
{
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    
}

-(void)closeAct
{
    [self dismissModalViewControllerAnimated:YES];
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
