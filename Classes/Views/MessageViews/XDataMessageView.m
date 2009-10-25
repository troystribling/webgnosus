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
+ (UIView*)viewForData:(XMPPxData*)data {
    NSMutableArray* gridArray = [self buildGridArray:data];
    NSMutableArray* labelArray = [LabelGridView buildViews:gridArray];
    LabelGridView* labelGridView = [[LabelGridView alloc] initWithLabelViews:labelArray];
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
