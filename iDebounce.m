//
//  iDebounce.m
//  Helpful Bloke
//
//  Created by Jonathon Hibbard on 7/18/14.
//  Copyright (c) 2014 Integrated Events, LLC. All rights reserved.
//

#import "iDebounce.h"

@interface iDebounce()

@property (nonatomic, strong) NSMutableDictionary *iDebounceBlockMap;

@end

@implementation iDebounce

+(instancetype)sharedInstance {

    static iDebounce *_sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once( &onceToken, ^{
        _sharedInstance = [iDebounce new];
    });

    return _sharedInstance;
}

+(void)debounce:( iDebounceBlock )block withIdentifier:(NSString *)identifier wait:( NSTimeInterval )seconds {

    hbUtils *utils = [[self class] sharedInstance];

    if( [utils.iDebounceBlockMap objectForKey:identifier] ) {
        return;
    }

    [NSTimer scheduledTimerWithTimeInterval:seconds target:utils selector:@selector( executeDebouncedBlockForTimer: ) userInfo:@{ @"name": identifier } repeats:NO];

    [utils.iDebounceBlockMap setObject:block forKey:identifier];
}


-(instancetype)init {

    self = [super init];
    if( !self ) {
        return nil;
    }

    _iDebounceBlockMap = [NSMutableDictionary dictionary];

    return self;
}

-(void)executeDebouncedBlockForTimer:(NSTimer *)timer {

    NSString *methodIdentifier = [timer.userInfo[@"name"] copy];
    if( self.iDebounceBlockMap[methodIdentifier] ) {

        NSLog( @"Executing iDebounce block having identifier = %@", methodIdentifier );

        iDebounceBlock block = [self.iDebounceBlockMap[methodIdentifier] copy];
        if (block != nil) {
            block();
        }

        [self.iDebounceBlockMap removeObjectForKey:methodIdentifier];
    }

    [timer invalidate];
}

@end
