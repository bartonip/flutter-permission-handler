//
// Created by Razvan Lung(long1eu) on 2019-02-15.
// Copyright (c) 2019 The Chromium Authors. All rights reserved.
//

#import "ActivityRecognitionPermissionStrategy.h"

#if PERMISSION_ACTIVITY_RECOGNITION

@implementation ActivityRecognitionPermissionStrategy

- (PermissionStatus)checkPermissionStatus:(PermissionGroup)permission {
    return [ActivityRecognitionPermissionStrategy permissionStatus];
}

- (ServiceStatus)checkServiceStatus:(PermissionGroup)permission {
    return ServiceStatusNotApplicable;
}

- (void)requestPermission:(PermissionGroup)permission completionHandler:(PermissionStatusHandler)completionHandler {
    PermissionStatus status = [self checkPermissionStatus:permission];
    if (status != PermissionStatusDenied) {
        completionHandler(status);
        return;
    }

    if (@available(iOS 11.0, *)) {
        NSDate *now = [NSDate date];
        [CMPedometer startPedometerUpdatesFromDate:now withHandler:(CMPedometerData *pedometerData, NSError *error) {
            completionHandler([ActivityRecognitionPermissionStrategy determinePermissionStatus:status]);
            [CMPedometer stopPedometerUpdates];
        }];
    } else {
        NSTimeInterval duration = 0.1;
        [CMSensorRecorder recordAccelerometerForDuration:duration];
        completionHandler([ActivityRecognitionPermissionStrategy determinePermissionStatus:status]);
        return;
    }
}

+ (PermissionStatus)permissionStatus {
    if(@available(iOS 11.0, *)) {
        CMAuthorizationStatus status = [CMPedometer authorizationStatus];
        return [ActivityRecognitionPermissionStrategy determinePermissionStatus:status];
    } else {
        CMAuthorizationStatus status = [CMSensorRecorder authorizationStatus];
        return [ActivityRecognitionPermissionStrategy determinePermissionStatus:status];
    }

    return PermissionStatusDenied;
}

+ (PermissionStatus)determinePermissionStatus:(CMAuthorizationStatus)authorizationStatus {
    switch (authorizationStatus) {
        case CMAuthorizationStatusNotDetermined:
            return PermissionStatusDenied;
        case CMAuthorizationStatusDenied:
            return PermissionStatusPermanentlyDenied;
        case CMAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        case CMAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    }

    return PermissionStatusDenied;
}

@end

#else

@implementation MediaLibraryPermissionStrategy
@end

#endif
