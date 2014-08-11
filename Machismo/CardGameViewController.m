//
//  CardGameViewController.m
//  Machismo
//
//  Created by Umar Qattan on 7/26/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UILabel *flipDescription;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *flipHistory;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        [self changeModeSelector:self.modeSelector];
    }
    return _game;
}

- (NSMutableArray *)flipHistory
{
    if(!_flipHistory)
    {
        _flipHistory = [NSMutableArray array];
    }
    return _flipHistory;
                        
}


- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
- (IBAction)changeSlider:(id)sender
{
    int sliderValue;
    sliderValue = lroundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue
                        animated:NO];
    if([self.flipHistory count])
    {
        self.flipDescription.alpha = (sliderValue+1 < [self.flipHistory count])? 0.6 : 1.0;
        self.flipDescription.text = [self.flipHistory objectAtIndex:sliderValue];
    }
    
}

- (IBAction)touchDealButton:(id)sender
{
    self.modeSelector.enabled = YES;
    self.flipHistory = nil;
    self.game = nil;
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    self.modeSelector.enabled = NO;
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (IBAction)changeModeSelector:(UISegmentedControl *)sender
{
    self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

- (void)setSliderRange
{
    //sets discrete values for slider
    int maxValue = [self.flipHistory count] - 1;
    self.historySlider.maximumValue = maxValue;
    [self.historySlider setValue:maxValue animated:YES];
}
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if(self.game)
    {
        NSString *description = @"";
        
        if([self.game.lastChosenCards count])
        {
            NSMutableArray *cardContents = [NSMutableArray array];
            for (Card *card in self.game.lastChosenCards)
            {
                [cardContents addObject:card.contents];
            }
            description = [cardContents componentsJoinedByString:@" "];
        }
        if(self.game.lastScore > 0)
        {
            description = [NSString stringWithFormat:@"Matched %@ for %d points.", description, self.game.lastScore];
        }
        else if(self.game.lastScore < 0)
        {
            description = [NSString stringWithFormat:@"%@ don't match! %d point penalty.", description, -self.game.lastScore];
        }
        
        self.flipDescription.text = description;
        self.flipDescription.alpha = 1;
        
        if(![description isEqualToString:@""] && ![[self.flipHistory lastObject] isEqualToString:description])
        {
            [self.flipHistory addObject:description];
            [self setSliderRange];
        }
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.chosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

@end