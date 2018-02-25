//
//  WeatherViewModel.h
//  ChuckWeather
//
//  Created by Андрей Бабий on 15.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface WeatherViewModel : NSObject

@property (strong, nonatomic) NSString *VMTemperature;
@property (strong, nonatomic) NSString *VMHumidity;
@property (strong, nonatomic) NSString *VMPressure;
@property (strong, nonatomic) NSString *VMMinTemp;
@property (strong, nonatomic) NSString *VMMaxTemp;

@property (strong, nonatomic) NSString *VMClearSky;

@property (strong, nonatomic) NSString *VMWindSpeed;

@property (strong, nonatomic) NSString *VMArea;

@property (strong, nonatomic) NSString *VMCoordinates;

//@property (weak, nonatomic) ViewController* myController;

-(void)updateWeaterUI;
- (UIAlertController *)callAlert: (NSString *) where;
@end
