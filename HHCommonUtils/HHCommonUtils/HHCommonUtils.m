//
//  HHCommonUtils.h
//  antiqueDemo
//
//  Created by antique on 16/3/30.
//  Copyright © 2016年 antique-apple. All rights reserved.
//

#import "HHCommonUtils.h"
#define lower_type 1
//设备的宽高
#ifndef SCREENHEIGHT
#define SCREENHEIGHT      [UIScreen mainScreen].bounds.size.height
#endif
#ifndef SCREENWIDTH
#define SCREENWIDTH       [UIScreen mainScreen].bounds.size.width
#endif
//获取颜色
#ifndef RGBA
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#endif
#ifndef RGB
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
#endif
@interface HHCommonUtils ()
@end

@implementation HHCommonUtils
@synthesize currentViewController;
+ (NSMutableString *)deleteCharacters:(NSMutableString *)content withReg:(NSString *)tagReg {
    if(content) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:tagReg options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray<NSTextCheckingResult *> *results = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
        for (int i=(int)results.count;i > 0;i--) {
            NSTextCheckingResult *result = results[i-1];
            [content replaceCharactersInRange:result.range withString:@""];
        }
    }
    return content;
}

+ (NSString *)getTextFromWeb:(NSString *)web {
    //去掉脚本
    NSString *tagReg = @"<\\s*script(.|[\\r\\n])*?>(.|[\\r\\n])*?<\\s*/script\\s*>";
    NSMutableString *content = [web mutableCopy];
    content = [self deleteCharacters:content withReg:tagReg];
    //去掉注释
    tagReg = @"<!—(.|[\\r\\n])*?—>";
    content = [self deleteCharacters:content withReg:tagReg];
    //去掉标签
    tagReg = @"<\\s*[^\\s!>]+\\s*([^\"']|\"[^\"]*\"|'[^']*')*?>";
    content = [self deleteCharacters:content withReg:tagReg];
    //去掉html中特殊占位符
    tagReg = @"&[a-zA-Z]{1}(.|\n|\r)*?;+?";
    content = [self deleteCharacters:content withReg:tagReg];
    //待写--删除空白符
    tagReg = @"\\s+";
    content = [self deleteCharacters:content withReg:tagReg];
    NSString *contentstring = (NSString *)content;
    return contentstring;
}

// 键盘弹出时:
+(void)keyboardWillShow:(NSNotification *)notification inView:(UIView *)remoteView gapToBottom:(CGFloat)gapToBottom
{
    UIView *currentView = [self findFirstResponder:remoteView];
    if(currentView == nil) {//present的controller中的视图调用
        return;
    }
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    //调整放置有textView的view的位置
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:0.3];
    //cordinate shadeView's height
    //抬高高度 = 键盘高度-(屏幕高度-（本身的y+本身的高度)
    CGFloat vH = remoteView.bounds.size.height;
    CGFloat cvH = currentView.bounds.size.height;
    CGFloat cvY = currentView.frame.origin.y;
    //20160624 dongkaiming start 算法改进：去掉deep，循环判断
    //    if(deep > 0) {
    //        cvY = [currentView convertPoint:currentView.frame.origin toView:remoteView].y;
    //    }
    UIView *tempView = currentView;
    while(true) {
        //20160808 dongkaiming start
        /*UITextView等输入框也属于ScrollView,但不用把此层scrollView的y偏移减去*/
        if(tempView == currentView) {
            cvY+=tempView.superview.frame.origin.y;
            tempView = tempView.superview;
            continue;
        }
        /*如果当前临时view或view的外层恰好是要移动的容器view,不要执行(cvY+=外层view的y值)的方法，因为加上这个y之后,如果y>0,相当于用的是remoteView的外层view，而remoteView高度和外层view不匹配，计算会偏高;此层view依旧需要减去此层ScrollView的y偏移*/
        if(tempView.superview == remoteView||tempView == remoteView) {
            Class tempClass = tempView.class;
            if([tempClass isSubclassOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)tempView;
                cvY -= scrollView.contentOffset.y;
                /*如果当前临时view为remoteView(其他层的scrollView不管，因为考虑到正常人不会把输入栏放到一个要滚动的内嵌scrollView中,况且这种情况太复杂，没必要加大我这小小工具的复杂度),计算底部遮挡，cvY需要加上这个遮挡的高度*/
                //scrollView需要上升的距离，相当于y变小，同时输入框也因为上升,y也变小
                CGFloat offsetYNeedHeighter = cvY + cvH - tempView.frame.size.height;
                if(offsetYNeedHeighter>0) {
                    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+offsetYNeedHeighter);
                    cvY -= offsetYNeedHeighter;
                }
            }
            if(tempView == remoteView)  {
                break;//如果当前为临时view为remoteView，计算调整大小的cvY算法结束
            }
            tempView = tempView.superview;
            continue;
        }
        
        Class tempClass = tempView.class;
        if([tempClass isSubclassOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)tempView;
            cvY -= scrollView.contentOffset.y;
            /*如果当前临时view为remoteView(其他层的scrollView不管，因为考虑到正常人不会把输入栏放到一个要滚动的内嵌scrollView中,况且这种情况太复杂，没必要加大我这小小工具的复杂度),计算底部遮挡，cvY需要加上这个遮挡的高度*/
            //scrollView需要上升的距离，相当于y变小，同时输入框也因为上升,y也变小
            CGFloat offsetYNeedHeighter = cvY + cvH - tempView.frame.size.height;
            if(offsetYNeedHeighter>0) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+offsetYNeedHeighter);
                cvY -= offsetYNeedHeighter;
            }
        }
        //20160808 dongkaiming end
        cvY+=tempView.superview.frame.origin.y;
        //UITableViewWapperView研究不深，这里把它过滤掉
        float Version=[[[UIDevice currentDevice] systemVersion] floatValue];
        if([tempClass isSubclassOfClass:[UITableViewCell class]]&&Version>=7.0)
        {
            tempView = tempView.superview;
        }
        tempView = tempView.superview;
    }
    //20160624 dongkaiming end
    CGFloat heighterValue = keyboardRect.size.height-(vH-cvH-cvY)-gapToBottom;
    if(heighterValue < 0) {
        heighterValue = 0;
    }
    [remoteView setFrame:CGRectMake(0, remoteView.frame.origin.y
                                    -heighterValue,remoteView.bounds.size.width,remoteView.bounds.size.height)];
    [UIView commitAnimations];
}

//找到focused的View
+ (UIView *)findFirstResponder:(UIView*)view
{
    if (view.isFirstResponder) {
        return view;
    }
    for (UIView *subView in view.subviews) {
        UIView *firstResponder = [self findFirstResponder:subView];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    //20160420 董凯明 start:添加对字符串是nil的判断
    if (string == nil) {
        return NO;
    }
    //20160420 董凯明 end
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

+ (void)removeFromTag:(NSString *)tag withAttrs:(NSString *)attrs ins:(NSMutableString *)content andRange:(NSRange)range{
    NSArray<NSString*> *attrArray = [attrs componentsSeparatedByString:@","];
    NSString *tagNew = tag;
    for (int i = (int)attrArray.count-1; i >= 0; i--) {
        NSString *attr = attrArray[i];
        tagNew = [self removeFromTag:tag withAttr:attr];
        tag = tagNew;
    }
    [content replaceCharactersInRange:range withString:tag];
}

+ (NSString*)removeFromTag:(NSString *)tag withAttr:(NSString *)attr {
    NSError *error = NULL;
    //去除属性
    NSString *regString = [NSString stringWithFormat:@"%@\\s*=\\s*\"[^\"]*\"",attr];
    NSRegularExpression *heightRegex = [NSRegularExpression regularExpressionWithPattern:regString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *heightResult = [heightRegex firstMatchInString:tag options:0 range:NSMakeRange(0, [tag length])];
    if(heightResult) {
        NSMutableString *mulTag = [NSMutableString stringWithString:tag];
        [mulTag replaceCharactersInRange:heightResult.range withString:@""];
        tag =  [NSString stringWithString:mulTag];
    }
    //去除style中存放的属性相关
    NSRange range = NSMakeRange(0, 0);
    
    NSError *error1 = NULL;
    NSString *regString1 = @"style\\s*=\\s*\"[^\"]*\"";
    NSRegularExpression *heightRegex1 = [NSRegularExpression regularExpressionWithPattern:regString1 options:NSRegularExpressionCaseInsensitive error:&error1];
    NSTextCheckingResult *heightResult1 = [heightRegex1 firstMatchInString:tag options:0 range:NSMakeRange(0, [tag length])];
    NSString *style = nil;
    if(heightResult1) {
        range = heightResult1.range;
        style = [tag substringWithRange:heightResult1.range];
    }
    
    //    NSString *style = [self getAttr:@"style" fromTag:tag findRange:range];
    if (style) {
        NSString *content = [self getContentFromAttr:style];
        if(content!=nil) {
            NSArray *array = [content componentsSeparatedByString:@";"];
            for (int i=0;i<(int)array.count;i++) {
                NSString *kv = array[i];
                //如果存在width属性，取其值
                NSRegularExpression *widthStyleReg = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\s*%@\\s*:",attr] options:NSRegularExpressionCaseInsensitive error:&error];
                NSTextCheckingResult *widthStyleResult = [widthStyleReg firstMatchInString:kv options:0 range:NSMakeRange(0, kv.length)];
                if (widthStyleResult&&widthStyleResult.range.location==0) {
                    NSMutableString *contenNew = [NSMutableString stringWithString:@""];
                    for(int j=0;j<(int)array.count;j++) {
                        if(j!=i) {
                            if(j!=(int)array.count -1) {
                                [contenNew appendString:[NSString stringWithFormat:@"%@;",array[j]]];
                            } else {
                                [contenNew appendString:array[j]];
                            }
                        }
                    }
                    NSMutableString *mulTag = [NSMutableString stringWithString:tag];
                    [mulTag replaceCharactersInRange:range withString:[NSString stringWithString:[NSString stringWithFormat:@"style=\"%@\"",contenNew]]];
                    tag =  [NSString stringWithString:mulTag];
                    return tag;
                }
            }
        }
    }
    return tag;
}

+(NSString*)getContentFromAttr:(NSString*)attr {
    NSError *error = NULL;
    NSRegularExpression *contentRegex = [NSRegularExpression regularExpressionWithPattern:@"[^\"]+[^\"]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult*> *heightValueResults = [contentRegex matchesInString:attr options:0 range:NSMakeRange(0, [attr length])];
    if (heightValueResults.count>1) {
        NSString *value = [attr substringWithRange:heightValueResults[1].range];
        return value;
    } else {
        return nil;
    }
    
}

+(NSString*)getAttr:(NSString*)attr fromTag:(NSString*)tag findRange:(NSRange*)range{
    NSError *error = NULL;
    NSString *regString = [NSString stringWithFormat:@"%@\\s*=\\s*\"[^\"]*\"",attr];
    NSRegularExpression *heightRegex = [NSRegularExpression regularExpressionWithPattern:regString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *heightResult = [heightRegex firstMatchInString:tag options:0 range:NSMakeRange(0, [tag length])];
    if(heightResult) {
        *range = heightResult.range;
        return [tag substringWithRange:heightResult.range];
    } else {
        return nil;
    }
}

+ (void)replaceFromTag:(NSString *)tag withAttr:(NSString *)attr ins:(NSMutableString *)content andRange:(NSRange)range withValue:(float)value type:(NSInteger)type{
    NSString *newTag = [self getNewTagToReplace:tag withAttr:attr withValue:value type:type];
    [content replaceCharactersInRange:range withString:newTag];
}

+(NSString*)getNewTagToReplace:(NSString *)tag withAttr:(NSString *)attr withValue:(CGFloat)value type:(NSInteger)type {
    NSMutableString *newTag = [NSMutableString stringWithString:tag];
    //替换属性的值
    Boolean isFound = false;
    isFound = [self replaceAttrFromTag:newTag withAttr:attr withValue:value type:type];
    if(!isFound) {
        [self replaceStyleFromTag:newTag withAttr:attr withValue:value type:type];
    }
    return newTag;
}

+(Boolean)replaceAttrFromTag:(NSMutableString *)tag withAttr:(NSString *)attr withValue:(CGFloat)value type:(NSInteger)type {
    //取得替换区域和新值
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = [self getRangeAndContentOfAttr:[NSString stringWithString:tag] withAttr:attr withValue:value type:type];
    NSUInteger loc = (NSUInteger)[[dic valueForKey:@"loc"] integerValue];
    NSUInteger len = (NSUInteger)[[dic valueForKey:@"len"] integerValue];
    NSString *replaceValue = [dic valueForKey:@"value"];
    if(len!=0) {
        NSRange replaceRange = NSMakeRange(loc, len);
        [tag replaceCharactersInRange:replaceRange withString:replaceValue];
        return true;
    } else {
        return false;
    }
}

+(Boolean)replaceStyleFromTag:(NSMutableString *)tag withAttr:(NSString *)attr withValue:(CGFloat)value type:(NSInteger)type {
    //取得style和style的range(在result中)
    NSError *error = NULL;
    NSString *regString = @"style\\s*=\\s*\"[^\"]*\"";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:tag options:0 range:NSMakeRange(0, [tag length])];
    NSString *style = nil;
    if(result) {
        style = [tag substringWithRange:result.range];
    }
    //找到style中属性相关，替换
    if (style) {
        NSString *content = [self getContentFromAttr:style];
        if(content!=nil) {
            NSArray *array = [content componentsSeparatedByString:@";"];
            for (int i=0;i<(int)array.count;i++) {
                NSString *kv = array[i];
                //如果存在width属性，取其值
                NSRegularExpression *widthStyleReg = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\s*%@\\s*:",attr] options:NSRegularExpressionCaseInsensitive error:&error];
                NSTextCheckingResult *widthStyleResult = [widthStyleReg firstMatchInString:kv options:0 range:NSMakeRange(0, kv.length)];
                if (widthStyleResult&&widthStyleResult.range.location==0) {
                    NSMutableString *contenNew = [NSMutableString stringWithString:@""];
                    for(int j=0;j<(int)array.count;j++) {
                        if(j!=i) {
                            if(j!=(int)array.count -1) {
                                [contenNew appendString:[NSString stringWithFormat:@"%@;",array[j]]];
                            } else {
                                [contenNew appendString:array[j]];
                            }
                        } else {
                            if(j!=(int)array.count -1) {
                                //取得并调整属性关联
                                NSString *attrRefer = array[j];
                                //如果存在width属性，取其值
                                NSRegularExpression *widthStyleReg = [NSRegularExpression regularExpressionWithPattern:@"\\s*width\\s*:" options:NSRegularExpressionCaseInsensitive error:&error];
                                NSTextCheckingResult *widthStyleResult = [widthStyleReg firstMatchInString:kv options:0 range:NSMakeRange(0, kv.length)];
                                CGFloat width = 0;
                                if (widthStyleResult&&widthStyleResult.range.location==0) {
                                    width = [self getValueFromAttr:kv];
                                    if(type == lower_type) {
                                        width = width>value?value:width;
                                    }
                                    attrRefer = [NSString stringWithFormat:@"width=%f",width];
                                } else {
                                    attrRefer = [NSString stringWithFormat:@"width=%f",value];
                                }
                                [contenNew appendString:[NSString stringWithFormat:@"%@;",attrRefer]];
                            } else {
                                [contenNew appendString:array[j]];
                            }
                        }
                    }
                    [tag replaceCharactersInRange:result.range withString:[NSString stringWithString:[NSString stringWithFormat:@"style=\"%@\"",contenNew]]];
                    return true;
                }
            }
        }
    }
    return false;
}

+ (NSMutableDictionary*)getRangeAndContentOfAttr:(NSString *)tag withAttr:(NSString *)attr withValue:(CGFloat)value type:(NSInteger)type{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //取得attr在tag中的位置
    NSError *error = NULL;
    NSString *regString = [NSString stringWithFormat:@"%@\\s*=\\s*\"[^\"]*\"",attr];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:tag options:0 range:NSMakeRange(0, [tag length])];
    if(result) {
        NSMutableString *mulTag = [NSMutableString stringWithString:tag];
        //取得区域
        [dic setValue:[NSString stringWithFormat:@"%ld",(long)result.range.length] forKey:@"len"];
        [dic setValue:[NSString stringWithFormat:@"%ld",(long)result.range.location] forKey:@"loc"];
        //取值并根据类型调整
        NSString *widthAttr = [tag substringWithRange:result.range];
        CGFloat width = 0;
        if (widthAttr) {
            width = [self getValueFromAttr:widthAttr];
            if(type == lower_type) {
                width = width>value?value:width;
            }
            [dic setValue:[NSString stringWithFormat:@"width=%f",width] forKey:@"value"];
        }
        //替换
        [mulTag replaceCharactersInRange:result.range withString:@""];
        tag =  [NSString stringWithString:mulTag];
    } else {
        [dic setValue:@"0" forKey:@"len"];
        [dic setValue:@"0" forKey:@"loc"];
    }
    return dic;
}

+(NSString*)getAttr:(NSString*)attr fromTag:(NSString*)tag {
    NSError *error = NULL;
    NSString *regString = [NSString stringWithFormat:@"%@\\s*=\\s*\"[^\"]*\"",attr];
    NSRegularExpression *heightRegex = [NSRegularExpression regularExpressionWithPattern:regString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *heightResult = [heightRegex firstMatchInString:tag options:0 range:NSMakeRange(0, [tag length])];
    if(heightResult) {
        return [tag substringWithRange:heightResult.range];
    } else {
        return nil;
    }
}

+(CGFloat)getValueFromAttr:(NSString*)attr {
    NSError *error = NULL;
    NSRegularExpression *floatRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d+.?\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *heightValueResult = [floatRegex firstMatchInString:attr options:0 range:NSMakeRange(0, [attr length])];
    if (heightValueResult) {
        CGFloat value = [[attr substringWithRange:heightValueResult.range] floatValue];
        return value;
    } else {
        return 0;
    }
}

+ (void)readSecond:(int)count withButton:(UIButton *)button {
    NSString *temp = button.currentTitle;
    button.userInteractionEnabled = NO;
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(aQueue, ^{
        for (NSInteger i = count; i >0; i--) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%ld秒",(long)i] forState:UIControlStateNormal];
            });
            [NSThread sleepForTimeInterval:1];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:temp forState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
        });
    });
    
}

+ (void)showNavigationBackImage:(NSString*)imageName andController:(UIViewController*)controller{
    //导航栏 --返回按钮
    UIImage* img=[UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28, 28);
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES;
    [btn addTarget:controller action: @selector(leftMenuSelectedd:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    controller.navigationItem.leftBarButtonItem=item;
    
}

+ (void)showNavigationBackImage:(NSString*)imageName andTitle:(NSString*)title andController:(UIViewController*)controller{
    //导航栏 --返回按钮
    UIImage* img=[UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28, 28);
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES;
    [btn addTarget:controller action: @selector(leftMenuSelectedd:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:controller action:@selector(leftMenuSelectedd:)];
    [titleItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [titleItem setTintColor: RGB(15, 110, 100)];
    
    
    controller.navigationItem.leftBarButtonItems = @[item, titleItem];
    
}



- (void)leftMenuSelectedd:(UITapGestureRecognizer*)sender
{
    //nothing, just avoid warnings
}

+ (UIImage *)scaleToSize:(CGSize)targetSize ofImage:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) ==NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(NSInteger)getHeightOfLabel:(UILabel*)label {
    NSString *fullDescAndTagStr = label.text;
    CGFloat labelWidth = label.layer.bounds.size.width;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullDescAndTagStr];
    NSRange allRange = [fullDescAndTagStr rangeOfString:fullDescAndTagStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:label.font
                    range:allRange];
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    titleHeight = ceilf(rect.size.height);
    
    return titleHeight+2;  // 加两个像素,防止emoji被切掉
}

+(void)setExtraCellLineHidden:(UITableView*)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}

+(void)establishItem:(UIView *)item withSuperViewContainingConstants:(CGRect)rect {
    UIView *view = item.superview;
    item.translatesAutoresizingMaskIntoConstraints = NO;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if(rect.origin.y != CGFLOAT_MAX) {
        //顶部与父视图顶部对齐
        NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0f constant:rect.origin.y];
        topConstraint.active = YES;
    }
    if(rect.origin.x != CGFLOAT_MAX) {
        //左侧与父视图左侧对齐
        NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:rect.origin.x];
        leftConstraint.active = YES;
    }
    if(rect.size.width >=0&&rect.size.width != CGFLOAT_MAX) {
        //右侧与父视图右侧对齐
        NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:rect.size.width];
        rightConstraint.active = YES;
    } else if(rect.size.width != CGFLOAT_MAX){
        //宽度
        NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:item  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:-rect.size.width];
        widthConstraint.active = YES;
    }
    if(rect.size.height >=0&&rect.size.height != CGFLOAT_MAX) {
        //顶部与父视图顶部对齐
        NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:rect.size.height];
        bottomConstraint.active = YES;
    } else if(rect.size.height != CGFLOAT_MAX){
        //高度
        NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:item  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:-rect.size.height];
        heightConstraint.active = YES;
    }
    
}

+(void)addSubView:(UIView *)subView withRelativeRect:(CGRect)rect inView:(UIView *)view withRealView:(UIView *)realView{
    //找到真正的rect
    CGFloat realY = rect.origin.y;
    CGFloat realX = rect.origin.x;
    UIView *tempView = view;
    realX += tempView.frame.origin.x;
    realY += tempView.frame.origin.y;
    while(true) {
        if(tempView.superview == realView) {
            break;
        }
        realY+=tempView.superview.frame.origin.y;
        realX+=tempView.superview.frame.origin.x;
    }
    //重设frame
    subView.frame = CGRectMake(realX, realY, rect.size.width, rect.size.height);
    //添加到realView中
    [realView addSubview:subView];
}

+(CGRect)getAbsolutelyRectInRealView:(UIView *)realView withRelativeRect:(CGRect)rect inView:(UIView *)view{
    //找到真正的rect
    CGFloat realY = rect.origin.y;
    CGFloat realX = rect.origin.x;
    UIView *tempView = view;
    realX += tempView.frame.origin.x;
    realY += tempView.frame.origin.y;
    while(true) {
        if(tempView.superview == realView) {
            break;
        }
        realY+=tempView.superview.frame.origin.y;
        realX+=tempView.superview.frame.origin.x;
    }
    //重设frame
    return CGRectMake(realX, realY, rect.size.width, rect.size.height);
}

+ (void)setOrResetTrangleWithColor:(UIColor *)color andSize:(CGSize)size inView:(UIView *)view reset:(BOOL)isReset withLayer:(CALayer *)trangleLayer{
    CGPoint bgLayerPoint = CGPointMake(view.frame.size.width-size.width-2, view.frame.size.height/2);//在view右边居中位置+左偏移2放下三角
    if(!isReset) {
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor clearColor] andPosition:bgLayerPoint andSize:size inView:view];
        CGPoint indicatorPoint = CGPointMake(size.width+2, view.frame.size.height/2);
        CAShapeLayer *indicator = [self createIndicatorWithColor:color andPosition:indicatorPoint andSize:size];
        [bgLayer addSublayer:indicator];
        [view.layer addSublayer:bgLayer];
    } else {
        //重设三角位置、颜色
        CAShapeLayer *dateLabelBgLayer = [self createIndicatorWithColor:color andPosition:bgLayerPoint andSize:size];
        [view.layer replaceSublayer:trangleLayer with:dateLabelBgLayer];
    }
}

+ (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position andSize:(CGSize)size inView:(UIView *)view{
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, size.width*2+4, view.frame.size.height);
    layer.backgroundColor = color.CGColor;
    layer. anchorPoint = CGPointMake(0.5, 0.5);
    return layer;
}

+ (CAShapeLayer *)createIndicatorWithColor:(UIColor *)fillColor andPosition:(CGPoint)point andSize:(CGSize)size{
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    //画线
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(size.width/2, size.height)];
    [path closePath];
    //赋给layer,设置宽度和填充色
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.fillColor = fillColor.CGColor;
    //重绘path,设置宽度、线帽的样式：kCGLineCapButt表示不绘制端点，kCGLineCapRound：该属性值指定绘制圆形端点...、衔接方式：kCGLineJoinMiter表示斜面衔接、斜面的长度上限-miterLimit这个属性表示斜面长度和线条长度的比值，默认是 10，意味着一个斜面的长度不应该超过线条宽度的10倍
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);//释放不再需要的CGPathRef类型的bound
    layer.position = point;
    //描点-默认（0.5，0.5），表示令图像（宽度*0.5，高度*0.5）的点向（0，0）移动
    layer. anchorPoint = CGPointMake(0.5, 0.5);
    return layer;
}

+(NSString *)notRounding:(float)floatValue afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:floatValue];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

//生成使WebView放大缩小功能的js
+(void)enhanceZoomAbilibyInWebView:(UIWebView *)webView {
    NSString *jsCode = @"function increaseMaxZoomFactor() {\n\
    var element = document.createElement('meta');\n\
    element.name = 'viewport';\n\
    element.content = 'user-scalable=yes,width=device-width,initial-scale=1,maximum-scale=10,minimun-scale=1.0';\n\
    var head = document.getElementsByTagName('head')[0];\n\
    head.appendChild(element);\n\
    }";
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
    [webView stringByEvaluatingJavaScriptFromString:@"increaseMaxZoomFactor()"];
}

+(NSString *)getCodeFromResourceName:(NSString *)name andType:(NSString *)type {
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:type];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsCode;
}

+ (NSString *)riseRateWithCurrentCount:(NSInteger)currentCount andLastCount:(NSInteger)lastCount {
    NSString *sameRate = currentCount==0?@"0.00%":(lastCount==0?@"100.00%":[NSString stringWithFormat:@"%.2f",(currentCount-lastCount)*100.0/lastCount]);
    return sameRate;
}


+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0f];
}

+ (NSDate *)getLastMonthDate {
    
    NSDate *currentDate = [NSDate new];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setYear:0];
    [components setDay:0];
    [components setMonth:-1];
    NSDate *lastMonth = [cal dateByAddingComponents:components toDate: currentDate options:0];
    return lastMonth;
}

+ (NSDate *)getLastNMonthDate:(NSInteger)n {
    
    NSDate *currentDate = [NSDate new];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setYear:0];
    [components setDay:0];
    [components setMonth:-n];
    NSDate *lastMonth = [cal dateByAddingComponents:components toDate: currentDate options:0];
    return lastMonth;
}


+ (NSString *)stringValue:(NSString*)arg fromDictionary:(NSDictionary*)dictionary {
    NSString *standardStringValue = [NSString stringWithFormat:@"%@",[dictionary valueForKey:arg]];//过滤[NSNull null]
    standardStringValue = [self turnStringValue:standardStringValue fromArray:@[@"<null>"] toValue:@""];//过滤[NSNull null]转化的"<null>"
    return standardStringValue;
}

+ (NSString *)floatString:(NSString*)arg fromDictionary:(NSDictionary*)dictionary tailLength:(NSUInteger)tailLength{
    NSString *standardStringValue = [self stringValue:arg fromDictionary:dictionary];
    NSString *headString = @"%";
    NSString *willAppendString = [NSString stringWithFormat:@".%luf",tailLength];
    NSString *formatString = [headString stringByAppendingString:willAppendString];
    NSScanner* scan = [NSScanner scannerWithString:standardStringValue];
    float val;
    if( [scan scanFloat:&val] && [scan isAtEnd])
    {
        NSLog(@"this is a float");
        standardStringValue = [NSString stringWithFormat:formatString,[standardStringValue floatValue]];
    }
    return standardStringValue;
}

+(NSString*)turnStringValue:(NSString*)stringValue fromArray:(NSArray*)array toValue:(NSString*)value {
    for(NSString *tempString in array) {
        if([stringValue isEqualToString:tempString]) {
            return @"";
        }
    }
    return stringValue;
}

+ (BOOL)isEmptyString:(NSString*)string {
    if([string isEqual:[NSNull null]]) {
        return YES;
    }
    if([self isString:string existInArray:@[@""]]) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)isString:(NSString*)string existInArray:(NSArray*)array {
    if([array containsObject:string]) {
        return YES;
    } else {
        return NO;
    }
}

+(NSDictionary*)getKeyValuesByKeyArray:(NSArray*)keyArray andValueArray:(NSArray*)valueArray {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    int i = 0;
    for(NSString *key in keyArray) {
        [dic setValue:valueArray[i] forKey:key];
        i++;
    }
    NSDictionary *targetDic = [[NSDictionary alloc]initWithDictionary:dic];
    return targetDic;
}

+ (AntiqueResultDealState)loadData:(NSArray *)result withWillLoadPageNum:(NSUInteger*)willLoadPageNum andDataArray:(NSMutableArray *)dataArray withFirstPage:(NSUInteger)first_page{
    if(first_page != NSUIntegerMax) {//使用分页
        if(result.count == 0) {//未取到数据
            if(*willLoadPageNum == first_page) {//数据为空
                [dataArray removeAllObjects];
                return AntiqueResultDealStateEmpty;
            } else {//数据已加载完
                return AntiqueResultDealStateEnd;
            }
        } else {
            [dataArray addObjectsFromArray:result];
            *willLoadPageNum = *willLoadPageNum+1;
            return AntiqueResultDealStateDefault;
        }
    } else {//不使用分页
        if(result.count == 0) {
            [dataArray removeAllObjects];
            return AntiqueResultDealStateEmpty;
        } else {
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:result];
            return AntiqueResultDealStateDefault;
        }
    }
}

+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02 withDateFormatter:(NSString*)dateFormatter{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormatter];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=-1; break;
            //date02比date01小
        case NSOrderedDescending: ci=1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}
@end
