//
//  MoviePlayer.m
//  Youtoo
//
//  Created by CorpusMobileLabs on 09/10/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "MoviePlayer.h"
#import "YoutooAppDelegate.h"

@implementation MoviePlayer

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
/*-(id) initWithURL :(NSURL *) url
{
   // NSURL *vidurl = [NSURL URLWithString:self.videoPath];
    MPMoviePlayerViewController * playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
    [playerController setWantsFullScreenLayout:YES];
    playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [playerController.moviePlayer play];
    [playerController release];
    playerController=nil;
    NSLog(@"playvideo");
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}*/

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    MPMoviePlayerViewController * playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
    [playerController setWantsFullScreenLayout:YES];
    playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [playerController.moviePlayer play];
    [playerController release];
    playerController=nil;
    NSLog(@"playvideo");

}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

/*- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}*/

-(id)initWithContentURL :(NSURL *) url
{
    self = [super initWithContentURL:url];
    if(self)
    {
    
    }
    return self;
}
-(void) setFullScreenLayout :(BOOL) state
{
    [super setWantsFullScreenLayout: state];
}
-(void) playvideo
{
   // [super moviePlayer.play];
    [super.moviePlayer play];
}
-(void) setMovieType
{
    //[super moviePlayer.movieSourceType];
    super.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft);
}

@end
