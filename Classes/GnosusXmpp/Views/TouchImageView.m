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
@synthesize viewName;

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
+ (TouchImageView*)viewWithFrame:(CGRect)_frame andDelegate:(id)_delegate {
    return [[[TouchImageView alloc] initWithFrame:_frame andDelegate:_delegate] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (TouchImageView*)viewWithFrame:(CGRect)_frame name:(NSString*)_viewName andDelegate:(id)_delegate {
    return [[[TouchImageView alloc] initWithFrame:_frame name:_viewName andDelegate:_delegate] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)_frame {
    if (self = [super initWithFrame:_frame]) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)_frame andDelegate:(id)_delegate {
    if (self = [self initWithFrame:_frame]) {
        self.delegate = _delegate;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)_frame name:(NSString*)_viewName andDelegate:(id)_delegate {
    if (self = [self initWithFrame:_frame andDelegate:_delegate]) {
        self.viewName = _viewName;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithImage:(UIImage*)_image andDelegate:(id)_delegate {
    if (self = [super initWithImage:_image]) {
        self.delegate = _delegate;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithImage:(UIImage*)_image name:(NSString*)_viewName andDelegate:(id)_delegate {
    if (self = [self initWithImage:_image andDelegate:_delegate]) {
        self.viewName = _viewName;
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
