//
//  GDPoiVC.m
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/13.
//  Copyright © 2017年 bianming. All rights reserved.
//
#define RightCallOutTag 1
#define LeftCallOutTag 2

#import "GDPoiVC.h"
#import "GDPoiCell.h"
#import "POIAnnotation.h"
#import "ReGeocodeAnnotation.h"
#import "CustomAnnotationView.h"


@interface GDPoiVC ()<MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate,AMapLocationManagerDelegate>{
    //CustomAnnotationView *_annotationView;
}


@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///经
@property(nonatomic,assign)double latitude;
///纬
@property(nonatomic,assign)double longitude;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property(nonatomic,strong)UIButton* gpsButton;
@property(nonatomic,strong)AMapPOIAroundSearchRequest *request;
@property(nonatomic,strong)MAUserLocation *userLocation;;
@property(nonatomic,assign) double zoomLevel;
///是否是文字搜索
@property(nonatomic,assign)BOOL is_keyword;
@property(nonatomic,assign)BOOL is_wasUserAction;
@property(nonatomic,strong)AMapPOI *poi;
@property (nonatomic, strong) MAPointAnnotation *poiAnnotation;
@property(nonatomic,strong)UIImageView *AnnotationImageView;
@end

@implementation GDPoiVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    // 开启定位
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    _is_keyword = NO;
    _is_wasUserAction = NO;
    self.poi = [[AMapPOI alloc]init];
    
}

#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Width*0.8)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [self.tableView tableViewregisterNibArray:@[@"GDPoiCell"]];
    self.tableView.tableFooterView = [UIView new];
    self.mapView = [[MAMapView alloc] initWithFrame:view.bounds];
//    self.mapView.rotationDegree =10;
    //[self.mapView setCameraDegree:30.0];
    self.mapView.delegate = self;
//    self.mapView.showsIndoorMap = YES;
//    self.mapView.showsIndoorMapControl = YES;
   
    //[self.mapView setCurrentIndoorMapFloorIndex:10];
    self.mapView.desiredAccuracy=kCLLocationAccuracyBest;
    //self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.zoomLevel =18;
    [self.mapView setZoomLevel:self.zoomLevel animated:YES];
    //self.mapView.touchPOIEnabled = YES;
    [view addSubview:self.mapView];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self initSearchBarAndOK];
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(view.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 20,
                                    view.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 20);
    
    [view addSubview:zoomPannelView];
    [self image];

}
- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    return ret;
}

- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 98)];
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 40, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    self.zoomLevel= oldZoom + 1;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    self.zoomLevel= oldZoom - 1;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

- (void)gpsAction {
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    //YES 为打开定位，NO为关闭定位
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
}

#pragma mark -
- (void)initSearchBarAndOK
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Width-80, 40)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"输入关键字";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.navigationItem.titleView = self.searchBar;
    //[self.navigationItem.titleView addSubview:self.searchBar];

   // [self.searchBar sizeToFit];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [backBtn addTarget:self action:@selector(OKAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    if(self.searchBar.text.length == 0) {
        return;
    }
    
    [self searchPoiByKeyword:self.searchBar.text];
}
/**
 *  连续定位回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 */
#pragma mark - 连续定位回调函数
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (!_request) {
        self.request = [[AMapPOIAroundSearchRequest alloc] init];

    }
    self.request.offset = 20;                //每页搜索的信息个数
    self.request.page =1;
    self.request.radius = 1000;               //搜索半径
    self.request.sortrule = 1;                //-距离排序
    _request.location    = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //[self showToast:[NSString stringWithFormat: @"%f",location.horizontalAccuracy]];
    _request.keywords  = @"公司企业|汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|道路附属设施|地名地址信息|公共设施";
    /* 综合排序. */
    _request.sortrule            = 1;
    _request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:_request];
    CLLocationCoordinate2D endclLocationCoordinate2D;
    endclLocationCoordinate2D.latitude = location.coordinate.latitude;
    endclLocationCoordinate2D.longitude = location.coordinate.longitude;
    
    //[self addAnnotationWithCooordinate:endclLocationCoordinate2D];
    
    
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{

}
#pragma mark - /* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword
{   _is_keyword = YES;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    //request.cityLimit           = YES;
    request.requireSubPOIs= YES;
    [self.search AMapPOIKeywordsSearch:request];
}

/**
 * @brief 定位失败后调用此接口
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
}

#pragma mark - 在地图View停止定位后调用此接口
/**
 * @brief 在地图View停止定位后调用此接口
 * @param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
    
}

#pragma mark -地图移动结束后调用此接口
/**
 * @brief 地图移动结束后调用此接口
 * @param mapView 地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    _is_wasUserAction = wasUserAction;
    if (wasUserAction==YES
        ) {
    _request.location            = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
       
                [self.search AMapPOIAroundSearch:_request];
    }
    CLLocationCoordinate2D startclLocationCoordinate2D;
    startclLocationCoordinate2D.latitude =  self.mapView.centerCoordinate.latitude;
    startclLocationCoordinate2D.longitude = self.mapView.centerCoordinate.longitude ;
    //[self addAnnotationWithCooordinate:startclLocationCoordinate2D ];
}
#pragma mark - 单击地图底图调用此接口
/**
 *  单击地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    _mapView.centerCoordinate = coordinate;
    _request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.search AMapPOIAroundSearch:_request];
    CLLocationCoordinate2D startclLocationCoordinate2D;
    startclLocationCoordinate2D.latitude =  self.mapView.centerCoordinate.latitude;
    startclLocationCoordinate2D.longitude = self.mapView.centerCoordinate.longitude ;
   // [self addAnnotationWithCooordinate:startclLocationCoordinate2D ];
}


 #pragma mark -  /* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    self.poi =nil;
    
    if (response.pois.count == 0)
    {           [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        return ;
    }
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    [self.mapView setZoomLevel:self.zoomLevel animated:YES];
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.dataArray removeAllObjects];
        AMapPOI *obj =response.pois[0];
         [self.dataArray addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    
   // if (_is_keyword==YES&&_is_wasUserAction==NO) {
        __weak typeof(self) weakSelf = self;
        [self.dataArray removeAllObjects];
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
            
            [weakSelf.dataArray addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        }];
     NSLog(@"%@",poiAnnotations);
        [self.tableView reloadData];
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.showsUserLocation = NO;
     [self.locationManager stopUpdatingLocation];
    //YES 为打开定位，NO为关闭定位
    
}

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois
{
//    if (pois.count == 0)
//    {
//        return;
//    }
//    
//    MAPointAnnotation *annotation = [self annotationForTouchPoi:pois[0]];
//    
//    /* Remove prior annotation. */
//    [self.mapView removeAnnotation:self.poiAnnotation];
//    
//    [self.mapView addAnnotation:annotation];
//    [self.mapView selectAnnotation:annotation animated:YES];
//    
//    self.poiAnnotation = annotation;
}

#pragma mark - Action Handle

- (void)touchPOIEanbledAction:(UISwitch *)switcher
{
    //self.mapView.touchPOIEnabled = switcher.on;
}
#pragma mark - Utility

/* Convert MATouchPoi to MAPointAnnotation. */
//- (MAPointAnnotation *)annotationForTouchPoi:(MATouchPoi *)touchPoi
//{
//    if (touchPoi == nil)
//    {
//        return nil;
//    }
//    
//    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
//    
//    annotation.coordinate = touchPoi.coordinate;
//    annotation.title  = touchPoi.name;
//    
//    return annotation;
//}

/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    self.zoomLevel =mapView.zoomLevel;
}
-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    
    [self.mapView addAnnotation:annotation];
}
#pragma mark - MAMapViewDelegate

//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        
//        static NSString *customReuseIndetifier = @"customReuseIndetifier";
//        
//        if (_annotationView == nil)
//        {
//            _annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
//            
//            _annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
//            _annotationView.canShowCallout = YES;
//            
//            _annotationView.draggable = YES;
//            _annotationView.calloutOffset = CGPointMake(0, -5);
//            _annotationView.portrait = [UIImage imageNamed:@"巴士"];
//        }else{
//            _annotationView.portrait = [UIImage imageNamed:@"巴士"];
//        }
//        
//        
//        
//        return _annotationView;
//    }
//    
//    return nil;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GDPoiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GDPoiCell" forIndexPath:indexPath];

    //cell 赋值
    [cell cellGetData:((POIAnnotation*)self.dataArray[indexPath.row]).poi];
        return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    POIAnnotation * POI =_dataArray[indexPath.row];
    NSLog(@"F--%@",[POI yy_modelToJSONObject]);
    self.zoomLevel  = 18;
    [self.mapView setZoomLevel:self.zoomLevel animated:YES];
//    [self.mapView setCenterCoordinate:POI.coordinate];
  
    CLLocationCoordinate2D startclLocationCoordinate2D;
    
    startclLocationCoordinate2D.latitude =  POI.poi.location.latitude;
    startclLocationCoordinate2D.longitude = POI.poi.location.longitude ;
    self.mapView.centerCoordinate =startclLocationCoordinate2D;
    //[self addAnnotationWithCooordinate:startclLocationCoordinate2D ];
    self.poi = POI.poi;
   
}
#pragma mark - 确定点击事件
-(void)OKAction:(UIButton*)sender{
    NSLog(@"%@",self.poi.name);
   // [self.view endEditing:NO];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.poi.name.length ==0) {
        [self showToast:@"请选择地点"];
    }else{
        self.returnGDPoiVC(self.poi);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//block 传值 二  block 作为方法参数传值

-(void)ReturnGDPoiVCPOI:(ReturnGDPoiVC)block{
    self.returnGDPoiVC = block;
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Width*0.15;
    
}
-(void)image{
  self.AnnotationImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-25)/2, (self.mapView.frame.size.height-40)/2-20, 25, 40)];
    
    //_AnnotationImageView.backgroundColor = [UIColor redColor];
    self.AnnotationImageView.image = [UIImage imageNamed:@"我的定位-1"];
    [self.mapView  addSubview:_AnnotationImageView];
    
    
 

}

@end
