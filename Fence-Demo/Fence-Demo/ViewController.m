//
//  ViewController.m
//  Fence-Demo
//
//  Created by Setven on 2018/12/20.
//  Copyright © 2018 BJEV. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic,strong) MAPolygon* Overpoly;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [AMapServices sharedServices].apiKey = @"";
    NSLog(@"请核对APPID 与 bundelID");
    [self mapView];
    
    NSArray *rangArr = @[@"39.933921, 116.372927",@"39.907261, 116.376532",@"39.900611, 116.418161",@"39.941949, 116.435497"];
    [self DrawingGraphics:rangArr];
    
}


//初始化地图
-(MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        //定位点 YES为开启当前定位点  NO为关闭
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //地图缩放级别
//        [_mapView setZoomLevel:15 animated:YES];
        [self.view addSubview:self.mapView];
    }
    return _mapView;
}

-(void)DrawingGraphics:(NSArray *)rangeArr
{
    CLLocationCoordinate2D points[rangeArr.count];
    for (int i = 0; i< rangeArr.count; i++) {
        NSString *str =  rangeArr[i];
        NSArray *array = [str componentsSeparatedByString:@","];
        NSString *one = [NSString stringWithFormat:@"%@",array[1]];
        NSString *two = [NSString stringWithFormat:@"%@",array[0]];
        
        points[i] =CLLocationCoordinate2DMake([two doubleValue], [one doubleValue]);
    }
    
    self.Overpoly = [MAPolygon polygonWithCoordinates:points count:rangeArr.count];
    
    [_mapView addOverlay:self.Overpoly];
}

//高德地图添加覆盖物的协议方法 绘制路线也是此方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *OverlayRenderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        
        return OverlayRenderer;
    }
    
    if([overlay isKindOfClass:[MAPolygon class]])
        
    {
        
        MAPolygonRenderer *polygon = [[MAPolygonRenderer alloc]initWithPolygon:(MAPolygon*)overlay];
        //边线宽度
        polygon.lineWidth = 1;
        //边线颜色
        polygon.strokeColor = UIColorRGBA(60, 200, 168, 1);
        //填充颜色
        polygon.fillColor = UIColorRGBA(161, 228, 213, 0.15);
        return polygon;
    }
    
    
    return nil;
}



@end
