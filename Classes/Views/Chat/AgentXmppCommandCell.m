//
//  AgentXmppCommandCell.m
//  webgnosus
//
//  Created by Troy Stribling on 4/20/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AgentXmppCommandCell.h"
#import "CellUtils.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AgentXmppCommandCell (PrivateAPI)

+ (AgentXmppCommandCell*)createRosterCellFromNib;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AgentXmppCommandCell

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize commandLabel;

//===================================================================================================================================
#pragma mark AgentXmppCommandCell

//===================================================================================================================================
#pragma mark AgentXmppCommandCell PrivateAPI

//===================================================================================================================================
#pragma mark UITableViewCell

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView *)tableView cellWithText:(NSString*)cellText {        
    AgentXmppCommandCell* cell = (AgentXmppCommandCell*)[CellUtils createCell:[AgentXmppCommandCell class] forTableView:tableView];
    cell.commandLabel.text = cellText;
    return cell;
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
