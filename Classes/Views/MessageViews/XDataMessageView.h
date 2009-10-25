//
//  XDataMessageView.h
//  webgnosus
//
//  Created by Troy Stribling on 4/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class LabelGridView;
@class XMPPxData;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XDataMessageView : NSObject {
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)humanizeString:(NSString*)nonHuman;
+ (NSString*)stringifyArray:(NSArray*)stringArray;
+ (UIView*)viewForData:(XMPPxData*)data;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (XDataMessageView)

+ (NSMutableArray*)buildGridArray:(XMPPxData*)data;
+ (void)initLabelGridView:(LabelGridView*)labelGridView;

@end

