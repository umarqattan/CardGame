//
//  Card.h
//  Machismo
//
//  Created by Umar Qattan on 7/26/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

@property (nonatomic) NSUInteger numberOfMatchingCards;
- (int)match:(NSArray *)otherCards;

@end
