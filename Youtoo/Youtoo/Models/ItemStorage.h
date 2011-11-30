//
//  ItemStorage.h
//  ALN
//
//  Created by Ihor Xom on 4/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemModel;

@interface ItemStorage : NSObject
{
	NSString			*_imageDirectoryPath;
	NSMutableArray		*_storageList;
    id threadObj;
}
@property (nonatomic, retain) NSString *imageDirectoryPath;
@property (nonatomic, retain) NSMutableArray *storageList;
@property (nonatomic, retain) id threadObj;

- (void)downloadImages;
- (void)cleanStorage;
- (void)cleanImages;
- (void)addFavoriteShow:(ItemModel *)aModel;
-(void) stopThread;

@end
