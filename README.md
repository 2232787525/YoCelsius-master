# YoCelsius 别人的天气demo 几乎包含了所有的交互动画，非常棒。

## 研究了一段时间，改了部分动画风格精简了部分代码，改动如下：

1. 去掉了所有继承于NumberCount(数字从一个值动态变化到另外一个值的动画)的子类，
2. 精简了部分适配不同型号iphone的方法
3. 将所有***CountLable的类统一成一个类CountLable
4. 将sunriseView sunsetView 整合成一个类SunView，将父类sun的方法写到SunView中，去掉sun类
5. 大部分动画使用 startStatue、showStatue、hideStatue三个方法控制动画的开始状态、正常显示状态和动画消失的状态

[](https://github.com/2232787525/YoCelsius-master/blob/master/QQ20171127-105855-HD.gif)
