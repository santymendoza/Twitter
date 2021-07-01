//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "DateTools.h"
#import "DetailsViewController.h"

@interface TimelineViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong,nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (nonatomic, strong) UIRefreshControl *refreshControl;



@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget: self action:@selector(getTimeLine) forControlEvents: UIControlEventValueChanged];
    [self.tableView  insertSubview:self.refreshControl atIndex:0];

    
    [self getTimeLine];
}


- (void) getTimeLine {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = (NSMutableArray *)tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)logOutPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == self.arrayOfTweets.count){
        //[self loadMoreData:self.arrayOfTweets.count + 20];
    }
}

-(void)loadMoreData{
    Tweet *lastTweet = self.arrayOfTweets[ self.arrayOfTweets.count - 1 ];
    NSString *maxId = lastTweet.idStr; // go through the arrayOfTweets, get the last tweet being displayed, get the idStr of that tweet
    [[APIManager shared] getHomeTimelineWithMaxIdWithCompletion:maxId completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            [self.arrayOfTweets addObjectsFromArray:tweets];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            self.isMoreDataLoading = false;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){

        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
                
                // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging){
            self.isMoreDataLoading = true;
            [self loadMoreData];

        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.name.text = tweet.user.name;
    cell.userName.text = tweet.user.screenName;
   
    cell.date.text = tweet.createdAtString;
    
    
    cell.tweetText.text = tweet.text;
    cell.tweet = tweet;
    NSString *countString = [NSString stringWithFormat: @"%d", tweet.favoriteCount];
    [cell.favoritedButton setTitle:countString forState:UIControlStateNormal];
    countString = [NSString stringWithFormat: @"%d", tweet.retweetCount];
    [cell.retweetButton setTitle:countString forState:UIControlStateNormal];
    
    NSString *URLString = tweet.user.profilePicture;
    URLString = [URLString
           stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    
    cell.profilePicture.image = nil;
    [cell.profilePicture setImageWithURL: url];
    
    
    
    return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"detailsSegue"]) {
        UITableView *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell: tappedCell];
        Tweet *tappedTweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.tweet = tappedTweet;
    } else if([segue.identifier isEqualToString:@"composeSegue"]) {
        
    }
    
}


@end
