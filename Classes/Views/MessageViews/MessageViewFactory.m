//
//  MessageViewFactory.m
//  webgnosus
//
//  Created by Troy Stribling on 2/27/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MessageViewFactory.h"
#import "BodyMessageView.h"
#import "EntryMessageView.h"
#import "XDataScalarMessageView.h"
#import "XDataArrayMessageView.h"
#import "XDataHashMessageView.h"
#import "XDataArrayHashMessageView.h"
#import "XMPPxData.h"
#import "MessageModel.h"
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagCommandDataType {
    CommandDataUnknown,
    CommandDataScalar,
    CommandDataArray,
    CommandDataHash,
    CommandDataArrayHash,
} CommandDataType;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageViewFactory (PrivateAPI)

+ (UIView*)viewForXDataMessage:(MessageModel*)message;
+ (CommandDataType)identifyXDataType:(XMPPxData*)data;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageViewFactory

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark MessageViewFactory

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIView*)viewForMessage:(MessageModel*)message {        
	UIView* view = nil;
    if (message.textType ==  MessageTextTypeCommandXData) {
        view = [self viewForXDataMessage:message];
    } else if (message.textType ==  MessageTextTypeEventxData) {
        view = [self viewForXDataMessage:message];
    } else if (message.textType ==  MessageTextTypeEventEntry) {
        view = [EntryMessageView viewForMessage:message];
    } else if (message.textType ==  MessageTextTypeEventText) {
        view = [BodyMessageView  viewForMessage:message];
    } else {
        view = [BodyMessageView  viewForMessage:message];
    }
	return view;
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIView*)viewForXDataMessage:(MessageModel*)message {
	UIView* view = nil;
    XMPPxData* data = [message parseXDataMessage];
    CommandDataType dataType = [self identifyXDataType:data];
    switch (dataType) {
        case CommandDataUnknown:
            view = [BodyMessageView  viewForMessage:message];
            break;
        case CommandDataScalar:
            view = [XDataScalarMessageView viewForMessage:message];
            break;
        case CommandDataArray:
            view = [XDataArrayMessageView viewForData:data];
            break;
        case CommandDataHash:
            view = [XDataHashMessageView viewForData:data];
            break;
        case CommandDataArrayHash:
            view = [XDataArrayHashMessageView viewForData:data];
            break;
    }
    return view;
}

//===================================================================================================================================
#pragma mark MessageViewFactory (PrivateAPI)

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CommandDataType)identifyXDataType:(XMPPxData*)data {
    CommandDataType dataType = CommandDataUnknown;
    if (data) {
        NSInteger fields = [[data fields] count];
        NSInteger items = [[data items] count];
        if (fields == 1) {
            NSInteger vals = [[[[data fields] objectAtIndex:0] lastObject] count];
            if (vals > 1) {
                dataType = CommandDataArray;
            } else {
                dataType = CommandDataScalar;
            }
        } else if (fields > 1) {
            dataType = CommandDataHash;
        } else if (items > 0) {
            dataType = CommandDataArrayHash;
        }
    }    
    return dataType;
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
