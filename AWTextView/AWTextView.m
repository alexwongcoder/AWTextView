//
//  AWTextView.m
//  AWTextViewDemo
//
//  Created by Alex on 17/10/22.
//  Copyright © 2017年 Alex Wong. All rights reserved.
//

#import "AWTextView.h"

// UITextView
static NSString * const kTVTextKey = @"text";
static NSString * const kTVFontKey = @"font";
static NSString * const kTVAttributedTextKey = @"attributedText";
static NSString * const kTVTextAlignmentKey = @"textAlignment";

@interface AWTextView ()
@property (strong, nonatomic) UITextView *placeholderTextView;
@end

@implementation AWTextView
#pragma mark -
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addOwnView];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self addOwnView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addOwnView];
    }
    return self;
}


#pragma mark -
-(void)addOwnView{
    AWAssert(self.placeholderTextView, @"placeholderTextView existed: %@", self.placeholderTextView);
    
    //placeholderTextView, which is used to display the placeholder text, initializes first, and then adds it to the AWTextView when the placeholder text is used.
    self.placeholderTextView = [[UITextView alloc]initWithFrame:self.bounds];
    
    [self configOwnView];
}

#pragma mark -
-(void)configOwnView{
    self.placeholderTextView.opaque = NO;
    self.placeholderTextView.backgroundColor = [UIColor clearColor];
    self.placeholderTextView.font = self.font;
    self.placeholderTextView.textColor = [UIColor colorWithWhite:0.7f alpha:0.7f];
    self.placeholderTextView.textAlignment = self.textAlignment;
    self.placeholderTextView.editable = NO;
    self.placeholderTextView.scrollEnabled = NO;
    self.placeholderTextView.userInteractionEnabled = NO;
    self.placeholderTextView.isAccessibilityElement = NO;
    self.placeholderTextView.contentOffset = self.contentOffset;
    self.placeholderTextView.contentInset = self.contentInset;
    self.placeholderTextView.selectable = NO;
    if (self.attributedPlaceholder) {
        self.placeholderTextView.attributedText = self.attributedPlaceholder;
    } else if (self.placeholder) {
        self.placeholderTextView.text = self.placeholder;
    }
    
    [self configPlaceholderVisibleWith:self.text];
    
    [self addObserver];
}
#pragma mark -KVO for superview's property
-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    [self addObserver:self
           forKeyPath:kTVTextKey
              options:NSKeyValueObservingOptionNew
              context:nil];
    [self addObserver:self
           forKeyPath:kTVFontKey
              options:NSKeyValueObservingOptionNew
              context:nil];
    [self addObserver:self
           forKeyPath:kTVAttributedTextKey
              options:NSKeyValueObservingOptionNew
              context:nil];
    [self addObserver:self
           forKeyPath:kTVTextAlignmentKey
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{

    if([keyPath isEqualToString:kTVFontKey]) {
        self.placeholderTextView.font = [change valueForKey:NSKeyValueChangeNewKey];
    }
    
    else if ([keyPath isEqualToString:kTVAttributedTextKey]) {
        NSAttributedString *newAttributedText = [change valueForKey:NSKeyValueChangeNewKey];
        [self configPlaceholderVisibleWith:newAttributedText.string];
    }
    else if ([keyPath isEqualToString:kTVTextKey]) {
        NSString *newText = [change valueForKey:NSKeyValueChangeNewKey];
        [self configPlaceholderVisibleWith:newText];
    }
    else if ([keyPath isEqualToString:kTVTextAlignmentKey]) {
        NSNumber *alignment = [change objectForKey:NSKeyValueChangeNewKey];
        self.placeholderTextView.textAlignment = alignment.intValue;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutSubviews];
}

- (void)relayoutSubviews
{
    self.placeholderTextView.frame = self.bounds;
}
#pragma mark -
#pragma mark -SET/GET-
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    _attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder];
    self.placeholderTextView.text = placeholder;
    [self relayoutSubviews];
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    self.placeholderTextView.font = placeholderFont;
    [self relayoutSubviews];
}
-(void)setPlaceholderTextColor:(UIColor *)placeholderTextColor{
   
    _placeholderTextColor = placeholderTextColor;
    self.placeholderTextView.textColor = placeholderTextColor;
}

-(void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder{
    _attributedPlaceholder = [attributedPlaceholder copy];
    _placeholder = attributedPlaceholder.string;
    self.placeholderTextView.attributedText = attributedPlaceholder;
    [self relayoutSubviews];
}

#pragma mark -
//textDidChange
- (void)textDidChange:(NSNotification *)aNotification
{
    [self configPlaceholderVisibleWith:self.text];
}

#pragma mark -
//config placeholderTextView's alpha for showing or not
-(void)configPlaceholderVisibleWith:(NSString*)text{
    if (text.length < 1) {
        if (self.placeholderFadeTime > 0) {
            if (![self.placeholderTextView isDescendantOfView:self]) {
                self.placeholderTextView.alpha = 0;
                [self addSubview:self.placeholderTextView];
                [self sendSubviewToBack:self.placeholderTextView];
            }
            [UIView animateWithDuration:self.placeholderFadeTime animations:^{
                self.placeholderTextView.alpha = 1.0;
            }];
        }
        else {
            [self addSubview:self.placeholderTextView];
            //sendSubviewToBack :place thesubview between AWTextView and AWTextContainerView ; bringSubviewToFront place above AWTextContainerView,
            [self sendSubviewToBack:self.placeholderTextView];
            self.placeholderTextView.alpha = 1.0;
        }
    }
    else {
        if (self.placeholderFadeTime > 0) {
            [UIView animateWithDuration:self.placeholderFadeTime  animations:^{
                self.placeholderTextView.alpha = 0;
            }];
        }
        else {
            [self.placeholderTextView removeFromSuperview];
        }
    }
}

#pragma mark -
- (BOOL)becomeFirstResponder
{
    [self configPlaceholderVisibleWith:self.text];
    
    return [super becomeFirstResponder];
}

@end
