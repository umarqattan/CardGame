//
//  SetCardGameViewController.m
//  Machismo
//
//  Created by Umar Qattan on 8/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

@end/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

