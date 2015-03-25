//
//  CapaTrack.m
//  ARMetaioTest
//
//  Created by 池田昂平 on 2014/11/18.
//  Copyright (c) 2014年 池田昂平. All rights reserved.
//

#import "CapaTrackBase.h"

@implementation CapaTrackBase{
    
}

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //値の初期化
        self.armarkerRecog = NO;
        self.aridNum = 0;
        self.multipleTouchEnabled = YES;
        prev_fixedpointsPosi = [[NSMutableArray alloc] init];
        curr_fixedpointsPosi = [[NSMutableArray alloc] init];
        sumDistance = CGPointMake(0, 0);
        
        [self loadSound];
        
        UIColor *dblue = [UIColor colorWithRed:0x33/255.0 green:0 blue:0x99/255.0 alpha:0.0];
        self.backgroundColor = dblue;
        
        movingTxt = [NSString stringWithFormat: @"Moving"];
        stopTxt = [NSString stringWithFormat: @"Stop"];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIColor *deepskyblue = [UIColor colorWithRed:0 green:0.749 blue:1 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:1 green:0.33 blue:0 alpha:1.0];
    UIColor *transRed = [UIColor colorWithRed:1 green:0.33 blue:0 alpha:0.3];
    UIColor *clear = [UIColor clearColor];
    
    if(self.armarkerRecog){
        //マーカー認識成功
        
        NSLog(@"armarkerRecog");
        
        //円描画
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 5.0);
        CGContextSetStrokeColorWithColor(context, [deepskyblue CGColor]); //青色
        
        float ellipseWidth = self.transComp.z + 460;
        //if()
        float ellipseX = self.arLocaCGPoint.x - 50;
        float ellipseY = self.arLocaCGPoint.y - 100;
        
        /*
        if((ellipseX < 0)||(ellipseY < 0)||(ellipseX + ellipseWidth > 768)||(ellipseY + ellipseWidth > 1024)){
            CGContextSetStrokeColorWithColor(context, [red CGColor]); //赤色
            self.backgroundColor = transRed;
        }else{
            self.backgroundColor = clear;
        }
         */
        
        /*
        if(self.transComp.z >= -250){
            //self.isMapAnimating = NO;
            CGPoint point_operation = CGPointMake(150, 500);
            UIFont *font_operation = [UIFont systemFontOfSize:50];
            [@"Put the marker" drawAtPoint:point_operation withAttributes:@{NSFontAttributeName:font_operation, NSForegroundColorAttributeName: [UIColor blackColor]}];
            
        }else if(self.transComp.z >= -270){
            //self.isMapAnimating = YES;
            CGContextSetStrokeColorWithColor(context, [deepskyblue CGColor]);
            CGContextStrokeEllipseInRect(context, CGRectMake(ellipseX, ellipseY, ellipseWidth, ellipseWidth));
            //タッチの指示を画面上に表示
        }else{
            //self.isMapAnimating = YES;
            CGContextSetStrokeColorWithColor(context, [deepskyblue CGColor]);
            CGContextStrokeEllipseInRect(context, CGRectMake(ellipseX + 100, ellipseY, 200, 200));
        }
        */
        /*
        NSLog(@"arLocation:(%f, %f)", self.arLocaCGPoint.x, self.arLocaCGPoint.y);
        CGContextStrokeEllipseInRect(context, CGRectMake(ellipseX, ellipseY, ellipseWidth, ellipseWidth));
         */
        
        /*
        if(self.transComp.z <= -200){
            CGContextStrokeEllipseInRect(context, CGRectMake(ellipseX, ellipseY, ellipseWidth, ellipseWidth));
        }else{
            //タッチの指示を画面上に表示
        }
         */
        NSLog(@"self.transComp.z: %lf", self.transComp.z);
        
        if(self.isMapAnimating){
            CGPoint point1 = CGPointMake(50, 50);
            UIFont *font1 = [UIFont systemFontOfSize:50];
            [movingTxt drawAtPoint:point1 withAttributes:@{NSFontAttributeName:font1, NSForegroundColorAttributeName: [UIColor blackColor]}];
            
            CGContextSetStrokeColorWithColor(context, [deepskyblue CGColor]); //青色
            
            //UIColor *animatingColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.3];
            UIColor *animatingColor = transRed;
            CGContextSetStrokeColorWithColor(context, [red CGColor]); //赤色
            self.backgroundColor = animatingColor;
        }else{
            CGPoint point2 = CGPointMake(50, 50);
            UIFont *font2 = [UIFont systemFontOfSize:50];
            [stopTxt drawAtPoint:point2 withAttributes:@{NSFontAttributeName:font2, NSForegroundColorAttributeName: [UIColor blackColor]}];
            
            self.backgroundColor = clear;
        }
        
        NSLog(@"arLocation:(%f, %f)", self.arLocaCGPoint.x, self.arLocaCGPoint.y);
        CGContextStrokeEllipseInRect(context, CGRectMake(ellipseX, ellipseY, ellipseWidth, ellipseWidth));

        
        /*
        //座標・角度の表示
        NSString *arCoordinateTxt = [NSString stringWithFormat:@"x:%f  y:%f",self.arLocaVec2d.x, self.arLocaVec2d.y];
        NSString *arRotationTxt = [NSString stringWithFormat:@"z-axis:%f", self.rotation.z];
        
        CGPoint point_coor = CGPointMake(50, 50);
        CGPoint point_rota = CGPointMake(50, 100);
        UIFont *font = [UIFont systemFontOfSize:30];
        
        [arCoordinateTxt drawAtPoint:point_coor withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: deepskyblue}];
        [arRotationTxt drawAtPoint:point_rota withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: deepskyblue}];
        */

        
        /*
        self.backgroundColor = dblue;
        
        NSString *arRecogTxt = @"Marker recognition is success.";
        CGPoint point = CGPointMake(50, 50);
        UIFont *font = [UIFont systemFontOfSize:30];
        //[arRecogTxt drawAtPoint:point withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor orangeColor]}];
        [arRecogTxt drawAtPoint:point withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: deepskyblue}];
        
        //ID認識成功
        if(self.aridNum > 0){
            NSString *idTxt = [NSString stringWithFormat: @"Marker ID : NO.%d.", self.aridNum];
            CGPoint point2 = CGPointMake(50, 100);
            UIFont *font2 = [UIFont systemFontOfSize:30];
            //[idTxt drawAtPoint:point2 withAttributes:@{NSFontAttributeName:font2, NSForegroundColorAttributeName: [UIColor orangeColor]}];
            [idTxt drawAtPoint:point2 withAttributes:@{NSFontAttributeName:font2, NSForegroundColorAttributeName: deepskyblue}];
        }
         */
    }
    
    //マーカー認識が成功した場合に描画
    if(self.capaRecog){
        NSString *degreeStr = [NSString stringWithFormat:@"degree: %.0lf°", degree];
        UIFont *font_move = [UIFont systemFontOfSize:50];
        [degreeStr drawAtPoint:CGPointMake(50, 50) withAttributes:@{NSFontAttributeName:font_move, NSForegroundColorAttributeName: deepskyblue}];
    }
    
    //ID認識が成功した場合に描画
    if((self.capaRecog)&&(self.capaidNum > 0)){
        
    }
}

- (void)loadSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"recog" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.capaRecogSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
}

//タッチイベント
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //4点以外の認識になったとき
    if([[event allTouches] count] != 4){
        self.calcReset = YES; //再度2点間の距離を計算
        self.capaRecog = NO;
        return;
    }
    [self showTouchPoint:[event allTouches]];
}

//ドラッグイベント
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[event allTouches] count] != 4){
        return;
    }
    //[self showTouchPoint:[event allTouches]];
    
    if(([prev_fixedpointsPosi count] >= 4)&&([curr_fixedpointsPosi count] >= 4)){
        //最寄りの点を探索
        [self findSameFixedPoints:[event allTouches]];
    }else{
        [self calcDistance];
    }
}

//タッチオブジェクト取得
- (void)showTouchPoint:(NSSet *)allTouches{
    self.touchObjects = [allTouches allObjects]; //タッチオブジェクト(4点)を配列に保存
    
    if(self.calcReset){
        [self calcDistance]; //距離
    }
}

- (void)calcDistance{
    NSLog(@"calcDistance");
    
    //手順
    //①fixP1とfixP2 (対角線上にある固定点) を求める
    //②fixP3 (3点目の固定点) を求める
    
    //最大2点間距離 = fixP1・fixP2距離
    float maxDis = 0;
    
    //固定点 (要素番号)
    int fixP1_ind = 0;
    int fixP2_ind = 0;
    int fixP3_ind = 0;
    
    //中央点 (要素番号)
    int cenP_ind = 0;
    
    
    //①fixP1とfixP2を探す
    for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            //全ての2点間距離を計算
            if(i != j){
                UITouch *tobj1 = [self.touchObjects objectAtIndex:i];
                UITouch *tobj2 = [self.touchObjects objectAtIndex:j];
                CGPoint loc1 = [tobj1 locationInView:self];
                CGPoint loc2 = [tobj2 locationInView:self];
                
                float disX = pow((loc1.x - loc2.x), 2); //xの差分を2乗
                float disY = pow((loc1.y - loc2.y), 2); //yの差分を2乗
                float dis = sqrt(disX + disY); //2点間の距離を求める
                
                //最大2点間距離
                if(dis > maxDis){
                    maxDis = dis;
                    fixP1_ind = i;
                    fixP2_ind = j;
                    fixP1_posi = loc1;
                    fixP2_posi = loc2;
                }
            }
        }
    }
    
    //fixP1とfixP2の座標を保存（現在）
    if([curr_fixedpointsPosi count] >= 4){
        [curr_fixedpointsPosi replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:fixP1_posi]];
        [curr_fixedpointsPosi replaceObjectAtIndex:1 withObject:[NSValue valueWithCGPoint:fixP2_posi]];
    }else{
        [curr_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:fixP1_posi] atIndex:0];
        [curr_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:fixP2_posi] atIndex:1];
    }
    
    //fixP1とfixP2の座標を保存（以前）
    if([prev_fixedpointsPosi count] >= 4){
        [prev_fixedpointsPosi replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:fixP1_posi]];
        [prev_fixedpointsPosi replaceObjectAtIndex:1 withObject:[NSValue valueWithCGPoint:fixP2_posi]];
    }else{
        [prev_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:fixP1_posi] atIndex:0];
        [prev_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:fixP2_posi] atIndex:1];
    }
    NSLog(@"固定点2点：(%.1f, %.1f)と(%.1f, %.1f)", fixP1_posi.x, fixP1_posi.y, fixP2_posi.x, fixP2_posi.y);
    
    
    //②fixP3を探す
    for(int i = 0; i < 4; i++){
        //残り2点の中から
        if((i != fixP1_ind)&&(i != fixP2_ind)){
            //fixP1との距離を調べる
            UITouch *tobj1 = [self.touchObjects objectAtIndex:fixP1_ind]; //fixP1
            UITouch *tobj3 = [self.touchObjects objectAtIndex:i]; //調べる点
            CGPoint loc1 = [tobj1 locationInView:self];
            CGPoint loc3 = [tobj3 locationInView:self];
            
            float disX = pow((loc1.x - loc3.x), 2);
            float disY = pow((loc1.y - loc3.y), 2);
            float dis = sqrt(disX + disY); //2点間の距離
            dis = (dis / 132) * 2.54; //px → cm 変換
            
            //fixP1との距離が特定の数値のとき
            if((dis >= 2.0)&&(dis <= 4.0)){
                NSLog(@"dis = %.1fcm", dis);
                
                //fixP2との距離を調べる
                UITouch *tobj2 = [self.touchObjects objectAtIndex:fixP2_ind]; //fixP2
                CGPoint loc2 = [tobj2 locationInView:self];
                
                float disX = pow((loc2.x - loc3.x), 2);
                float disY = pow((loc2.y - loc3.y), 2);
                dis = sqrt(disX + disY); //2点間の距離
                dis = (dis / 132) * 2.54; //px → cm 変換
                
                NSLog(@"dis = %.1fcm", dis);
                
                //fixP2との距離が特定の数値のとき
                if((dis >= 2.0)&&(dis <= 4.0)){
                    fixP3_ind = i;
                    fixP3_posi = loc3;
                    
                    //fixP3の座標を保存（現在）
                    if([curr_fixedpointsPosi count] >= 4){
                        [curr_fixedpointsPosi replaceObjectAtIndex:2 withObject:[NSValue valueWithCGPoint:fixP3_posi]];
                    }else{
                        [curr_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:fixP3_posi] atIndex:2];
                    }
                    
                    //fixP3の座標を保存（以前）
                    if([prev_fixedpointsPosi count] >= 4){
                        [prev_fixedpointsPosi replaceObjectAtIndex:2 withObject:[NSValue valueWithCGPoint:fixP3_posi]];
                    }else{
                        [prev_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:fixP3_posi] atIndex:2];
                    }
                    NSLog(@"残りの固定点：(%.1f, %.1f)", fixP3_posi.x, fixP3_posi.y);
                    NSLog(@"prev_fixedpointsPosi : %@", [prev_fixedpointsPosi description]);
                    
                    
                    //中央の可変点cenPを求める
                    for(int i = 0; i < 4; i++){
                        if((i != fixP1_ind)&&(i != fixP2_ind)&&(i != fixP3_ind)){
                            cenP_ind = i;
                            UITouch *tobj4 = [self.touchObjects objectAtIndex:cenP_ind]; //cenP
                            cenP_posi = [tobj4 locationInView:self];
                            
                            NSLog(@"中央点：(%.1f, %.1f)", cenP_posi.x, cenP_posi.y);
                        }
                    }
                    //fixP3の座標を保存（現在）
                    if([curr_fixedpointsPosi count] >= 4){
                        [curr_fixedpointsPosi replaceObjectAtIndex:3 withObject:[NSValue valueWithCGPoint:cenP_posi]];
                    }else{
                        [curr_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:cenP_posi] atIndex:3];
                        NSLog(@"prev_fixedpointsPosi : %@", [prev_fixedpointsPosi description]);
                    }
                    
                    //fixP3の座標を保存（以前）
                    if([prev_fixedpointsPosi count] >= 4){
                        [prev_fixedpointsPosi replaceObjectAtIndex:3 withObject:[NSValue valueWithCGPoint:cenP_posi]];
                    }else{
                        [prev_fixedpointsPosi insertObject:[NSValue valueWithCGPoint:cenP_posi] atIndex:3];
                    }
                    
                    
                    
                    //静電マーカーの中心
                    [self calcCenter:fixP1_posi fixedPoints2:fixP2_posi fixedPoints3:fixP3_posi];
                    
                    //静電マーカーの中心座標を更新
                    prev_center = center;
                    sumDistance = CGPointMake(0, 0);
                    
                    
                    //マーカーとして認識
                    [self didRecognition];
                    
                    //fixP1・cenP間の距離
                    float dis1X = pow((cenP_posi.x - fixP1_posi.x), 2);
                    float dis1Y = pow((cenP_posi.y - fixP1_posi.y), 2);
                    float dis1 = sqrt(dis1X + dis1Y);
                    dis1 = (dis1 / 132) * 2.54; //px → cm 変換
                    NSLog(@"dis1 (%@)と中央点の距離 = %.1fcm", NSStringFromCGPoint(fixP1_posi), dis1);
                    
                    //fixP2・cenP間の距離
                    float dis2X = pow((cenP_posi.x - fixP2_posi.x), 2);
                    float dis2Y = pow((cenP_posi.y - fixP2_posi.y), 2);
                    float dis2 = sqrt(dis2X + dis2Y);
                    dis2 = (dis2 / 132) * 2.54; //px → cm 変換
                    NSLog(@"dis2 (%@)と中央点の距離 = %.1fcm", NSStringFromCGPoint(fixP2_posi), dis2);
                    
                    //fixP3・cenP間の距離
                    float dis3X = pow((cenP_posi.x - fixP3_posi.x), 2);
                    float dis3Y = pow((cenP_posi.y - fixP3_posi.y), 2);
                    float dis3 = sqrt(dis3X + dis3Y);
                    dis3 = (dis3 / 132) * 2.54; //px → cm 変換
                    NSLog(@"dis3 (%@)と中央点の距離 = %.1fcm", NSStringFromCGPoint(fixP3_posi), dis3);
                    
                    //IDの判別
                    [self identify:dis1 distance3:dis3];
                    
                    break; //中央点が求まったので, 探索終了
                }else{
                    self.capaRecog = NO;
                }
            }else{
                self.capaRecog = NO;
            }
        }
    }//②fixP3を探す
    
    //一度限りの実行
    self.calcReset = NO;
}

//同一の固定点を探す(マーカーがドラッグされた時)
- (void)findSameFixedPoints:(NSSet *)allTouches{
    NSLog(@"findSameFixedPoints");
    
    //配列に保存
    self.touchObjects = [allTouches allObjects];
    
    //保存した3つの固定点について、同一固定点をタッチオブジェクトの中から見つける
    for(int j = 0; j < 4; j++){
        //保存した固定点の座標を復元
        NSValue *value = [prev_fixedpointsPosi objectAtIndex:j];
        CGPoint pre_loc = [value CGPointValue];
        
        float minDis = MAXFLOAT;
        int pointIndex = 0;
        CGPoint pointLocation = CGPointMake(0, 0);
        
        for(int i = 0; i < 4; i++){
            //タッチオブジェクトの座標を取り出す
            UITouch *tobj = [self.touchObjects objectAtIndex:i];
            CGPoint loc = [tobj locationInView:self];
            
            float disX = pow((loc.x - pre_loc.x), 2);
            float disY = pow((loc.y - pre_loc.y), 2);
            float dis = sqrt(disX + disY); //2点間の距離
            
            //最短2点間距離
            if(dis < minDis){
                minDis = dis;
                pointIndex = i; //i番目のタッチオブジェクトが同一点である
                pointLocation = loc; //タッチオブジェクトの座標を控えておく
            }
        }
        
        [curr_fixedpointsPosi replaceObjectAtIndex:j withObject:[NSValue valueWithCGPoint:pointLocation]];
        [prev_fixedpointsPosi replaceObjectAtIndex:j withObject:[NSValue valueWithCGPoint:pointLocation]];
        
        minDis = (minDis / 132) * 2.54;
        NSLog(@"最短距離：%.2lfcm,", minDis);
        NSLog(@"%d番目のタッチオブジェクト,", pointIndex);
    }
    
    //中心の座標を更新
    CGPoint fp1 = [[curr_fixedpointsPosi objectAtIndex:0] CGPointValue];
    CGPoint fp2 = [[curr_fixedpointsPosi objectAtIndex:1] CGPointValue];
    CGPoint fp3 = [[curr_fixedpointsPosi objectAtIndex:2] CGPointValue];
    CGPoint cp = [[curr_fixedpointsPosi objectAtIndex:3] CGPointValue];
    [self calcCenter:fp1 fixedPoints2:fp2 fixedPoints3:fp3];
    
    //動作を判別
    [self trackMove];
    
    //角度を測定
    [self calcAngle:fp1 fixedPoints2:fp2 fixedPoints3:fp3 centerPoint:cp];
    
    [self setNeedsDisplay];
}


//マーカーとして認識完了
- (void)didRecognition{

    self.capaRecog = YES; //認識状態
    
    [self.capaRecogSound play]; //認識音
    
    //[self.delegate showStreetView]; //ストリートビュー表示
}

//ID (静電マーカー)
- (void)identify:(float)d1 distance3:(float)d3{
    NSLog(@"d1 = %.1fcm", d1);
    NSLog(@"d3 = %.1fcm", d3);
    
    self.capaidNum = 0;
    
    //Marker NO.1
    if( ((d1 >= 1.0)&&(d1 <= 1.6)) && ((d3 >= 2.0)&&(d3 <=  2.6)) ){
        NSLog(@"このマーカーはNO.1");
        self.capaidNum = 1;
    }
    
    //Marker NO.3
    if( ((d1 >= 2.0)&&(d1 <= 2.6)) && ((d3 >= 2.7)&&(d3 <= 3.3)) ){
        NSLog(@"このマーカーはNO.3");
        self.capaidNum = 3;
    }
    
    //Marker NO.4
    if( ((d1 >= 1.5)&&(d1 <= 2.1)) && ((d3 >= 1.4)&&(d3 <= 2.0)) ){
        NSLog(@"このマーカーはNO.4");
        self.capaidNum = 4;
    }
    
    //Marker NO.5
    if( ((d1 >= 1.8)&&(d1 <= 2.4)) && ((d3 >= 1.8)&&(d3 <= 2.4)) ){
        NSLog(@"このマーカーはNO.5");
        self.capaidNum = 5;
    }
    
    //Marker NO.6
    if( ((d1 >= 1.9)&&(d1 <= 2.5)) && ((d3 >= 2.2)&&(d3 <= 2.8)) ){
        NSLog(@"このマーカーはNO.6");
        self.capaidNum = 6;
    }
    
    //Marker NO.7
    if( ((d1 >= 2.0)&&(d1 <= 2.6)) && ((d3 >= 1.0)&&(d3 <= 1.6)) ){
        NSLog(@"このマーカーはNO.7");
        self.capaidNum = 7;
    }
    
    //Marker NO.8
    if( ((d1 >= 2.3)&&(d1 <= 2.9)) && ((d3 >= 1.4)&&(d3 <= 2.0)) ){
        NSLog(@"このマーカーはNO.8");
        self.capaidNum = 8;
    }
    
    //Marker NO.9
    if( ((d1 >= 2.7)&&(d1 <= 3.3)) && ((d3 >= 2.0)&&(d3 <= 2.6)) ){
        NSLog(@"このマーカーはNO.9");
        self.capaidNum = 9;
    }
    
}

//静電マーカーの中央を求める
- (void)calcCenter:(CGPoint)fp1 fixedPoints2:(CGPoint)fp2 fixedPoints3:(CGPoint)fp3{
    //対角線上にある2つの固定点から求める
    center.x = fp1.x + (fp2.x - fp1.x) / 2;
    center.y = fp1.y + (fp2.y - fp1.y) / 2;
    
    //距離の絶対値をとる
    if(center.x < 0){
        center.x = center.x * (-1);
    }
    if(center.y < 0){
        center.y = center.y * (-1);
    }
}

//（前後左右の）動作判別を行う
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
    degree = (radian / (2*M_PI)) * 360 + 180; // -180~180 → 0~360．
    degree = degree + 90; //0~360 → 90~450（90°足して0°が来る向きを合わせる．）
    degree = fmodf(degree, 360);
    
    NSLog(@"radian = %lf", radian);
    NSLog(@"degree = %lf", degree);
}


@end
