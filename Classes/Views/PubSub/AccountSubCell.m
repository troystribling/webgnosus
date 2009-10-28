//
//  AccountSubCell.m
//  webgnosus
//
//  Created by Troy Stribling on 9/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountSubCell.h"
#import "TouchImageView.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "SubscriptionModel.h"
#import "ServiceItemModel.h"
#import "MessageModel.h"
#import "AlertViewManager.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountSubCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountSubCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize itemLabel;
@synthesize messageCountLabel;
@synthesize jidLabel;
@synthesize messageCountImage;
@synthesize itemImage;
@synthesize subscription;
@synthesize account;

//===================================================================================================================================
#pragma mark AccountSubCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUnreadMessageCount {
    NSInteger msgCount = [MessageModel countUnreadEventsByNode:self.subscription.node andAccount:self.account];
    if (msgCount == 0) {
        self.messageCountImage.hidden = YES;
        self.messageCountLabel.hidden = YES;
    } else {
        self.messageCountImage.hidden = NO;
        self.messageCountLabel.hidden = NO;
        self.messageCountLabel.text = [NSString stringWithFormat:@"%d", msgCount];
    }
}

//===================================================================================================================================
#pragma mark AccountSubCell PrivateAPI

//===================================================================================================================================
#pragma mark TouchImageView Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)pubSubImage {
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    [XMPPPubSubSubscriptions unsubscribe:client JID:[XMPPJID jidWithString:self.subscription.service] node:self.subscription.node];
    [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Unsubscribing"];
}

//===================================================================================================================================
#pragma mark UITableViewCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//===================================================================================================================================
#pragma mark UIView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)coder { 
	if (self = [super initWithCoder:coder]) { 
        self.itemImage = [[TouchImageView alloc] initWithFrame:CGRectMake(20.0f, 16.0f, 30.0f, 30.0f) andDelegate:self];
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-green.png"]; 
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    [self addSubview:self.itemImage];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
