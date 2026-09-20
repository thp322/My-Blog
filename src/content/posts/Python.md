---
title: Python3 高级教程
date: 2026-09-20
tags: [Python]
description: 讲解 Python 基础（语法、装饰器、生成器、闭包、高阶函数），Python 并发（多线程/多进程、线程池、进程池、asyncio 协程、GIL锁），CPython 解释器（内存模型、垃圾回收、GIL、内存泄漏/OOM 排查）
---

Python 是一个高层次的结合了解释性、编译性、互动性和面向对象的脚本语言。本文从最基础的 Python 语法写起，逐步讲解 Python 高级内容，带你彻底掌握 Python 。

---

## 一、Python3 介绍

### 前言

Python 的 3.0 版本，常被称为 Python 3000，或简称 Py3k。相对于 Python 的早期版本，这是一个较大的升级。为了不带入过多的累赘，Python 3.0 在设计的时候没有考虑向下兼容

官方宣布，2020 年 1 月 1 日， 停止 Python 2 的更新

###  简介

Python 是一个高层次的结合了解释性、编译性、互动性和面向对象的脚本语言

Python 的设计具有很强的可读性，相比其他语言经常使用英文关键字，其他语言的一些标点符号，它具有比其他语言更有特色语法结构

- **Python 是一种解释型语言：** 这意味着开发过程中没有了编译这个环节。类似于 PHP 和 Perl 语言
- **Python 是交互式语言：** 这意味着，您可以在一个 Python 提示符 **>>>** 后直接执行代码
- **Python 是面向对象语言:**  这意味着 Python 支持面向对象的风格或代码封装在对象的编程技术
- **Python 是初学者的语言：**Python 对初级程序员而言，是一种伟大的语言，它支持广泛的应用程序开发，从简单的文字处理到 WWW 浏览器再到游戏

![1](/images/Python/1.png)

### Python 发展历史

Python 是由 Guido van Rossum 在八十年代末和九十年代初，在荷兰国家数学和计算机科学研究所设计出来的

Python 本身也是由诸多其他语言发展而来的,这包括 ABC、Modula-3、C、C++、Algol-68、SmallTalk、Unix shell 和其他的脚本语言等等

像 Perl 语言一样，Python 源代码同样遵循 GPL(GNU General Public License)协议

现在 Python 是由一个核心开发团队在维护，Guido van Rossum 仍然占据着至关重要的作用，指导其进展

Python 2.0 于 2000 年 10 月 16 日发布，增加了实现完整的垃圾回收，并且支持 Unicode

Python 3.0 于 2008 年 12 月 3 日发布，此版不完全兼容之前的 Python 源代码。不过，很多新特性后来也被移植到旧的 Python 2.6/2.7版本

Python 3.0 版本，常被称为 Python 3000，或简称 Py3k。相对于 Python 的早期版本，这是一个较大的升级

Python 2.7 被确定为最后一个 Python 2.x 版本，它除了支持 Python 2.x 语法外，还支持部分 Python 3.1 语法

### Python 特点

1. 易于学习：Python有相对较少的关键字，结构简单，和一个明确定义的语法，学习起来更加简单
2. 易于阅读：Python代码定义的更清晰
3. 易于维护：Python的成功在于它的源代码是相当容易维护的
4. 一个广泛的标准库：Python的最大的优势之一是丰富的库，跨平台的，在UNIX，Windows和Macintosh兼容很好
5. 互动模式：互动模式的支持，您可以从终端输入执行代码并获得结果的语言，互动的测试和调试代码片断。
6. 可移植：基于其开放源代码的特性，Python已经被移植（也就是使其工作）到许多平台
7. 可扩展：如果你需要一段运行很快的关键代码，或者是想要编写一些不愿开放的算法，你可以使用 C 或 C++ 完成那部分程序，然后从你的 Python 程序中调用
8. 数据库：sPython 提供所有主要的商业数据库的接口
9. GUI编程：Python 支持 GUI 可以创建和移植到许多系统调用
10. 可嵌入: 你可以将 Python 嵌入到 C/C++ 程序，让你的程序的用户获得"脚本化"的能力

### Python 应用

- Youtube - 视频社交网站
- Reddit - 社交分享网站
- Dropbox - 文件分享服务
- 豆瓣网 - 图书、唱片、电影等文化产品的资料数据库网站
- 知乎 - 一个问答网站
- 果壳 - 一个泛科技主题网站
- Bottle - Python微Web框架
- EVE - 网络游戏EVE大量使用Python进行开发
- Blender - 使用Python作为建模工具与GUI语言的开源3D绘图软件
- Inkscape - 一个开源的SVG矢量图形编辑器。
- ...



---



## 二、Python 核心基础语法

### 1、基础语法

#### （1）编码

默认情况下，Python3 源码文件以 **UTF-8** 编码，所有字符串都是 unicode 字符串

当然你也可以为源码文件指定不同的编码：

```python
# -*- coding: cp-1252 -*-
```

上述定义允许在源文件中使用 Windows-1252 字符集中的字符编码，对应适合语言为保加利亚语、白俄罗斯语、马其顿语、俄语、塞尔维亚语

#### （2）标识符

- 第一个字符必须以字母（a-z, A-Z）或下划线 **_** 
- 标识符的其他的部分由字母、数字和下划线组成
- 标识符对大小写敏感，count 和 Count 是不同的标识符
- 标识符对长度无硬性限制，但建议保持简洁（一般不超过 20 个字符）
- 禁止使用保留关键字，如 if、for、class 等不能作为标识符

合法标识符：

```python
age = 25                # 普通变量名，最常见
user_name = "Alice"     # 用下划线连接单词，清晰易读
_total = 100            # 下划线开头通常表示“内部使用”或“私有”
MAX_SIZE = 1024         # 全大写通常表示“常量”（固定不变的值）
calculate_area()        # 函数名，动词+名词
StudentInfo             # 类名，首字母大写（驼峰命名法）
__private_var           # 双下划线开头，有特殊含义
```

**非法标识符：**

```python
2nd_place = "silver"    # 错误：以数字开头
user-name = "Bob"       # 错误：包含连字符
class = "Math"          # 错误：使用关键字
$price = 9.99           # 错误：包含特殊字符
for = "loop"            # 错误：使用关键字
```

Python 3 允许使用 Unicode 字符作为标识符，可以用中文作为变量名，非 ASCII 标识符也是允许的了

```python
姓名 = "张三"   # 合法
π = 3.14159    # 合法
```

测试标识符是否合法：

```python
def is_valid_identifier(name):
    try:
        exec(f"{name} = None")
        return True
    except:
        return False

print(is_valid_identifier("2var"))  # False
print(is_valid_identifier("var2"))  # True
```

#### （3）Python 保留关键字

保留字即关键字，我们不能把它们用作任何标识符名称。Python 的标准库提供了一个 keyword 模块，可以输出当前版本的所有关键字：

```python
>>> import keyword
>>> keyword.kwlist
['False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']
```

| **类别**     | **关键字** | **说明**                               |
| :----------- | :--------- | :------------------------------------- |
| **逻辑值**   | `True`     | 布尔真值                               |
|              | `False`    | 布尔假值                               |
|              | `None`     | 表示空值或无值                         |
| **逻辑运算** | `and`      | 逻辑与运算                             |
|              | `or`       | 逻辑或运算                             |
|              | `not`      | 逻辑非运算                             |
| **条件控制** | `if`       | 条件判断语句                           |
|              | `elif`     | 否则如果（else if 的缩写）             |
|              | `else`     | 否则分支                               |
| **循环控制** | `for`      | 迭代循环                               |
|              | `while`    | 条件循环                               |
|              | `break`    | 跳出循环                               |
|              | `continue` | 跳过当前循环的剩余部分，进入下一次迭代 |
| **异常处理** | `try`      | 尝试执行代码块                         |
|              | `except`   | 捕获异常                               |
|              | `finally`  | 无论是否发生异常都会执行的代码块       |
|              | `raise`    | 抛出异常                               |
| **函数定义** | `def`      | 定义函数                               |
|              | `return`   | 从函数返回值                           |
|              | `lambda`   | 创建匿名函数                           |
| **类与对象** | `class`    | 定义类                                 |
|              | `del`      | 删除对象引用                           |
| **模块导入** | `import`   | 导入模块                               |
|              | `from`     | 从模块导入特定部分                     |
|              | `as`       | 为导入的模块或对象创建别名             |
| **作用域**   | `global`   | 声明全局变量                           |
|              | `nonlocal` | 声明非局部变量（用于嵌套函数）         |
| **异步编程** | `async`    | 声明异步函数                           |
|              | `await`    | 等待异步操作完成                       |
| **其他**     | `assert`   | 断言，用于测试条件是否为真             |
|              | `in`       | 检查成员关系                           |
|              | `is`       | 检查对象身份（是否是同一个对象）       |
|              | `pass`     | 空语句，用于占位                       |
|              | `with`     | 上下文管理器，用于资源管理             |
|              | `yield`    | 从生成器函数返回值                     |

#### （4）注释

```python
# 单行注释

"""
多行注释 1
"""

'''
多行注释 2
'''
```

#### （5）行与缩进

python 最具特色的就是使用缩进来表示代码块，不需要使用大括号 **{}** ，缩进的空格数是可变的，但是同一个代码块的语句必须包含相同的缩进空格数

```python
if True:
    print ("True")
else:
    print ("False")
```

缩进相同的一组语句构成一个代码块，我们称之代码组

像 if、while、def 和 class 这样的复合语句，首行以关键字开始，以冒号( : )结束，该行之后的一行或多行代码构成代码组

我们将首行及后面的代码组称为一个子句(clause)

#### （6）空行

函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始

空行并不是 Python 语法的一部分，作用在于分隔两段不同功能或含义的代码

**记住：**空行也是程序代码的一部分

#### （7）多行语句

Python 通常是一行写完一条语句，但如果语句很长，我们可以使用反斜杠 `\` 来实现多行语句，例如：

```python
total = item_one + \
        item_two + \
        item_three
```

在 [], {}, 或 () 中的多行语句，不需要使用反斜杠 `\` ，例如：

```python
total = ['item_one', 'item_two', 'item_three',
        'item_four', 'item_five']
```

#### （8）同一行显示多条语句

Python 可以在同一行中使用多条语句，语句之间使用分号 **;** 分割，以下是一个简单的实例：

```python
import sys; x = 'runoob'; sys.stdout.write(x + '\n')
```

#### （9）input 等待用户输入

```
input("输入：")
```

#### （10）print 输出

**print** 默认输出是换行的，如果要实现不换行需要在变量末尾加上 **end=""**：

```python
print(1, end=" " )
print(2, end=" " )
```

#### （11）import 与 from...import

在 python 用 **import** 或者 **from...import** 来导入相应的模块

```python
# 将整个模块(somemodule)导入
import somemodule

# 从某个模块中导入某个函数
from somemodule import somefunction

# 从某个模块中导入多个函数
from somemodule import firstfunc, secondfunc, thirdfunc

# 将某个模块中的全部函数导入
from somemodule import *
```

#### （12）命令行参数

很多程序可以执行一些操作来查看一些基本信息，Python 可以使用 -h 参数查看各参数帮助信息：

```python
$ python -h
usage: python [option] ... [-c cmd | -m mod | file | -] [arg] ...
Options and arguments (and corresponding environment variables):
-c cmd : program passed in as string (terminates option list)
-d     : debug output from parser (also PYTHONDEBUG=x)
-E     : ignore environment variables (such as PYTHONPATH)
-h     : print this help message and exit

[ etc. ]
```

### 2、基本数据类型

Python 中的变量不需要声明。每个变量在使用前都必须赋值，变量赋值以后该变量才会被创建

在 Python 中，变量就是变量，它没有类型，我们所说的**类型**是变量所指的内存中对象的类型

#### 赋值

```python
a = 1
```

#### 多个变量赋值

```python
a = b = c = 1
```

#### 查看变量的类型

```python
x = False
print(type(x)) 
# <class 'bool'>

a = False
print(isinstance(a, int))
# True
```

`isinstance` 和 `type` 的区别在于：

- `type()` 不会认为子类是一种父类类型
- `isinstance()` 会认为子类是一种父类类型

**注意：**Python3 中，bool 是 int 的子类，True 和 False 可以和数字相加

#### （1）标准数据类型

Python3 中有 6 种标准数据类型，以及 bool 布尔类型（bool 是 int 的子类，有时单独列出）：

- Number（数字）
- String（字符串）
- bool（布尔类型）
- List（列表）
- Tuple（元组）
- Set（集合）
- Dictionary（字典）

按是否可变，可以分为以下两类：

- **不可变数据（4 个）：**Number（数字）、String（字符串）、bool（布尔）、Tuple（元组）
- **可变数据（3 个）：**List（列表）、Dictionary（字典）、Set（集合）

此外还有一些高级的数据类型，如字节数组类型 bytes

#### （2）Number（数字）

Python3 支持 **int、float、bool、complex（复数）**

在 Python 3 里，只有一种整数类型 int，表示为长整型

当你指定一个值时，Number 对象就会被创建：

```python
var = 1
```

可以使用 **del** 语句删除对象引用：

```python
del var
print(var)
# name 'var' is not defined.
```

##### 数值运算：

```
+  -  *  /  ** //
```

**注意：**

- Python 可以同时为多个变量赋值，如 `a, b = 1, 2`
- 一个变量可以通过赋值指向不同类型的对象
- 数值的除法包含两个运算符：**/** 返回一个浮点数，**//** 返回一个整数（向下取整）
- 在混合计算时，Python 会把整型自动转换为浮点数
- *Python 3 中整数字面量不允许前导零（如* `080`*），八进制数必须使用* `0o` *前缀（如* `0o17`*），十六进制使用* `0x` *前缀（如* `0x69`*），二进制使用* `0b` *前缀*

#### （3）String（字符串）

Python 中的字符串用单引号 **'** 或双引号 **"** 括起来，同时使用反斜杠 **\** 转义特殊字符

字符串截取的语法格式如下：

```python
变量[头下标:尾下标]
```

![2](/images/Python/2.png)

加号 **+** 是字符串的连接符，星号 ***** 表示复制当前字符串，与之结合的数字为复制的次数

```python
str1 = "hello"

print(str1 * 2)         # 重复打印两次：hellohello
print(str1 + "world")  # 字符串拼接：helloworld
```

Python 使用反斜杠 `\` 转义特殊字符，如果你不想让反斜杠发生转义，可以在字符串前面添加一个 `r`，表示原始字符串：

```python
print('Ru\noob')
# Ru
# oob

print(r'Ru\noob')
# Ru\noob
```

另外，反斜杠（\）可以作为续行符，表示下一行是上一行的延续。也可以使用 **"""..."""** 或者 **'''...'''** 跨越多行

```python
total = 1 + 2 + 3 + \
        4 + 5 + 6
print(total)  
# 21

b = """Hello
World"""
print(b)
# Hello
# World
```

注意，Python 没有单独的字符类型，一个字符就是长度为 1 的字符串

Python 字符串不能被改变，向一个索引位置赋值，比如 **word[0] = 'm'** 会导致错误

#### （4）bool（布尔类型）

布尔类型即 True 或 False。在 Python 中，True 和 False 都是关键字，表示布尔值

特点：

- 布尔类型只有两个值：True 和 False

- bool 是 int 的子类，因此布尔值可以被看作整数来使用，其中 True 等价于 1，False 等价于 0

- 布尔类型可以和其他数据类型进行比较，比如数字、字符串等。在比较时，Python 会将 True 视为 1，False 视为 0

- 布尔类型可以和逻辑运算符一起使用，包括 `and`、`or` 和 `not`，用来组合多个布尔表达式

- 布尔类型也可以被转换成其他数据类型，比如整数、浮点数和字符串。在转换时，True 会被转换成 1，False 会被转换成 0

- 可以使用 `bool()` 函数将其他类型的值转换为布尔值。

  1）以下值转换为布尔值时为 `False`：`None`、`False`、零（`0`、`0.0`、`0j`）、空序列（如 `''`、`()`、`[]`）和空映射（如 `{}`）

  2）其他所有值转换为布尔值时均为 `True`

#### （5）List（列表）

List（列表）是 Python 中使用最频繁的数据类型

列表可以完成大多数集合类的数据结构实现。列表中元素的类型可以不相同，也可以嵌套列表

和字符串一样，列表同样可以被索引和截取，列表被截取后返回一个包含所需元素的新列表，不同的是列表中的元素是可以改变的

```python
变量[头下标:尾下标]
```

加号 **+** 是列表连接运算符，星号 ***** 是重复操作。如下实例：

```python
list1 = ['abc', 123] 
list2 = [456, 'def']

print(list1 * 2)        
# ['abc', 123, 'abc', 123]

print(list1 + list2) 
# ['abc', 123, 456, 'def']
```

Python 列表截取可以接收第三个参数，参数作用是截取的步长

如果第三个参数为负数表示逆向读取

```python
list1 = [1, 2, 3, 4, 5, 6]
print(list1[5:0:-2])
# [6, 4, 2]
```

#### （6）元祖

元组（tuple）与列表类似，元组中的元素类型也可以不相同，不同之处在于元组的元素不能修改

元组与字符串类似，可以被索引且下标从 0 开始，-1 为从末尾开始的位置，也可以进行截取。其实，可以把字符串看作一种特殊的元组

构造包含 0 个或 1 个元素的元组比较特殊，有一些额外的语法规则：

```python
tup1 = ()      # 空元组
tup2 = (20,)   # 一个元素，需要在元素后添加逗号

not_a_tuple = (42)  # 这是整数 42，不是元组
```

元组也可以使用 **+** 操作符进行拼接

#### （7）Set（集合）

Python 中的集合（Set）是一种无序、可变的数据类型，用于存储唯一的元素。集合中的元素不会重复，并且可以进行交集、并集、差集等常见的集合操作

在 Python 中，集合使用大括号 **{}** 表示，元素之间用逗号 **,** 分隔。也可以使用 **set()** 函数创建集合

**注意：**创建一个空集合必须用 **set()** *而不是* **{}**，因为 **{}** *创建的是一个空字典

#### （8）Dictionary（字典）

字典是一种映射类型，用 **{}** 标识，它是一个 **键(key) : 值(value)** 的集合。键(key) 必须使用不可变类型，且在同一个字典中键必须是唯一的

**注意：**Python 3.7 起，字典会保持元素的***插入顺序***，不再是无序的。如果需要有序字典的特性，直接使用普通`dict` *即可。*

```python
dict1 = dict([('Runoob', 1), ('Google', 2), ('Taobao', 3)])
print(dict1)
# {'Runoob': 1, 'Google': 2, 'Taobao': 3}

dict2 = {x: x**2 for x in (2, 4, 6)}
print(dict2)
# {2: 4, 4: 16, 6: 36}
```

**{x: x\**2 for x in (2, 4, 6)}** 使用的是字典推导式

另外，字典类型也有一些内置的函数，例如 `clear()`、`keys()`、`values()` 等

#### （9）bytes 类型

bytes 类型表示的是不可变的二进制序列（byte sequence）。与字符串类型不同的是，bytes 类型中的元素是整数值（0 到 255 之间的整数），而不是 Unicode 字符

bytes 类型通常用于处理二进制数据，比如图像文件、音频文件、视频文件等。在网络编程中，也经常使用 bytes 类型来传输二进制数据。

创建 bytes 对象最常见的方式是使用 **b** 前缀：

```python
x = b"hello"           # 使用 b 前缀创建 bytes 对象
print(x)               # b'hello'
print(type(x))         # <class 'bytes'>
print(x[0])            # 104（'h' 的 ASCII 值，bytes 元素是整数）
```

也可以使用 `bytes()` 函数将其他类型的对象转换为 bytes 类型，第二个参数指定编码方式：

```python
x = bytes("hello", encoding="utf-8")
```

与字符串类型类似，bytes 类型也支持切片、拼接、查找、替换等操作。由于 bytes 类型是不可变的，修改操作需要创建一个新的 bytes 对象：

```python
x = b"hello"
y = x[1:3]          # 切片操作，得到 b'el'
z = x + b"world"    # 拼接操作，得到 b'helloworld'
print(y)            # b'el'
print(z)            # b'helloworld'
```

需要注意的是，bytes 类型中的元素是整数值，因此在进行比较操作时需要使用相应的整数值。可以用 `ord()` 函数将字符转换为对应的整数值：

```python
x = b"hello"
if x[0] == ord("h"):    # ord("h") 返回 104
    print("第一个元素是 'h'")
```

### 3、数据类型转换

Python 数据类型转换可以分为两种：

- 隐式类型转换 - 自动完成
- 显式类型转换 - 需要使用类型函数来转换











