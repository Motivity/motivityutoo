//
//  ProfileCell.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "ProfileCell.h"
#import "ItemModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProfileCell

@synthesize itemModel;
@synthesize getCurrRow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier:(int) currRow
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        getCurrRow = 0;
        [self createCellLabels :currRow];
    }
    return self;
}
- (void)createCellLabels :(int) currRow
{
   _showTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(108.0, 0.0, 220.0, 45.0)];
	_showTimeLabel.textAlignment = UITextAlignmentLeft;
	_showTimeLabel.backgroundColor = [UIColor clearColor];
	_showTimeLabel.font = [UIFont boldSystemFontOfSize:28.0];
    //if ( indexPath.row==0 )
    if ( currRow==0 )
        _showTimeLabel.textColor = [UIColor colorWithRed:0.0 green:0.50 blue:0.76 alpha:1];
    else
        _showTimeLabel.textColor = [UIColor colorWithRed:0.08 green:0.19 blue:0.29 alpha:1];

    //_showTimeLabel.text = [showTime objectAtIndex:indexPath.row];
	[self.contentView addSubview:_showTimeLabel];
    
    
    _showNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(108.0, 30.0, 220.0, 60.0)];
	_showNameLbl.textAlignment = UITextAlignmentLeft;
	_showNameLbl.backgroundColor = [UIColor clearColor];
    //_showNameLbl.scrollEnabled = NO;
    _showNameLbl.numberOfLines = 2;
	_showNameLbl.font = [UIFont boldSystemFontOfSize:21.0];
	_showNameLbl.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
    //_showNameLbl.text = [showName objectAtIndex:indexPath.row];
	[self.contentView addSubview:_showNameLbl];
    //[_showNameLbl setEditable:NO];

    

    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 10.0, 90.0, 80.0)];
	_iconImageView.image = [UIImage imageNamed:@"image.png"];
	//_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // adding border to the first row of the imageView
    if ( currRow==0 )
    {
        [_iconImageView.layer setBorderColor: [[UIColor colorWithRed:0.0 green:0.50 blue:0.76 alpha:1.0] CGColor]];
        [_iconImageView.layer setBorderWidth: 3.0];
        
        _onAirLbl = [[UILabel alloc] initWithFrame:CGRectMake(108.0, 60.0, 150.0, 60.0)];
        _onAirLbl.textAlignment = UITextAlignmentLeft;
        _showNameLbl.numberOfLines = 0;
        _onAirLbl.backgroundColor = [UIColor clearColor];
        _onAirLbl.text = @"(on air now)";
        _onAirLbl.font = [UIFont boldSystemFontOfSize:21.0];
        _onAirLbl.textColor = [UIColor colorWithRed:0.0 green:0.50 blue:0.76 alpha:1];
        [self.contentView addSubview:_onAirLbl];
    }
    else
    {
        [_iconImageView.layer setBorderColor: [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor]];
        [_iconImageView.layer setBorderWidth: 4.0];     
        
    }
    
	[self.contentView addSubview:_iconImageView];
        
}
-(void) setCurrRow :(int) currrow
{
    getCurrRow = 0;
    getCurrRow = currrow;
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
		_showTimeLabel.text = itemModel.showTime;
        _showNameLbl.text = itemModel.showName;	
       // if ( getCurrRow==0 )
        {
            /*NSString *tempTxt = [NSString stringWithFormat:@"%@", @""];
            
            for (int i=0; i<[itemModel.showName length] ; i++)
            {
                tempTxt = [tempTxt stringByAppendingString:@" "];
            }
            NSString *tempStr;
            tempStr = [ NSString stringWithFormat:@"%@", tempTxt];
            tempStr = [ tempStr stringByAppendingString:@"(on air now)"];
            
            _onAirLbl.text = tempStr;
            */
            //CGSize maximumLabelSize = CGSizeMake(296,9999);
            //CGSize expectedLabelSize = [@"(on air now)" sizeWithFont:_showNameLbl.font 
                          //                    constrainedToSize:maximumLabelSize 
                            //                      lineBreakMode:_showNameLbl.lineBreakMode]; 
           // UILabel *newLabel = [self createDynamicLabel:responseDrugInfo.GenName
             //                               contentFrame:CGRectMake(lblGenericName.frame.origin.x + lblGenericName.frame.size.width, lblGenericName.frame.origin.y, lblGenericName.frame.size.width, lblGenericName.frame.size.height) 
               //                                    color:[UIColor customisedlightgreysColor] 
                 //                                   font:[UIFont regular14]];
            // UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(_showNameLbl.frame.origin.x+_showNameLbl.frame.size.width, _showNameLbl.frame.origin.y, 100, 45)];
            
            /*UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(_showNameLbl.frame.origin.x+[_showNameLbl.text length] , _showNameLbl.frame.origin.y, 100, 45)];
            newLabel.textAlignment = UITextAlignmentLeft;
            newLabel.backgroundColor = [UIColor clearColor];
            newLabel.numberOfLines = 2;
            newLabel.font = [UIFont boldSystemFontOfSize:21.0];
            newLabel.textColor = [UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
            newLabel.text = @"(on air now)";
            [self.contentView addSubview:newLabel ];*/
        }
        
        if ( nil == itemModel.storageImage )
            _iconImageView.image = [UIImage imageNamed:@"logo.png"];
        else
		_iconImageView.image = itemModel.storageImage;
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
    
    [_showNameLbl release];
    [_showTimeLabel release];
    [_iconImageView release];
    
    [super dealloc];
}

@end
