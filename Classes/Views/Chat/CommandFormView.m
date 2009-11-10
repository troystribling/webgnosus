//
//  CommandFormView.m
//  webgnosus
//
//  Created by Troy Stribling on 11/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandFormView.h"
#import "NSObjectiPhoneAdditions.h"
#import "SegmentedListPicker.h"
#import "XMPPIQ.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"
#import "XMPPxDataField.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormView (PrivateAPI)

- (void)createFormItemViews;
- (UILabel*)createLable:(NSString*)labelText withOffSet:(CGFloat)offSet andFontSize:(CGFloat)fontSize;
- (CGRect)labelRect:(NSString*)label withOffSet:(CGFloat)offSet andFontSize:(CGFloat)fontSize;
- (void)addSeperatorWithOffSet:(CGFloat)offSet;
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
@implementation CommandFormView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize form;
@synthesize formFieldViews;
@synthesize fields;
@synthesize formYPos;
@synthesize parentView;

//===================================================================================================================================
#pragma mark CommandFormViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createFormItemViews {
    self.formYPos = kCOMMAND_FORM_YOFFSET;
    XMPPCommand* command = [self.form command];
    XMPPxData* cmdData = [command data];
    [self titleView:cmdData];
    [self instructionsView:cmdData];
    [self fieldViews:cmdData];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UILabel*)createLable:(NSString*)labelText withOffSet:(CGFloat)offSet andFontSize:(CGFloat)fontSize {
    CGRect labelRect = [self labelRect:labelText withOffSet:offSet andFontSize:fontSize];
    UILabel* label = [[UILabel alloc] initWithFrame:labelRect];
    label.textAlignment = UITextAlignmentLeft;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = labelText;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    return label;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGRect)labelRect:(NSString*)label withOffSet:(CGFloat)offSet andFontSize:(CGFloat)fontSize {
    CGSize textSize = {kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, 20000.0f};
    CGSize size = [label sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect labelRect = CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, size.height);
    self.formYPos += size.height+offSet;
    return labelRect;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addSeperatorWithOffSet:(CGFloat)offSet {
    UIView* seperator = [[UIView alloc] initWithFrame:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, 2.0f)];
    seperator.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    [self addSubview:seperator];
    self.formYPos += seperator.frame.size.height+offSet;
    [seperator release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)titleView:(XMPPxData*)data {
    UILabel* titleLable = [self createLable:[data title] withOffSet:kCOMMAND_FORM_YOFFSET andFontSize:[UIFont systemFontSize]];
    titleLable.textAlignment = UITextAlignmentCenter;
    [self addSubview:titleLable];
    [titleLable release];
    [self addSeperatorWithOffSet:kCOMMAND_FORM_CONTROL_SEPERATOR_YOFFSET];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)instructionsView:(XMPPxData*)data {
    UILabel* instructionsLable = [self createLable:[data instructions] withOffSet:kCOMMAND_FORM_YOFFSET andFontSize:15.0f];
    instructionsLable.font = [instructionsLable.font fontWithSize:15.0f];
    [self addSubview:instructionsLable];
    [instructionsLable release];
    [self addSeperatorWithOffSet:kCOMMAND_FORM_CONTROL_SEPERATOR_YOFFSET];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fieldViews:(XMPPxData*)data {
    NSArray* dataFields = [data fields];
    for (int i = 0; i < [dataFields count]; i++) {
        XMPPxDataField* field = [dataFields objectAtIndex:i];
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
        [self.fields setValue:field forKey:[field var]];
    }
    if ([dataFields count] > 0) {
        [self addSeperatorWithOffSet:kCOMMAND_FORM_CONTROL_SEPERATOR_YOFFSET];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textSingleView:(XMPPxDataField*)field {
    UITextField* fieldText = [[UITextField alloc] initWithFrame:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, kCOMMAND_FORM_TEXTFIELD_HEIGHT)];
    fieldText.placeholder = [field label];
    fieldText.borderStyle = UITextBorderStyleRoundedRect;
    fieldText.autocorrectionType = UITextAutocorrectionTypeNo;
    fieldText.returnKeyType = UIReturnKeyDone;
    fieldText.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldText.font = [UIFont fontWithName:@"helvetica" size:17.0f];;
    fieldText.delegate = self;
    [self addSubview:fieldText];
    NSString* fieldVar = [field var];
    self.formYPos += fieldText.frame.size.height+kCOMMAND_FORM_YOFFSET;
    [self.formFieldViews setValue:fieldText forKey:fieldVar];
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
    UILabel* fieldLabel = [self createLable:[field label] withOffSet:kCOMMAND_FORM_CONTROL_YOFFSET andFontSize:[UIFont systemFontSize]];
    [self addSubview:fieldLabel];
    NSDictionary* opts = [field options];
    if ([opts count] > 0) {
        SegmentedListPicker* fieldPicker = 
            [[SegmentedListPicker alloc] init:[opts allKeys] withValueAtIndex:0  andRect:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, kCOMMAND_FORM_LIST_SIZE)];
        fieldPicker.tintColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        [self addSubview:fieldPicker];
        NSString* fieldVar = [field var];
        self.formYPos += fieldPicker.frame.size.height+kCOMMAND_FORM_YOFFSET;
        [self.formFieldViews setValue:fieldPicker forKey:fieldVar];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)jidSingleView:(XMPPxDataField*)field {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fixedView:(XMPPxDataField*)field {
    NSArray* values = [field values];
    UILabel* fixedLable = [self createLable:[values lastObject] withOffSet:kCOMMAND_FORM_YOFFSET andFontSize:[UIFont systemFontSize]];
    [self addSubview:fixedLable];
    [fixedLable release];
}

//===================================================================================================================================
#pragma mark CommandFormView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithForm:(XMPPIQ*)initForm inParentView:(UIView*)initParentView {
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kCOMMAND_FORM_WIDTH, kCOMMAND_FORM_XTRA_HEIGHT)]) {
        self.form = initForm;
        self.parentView = initParentView;
        self.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
        self.formFieldViews = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.fields = [[NSMutableDictionary alloc] initWithCapacity:10];
        [self createFormItemViews];
        [self.parentView addSubview:self];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPxData*)formFields {
    NSArray* fieldVars = [self.formFieldViews allKeys];
    NSMutableArray* fieldVals = [NSMutableArray arrayWithCapacity:[fieldVars count]];
    for (int i = 0; i < [fieldVars count]; i++) {
        NSString* var = [fieldVars objectAtIndex:i];
        id fieldView = [self.formFieldViews valueForKey:var];
        XMPPxDataField* field =[[XMPPxDataField alloc] init];
        [field addVar:var];
        NSString* fieldViewValue;
        if ([[fieldView className] isEqualToString:@"UITextField"]) {
            fieldViewValue = (NSString*)[fieldView text];
            [field addType:@"text-single"];
        } else if ([[fieldView className] isEqualToString:@"SegmentedListPicker"]) {
            NSString* fieldLabel = (NSString*)[fieldView selectedItem];
            NSDictionary* opts = [(XMPPxDataField*)[self.fields valueForKey:var] options];
            fieldViewValue = (NSString*)[opts valueForKey:fieldLabel];
            [field addType:@"list-single"];
        }
        [field addValues:[NSArray arrayWithObject:fieldViewValue]];
        [fieldVals addObject:field];
        [field release];
    }
    XMPPxData* dataForm = [[XMPPxData alloc] initWithDataType:@"submit"];
    [dataForm addFields:fieldVals];
    return [dataForm autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
}

//===================================================================================================================================
#pragma mark UITextFieldDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSArray* fieldViews = [self.formFieldViews allValues];
    for (int i = 0; i < [fieldViews count]; i++) {
        id fieldView = [fieldViews objectAtIndex:i];
        if ([[fieldView className] isEqualToString:@"UITextField"]) {
            [fieldView resignFirstResponder];
        }
    }
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField*)textField {
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
