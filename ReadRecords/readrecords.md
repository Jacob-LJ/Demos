---
2018年09月25日

25 [缴满15年仍不能领养老金？](https://mp.weixin.qq.com/s/ADryPDvbeV_NR0hDpF3Hlg)
> 看参保人在各个参保地的缴费年限，然后按照“户籍地优先、从长、从后计算”的原则来确定领取地

24 [iOS启动时间优化](http://www.zoomfeng.com/blog/launch-time.html)
> App启动流程描述比较详细

---
2018年09月22日

23 [MBProgressHUD的封装](https://github.com/nenhall/NHHUDExtend)
> 在 airprint demo 中使用了，demo 事例清晰

22 [2018最新苹果APP上架App Store流程](https://blog.csdn.net/xxw888/article/details/73618837)
> 知道，原来上传 App 时候可选择销售区域的，并不是国内开发者只能发布应用到国内AppStore的

---
2018年09月21日

21 [图形记忆法](https://m.weibo.cn/status/4286454400398162?wm=3333_2001&from=1089093010&sourcetype=weixin&featurecode=newtitle)
> 从图形上理解抽象概念或事实概念

20 [检测设备是否为 iPhone X/XS/XR 的几种方式](https://kangzubin.com/iphonex-detect/)
> 还是屏幕宽高相对比较好判断

19 [浏览器渲染性能分析总结](http://jinge.red/html/performance/rendering.html?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)
> 浏览器渲染性能分析总结
优化javascript的执行
避免js执行时间太长
用requestAnimationRequest来做视觉变化
减少样式计算的作用范围及复杂性
避免复杂的布局计算以及布局的反复计算(下面简称布局抖动)
简化绘制复杂性及减小绘制区域
坚持使用只影响合成的css属性(下面简称"合成相关")及合理使用渲染层
考虑在事件处理中使用防节流机制

18 [Google图解：Chrome 快是有原因的，科普浏览器架构](https://mp.weixin.qq.com/s/TPqQtkkj0KcQhZJm-sXEuw)
> Chrome 10 周年之际，官方使用图解的方式，很清晰的讲解了现代浏览器的运行原理

17 [使用 NSUserDefaults 存储字典的一个坑](https://juejin.im/post/5adf1831518825673b61aa65)
> 使用 NSUserDefaults 存储字典报错Attempt to set a non-property-list objec ... as an NSUserDefaults/CFPreferences value for key ...，原因是存储 非NSString类型的key字典


16 [图片浏览器 (支持视频)](https://www.jianshu.com/p/bffdb9f0036c?utm_campaign=hugo&utm_medium=reader_share&utm_content=note)
> 主要讲述 YBImageBrowser 的一些功能技术细节，代码架构思路，设计模式选择等

15 [iOS LocalAuthentication开发实践 指纹解锁](http://www.code4app.com/blog-907068-21235.html)
> 对用到的 API 有比较详细的介绍，小 Q 项目中指纹解锁模块进行了功能类的抽取，需重新抽成 demo，给以后自己参考

---
2018年09月19日
14 使用safari对webview进行调试
> [safari调试iPhone app web页面](https://www.jianshu.com/p/30de92fa0d0d)
> [使用safari对webview进行调试模拟器](https://www.cnblogs.com/muyushifang07/p/5412956.html)

13 Cornerstone ignore
> 应该忽略的文件有 `xcuserdata, *.xcuserstate, *.xcuserdatad`,但后面两个其实就在第一个文件夹下的
> [整体路径](https://stackoverflow.com/a/22730480)
> [cornerstone ignore,忽略不必要的文件](https://www.jianshu.com/p/34aaeb7d949f)
> [cornerstone 忽略不必要文件]( https://juejin.im/post/5a31d57c6fb9a045211eb736)

12 [身处小公司，如何在2年内快速突破](https://juejin.im/post/5ba09086f265da0a8726503b)
> 给出了进阶的思路，第二点提出了笔记的方式：xmind式笔记串联思想

11 [不想学习的时候如何逼迫自己去学习](https://www.zhihu.com/question/20773513/answer/481734387)
> 验的记忆由峰终定律（Peak-End Rule）决定
> 第一个是体验最高峰的时候，无论是正向的最高峰还是负向的最高峰，一定是能记得住的。（峰值）
> 第二个是结束时的感觉。（终值）
> 1.学习困难时，切换至容易的事情上获取正向峰值，然后再切换回来继续学习
> 2. 终值，每次学习的末尾，都要以你最喜欢、最能带给你反馈感的环节结束。别去学最难的东西，也别在纠结焦虑中，让学习体验以痛苦终结。

10 [iPhone 屏幕分辨率终极指南](https://kangzubin.com/iphone-resolutions/)
> 判断当前设备是否为 iPhone X :获取屏幕的高度，判断是否等于 812 或 896

9 [Instagram风格的相册和照相repo](https://github.com/Yummypets/YPImagePicker)
> swift写的

8 [初步探索LaunchScreen](https://mp.weixin.qq.com/s/gv6kL7sqRKsimF300grsfw)
> 点击App图标后，iOS系统的桌面SpringBoard会先创建LaunchScreen，然后创建App对应的进程。那么可以这样认为：LaunchScreen的加载是不占用App进程自身感知到的启动时间的。LaunchScreen是SpringBoard为了用户体验，提前在进程启动之前展示给用户看的。其中内含逆向相关操作，可以作为逆向例子参考

7 downloader下载器相关-github
> [MCDownloadManager](https://github.com/agelessman/MCDownloadManager)
> [HWIFileDownload](https://github.com/Heikowi/HWIFileDownload)

6 [Taro](https://taro.aotu.io/)
> 多端统一开发框架 Taro 1.0 正式发布，全面支持小程序

5 [深入理解 JavaScriptCore](https://mp.weixin.qq.com/s/FwLL1CukwkNASlZfuIhlRA)
> 美团技术团队分享

4 [RJIterator](https://github.com/renjinkui2719/RJIterator)
> 生成器与迭代器的Objective-C实现,实现类似ES6的yield语意,ES7 async, await异步方案,支持在Objective-C/Swift项目中以同步风格编写异步代码,避免长回调链和Promise链.
> 登录场景: 登录成功 --> 查询个人信息 --> 下载头像 --> 给头像加特效 --> 进入详情

---
2018年09月18日

3 [iOS性能优化篇](http://www.cocoachina.com/ios/20180917/24848.html)
> 优化要点罗列：CPU和GPU(屏幕成像原理、卡顿)、离屏渲染、耗电、App启动

2 [iPad上的WKWebView自动将该网址转为PC端的网址](https://www.jianshu.com/p/fb5c62a36232)
> WKWebView 在iPad上加载手机端的网址时，会自动将该网址转为PC端的网址，将WKWebView的customUserAgent把iPad改为iPhone就可以。userAgent是浏览器标识，意思就是将iPad的浏览器标识变成iPhone浏览器的标识，这样就会加载iPhone上的网址


1 [关于Xcode Archive后App出关于Xcode Archive后App出现在Other Items分组里的解决办法](https://weibo.com/1608617333/GvCKxxlF2?type=comment#_rnd1537245829295)
> 打包时遇到，Archive成功后App出现在了Other Items分组里，而非原来的iOS Apps下面对应的App里，并且Validate处于禁用状态，无法导出ipa和上传AppStore

