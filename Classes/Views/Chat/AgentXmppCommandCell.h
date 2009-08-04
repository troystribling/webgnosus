//
//  AgentXmppCommandCell.h
//  webgnosus_client
//
//  Created by Troy Stribling on 4/20/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AgentXmppCommandCell : UITableViewCell {
    IBOutlet UILabel* commandLabel;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* commandLabel;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)tableView:(UITableView *)tableView cellWithText:(NSString*)cellText;

@end
