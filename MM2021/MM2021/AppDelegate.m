//
//  AppDelegate.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "ServerManager.h"
#import "ExecutionTestTVC.h"



@interface AppDelegate () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager   *locationManager;
@property (strong, nonatomic) CLLocation          * location;


@end

@implementation AppDelegate

 
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{

    CLLocationDistance meters = [newLocation distanceFromLocation:oldLocation];
    if(meters >=40000)  // 40 km
    {
        //NSLog(@"newLocation = %@",newLocation);
        //  Если наша локация изменилась больше чем на 40 км, отправить на сервер новую
        //  Jeśli nasza lokalizacja zmieniła się o ponad 40 km, wyślij nową na serwer
        //  If our location has changed by more than 40 km, send a new one to the server
        //[YMMYandexMetrica setLocation:newLocation];
    }
    [manager stopUpdatingLocation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[Fabric with:@[[Crashlytics class]]];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    if (self.locationManager)
        self.locationManager = nil;
    
    self.locationManager = [[CLLocationManager alloc ] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager setDistanceFilter:40000];
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

}




@end
