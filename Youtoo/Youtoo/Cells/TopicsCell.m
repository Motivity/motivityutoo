//
//  ScheduleCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 29/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "TopicsCell.h"
#import "ItemModel.h"


@implementation TopicsCell
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
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 8.0, 290.0, 60.0)];
	_questionLabel.textAlignment = UITextAlignmentLeft;
	_questionLabel.backgroundColor = [UIColor clearColor];
	_questionLabel.font = [UIFont boldSystemFontOfSize:12.0];
    _questionLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
    _questionLabel.numberOfLines = 4;
    _questionLabel.text = @"";
	[self.contentView addSubview:_questionLabel];

	_showLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 75.0, 290.0, 25.0)];
	_showLabel.textAlignment = UITextAlignmentLeft;
	_showLabel.backgroundColor = [UIColor clearColor];
	_showLabel.font = [UIFont boldSystemFontOfSize:20.0];
	_showLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
   _showLabel.text = @"";
	[self.contentView addSubview:_showLabel];
    
    _episodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 100.0, 250.0, 17.0)];
	_episodeLabel.textAlignment = UITextAlignmentLeft;
	_episodeLabel.backgroundColor = [UIColor clearColor];
	_episodeLabel.font = [UIFont boldSystemFontOfSize:12.0];
	_episodeLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
   _episodeLabel.text = @"";
	[self.contentView addSubview:_episodeLabel];
    
}
- (void)setItemModel:(ItemModel *)aModel
{
	if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
	}
	
    //_questionLabel.text = @"IF YOU COULD IMPROVE ANY OBJECT, WHICH ONE WOULD IT BE AND WHAT WOULD YOU CHANGE ABOUT IT?";
    //_showLabel.text = @"Kipkay TV";
    //_episodeLabel.text = @"Kipkay TV Episode 5";
    
    NSLog(@"itemModel.questionName: %@", itemModel.questionName);
    NSLog(@"itemModel.showName: %@", itemModel.showName);
    NSLog(@"itemModel.episodeName: %@", itemModel.episodeName);
    
	_questionLabel.text = itemModel.questionName;
    _showLabel.text = itemModel.showName;
    _episodeLabel.text = itemModel.episodeName;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_questionLabel release];
    [_showLabel release];
    [_episodeLabel release];
    if ( itemModel ) 
        [itemModel release];
    
    [super dealloc];
}

@end
