# ModelGenerator
---

## What is this?

在客户端开发中，经常需要根据服务器返回的数据建一些Modal类，很多情况只是一行行重复地声明服务器给的数据对应的属性，过程十分单一或许这个工具可以让你免去这一枯燥的过程。它可以通过解析Json来自动生成对应的的类，属性名与Json中的字段名一致，如果目标语言是Java，还会生成setter、getter。

> 目前支持3种语言`Objective-C`、`Swift`、`Java`

下面是运行截图
![](screenshot.gif)
               
## How to install and use?
              
	在Xcode中打开本工程build就可以得到可运行文件。你也可以直接打开install目录中的dmg来安装。
              
    运行后不需要任何配置，选择你要用的语言，输入希望生成的Modal类名，点击start即可开始
              
              
##Contact
* Email:zbc@zhubch.com
* QQ:474135951
              
## License
              
ModelGenerator is published under MIT License
   	
   	
   	Copyright (c) 2015 zhubch
    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
    Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.