//
//  HHCommonUtils.h
//  huangheNews
//
//  Created by thx03 on 16/3/30.
//  Copyright © 2016年 fuqiang-apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHCommonUtils : NSObject<UITextFieldDelegate>

/* @brief  过滤正则表达式匹配的字符
 * @param  content:要过滤的内容 tagReg:正则表达式
 * @return 文本字符串
 * @author 汤凯
 */
+ (NSMutableString *)deleteCharacters:(NSMutableString *)content withReg:(NSString *)tagReg;

/* @brief  过滤出网页文本
 * @param  web:网页内容
 * @return 文本字符串
 * @author 汤凯
 */
+ (NSString *)getTextFromWeb:(NSString *)web;

/* @brief  简单键盘弹出时调整视图高度
 * @param notification:系统用户信息 remoteView:要调整的视图
 * @return 文本字符串
 * @author 董凯明
 */
+(void)keyboardWillShow:(NSNotification *)notification inView:(UIView *)remoteView;

/* @brief  字符串是否纯数字
 * @param string:字符串
 * @return 文本字符串
 * @author http://www.oschina.net/code/snippet_2248391_53037 韩万杰
 */
+ (BOOL)isPureNumandCharacters:(NSString *)string;

/* @brief  删除标签中的属性组
 * @param tag:标签 attrs:属性组
 * @return 无
 * @author 董凯明
 */
+ (void)removeFromTag:(NSString *)tag withAttrs:(NSString *)attrs ins:(NSMutableString*)content andRange:(NSRange)range;

/* @brief  替换标签中的属性的值
 * @param tag:标签 attr:属性名 content:要修改的内容 range:要修改的位置 value:替换后的值 type:替换类型
 * @return 无
 * @author 董凯明
 */
+ (void)replaceFromTag:(NSString *)tag withAttr:(NSString *)attr ins:(NSMutableString *)content andRange:(NSRange)range withValue:(float)value type:(NSInteger)type;

/* @brief  button中实现读秒
 * @param count:秒数 button:要实现读秒的按钮（注意其他回复按钮交互的操作）
 * @return 无
 * @author 董凯明
 */
+ (void)readSecond:(int)count withButton:(UIButton *)button;
@end
