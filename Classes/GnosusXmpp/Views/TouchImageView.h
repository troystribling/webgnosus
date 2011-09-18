//
//  PubSubIndicatorView.h
//  webgnosus
//
//  Created by Troy Stribling on 10/18/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TouchImageView : UIImageView {
    id delegate;
    NSString* viewName;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSString* viewName;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)viewWithFrame:(CGRect)_frame;
+ (id)viewWithFrame:(CGRect)_frame andDelegate:(id)_delegate;
+ (id)viewWithFrame:(CGRect)_frame name:(NSString*)_viewName andDelegate:(id)_delegate;
- (id)initWithFrame:(CGRect)_frame;
- (id)initWithFrame:(CGRect)_frame andDelegate:(id)_delegate;
- (id)initWithFrame:(CGRect)_frame name:(NSString*)_viewName andDelegate:(id)_delegate;
- (id)initWithImage:(UIImage*)_image name:(NSString*)_viewName andDelegate:(id)_delegate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (TouchImageView)

- (void)imageTouched:(TouchImageView*)pubSubImage;

@end
