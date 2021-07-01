//
//  DetailsViewController.m
//  twitter
//
//  Created by Santy Mendoza on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoritedButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userLabel.text = self.tweet.user.name;
    self.textLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    self.userNameLabel.text = self.tweet.user.screenName;
    NSString *countString = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];
    [self.favoritedButton setTitle:countString forState:UIControlStateNormal];
    countString = [NSString stringWithFormat: @"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:countString forState:UIControlStateNormal];
    //cell.retweetButton.textInputMode = tweet.retweetCount;
    
    NSString *URLString = self.tweet.user.profilePicture;
    URLString = [URLString
           stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    
    
    self.profilePicture.image = nil;
    [self.profilePicture setImageWithURL: url];

    
    // Do any additional setup after loading the view.
}
- (IBAction)favoriteButtonPressed:(id)sender {
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
- (IBAction)retweetButtonPressed:(id)sender {
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
    self.userLabel.text = self.tweet.user.name;
    self.textLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    self.userNameLabel.text = self.tweet.user.screenName;
    NSString *countString = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];
    [self.favoritedButton setTitle:countString forState:UIControlStateNormal];
    countString = [NSString stringWithFormat: @"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:countString forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
