//
//  TickerShoutModel.h
//  Youtoo
//
//  Created by Subrahmanyam Chaturvedula's on 11/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TickerShoutModel : NSObject {
    
    NSString *textShout;
    NSString *shoutLink;
}

@property (nonatomic, copy) NSString *textShout;
@property (nonatomic, copy) NSString *shoutLink;


@end
