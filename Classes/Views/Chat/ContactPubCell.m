//
//  ContactPubCell.m
//  webgnosus
//
//  Created by Troy Stribling on 10/1/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ContactPubCell.h"
#import "TouchImageView.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "SubscriptionModel.h"
#import "AlertViewManager.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ContactPubCell (PrivateAPI)

- (void)setPubImage;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ContactPubCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize itemLabel;
@synthesize itemImage;
@synthesize serviceItem;
@synthesize account;
@synthesize subscription;

//===================================================================================================================================
#pragma mark ContactPubCell

//===================================================================================================================================
#pragma mark ContactPubCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setPubImage {
    if (self.subscription) {
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-green.png"]; 
    } else {
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-grey.png"]; 
    }
}

//===================================================================================================================================
#pragma mark TouchImageView Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)pubSubImage {
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    if (!self.subscription) {
        [XMPPPubSubSubscriptions subscribe:client JID:[XMPPJID jidWithString:self.serviceItem.service] node:self.serviceItem.node];
        [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Subscribing"];
    } else {
        [XMPPPubSubSubscriptions unsubscribe:client JID:[XMPPJID jidWithString:self.serviceItem.service] node:self.serviceItem.node];
        [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Unsubscribing"];
    }
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [AlertViewManager showAlert:@"Subscription Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self setPubImage];
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [AlertViewManager showAlert:@"Unsubscribe Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeResult:(XMPPIQ*)iq {
    [self setPubImage];
    [AlertViewManager dismissActivityIndicator];
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
        self.itemImage = [[TouchImageView alloc] initWithFrame:CGRectMake(20.0f, 7.0f, 30.0f, 30.0f) andDelegate:self];
        self.itemImage.delegate = self;
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    self.subscription = [SubscriptionModel findByAccount:self.account andNode:self.serviceItem.node];
    [self setPubImage];
    [self addSubview:self.itemImage];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
