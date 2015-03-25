//
//  CapaTrack.m
//  ARMetaioMap
//
//  Created by 池田昂平 on 2015/01/18.
//  Copyright (c) 2015年 池田昂平. All rights reserved.
//

#import "CapaTrack.h"

@implementation CapaTrack

//マーカーとして認識完了
- (void)didRecognition{
    
    self.capaRecog = YES; //認識状態
    
    [self.capaRecogSound play]; //認識音
    
    /*
    BOOL isSuccessShowing = [self.delegate showStreetView]; //ストリートビュー表示
    if(isSuccessShowing == NO){
        self.capaRecog = NO;
    }
    */
    [self.delegate showStreetView]; //ストリートビュー表示
}

@end
