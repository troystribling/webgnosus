//
//  CommandFormView.h
//  webgnosus
//
//  Created by Troy Stribling on 11/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class XMPPIQ;
@class XMPPxData;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormView : UIView <UITextFieldDelegate,UITextViewDelegate> {
    XMPPIQ* form;
    NSMutableDictionary* formFieldViews;
    NSMutableDictionary* fields;
    UIToolbar* textViewToolBar;
    UIView* parentView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) XMPPIQ* form;
@property (nonatomic, retain) NSMutableDictionary* formFieldViews;
@property (nonatomic, retain) NSMutableDictionary* fields;
@property (nonatomic, retain) UIToolbar* textViewToolBar;
@property (nonatomic, retain) UIView* parentView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithForm:(XMPPIQ*)initForm inParentView:(UIView*)initParentView;
- (XMPPxData*)formFields;

@end
