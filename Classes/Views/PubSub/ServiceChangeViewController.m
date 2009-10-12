//
//  ServiceChangeViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 10/11/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ServiceChangeViewController.h"
#import "ServiceViewController.h"
#import "AlertViewManager.h"
#import "AccountModel.h"
#import "ServiceItemModel.h"
#import "XMPPPubSub.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPClientManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceChangeViewController (PrivateAPI)

- (void)failureAlert:(NSString*)message;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceChangeViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize addressTextField;
@synthesize nodeTextField;
@synthesize serviceController;
@synthesize account;

//===================================================================================================================================
#pragma mark AddPublicationViewController

//===================================================================================================================================
#pragma mark AddPublicationViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)failureAlert:(NSString*)message { 
    [AlertViewManager showAlert:@"Disco Error" withMessage:message];
}

//===================================================================================================================================
#pragma mark XMPPClientDelegate

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
	self.title = @"Change Service";
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
    if (![self.addressTextField.text isEqualToString:@""]) {
        XMPPClient* client = [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
        ServiceItemModel* item;
        if (![self.nodeTextField.text isEqualToString:@""]) {
            item = [ServiceItemModel findByService:addr];
        } else {
            item = [ServiceItemModel findByService:addr andNode:node];
        }
        [self.nodeTextField resignFirstResponder]; 
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
