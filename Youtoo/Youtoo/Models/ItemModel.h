//
//  ItemModel.h
//  ALN
//
//  Created by Ihor Xom on 4/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemModel : NSObject
{
	BOOL	isBlog;
	NSString *showID;
	NSString *title;
	NSString *description;
	NSString *showDate;
	NSString *showTime;
	NSString *summary;
	NSString *airDate;
	NSString *videoPath;
	NSString *line1;
	NSString *line2;
	NSString *imagePath;
	NSString *authorName;
	UIImage *storageImage;
	NSString *preRollVideoPath;
	NSString *postRollVideoPath;
	NSString *preRolltitle;
	NSString *postRolltitle;
    NSString *checkedInCount;
    NSString *likedCount;
     NSString *scheduleShowId;
    NSString *episodeName;
    NSString *episodeStart;
       NSString *showName;
    NSString *questionName;
    NSString *episodeid;
    NSString *fameSpotCount;
    NSString *friendAvatar;
    NSString *friendName;
    NSString *friendUserID;
     NSString *friendCredit;
      NSString *questionID;
    NSString *myStreamContent;
    NSString *videoID;
    NSString *videoImagePath;
    NSString *avatarImagePath;
    NSString *favImagePath;
    NSString *mystreamVideoThumbnail;
    NSString *followCount;
}
@property BOOL isBlog;
@property (nonatomic, copy) NSString *avatarImagePath;
@property (nonatomic, copy) NSString *myStreamContent;
@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *friendCredit;
@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *friendUserID;
@property (nonatomic, copy) NSString *showID;
@property (nonatomic, copy) NSString *friendAvatar;
@property (nonatomic, copy) NSString *friendName;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *fameSpotCount;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *showDate;
@property (nonatomic, copy) NSString *showTime;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *airDate;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *line1;
@property (nonatomic, copy) NSString *line2;
@property (nonatomic, retain) NSString *authorName;
@property (nonatomic, retain) UIImage *storageImage;
@property (nonatomic, copy) NSString *preRollVideoPath;
@property (nonatomic, copy) NSString *postRollVideoPath;
@property (nonatomic, copy) NSString *preRolltitle;
@property (nonatomic, copy) NSString *postRolltitle;
@property (nonatomic, copy) NSString *checkedInCount;
@property (nonatomic, copy) NSString *likedCount;
@property (nonatomic, copy) NSString *followCount;
@property (nonatomic, copy)   NSString *scheduleShowId;
@property (nonatomic, copy)   NSString *episodeName;
@property (nonatomic, copy)   NSString *episodeStart;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, copy)   NSString *questionName;
@property (nonatomic, copy) NSString *episodeid;
@property (nonatomic, copy) NSString *videoImagePath;
@property (nonatomic, copy) NSString *favImagePath;
@property (nonatomic, copy)  NSString *mystreamVideoThumbnail;
- (id)initWithDict:(NSDictionary *)aDict;
- (void)downloadImage;

@end
