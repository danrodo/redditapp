//
//  PostTableTableViewController.m
//  redditapp
//
//  Created by Daniel Rodosky on 5/16/14.
//  Copyright (c) 2014 Dan Rodosky. All rights reserved.
//

#import "PostTableTableViewController.h"
#import "RedditPost.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PostTableTableViewController ()
@property (nonatomic, strong) NSArray *postArray;
@end

@implementation PostTableTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Reddit posts";
    
    NSLog(@"its about to begin");
    
    [self refresh];
}

- (void)refresh
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://reddit.com/.json"]];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *array = [dictionary valueForKeyPath:@"data.children"];
        
        
        NSMutableArray *mutArray = [NSMutableArray array];
        
        for(NSDictionary *postDict in array)//pointer into arry to parse
        {
            RedditPost *newPost = [[RedditPost alloc] init];
            newPost.title = [postDict valueForKeyPath:@"data.title"];
            newPost.imageURL = [NSURL URLWithString:[postDict valueForKeyPath:@"data.URL"]];
            [mutArray addObject:newPost];
            
        }
        
        self.postArray = [NSArray arrayWithArray:mutArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData]; 
        });
        NSLog(@"its done");
    }];
    
    [task resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.postArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"post identifier"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"post identifier"];
    }
    RedditPost *post = self.postArray[indexPath.row];
    
    cell.textLabel.text = post.title;
    [cell.imageView setImageWithURL:post.imageURL placeHolderImage:[UIImage imageNamed:@"reddit"]];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
