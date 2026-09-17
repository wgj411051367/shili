//
//  PlaceViewController.m
//  liveios
//
//  Created by imac on 2021/9/15.
//  Copyright © 2021 iSailor. All rights reserved.
//

#import "PlaceViewController.h"

@interface PlaceViewController ()
{
    UIImageView *placeImage;
}
@end

@implementation PlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    placeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    placeImage.image = [UIImage imageNamed:@"qidongImage4"];
    placeImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:placeImage];
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
