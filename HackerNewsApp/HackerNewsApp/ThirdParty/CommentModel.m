//
//  CommentModel.m
//  CommentLaout
//
//  Created by xiaohaibo on 11/29/15.
//  Copyright © 2015 xiao haibo. All rights reserved.
//
#import "Constant.h"
#import "CommentModel.h"
#import <HackerNewsApp-Swift.h>

@implementation CommentModel

-(instancetype)initWithDict:(NSDictionary *)dic{
    
    if (self = [super init]) {
        NSString *string =dic[@"f"];
        NSRange rang =[string rangeOfString:@"["];
        
        self.address =[string substringToIndex:rang.location];
        
        self.comment =dic[@"b"];
        
        rang =[string rangeOfString:@"["];
        NSInteger start = rang.location;
        rang =[string rangeOfString:@"]"];
        NSInteger end = rang.location;
       
        self.name = [string substringWithRange:NSMakeRange(start+1, end - start-1)];
        self.timeString =dic[@"t"];
        
    }
    return self;
    
}

-(instancetype)initWithHNNewsItem:(HNNewsItem*) hnNewsItem{
    if (self = [super init]) {
        
//        NSString *string =dic[@"f"];
//        NSRange rang =[string rangeOfString:@"["];
//        
//        self.address =[string substringToIndex:rang.location];
        
        self.comment =hnNewsItem.text;
        
//        rang =[string rangeOfString:@"["];
//        NSInteger start = rang.location;
//        rang =[string rangeOfString:@"]"];
//        NSInteger end = rang.location;
        
        self.name = hnNewsItem.author;
//        self.timeString = hnNewsItem.time;
        
    }
    return self;
}

- (CGSize)sizeWithConstrainedToSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: CommentFont};
    CGSize textSize         = [self.comment boundingRectWithSize:CGSizeMake(size.width, 0)
                                                 options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
    return textSize;
}
@end
