//
//  ViewController.m
//  SKDemo
//
//  Created by hmh on 16/1/21.
//  Copyright © 2016年 WanJi. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "RotateView.h"

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralManagerDelegate>

@property (nonatomic,strong) RotateView * rotateview;

@property (nonatomic,strong) CBCentralManager * blueMgr;//中心管理器

@property (nonatomic,strong) NSMutableArray * peripheraArr;

@property (nonatomic,strong) CBPeripheralManager * perMgr;//外设管理器
@property (nonatomic,strong) CBMutableCharacteristic * customerCharacteristic;
@property (nonatomic,strong) CBMutableService * customerService;

@end
static NSString *const kCharacteristicUUID = @"CCE62C0F-1098-4CD0-ADFA-C8FC7EA2EE90";

static NSString *const kServiceUUID = @"50BD367B-6B17-4E81-B6E9-F62016F26E7B";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 40, 100, 40)];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    [btn setTitle:@"扫描" forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(TapClick) forControlEvents:UIControlEventTouchUpInside];
    
    RotateView *rotateview = [[RotateView alloc]initWithFrame:CGRectMake(100, 40, 100, 100)];
    
    self.rotateview = rotateview;
    
    rotateview.image =  [UIImage imageNamed:@"scan"];
    
    [self.view addSubview:rotateview];
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 100, 40)];
    [btn2 setTitle:@"蓝牙" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 addTarget: self action:@selector(blueClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, 100, 40)];
    [btn3 setTitle:@"外设" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor blueColor];
    [btn3 addTarget: self action:@selector(perClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
}
//存放外部设备（服务器）的数组
-(NSMutableArray *)peripheraArr
{
    if (_peripheraArr == nil) {
        _peripheraArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _peripheraArr;
}
-(void)TapClick
{
  
    [self.rotateview startRotate];
    
    
}

-(void)blueClick
{
    self.blueMgr =[[CBCentralManager alloc]initWithDelegate:self queue:nil];
}


-(void)perClick
{
    self.perMgr = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}


//一开检查本地设备状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;
{
    NSLog(@"centralManagerDidUpdateState:%@",central);
    switch (central.state) {
        case CBCentralManagerStatePoweredOn://开关 -》开
            [self.blueMgr scanForPeripheralsWithServices:nil options:nil];//接收
            break;
        default:
            break;
    };
}


//发现一个外设
//d = 10^((abs(RSSI) - A) / (10 * n)) RSSI 接收信号强度（负值）
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"发现 %@---%@ ----%@",peripheral,advertisementData,RSSI);
    if([self.peripheraArr containsObject:peripheral])
        return;
    [self.blueMgr connectPeripheral:peripheral options:nil];
 
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (![self.peripheraArr containsObject:peripheral]) { //保存起来
        [self.peripheraArr addObject:peripheral];
    }
}



-(void)setUp{
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
 
    self.customerCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
 
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
 
    self.customerService = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
 
    self.customerService.characteristics = @[self.customerCharacteristic];
 
    [self.perMgr addService:self.customerService];
    
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"%@",peripheral);
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            [self setUp];
            break;
            
        default:
            break;
    }
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    if (error == nil) {
        //添加服务后可以在此向外界发出通告 调用完这个方法后会调用代理的
        //(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
        [self.perMgr startAdvertising:@{CBAdvertisementDataLocalNameKey : @"Service",CBAdvertisementDataServiceUUIDsKey : [CBUUID UUIDWithString:kServiceUUID]}];
    }
    
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    NSLog(@"in peripheralManagerDidStartAdvertisiong:error");
}
@end
