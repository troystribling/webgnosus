//
//  ServiceViewController.h
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class AccountModel;
@class ServiceItemModel;
@class ServiceModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceViewController : UITableViewController {
	UIBarButtonItem* editAccountsButton;
	UIBarButtonItem* searchServiceButton;
    ServiceViewController* rootServiceViewController;
    NSMutableArray* serviceItems;
    NSString* node;
    NSString* service;
    AccountModel* account;
    ServiceItemModel* selectedItem;
    ServiceModel* parentService;
    NSMutableArray* sectionViewControllers;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIBarButtonItem* editAccountsButton;
@property (nonatomic, retain) UIBarButtonItem* searchServiceButton;
@property (nonatomic, retain) ServiceViewController* rootServiceViewController;
@property (nonatomic, retain) NSMutableArray* serviceItems;
@property (nonatomic, retain) NSString* node;
@property (nonatomic, retain) NSString* service;
@property (nonatomic, retain) AccountModel* account;
@property (nonatomic, retain) ServiceItemModel* selectedItem;
@property (nonatomic, retain) ServiceModel* parentService;
@property (nonatomic, retain) NSMutableArray* sectionViewControllers;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setService:(NSString*)initService andNode:(NSString*)initNode;

@end
