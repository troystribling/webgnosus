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
#import "MessageModel.h"
#import "AlertViewManager.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPPubSubSubscriptions.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ContactPubCell (PrivateAPI)

- (void)setPubImageSubscribed:(BOOL)sub;
- (void)loadSubscription;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ContactPubCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize itemLabel;
@synthesize itemImage;
@synthesize serviceItem;
@synthesize account;
@synthesize subscriptions;

//===================================================================================================================================
#pragma mark ContactPubCell

//===================================================================================================================================
#pragma mark ContactPubCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setPubImageSubscribed:(BOOL)sub {
    if (sub) {
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-green.png"]; 
    } else {
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-grey.png"]; 
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadSubscription {
    self.subscriptions = [SubscriptionModel findAllByAccount:self.account andNode:self.serviceItem.node];
}

//===================================================================================================================================
#pragma mark TouchImageView Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)pubSubImage {
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    if ([self.subscriptions count] > 0) {
        for(int i=0; i < [self.subscriptions count]; i++) {
            SubscriptionModel* subscription = [self.subscriptions objectAtIndex:i];
            [XMPPPubSubSubscriptions unsubscribe:client JID:[XMPPJID jidWithString:self.serviceItem.service] node:self.serviceItem.node andSubId:subscription.subId];
        }
        [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Unsubscribing"];
    } else {
        [XMPPPubSubSubscriptions subscribe:client JID:[XMPPJID jidWithString:self.serviceItem.service] node:self.serviceItem.node];
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
    [self setPubImageSubscribed:YES];
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
    [self setPubImageSubscribed:NO];
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
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    [self loadSubscription];
    if ([self.subscriptions count] > 0) {
        [self setPubImageSubscribed:YES];
    } else {
        [self setPubImageSubscribed:NO];
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
