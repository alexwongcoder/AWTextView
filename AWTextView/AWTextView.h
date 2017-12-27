//
//  AWTextView.h
//  AWTextViewDemo
//
//  Created by Alex on 17/10/22.
//  Copyright © 2017年 Alex Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double AWTextViewVersionNumber;
FOUNDATION_EXPORT const unsigned char AWTextViewVersionString[];

#define AWAssert(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)

@interface AWTextView : UITextView
/**placeholder*/
@property (null_resettable,nonatomic, copy) NSString *placeholder;
/**placeholder font*/
@property (nullable,nonatomic, strong) UIFont *placeholderFont;// default is superview's font
/**placeholder color*/
@property (nullable, nonatomic, strong) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;//default is nil. string is drawn 70% gray
/**attributed placeholder */
@property (null_resettable,nonatomic,copy) NSAttributedString *attributedPlaceholder;
/**attributed fade time*/
@property (nonatomic) double placeholderFadeTime;
@end



