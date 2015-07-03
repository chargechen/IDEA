#import <Foundation/Foundation.h>

@interface IPImageFileMgr : NSObject

//上传大图 或 下载图片时调用
+ (instancetype)shareInstance;
- (void)savePhoto:(NSData *)fileData fileID:(NSString *)fileID;
- (void)movePhoto:(NSString *)oldFileID newFileID:(NSString *)newFileID;
- (BOOL)isPhotoExist:(NSString *)fileID;
- (UIImage *)getPhoto:(NSString *)fileID;

@end
