//
//  More.m
//  Youtoo
//
//  Created by PRABAKAR MP on 16/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "More.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "YoutooAppDelegate.h"
#import "AboutYoutoo.h"
#import "AboutYoutooCredits.h"
#import "GetYoutooTv.h"
#import "FAQ.h"
#import "Legal.h"
#import "AboutApp.h"
#import "LogInScreen.h"
#import "ProfileFriendView.h"

@implementation More

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
    //self.title = @"More From Youtoo";
    self.navigationController.navigationBarHidden = YES;

    //self.navigationController.
    tableView.delegate = self;
    tableView.dataSource = self;
    list = [[NSArray alloc] initWithObjects:@"About Youtoo",@"About Youtoo Credits", @"Get Youtoo Tv", @"FAQ", @"Legal", @"About App", @"Logout of Youtoo", nil];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
    [appDelegate stopAdvertisingBar];
	[appDelegate startAdvertisingBar];
}

- (void)reloadPage
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
}

- (BOOL)canShowAdvertising
{
	return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [list objectAtIndex:[indexPath row]]; 
    cell.textLabel.textColor = [UIColor colorWithRed:0.015 green:0.2 blue:0.36 alpha:1];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(indexPath.row == 0)
    {
        AboutYoutoo *aboutViewContr = [[AboutYoutoo alloc] initWithNibName:@"AboutYoutoo" bundle:nil];
        [self.navigationController pushViewController:aboutViewContr animated:YES];
        [aboutViewContr release];
    }
   else if(indexPath.row == 1)
    {
        AboutYoutooCredits *aboutCreditsViewContr = [[AboutYoutooCredits alloc] initWithNibName:@"AboutYoutooCredits" bundle:nil];
        [self.navigationController pushViewController:aboutCreditsViewContr animated:YES];
        [aboutCreditsViewContr release];
    }
   else if(indexPath.row == 2)
   {
       GetYoutooTv *getYoutooTvViewContr = [[GetYoutooTv alloc] initWithNibName:@"GetYoutooTv" bundle:nil];
       [self.navigationController pushViewController:getYoutooTvViewContr animated:YES];
       [getYoutooTvViewContr release];
   }
   else if(indexPath.row == 3)
   {
       FAQ *faqViewContr = [[FAQ alloc] initWithNibName:@"FAQ" bundle:nil];
       [self.navigationController pushViewController:faqViewContr animated:YES];
       [faqViewContr release];
   }
   else if(indexPath.row == 4)
   {
       Legal *legalViewContr = [[Legal alloc] initWithNibName:@"Legal" bundle:nil];
       [self.navigationController pushViewController:legalViewContr animated:YES];
       [legalViewContr release];
   }
    
   else if(indexPath.row == 5)
   {
       AboutApp *aboutAppViewContr = [[AboutApp alloc] initWithNibName:@"AboutApp" bundle:nil];
       [self.navigationController pushViewController:aboutAppViewContr animated:YES];
       [aboutAppViewContr release];
   }

    else if ( indexPath.row==6 )
    {
        NSString *signOutURL = @"http://www.youtoo.com/iphoneyoutoo/signout";
        ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
                                        [NSURL URLWithString:signOutURL]] autorelease];
        [networkQueue addOperation:request];
        [networkQueue go];
        //appDelegate.userIsSignedIn = NO;
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Youtoo" message:@"Do you really want to Log out?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];        
        [logoutAlert show];
        
        
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"Alert buttonIndex: %d", buttonIndex);
    // THIS is a temporary code for Log out, we need to handle it properly later..
    if(buttonIndex == 0) // 0 means Ok clicked in Logout alert
	{
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate removeLoginDataPlistItems];
        appDelegate.userImage=NULL; // user avatar image
        
        LogInScreen *loginViewContr = [[[LogInScreen alloc] initWithNibName:@"LogInScreen" bundle:[NSBundle mainBundle]] autorelease];
        UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:loginViewContr];
        [appDelegate.window addSubview:navg.view];
    }
    
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in More screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
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
