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
@interface CommandFormView : UIView <UITextFieldDelegate> {
    XMPPIQ* form;
    NSMutableDictionary* formFields;
    CGFloat formYPos;
    UIView* parentView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) XMPPIQ* form;
@property (nonatomic, retain) NSMutableDictionary* formFields;
@property (nonatomic, assign) CGFloat formYPos;
@property (nonatomic, retain) UIView* parentView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithForm:(XMPPIQ*)initForm inParentView:(UIView*)initParentView;
- (XMPPxData*)fields;

@end
