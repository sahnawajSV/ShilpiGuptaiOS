//
//  fetchedDataViewController.m
//  TestAppFetchData
//
//  Created by Temp on 06/09/17.
//  Copyright © 2017 Temp. All rights reserved.
//

#import "fetchedDataViewController.h"
#import "imageLoadViewController.h"

@interface fetchedDataViewController ()
{
NSMutableArray *arr_responseJSON;
NSString *str_imgURL;
}
@end

@implementation fetchedDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [tableViewLoad reloadData];
    // Do any additional setup after loading the view.
    
 //  NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DeletedImage"];
}



- (void)viewWillAppear:(BOOL)animated
{
     [tableViewLoad reloadData];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"http://jsonplaceholder.typicode.com/photos"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              arr_responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              
                                             // NSLog(@"respose %@",arr_responseJSON);
                                              
                                              [tableViewLoad reloadData];
                                              
                                          }];
    
    [postDataTask resume];

}

//Manage the deleted images
//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_responseJSON.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // this method is called for each cell and returns height
    NSDictionary *dictData=[arr_responseJSON objectAtIndex:indexPath.row];
    NSString * text= [ dictData valueForKey:@"title"];
    
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize: 14.0] forWidth:[tableView frame].size.width - 40.0 lineBreakMode:NSLineBreakByWordWrapping];
    // return either default height or height to fit the text
    return textSize.height < 44.0 ? 44.0 : textSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
        [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[cell textLabel] setFont:[UIFont systemFontOfSize: 14.0]];
    }
    
    NSDictionary *dictData=[arr_responseJSON objectAtIndex:indexPath.row];
    cell.textLabel.text= [ dictData valueForKey:@"title"];
   
    str_imgURL = [dictData valueForKey:@"url"];
    NSString *imageURL= [dictData valueForKey:@"thumbnailUrl"];
    
    
//   cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]; //note

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:imageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
                    cell.imageView.image= [UIImage imageWithData:data];
      //  [tableViewLoad reloadData];
                    
    }];
    
    [postDataTask resume];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ImageViewLoad" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ImageViewLoad"])
    {
        imageLoadViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setImageURL:str_imgURL];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
       NSInteger index = indexPath.row;
        
        [arr_responseJSON removeObjectAtIndex:index];
        
        [tableViewLoad deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
    [tableViewLoad endUpdates];
}

- (IBAction)refreshData:(id)sender
{
    [tableViewLoad reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
