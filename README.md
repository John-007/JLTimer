# JLTimer

#### 介绍

一款基于 NSTimer 、好用高效的计时器

- 采用单例持有 NStimer 对象，通过Block实时回调给创建者，使控制器与其完全解耦，再也不用担心控制器和 NStimer 循环引用问题。

- 全自动管理，计时器无业务时时自动释放，创建者无需处理后续 invalid 等操作。

- 无论同时运行着多少计时任务，全局同一时间只有一个 NSTimer 在运行，有效节省系统资源。

- 代码风格简洁易懂，使用Block回调方式，无需另写触发方法。


#### 使用说明


1.快捷创建一个只回调一次的计时器。

```
[[JLTimer shared] addNewTaskWithOnceTime:5 handleBlock:^{
	
    //5秒后回调并停止计时           
}];
```
 


2.快捷创建一个倒计时的计时器。

```
[[JLTimer shared] addCountDownTaskWithTime:3 handleBlock:^{

    //每1秒回调1次，到第3秒时停止计时

}];

```


3.创建一个常规计时器，附带停止方法。

```
NSString *timerID = [[JLTimer shared] addNewTaskWithTime:1 isRepeat:true handleBlock:^{
            
    //每1秒回调1次，一直重复，返回值为当前计时器的ID
}];

//可以在业务需要的时候调用stopTimerWithID方法停止该计时器

[[JLTimer shared] stopTimerWithID:timerID];
```

