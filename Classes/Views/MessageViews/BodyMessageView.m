//
//  BodyMessageView.m
//  webgnosus
//
//  Created by Troy Stribling on 2/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "BodyMessageView.h"
#import "MessageModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BodyMessageView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BodyMessageView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark BodyMessageView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)getMessageText:(MessageModel*)message {
    return message.messageText;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CGRect)getMessageRect:(NSString*)messageText {
	CGFloat cellHeight = 20.0f;
    CGFloat width =  kDISPLAY_WIDTH;
    if (messageText) {
        CGSize textSize = {width, 20000.0f};
        CGSize size = [messageText sizeWithFont:[UIFont systemFontOfSize:kMESSAGE_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
        cellHeight = MAX(size.height, cellHeight);
    }    
	return CGRectMake(0.0f, 0.0f, width, cellHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIView*)viewForMessage:(MessageModel*)message {
    NSString* messageText = [self getMessageText:message];
    CGRect viewRect = [self getMessageRect:messageText];
    UILabel* messageView = [[UILabel alloc] initWithFrame:viewRect];
    messageView.text = messageText;
    return messageView;
}

//===================================================================================================================================
#pragma mark UITableViewCell

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
