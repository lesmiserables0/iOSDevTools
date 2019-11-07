//
//  LocationTool.m
//  TIMChat
//
//  Created by Admin on 2017/5/31.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LocationTool.h"
@implementation LocationTool
+(id)shareLocationTool
{
    static id sLT;
    if (sLT == nil)
    {
        sLT =  [[LocationTool alloc]init];
    }
    return sLT;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self startLocation];
    }
    return self;
}

#pragma mark 开启定位
-(void)startLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if (!_lbsManager)
        {
            _lbsManager = [[CLLocationManager alloc] init];
            [_lbsManager setDesiredAccuracy:kCLLocationAccuracyBest];
            _lbsManager.delegate = self;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                [_lbsManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
            }
        }
    }
    
}

-(void)getLocation:(void(^)(CLLocation * location)) cb
{
    if ([CLLocationManager locationServicesEnabled] == FALSE)
    {
        [HUDHelper alert:@"请在iPhone“设置-隐私-定位服务”中允许圈圈使用定位服务。" action:^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        return;
    }
    else
    {
        // 判断用户是否允许程序获取位置权限
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways)
        {
            saveLocationback = [cb copy];
        
            // 停止上一次的
            [_lbsManager stopUpdatingLocation];
            // 开始新的数据定位
            [_lbsManager startUpdatingLocation];
        
        }


    }
    
}
+(void)Get_location:(void (^)(CLLocation * location))cb
{
    [[LocationTool shareLocationTool] getLocation:cb];
}

-(void)stopLocation
{
    [_lbsManager stopUpdatingLocation];
}

+(void)Stop_location
{
    [[LocationTool shareLocationTool]  stopLocation];
}
#pragma mark --CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DebugLog(@"定位出错");
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    _currLocation = [locations lastObject];

    
//    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",_currLocation.coordinate.latitude]);
//
//    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",_currLocation.coordinate.longitude]);
    
    if (saveLocationback) {
        saveLocationback(_currLocation);
    }
    
}



@end
