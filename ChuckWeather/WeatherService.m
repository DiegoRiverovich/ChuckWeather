//
//  WeatherService.m
//  ChuckWeather
//
//  Created by Андрей Бабий on 13.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import "WeatherService.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherService()
@property (strong, nonatomic) NSDate* lastTimeWeatherQueary; // last time when query was done
@property (assign, nonatomic) NSTimeInterval lastTimeWeatherQuearyInterval; // last time when query was done
@property (strong, nonatomic) NSString* dataGL;
@property (strong, nonatomic) NSDictionary* dict;
@property (assign, nonatomic) Boolean newData;

@end

@implementation WeatherService

- (instancetype)initWithLattitude: (Float32)lat andLongitude: (Float32)lon
{
    self = [self init];
    if (self) {
        self.longitude = lon;
        self.lattitude = lat;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastTimeWeatherQuearyInterval = 901;
        self.timeBetweenQuearies = 900;
        self.lastTimeWeatherQueary = [[NSDate alloc] init];
        self.dataGL = @"";
        self.newData = NO;
        self.lattitude = -8.720000; //-8.724163;
        self.longitude = 115.174380;
        
        //[self addObserver:self forKeyPath:@"da" options: NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void) getWeather {
    __weak WeatherService *weakSelf = self;
    // Formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd:HH:mm:ss"];
    
    [self getUserDefaults];
    
    NSDate* timeNow = [NSDate date];
    self.lastTimeWeatherQuearyInterval = [timeNow timeIntervalSinceDate:self.lastTimeWeatherQueary];
    
    //NSLog(@"Now date: %@", [formatter stringFromDate:timeNow]);
    //NSLog(@"lastTimeWeatherQuearyInterval, timeBetweenQuearies: %f, %f", self.lastTimeWeatherQuearyInterval, self.timeBetweenQuearies);
    NSString *quearyString = [NSString stringWithFormat:@"", self.lattitude, self.longitude];
    //NSLog(@"Queary string: %@", quearyString);
    if (self.lastTimeWeatherQuearyInterval > self.timeBetweenQuearies) {
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:quearyString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //NSLog(@"weather response %@", response);
            //NSLog(@"weather error %@", error);
            //NSLog(@"weather data %@", data);
            weakSelf.dataGL = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            if (data != nil) {
                [weakSelf serializeJSON: data];
                weakSelf.lastTimeWeatherQueary = [[NSDate alloc] init];
                
                // Save date to userDefaulst
                [[NSUserDefaults standardUserDefaults] setObject:self.lastTimeWeatherQueary forKey:@"lastTimeWeatherQueary"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                weakSelf.newData = YES;
                //NSLog(@"Activity Indicator disable");
            } else if (error != nil) {
                weakSelf.newData = NO;
                weakSelf.error = error;
                //NSLog(@"Сервер с прогнозом не доступен. Попробуйте в другой раз.");
            }
            
        }]resume];
    } else {
        self.newData = NO;
    }
   
}

- (void) serializeJSON: (NSData *) jsonData {
    self.dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    if([self.dict count] > 0) {
        
        //NSArray *newArray = [self.dict valueForKey:@"weather"];
        //NSLog(@"Dict: %@", self.dict);
        self.weatherArray = [self.dict valueForKey:@"weather"];
        self.mainWeatherDict = [self.dict valueForKey:@"main"];
        self.windDict = [self.dict valueForKey:@"wind"];
        self.cloudDict = [self.dict valueForKey:@"clouds"];
        self.area = [self.dict valueForKey:@"name"];
        self.coordDict = [self.dict valueForKey:@"coord"];
        //NSLog(@"Dict COORD: %@", self.coordDict);
        
        // Save date to userDefaulst
        [[NSUserDefaults standardUserDefaults] setObject:self.weatherArray forKey:@"weatherArray"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mainWeatherDict forKey:@"mainWeatherDict"];
        [[NSUserDefaults standardUserDefaults] setObject:self.windDict forKey:@"windDict"];
        [[NSUserDefaults standardUserDefaults] setObject:self.cloudDict forKey:@"cloudDict"];
        [[NSUserDefaults standardUserDefaults] setObject:self.area forKey:@"area"];
        [[NSUserDefaults standardUserDefaults] setObject:self.coordDict forKey:@"coord"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) getUserDefaults {
    // Get NSUserDefaults
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"lastTimeWeatherQueary"]){
        self.lastTimeWeatherQueary = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastTimeWeatherQueary"];
        //NSLog(@"mykey found");
    } else {
        self.lastTimeWeatherQueary = [self.lastTimeWeatherQueary dateByAddingTimeInterval:-60*25];
        // do nothing
    }
}


- (void)dealloc
{
    @try{
        [self removeObserver:self forKeyPath:@"newData"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    
}

@end
