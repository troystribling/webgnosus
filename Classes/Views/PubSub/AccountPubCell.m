//
//  AccountPubCell.m
//  webgnosus
//
//  Created by Troy Stribling on 9/8/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountPubCell.h"
#import "TouchImageView.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "SubscriptionModel.h"
#import "AlertViewManager.h"
#import "GeoLocManager.h"
#import "XMPPClient.h"
#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPPubSubOwner.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountPubCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountPubCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize itemLabel;
@synthesize itemImage;
@synthesize account;
@synthesize serviceItem;

//===================================================================================================================================
#pragma mark AccountPubCell

//===================================================================================================================================
#pragma mark AccountPubCell PrivateAPI

//===================================================================================================================================
#pragma mark TouchImageView Delegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)pubSubImage {
    XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
    [XMPPPubSubOwner delete:client JID:[XMPPJID jidWithString:self.serviceItem.service] node:self.serviceItem.node];
    if ([self.serviceItem.node isEqualToString:[self.account geoLocPubSubNode]]) {
        GeoLocManager* geoLoc = [GeoLocManager instance];
        [geoLoc removeUpdateDelegatesForAccount:[self account]];
        [geoLoc stopIfNotUpdating];
    }
    [AlertViewManager showActivityIndicatorInView:self.window withTitle:@"Deleting"];
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
        self.itemImage.image = [UIImage imageNamed:@"service-pubsub-node-blue.png"]; 
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
