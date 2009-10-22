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
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) id delegate;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andDelegate:(id)initDelegate;
- (id)initWithImage:(UIImage*)image andDelegate:(id)initDelegate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (TouchImageView)

- (void)imageTouched:(TouchImageView*)pubSubImage;

@end
