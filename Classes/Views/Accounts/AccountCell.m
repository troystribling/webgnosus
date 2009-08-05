//
//  AccountCell.m
//  webgnosus
//
//  Created by Troy Stribling on 1/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountCell.h"
#import "AccountsViewController.h"
#import "AccountModel.h"
#import "XMPPClientManager.h"
#import "ModelUpdateDelgate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidLabel;
@synthesize accountsViewController;
@synthesize connectedImage;

//===================================================================================================================================
#pragma mark AccountCell

//===================================================================================================================================
#pragma mark AccountCell PrivateAPI

//===================================================================================================================================
#pragma mark UITableViewCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    CGRect jidLabelRect = self.jidLabel.frame;
    if (editing) {
        jidLabelRect.size.width = kSMALL_MESSAGE_WITH_STATUS_WIDTH;
        self.connectedImage.hidden = YES;
    } else {
        jidLabelRect.size.width = kLARGE_MESSAGE_WITH_STATUS_WIDTH;
        self.connectedImage.hidden = NO;
    }
    self.jidLabel.frame = jidLabelRect;
    [super setEditing:editing animated:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//===================================================================================================================================
#pragma mark UIView

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
