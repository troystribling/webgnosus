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
#import "AlertViewManager.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
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

//===================================================================================================================================
#pragma mark ContactPubCell

//===================================================================================================================================
#pragma mark ContactPubCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setPubImage {
    self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-grey.png"]; 
}

//===================================================================================================================================
#pragma mark TouchImageView Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)pubSubImage {
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
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
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
        self.itemImage = [[TouchImageView alloc] initWithFrame:CGRectMake(20.0f, 5.0f, 30.0f, 30.0f) andDelegate:self];
        self.itemImage.delegate = self;
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
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
