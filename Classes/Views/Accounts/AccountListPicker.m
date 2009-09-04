//
//  AccountListPicker.m
//  webgnosus
//
//  Created by Troy Stribling on 8/29/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "AccountListPicker.h"
#import "AccountModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AccountListPicker (PrivateAPI)

- (void)segmentControlSelectionChanged:(id)sender;
- (void) initAccountList;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AccountListPicker

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize segmentedControl;
@synthesize accountJIDs;
@synthesize currentAccountIndex;

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
    if (self = [super init]) {
        [self initAccountList];
        self.segmentedControl= [[UISegmentedControl alloc] initWithItems:[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"left-arrow.png"], 
                                                                          [self.accountJIDs objectAtIndex:self.currentAccountIndex], [UIImage imageNamed:@"right-arrow.png"], nil]];
        [self.segmentedControl addTarget:self action:@selector(segmentControlSelectionChanged:) forControlEvents:UIControlEventValueChanged];
        self.segmentedControl.frame = CGRectMake(15.0f, 40.0f, 240.0f, 30.0f);
        self.segmentedControl.momentary = YES;
        [self.segmentedControl setWidth:30.f forSegmentAtIndex:0];
        [self.segmentedControl setWidth:30.f forSegmentAtIndex:2];
    }
    return self;
}

//===================================================================================================================================
#pragma mark AccountListPicker

//===================================================================================================================================
#pragma mark AccountListPicker PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) initAccountList {
    self.accountJIDs = [[NSMutableArray alloc] initWithCapacity:10];
    NSArray* accounts = [AccountModel findAllActivated];
    for (int i = 0; i < [accounts count]; i++) {
        AccountModel* account = [accounts objectAtIndex:i];
        [self.accountJIDs addObject:[account jid]];
        if (account.displayed) {
            self.currentAccountIndex = i;
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) segmentControlSelectionChanged:(id)sender {
    NSInteger selectedSegment = [(UISegmentedControl*)sender selectedSegmentIndex];
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
    [self.segmentedControl release];
    [self.accountJIDs release];
}

@end
