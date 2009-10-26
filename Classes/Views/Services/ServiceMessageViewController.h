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
	IBOutlet UILabel* nodeLabel;
    NSString* node;
    MessageModel* message;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* nodeLabel;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) MessageModel* message;

@end
