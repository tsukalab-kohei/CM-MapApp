//
//  ViewController.h
//  ARMetaioTest
//
//  Created by 池田昂平 on 2014/10/20.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import "MetaioSDKViewController.h"
#import "EAGLView.h"
#import "CapaTrack.h"
#import "CapaTrackonStreetV.h"

@interface ViewController : MetaioSDKViewController<CapaDelegate>{
    CGRect screenBounds;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    CLLocationCoordinate2D mapCoordinate;
    CLLocationCoordinate2D preMapCoordinate; //以前のmapCoordinateを代入
    
    CLLocationCoordinate2D panoramaNear; //静電マーカーを設置した地点の座標
    
    GMSPanoramaView *panoramaView;
    
    NSString *pre_markerName;
}

@property AVAudioPlayer *recogSound;
@property CapaTrack *capatrack;
@property CapaTrackonStreetV *capatrackOnStreetV;

 //google map
@property (nonatomic, strong) GMSMapView *mapView;

@end
