---
title: MySQL 数据库入门到精通
date: 2026-09-23
tags: [MySQL, 数据库]
description: 从 MySQL 安装到 MySQL 高级、MySQL 优化全栈式教程
---

本文是 MySQL 数据库入门到精通教程，知识涵盖了 MySQL 的基础、进阶、运维等多个方面，不仅讲解知识点的具体应用，还会讲解其底层结构和原理，满足我们日常的开发、运维、面试、以及自我提升。

---

## 一、MySQL 简介

### 1、MySQL 入门到精通需要学习哪些内容？

![1](/images/mysql/1.png)

### 2、数据库相关概念

| 名称           | 全称                                                         | 简称                               |
| -------------- | ------------------------------------------------------------ | ---------------------------------- |
| 数据库         | 存储数据的仓库，数据是有组织的进行存储                       | DataBase（DB）                     |
| 数据库管理系统 | 操纵和管理数据库的大型软件                                   | DataBase Management System（DBMS） |
| SQL            | 操作关系型数据库的编程语言，定义了一套操作关系型数据库统一标准 | Structured Query Language（SQL）   |

![2](/images/mysql/2.png)

主流的关系型数据库管理系统

| Rank | DBMS                         | Database Model          | Score   |
| :--: | ---------------------------- | ----------------------- | ------- |
|  1   | Oracle                       | Relational, Multi-model | 1266.89 |
|  2   | **MySQL**                    | Relational, Multi-model | 1206.05 |
|  3   | Microsoft SQL Server         | Relational, Multi-model | 944.81  |
|  4   | PostgreSQL                   | Relational, Multi-model | 606.56  |
|  5   | IBM Db2                      | Relational, Multi-model | 164.20  |
|  6   | Microsoft Access             | Relational              | 128.95  |
|  7   | SQLite                       | Relational              | 127.43  |
|  8   | MariaDB                      | Relational, Multi-model | 106.42  |
|  9   | Microsoft Azure SQL Database | Relational, Multi-model | 86.32   |
|  10  | Hive                         | Relational              | 83.45   |

不管是哪个 DBMS，都是通过统一标准的 sql 语言操作

### 3、MySQL 下载与启动

#### （1）MySQL 下载

[MySQL : Download MySQL Installer](https://dev.mysql.com/downloads/installer/)

![3](/images/mysql/3.png)

#### （2）MySQL 启动与停止

##### 1）win + R 输入 services.msc

![4](/images/mysql/4.png)

回车，找到 MySQL 相关服务，启动即可

##### 1）命令行输入指令

启动

```cmd
net start mysql80
```

停止

```cmd
net stop mysql80
```

#### （3）客户端连接

1）方式一

使用 MySQL 提供的客户端命令行工具

在开始菜单找到 MySQL 8.0 Command Line Client，点击进入，输入密码

![5](/images/mysql/5.png)

2）方式二

使用系统自带的命令行工具执行指令

```cmd
mysql  [-h 127.0.0.1]  [-P 3306]  -u root -p
```

[] 内为可选参数，如果需要连接远程的 MySQL，需要加上这两个参数来指定远程主机 IP、端口，如果连接本地的 MySQL，则无需指定这两个参数

| 参数 | 说明                         |
| ---- | ---------------------------- |
| `-h` | MySQL 服务所在的主机 IP      |
| `-P` | MySQL 服务端口号，默认 3306  |
| `-u` | MySQL 数据库用户名           |
| `-p` | MySQL 数据库用户名对应的密码 |

> 注意：
>
>  使用这种方式进行连接时，需要安装完毕后配置PATH环境变量

### 4、数据模型

#### （1）关系型数据库（RDBMS） 

概念：建立在关系模型基础上，由多张相互连接的二维表组成的数据库

二维表，指的是由行和列组成的表，如下图（类似于 Excel 表格数据，有表头、有列、有行， 还可以通过一列关联另外一个表格中的某一列数据）

![7](/images/mysql/7.png)

我们之前提到的 MySQL、Oracle、DB2、 SQLServer 这些都是属于关系型数据库，里面都是基于二维表存储数据的。简单说，基于二维表存储 数据的数据库就成为关系型数据库，不是基于二维表存储数据的数据库，就是非关系型数据库

特点： 

- 使用表存储数据，格式统一，便于维护
- 使用SQL语言操作，标准统一，使用方便

#### （2）数据模型

MySQL是关系型数据库，是基于二维表进行数据存储的的，具体的结构图下：

![6](/images/mysql/6.png)

- 我们可以通过 MySQL 客户端连接数据库管理系统 DBMS，然后通过 DBMS 操作数据库 
- 可以使用 SQL 语句，通过数据库管理系统操作数据库，以及操作数据库中的表结构及数据
- 一个数据库服务器中可以创建多个数据库，一个数据库中也可以包含多张表，而一张表中又可以包含多行记录

## 二、MySQL 基础之 —— SQL

### 1、通用语法及分类

#### （1）通用语法

- SQL 语句可以单行或多行书写，以分号结尾
- SQL 语句可以使用空格 / 缩进来增强语句的可读性
- MySQL 数据库的 SQL 语句不区分大小写，关键字建议使用大写

- 注释： 

  单行注释： -- 注释内容 或 # 注释内容

  多行注释：/* 注释内容 */

#### （2）分类

SQL 语句，根据其功能，主要分为四类：DDL、DML、DQL、DCL

| 分类 | 全称                       | 说明                                                   |
| ---- | -------------------------- | ------------------------------------------------------ |
| DDL  | Data Definition Language   | 数据定义语言，用来定义数据库对象 (数据库，表，字段)    |
| DML  | Data Manipulation Language | 数据操作语言，用来对数据库表中的数据进行增、删、改     |
| DQL  | Data Query Language        | 数据查询语言，用来查询数据库中表的记录                 |
| DCL  | Data Control Language      | 数据控制语言，用来创建数据库用户、控制数据库的访问权限 |

### 2、MySQL 中的数据类型

MySQL中的数据类型有很多，主要分为三类：数值类型、字符串类型、日期时间类型

#### （1）数值类型

| 类型        | 大小    | 有符号 (SIGNED) 范围                                  | 无符号 (UNSIGNED) 范围                                    | 描述                |
| ----------- | ------- | ----------------------------------------------------- | --------------------------------------------------------- | ------------------- |
| TINYINT     | 1byte   | (-128, 127)                                           | (0, 255)                                                  | 小整数值            |
| SMALLINT    | 2 bytes | (-32768, 32767)                                       | (0, 65535)                                                | 大整数值            |
| MEDIUMINT   | 3 bytes | (-8388608, 8388607)                                   | (0, 16777215)                                             | 大整数值            |
| INT/INTEGER | 4 bytes | (-2147483648, 2147483647)                             | (0, 4294967295)                                           | 大整数值            |
| BIGINT      | 8 bytes | (-2^63, 2^63-1)                                       | (0, 2^64-1)                                               | 极大整数值          |
| FLOAT       | 4 bytes | (-3.402823466 E+38, 3.402823466351 E+38)              | 0 和 (1.175494351 E-38, 3.402823466 E+38)                 | 单精度浮点数值      |
| DOUBLE      | 8 bytes | (-1.7976931348623157 E+308, 1.7976931348623157 E+308) | 0 和 (2.2250738585072014 E-308, 1.7976931348623157 E+308) | 双精度浮点数值      |
| DECIMAL     |         | 依赖于 M (精度) 和 D (标度) 的值                      | 依赖于 M (精度) 和 D (标度) 的值                          | 小数值 (精确定点数) |

其中 M (精度) 表示整个长度，D (标度) 表示小数位数

例子：

```sql
age tinyint unsigend comment '年龄'
```

```sql
score double(4,1)总分100分, 最多出现一位小数
# 总分 100 分, 最多出现一位小数
```

#### （2）字符串类型

| 类型       | 大小                  | 描述                          |
| ---------- | --------------------- | ----------------------------- |
| CHAR       | 0-255 bytes           | 定长字符串 (需要指定长度)     |
| VARCHAR    | 0-65535 bytes         | 变长字符串 (需要指定长度)     |
| TINYBLOB   | 0-255 bytes           | 不超过 255 个字符的二进制数据 |
| TINYTEXT   | 0-255 bytes           | 短文本字符串                  |
| BLOB       | 0-65535 bytes         | 二进制形式的长文本数据        |
| TEXT       | 0-65535 bytes         | 长文本数据                    |
| MEDIUMBLOB | 0-16 777 215 bytes    | 二进制形式的中等长度文本数据  |
| MEDIUMTEXT | 0-16 777 215 bytes    | 中等长度文本数据              |
| LONGBLOB   | 0-4 294 967 295 bytes | 二进制形式的极大文本数据      |
| LONGTEXT   | 0-4 294 967 295 bytes | 极大文本数据                  |

二进制形式的数据，如音频、视频、软件安装包等，我们一般不存在数据库中（性能并不高，且不方便管理），一般用专门的文件服务器存储

char 与 varchar 都可以描述字符串，char 是定长字符串，指定长度多长，就占用多少个字符，和字段值的长度无关 。而 varchar 是变长字符串，指定的长度为最大占用长度 。相对来说，char 的性能会更高些

- char：性能好
- varchar：性能较差，因为会根据内容计算需要占用的空间

```
如：
1）用户名 username ------> 长度不定，最长不会超过50
    username varchar(50)

2）性别 gender ---------> 存储值，不是男，就是女
    gender char(1)

3）手机号 phone --------> 固定长度为11
    phone char(11)
```

#### （3）日期时间类型

| 类型      | 大小 | 范围                                       | 格式                | 描述                     |
| --------- | ---- | ------------------------------------------ | ------------------- | ------------------------ |
| DATE      | 3    | 1000-01-01 至 9999-12-31                   | YYYY-MM-DD          | 日期值                   |
| TIME      | 3    | -838:59:59 至 838:59:59                    | HH:MM:SS            | 时间值或持续时间         |
| YEAR      | 1    | 1901 至 2155                               | YYYY                | 年份值                   |
| DATETIME  | 8    | 1000-01-01 00:00:00 至 9999-12-31 23:59:59 | YYYY-MM-DD HH:MM:SS | 混合日期和时间值         |
| TIMESTAMP | 4    | 1970-01-01 00:00:01 至 2038-01-19 03:14:07 | YYYY-MM-DD HH:MM:SS | 混合日期和时间值，时间戳 |

### 3、图形化界面工具 DataGrip

在命令进行操作，主要存在以下两点问题： 

- 会影响开发效率 
- 使用起来，并不直观，并不方便

所以在日常的开发中，我们会借助于 MySQL 的图形化界面，来简化开发，提高开发效率

目前 mysql主流的图形化界面工具，有以下几种：

![8](/images/mysql/8.png)

我们选择最后一种 DataGrip，这种图形化界面工具功能更加强大，界面提示更加友好， 是我们使用 MySQL 的不二之选

### 4、DDL

#### （1）DDL —— 数据库操作

##### 1）查询数据库

**查询所有数据库**

```sql
show databases;
```

**查询当前数据库**

```sql
select database();
```

##### 2）创建数据库

```sql
create database [ if not exists ] 数据库名 [ default charset 字符集 ] [ collate 排序规则 ];
```

在同一个数据库服务器中，不能创建两个名称相同的数据库，否则将会报错

可以通过 `if not exists` 参数来解决这个问题，数据库不存在，则创建该数据库，如果存在，则不创建：

```sql
create database if not exists 数据库名;
```

创建一个数据库，并且指定字符集：

```sql
create database 数据库名 default charset utf8mb4;
```

> MySQL 数据库中不建议设置 utf8，因为 utf8 只占三个字节，一些特殊字符占四个字节，所以推荐用 utf8mb4，支持四个字节

##### 3）删除数据库

```sql
drop database 数据库名;
```

如果删除一个不存在的数据库，将会报错。此时，可以加上参数 if exists，如果数据库存在，再执行删除，否则不执行删除

```sql
drop database [ if exists ] 数据库名;
```

##### 4）切换数据库

我们要操作某一个数据库下的表时，就需要通过该指令，切换到对应的数据库下，否则是不能操作的

```sql
use 数据库名;
```

#### （2）DDL —— 表操作

##### 1） 表操作 — 查询

**查询当前数据库所有表**

```sql
show tables;
```

比如，我们可以切换到 sys 这个系统数据库，并查看系统数据库中的所有表结构：

```sql
use sys;
show tables;
```

**查看指定表结构**

```sql
desc 表名;
```

通过这条指令，我们可以查看到指定表的字段，字段的类型、是否可以为NULL，是否存在默认值等信息

**查询指定表的建表语句**

```sql
show create table 表名;
```

通过这条指令，主要是用来查看建表语句的，而有部分参数我们在创建表的时候，并未指定也会查询到，因为这部分是数据库的默认值，如：存储引擎、字符集等

##### 2） 表操作 — 创建

```sql
# 创建表结构
CREATE TABLE 表名(
    字段1 字段1类型 [COMMENT 字段1注释 ],
    字段2 字段2类型 [COMMENT 字段2注释 ],
    字段3 字段3类型 [COMMENT 字段3注释 ],
    ......
    字段n 字段n类型 [COMMENT 字段n注释 ]
) [ COMMENT 表注释 ] ;
```

注意：[...] 内为可选参数，**最后一个字段后面没有逗号**

比如，我们创建一张表 tb_user，对应的结构如下，那么建表语句为：

| id   | name     | age  | gender |
| ---- | -------- | ---- | ------ |
| 1    | 令狐冲   | 28   | 男     |
| 2    | 风清扬   | 68   | 男     |
| 3    | 东方不败 | 32   | 男     |

```sql
create table emp(
    id int comment '编号',
    name varchar(10) comment '姓名',
    age tinyint unsigned comment '年龄',
    gender varchar(1) comment '性别',
    entrydate date comment '入职时间'
) comment '员工表';
```

##### 3） 表操作 — 修改

1. 添加字段

   ```sql
   ALTER TABLE 表名 ADD 字段名 类型(长度) [ COMMENT 注释 ] [ 约束 ];
   ```

2. 修改数据类型

   ```sql
   ALTER TABLE 表名 MODIFY 字段名 新数据类型(长度);
   ```

3. 修改字段名和数据类型

   ```sql
   ALTER TABLE 表名 CHANGE 旧字段名 新字段名 类型(长度) [ COMMENT 注释 ] [ 约束 ];
   ```

   例子：将 emp 表的 nickname 字段修改为 username，类型为 varchar (30)

   ```sql
   ALTER TABLE emp CHANGE nickname username varchar(30) COMMENT '昵称';
   ```

4. 删除字段

   ```sql
   ALTER TABLE 表名 DROP 字段名;
   ```

5. 修改表名

   ```sql
   ALTER TABLE 表名 RENAME TO 新表名;
   ```

##### 4）表操作 — 删除

1. 删除表

   ```sql
   DROP TABLE [ IF EXISTS ] 表名;
   ```

2. 删除指定表，并重新创建表

   ```sql
   TRUNCATE TABLE 表名;
   ```

   注意：在删除表的时候，表中的全部数据都会被删除

#### （3）总结

1. DDL - 数据库操作

   ```sql
   SHOW DATABASES;
   CREATE DATABASE 数据库名;
   USE 数据库名;
   SELECT DATABASE();
   DROP DATABASE 数据库名;
   ```

2. DDL - 表操作

   ```sql
   SHOW TABLES;
   CREATE TABLE 表名(字段 字段类型, 字段 字段类型);
   DESC 表名;
   SHOW CREATE TABLE 表名;
   ALTER TABLE 表名 ADD/MODIFY/CHANGE/DROP/RENAME TO ...;
   DROP TABLE 表名;
   ```

### 5、DML























### 6、DQL























### 7、DCL























## 三、MySQL 基础之 —— 函数

1、字符串函数











2、数值函数













3、日期函数













4、流程函数

















## 四、MySQL 基础之 —— 约束















## 五、MySQL 基础之 —— 多表查询



















## 六、MySQL 基础之 —— 事务















## 七、MySQL 进阶之 —— 存储引擎

















