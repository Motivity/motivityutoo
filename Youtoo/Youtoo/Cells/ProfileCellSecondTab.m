//
//  ProfileCellSecondTab.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileCellSecondTab.h"
#import "ItemModel.h"
#import "ItemStorage.h"

@implementation ProfileCellSecondTab

@synthesize itemModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier :(int) indexPathRow
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        row = indexPathRow;
        incremBtnDataVal = 0;
        incremLblDataVal = 0;
        [self createCellLabels];
    }
    return self;
}

-(IBAction) buttonPressed: (id) sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag: %d", [sender tag]);
    
}

- (void)createCellLabels
{
	btn1 = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 80.0, 65.0)];
    //UIImageView *imageView = [UIImage imageNamed:@"avatar.png"];
    btn1.enabled = YES;
    //[btn1 setBackgroundColor:[UIColor blueColor]];
    btn1.tag = row;
    NSLog(@"btn1.tag : %d", btn1.tag );
    
    //[btn1 setImage:aModel.storageImage forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn1];
    
    lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 73.0, 220.0, 25.0)];
	lbl1.textAlignment = UITextAlignmentLeft;
	lbl1.backgroundColor = [UIColor clearColor];
	lbl1.font = [UIFont boldSystemFontOfSize:17.0];
    lbl1.tag = row;
	lbl1.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
	[self.contentView addSubview:lbl1];
    [lbl1 release];
   
    lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 73.0, 220.0, 25.0)];
	lbl2.textAlignment = UITextAlignmentLeft;
	lbl2.backgroundColor = [UIColor clearColor];
	lbl2.font = [UIFont boldSystemFontOfSize:17.0];
    lbl2.tag = row+100;
	lbl2.textColor = [UIColor colorWithRed:0.09 green:0.04 blue:0.0 alpha:1];
	[self.contentView addSubview:lbl2];
    [lbl2 release];
    
   btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180.0, 6.0, 80.0, 65.0)];        
    //[btn1 setBackgroundColor:[UIColor blackColor]];
    [btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = row+100;
    NSLog(@"btn1.tag : %d", btn2.tag );
    [self.contentView addSubview:btn2];
}

- (void)setItemModel:(ItemModel *)aModel
{
	if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
	}

    ItemModel *pModel;
    ItemStorage *itemStorage = [[ItemStorage alloc] init];
    if ( row==0 )
    {        
        pModel = [itemStorage.storageList objectAtIndex:(row+1)];
    }
    else
    {
        incremBtnDataVal+=2;
        incremLblDataVal+=2;
        pModel = [itemStorage.storageList objectAtIndex:incremBtnDataVal];        
    }
	//if (nil != itemModel.storageImage)
	{
        if ( nil == itemModel.storageImage )
        {
            [btn1 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
            [btn2 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        }
        else
        {
            if ( row==0 )
            {
                [btn1 setImage:itemModel.storageImage forState:UIControlStateNormal];            
                [btn2 setImage:pModel.storageImage forState:UIControlStateNormal];
            }
            else
            {
                [btn1 setImage:pModel.storageImage forState:UIControlStateNormal];
                
                ItemModel *pTempModel;
                pTempModel = [itemStorage.storageList objectAtIndex:(incremBtnDataVal+1) ];
                [btn2 setImage:pTempModel.storageImage forState:UIControlStateNormal];
            }            
        }
        if ( itemModel.showName==NULL )
           lbl1.text = @"Show Name";
        else
        {            
            if ( row==0 )
            {
                lbl1.text = itemModel.showName;
                lbl2.text = pModel.showName;
            }
            else
            {
                lbl1.text = pModel.showName;
                
                ItemModel *pTempLblModel;
                pTempLblModel = [itemStorage.storageList objectAtIndex:(incremLblDataVal+1) ];
                
                [btn2 setImage:pTempLblModel.storageImage forState:UIControlStateNormal];
                lbl2.text = pTempLblModel.showName;
            }
        }
        

	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [itemModel release];
    
    [super dealloc];
}

@end
