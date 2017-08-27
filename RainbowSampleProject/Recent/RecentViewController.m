//
//  RecentViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/17/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "RecentViewController.h"


@interface RecentViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSArray * callsArray;
}

@end

@implementation RecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    // Do any additional setup after loading the view from its nib.
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    return cell;
}


@end
