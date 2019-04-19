

#import "UIControl+HitEdgeInsets.h"
#import <objc/runtime.h>

@implementation UIControl (HitEdgeInsets)

- (void)setHitInsets:(UIEdgeInsets)hitInsets {
    NSValue *value = [NSValue value:&hitInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, @selector(hitInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitInsets {
    NSValue *value = objc_getAssociatedObject(self, @selector(hitInsets));
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }
    else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitInsets, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
