//
//  FloatingBar.h
//  iGivings
//
//  Created by Ihor Xom on 5/3/10.
//  Copyright 2010 Everlasting Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatingBar : UIViewController
{
	UIScrollView			*_scrollView;
	NSArray					*_itemImages;
	NSMutableArray			*_buttonsArray;
	NSInteger				_selectedControlItem;
	NSInteger				_selectedBarItem;
	UIButton				*_leftArrow;
	UIButton				*_rightArrow;
}
@property NSInteger selectedBarItem;

@end
