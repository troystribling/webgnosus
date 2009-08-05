//
//  SelectAccountViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 1/19/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SelectAccountViewController.h"
#import "AddContactViewController.h"
#import "AccountModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SelectAccountViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SelectAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize accountPickerView;
@synthesize addContactViewController;
@synthesize accounts;
@synthesize accountSelectedButton;

//===================================================================================================================================
#pragma mark SelectAccountViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)accountSelected {
	self.addContactViewController.accountLabel.text = self.addContactViewController.account.jid;
	[self.navigationController popViewControllerAnimated:YES];
}

//===================================================================================================================================
#pragma mark SelectAccountViewController PrivateAPI

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.accountSelectedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(accountSelected)];
		self.accounts = [AccountModel findAll];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Select Account";
    self.navigationItem.rightBarButtonItem = self.accountSelectedButton;
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
#pragma mark UIPickerViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSInteger count = [AccountModel count];
	return count;
}

//===================================================================================================================================
#pragma mark UIPickerViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	AccountModel *accountItem = [accounts objectAtIndex:row];
	return accountItem.jid;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.addContactViewController.account = [accounts objectAtIndex:row];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
