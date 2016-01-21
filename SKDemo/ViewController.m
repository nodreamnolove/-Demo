//
//  ViewController.m
//  SKDemo
//
//  Created by 段瑞权 on 16/1/21.
//  Copyright © 2016年 WanJi. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "RotateView.h"

@interface ViewController ()<CBCentralManagerDelegate>

@property (nonatomic,strong) RotateView * rotateview;

@property (nonatomic,strong) CBCentralManager * blueMgr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    [btn setTitle:@"扫描" forState:UIControlStateNormal];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(TapClick) forControlEvents:UIControlEventTouchUpInside];
    
    RotateView *rotateview = [[RotateView alloc]initWithFrame:CGRectMake(100, 40, 100, 100)];
    
    self.rotateview = rotateview;
    
    rotateview.image =  [UIImage imageNamed:@"scan"];
    
    [self.view addSubview:rotateview];
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 40)];
    [btn2 setTitle:@"蓝牙" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 addTarget: self action:@selector(blueClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

-(void)TapClick
{
  
    [self.rotateview startRotate];
    
    
}

-(void)blueClick
{
    NSDictionary *deceice = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],CBCentralManagerScanOptionAllowDuplicatesKey,nil];
    CBCentralManager *mgr =[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    [mgr scanForPeripheralsWithServices:nil options:deceice];
    mgr.delegate = self;
    self.blueMgr = mgr;
}
//发现一个外设
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@---%@ ----%@",peripheral,advertisementData,RSSI);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;
{
    NSLog(@"centralManagerDidUpdateState:%@",central);
}
@end
