//
//  HHCommonUtils.m
//  huangheNews
//
//  Created by thx03 on 16/3/30.
//  Copyright © 2016年 fuqiang-apple. All rights reserved.
//

#import "HHCommonUtils.h"
#define lower_type 1
@interface HHCommonUtils ()
@end

@implementation HHCommonUtils

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

// 键盘弹出时
+(void)keyboardWillShow:(NSNotification *)notification inView:(UIView *)remoteView
{
    UIView *currentView = [self findFirstResponder:remoteView];
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
        if(tempView.superview == remoteView) {
            break;
        }
        cvY+=tempView.superview.frame.origin.y;
        tempView = tempView.superview;
    }
    //20160624 dongkaiming end
    NSInteger heighterValue = keyboardRect.size.height-(vH-cvH-cvY);
    if(heighterValue < 0) {
        heighterValue = 0;
    }
    [remoteView setFrame:CGRectMake(0, -heighterValue,remoteView.bounds.size.width,remoteView.bounds.size.height)];
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
@end
