//
//  WeatherService.h
//  ChuckWeather
//
//  Created by Андрей Бабий on 13.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherService : NSObject
NS_ASSUME_NONNULL_BEGIN
- (instancetype)initWithLattitude: (Float32)lat andLongitude: (Float32)lon;

@property (strong, nonatomic) NSMutableArray* weatherArray;
@property (strong, nonatomic) NSDictionary* mainWeatherDict;
@property (strong, nonatomic) NSDictionary* windDict;
@property (strong, nonatomic) NSDictionary* cloudDict;
@property (assign, nonatomic) NSString* area;
@property (strong, nonatomic) NSDictionary* coordDict;

@property (assign, nonatomic) Float32 lattitude;
@property (assign, nonatomic) Float32 longitude;

@property (assign, nonatomic) NSTimeInterval timeBetweenQuearies;

-(void) getWeather;
NS_ASSUME_NONNULL_END

@property (strong, nonatomic) NSError * _Nullable error;

@end
