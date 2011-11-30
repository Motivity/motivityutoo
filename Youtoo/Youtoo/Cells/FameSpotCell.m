//
//  FameSpotCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "FameSpotCell.h"
#import "ItemModel.h"
#import <QuartzCore/QuartzCore.h>
@implementation FameSpotCell
@synthesize itemModel;
@synthesize itemModel2;
@synthesize delegateController;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //currRow = row;
        //dataCount = storageCount;
        //[self createCellLabels];
    }
    return self;
}

-(void) getCurrRow :(int) row :(NSUInteger) storageCount
{
    currRow = row;
    dataCount = storageCount;
}
- (void)createCellLabels :(NSUInteger) storageCount
{
    
    dataCount = storageCount;
    
    
    NSUInteger val = (currRow)+(currRow);
    
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(37.0, 6.0, 100.0, 100.0)];
    [btn1.layer setBorderColor: [[UIColor whiteColor] CGColor]]; 
    [btn1.layer setBorderWidth: 4.0];
    
    //[btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:btn1];
    
    
    lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(37.0, 104.0, 100.0, 40.0)];

    lbl1.textAlignment = UITextAlignmentCenter;
    lbl1.numberOfLines=2;
    lbl1.backgroundColor = [UIColor clearColor];
    [lbl1 setFont:[UIFont systemFontOfSize:14.0]];
    
    //lbl1.textColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.24 alpha:1];
    lbl1.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
    [self.contentView addSubview:lbl1];
    
    
    //if ( (currRow==0 && dataCount>1) ||  currRow>0 )
    {
        
        btn2 = [[UIButton alloc] initWithFrame:CGRectMake(178.0, 6.0, 100.0, 100.0)];    
        
        [btn2.layer setBorderColor: [[UIColor whiteColor] CGColor]]; 
        [btn2.layer setBorderWidth: 4.0];
        NSLog(@"btn1.tag : %d", btn2.tag );
        [self.contentView addSubview:btn2];
        
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(178.0, 104.0, 100.0, 40.0)];
        lbl2.textAlignment = UITextAlignmentCenter;
        lbl2.numberOfLines=2;
        lbl2.backgroundColor = [UIColor clearColor];
        [lbl2 setFont:[UIFont systemFontOfSize:14.0]];
        
        //lbl2.textColor = [UIColor colorWithRed:0.08 green:0.16 blue:0.24 alpha:1];
        lbl2.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; 
        [self.contentView addSubview:lbl2];
        
        
    }
    /////////////////////////////////
    
}

- (void)setItemModel:(ItemModel *)aModel
{
	if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
	}
    
	lbl1.text = itemModel.showName;
    
    NSUInteger val = (currRow)+(currRow);
    btn1.tag = (currRow==0)?currRow: val;
    [btn1 addTarget:self.delegateController action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    lbl1.tag = currRow;   
    
	if (nil != itemModel.storageImage)
	{
        [btn1 setImage:aModel.storageImage forState:UIControlStateNormal];        
	}
    else
    {
        [btn1 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    }
}

- (void)setItemModel2:(ItemModel *)aModel
{
	//NSLog(@"dataCount: %d ; currRow: %d", dataCount, currRow);
    
    if ( (currRow==0 && dataCount>1) ||  currRow>0 )
    {
        
        if (aModel != itemModel2)
        {
            [itemModel2 release];
            itemModel2 = [aModel retain];
        }
        
        lbl2.text = itemModel2.showName;
        
        NSUInteger val = (currRow)+(currRow);
        btn2.tag = (currRow==0)?(currRow+1):val+1;
        [btn2 addTarget:self.delegateController action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        lbl2.tag = currRow+1; 
        
        if (nil != itemModel.storageImage)
        {
            [btn2 setImage:itemModel2.storageImage forState:UIControlStateNormal];
        }
        else
        {
            [btn2 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        }
        
    }
}

-(IBAction) buttonPressed: (id) sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag in Video Detail Cell: %d", [sender tag]);
    
    if ([self.delegateController respondsToSelector:@selector(buttonPressed:)])
	{
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    [lbl1 release];
    [lbl2 release];
    [btn1 release];
    [btn2 release];
    if ( itemModel )
        [itemModel release];
    if ( itemModel2 )
        [itemModel2 release];

    
    [super dealloc];
}

@end
