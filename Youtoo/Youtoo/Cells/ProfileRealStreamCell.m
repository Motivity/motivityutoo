//
//  ProfileCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileRealStreamCell.h"
#import "ItemModel.h"


@implementation ProfileRealStreamCell

@synthesize itemModel;
@synthesize delegateController;

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
   _showQuestionLabel = [[UITextView alloc] initWithFrame:CGRectMake(111.0, 17.0, 220.0, 50.0)];
	_showQuestionLabel.textAlignment = UITextAlignmentLeft;
	_showQuestionLabel.backgroundColor = [UIColor clearColor];
	_showQuestionLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _showQuestionLabel.editable = NO;
    _showQuestionLabel.scrollEnabled = NO;
    //if ( indexPath.row==0 )
    _showQuestionLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1]; //colorWithRed:0.25 green:0.8 blue:1.0 alpha:1];
    //else
      //  _showTimeLabel.textColor = [UIColor blackColor];

    //_showTimeLabel.text = [showTime objectAtIndex:indexPath.row];
	[self.contentView addSubview:_showQuestionLabel];
    
    
    
    _showNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(111.0, 8.0, 182.0, 17.0)];
	_showNameLbl.textAlignment = UITextAlignmentLeft;
	_showNameLbl.backgroundColor = [UIColor clearColor];
	_showNameLbl.font = [UIFont boldSystemFontOfSize:17.0];
	_showNameLbl.textColor = [UIColor colorWithRed:0.15 green:0.36 blue:0.50 alpha:1.0];
    //_showNameLbl.text = [showName objectAtIndex:indexPath.row];
	//[self.contentView addSubview:_showNameLbl];
    
    
    
    /*_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];
	_iconImageView.image = [UIImage imageNamed:@"image.png"];
	_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:_iconImageView];
    */
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];	
   
   // [_playButton addTarget:self action:@selector(PlayVideo:) forControlEvents:UIControlEventTouchUpInside];
	[_playButton setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    _playButton.enabled = YES;
    //_playButton.tag = indexPath.row;
    
	[self.contentView addSubview:_playButton];
   // [_playButton release];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 6.0, 87.0, 65.0)];	
	//[_playButton setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    _playButton.enabled = YES;
   // _playButton.tag = indexPath.row;
    
    [self.contentView addSubview:_playButton];
    //[_playButton release];
       
}

- (void)setItemModel:(ItemModel *)aModel
{
    if ( itemModel.storageImage!=NULL )
        NSLog(@"setItemModel:itemModel.storageImage : %@", itemModel.storageImage );
    else
        NSLog(@"setItemModel:itemModel.storageImage is NULL");
    
    if (aModel != itemModel)
	{
		[itemModel release];
		itemModel = [aModel retain];
	}
	
	//if (nil != itemModel.storageImage)
	{
		//_showQuestionLabel.text = itemModel.questionName;
        _showQuestionLabel.text = itemModel.myStreamContent;
       // _showNameLbl.text = itemModel.showName;	
        
        _playButton.tag = currRow;
        [_playButton addTarget:self.delegateController action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
 
        
        if ( nil == itemModel.storageImage )
            //_iconImageView.image = [UIImage imageNamed:@"logo.png"];
            [_playButton setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        else
            //_iconImageView.image = itemModel.storageImage;
            [_playButton setBackgroundImage:itemModel.storageImage forState:UIControlStateNormal];
	}
}
-(void) getCurrRow :(int) row
{
    currRow = row;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction) buttonPressed: (id) sender
{
   // UIButton *button = (UIButton *)sender;
    NSLog(@"Btn Tag in Video Detail Cell: %d", [sender tag]);
    
    if ([self.delegateController respondsToSelector:@selector(buttonPressed:)])
	{
        
    }
}

- (void)dealloc
{
    if ( itemModel )
        [itemModel release];
    
    [_showNameLbl release];
    [_showQuestionLabel release];
    [_iconImageView release];
    
    [super dealloc];
}

@end
