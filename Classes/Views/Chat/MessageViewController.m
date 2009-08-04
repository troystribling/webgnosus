//
//  MessageViewController.m
//  webgnosus_client
//
//  Created by Troy Stribling on 2/25/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MessageViewController.h"
#import "MessageModel.h"
#import "AccountModel.h"

#import "XMPPClientManager.h"
#import "XMPPClient.h"
#import "XMPPJID.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MessageViewController (PrivateAPI)

- (void)messageDidChange:(NSNotification *)notif;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MessageViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize messageView;
@synthesize sendMessageButton;
@synthesize account;
@synthesize partner;

//===================================================================================================================================
#pragma mark MessageViewController

//===================================================================================================================================
#pragma mark MessageViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)sendMessageButtonWasPressed:(id)sender {
    NSString* enteredMessageText = self.messageView.text;
    if (![enteredMessageText isEqualToString:@""]) {
        MessageModel* model = [[MessageModel alloc] init];
        model.messageText = enteredMessageText;
        model.accountPk = self.account.pk;
        model.toJid = [self.partner fullJID];
        model.fromJid = [self.account fullJID];
        model.createdAt = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        [model insert];
        [model release];
        XMPPClient* xmppClient = [[XMPPClientManager instance] xmppClientForAccount:self.account];
        XMPPJID* partnerJID = [XMPPJID jidWithString:[self.partner fullJID]];
        [xmppClient sendMessage:enteredMessageText toJID:partnerJID];
    }    
    [self.messageView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}	

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)messageDidChange:(NSNotification *)notif {
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [self.messageView becomeFirstResponder];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [[XMPPClientManager instance] xmppClientForAccount:self.account andDelegateTo:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDidChange:) name:UITextViewTextDidChangeNotification
                                               object:self.view.window];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
    [[XMPPClientManager instance] removeXMPPClientDelegate:self forAccount:self.account];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
#pragma mark XMPPClientDelegate

//===================================================================================================================================
#pragma mark UITextViewDelegate

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

