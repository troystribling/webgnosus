//
//  TouchImageView.m
//  webgnosus
//
//  Created by Troy Stribling on 10/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TouchImageView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TouchImageView (PrivateAPI)

- (void)delegateImageTouched;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TouchImageView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize delegate;

//===================================================================================================================================
#pragma mark TouchImageView

//===================================================================================================================================
#pragma mark TouchImageView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)delegateImageTouched {
    if ([self.delegate respondsToSelector:@selector(imageTouched:)]) {
        [self.delegate imageTouched:self];
    }
} 

//===================================================================================================================================
#pragma mark UIView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame andDelegate:(id)initDelegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = initDelegate;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithImage:(UIImage*)image andDelegate:(id)initDelegate {
    if (self = [super initWithImage:image]) {
        self.delegate = initDelegate;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIResponder

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self delegateImageTouched];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
