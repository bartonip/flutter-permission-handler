//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "PermissionStrategy.h"

#if PERMISSION_ACTIVITY_RECOGNITION

#import <CoreMotion/CoreMotion.h>

@interface ActivityRecognitionPermissionStrategy : NSObject <PermissionStrategy>
@end

#else

#import "UnknownPermissionStrategy.h"
@interface ActivityRecognitionPermissionStrategy : UnknownPermissionStrategy
@end

#endif
