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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceMessageViewController : UIViewController {
	IBOutlet UITextView* messageTextView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITextView* messageTextView;

@end
