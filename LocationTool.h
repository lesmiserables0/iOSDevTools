//
//  LocationTool.h
//  TIMChat
//
//  Created by Admin on 2017/5/31.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationTool : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager   *_lbsManager;
    CLLocation * _currLocation;
    void (^saveLocationback)(CLLocation * location);
}
+(id)shareLocationTool;
+(void) Get_location:(void(^)(CLLocation *location)) cb;
+(void) Stop_location;
@end
