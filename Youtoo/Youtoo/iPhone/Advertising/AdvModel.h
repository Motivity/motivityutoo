//
//  AdvModel.h
//  ALN
//
//  Created by Ihor Xom on 4/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AdvModel : NSObject
{
	NSString	*text;
	NSString	*name;
	NSString	*homeTown;
	NSString	*birthDay;
	NSString	*interests;
	NSString	*moviesGenre;
	NSString	*movies;
	NSString	*imagePath;
	NSString	*advertisingPath;
    NSString	*moreinfoPath;
	NSString	*profilePath;
	UIImage		*storageImage;
	UIImage		*profileImage;
}
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *birthDay;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *homeTown;
@property (nonatomic, copy) NSString *interests;
@property (nonatomic, copy) NSString *movies;
@property (nonatomic, copy) NSString *moviesGenre;
@property (nonatomic, copy) NSString *profilePath;
@property (nonatomic, copy) NSString *advertisingPath;
@property (nonatomic, copy) NSString *moreinfoPath;
@property (nonatomic, retain) UIImage *storageImage;
@property (nonatomic, retain) UIImage *profileImage;

+ (AdvModel *)sharedAdvertising;
- (void)loadImage;
- (void)loadProfileImage;
- (void)initializeModel;

@end
