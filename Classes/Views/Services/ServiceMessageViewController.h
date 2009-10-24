//
//  ServiceMessageViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 10/23/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class MessageModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceMessageViewController : UIViewController {
	IBOutlet UILabel* messageTextView;
    MessageModel* message;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* messageTextView;
@property (nonatomic, retain) MessageModel* message;

@end
