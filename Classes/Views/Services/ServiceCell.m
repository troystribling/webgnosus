//
//  ServiceCell.m
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceCell.h"
#import "TouchImageView.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "SubscriptionModel.h"
#import "ServiceModel.h"
#import "AlertViewManager.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPPubSubOwner.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceCell (PrivateAPI)

- (UIImage*)serviceImage;
- (void)setPubImage;
- (void)loadSubscription;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize itemLabel;
@synthesize itemImage;
@synthesize service;
@synthesize account;
@synthesize subscriptions;
@synthesize enableImageTouch;

//===================================================================================================================================
#pragma mark ServiceCell

//===================================================================================================================================
#pragma mark ServiceCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setPubImage {
    if ([self.service.node hasPrefix:[self.account pubSubRoot]]) {
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-blue.png"]; 
    } else if ([self.subscriptions count] > 0) {
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-green.png"]; 
    } else {
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-grey.png"]; 
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadSubscription {
    self.subscriptions = [SubscriptionModel findAllByAccount:self.account andNode:self.service.node];
}

//===================================================================================================================================
#pragma mark TouchImageView Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)pubSubImage {
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
    XMPPJID* jid = [XMPPJID jidWithString:self.service.jid];
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    if ([self.service.node hasPrefix:[self.account pubSubRoot]]) {
        [XMPPPubSubOwner delete:client JID:jid node:self.service.node];
        [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Deleting"];
    } else if ([self.subscriptions count] > 0) {
        for(int i=0; i < [self.subscriptions count]; i++) {
            SubscriptionModel* subscription = [self.subscriptions objectAtIndex:i];
            [XMPPPubSubSubscriptions unsubscribe:client JID:jid node:self.service.node andSubId:subscription.subId];
        }
        [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Unsubscribing"];
    } else {
        [XMPPPubSubSubscriptions subscribe:client JID:jid node:self.service.node];
        [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Subscribing"];
    }
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self loadSubscription];
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [AlertViewManager showAlert:@"Subscription Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubSubscribeResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self loadSubscription];
    [self setPubImage];
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self loadSubscription];
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [AlertViewManager showAlert:@"Unsubscribe Failed"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceivePubSubUnsubscribeResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self loadSubscription];
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [self setPubImage];
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
        self.itemImage = [[TouchImageView alloc] initWithFrame:CGRectMake(20.0f, 7.0f, 30.0f, 30.0f)];
        self.enableImageTouch = NO;
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    if (self.enableImageTouch) {
        self.itemImage.delegate = self;
        [self loadSubscription];
        [self setPubImage];
    }
    [self addSubview:self.itemImage];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
