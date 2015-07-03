#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

- (NSString *)md5String {
	const char *source = [self UTF8String];
	unsigned char md5[CC_MD5_DIGEST_LENGTH];
	CC_MD5(source, strlen(source), md5);
	
	NSMutableString *retString = [NSMutableString stringWithCapacity:40];
	
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++ i) {
		NSString *strValue = [NSString stringWithFormat:@"%02X", md5[i]];
		[retString appendString:strValue];
	}
	return retString;
}

@end
