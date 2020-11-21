//
//  ARGMedia.h
//  ARGEARSDK
//
//  Created by Jaecheol Kim on 2019/11/12.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kARGMediaAutoSave @"kARGMediaAutoSave"

typedef void(^GoToPreviewBlock) (void);

typedef void (^ARGMediaSaveSuccess) (void);
typedef void (^_Nullable ARGMediaSaveError) (void);

typedef struct ARGMediaSaveBlock {
    ARGMediaSaveSuccess Success;
    ARGMediaSaveError Error;
} ARGMediaSaveBlock;

typedef NS_ENUM(NSInteger, ARGMediaRatio) {
    ARGMediaRatio_16x9,
    ARGMediaRatio_4x3,
    ARGMediaRatio_1x1,
};

typedef NS_ENUM(NSInteger, ARGMediaMode) {
    ARGMediaModePhoto,
    ARGMediaModeVideo,
};

typedef NS_ENUM(NSInteger, ARGMediaVideoBitrate) {
    ARGMediaVideoBitrate_4M,
    ARGMediaVideoBitrate_2M,
    ARGMediaVideoBitrate_1M,
};

@interface ARGMedia : NSObject

@property (nonatomic, assign) BOOL autoSave;
@property (nonatomic, assign) BOOL recordSound;

- (void)setVideoDevice:(AVCaptureDevice *)device;
- (void)setVideoConnection:(AVCaptureConnection *)connection;
- (void)setVideoDeviceOrientation:(AVCaptureVideoOrientation)videoOrientation;
- (void)setMediaRatio:(ARGMediaRatio)mediaRatio;
- (void)setMediaMode:(ARGMediaMode)mediaMode;
- (void)setVideoBitrate:(ARGMediaVideoBitrate)videoBitrate;

- (void)takePic:(void (^ __nullable)(UIImage * _Nullable image))completion;

// Recording
- (AVCaptureVideoOrientation)getRecordingOrientation;

- (void)recordVideoStart:(void (^ __nullable)(CGFloat recTime))completion;

- (void)recordVideoStop:(void (^ __nullable)(NSDictionary * __nonnull videoInfo))stopBlock
                   save:(void (^ __nullable)(NSDictionary * __nonnull videoInfo))saveBlock;

// Album
- (void)saveImage:(UIImage *)image saved:(ARGMediaSaveSuccess)saved goToPreview:(GoToPreviewBlock)previewBlock;
- (void)saveVideo:(NSDictionary *)videoInfo saved:(ARGMediaSaveSuccess)saved goToPreview:(GoToPreviewBlock)previewBlock;

- (void)saveImageToAlbum:(UIImage *)image success:(ARGMediaSaveSuccess)success error:(ARGMediaSaveError)error;
- (void)saveVideoToAlbum:(NSURL *)url success:(ARGMediaSaveSuccess)success error:(ARGMediaSaveError)error;

@end

NS_ASSUME_NONNULL_END
