//
// Created by Barton Ip(bartonip) on 2022-08-11.
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
