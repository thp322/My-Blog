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

DML 英文全称是 Data Manipulation Language (数据操作语言)，用来对数据库中表的数据记录进行增、删、改操作

- 添加数据（INSERT）
- 修改数据（UPDATE）
- 删除数据（DELETE）

#### （1）添加数据

##### 1） 给指定字段添加数据

```sql
INSERT INTO 表名(字段名1, 字段名2, ...) VALUES(值1, 值2, ...);
```

插入数据完成之后，查询数据库的数据：

```sql
select * from 表名;
```

##### 2）给全部字段添加数据

```sql
INSERT INTO 表名 VALUES (值1, 值2, ...);
```

##### 3）批量添加数据

```sql
INSERT INTO 表名 (字段名1, 字段名2, ...) VALUES (值1, 值2, ...), (值1, 值2, ...), (值1, 值2, ...);
INSERT INTO 表名 VALUES (值1, 值2, ...), (值1, 值2, ...), (值1, 值2, ...);
```

注意事项：

- 插入数据时，指定的字段顺序需要与值的顺序是一一对应的
- 字符串和日期型数据应该包含在引号中
- 插入的数据大小，应该在字段的规定范围内

#### （2）修改数据

```sql
UPDATE 表名 SET 字段名1 = 值1 , 字段名2 = 值2 , .... [ WHERE 条件 ] ;
```

注意事项： 

修改语句的条件可以有，也可以没有，如果没有条件，则会修改整张表的所有数据

#### （3）删除数据

```sql
DELETE FROM 表名 [ WHERE 条件 ];
```

注意事项：

- DELETE 语句的条件可以有，也可以没有，如果没有条件，则会删除整张表的所有数据
- DELETE 语句不能删除某一个字段的值（可以使用 UPDATE，将该字段值置为 NULL 即可）
- 当进行删除全部数据操作时，datagrip 会提示我们，询问是否确认删除，我们直接点击 Execute 即可

### 6、DQL

DQL 英文全称是 Data Query Language（数据查询语言），数据查询语言，用来查询数据库中表的记录

查询关键字：`SELECT`

在一个正常的业务系统中，查询操作的频次是要远高于增删改的，在查询的过程中，可能还会涉及到条件、排序、分页等操作

#### （1）基本语法

```sql
SELECT
    字段列表
FROM
    表名列表
WHERE
    条件列表
GROUP BY
    分组字段列表
HAVING
    分组后条件列表
ORDER BY
    排序字段列表
LIMIT
    分页参数
```

将上面的完整语法进行拆分，分为以下几个部分：

- 基本查询（不带任何条件）
- 条件查询（WHERE）
- 聚合函数（count、max、min、avg、sum）
- 分组查询（group by）
- 排序查询（order by）
- 分页查询（limit）

#### （2）基础查询（不带任何查询条件）

##### 1）查询多个字段

```sql
SELECT 字段1, 字段2, 字段3 ... FROM 表名 ;
SELECT * FROM 表名 ;
```

> 注意：* 号代表查询所有字段，在实际开发中尽量少用（不直观、影响效率）

##### 2）字段设置别名

```sql
SELECT 字段1 [ AS 别名1 ] , 字段2 [ AS 别名2 ] ... FROM 表名;
SELECT 字段1 [ 别名1 ] , 字段2 [ 别名2 ] ... FROM 表名;
```

##### 3）去除重复记录

```sql
SELECT DISTINCT 字段列表 FROM 表名;
```

案例：

A. 查询指定字段 name，workno，age 并返回

```sql
select name,workno,age from emp;
```

B. 查询返回所有字段

```sql
select id ,workno,name,gender,age,idcard,workaddress,entrydate from emp;
select * from emp;
```

C. 查询所有员工的工作地址，起别名

```sql
select workaddress as '工作地址' from emp;
-- as 可以省略
select workaddress '工作地址' from emp;
```

D. 查询公司员工的上班地址有哪些（不要重复）

```sql
select distinct workaddress '工作地址' from emp;
```

#### （3）条件查询

##### 1）语法

```sql
SELECT 字段列表 FROM 表名 WHERE 条件列表 ;
```

##### 2）条件

常用的比较运算符：

| 比较运算符          | 功能                                     |
| ------------------- | ---------------------------------------- |
| >                   | 大于                                     |
| >=                  | 大于等于                                 |
| <                   | 小于                                     |
| <=                  | 小于等于                                 |
| =                   | 等于                                     |
| <> 或 !=            | 不等于                                   |
| BETWEEN ... AND ... | 在某个范围之内(含最小、最大值)           |
| IN(...)             | 在in之后的列表中的值，多选一             |
| LIKE 占位符         | 模糊匹配(_匹配单个字符，%匹配任意个字符) |
| IS NULL             | 是NULL                                   |

常用的逻辑运算符：

| 逻辑运算符 | 功能                         |
| ---------- | ---------------------------- |
| AND 或 &&  | 并且（多个条件同时成立）     |
| OR 或 \|\| | 或者（多个条件任意一个成立） |
| NOT 或 !   | 非，不是                     |

##### 案例：

```sql
-- A. 查询年龄等于 88 的员工
select * from emp where age = 88;

-- B. 查询年龄小于 20 的员工信息
select * from emp where age < 20;

-- C. 查询年龄小于等于 20 的员工信息
select * from emp where age <= 20;

-- D. 查询没有身份证号的员工信息
select * from emp where idcard is null;

-- E. 查询有身份证号的员工信息
select * from emp where idcard is not null;

-- F. 查询年龄不等于 88 的员工信息
select * from emp where age != 88;
select * from emp where age <> 88;

-- G. 查询年龄在 15 岁(包含) 到 20 岁(包含)之间的员工信息
select * from emp where age >=15 && age <=20;
select * from emp where age >= 15 and age <= 20;
select * from emp where age between 15 and 20;

-- H. 查询性别为 女 且年龄小于 25 岁的员工信息
select * from emp where gender = '女' and age < 25;

-- I. 查询年龄等于 18 或 20 或 40 的员工信息
select * from emp where age = 18 or age = 20 or age =40;
select * from emp where age in(18,20,40);

-- J. 查询姓名为两个字的员工信息
select * from emp where name like '__';

-- K. 查询身份证号最后一位是 X 的员工信息
select * from emp where idcard like '%X';      # % : 前面是多少个字符都无所谓
select * from emp where idcard like '___________X';
```

#### （4）聚合函数

##### 1）介绍

将一列数据作为一个整体，进行纵向计算

##### 2）常见的聚合函数

| 函数  | 功能     |
| ----- | -------- |
| count | 统计数量 |
| max   | 最大值   |
| min   | 最小值   |
| avg   | 平均值   |
| sum   | 求和     |

##### 3）语法

```sql
SELECT 聚合函数(字段列表) FROM 表名 ;
```

> 注意：NULL 值是不参与所有聚合函数运算的

##### 案例：

A. 统计该企业员工数量

```sql
select count(*) from emp;        -- 统计的是总记录数
select count(idcard) from emp;   -- 统计的是 idcard 字段不为 null 的记录数
```

对于 count 聚合函数，统计符合条件的总记录数，还可以通过 count（数字/字符串）的形式进行统计查询，比如：

```sql
select count(1) from emp;
```

> 对于count（*）、count（字段）、count(1) 的具体原理，我们在进阶篇中 SQL 优化部分会详细讲解，此处大家只需要知道如何使用即可

B. 统计该企业员工的平均年龄

```sql
select avg(age) from emp;
```

C. 统计该企业员工的最大年龄

```sql
select max(age) from emp;
```

D. 统计该企业员工的最小年龄

```sql
select min(age) from emp;
```

E. 统计西安地区员工的年龄之和

```sql
select sum(age) from emp where workaddress = '西安';
```

#### （5）分组查询

##### 1）语法

```sql
SELECT 字段列表 FROM 表名 [ WHERE 条件 ] GROUP BY 分组字段名 [ HAVING 分组后过滤条件 ];
```

##### 2）where 与 having 区别

- 执行时机不同

  where 是分组之前进行过滤，不满足 where 条件，不参与分组；而 having 是分组之后对结果进行过滤

- 判断条件不同

  where 不能对聚合函数进行判断，而 having 可以

> 注意事项：
>
> - 分组之后，查询的字段一般为聚合函数和分组字段，查询其他字段无任何意义
> - 执行顺序：where > 聚合函数 > having
> - 支持多字段分组，具体语法为：group by columnA,columnB

##### 案例： 

A. 根据性别分组，统计男性员工和女性员工的数量

```sql
select gender, count(*) from emp group by gender ;
```

B. 根据性别分组，统计男性员工 和 女性员工的平均年龄

```sql
select gender, avg(age) from emp group by gender ;
```

C. 查询年龄小于 45 的员工，并根据工作地址分组，获取员工数量大于等于 3 的工作地址

```sql
select workaddress, count(*) address_count from emp where age < 45 group by workaddress having address_count >= 3;
```

D. 统计各个工作地址上班的男性及女性员工的数量

```sql
select workaddress, gender, count(*) '数量' from emp group by gender , workaddress;
```

#### （6）排序查询

排序在日常开发中是非常常见的一个操作，有升序排序，也有降序排序

##### 1）语法

```sql
SELECT 字段列表 FROM 表名 ORDER BY 字段1 排序方式1 , 字段2 排序方式2 ;
```

##### 2）排序方式

- ASC：升序(默认值)
- DESC：降序

> 注意事项：
>
> - 如果是升序，可以不指定排序方式 ASC
> - 如果是多字段排序，当第一个字段值相同时，才会根据第二个字段进行排序

##### 案例：

A. 根据年龄对公司的员工进行升序排序

```sql
select * from emp order by age asc;
select * from emp order by age;
```

B. 根据入职时间，对员工进行降序排序

```sql
select * from emp order by entrydate desc;
```

C. 根据年龄对公司的员工进行升序排序，年龄相同，再按照入职时间进行降序排序

```sql
select * from emp order by age asc , entrydate desc;
```

#### （7）分页查询

分页操作在业务系统开发时，也是非常常见的一个功能，我们在网站中看到的各种各样的分页条，后台都需要借助于数据库的分页操作

##### 语法

```sql
SELECT 字段列表 FROM 表名 LIMIT 起始索引, 查询记录数 ;
```

> 注意事项：
>
> - 起始索引从 0 开始，起始索引 =（查询页码 - 1）* 每页显示记录数
> - 分页查询是数据库的方言，不同的数据库有不同的实现，MySQL 中是 LIMIT
> - 如果查询的是第一页数据，起始索引可以省略，直接简写为 limit 10

##### 案例：

A. 查询第 1 页员工数据，每页展示 10 条记录

```sql
select * from emp limit 0,10;

select * from emp limit 10;
```

B. 查询第 2 页员工数据，每页展示 10 条记录 --------> (页码 - 1) * 页展示记录数

```sql
select * from emp limit 10,10;
```

#### （8）DQL执行顺序

在讲解DQL语句的具体语法之前，我们已经讲解了DQL语句的完整语法，及编写顺序，接下来，我们要来说明的是DQL语句在执行时的执行顺序，也就是先执行哪一部分，后执行哪一部分

##### 编写顺序

```
SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT
```

##### 执行顺序

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

![9](/images/mysql/9.png)

##### 验证：

查询年龄大于15的员工姓名、年龄，并根据年龄进行升序排序

```sql
select name , age from emp where age > 15 order by age asc;
```

在查询时，我们给 emp 表起一个别名 e，然后在 select 及 where 中使用该别名

```sql
select e.name , e.age from emp e where e.age > 15 order by age asc;
```

执行上述 SQL 语句后，我们看到依然可以正常的查询到结果，此时就说明：from 先执行，然后 where 和 select 执行。那  where 和 select 到底哪个先执行呢？

此时，此时我们可以给 select 后面的字段起别名，然后在 where 中使用这个别名，然后看看是否可以执行成功

```sql
select e.name ename , e.age eage from emp e where eage > 15 order by age asc;
```

> 执行上述 SQL 报错：`Unknown column 'eage' in 'where clause'` 由此我们可以得出结论：**from 先执行，然后执行 where ， 再执行 select**

接下来，我们再执行如下 SQL 语句，查看执行效果：

```sql
select e.name ename , e.age eage from emp e where e.age > 15 order by eage asc;
```

结果执行成功。那么也就验证了：**order by 是在select 语句之后执行的**

综上所述，我们可以看到 DQL 语句的执行顺序为： **from → where → group by → having → select → order by → limit**

### 7、DCL

DCL 英文全称是 Data Control Language（数据控制语言），用来管理数据库用户、控制数据库的访问权限

DCL 主要控制两个方面：

- 数据库有哪些用户可以访问
- 每个用户具有哪些访问权限

#### （1）DCL —— 管理用户

##### 1）查询用户

```sql
select * from mysql.user;
```

查询结果字段说明：

- Host：代表当前用户访问的主机，如果为`localhost`，仅代表只能够在当前本机访问，不可以远程访问

- User：代表的是访问该数据库的用户名

  > 在MySQL中需要通过Host和User来唯一标识一个用户

##### 2）创建用户

```sql
CREATE USER '用户名'@'主机名' IDENTIFIED BY '密码';
```

实例：

```sql
-- 创建用户 itcast ，只能够在当前主机localhost访问，密码123456;
create user 'itcast'@'localhost' identified by '123456';

-- 创建用户 heima ，可以在任意主机访问该数据库，密码123456 ;
create user 'heima'@'%' identified by '123456';

-- 修改用户 heima 的访问密码为 1234 ;
alter user 'heima'@'%' identified with mysql_native_password by '1234';

-- 删除itcast@localhost用户
drop user 'itcast'@'localhost';
```

##### 3）修改用户密码

```sql
ALTER USER '用户名'@'主机名' IDENTIFIED WITH mysql_native_password BY '新密码';
```

##### 4）删除用户

```sql
DROP USER '用户名'@'主机名';
```

> 注意事项： 在 MySQL 中需要通过`用户名@主机名`的方式，来唯一标识一个用户























## 三、MySQL 基础之 —— 函数

1、字符串函数











2、数值函数













3、日期函数













4、流程函数

















## 四、MySQL 基础之 —— 约束















## 五、MySQL 基础之 —— 多表查询



















## 六、MySQL 基础之 —— 事务















## 七、MySQL 进阶之 —— 存储引擎













## 数据准备

```sql
create table emp(
    id int comment '编号',
    workno varchar(10) comment '工号',
    name varchar(10) comment '姓名',
    gender char(1) comment '性别',
    age tinyint unsigned comment '年龄',
    idcard char(18) comment '身份证号',
    workaddress varchar(50) comment '工作地址',
    entrydate date comment '入职时间'
) comment '员工表';

INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (1, '00001', '柳岩666', '女', 20, '123456789012345678', '北京', '2000-01-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (2, '00002', '张无忌', '男', 18, '123456789012345670', '北京', '2005-09-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (3, '00003', '韦一笑', '男', 38, '123456789712345670', '上海', '2005-08-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (4, '00004', '赵敏', '女', 18, '123456757123845670', '北京', '2009-12-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (5, '00005', '小昭', '女', 16, '123456769012345678', '上海', '2007-07-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (6, '00006', '杨逍', '男', 28, '12345678931234567X', '北京', '2006-01-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (7, '00007', '范瑶', '男', 40, '123456789212345670', '北京', '2005-05-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (8, '00008', '黛绮丝', '女', 38, '123456157123645670', '天津', '2015-05-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (9, '00009', '范凉凉', '女', 45, '123156789012345678', '北京', '2010-04-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (10, '00010', '陈友谅', '男', 53, '123456789012345670', '上海', '2011-01-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (11, '00011', '张士诚', '男', 55, '123567897123465670', '江苏', '2015-05-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (12, '00012', '常遇春', '男', 32, '123446757152345670', '北京', '2004-02-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (13, '00013', '张三丰', '男', 88, '123656789012345678', '江苏', '2020-11-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (14, '00014', '灭绝', '女', 65, '123456719012345670', '西安', '2019-05-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (15, '00015', '胡青牛', '男', 70, '12345674971234567X', '西安', '2018-04-01');
INSERT INTO emp (id, workno, name, gender, age, idcard, workaddress, entrydate)
VALUES (16, '00016', '周芷若', '女', 18, null, '北京', '2012-06-01');
```

