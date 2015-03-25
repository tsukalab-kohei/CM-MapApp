//
//  CapaTrackonStreetV.h
//  ARMetaioMap
//
//  Created by 池田昂平 on 2015/01/18.
//  Copyright (c) 2015年 池田昂平. All rights reserved.
//

#import "CapaTrackBase.h"

@interface CapaTrackonStreetV : CapaTrackBase

//Override
- (void)trackMove;
- (void)calcAngle:(CGPoint)fp1 fixedPoints2:(CGPoint)fp2 fixedPoints3:(CGPoint)fp3 centerPoint:(CGPoint)cp;

@end
