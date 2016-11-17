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

/* @brief 取得当前时间的上n月当天
 * @param 空
 * @return 上n月当天
 * @from 汤凯
 */
+ (NSDate *)getLastNMonthDate:(NSInteger)n;

/* @brief 取得字符串
 * @param arg:参数名 dictionary:字典
 * @return 过滤后的字符串
 * @from 董凯明
 */
+ (NSString *)stringValue:(NSString*)arg fromDictionary:(NSDictionary*)dictionary;

/* @brief 取得字符串
 * @param arg:参数名 dictionary:字典 tailLength:小数点后面的位数
 * @return 过滤后的字符串
 * @from 董凯明
 */
//+ (NSString *)floatString:(NSString*)arg fromDictionary:(NSDictionary*)dictionary tailLength:(NSInteger)tailLength;

/* @brief 取得字符串
 * @param string:要检查的字符串
 * @return BOOL
 * @from 董凯明
 */
+ (BOOL)isEmptyString:(NSString*)string;

/* @brief 通过键-值数组取得对应字典
 * @param keyArray:键数组 valueArray:值数组
 * @return 对应字典
 * @from 董凯明
 */
+(NSDictionary*)getKeyValuesByKeyArray:(NSArray*)keyArray andValueArray:(NSArray*)valueArray;

typedef NS_ENUM(NSUInteger, AntiqueResultDealState) {//result处理类型
    AntiqueResultDealStateDefault = 1,//默认:正常
    AntiqueResultDealStateEnd = 2,//数据加载完成
    AntiqueResultDealStateEmpty = 3, //没有数据
};
/* @brief 取得数据后在返回当前状态
 * @param result:取得的数据 willLoadPageNum:将要加载的页码的指针 dataArray:存放数据的数组,该值必须已经初始化
 * @return 下次加载的页码
 * @from 董凯明
 */
+ (AntiqueResultDealState)loadData:(NSArray *)result withWillLoadPageNum:(NSUInteger*)willLoadPageNum andDataArray:(NSMutableArray *)dataArray withFirstPage:(NSUInteger)first_page;

/* @brief 比较两个字符串代表的日期大小
 * @param date01:日期01 date02:日期02 dateFormatter:日期01和日期02的日期格式--必须一致
 * @return 0:相同 1:日期01比较大 2:日期02比较大
 * @from http://blog.163.com/life_00700@126/blog/static/276466892014101833747923/
 */
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02 withDateFormatter:(NSString*)dateFormatter;
@end
