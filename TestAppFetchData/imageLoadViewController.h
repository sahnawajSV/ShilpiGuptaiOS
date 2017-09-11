//
//  imageLoadViewController.h
//  TestAppFetchData
//
//  Created by Temp on 06/09/17.
//  Copyright © 2017 Temp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageLoadViewController : UIViewController
{
IBOutlet UIImageView *imgDataLoad;
}
@property(nonatomic,weak) NSString *imageURL;

@end
