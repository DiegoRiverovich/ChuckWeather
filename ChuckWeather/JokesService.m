//
//  JokesService.m
//  ChuckWeather
//
//  Created by Андрей Бабий on 13.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import "JokesService.h"

@interface JokesService()
@property (strong, nonatomic) NSString* dataGL;
@property (assign, nonatomic) Boolean newDataJokes;
@property (strong, nonatomic) NSDictionary* dict;

@end

@implementation JokesService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.newDataJokes = NO;
    }
    return self;
}

- (void) getJokes {
   __weak JokesService *weakSelf = self;
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://rzhunemogu.ru/RandJSON.aspx?CType=1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // #test response and data
            //NSLog(@"jokes response %@", response);
            //NSLog(@"jokes error %@", error);
            //NSLog(@"jokes data %@", data);
            
            if (data != nil) {
                // #from data to string ENCODING NSWindowsCP1251StringEncoding
                NSString *str = [[NSString alloc]initWithData:data encoding:NSWindowsCP1251StringEncoding];
                //NSLog(@"%@", str);
                // #remove \n \r
                str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                
                str = [str stringByReplacingOccurrencesOfString:@"{\"content\":\"" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
                // #str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                //NSString *newString = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                //NSLog(@"NEW STRING %@", newString);
                // #setup dajoke nad kvo
                weakSelf.daJoke = str; //finalData;
                weakSelf.daJoke = [NSString stringWithFormat:@"%@ \n\n%@", str, @"http://rzhunemogu.ru/"];
                weakSelf.newDataJokes = YES;
                // SERIALIZATION DON'T NEEDED !!!!!
                // #from string to data
                //NSData *newData = [newString dataUsingEncoding:NSUTF8StringEncoding];
                //[self serializeJSON:newData];
            } else if (error != nil) {
                weakSelf.newDataJokes = NO;
                weakSelf.daJoke = @"Сервер с шутками не доступен. Попробуйте в другой раз.";
                //NSLog(@"Сервер с шутками не доступен. Попробуйте в другой раз.");
            }
            
        }]resume];
    
}

- (void) serializeJSON: (NSData *) jsonData {
    NSError *e = nil;
    
    // serialization to dictionary
    NSDictionary *newjson = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    // get string from dictionary
    NSString *finalData = newjson[@"content"];
    NSString *str = [finalData stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    self.daJoke = str; //finalData;
    
    
    self.newDataJokes = YES;
    
    //NSLog(@"ERROR! %@", e);
}


@end
