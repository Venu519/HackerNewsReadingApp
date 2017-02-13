//
//  CommentModel.h
//  CommentLaout
//
//  Created by xiaohaibo on 11/29/15.
//  Copyright © 2015 xiao haibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HNNewsItem;
@interface CommentModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *timeString;
@property (nonatomic,strong) NSString *floor;


//-(instancetype)initWithDict:(NSDictionary *)dic;
-(instancetype)initWithHNNewsItem:(HNNewsItem*) hnNewsItem;
-(CGSize)sizeWithConstrainedToSize:(CGSize)sz;
@end
