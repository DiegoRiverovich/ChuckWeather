//
//  WeatherViewModel.m
//  ChuckWeather
//
//  Created by Андрей Бабий on 15.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import "WeatherViewModel.h"
@interface WeatherViewModel()

@end

@implementation WeatherViewModel

// #call alert
- (UIAlertController *)callAlert: (NSString *) where {
    __weak WeatherViewModel *weakSelf = self;
    NSString *errorMessage = @"";
    if ([where isEqualToString:@"location"]) {
        errorMessage = @"У программы нет доступа к геопозиции. Изменить можно в настройках устройства.";
    } else if ([where isEqualToString:@"weather"]) {
        errorMessage = @"Сервер с прогнозом не доступен. Попробуйте в другой раз.";
    } else {
        errorMessage = @"";
    }
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Ошибка"
                                 message:errorMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* cancelButton = [UIAlertAction
                                actionWithTitle:@"Отмена"
                                style:UIAlertActionStyleDefault
                                handler: nil/*^(UIAlertAction * action)*/
                                //Handle your yes please button action here
                                //[self clearAllData];
                                ];
    
    
    UIAlertAction* enableButton = [UIAlertAction
                                   actionWithTitle:@"Включить"
                                   style:UIAlertActionStyleDefault
                                   handler: ^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                       [weakSelf enableLocation];
                                   }];
    
    //[alert addButtonWithTitle:@"Bar" block:^{ NSLog(@"Bar"); }];
    
    [alert addAction:cancelButton];
    if ([where isEqualToString:@"location"]) {
        [alert addAction:enableButton];
    }
    
    //[self presentViewController:alert animated:YES completion:nil];
    return alert;
}

-(void)enableLocation {
    //__weak UIViewController* myController = [[NSMutableArray alloc] init];
    //[self.myController enableLocation];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)updateWeaterUI {
    __weak WeatherViewModel *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        /* #GET Data from object
         // #convert string to float
         Float32 myFloat = [[self.service.mainWeatherDict valueForKey:@"temp"] floatValue];
         // #remove decimal in float and convert to string back
         NSString *testString = [NSString stringWithFormat:@" %.0f", myFloat];
         // #print result
         NSLog(@"Observer Weather is called !!!!!!!! %@", testString);
         // #set temperature label
         ////self.temperatureLabel.text = testString;
         // #set temperature from dictionary OLD
         //self.temperatureLabel.text = [NSString stringWithFormat: @"%@", [self.service.mainWeatherDict valueForKey:@"temp"]];
         //NSString * counting =[NSString stringWithFormat:@"fdfg%04d.png", alfa];
         */
        // #get data from USERDEFAULST
        NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
        // #main weather dictionary from USERDEFAULS
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"mainWeatherDict"]){
            // #temperature
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"mainWeatherDict"];
            Float32 myFloat = [[dict objectForKey:@"temp"] floatValue];
            //NSLog(@"mykey found %.2f", myFloat);
            //NSLog(@"mykey found %@f", dict);
            NSString *temperature = [NSString stringWithFormat:@"%.0f°C", myFloat];
            //self.temperatureLabel.text = temperature;
            weakSelf.VMTemperature = temperature;
            // # humidity
            NSString *humidityFromDict = [dict objectForKey:@"humidity"];
            //NSLog(@"mykey found humidity %@", humidityFromDict);
            //self.humidity.text = [NSString stringWithFormat:@"Влажность: %@", humidityFromDict];
            weakSelf.VMHumidity = [NSString stringWithFormat:@"Влажность: %@", humidityFromDict];
            
            // # pressure
            NSString *pressureFromDict = [dict objectForKey:@"pressure"];
            //NSLog(@"mykey found pressure %@", pressureFromDict);
            //self.pressure.text = [NSString stringWithFormat:@"Давление: %@", pressureFromDict];
            weakSelf.VMPressure = [NSString stringWithFormat:@"Давление: %@", pressureFromDict];
            // # min temperature
            NSString *min_tempFromDict = [dict objectForKey:@"temp_min"];
            //NSLog(@"mykey found temp_min %@", min_tempFromDict);
            //self.minTemp.text = [NSString stringWithFormat:@"Минимальная температура: %@", min_tempFromDict];
            weakSelf.VMMinTemp = [NSString stringWithFormat:@"Минимальная температура: %@", min_tempFromDict];
            // # max temperature
            NSString *max_tempFromDict = [dict objectForKey:@"temp_max"];
            //NSLog(@"mykey found temp_max %@", max_tempFromDict);
            //self.maxTemp.text = [NSString stringWithFormat:@"Максимальная температура: %@", max_tempFromDict];
            weakSelf.VMMaxTemp = [NSString stringWithFormat:@"Максимальная температура: %@", max_tempFromDict];
            //NSLog(@"mykey found");
        } else {
            // do nothing
        }
        // #main weather array from USERDEFAULS
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"weatherArray"]){
            NSArray *weatherArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"weatherArray"];
            NSDictionary *dict = weatherArray[0];
            NSString *clear = [dict objectForKey:@"description"];
            //self.clearSky.text = clear;
            weakSelf.VMClearSky = clear;
            //NSLog(@"mykey found!!!! %@", clear);
            
        } else {
            // do nothing
        }
        // #main wind dictionary from USERDEFAULS
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"windDict"]){
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"windDict"];
            Float32 myFloat = [[dict objectForKey:@"speed"] floatValue];
            //NSLog(@"mykey found %.2f", myFloat);
            //NSLog(@"mykey found %@f", dict);
            NSString *testString = [NSString stringWithFormat:@"%.0f", myFloat];
            //self.windSpeed.text = [NSString stringWithFormat:@"Скорость ветра: %@ м/с", testString];
            weakSelf.VMWindSpeed = [NSString stringWithFormat:@"Скорость ветра: %@ м/с", testString];
            //NSLog(@"mykey found");
        } else {
            // do nothing
        }
        // # area from USERDEFAULS
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"area"]){
            NSString *area = [[NSUserDefaults standardUserDefaults] objectForKey:@"area"];
            //self.area.text = [NSString stringWithFormat:@"Район: %@", area];
            NSString *kapotnya = [area isEqualToString:@"Alekseyevka"] ? @"Kapotnya" : area;
            weakSelf.VMArea = [NSString stringWithFormat:@"Район: %@", kapotnya];
            //NSLog(@"mykey found");
        } else {
            // do nothing
        }
        // # coordinates from USERDEFAULS
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"coord"]){
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"coord"];
            NSString *lon = [dict objectForKey:@"lon"];
            NSString *lat = [dict objectForKey:@"lat"];
            //self.coordinates.text = [NSString stringWithFormat:@"Координаты: %@ %@", lon, lat];
            weakSelf.VMCoordinates = [NSString stringWithFormat:@"Координаты: %@,  %@", lat, lon];
            //NSLog(@"mykey found");
        } else {
            // do nothing
        }
    });
}


@end
