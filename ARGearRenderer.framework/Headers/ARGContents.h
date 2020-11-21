//
//  ARContents.h
//  ARGEARSDK
//
//  Created by Jaecheol Kim on 2019/11/13.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, ARGContentItemType)  {
    ARGContentItemTypeSticker,
    ARGContentItemTypeFilter,
    ARGContentItemTypeBeauty,
    ARGContentItemTypeBulge,
    ARGContentItemTypeNum
};

typedef NS_ENUM (NSInteger, ARGContentItemFilterOption)  {
    ARGContentItemFilterOptionBlur,
    ARGContentItemFilterOptionVignetting,
    ARGContentItemFilterOptionNum
    
};

typedef NS_ENUM (NSInteger, ARGContentItemBulge)  {
    ARGContentItemBulgeNONE         = -1,
    ARGContentItemBulgeFUN1         = 1,
    ARGContentItemBulgeFUN2         = 2,
    ARGContentItemBulgeFUN3         = 3,
    ARGContentItemBulgeFUN4         = 4,
    ARGContentItemBulgeFUN5         = 5,
    ARGContentItemBulgeFUN6         = 6,
    ARGContentItemBulgeNum
};

typedef NS_ENUM (NSInteger, ARGContentItemBeauty)  {
    ARGContentItemBeautyVline = 0,
    ARGContentItemBeautyFaceSlim,
    ARGContentItemBeautyJaw,
    ARGContentItemBeautyChin,
    ARGContentItemBeautyEye,
    ARGContentItemBeautyEyeGap,
    ARGContentItemBeautyNoseLine,
    ARGContentItemBeautyNoseSise,
    ARGContentItemBeautyNoseLength,
    ARGContentItemBeautyMouthSize,
    ARGContentItemBeautyEyeBack,
    ARGContentItemBeautyEyeCorner,
    ARGContentItemBeautyLipSize,
    ARGContentItemBeautySkinFace,
    ARGContentItemBeautySkinDarkCircle,
    ARGContentItemBeautySkinMouthWrinkle,
    ARGContentItemBeautyNum
};

typedef __strong void (^ARGContentsCallback)(BOOL success, NSString* _Nullable msg);

@interface ARGContents : NSObject

@property (nonatomic, strong) NSString *stickerItemID;
@property (nonatomic, strong) NSString *filterItemID;

- (void)setItemWithType:(ARGContentItemType)itemType
       withItemFilePath:(NSString * _Nullable)itemFilePath
             withItemID:(NSString * _Nullable)itemId
                completion:(ARGContentsCallback _Nullable)callback;

- (void)setFilterLevel:(float)level;

- (void)setDefaultBeauty;
- (void)setBeautyOn:(BOOL)on;
- (void)setBeauty:(ARGContentItemBeauty)type value:(float)value;
- (float)getBeautyValue:(ARGContentItemBeauty)type;
- (void)setBeautyValues:(float *_Nonnull)values;

- (void)setBulge:(ARGContentItemBulge)bulge;

- (void)clear:(ARGContentItemType)itemType;

@end

NS_ASSUME_NONNULL_END
