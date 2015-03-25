//
//  ViewController.m
//  ARMetaioTest
//
//  Created by 池田昂平 on 2014/10/20.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenBounds = [[UIScreen mainScreen] bounds];
    screenWidth = screenBounds.size.width;
    screenHeight = screenBounds.size.width;
    
    self.glView = [[EAGLView alloc] initWithFrame:self.view.bounds]; //EAGLView (metaio AR)
    self.capatrack = [[CapaTrack alloc] initWithFrame:self.view.bounds]; //CapaTrack (metaio AR)
    self.capatrackOnStreetV = [[CapaTrackonStreetV alloc] initWithFrame:self.view.bounds]; //CapaTrack (metaio AR)
    
    self.capatrack.delegate = self;
    self.capatrackOnStreetV.delegate = self;
    
    self.capatrack.isMapAnimating = NO;

    m_metaioSDK->setTrackingEventCallbackReceivesAllChanges(true); //常時onTrackingEventを呼ぶ
    
    [self loadSound]; //サウンド設定
    
    [self showMap]; //地図表示
    
    [self loadConfig]; //マーカー設定ファイル (AR)
    
    [self.view addSubview:self.capatrack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//サウンド設定
- (void)loadSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"recogHover" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.recogSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
}

/*
//認識イベント (ARマーカー)
- (void)onTrackingEvent:(const metaio::stlcompat::Vector<metaio::TrackingValues> &)poses{
    
    if(poses.size() >= 1){
            
      for(int i = 0; i < 2; i++){
        if(poses[i].quality >= 0.5){
            self.capatrack.armarkerRecog = YES;
            [self.recogSound play];
            
            NSLog(@"capaRecog = %d", self.capatrack.capaRecog);
            
            if(self.capatrack.capaRecog){   //初めて認識された1回のみ
                [self.capatrack removeFromSuperview];
                [self showMap]; //地図表示
                [self.view addSubview:self.capatrack];
                
                //NSLog(@"preMapCoordinate = (%f, %f)", preMapCoordinate.longitude, preMapCoordinate.latitude);
                
            }else{
                bool isMapPorjEnabled = [self.mapView.projection containsCoordinate:preMapCoordinate];
                if(isMapPorjEnabled){
                    //Vector3d 切り捨てしてから代入
                    self.capatrack.transComp = metaio::Vector3d(floor(poses[i].translation.x), floor(poses[i].translation.y), floor(poses[i].translation.z));
                    
                    //座標
                    //self.capatrack.arLocaVec2d = m_metaioSDK->getViewportCoordinatesFrom3DPosition(poses[i].coordinateSystemID, self.capatrack.transComp); //Vector3d → Vector2d
                    
                    if(self.capatrack.transComp.z <= -250){ //ある程度カメラに接近したら中止
                        
                        //地図の移動
                        //Vec2d → CGPoint → CLLocationCoordinate2D
                        self.capatrack.arLocaVec2d = metaio::Vector2d(poses[i].translation.y, poses[i].translation.x);
                        self.capatrack.arLocaCGPoint = CGPointMake(968*(self.capatrack.arLocaVec2d.x/175)+(968/2)-180, 1024*(self.capatrack.arLocaVec2d.y/210)+(1024/2));
                        
                        
                        if((self.capatrack.arLocaCGPoint.x <= 100)||(self.capatrack.arLocaCGPoint.x >= screenWidth-100)||(self.capatrack.arLocaCGPoint.y <= 100)||(self.capatrack.arLocaCGPoint.y >= screenHeight-100)){
                            
                            mapCoordinate = [self.mapView.projection coordinateForPoint: self.capatrack.arLocaCGPoint];
                            [self.mapView animateToLocation:mapCoordinate];
                            self.capatrack.isMapAnimating = YES;
                        }else{
                            self.capatrack.isMapAnimating = NO;
                        }
                        
                        preMapCoordinate = mapCoordinate;
                        
                        //地図の拡大・縮小
                        float zoomLevel = 13;
                        
                        if(self.capatrack.transComp.z <= -1410){
                            zoomLevel = 13;
                        }else{
                            zoomLevel = 14;
                        }
                        [self.mapView animateToZoom:zoomLevel];
                        NSLog(@"zoomLevel = %f", zoomLevel);
                        
                        NSLog(@"3次元 x座標:%.1f, y座標:%.1f, z座標:%.1f", self.capatrack.transComp.x, self.capatrack.transComp.y, self.capatrack.transComp.z); //3次元座標
                    }
                }else{
                    NSLog(@"MapProj is not Enabled");
                }
            }
            
            self.capatrack.capaRecog = NO;
            
            //ID
            NSString *markerName = [NSString stringWithCString:poses[i].cosName.c_str() encoding:[NSString defaultCStringEncoding]];
            [self recogARID:markerName];
            NSLog(@"makerName: %@", markerName);

            //角度  Rotation → Vector3d
            self.capatrack.rotation = poses[i].rotation.getEulerAngleDegrees();
            
            //NSLog(@"coordinateID = %d", poses[i].coordinateSystemID);
            
            [self.capatrack setNeedsDisplay];
            
        }else{
            self.capatrack.armarkerRecog = NO;
        }
      }//for
    }
}
*/


//認識イベント (ARマーカー)
- (void)onTrackingEvent:(const metaio::stlcompat::Vector<metaio::TrackingValues> &)poses{
    
    if(poses.size() >= 1){
        
     for(int i = 0; i < 2; i++){
        if(poses[i].quality >= 0.5){
            self.capatrack.armarkerRecog = YES;
            [self.recogSound play];
            
            NSLog(@"capaRecog = %d", self.capatrack.capaRecog);
            
            //地図の移動
            //Vec2d → CGPoint → CLLocationCoordinate2D
            self.capatrack.arLocaVec2d = metaio::Vector2d(poses[0].translation.y, poses[0].translation.x);
            self.capatrack.arLocaCGPoint = CGPointMake(968*(self.capatrack.arLocaVec2d.x/175)+(968/2)-180, 1024*(self.capatrack.arLocaVec2d.y/210)+(1024/2));
            
            if(self.capatrack.capaRecog){   //初めて認識された1回のみ
                [self.capatrack removeFromSuperview];
                [self showMap]; //地図表示
                [self.view addSubview:self.capatrack];
                
                //NSLog(@"preMapCoordinate = (%f, %f)", preMapCoordinate.longitude, preMapCoordinate.latitude);
                
            }else{
                bool isMapPorjEnabled = [self.mapView.projection containsCoordinate:preMapCoordinate];
                if(isMapPorjEnabled){
                    //Vector3d 切り捨てしてから代入
                    self.capatrack.transComp = metaio::Vector3d(floor(poses[0].translation.x), floor(poses[0].translation.y), floor(poses[0].translation.z));
                    
                    
                    if(self.capatrack.transComp.z <= -200){ //ある程度カメラに接近したら中止
                        
                        if((self.capatrack.arLocaCGPoint.x <= 100)||(self.capatrack.arLocaCGPoint.x >= screenWidth-100)||(self.capatrack.arLocaCGPoint.y <= 100)||(self.capatrack.arLocaCGPoint.y >= screenHeight-100)){
                            
                            [self.mapView animateToLocation:mapCoordinate];
                            self.capatrack.isMapAnimating = YES;
                        }else{
                            self.capatrack.isMapAnimating = NO;
                        }
                        
                        mapCoordinate = [self.mapView.projection coordinateForPoint: self.capatrack.arLocaCGPoint];
                        preMapCoordinate = mapCoordinate;
                        
                        //地図の拡大・縮小
                        float zoomLevel = 12;
                        
                        if(self.capatrack.transComp.z <= -1410){
                            zoomLevel = 12;
                        }else{
                            zoomLevel = 14;
                        }
                        [self.mapView animateToZoom:zoomLevel];
                        NSLog(@"zoomLevel = %f", zoomLevel);
                        
                        NSLog(@"3次元 x座標:%.1f, y座標:%.1f, z座標:%.1f", self.capatrack.transComp.x, self.capatrack.transComp.y, self.capatrack.transComp.z); //3次元座標
                    }
                }else{
                    NSLog(@"MapProj is not Enabled");
                }
                NSLog(@"poses[%d].quality: %f", i, poses[i].quality);
            }
            
            self.capatrack.capaRecog = NO;
            
            //ID
            NSString *markerName = [NSString stringWithCString:poses[0].cosName.c_str() encoding:[NSString defaultCStringEncoding]];
            [self recogARID:markerName];
            
            //角度  Rotation → Vector3d
            self.capatrack.rotation = poses[0].rotation.getEulerAngleDegrees();
            
            //NSLog(@"coordinateID = %d", poses[0].coordinateSystemID);
            
            [self.capatrack setNeedsDisplay];
            break;
            NSLog(@"break");
                  
            //NSLog(@"3次元 x座標:%.1f, y座標:%.1f, z座標:%.1f", self.capatrack.transComp.x, self.capatrack.transComp.y, self.capatrack.transComp.z); //3次元座標
            //NSLog(@"2次元(CGPoint) x座標:%.1f, y座標:%.1f ", self.capatrack.arLocaCGPoint.x, self.capatrack.arLocaCGPoint.y); //2次元座標
        }else{
            self.capatrack.armarkerRecog = NO;
            NSLog(@"lost: poses[%d].quality: %f", i, poses[i].quality);
        }
     }
        
    }
    //NSLog(@"poses.size() = %lu", poses.size());
    //NSLog(@"poses[0].quality = %f", poses[0].quality);
    //NSLog(@"poses[1].quality = %f", poses[1].quality);
}

//マーカー設定ファイル読み込み (AR)
- (void)loadConfig {
    NSString *trackingid01 = [[NSBundle mainBundle] pathForResource:@"idmarkerConfig2D_2" ofType:@"zip"];
    if(trackingid01){
        bool success = m_metaioSDK->setTrackingConfiguration([trackingid01 UTF8String]);
        if(!success){
            NSLog(@"No success loading the trackingconfiguration");
        }
    }else{
        NSLog(@"No success loading the trackingconfiguration");
    }
}

//ID認識 (ARマーカー)
- (void)recogARID:(NSString *)markerName{
    
    if([markerName isEqualToString:@"ID marker 1"]){
        self.capatrack.aridNum = 1;
        self.capatrack.aridName = @"ID marker 1";
        NSLog(@"match:1");
    }else if([markerName isEqualToString:@"ID marker 2"]){
        self.capatrack.aridNum = 2;
        self.capatrack.aridName = @"ID marker 2";
        NSLog(@"match:2");
    }else{
        //self.capatrack.aridNum = 0;
        NSLog(@"maker name is %@", markerName);
    }
}

//地図の表示
- (void)showMap {
    [self.mapView animateToViewingAngle:45];
    
    //defaultMapCoordinate = {34.7070318, 137.615537};
    CLLocationCoordinate2D defaultMapCoordinate = {1.283186, 103.860070}; //東京 お台場

    if(([self.capatrack.aridName isEqualToString:@"ID marker 1"])||([self.capatrack.aridName isEqualToString:@"ID marker 2"])){
        //東京 お台場
        NSLog(@"Singapore");
    }/*
    else if([self.capatrack.aridName isEqualToString:@"ID marker 2"]){
        defaultMapCoordinate.latitude = 1.283186; //シンガポール
        defaultMapCoordinate.longitude = 103.860070;
        NSLog(@"Singapore");
    }
    */
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:defaultMapCoordinate.latitude
                                                            longitude:defaultMapCoordinate.longitude
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    preMapCoordinate = defaultMapCoordinate;
}


//- (void)showStreetView {
//    
//    //CLLocationCoordinate2D panoramaNear = {34.70, 137.61};
//    panoramaNear.latitude = 34.70; //初期値
//    panoramaNear.longitude = 137.61;
//    //panoramaView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:panoramaNear];
//    
//    /*
//    self.view =  panoramaView;
//    
//    [self.capatrackOnStreetV removeFromSuperview]; //以前のcapatrackOnStreetVを削除
//    [self.view addSubview:self.capatrackOnStreetV]; //ストリートビュー操作用レイヤーを追加
//    */
//    
//    //[self.view addSubview:self.capatrack2];
//    
//    //move to near coordinate
//    bool isMapPorjEnabled = [self.mapView.projection containsCoordinate:preMapCoordinate];
//    __block BOOL isPanoramaError = NO;
//
//    if(isMapPorjEnabled){
//        panoramaNear = [self.mapView.projection coordinateForPoint: self.capatrack.center]; //CGPoint → CLLocationCoordinate2D
//        
//        //__block BOOL isPanoramaError;
//        GMSPanoramaService *panoramaservice = [[GMSPanoramaService alloc] init];
//        [panoramaservice requestPanoramaNearCoordinate:panoramaNear callback:^(GMSPanorama *panorama, NSError *error) {
//            isPanoramaError = YES;
//            NSLog(@"The service returned error:%@", error);
//            NSLog(@"isPanoramaError: %d", isPanoramaError);
//            self.capatrackOnStreetV.capaRecog = NO;
//            
//            [self.capatrack removeFromSuperview];
//            [self showMap]; //地図表示
//            [self.view addSubview:self.capatrack];
//        }];
//        
//    }
//    if(!isPanoramaError){
//        NSLog(@"showPanorama moveNearCoordinate");
//        panoramaView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:panoramaNear];
//        self.view =  panoramaView;
//        
//        [self.capatrackOnStreetV removeFromSuperview]; //以前のcapatrackOnStreetVを削除
//        [self.view addSubview:self.capatrackOnStreetV]; //ストリートビュー操作用レイヤーを追加
//        [panoramaView moveNearCoordinate:panoramaNear];
//    }
//
//
//    //panoramaNear = [self.mapView.projection coordinateForPoint: self.capatrack.arLocaCGPoint];
//        
//    NSLog(@"showStreetView was called");
//    NSLog(@"panoramaNear (%f, %f)", panoramaNear.longitude, panoramaNear.latitude);
//    //return YES;
//}

/*
- (void)showStreetView {
    
    //CLLocationCoordinate2D panoramaNear = {34.70, 137.61};
    panoramaNear.latitude = 34.70;
    panoramaNear.longitude = 137.61;
    
    [self.capatrackOnStreetV removeFromSuperview]; //以前のcapatrackOnStreetVを削除
    [self.view addSubview:self.capatrackOnStreetV]; //ストリートビュー操作用レイヤーを追加
    
    
    //[self.view addSubview:self.capatrack2];
    
    
    //move to near coordinate
    bool isMapPorjEnabled = [self.mapView.projection containsCoordinate:preMapCoordinate];
    if(isMapPorjEnabled){
        panoramaNear = [self.mapView.projection coordinateForPoint: self.capatrack.center]; //CGPoint → CLLocationCoordinate2D
        [panoramaView moveNearCoordinate:panoramaNear];
    }
    
    panoramaView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:panoramaNear];
    self.view =  panoramaView;
    
    //panoramaNear = [self.mapView.projection coordinateForPoint: self.capatrack.arLocaCGPoint];
    
    NSLog(@"showStreetView was called");
    NSLog(@"panoramaNear (%f, %f)", panoramaNear.longitude, panoramaNear.latitude);
    
}
 */

- (void)showStreetView {
    
    //CLLocationCoordinate2D panoramaNear = {34.70, 137.61};
    panoramaNear.latitude = 34.70;
    panoramaNear.longitude = 137.61;
    
    panoramaView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:panoramaNear];
    
    self.view =  panoramaView;
    
    [self.capatrackOnStreetV removeFromSuperview]; //以前のcapatrackOnStreetVを削除
    [self.view addSubview:self.capatrackOnStreetV]; //ストリートビュー操作用レイヤーを追加
    
    
    //[self.view addSubview:self.capatrack2];
    
    //move to near coordinate
    bool isMapPorjEnabled = [self.mapView.projection containsCoordinate:preMapCoordinate];
    if(isMapPorjEnabled){
        panoramaNear = [self.mapView.projection coordinateForPoint: self.capatrack.center]; //CGPoint → CLLocationCoordinate2D
        [panoramaView moveNearCoordinate:panoramaNear];
    }
    
    //panoramaNear = [self.mapView.projection coordinateForPoint: self.capatrack.arLocaCGPoint];
    
    NSLog(@"showStreetView was called");
    NSLog(@"panoramaNear (%f, %f)", panoramaNear.longitude, panoramaNear.latitude);
    
}




/*
- (void)moveStreetView{
    
    CLLocationCoordinate2D nextPanorama;
    nextPanorama.latitude = panoramaNear.latitude + 0.001;
    nextPanorama.longitude = panoramaNear.longitude + 0.001;
    
    [panoramaView moveNearCoordinate:nextPanorama];
    
    panoramaNear = nextPanorama;
}
 */


//ストリートビューの視点を回転
- (void)rotateStreetView:(float)degree{
    //静電マーカーの向き = ストリートビューの向き
    GMSPanoramaCamera *panoramaCamera = [GMSPanoramaCamera cameraWithHeading:degree pitch:-10 zoom:1];
    [panoramaView animateToCamera:panoramaCamera animationDuration:1.0];
}

@end
