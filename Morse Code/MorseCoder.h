//
//  MorseCoder.h
//  Morse Code
//
//  Created by Rick Wu on 25/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MorseCoder : NSObject

@property (strong) NSDictionary *codebook;

- (NSString *) translate: (NSString *) asciiStr;

@end
