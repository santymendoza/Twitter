//
//  Tweet.m
//  twitter
//
//  Created by Santy Mendoza on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "NSDate+DateTools.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
     self = [super init];
     if (self) {

         // Is this a re-tweet?
         NSDictionary *originalTweet = dictionary[@"retweeted_status"];
         if(originalTweet != nil){
             NSDictionary *userDictionary = dictionary[@"user"];
             self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

             // Change tweet to original tweet
             dictionary = originalTweet;
         }
         self.idStr = dictionary[@"id_str"];
         self.text = dictionary[@"text"];
         self.favoriteCount = [dictionary[@"favorite_count"] intValue];
         self.favorited = [dictionary[@"favorited"] boolValue];
         self.retweetCount = [dictionary[@"retweet_count"] intValue];
         self.retweeted = [dictionary[@"retweeted"] boolValue];
         
         // initialize user
         NSDictionary *user = dictionary[@"user"];
         self.user = [[User alloc] initWithDictionary:user];
         
         
         //current time
         NSDate * now = [NSDate date];
         NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
         [outputFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
         NSString *newDateString = [outputFormatter stringFromDate:now];
         NSLog(@"newDateString %@", newDateString);
         
         // Format createdAt date string
         NSString *createdAtOriginalString = dictionary[@"created_at"];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         // Configure the input format to parse the date string
         formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
         // Convert String to Date
         NSDate *date = [formatter dateFromString:createdAtOriginalString];
         
         // Configure output format
         formatter.dateStyle = NSDateFormatterShortStyle;
         formatter.timeStyle = NSDateFormatterNoStyle;
         
         
         //double hoursApart = [now hoursFrom:createdAtOriginalString];
         // Convert Date to String
         //self.createdAtString = [formatter stringFromDate:date];
         self.createdAtString = [date shortTimeAgoSinceNow];
     }
     return self;
 }


+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}



@end
