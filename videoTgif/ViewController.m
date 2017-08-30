//
//  ViewController.m
//  videoTgif
//
//  Created by coco on 2017/8/30.
//  Copyright © 2017年 coco. All rights reserved.
//

#import "ViewController.h"
#import "GifConvertor.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "SVProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageview1;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageview2;
@property(nonatomic, strong) GifConvertor *convertor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.convertor = [[GifConvertor alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)covtone:(UIButton *)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"6" ofType:@"mp4"];
    NSString *storepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/6.gif"];
    [SVProgressHUD show];
    __weak __typeof(self)weakSelf = self;
    [self.convertor convertFromMp4Url:path toStorePath:storepath result:^(BOOL success) {
        
        [SVProgressHUD dismiss];
        if (success) {
            NSData *data = [NSData dataWithContentsOfFile:storepath];
            FLAnimatedImage *image =[[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
            [weakSelf.imageview1 setAnimatedImage:image];
        }
        
        
    }];
    
    
}
- (IBAction)convt2:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"7" ofType:@"mp4"];
    NSString *storepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/7.gif"];
    [SVProgressHUD show];
    __weak __typeof(self)weakSelf = self;
    [self.convertor convertFromMp4Url:path toStorePath:storepath result:^(BOOL success) {
        
        [SVProgressHUD dismiss];
        if (success) {
            NSData *data = [NSData dataWithContentsOfFile:storepath];
            FLAnimatedImage *image =[[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
            [weakSelf.imageview2 setAnimatedImage:image];
        }
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
