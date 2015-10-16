//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesTimestampFormatter.h"

@interface JSQMessagesTimestampFormatter ()

// Separate formatters for the Date & Time parts for performance reasons
@property (strong, nonatomic, readwrite) NSDateFormatter *dateFormatter;
@property (strong, nonatomic, readwrite) NSDateFormatter *timeFormatter;

@end



@implementation JSQMessagesTimestampFormatter

#pragma mark - Initialization

+ (JSQMessagesTimestampFormatter *)sharedFormatter
{
    static JSQMessagesTimestampFormatter *_sharedFormatter = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [[JSQMessagesTimestampFormatter alloc] init];
    });
    
    return _sharedFormatter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDoesRelativeDateFormatting:YES];
        
        _timeFormatter = [[NSDateFormatter alloc] init];
        [_timeFormatter setLocale:[NSLocale currentLocale]];
        
        UIColor *color = [UIColor lightGrayColor];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        _dateTextAttributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName : color,
                                 NSParagraphStyleAttributeName : paragraphStyle };
        
        _timeTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName : color,
                                 NSParagraphStyleAttributeName : paragraphStyle };
    }
    return self;
}

- (void)dealloc
{
    _dateFormatter = nil;
    _timeFormatter = nil;
    _dateTextAttributes = nil;
    _timeTextAttributes = nil;
}

#pragma mark - Formatter

- (NSString *)timestampForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    NSString *relativeDate = [self relativeDateForDate:date];
    NSString *time = [self timeForDate:date];
    
    return [NSString stringWithFormat:@"%@ %@", relativeDate, time];
}

- (NSAttributedString *)attributedTimestampForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    NSString *relativeDate = [self relativeDateForDate:date];
    NSString *time = [self timeForDate:date];
    
    NSMutableAttributedString *timestamp = [[NSMutableAttributedString alloc] initWithString:relativeDate
                                                                                  attributes:self.dateTextAttributes];
    
    [timestamp appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    [timestamp appendAttributedString:[[NSAttributedString alloc] initWithString:time
                                                                      attributes:self.timeTextAttributes]];
    
    return [[NSAttributedString alloc] initWithAttributedString:timestamp];
}

- (NSString *)timeForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    [self.timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [self.timeFormatter stringFromDate:date];
}

- (NSString *)relativeDateForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [self.dateFormatter stringFromDate:date];
}

@end