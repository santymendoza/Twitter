//
//  ComposeViewController.m
//  twitter
//
//  Created by Santy Mendoza on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"


@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.composeView.delegate = self;
}
- (IBAction)closeButtonPressed:(id)sender {
    //close compose tab
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetButtonPressed:(id)sender {
    [[APIManager shared]postStatusWithText:self.composeView.text completion:^(Tweet *, NSError *) {
            if (self){
                NSLog(@"worked");
            }
            else{
                NSLog(@"didn't worked");
            }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
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
