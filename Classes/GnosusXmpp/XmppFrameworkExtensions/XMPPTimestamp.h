//
//  XMPPTimestamp.h
//  webgnosus
//
//  Created by Troy Stribling on 7/31/10.
//  Copyright 2010 Plan-B Reserach. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface XMPPTimestamp : NSObject 

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSDateFormatter*)dateFormatter;
+ (NSString*)dateToString:(NSDate*)val;
+ (NSDate*)stringToDate:(NSString*)val;

@end
