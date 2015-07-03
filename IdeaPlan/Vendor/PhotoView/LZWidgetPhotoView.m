//
//  LZWidgetPhotoView.m
//  LizhiFM
//
//  Created by chargechen on 14/10/31.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZWidgetPhotoView.h"
#import "LZThreadMgr.h"
#import "LZWidgetPhotoMgr.h"
#import "IPPhotoCacheMgr.h"
#import "IPImageFileMgr.h"
#define RELEASE_SAFELY(_obj) do { [_obj release]; _obj = nil; } while (0)
#define RETAIN_SAFELY(_receiver, _assigner) do { id __assigner = _assigner; if (__assigner != _receiver) { [_receiver release]; _receiver = [__assigner retain]; } } while (0)
@implementation LZWidgetPhotoView
@synthesize fileID = mFileID;
@synthesize imageView = mImageView;
@synthesize isAutoFetch = mIsAutoFetch;
@synthesize isShowDefault = mIsShowDefault;
@synthesize isChangeFileIDAnimate = mIsChangeFileIDAnimate;
@synthesize isFromAlbum = mIsFromAlbum;
@synthesize defaultFileName = mDefaultFileName;
@synthesize isPhotoFetched = mIsPhotoFetched;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        mFileID = nil;
        mGender = 0;
        mIsAutoFetch = YES;
        mIsShowDefault = YES;
        mIsFromAlbum = NO;
        mIsPhotoFetched = NO;
        mImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
        [mImageView setUserInteractionEnabled:NO];
        [self addSubview:mImageView];
        
    }
    
    return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mFileID = nil;
        mGender = 0;
        mIsAutoFetch = YES;
        mIsShowDefault = YES;
        mIsFromAlbum = NO;
        mIsPhotoFetched = NO;
        mImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
        [mImageView setUserInteractionEnabled:NO];
        [self addSubview:mImageView];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    RELEASE_SAFELY(mFileID);
    RELEASE_SAFELY(mDefaultFileName);
    RELEASE_SAFELY(_defaultImage);
    RELEASE_SAFELY(mImageView);
    RELEASE_SAFELY(mUploadingIcon);
    RELEASE_SAFELY(mIndicatorView);
    [super dealloc];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    [mImageView setContentMode:contentMode];
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [mImageView setFrame:[self bounds]];
    
}

- (void)setFileID:(NSString *)fileID {
    [self setFileID:fileID gender:0];
}

- (void)setFileID:(NSString *)fileID
           gender:(NSInteger)gender
{
    if(nil == fileID || ![fileID isKindOfClass:[NSString class]])
    {
        return;
    }
    
    if (fileID && [fileID isEqualToString:mFileID]) {
        mGender = gender;
        return;
    }
    
    if ([fileID isKindOfClass:[NSNull class]] || nil == fileID || [fileID length] == 0) {
        RETAIN_SAFELY(mFileID, fileID);
        mGender = gender;
        [mImageView setImage:[self getDefaultImage]];
        mIsPhotoFetched = YES;
        [self updateIndicatorView];
        return;
    }
    
    if (mFileID) {
        [self removePhotoFetchObserver];
    }
    
    mIsPhotoFetched = NO;
    [self updateIndicatorView];
    
    RETAIN_SAFELY(mFileID, fileID);
    mGender = gender;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPhotoFetchedOK:)
                                                 name:[self notificatonKey:mFileID]
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPhotoFetchedFailed) name:[self failedNotificationKey:mFileID]
                                               object:nil];
   
    [self performSelectorOnMainThread:@selector(updateInterface)
                           withObject:nil
                        waitUntilDone:NO];
    //    [self updateInterface];
}

- (void) setImage:(UIImage *)image
{
    [self setImage:image animationDuration:.2f];
}

- (void)setImage:(UIImage *)image
animationDuration:(float)duration
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionFade];
    
    [[mImageView layer] addAnimation:animation forKey:@"easeInEaseOut"];
    [mImageView setImage:image];
    
}

- (void)updateInterface
{
    
    [mImageView setImage:[self getDefaultImage]];
    [self performSelector:@selector(updateImageView:) onThread:[LZThreadMgr threadForGlobal] withObject:mFileID waitUntilDone:NO];
}

- (void)updateImageView:(NSString *)fileID
{
    @autoreleasepool {
        UIImage *image = [self getCurrentImage:fileID];
        if (image) {
            [self setImage:image animationDuration:.5f];
        } else {
            [mImageView setImage:[self getDefaultImage]];
        }
        if (mIsAutoFetch) {
            [self startFetch];
        }
    }
}

- (NSString *)notificatonKey:(NSString *)fileID{
    return [NSString stringWithFormat:@"kPhotoFetch:%@", fileID];
}

- (NSString *)failedNotificationKey:(NSString *)fileID{
    return [NSString stringWithFormat:@"kPhotoFetchFailed:%@", fileID];
}

- (void)removePhotoFetchObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[self notificatonKey:mFileID]
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[self failedNotificationKey:mFileID]
                                                  object:nil];
}

- (void)startFetch{
    if (!mFileID || mFileID.length == 0) {
        return;
    }
    
    if (!mIsPhotoFetched) {
        [[LZWidgetPhotoMgr sharedInstance] startFetch:mFileID];
    }
}

- (void)onPhotoFetchedOK:(NSNotification *)notif{
    if (mIsPhotoFetched) {
        return;
    }
    
    if (nil == mFileID || [mFileID length] == 0) {
        [self removePhotoFetchObserver];
        return;
    }
    
    NSDictionary *dictionary = (NSDictionary *)notif.object;
    UIImage *image = [dictionary valueForKey:kImageFetched_image];
    NSString *fileID = [dictionary valueForKey:kImageFetched_fileID];
    
    if (![mFileID isEqualToString:fileID]) {
        return;
    }
    
    if (!image) {
        return;
    }
    [self setImage:image animationDuration:.5f];
    
    mIsPhotoFetched = YES;
    [self updateIndicatorView];
    [self removePhotoFetchObserver];
}

- (void)onPhotoFetchedFailed{
    
}

- (UIImage *)getCurrentImage:(NSString *)fileID {
    if (nil == fileID || [fileID length] == 0) {
        return nil;
    }
    
    UIImage *result = [[IPPhotoCacheMgr shareInstance] getPhotoFromBuffer:fileID];
    if (result) {
        mIsPhotoFetched = YES;
        [self updateIndicatorView];
        [self removePhotoFetchObserver];
        
        return result;
    } else {
        result = [[IPImageFileMgr shareInstance] getPhoto:fileID];
        if (result) {
            mIsPhotoFetched = YES;
            [self updateIndicatorView];
            [self removePhotoFetchObserver];
        }
        return result;
    }
    
    return nil;
}

- (UIImage *)getDefaultImage {
    if (!mIsShowDefault) {
        return nil;
    } else if (_defaultImage) {
        return _defaultImage;
    }else {
        return [UIImage imageNamed:mDefaultFileName];
    }
}

- (CGSize)imageSize {
    CGSize result = CGSizeMake(0, 0);
    
    if ([mImageView image]) {
        result = [[mImageView image] size];
    }
    
    return result;
}

- (void)updateIndicatorView {
    
}


- (UIImage *)image {
    return [mImageView image];
}
@end
