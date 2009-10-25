//
//  XDataMessageView.m
//  webgnosus
//
//  Created by Troy Stribling on 4/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataMessageView.h"
#import "LabelGridView.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "CellUtils.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataMessageView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataMessageView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize titleLabel;

//===================================================================================================================================
#pragma mark XDataMessageView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)humanizeString:(NSString*)nonHuman {
    return [nonHuman stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)stringifyArray:(NSArray*)stringArray {
    NSString* stringified;
    stringified = [stringArray componentsJoinedByString:@","];
    return stringified;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIView*)viewForMessage:(MessageModel*)message {
    NSMutableArray* gridArray = [self buildGridArray:data];
    UIFont* labelFont = [UIFont fontWithName:[NSString stringWithUTF8String:kLABEL_GRID_FONT] size:kLABEL_GRID_FONT_SIZE];
    NSMutableArray* labelArray = [LabelGridView buildViews:gridArray labelOffSet:kLABEL_OFFSET labelHeight:kLABEL_GRID_HEIGHT andFont:labelFont];
    LabelGridView* labelGridView = [[LabelGridView alloc] initWithLabelViews:labelArray borderWidth:kGRID_BORDER_WIDTH  maxWidth:kDISPLAY_WIDTH gridXOffset:kGRID_X_OFFSET andGridYOffset:kGRID_Y_OFFSET];
    [labelGridView setCellColor:[UIColor colorWithRed:0.94f green:0.94f blue:0.92f alpha:1.0f]];
    [labelGridView setBorderColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]]; 
	if ([self respondsToSelector:@selector(initLabelGridView:)] ) {
        [self initLabelGridView:labelGridView]; 
    }
    return labelGridView;
}

//===================================================================================================================================
#pragma mark XDataMessageView PrivateAPI

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
