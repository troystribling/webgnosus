//
//  XDataScalarMessageView.m
//  webgnosus
//
//  Created by Troy Stribling on 10/24/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "XDataScalarMessageView.h"
#import "MessageModel.h"
#import "XMPPxData.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataScalarMessageView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XDataScalarMessageView

//===================================================================================================================================
#pragma mark XDataScalarMessageView

//===================================================================================================================================
#pragma mark XDataScalarMessageView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)getMessageText:(MessageModel*)message {
    XMPPxData* data = [message parseXDataMessage];
    NSArray* fields = [data fieldsToArrayOfHashes];
    NSString* scalar = @"empty";
    if ([fields count] > 0) {
        scalar = [[[fields lastObject] lastObject] lastObject];
    }    
    return scalar;
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
