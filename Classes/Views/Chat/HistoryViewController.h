//
//  HistoryViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 1/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* messages;
    NSMutableArray* accounts;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NSMutableArray* messages;
@property (nonatomic, retain) NSMutableArray* accounts;

//-----------------------------------------------------------------------------------------------------------------------------------

@end
