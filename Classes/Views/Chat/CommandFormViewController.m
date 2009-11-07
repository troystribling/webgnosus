//
//  CommandFormViewController.m
//  webgnosus
//
//  Created by Troy Stribling on 11/5/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandFormViewController.h"
#import "CommandFormView.h"
#import "XMPPIQ.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"
#import "XMPPxDataField.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormViewController (PrivateAPI)

- (void)createFormView;
- (CGRect)labelRect:(NSString*)label;
- (void)titleView:(XMPPxData*)data;
- (void)instructionsView:(XMPPxData*)data;
- (void)fieldViews:(XMPPxData*)data;
- (void)textSingleView:(XMPPxDataField*)field;
- (void)textMultiView:(XMPPxDataField*)field;
- (void)textPrivateView:(XMPPxDataField*)field;
- (void)booleanView:(XMPPxDataField*)field;
- (void)listSingleView:(XMPPxDataField*)field;
- (void)jidSingleView:(XMPPxDataField*)field;
- (void)fixedView:(XMPPxDataField*)field;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommandFormViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize formScrollView;
@synthesize cancelButton;
@synthesize sendButton;
@synthesize formView;
@synthesize form;
@synthesize formFields;
@synthesize formYPos;

//===================================================================================================================================
#pragma mark CommandFormViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createFormView {
    self.formYPos = 0.0f;
    XMPPCommand* command = [self.form command];
    XMPPxData* cmdData = [command data];
    [self titleView:cmdData];
    [self instructionsView:cmdData];
    CGRect formRect = CGRectMake(0.0f, 0.0f, kCOMMAND_FORM_WIDTH, self.formYPos);
    self.formView = [[CommandFormView alloc] initWithFrame:formRect];
    self.formView.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    UIView* titleView = [self.formFields valueForKey:@"title"];
    [self.formView addSubview:titleView];
    UIView* descriptionView = [self.formFields valueForKey:@"instructions"];
    [self.formView addSubview:descriptionView];
    [self.formScrollView addSubview:self.formView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGRect)labelRect:(NSString*)label {
    CGSize textSize = {kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, 20000.0f};
    CGSize size = [label sizeWithFont:[UIFont systemFontOfSize:kMESSAGE_CELL_FONT_SIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    return CGRectMake(kCOMMAND_FORM_XPOS, kCOMMAND_FORM_YPOS+self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, size.height);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)titleView:(XMPPxData*)data {
    NSString* title = [data title];
    CGRect titleRect = [self labelRect:title];
    UILabel* titleLable = [[UILabel alloc] initWithFrame:titleRect];
    titleLable.textAlignment = UITextAlignmentCenter;
    titleLable.lineBreakMode = UILineBreakModeWordWrap;
    titleLable.text = title;
    titleLable.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    [self.formFields setValue:titleLable forKey:@"title"];
    self.formYPos =+ kCOMMAND_FORM_YPOS+titleRect.size.height;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)instructionsView:(XMPPxData*)data {
    NSString* instructions = [data instructions];
    CGRect instructionsRect = [self labelRect:instructions];
    UILabel* titleLable = [[UILabel alloc] initWithFrame:instructionsRect];
    titleLable.textAlignment = UITextAlignmentLeft;
    titleLable.lineBreakMode = UILineBreakModeWordWrap;
    titleLable.text = instructions;
    titleLable.font = [titleLable.font fontWithSize:15.0f];
    titleLable.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    [self.formFields setValue:titleLable forKey:@"instructions"];
    self.formYPos =+ kCOMMAND_FORM_YPOS+instructionsRect.size.height;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fieldViews:(XMPPxData*)data {
    NSArray* fields = [data fields];
    for (int i = 0; i < [fields count]; i++) {
        XMPPxDataField* field = [fields objectAtIndex:i];
        NSString* fieldType = [field type];
        if ([fieldType isEqualToString:@"text-single"]) {
            [self textSingleView:field];
        } else if ([fieldType isEqualToString:@"text-multi"]) {
            [self textMultiView:field];
        } else if ([fieldType isEqualToString:@"text-private"]) {
            [self textPrivateView:field];
        } else if ([fieldType isEqualToString:@"boolean"]) {
            [self booleanView:field];
        } else if ([fieldType isEqualToString:@"list-single"]) {
            [self listSingleView:field];
        } else if ([fieldType isEqualToString:@"jid-single"]) {
            [self jidSingleView:field];
        } else if ([fieldType isEqualToString:@"fixed"]) {
            [self fixedView:field];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textSingleView:(XMPPxDataField*)field{
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textMultiView:(XMPPxDataField*)field {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textPrivateView:(XMPPxDataField*)field {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)booleanView:(XMPPxDataField*)field {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)listSingleView:(XMPPxDataField*)field {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)jidSingleView:(XMPPxDataField*)field {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fixedView:(XMPPxDataField*)field {
}

//===================================================================================================================================
#pragma mark CommandFormViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)form:(XMPPIQ*)initForm inView:(UIView*)containedView {
    [[CommandFormViewController alloc] initWithNibName:@"CommandFormViewController" bundle:nil inView:containedView andForm:initForm];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)cancelButtonPressed:(id)sender {
    [self.view removeFromSuperview];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)sendButtonPressed:(id)sender {
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle inView:(UIView*)parentView andForm:(XMPPIQ*)initForm { 
	if (self = [super initWithNibName:nibName bundle:nibBundle]) { 
        self.view.frame = parentView.frame;
        self.form = initForm;
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [parentView addSubview:self.view];
	} 
	return self; 
} 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];	
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.formFields = [[NSMutableDictionary alloc] initWithCapacity:10];
    [self createFormView];
    [self.formScrollView addSubview:self.formView];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
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
#pragma mark UITableViewController

//===================================================================================================================================
#pragma mark UITableViewDeligate

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end

