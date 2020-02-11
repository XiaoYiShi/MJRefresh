//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000


#import <Foundation/Foundation.h>
//! Project version number for CCBaseKit.
FOUNDATION_EXPORT double MJRefreshVersionNumber;

//! Project version string for CCBaseKit.
FOUNDATION_EXPORT const unsigned char MJRefreshVersionString[];


/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, MJRefreshState) {
    /** 普通闲置状态 */
    MJRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    MJRefreshStatePulling,
    /** 正在刷新中的状态 */
    MJRefreshStateRefreshing,
    /** 即将刷新的状态 */
    MJRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    MJRefreshStateNoMoreData
};

/** 进入刷新状态的回调 */
typedef void (^MJRefreshComponentRefreshingBlock)(void);
/** 开始刷新后的回调(进入刷新状态后的回调) */
typedef void (^MJRefreshComponentBeginRefreshingCompletionBlock)(void);
/** 结束刷新后的回调 */
typedef void (^MJRefreshComponentEndRefreshingCompletionBlock)(void);
