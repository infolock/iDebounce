//
//  iDebounce.m
//  Helpful Bloke
//
//  Created by Jonathon Hibbard on 7/18/14.
// 
// The MIT License (MIT)
// Copyright (c) 2014 Jonathon Hibbard
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

    iDebounce *instance = [[self class] sharedInstance];

    if( [instance.iDebounceBlockMap objectForKey:identifier] ) {
        return;
    }

    [NSTimer scheduledTimerWithTimeInterval:seconds target:instance selector:@selector( executeDebouncedBlockForTimer: ) userInfo:@{ @"name": identifier } repeats:NO];

    [instance.iDebounceBlockMap setObject:block forKey:identifier];
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
