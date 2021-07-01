//
//  TweetCell.m
//  twitter
//
//  Created by Santy Mendoza on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    if(self.favoritedButton.selected){
            self.tweet.favorited = NO;
            self.tweet.favoriteCount = self.tweet.favoriteCount - 1;
            [self.favoritedButton setSelected:NO];
            [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
                if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
                }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
        }
    }];
    }
    else{
            self.tweet.favorited = YES;
            self.tweet.favoriteCount += 1;
            [self.favoritedButton setSelected:YES];
            [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    if(self.retweetButton.selected){
            self.tweet.retweeted = NO;
            self.tweet.retweetCount -= 1;
            [self.retweetButton setSelected:NO];
            [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
                if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
                }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
        }
    }];
    }
    else{
            self.tweet.retweeted = YES;
            self.tweet.retweetCount += 1;
            [self.retweetButton setSelected:YES];
            [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeting the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    [self refreshData];
    
}


-(void) refreshData{
    self.name.text = self.tweet.user.name;
    self.userName.text = self.tweet.user.screenName;
    self.date.text = self.tweet.createdAtString;
    self.tweetText.text = self.tweet.text;
    NSString *countString = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];
    [self.favoritedButton setTitle:countString forState:UIControlStateNormal];
    countString = [NSString stringWithFormat: @"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:countString forState:UIControlStateNormal];
}

@end
