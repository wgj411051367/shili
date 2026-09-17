#import "UIScrollView+UITouch.h"

@implementation UIScrollView (ScrollTouch)

//重写touchesBegin方法

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //主要代码实现：
    if([self isMemberOfClass:[UIScrollView class]]) {//10.29 修改 此处加判断是因为与系统的手写输入键盘冲突
        //[[self nextResponder] touchesBegan:touches withEvent:event];
        //super调用，别漏
         [super touchesBegan:touches withEvent:event];
    }
    
    
}

//重写touchesEnded方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self isMemberOfClass:[UIScrollView class]]) {
      [[self nextResponder] touchesEnded:touches withEvent:event];
      [super touchesEnded:touches withEvent:event];
    }
}
//重写touchesMoved方法
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self isMemberOfClass:[UIScrollView class]]) {
      [[self nextResponder] touchesMoved:touches withEvent:event];
      [super touchesMoved:touches withEvent:event];
    }
}

@end
