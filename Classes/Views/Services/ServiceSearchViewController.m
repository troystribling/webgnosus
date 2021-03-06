//
//  ServiceSearchViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceSearchViewController.h"
#import "ServiceViewController.h"
#import "AlertViewManager.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "XMPPPubSub.h"
#import "XMPPDiscoItemsQuery.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"
#import "XMPPDiscoItemsServiceResponseDelegate.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceSearchViewController (PrivateAPI)

- (void)failureAlert:(NSString*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceSearchViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addressTextField;
@synthesize nodeTextField;
@synthesize rootServiceController;
@synthesize account;

//===================================================================================================================================
#pragma mark AddPublicationViewController

//===================================================================================================================================
#pragma mark AddPublicationViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)message { 
    [AlertViewManager showAlert:message];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//===================================================================================================================================
#pragma mark XMPPClientDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsServiceResult:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    self.rootServiceController.service = self.addressTextField.text;
    if ([self.nodeTextField.text isEqualToString:@""]) {
        self.rootServiceController.node = nil;
    } else {
        self.rootServiceController.node = self.nodeTextField.text;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)xmppClient:(XMPPClient*)client didReceiveDiscoItemsServiceError:(XMPPIQ*)iq {
    [AlertViewManager dismissActivityIndicator];
    [self failureAlert:@"Disco Failed"];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Search Service";
	self.account = [AccountModel findFirstDisplayed];
	self.addressTextField.returnKeyType = UIReturnKeyDone;
    self.addressTextField.delegate = self;
	self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.nodeTextField.returnKeyType = UIReturnKeyDone;
    self.nodeTextField.delegate = self;
	self.nodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.addressTextField becomeFirstResponder]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [[XMPPClientManager instance] delegateTo:self forAccount:self.account];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//===================================================================================================================================
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString* addr = self.addressTextField.text;
    NSString* node = self.nodeTextField.text;
    [textField resignFirstResponder]; 
    if (![self.addressTextField.text isEqualToString:@""]) {
        NSInteger count = [ServiceItemModel countByService:addr andParentNode:node];
        if (count == 0) {
            XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account];
            [XMPPDiscoItemsQuery get:client JID:[XMPPJID jidWithString:addr] node:node andDelegateResponse:[XMPPDiscoItemsServiceResponseDelegate delegate]];
            [AlertViewManager showActivityIndicatorInView:self.view.window withTitle:@"Service Disco"];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        [self failureAlert:@"Address Required"];
    }
	return NO; 
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
