//
//  CapaTrack.h
//  ARMetaioTest
//
//  Created by 池田昂平 on 2014/11/18.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MetaioSDKViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@protocol CapaDelegate <NSObject>
// デリゲートメソッドを宣言
- (void)showStreetView;
- (void)moveStreetView;
- (void)rotateStreetView:(float)degree;
@end

@interface CapaTrackBase : UIView{
    CGPoint prev_center; //中心（以前）
    CGPoint center; //中心
    CGPoint fixP1_posi; //固定点の座標
    CGPoint fixP2_posi;
    CGPoint fixP3_posi;
    CGPoint cenP_posi; //中央点の座標
    
    float degree; //回転角
    CGPoint sumDistance; //移動距離の総和
    NSString *moveState; //移動した方向
    BOOL moveFlag; //移動したかどうか
    
    NSMutableArray *prev_fixedpointsPosi; //固定点の座標（以前）
    NSMutableArray *curr_fixedpointsPosi; //固定点の座標（現在）*findSameFixedPointsで使用
    
    NSString *movingTxt;
    NSString *stopTxt;
}

@property (nonatomic, strong) id<CapaDelegate> delegate; //デリゲート先で参照できるようにプロパティを定義

@property AVAudioPlayer *capaRecogSound; //認識音

//ARに関するプロパティ
@property BOOL armarkerRecog; //認識状態 (AR)
@property int aridNum; //ID (AR)
@property NSString* aridName; //IDの名前 (AR)

@property metaio::Vector3d transComp; //座標 (AR)
@property metaio::Vector2d arLocaVec2d; //座標 (AR)
@property CGPoint arLocaCGPoint; //座標 (AR)
@property metaio::Vector3d rotation; //座標 (AR)

//capa（静電マーカー）に関するプロパティ
@property BOOL capaRecog; //認識状態 (静電マーカー) 初めの一回目認識されたときのみYES
@property int capaidNum; //ID (静電マーカー)
@property NSArray *touchObjects; //タッチオブジェクト (4点)
@property BOOL calcReset;

//地図に関するプロパティ
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSPanoramaView *panoramaView;
@property BOOL isMapAnimating;

@end
