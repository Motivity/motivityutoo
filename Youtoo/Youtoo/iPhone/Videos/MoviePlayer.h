//
//  MoviePlayer.h
//  Youtoo
//
//  Created by CorpusMobileLabs on 09/10/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayer : MPMoviePlayerViewController
{
    
}

-(void) setFullScreenLayout :(BOOL) state;
-(void) playvideo;
-(void) setMovieType;

@end
