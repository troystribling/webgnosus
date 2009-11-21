//
//  XMPPPubSubUnsubscribeDelegate.h
//  webgnosus
//
//  Created by Troy Stribling on 9/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPPubSubUnsubscribeDelegate : NSObject {
    NSString* node;
    NSString* subId;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* subId;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNode:(NSString*)initNode andSubId:(NSString*)initSubId;

@end
