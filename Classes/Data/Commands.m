//
//  Commands.m
//  webgnosus_client
//
//  Created by Troy Stribling on 5/16/09.
//  Copyright 2009 Plan-B Research. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "Commands.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static Commands* thisCommands = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Commands (PrivateAPI)

- (void)loadCommands;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation Commands

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize commands;

//===================================================================================================================================
#pragma mark Commands

//-----------------------------------------------------------------------------------------------------------------------------------
+ (Commands*)instance {	
    @synchronized(self) {
        if (thisCommands == nil) {
            [[self alloc] init]; 
        }
    }       
    return thisCommands;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableArray*)atIndex:(NSUInteger)index {
    return [self.commands objectAtIndex:index];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSMutableDictionary*)commandWithName:(NSString*)command {
    for (int j = 1; j < [self.commands count]; j++) {
        NSMutableArray* perfCommands = [self.commands objectAtIndex:j];
        for (int i = 0; i < [perfCommands count];i++) {
            NSMutableDictionary* record = [perfCommands objectAtIndex:i];
            if ([[record objectForKey:@"method"] isEqualToString:command]) {
                return record;
            }
        }
    }
    return NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)hasPerformanceCommand:(NSString*)command {
    for (int j = 1; j < [self.commands count]; j++) {
        NSMutableArray* perfCommands = [self.commands objectAtIndex:j];
        for (int i = 0; i < [perfCommands count];i++) {
            NSMutableDictionary* record = [perfCommands objectAtIndex:i];
            if ([[record objectForKey:@"method"] isEqualToString:command]) {
                return YES;
            }
        }
    }
    return NO;
}

//===================================================================================================================================
#pragma mark Commands PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadCommands {
    self.commands = [[NSMutableArray alloc] initWithCapacity:10];
    // system messages
    NSMutableArray* commandList = [[NSMutableArray alloc] initWithCapacity:10];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"uptime", @"method", @"", @"parameter", @"uptime", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"processes_using_most_memory", @"method", @"", @"parameter", @"processes using most memory", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"processes_using_most_cpu", @"method", @"", @"parameter", @"processes using most cpu", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"zombie_processes", @"method", @"", @"parameter", @"zombie processes", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"largest_files", @"method", @"", @"parameter", @"largest files", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"largest_open_files", @"method", @"", @"parameter", @"largest open files", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"listening_tcp_sockets", @"method", @"", @"parameter", @"listening tcp sockets", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"connected_tcp_sockets", @"method", @"", @"parameter", @"connected tcp sockets", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"udp_sockets", @"method", @"", @"parameter", @"udp sockets", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"file_system_usage", @"method", @"", @"parameter", @"file system usage", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ethernet_interfaces", @"method", @"", @"parameter", @"ethernet interfaces", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"active_users", @"method", @"", @"parameter", @"active users", @"description", nil]];
    [self.commands addObject:commandList];
    [commandList release];
    // cpu peferomance messages
    commandList = [[NSMutableArray alloc] initWithCapacity:10];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"cpu_total",             @"method", @"", @"parameter", @"%",   @"unit", @"total cpu", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"one_minute_load",       @"method", @"", @"parameter", @"",    @"unit", @"one minute load average", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"iowait",                @"method", @"", @"parameter", @"%",   @"unit", @"IO wait", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"user",                  @"method", @"", @"parameter", @"%",   @"unit", @"user process cpu usage", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"system",                @"method", @"", @"parameter", @"%",   @"unit", @"system process cpu usage", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"processes",             @"method", @"", @"parameter", @"1/s", @"unit", @"processes creation rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"procs_running",         @"method", @"", @"parameter", @"",    @"unit", @"running processes", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ctxt",                  @"method", @"", @"parameter", @"1/s", @"unit", @"context switching rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"five_minute_load",      @"method", @"", @"parameter", @"",    @"unit", @"five minute load average", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"fifteen_minute_load",   @"method", @"", @"parameter", @"",    @"unit", @"fifteen minute load average", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"idle",                  @"method", @"", @"parameter", @"%",   @"unit", @"idle", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"nice",                  @"method", @"", @"parameter", @"%",   @"unit", @"nice user process cpu usage", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"irq",                   @"method", @"", @"parameter", @"%",   @"unit", @"hardware interrupt servicing", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"softirq",               @"method", @"", @"parameter", @"%",   @"unit", @"software interrupt servicing", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"steal",                 @"method", @"", @"parameter", @"%",   @"unit", @"virtual host hypervisor cpu usage", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"guest",                 @"method", @"", @"parameter", @"%",   @"unit", @"hosted guests cpu usage", @"description", nil]];
    [self.commands addObject:commandList];
    [commandList release];
    // memory peferomance messages
    commandList = [[NSMutableArray alloc] initWithCapacity:10];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"mem_used_process",  @"method", @"", @"parameter", @"GB",    @"unit", @"memory used by processes", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"mem_used_total",    @"method", @"", @"parameter", @"GB",    @"unit", @"memory used by cache and processes", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"pswpin",            @"method", @"", @"parameter", @"KB/s",  @"unit", @"swap in rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"pswpout",           @"method", @"", @"parameter", @"KB/s",  @"unit", @"swap out rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"swap_used",         @"method", @"", @"parameter", @"GB",    @"unit", @"swap used", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"pgmajfault",        @"method", @"", @"parameter", @"1/s",   @"unit", @"major page fault rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"pgfault",           @"method", @"", @"parameter", @"1/s",   @"unit", @"total page fault rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"mem_free",          @"method", @"", @"parameter", @"GB",    @"unit", @"free memory", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"swap_free",         @"method", @"", @"parameter", @"GB",    @"unit", @"free swap", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"mem_total",         @"method", @"", @"parameter", @"GB",    @"unit", @"installed memory", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"swap_total",        @"method", @"", @"parameter", @"GB",    @"unit", @"swap file size", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"buffers",           @"method", @"", @"parameter", @"GB",    @"unit", @"buffer cache", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"cached",            @"method", @"", @"parameter", @"GB",    @"unit", @"page cache", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"swap_cached",       @"method", @"", @"parameter", @"GB",    @"unit", @"swap cache", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"cached_total",      @"method", @"", @"parameter", @"GB",    @"unit", @"total cache", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"pgin",              @"method", @"", @"parameter", @"KB/s",  @"unit", @"total page in rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"pgout",             @"method", @"", @"parameter", @"KB/s",  @"unit", @"total page out rate", @"description", nil]];
    [self.commands addObject:commandList];
    [commandList release];
    // storage peferomance messages
    commandList = [[NSMutableArray alloc] initWithCapacity:10];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"file_system_used",      @"method", @"", @"parameter", @"%",     @"unit", @"file system used", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"service_time",          @"method", @"", @"parameter", @"ms",    @"unit", @"service time", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"kb_read",               @"method", @"", @"parameter", @"KB/s",  @"unit", @"KB read rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"kb_written",            @"method", @"", @"parameter", @"KB/s",  @"unit", @"KB write rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"reads",                 @"method", @"", @"parameter", @"1/s",   @"unit", @"read rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"writes",                @"method", @"", @"parameter", @"1/s",   @"unit", @"write rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"service_time_reading",  @"method", @"", @"parameter", @"ms",    @"unit", @"read service time", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"service_time_writing",  @"method", @"", @"parameter", @"ms",    @"unit", @"write service time", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"busy_reading",          @"method", @"", @"parameter", @"%",     @"unit", @"time spent reading", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"busy_writing",          @"method", @"", @"parameter", @"%",     @"unit", @"time spent writing", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"file_system_size",      @"method", @"", @"parameter", @"GB",    @"unit", @"file system size", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"merged_reads",          @"method", @"", @"parameter", @"1/s",   @"unit", @"merged read rate", @"description", nil]];
    [self.commands addObject:commandList];
    [commandList release];
    // network peferomance messages
    commandList = [[NSMutableArray alloc] initWithCapacity:10];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"recv_kbytes",   @"method", @"", @"parameter", @"KB/s", @"unit", @"KB receive rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"trans_kbytes",  @"method", @"", @"parameter", @"KB/s", @"unit", @"KB transmit rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"recv_packets",  @"method", @"", @"parameter", @"1/s", @"unit", @"packet receive rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"trans_packets", @"method", @"", @"parameter", @"1/s", @"unit", @"packet transmit rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"recv_errors",   @"method", @"", @"parameter", @"1/s", @"unit", @"error receive rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"trans_errors",  @"method", @"", @"parameter", @"1/s", @"unit", @"error transmit rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"recv_drop",     @"method", @"", @"parameter", @"1/s", @"unit", @"received packet drop rate", @"description", nil]];
    [commandList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"trans_drop",    @"method", @"", @"parameter", @"1/s", @"unit", @"transmit packet drop rate", @"description", nil]];
    [self.commands addObject:commandList];
    [commandList release];
    // add commands
}

//===================================================================================================================================
#pragma mark NSObject

//-----------------------------------------------------------------------------------------------------------------------------------
-(id)init {
    if (self = [super init]) {
        thisCommands = self;
        [self loadCommands];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
