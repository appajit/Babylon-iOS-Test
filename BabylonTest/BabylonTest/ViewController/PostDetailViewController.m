//
//  DetailViewController.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 25/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "PostDetailViewController.h"
#import "Post.h"
#import "User.h"
#import "Comment.h"

@interface PostDetailViewController ()

@property (nonatomic,strong) PostsDataService *dataService;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

@property (nonatomic,strong) User *user;
@property (nonatomic,strong) NSArray *comments;
@property (nonatomic,strong) Post *post;


@end

@implementation PostDetailViewController

#pragma mark - Managing the detail item

-(void) configurePost:(Post*) post
             withUser:(User*) user
         withComments:(NSArray*) comments
{
    self.comments = comments;
    self.user = user;
    self.post = post;
    if(self.isViewLoaded)
    {
        [self configureUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Post Details";
    
    [self configureUI];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) configureUI
{
    self.postTitleLabel.text = self.post.title;
    self.postTextLabel.text = self.post.message;
    self.userNameLabel.text= self.user.name;
    self.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%ld",self.comments.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
