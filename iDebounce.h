//
//  iDebounce.h
//  Helpful Block
//
//  Created by Jonathon Hibbard on 7/18/14.
//  Copyright (c) 2014 Integrated Events, LLC. All rights reserved.
//

typedef void (^iDebounceBlock)();

@interface iDebounce : NSObject

+(instancetype)sharedInstance;

+(void)debounce:( iDebounceBlock )block withIdentifier:(NSString *)identifier wait:( NSTimeInterval )seconds;

@end
