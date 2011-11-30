//
//  ProfileImage.h
//  ALN
//
//  Created by Ihor Xom on 8/24/10.
//  Copyright 2010 americanlifetv. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileImage : UIImageView
{
	id	delegate;
}
@property (nonatomic, assign) id delegate;

@end
