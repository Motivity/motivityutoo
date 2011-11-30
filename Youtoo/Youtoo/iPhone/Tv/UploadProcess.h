//
//  UploadProcess.h
//  Youtoo
//
//  Created by PRABAKAR MP on 06/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMAdvertisingProtocol.h"

@class 	ASINetworkQueue;
@interface UploadProcess : UIViewController <UITextViewDelegate,NSXMLParserDelegate, CSMAdvertisingProtocol>{
    NSString				*currentVideoPath;
    NSString				*selectedSpotNameStr;    
@private
    BOOL						isNetworkOperation;
    UIProgressView *progressView;
    UIImageView *proceessVideoImg;
    
    NSTimer *updateTimer;
    int fbOrTwitterCall;
    NSString *currentElement;
     NSXMLParser	*rssParser;
    NSString				*sendResult;
    UIActivityIndicatorView *statusActivity;
    
    ASINetworkQueue *networkQueue;
}
@property(nonatomic, retain)  IBOutlet UIActivityIndicatorView *statusActivity;
@property(nonatomic, retain)  NSString				*currentVideoPath;
@property (nonatomic, copy) NSString *selectedSpotNameStr;
@property(nonatomic, retain) IBOutlet  UIImageView *proceessVideoImg;
@property (nonatomic, readwrite) int fbOrTwitterCall;
@property(nonatomic, retain) NSString *currentElement;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, copy) NSString *sendResult;
@property (nonatomic, retain) ASINetworkQueue			*networkQueue;

-(void)uploadProcessing;
-(void) sendFBTwitterStatus :(BOOL) bFBOnly;
-(void) canFBandTwitterEnabled : (BOOL) forFBOnly;
-(void) authLocallyIfNeedBes;

@end