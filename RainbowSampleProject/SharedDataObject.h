//
//  SharedDataObject.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/30/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDataObject : NSObject

+ (void) registerAllRainbowNotifications;

+ (UITabBarController *) setupTabbarController;

+ (NSString *)getItemDateString:(NSDate *)date;

+(NSString *)formatTimeFromSeconds:(NSString *)numberOfSeconds;
@end
