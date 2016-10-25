//
//  HHCommonUtils.h
//  antiqueDemo
//
//  Created by antique on 16/3/30.
//  Copyright © 2016年 antique-apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHCommonUtils : NSObject<UITextFieldDelegate>
//
//@property (nonatomic,strong) NSMutableDictionary *argsDic;//参数字典

@property (nonatomic,strong) UIViewController *currentViewController;

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
 * @param notification:系统用户信息 remoteView:要调整的视图 gapToBottom:remoteView距底部的高度
 * @return 文本字符串
 * @author 董凯明
 */
+(void)keyboardWillShow:(NSNotification *)notification inView:(UIView *)remoteView gapToBottom:(CGFloat)gapToBottom;

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

/* @brief  包含导航栏的控制器中添加返回按钮--需要自己实现-(void)leftMenuSelectedd:(UITapGestureRecognizer*)sender
 * @param imageName:图片名称 controller:目标控制器
 * @return 无
 * @author 董凯明
 */
+ (void)showNavigationBackImage:(NSString*)imageName andController:(UIViewController*)controller;
/* @brief  包含导航栏的控制器中添加返回按钮--需要自己实现-(void)leftMenuSelectedd:(UITapGestureRecognizer*)sender
 * @param imageName:图片名称 controller:目标控制器 title:title名字
 * @return 无
 * @author 董凯明 汤凯
 */
+ (void)showNavigationBackImage:(NSString*)imageName andTitle:(NSString*)title andController:(UIViewController*)controller;
/* @brief  包含导航栏的控制器中添加返回按钮--需要自己实现-(void)leftMenuSelectedd:(UITapGestureRecognizer*)sender
 * @param targetSize:目标尺寸 image:
 * @return 新图片
 * @author 引入http://blog.csdn.net/m372897500/article/details/34426559
 */
+ (UIImage *)scaleToSize:(CGSize)targetSize ofImage:(UIImage*)image;

/* @brief  根据颜色返回1*1的Image图片
 * @param color:颜色
 * @return 新图片
 * @author http://blog.csdn.net/zttjhm/article/details/42024487
 */
+ (UIImage*) createImageWithColor: (UIColor*) color;

//取得label需要适配到的高度
+(NSInteger)getHeightOfLabel:(UILabel*)label;

//设置tableView底部无内容时不展示横线
+(void)setExtraCellLineHidden:(UITableView*)tableView;

/* @brief  令视图与父视图建立约束
 * @param item:视图 rect:分别用y、x、width、height存放距顶、左、友、下的距离;CGFLOAT_MAX代表无效;width、height为负数时代表宽和高
 * @return 新图片
 * @author dongkaiming
 */
+(void)establishItem:(UIView *)item withSuperViewContainingConstants:(CGRect)rect;

//+(NSString *)dealWithErrorInfo:(NSError *)error withErrorCode:(NSString *)errorCode andDealType:(NSString*)dealType;
/* @brief  取得错误本地化信息
 * @param error:错误实体
 * @return 错误本地化信息
 * @author dongkaiming
 */
+(NSString *)getErrorLocalizedDescription:(NSError *)error;

/* @brief  把一个视图subview放入相对viewrect的位置,但实际view为realView
 * @param subview要放入的视图;rect:相对view的位置;view:看似放入的view;realView:实际放入的view
 * @return
 * @author dongkaiming
 */
+(void)addSubView:(UIView *)subView withRelativeRect:(CGRect)rect inView:(UIView *)view withRealView:(UIView *)realView;

/* @brief  取得view中rect在realView的绝对rect
 * @param rect:相对view的位置;view:看似放入的view;realView:实际放入的view
 * @return view中rect在realView的绝对rect
 * @author dongkaiming
 */
+(CGRect)getAbsolutelyRectInRealView:(UIView *)realView withRelativeRect:(CGRect)rect inView:(UIView *)view;

/* @brief  设或者重设view中的三角下拉图标
 * @param color:三角下拉图标颜色 size:三角的尺寸 view:要操作的视图 isReset:是否是重设
 * @return
 * @author dongkaiming
 */
+ (void)setOrResetTrangleWithColor:(UIColor *)color andSize:(CGSize)size inView:(UIView *)view reset:(BOOL)isReset withLayer:(CALayer *)trangleLayer;

/* @brief 把浮点型第position位之前的数取出，返回String
 * @param floatValue:浮点值 position:小数点第几位
 * @return
 * @from http://blog.sina.com.cn/s/blog_71715bf801017nyw.html
 */
+(NSString *)notRounding:(float)floatValue afterPoint:(int)position;

///* @brief 取出HHCommonUtils中的参数字典
// * @param
// * @return 参数字典
// * @author dongkaiming
// */
//+(NSMutableDictionary *) getArgsDic;

/* @brief 生成使WebView放大缩小功能的js,并放到webView中
 * @param webView 要调用功能的webView
 * @return
 * @from http://www.cocoachina.com/bbs/read.php?tid-55681.html
 */
+(void)enhanceZoomAbilibyInWebView:(UIWebView *)webView ;

/* @brief 把name.type资源中的代码取出
 * @param name:资源文件名 type:资源后缀
 * @return
 * @from http://www.cocoachina.com/bbs/read.php?tid-55681.html
 */
+(NSString *)getCodeFromResourceName:(NSString *)name andType:(NSString *)type;

/* @brief 计算当前数据与上次数据的增长率(可为负)，转为默认小数点两位的字符串，暂不考虑扩展
 * @param currentCount:当前个数 lastCount:上次个数
 * @return 代表增长率的小数点两位的字符串
 * @from 董凯明
 */
+ (NSString *)riseRateWithCurrentCount:(NSInteger)currentCount andLastCount:(NSInteger)lastCount;

/* @brief 取得字母&数组顺序表
 * @param searchText:查询关键字 alphabetStringArray:当前数据的字母字符串列表
 * @return 字母&数组顺序表
 * @from 董凯明
 */
+ (NSDictionary<NSString*,NSMutableArray<NSMutableArray<NSString*>*>*>*)getIndexTableOfAlphabetWithSearchText:(NSString *)searchText andAlphabetStringArray:(NSMutableArray *)alphabetStringArray;

///* @brief 取得对某些属性组的搜集请求
// * @param properties:属性组 predicate:断言
// * @return 搜集请求
// * @from 董凯明
// */
//+ (NSFetchRequest *)getRequestForProperties:(NSArray *)properties withPredict:(NSPredicate *)predicate;

/* @brief 求箭着落点面积以及分布概率
 * @param array:坐标数组 center:靶子的中心点
 * @return 面积以及分布概率数组
 * @from 汤凯
 */
+ (NSArray *)getArrowAreaWithArray:(NSArray *)array andCenter:(CGPoint)center;

/* @brief 求分布位置，左上，左下，右上，右下 distance
 * @param point:坐标数组 center:靶子的中心点
 * @return 左上:1，左下4，右上2，右下3
 * @from 汤凯
 */
+ (NSNumber *)getLocationWithPoint:(CGPoint)point andCenter:(CGPoint)center;

/* @brief 求箭位离中心点的距离
 * @param point:坐标数组 center:靶子的中心点
 * @return 箭位离中心点的距离
 * @from 汤凯
 */
+ (NSNumber *)getDistanceWithPoint:(CGPoint)point andCenter:(CGPoint)center;


/* @brief 比较两个字符串代表的日期大小
 * @param date01:日期01 date02:日期02 dateFormatter:日期01和日期02的日期格式--必须一致
 * @return 0:相同 1:日期01比较大 2:日期02比较大
 * @from http://blog.163.com/life_00700@126/blog/static/276466892014101833747923/
 */
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02 withDateFormatter:(NSString*)dateFormatter;

/* @brief 是手机号吗
 * @param phone:要检测的手机号
 * @return BOOL yes:格式正确 no:格式不正确
 * @from
 */
+(BOOL)isPhoneNumber:(NSString*)phone;

/* @brief 通过16进制数取得颜色
 * @param color:16进制颜色
 * @return 颜色
 * @from 汤凯
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/* @brief 通过16进制数取得颜色
 * @param color:16进制颜色 alpha:透明度
 * @return 颜色
 * @from 汤凯
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


/* @brief 取得当前时间的上月当天
 * @param 空
 * @return 上月当天
 * @from 汤凯
 */
+ (NSDate *)getLastMonthDate;

@end