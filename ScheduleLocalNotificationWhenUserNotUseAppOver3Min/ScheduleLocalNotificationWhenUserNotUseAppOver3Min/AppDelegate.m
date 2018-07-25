//
//  AppDelegate.m
//  ScheduleLocalNotificationWhenUserNotUseAppOver3Min
//
//  Created by Jacob_Liang on 2017/9/21.
//  Copyright © 2017年 Jacob. All rights reserved.
//

//应用场景:一般的工具型APP会包含多个本地通知，分别设置不同的fireDate。如3天，7天，一个月分别推送一次，以唤醒用户。若一个月之内打开APP，则所有本地通知重置。
//模拟需求：这里以设置1Min和3Min的本地通知为例


#import "AppDelegate.h"

static NSString * const LocalNotificationPeriod_1MinsKey = @"LocalNotificationPeriod_1Mins";
static NSString * const LocalNotificationPeriod_3MinsKey = @"LocalNotificationPeriod_3Mins";

static const NSTimeInterval kLocalNotificationTimeInterval_1Mins = 60;
static const NSTimeInterval kLocalNotificationTimeInterval_3Mins = 60 * 3;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，就别想再打开通知开关了)
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        
    } else {
        //iOS 8 请求用户通知权限
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
            [application registerUserNotificationSettings:settings];
            //在请求权限弹出的 Alert 选择中，用户选择 "好"时，会回调 application:didRegisterUserNotificationSettings:方法
        }
    }
    
    return YES;
}

//调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        //....
    }
}

//应用已经激活
- (void)applicationDidBecomeActive:(UIApplication *)application {

    // appIcon上的消息提示个数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 取消所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // 添加1Mins和3Mins的localNotification
    [self addLocalNotification];
}

- (void)addLocalNotification {
    [self setLocalNotification:kLocalNotificationTimeInterval_1Mins];
    [self setLocalNotification:kLocalNotificationTimeInterval_3Mins];
}


- (void)setLocalNotification:(NSTimeInterval)timeInterval {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    NSDate *fireDate = [NSDate date];
    notification.fireDate = [fireDate dateByAddingTimeInterval:timeInterval];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = [NSString stringWithFormat:@"Local Notification %f", timeInterval];
    notification.applicationIconBadgeNumber = 1;
    
    NSString *period;
    if (timeInterval == kLocalNotificationTimeInterval_1Mins) {
        period = LocalNotificationPeriod_1MinsKey;
    } else {
        period = LocalNotificationPeriod_3MinsKey;
    }
    notification.userInfo = @{
                              @"id": period,
                              };
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

/*
 首次用户安装 App 时，方法调用顺序如下
 1. didFinishLaunchingWithOptions -> registerUserNotificationSettings
 2. applicationDidBecomeActive -> 用户选择允许通知权限 -> didRegisterUserNotificationSettings
 3. applicationDidBecomeActive
 
 已经允许过通知权限，方法调用属性如下
 1. didFinishLaunchingWithOptions
 2. applicationDidBecomeActive
 */

@end
