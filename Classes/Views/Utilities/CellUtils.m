//
//  CellUtils.m
//  webgnosus
//
//  Created by Troy Stribling on 4/17/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CellUtils.h"
#import "NSObjectiPhoneAdditions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CellUtils (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CellUtils

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark CellUtils

//-----------------------------------------------------------------------------------------------------------------------------------
+ (UITableViewCell*)createCell:(Class)cellClass forTableView:(UITableView*)tableView { 
    NSString* nibName = [cellClass className];
    UITableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]; 
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator]; 
    NSObject* nibItem = nil; 
    while ((nibItem = [nibEnumerator nextObject]) != nil) { 
        if ([nibItem isKindOfClass:cellClass]) { 
            cell = (UITableViewCell*)nibItem; 
            if ([cell.reuseIdentifier isEqualToString:nibName]) 
                break; 
            else 
                cell = nil; 
        } 
    } 
	return cell; 
} 

//===================================================================================================================================
#pragma mark CellUtils PrivateAPI

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
