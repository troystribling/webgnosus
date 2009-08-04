//
//  RosterCell.m
//  webgnosus_client
//
//  Created by Troy Stribling on 1/20/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "RosterCell.h"
#import "RosterItemModel.h"
#import "ContactModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RosterCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RosterCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize jidLabel;
@synthesize activeImage;

//===================================================================================================================================
#pragma mark RosterCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIImage*)rosterItemImage:(RosterItemModel*)rosterItem {
    if ([rosterItem isAvailable]) {
        return [UIImage imageNamed:@"account-on-led.jpg"];
    } 
    return [UIImage imageNamed:@"account-off-led.jpg"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UIImage*)contactImage:(ContactModel*)contact {
    if ([contact hasError]) {
        return [UIImage imageNamed:@"account-error-led.jpg"];
    } else if ([RosterItemModel isJidAvailable:contact.jid]) {
        return [UIImage imageNamed:@"account-on-led.jpg"];
    } 
    return [UIImage imageNamed:@"account-off-led.jpg"];
}

//===================================================================================================================================
#pragma mark RosterCell PrivateAPI

//===================================================================================================================================
#pragma mark UITableViewCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    CGRect jidLabelRect = self.jidLabel.frame;
    if (editing) {
        jidLabelRect.size.width = kSMALL_MESSAGE_WITH_STATUS_WIDTH;
        self.activeImage.hidden = YES;
    } else {
        jidLabelRect.size.width = kLARGE_MESSAGE_WITH_STATUS_WIDTH;
        self.activeImage.hidden = NO;
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
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
