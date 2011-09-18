//
//  CommandFormTextMultiView.m
//  webgnosus
//
//  Created by Troy Stribling on 11/13/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandFormTextMultiView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormTextMultiView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommandFormTextMultiView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize textView;

//===================================================================================================================================
#pragma mark CommandFormTextMultiView

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)text {
    return self.textView.text;
}

//===================================================================================================================================
#pragma mark CommandFormTextMultiView PrivateAPI

//===================================================================================================================================
#pragma mark UIView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(kCOMMAND_FORM_TEXT_MULTI_BORDER, kCOMMAND_FORM_TEXT_MULTI_BORDER, frame.size.width-2*kCOMMAND_FORM_TEXT_MULTI_BORDER, frame.size.height-2*kCOMMAND_FORM_TEXT_MULTI_BORDER)] autorelease];
        self.textView.returnKeyType = UIReturnKeyDefault;
        self.textView.font = [UIFont fontWithName:@"helvetica" size:15.0f];
        [self addSubview:self.textView];
    }
    return self;
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
}

//===================================================================================================================================
#pragma mark NSObject
- (void)dealloc {
    [super dealloc];
}

@end
