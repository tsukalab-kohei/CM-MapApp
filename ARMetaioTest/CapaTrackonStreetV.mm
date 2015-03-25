//
//  CapaTrackonStreetV.m
//  ARMetaioMap
//
//  Created by 池田昂平 on 2015/01/18.
//  Copyright (c) 2015年 池田昂平. All rights reserved.
//

#import "CapaTrackonStreetV.h"

@implementation CapaTrackonStreetV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//（前後左右）の動作判別を行う
- (void)trackMove{

    CGPoint moveDistance = CGPointMake(center.x - prev_center.x, center.y - prev_center.y);
    moveDistance.x = (moveDistance.x / 132) * 2.54; //cmに変換
    moveDistance.y = (moveDistance.y / 132) * 2.54; //cmに変換

    sumDistance.x = sumDistance.x + moveDistance.x; //移動距離の総和
    sumDistance.y = sumDistance.y + moveDistance.y;

    NSLog(@"sumDistance.x = %.2lf", sumDistance.x);
    NSLog(@"sumDistance.y = %.2lf", sumDistance.y);

    moveFlag = NO; //前後左右へ移動したかどうか → 描画時の手がかり

    //1cm以上移動した時に動作検知
    if(sumDistance.x > 0){
        if(sumDistance.x > 1){
            NSLog(@"右へ動いた");
            NSLog(@"sumDistance.x = %.2lfcm", sumDistance.x);
            moveState = @"→";
            moveFlag = YES;
            sumDistance.y = 0; //y軸移動距離の初期化
        }
    }else if(sumDistance.x < 0){
        if(sumDistance.x < -1){
            NSLog(@"左へ動いた");
            NSLog(@"sumDistance.x = %.2lfcm", sumDistance.x);
            moveState = @"←";
            moveFlag = YES;
            sumDistance.y = 0; //y軸移動距離の初期化
        }
    }
    
    if(sumDistance.y > 0){
        if(sumDistance.y > 1){
            NSLog(@"後ろへ動いた");
            NSLog(@"sumDistance.y = %.2lfcm", sumDistance.y);
            moveState = @"↓";
            moveFlag = YES;
            sumDistance.x = 0; //x軸移動距離の初期化
        }
    }else if(sumDistance.y < 0){
        if(sumDistance.y < -1){
            NSLog(@"前へ動いた");
            NSLog(@"sumDistance.y = %.2lfcm", sumDistance.y);
            moveState = @"↑";
            moveFlag = YES;
            sumDistance.x = 0; //x軸移動距離の初期化
            
            //[self.delegate moveStreetView];
        }
    }
    
    prev_center = center;
}

//マーカーの回転角度を求める
- (void)calcAngle:(CGPoint)fp1 fixedPoints2:(CGPoint)fp2 fixedPoints3:(CGPoint)fp3 centerPoint:(CGPoint)cp{
    //固定点と中央点の位置関係 → マーカーの向きを4つに分類
    if((fp3.x >= cp.x)&&(fp3.y >= cp.y)){
        NSLog(@"回転角 0°");
        if(fp1.y > fp2.y){
            //int index = fixP1_ind;
            //fixP1_ind = fixP2_ind;
            //fixP2_ind = index; //P1とP2 要素番号の入れ替え
            
            CGPoint position = fp1;
            fp1 = fp2;
            fp2 = position; //P1とP2 要素番号の入れ替え
            [curr_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [prev_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
        
        //center.x = fp2.x + (fp1.x - fp2.x) / 2;
        //center.y = fp1.y + (fp2.y - fp1.y) / 2;
        
    }else if((fp3.x >= cp.x)&&(fp3.y <= cp.y)){
        NSLog(@"回転角 90°");
        if(fp1.y > fp2.y){
            //int index = fixP1_ind;
            //fixP1_ind = fixP2_ind;
            //fixP2_ind = index;
            
            CGPoint position = fp1;
            fp1 = fp2;
            fp2 = position;
            [curr_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [prev_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
        
        //center.x = fp1.x + (fp2.x - fp1.x) / 2;
        //center.y = fp1.y + (fp2.y - fp1.y) / 2;
        
    }else if((fp3.x <= cp.x)&&(fp3.y <= cp.y)){
        NSLog(@"回転角 180°");
        if(fp1.y < fp2.y){
            //int index = fixP1_ind;
            //fixP1_ind = fixP2_ind;
            //fixP2_ind = index;

            CGPoint position = fp1;
            fp1 = fp2;
            fp2 = position;
            [curr_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [prev_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }

        //center.x = fp1.x + (fp2.x - fp1.x) / 2;
        //center.y = fp2.y + (fp1.y - fp2.y) / 2;

    }else if((fp3.x <= cp.x)&&(fp3.y >= cp.y)){
        NSLog(@"回転角 270°");
        if(fp1.y < fp2.y){
            //int index = fixP1_ind;
            //fixP1_ind = fixP2_ind;
            //fixP2_ind = index;

            CGPoint position = fp1;
            fp1 = fp2;
            fp2 = position;
            [curr_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [prev_fixedpointsPosi exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }

        //center.x = fp2.x + (fp1.x - fp2.x) / 2;
        //center.y = fp2.y + (fp1.y - fp2.y) / 2;
    }

    //角度の計算
    float y = fp1.y - fp3.y;
    float x = fp1.x - fp3.x;
    float radian = atan2f(y, x);
    
    radian = radian * (-1); //角度の回転方向を反転
    degree = (radian / (2*M_PI)) * 360 + 180; // -180~180° → 0~360°．
    degree = degree + 90; //0~360° → 90~450°（90°足して0°が来る向きを合わせる．）
    degree = fmodf(degree, 360);
    
    NSLog(@"radian = %lf", radian);
    NSLog(@"degree = %lf", degree);
    
    [self.delegate rotateStreetView:degree];
}


@end
