//
//  ViewController.h
//  ChuckWeather
//
//  Created by Андрей Бабий on 12.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "JokesService.h"
#import "WeatherService.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) JokesService *jokes;
@property (strong, nonatomic) WeatherService *service;

- (void)updateWeaterUI;
- (void)updateJokesUI;
//- (void)enableLocation;

@end

