//
//  LZWidgetPhotoView.h
//  LizhiFM
//
//  Created by chargechen on 14/10/31.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZWidgetPhotoView : UIView
{
    //data
    NSString *mFileID;
    NSString *mDefaultFileName;
    NSInteger mGender;
    BOOL mIsAutoFetch;
    BOOL mIsShowDefault;
    BOOL mIsChangeFileIDAnimate;
    BOOL mIsPhotoFetched;
    BOOL mIsFromAlbum;
    id mPhotoViewDelegate;
    
    //ui
    UIImageView *mImageView;
    UIImageView *mUploadingIcon;
    UIActivityIndicatorView *mIndicatorView;
}

@property (nonatomic, readonly) NSString *fileID;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) BOOL isAutoFetch;
@property (nonatomic, assign) BOOL isShowDefault;
@property (nonatomic, assign) BOOL isChangeFileIDAnimate;
@property (nonatomic, assign) BOOL isFromAlbum;
@property (nonatomic, retain) NSString *defaultFileName;
@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, assign) BOOL isPhotoFetched;
@property (nonatomic, assign) BOOL isShowWithAnimation;

- (void)setFileID:(NSString *)fileID;
- (void)setFileID:(NSString *)fileID gender:(NSInteger)gender;
- (void)removePhotoFetchObserver;
- (void)startFetch;
- (void)onPhotoFetchedOK:(NSObject *)object;
- (void)onPhotoFetchedFailed;
- (CGSize)imageSize;
- (UIImage *)image;
- (void) setImage:(UIImage *)image;
- (UIImage *)getCurrentImage:(NSString *)fileID;
@end
