//
//  SelectAfameSpotCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 23/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "SelectAfameSpotCell.h"
#import "ItemModel.h"
#import <QuartzCore/QuartzCore.h>
@implementation SelectAfameSpotCell
@synthesize itemModel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellLabels];
    
    }
    return self;
}
- (void)createCellLabels
{
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.0, 25.0, 200.0, 21.0)];
	_titleLabel.textAlignment = UITextAlignmentLeft;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	_titleLabel.textColor = [UIColor colorWithRed:0.08 green:0.19 blue:0.29 alpha:1];;
    //_titleLabel.text = @"Favorite Episode?";
	[self.contentView addSubview:_titleLabel];
	
	_questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.0, 30.0, 187.0, 90.0)];
	_questionLabel.textAlignment = UITextAlignmentLeft;
	_questionLabel.backgroundColor = [UIColor clearColor];
    [_questionLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
_questionLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
    _questionLabel.numberOfLines = 3;
   // _questionLabel.text = @"What was your favorite episode from season 1?";
	[self.contentView addSubview:_questionLabel];
    
	iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(05.0, 6.0, 107.0, 107.0)];
    [iconImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]]; 
    [iconImageView.layer setBorderWidth: 4.0];

	iconImageView.image = [UIImage imageNamed:@"logo.png"];
	iconImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:iconImageView];
}

- (void)setItemModel:(ItemModel *)aModel
{
	if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
	}
	
	//if (nil != itemModel.storageImage)
	{
		_titleLabel.text = itemModel.episodeName;
        _questionLabel.text = itemModel.questionName;
        
        if ( nil == itemModel.storageImage )
            iconImageView.image = [UIImage imageNamed:@"logo.png"];
        else
            iconImageView.image = itemModel.storageImage;
	}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_titleLabel release];
    [_questionLabel release];
    [iconImageView release];
    
    if ( itemModel )
        [itemModel release];
    
    [super dealloc];
}

@end
