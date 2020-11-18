//
//  ARGFaceLandmark.h
//  ARGear
//
//  Created by Jaecheol Kim on 2019/10/29.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ARGInference.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARGFaceLandmark : ARGInference
@property(nonatomic) NSUInteger landmarkCount;
@property(nonatomic) simd_float2 *landmarkCoordinates;
@property(nonatomic) simd_float3 *landmarkvertices;
@end

NS_ASSUME_NONNULL_END
