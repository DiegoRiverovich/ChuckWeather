//
//  JokesService.h
//  ChuckWeather
//
//  Created by Андрей Бабий on 13.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JokesService : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (strong, nonatomic) NSString * daJoke;
NS_ASSUME_NONNULL_END
@property (strong, nonatomic) NSString * _Nullable error;

- (void) getJokes;
@end
