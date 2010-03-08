//
//  RresourceCell.m
//  webgnosus
//
//  Created by Troy Stribling on 3/7/10.
//  Copyright 2010 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ResourceCell.h"
#import "AccountModel.h"
#import "MessageModel.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ResourceCell (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ResourceCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize resourceLabel;
@synthesize messageCountLabel;
@synthesize messageCountImage;
@synthesize jid;

//===================================================================================================================================
#pragma mark ResourceCell PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUnreadMessageCount:(AccountModel*)account {
    NSInteger msgCount = [MessageModel countUnreadMessagesByFromJid:[self.jid full] andAccount:account];
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
#pragma mark ResourceCell PrivateAPI

//===================================================================================================================================
#pragma mark UITableViewCell

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
