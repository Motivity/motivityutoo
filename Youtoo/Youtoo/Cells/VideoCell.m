//
//  VideoCell.m
//  Youtoo
//
//  Created by CorpusMobileLabs on 27/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "VideoCell.h"
#import "ItemModel.h"

@implementation VideoCell

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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 05.0, 220.0, 60.0)];
	_titleLabel.textAlignment = UITextAlignmentLeft;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = [UIFont boldSystemFontOfSize:21.0];
    _titleLabel.numberOfLines = 2;
	_titleLabel.textColor = [UIColor colorWithRed:0.015 green:0.2 blue:0.26 alpha:1];
	[self.contentView addSubview:_titleLabel];
    //[_titleLabel release];
    
    episodeName = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 05.0, 220.0, 60.0)];
	episodeName.textAlignment = UITextAlignmentLeft;
	episodeName.backgroundColor = [UIColor clearColor];
	episodeName.font = [UIFont boldSystemFontOfSize:21.0];
    episodeName.numberOfLines = 2;
	episodeName.textColor = [UIColor colorWithRed:0.01 green:0.2 blue:0.26 alpha:1];
	[self.contentView addSubview:episodeName];
    //[episodeName release];

    
    UIImage *imageFromFile = [UIImage imageNamed:@"RoundedBatch.png"];    
	iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 15.0f, 65.0f,40.0f)];
	iconImageView.image = imageFromFile;
	//iconImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:iconImageView];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.0f, 13.0f, 60.0f,40.0f)];
	_countLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    [_countLabel setTextColor:[UIColor whiteColor]];
    [_countLabel setTextAlignment:UITextAlignmentCenter];
	[self.contentView addSubview:_countLabel];
    //[_countLabel release];
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
		_titleLabel.text = itemModel.showName;
		//iconImageView.image = itemModel.storageImage;
        _countLabel.text = itemModel.fameSpotCount;
        episodeName.text = itemModel.episodeName;
        
       
	}

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    if ( itemModel )
        [itemModel release];
    
    [_titleLabel release];
    [_countLabel release];
    [episodeName release];
    [iconImageView release];
    
    [super dealloc];
}


@end
