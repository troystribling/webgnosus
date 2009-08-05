//
//  AccountOptionsController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountOptionsController.h"
#import "AddAccountViewController.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountOptionsController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountOptionsController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize nicknameTextField;
@synthesize hostTextField;
@synthesize resourceTextField;
@synthesize portTextField;
@synthesize addAccountViewController;

//===================================================================================================================================
#pragma mark AccountOptionsController

//===================================================================================================================================
#pragma mark AccountOptionsController PrivateAPI

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	self.title = @"Options";
    self.nicknameTextField.returnKeyType = UIReturnKeyDone;
    self.nicknameTextField.delegate = self;
	self.nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.hostTextField.returnKeyType = UIReturnKeyDone;
    self.hostTextField.delegate = self;
	self.hostTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.resourceTextField.returnKeyType = UIReturnKeyDone;
    self.resourceTextField.delegate = self;
	self.resourceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.portTextField.returnKeyType = UIReturnKeyDone;
    self.portTextField.delegate = self;
	self.portTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nicknameTextField becomeFirstResponder]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
    self.addAccountViewController.nickname = self.nicknameTextField.text;
	self.addAccountViewController.host = self.hostTextField.text;
	self.addAccountViewController.resource = self.resourceTextField.text;
    self.addAccountViewController.port = [self.portTextField.text integerValue];
    [self.nicknameTextField resignFirstResponder]; 
    [self.navigationController popViewControllerAnimated:YES];
	return YES; 
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
