//
//  MasterViewController.m
//  BabylonTest
//
//  Created by Appaji Tholeti on 25/06/2016.
//  Copyright © 2016 Tholeti Consultyancy Services. All rights reserved.
//

#import "PostsViewController.h"
#import "PostDetailViewController.h"
#import "PostsDataService.h"
#import "CustomActivityIndicarView.h"
#import "PostsDataInfo.h"
#import "Post.h"

@interface PostsViewController ()

@property (nonatomic,strong) PostsDataService *dataService;
@property (nonatomic,strong) CustomActivityIndicarView *activityIndicatorView;
@property (nonatomic,strong) PostsDataInfo *postsDataInfo;

@end

@implementation PostsViewController

-(void) injectDataService:(PostsDataService*) dataService
{
    self.dataService = dataService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (PostDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.activityIndicatorView = [CustomActivityIndicarView activityIndicatorForDisplayView:self.view];
    self.title = @"Posts";
    [self fetchData];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//If  data is not downloaded provides the option to the user to redownlad the data
-(void) refreshData
{
    [self fetchData];
}

-(void) fetchData
{
    //show fetch data activity indicator
    [self.activityIndicatorView startAnimating];
    __weak typeof(self) weakSelf = self;

    [self.dataService getPostsWithCompletionBlock:^(PostsDataInfo *postsDataInfo, PostsDataServiceStatus status) {
        //switch to the main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            if(strongSelf)
            {
                //stop the activity indicaotr
                [strongSelf.activityIndicatorView stopAnimating];
                
                //if download is successfull display the data
                if(postsDataInfo)
                {
                    strongSelf.navigationItem.rightBarButtonItem = nil;
                    strongSelf.postsDataInfo = postsDataInfo;
                    [strongSelf.tableView reloadData];
                }
                if(status == PostsDataServiceStatusFailed)
                {
                    //in case of any download error, show the refresh button for the use to re download the data
                    strongSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                                                 target:strongSelf
                                                                                                                 action:@selector(refreshData)];
                    
                    NSString *errorDescription = @"Latest data is not available Please,try again";
                    //show the error info alert
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:errorDescription
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:nil];
                    [alert addAction:action];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
                
            }
        });
    }];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPostDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Post *post = self.postsDataInfo.posts[indexPath.row];
        PostDetailViewController *controller = (PostDetailViewController *)[[segue destinationViewController] topViewController];
        User *user = [self.postsDataInfo userForPost:post];
        NSArray *comments = [self.postsDataInfo commentsForPost:post];
        [controller configurePost:post withUser:user withComments:comments];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsDataInfo.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Post *post = self.postsDataInfo.posts[indexPath.row];
    cell.textLabel.text = post.title;
    return cell;
}


@end
