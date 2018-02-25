//
//  ViewController.m
//  ChuckWeather
//
//  Created by Андрей Бабий on 12.02.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

#import "ViewController.h"
#import "WeatherService.h"
#import "JokesService.h"
#import "WeatherViewModel.h"

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *coordinates;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UITextView *jokesTextView;

@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *pressure;
@property (weak, nonatomic) IBOutlet UILabel *minTemp;
@property (weak, nonatomic) IBOutlet UILabel *maxTemp;

@property (weak, nonatomic) IBOutlet UILabel *clearSky;

@property (weak, nonatomic) IBOutlet UILabel *windSpeed;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet WeatherViewModel *viewModel;

@property (assign ,nonatomic) Boolean isPhone;

@end

@implementation ViewController

- (IBAction)getLocationByButton:(UIButton *)sender {
    
    [self startLocationManager];
}

- (IBAction)testQueary:(UIButton *)sender {
    [self.jokes getJokes];
    [self updateUIByButton];
}

- (void)updateUIByButton {
    self.jokesTextView.text = self.jokes.daJoke;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // #phone of pad func
    [self phoneOrPad];
    // #set font for Pad
    [self setFontForPad];
    // #VievModel
    self.viewModel = [[WeatherViewModel alloc]init];
    [self.viewModel updateWeaterUI];
    // #location
    [self startLocationManager];
    /*
    // weather
    self.service = [[WeatherService alloc] init];
    [self.service addObserver:self forKeyPath:@"newData" options: NSKeyValueObservingOptionNew context:nil];
    [self.service getWeather];
    */
    // #jokes
    self.jokes = [[JokesService alloc] init];
    [self.jokes addObserver:self forKeyPath:@"newDataJokes" options: NSKeyValueObservingOptionNew context:nil];
    [self.jokes getJokes];
    
    // #update
    [self updateWeaterUI];
    [self updateUIByButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self updateWeaterUI];
    [self updateJokesUI];
}

-(void)startLocationManager {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        //self.locationManager.requestAlwaysAuthorization;
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [self.locationManager startUpdatingLocation];
        //NSLog(@"Location service are enabled!");
    } else {
        //NSLog(@"Location service are not enabled!");
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// #phone or pad
-(void)phoneOrPad {
    #define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
    if (IPAD) {
        self.isPhone = NO;
        // iPad
    } else {
        self.isPhone = YES;
        // iPhone / iPod Touch
    }
}

-(void)setFontForPad {
    if (!self.isPhone) {
        //[myView setFont:[UIFont systemFontOfSize:12]];
        
        [self.area setFont:[UIFont systemFontOfSize:30 weight:UIFontWeightBold]];
        [self.coordinates setFont:[UIFont systemFontOfSize:30 weight:UIFontWeightThin]];
        
        [self.temperatureLabel setFont:[UIFont systemFontOfSize:150 weight:UIFontWeightUltraLight]];
        [self.coordinates setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightThin]];
        
        [self.humidity setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightLight]];
        [self.pressure setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightLight]];
        [self.minTemp setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightLight]];
        [self.maxTemp setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightLight]];
        
        [self.windSpeed setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightLight]];
        
        [self.clearSky setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightLight]];
        
        [self.jokesTextView setFont:[UIFont systemFontOfSize:23 weight:UIFontWeightRegular]];
    }
}

// location delegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //NSLog(@"ERROR DIDUPDATELOCATION");
    
    // # create alert(in viewModel) and present
    //[self.viewModel callAlert];
    UIAlertController *ac = [self.viewModel callAlert: @"location"];
    [self presentViewController:ac animated:YES completion:nil];
    
    // #get default weather if GPS fails
    [self getWeatherService: 0 andLon: 0];
    [self.locationManager stopUpdatingLocation];
    //[self.activityIndicator stopAnimating];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    //NSLog(@"Location!!!! : @%8f, @%8f", location.coordinate.latitude, location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
    Float32 lon = location.coordinate.longitude;
    Float32 lat = location.coordinate.latitude;
    
    // weather
    [self getWeatherService: lat andLon:lon];
    
    //NSLog(@"DIDUPDATELOCATION");
    //NSLog(@"Location!!!! : @%8f, @%8f", lat, lon);
    [self.locationManager stopUpdatingLocation];
    
}

-(void)getWeatherService: (Float32)lat andLon:(Float32)lon{
    if (self.service == nil) /*(self.num == 0)*/ {
        if (lon != 0 && lat != 0) {
            self.service =[[WeatherService alloc] initWithLattitude:lat andLongitude:lon];
        } else {
            self.service =[[WeatherService alloc] init];
        }
        [self.service addObserver:self forKeyPath:@"newData" options: NSKeyValueObservingOptionNew context:nil];
        [self.service getWeather];
        [self.activityIndicator startAnimating];
        //NSLog(@"Activity Indicator start Cotntroller %@", ([NSThread isMainThread] ? @"YES" : @"NO"));
        
    } else {
        self.service.lattitude = lat;
        self.service.longitude = lon;
        [self.service getWeather];
        [self.activityIndicator startAnimating];
        //NSLog(@"Activity Indicator start Cotntroller %@", ([NSThread isMainThread] ? @"YES" : @"NO"));
    }
    
}

// #KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    __weak ViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        
        
        //NSLog(@"Activity Indicator disable Cotntroller %@", ([NSThread isMainThread] ? @"YES" : @"NO"));
        NSString *kChangeNew = [change valueForKey:@"new"];
        Boolean kChangeNewBoolean = kChangeNew.boolValue;
        //NSLog(@"NEW VALUE !!!!!!!! %@", (kChangeNewBoolean ? @"YES" : @"NO"));
        
        [weakSelf updateFromObserverUI:keyPath isNewValue:kChangeNewBoolean];
    });
}

- (void)updateFromObserverUI: (NSString *)keyPath isNewValue:(Boolean) value {
    if ([keyPath isEqualToString:@"newData"]) {
        if (value) /*(self.jokes.newDataJokes == YES)*/ {
            [self.viewModel updateWeaterUI];
            [self updateWeaterUI];
            //NSLog(@"OBSERVER YES NEW VALUE !!!!!!!! %@", (value ? @"YES" : @"NO"));
        } else {
            if (self.service.error != nil) {
                self.temperatureLabel.text = @"-";
                self.service.error = nil;
            } else {
                [self updateWeaterUI];
            }
            //UIAlertController *ac = [self.viewModel callAlert: @"weather"];
            //[self presentViewController:ac animated:YES completion:nil];
            //NSLog(@"OBSERVER NO NEW VALUE !!!!!!!! %@", (value ? @"YES" : @"NO"));
        }
        //NSLog(@"Observer Weather is called !!!!!!!!");
    }
    if ([keyPath isEqualToString:@"newDataJokes"]) {
        if (value) /*(self.jokes.newDataJokes == YES)*/ {
            [self updateJokesUI];
        } else {
            /*
            NSLog(@"Observer Jokes NONONONONONO is called !!!!!!!!");
            __weak ViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.jokesTextView.text = @"Сервер с шутками не доступен. Попробуйте в другой раз.";
            });
             */
            [self updateJokesUI];
        }
        //NSLog(@"Observer Jokes is called !!!!!!!!");
            
    }
}

- (void)updateWeaterUI {
    __weak ViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf.temperatureLabel.text = weakSelf.viewModel.VMTemperature;
        weakSelf.humidity.text = weakSelf.viewModel.VMHumidity;
        weakSelf.pressure.text = weakSelf.viewModel.VMPressure;
        weakSelf.minTemp.text = weakSelf.viewModel.VMMinTemp;
        weakSelf.maxTemp.text = weakSelf.viewModel.VMMaxTemp;
        
        weakSelf.clearSky.text = weakSelf.viewModel.VMClearSky;
        
        weakSelf.windSpeed.text = weakSelf.viewModel.VMWindSpeed;
        
        weakSelf.area.text = weakSelf.viewModel.VMArea;
        
        weakSelf.coordinates.text = weakSelf.viewModel.VMCoordinates;
        
        [weakSelf.activityIndicator stopAnimating];
        
    });
}

- (void)updateJokesUI {
    __weak ViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.jokesTextView.text = self.jokes.daJoke;
        [weakSelf.jokesTextView setText:weakSelf.jokes.daJoke];
        //NSLog(@"Observer Jokes is called TEXT: %@", weakSelf.jokes.daJoke);
    });
    //NSLog(@"Observer Jokes is called !!!!!!!!");
}

- (void)dealloc
{
    
}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


@end
