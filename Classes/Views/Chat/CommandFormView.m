//
//  CommandFormView.m
//  webgnosus
//
//  Created by Troy Stribling on 11/6/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CommandFormView.h"
#import "CommandFormTextMultiView.h"
#import "NSObjectiPhoneAdditions.h"
#import "SegmentedListPicker.h"
#import "XMPPIQ.h"
#import "XMPPCommand.h"
#import "XMPPxData.h"
#import "XMPPxDataField.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommandFormView (PrivateAPI)

- (void)createFormItemViews;
- (UILabel*)createLabel:(NSString*)labelText withXOffSet:(CGFloat)offSet width:(CGFloat)width andFontSize:(CGFloat)fontSize;
- (UILabel*)createLabel:(NSString*)labelText withYOffSet:(CGFloat)offSet andFontSize:(CGFloat)fontSize;
- (void)updateViewHeight:(CGFloat)heightDelta;
- (CGRect)labelRect:(NSString*)label withXOffSet:(CGFloat)offSet width:(CGFloat)width andFontSize:(CGFloat)fontSize;
- (UITextField*)textFieldViewWithLabel:(NSString*)label;
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
- (UILabel*)createLabel:(NSString*)labelText withXOffSet:(CGFloat)offSet width:(CGFloat)width andFontSize:(CGFloat)fontSize {
    CGRect labelRect = [self labelRect:labelText withXOffSet:offSet width:width andFontSize:fontSize];
    UILabel* label = [[UILabel alloc] initWithFrame:labelRect];
    label.textAlignment = UITextAlignmentLeft;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = labelText;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"helvetica" size:17.0f];
    label.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    return [label autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGRect)labelRect:(NSString*)label withXOffSet:(CGFloat)offSet width:(CGFloat)width andFontSize:(CGFloat)fontSize {
    CGSize textSize = {width, 20000.0f};
    CGSize size = [label sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect labelRect = CGRectMake(offSet, self.formYPos, width, size.height);
    return labelRect;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UILabel*)createLabel:(NSString*)labelText withYOffSet:(CGFloat)yOffSet andFontSize:(CGFloat)fontSize {
    UILabel* label = [self createLabel:labelText withXOffSet:kCOMMAND_FORM_XPOS width:kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS andFontSize:fontSize];
    [self updateViewHeight:label.frame.size.height+yOffSet];
    self.formYPos += label.frame.size.height+yOffSet;
    return label;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateViewHeight:(CGFloat)heightDelta {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+heightDelta);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITextField*)textFieldViewWithLabel:(NSString*)label {
    UITextField* fieldText = 
        [[UITextField alloc] initWithFrame:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, kCOMMAND_FORM_TEXTFIELD_HEIGHT)];
    fieldText.placeholder = label;
    fieldText.borderStyle = UITextBorderStyleRoundedRect;
    fieldText.autocorrectionType = UITextAutocorrectionTypeNo;
    fieldText.returnKeyType = UIReturnKeyDone;
    fieldText.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldText.font = [UIFont fontWithName:@"helvetica" size:17.0f];
    fieldText.delegate = self;
    [self addSubview:fieldText];
    [self updateViewHeight:fieldText.frame.size.height+kCOMMAND_FORM_YOFFSET];
    self.formYPos += fieldText.frame.size.height+kCOMMAND_FORM_YOFFSET;
    return [fieldText autorelease];
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addSeperatorWithOffSet:(CGFloat)offSet {
    UIView* seperator = [[UIView alloc] initWithFrame:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, 2.0f)];
    seperator.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    [self addSubview:seperator];
    [self updateViewHeight:seperator.frame.size.height+offSet];
    self.formYPos += seperator.frame.size.height+offSet;
    [seperator release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)titleView:(XMPPxData*)data {
    UILabel* titleLable = [self createLabel:[data title] withYOffSet:kCOMMAND_FORM_YOFFSET andFontSize:17.0f];
    titleLable.textAlignment = UITextAlignmentCenter;
    [self addSubview:titleLable];
    [self addSeperatorWithOffSet:kCOMMAND_FORM_CONTROL_SEPERATOR_YOFFSET];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)instructionsView:(XMPPxData*)data {
    UILabel* instructionsLable = [self createLabel:[data instructions] withYOffSet:kCOMMAND_FORM_YOFFSET andFontSize:15.0f];
    instructionsLable.font = [UIFont fontWithName:@"helvetica" size:15.0f];
    [self addSubview:instructionsLable];
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
        NSString* var = [field var];
        if (var) {
            [self.fields setValue:field forKey:var];
        }
    }
    if ([dataFields count] > 0) {
        [self addSeperatorWithOffSet:kCOMMAND_FORM_CONTROL_SEPERATOR_YOFFSET];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textSingleView:(XMPPxDataField*)field {
    UITextField* fieldText = [self textFieldViewWithLabel:[field label]];
    [self.formFieldViews setValue:fieldText forKey:[field var]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textMultiView:(XMPPxDataField*)field {
    UILabel* fieldLabel = [self createLabel:[field label] withYOffSet:kCOMMAND_FORM_CONTROL_YOFFSET andFontSize:17.0f];
    [self addSubview:fieldLabel];
    CommandFormTextMultiView* fieldText = 
        [[CommandFormTextMultiView alloc] initWithFrame:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, kCOMMAND_FORM_TEXTVIEW_HEIGHT)];
    fieldText.textView.delegate = self;
    [self addSubview:fieldText];
    [self updateViewHeight:fieldText.frame.size.height+kCOMMAND_FORM_YOFFSET];
    self.formYPos += fieldText.frame.size.height+kCOMMAND_FORM_YOFFSET;
    [self.formFieldViews setValue:fieldText forKey:[field var]];
    [fieldText release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textPrivateView:(XMPPxDataField*)field {
    UITextField* fieldText = [self textFieldViewWithLabel:[field label]];
    fieldText.secureTextEntry = YES;
    [self.formFieldViews setValue:fieldText forKey:[field var]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)booleanView:(XMPPxDataField*)field {
    UILabel* fieldLabel = 
        [self createLabel:[field label] withXOffSet:kCOMMAND_FORM_XPOS+kCOMMAND_FORM_BOOLEAN_WIDTH+kCOMMAND_FORM_BOOLEAN_SEPERATOR width:kCOMMAND_FORM_BOOLEAN_LABEL_WIDTH andFontSize:17.0f];
    if (fieldLabel.frame.size.height < kCOMMAND_FORM_BOOLEAN_HEIGHT) {
        self.formYPos += fieldLabel.frame.size.height+kCOMMAND_FORM_YOFFSET-kCOMMAND_FORM_BOOLEAN_HEIGHT;
        fieldLabel.frame = CGRectMake(fieldLabel.frame.origin.x, fieldLabel.frame.origin.y + kCOMMAND_FORM_YOFFSET, fieldLabel.frame.size.width, fieldLabel.frame.size.height);
        [self updateViewHeight:fieldLabel.frame.size.height+kCOMMAND_FORM_YOFFSET-kCOMMAND_FORM_BOOLEAN_HEIGHT];
    } else {
        [self updateViewHeight:fieldLabel.frame.size.height-kCOMMAND_FORM_BOOLEAN_HEIGHT];
        self.formYPos += fieldLabel.frame.size.height-kCOMMAND_FORM_BOOLEAN_HEIGHT;
    }
	UISwitch* fieldBoolean = [[UISwitch alloc] initWithFrame:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_BOOLEAN_WIDTH, kCOMMAND_FORM_BOOLEAN_HEIGHT)];
    [self addSubview:fieldLabel];
    [self addSubview:fieldBoolean];
    [self.formFieldViews setValue:fieldBoolean forKey:[field var]];
    [self updateViewHeight:fieldBoolean.frame.size.height+kCOMMAND_FORM_YOFFSET];
    self.formYPos += fieldBoolean.frame.size.height+kCOMMAND_FORM_YOFFSET;
    [fieldBoolean release];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)listSingleView:(XMPPxDataField*)field {
    UILabel* fieldLabel = [self createLabel:[field label] withYOffSet:kCOMMAND_FORM_CONTROL_YOFFSET andFontSize:17.0f];
    [self addSubview:fieldLabel];
    NSDictionary* opts = [field options];
    if ([opts count] > 0) {
        SegmentedListPicker* fieldPicker = 
            [[SegmentedListPicker alloc] init:[opts allKeys] withValueAtIndex:0  andRect:CGRectMake(kCOMMAND_FORM_XPOS, self.formYPos, kCOMMAND_FORM_WIDTH-2*kCOMMAND_FORM_XPOS, kCOMMAND_FORM_LIST_SIZE)];
        fieldPicker.tintColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        [self addSubview:fieldPicker];
        [self updateViewHeight:fieldPicker.frame.size.height+kCOMMAND_FORM_YOFFSET];
        self.formYPos += fieldPicker.frame.size.height+kCOMMAND_FORM_YOFFSET;
        [self.formFieldViews setValue:fieldPicker forKey:[field var]];
        [fieldPicker release];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)jidSingleView:(XMPPxDataField*)field {
    UITextField* fieldText = [self textFieldViewWithLabel:[field label]];
    [self.formFieldViews setValue:fieldText forKey:[field var]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fixedView:(XMPPxDataField*)field {
    NSString* val = [[field values] lastObject];
    UILabel* fixedLable = [self createLabel:val withYOffSet:kCOMMAND_FORM_YOFFSET andFontSize:17.0f];
    [self addSubview:fixedLable];
}

//===================================================================================================================================
#pragma mark CommandFormView

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithForm:(XMPPIQ*)initForm inParentView:(UIView*)initParentView {
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kCOMMAND_FORM_WIDTH, kCOMMAND_FORM_HEIGHT)]) {
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
        XMPPxDataField* formField = [self.fields valueForKey:var];
        XMPPxDataField* field =[[XMPPxDataField alloc] init];
        [field addVar:var];
        NSString* fieldViewValue;
        if ([[fieldView className] isEqualToString:@"UITextField"]) {
            fieldViewValue = (NSString*)[(UITextView*)fieldView text];
        } else if ([[fieldView className] isEqualToString:@"CommandFormTextMultiView"]) {
            fieldViewValue = (NSString*)[(CommandFormTextMultiView*)fieldView text];
        } else if ([[fieldView className] isEqualToString:@"UISwitch"]) {
            if ([(UISwitch*)fieldView isOn]) {
                fieldViewValue = @"true";
            } else {
                fieldViewValue = @"false";
            }
        } else if ([[fieldView className] isEqualToString:@"SegmentedListPicker"]) {
            NSString* fieldLabel = (NSString*)[(SegmentedListPicker*)fieldView selectedItem];
            NSDictionary* opts = [(XMPPxDataField*)[self.fields valueForKey:var] options];
            fieldViewValue = (NSString*)[opts valueForKey:fieldLabel];
        }
        [field addType:[formField type]];
        [field addValues:[NSArray arrayWithObject:fieldViewValue]];
        [fieldVals addObject:field];
        [field release];
    }
    XMPPxData* dataForm = [[XMPPxData alloc] initWithDataType:@"submit"];
    [dataForm addFields:fieldVals];
    return [dataForm autorelease];
}

//===================================================================================================================================
#pragma mark UIView

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
#pragma mark UITextViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textViewShouldEndEditing:(UITextView*)textView {
    NSArray* fieldViews = [self.formFieldViews allValues];
    for (int i = 0; i < [fieldViews count]; i++) {
        id fieldView = [fieldViews objectAtIndex:i];
        if ([[fieldView className] isEqualToString:@"UITextView"]) {
            [fieldView resignFirstResponder];
        }
    }
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)textViewDidBeginEditing:(UITextView*)textView {
}


//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
