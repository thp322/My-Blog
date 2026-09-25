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

  > 在 MySQL 中需要通过 Host 和 User 来唯一标识一个用户

##### 2）创建用户

```sql
CREATE USER '用户名'@'主机名' IDENTIFIED BY '密码';
```

##### 案例：

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

> 注意事项： 
>
> - 在 MySQL 中需要通过`用户名@主机名`的方式，来唯一标识一个用户
> - 主机名可以使用 % 通配
> - 这类 SQL 开发人员操作的比较少，主要是DBA（Database Administrator 数据库管理员）使用

#### （2）权限控制

MySQL中定义了很多种权限，但是常用的就以下几种：

| 权限                | 说明               |
| ------------------- | ------------------ |
| ALL, ALL PRIVILEGES | 所有权限           |
| SELECT              | 查询数据           |
| INSERT              | 插入数据           |
| UPDATE              | 修改数据           |
| DELETE              | 删除数据           |
| ALTER               | 修改表             |
| DROP                | 删除数据库/表/视图 |
| CREATE              | 创建数据库/表      |

上述只是简单罗列了常见的几种权限描述，其他权限描述及含义，可以直接参考官方文档

```sql
-- 1). 查询权限
SHOW GRANTS FOR '用户名'@'主机名';

-- 2). 授予权限
GRANT 权限列表 ON 数据库名.表名 TO '用户名'@'主机名';

-- 3). 撤销权限
REVOKE 权限列表 ON 数据库名.表名 FROM '用户名'@'主机名';
```

##### 注意事项

- 多个权限之间，使用逗号分隔
- 授权时，数据库名和表名可以使用 `*` 进行通配，代表所有

##### 案例：

```sql
-- A. 查询 'harper'@'%' 用户的权限
show grants for 'harper'@'%';

-- B. 授予 'harper'@'%' 用户 itcast 数据库所有表的所有操作权限
grant all on itcast.* to 'harper'@'%';

-- C. 撤销 'harper'@'%' 用户的itcast数据库的所有权限
revoke all on itcast.* from 'harper'@'%';
```

## 三、MySQL 基础之 —— 函数

函数是指一段可以直接被另一段程序调用的程序或代码。也就意味着，这一段程序或代码在 MySQL 中已经给我们提供了，我们要做的就是在合适的业务场景调用对应的函数完成对应的业务需求即可

MySQL 中的函数主要分为以下四类：

- 字符串函数
- 数值函数
- 日期函数
- 流程函数

### 1、字符串函数

MySQL中内置了很多字符串函数，常用的几个如下：

| 函数                     | 功能                                                         |
| ------------------------ | ------------------------------------------------------------ |
| CONCAT(s1,s2,…Sn)        | 字符串拼接，将 s1，s2，… Sn 拼接成一个字符串                 |
| LOWER(str)               | 将字符串 str 全部转为小写                                    |
| UPPER(str)               | 将字符串 str 全部转为大写                                    |
| LPAD(str,n,pad)          | 左填充，用字符串 pad 对 str 的左边进行填充，达到 n 个字符串长度 |
| RPAD(str,n,pad)          | 右填充，用字符串 pad 对 str 的右边进行填充，达到 n 个字符串长度 |
| TRIM(str)                | 去掉字符串头部和尾部的空格                                   |
| SUBSTRING(str,start,len) | 返回从字符串 str 从 start 位置起的 len 个长度的字符串        |

##### 案例 1：

```sql
-- A. concat：字符串拼接
select concat('Hello', ' MySQL');

-- B. lower：全部转小写
select lower('Hello');

-- C. upper：全部转大写
select upper('Hello');

-- D. lpad：左填充
select lpad('01', 5, '-');

-- E. rpad：右填充
select rpad('01', 5, '-');

-- F. trim：去除空格
select trim(' Hello MySQL ');

-- G. substring：截取子字符串
select substring('Hello MySQL',1,5);
```

##### 案例 2：

由于业务需求变更，企业员工的工号，统一为 5 位数，目前不足 5 位数的全部在前面补 0

```sql
update emp set workno = lpad(workno, 5, '0');
```

### 2、数值函数

常见的数值函数如下：

| 函数       | 功能                                   |
| ---------- | -------------------------------------- |
| CEIL(x)    | 向上取整                               |
| FLOOR(x)   | 向下取整                               |
| MOD(x,y)   | 返回 x / y 的模                        |
| RAND()     | 返回 0~1内的随机数                     |
| ROUND(x,y) | 求参数 x 的四舍五入的值，保留 y 位小数 |

##### 案例 1：

```sql
-- A. ceil：向上取整
select ceil(1.1);

-- B. floor：向下取整
select floor(1.9);

-- C. mod：取模
select mod(7,4);

-- D. rand：获取随机数
select rand();

-- E. round：四舍五入
select round(2.344,2);
```

##### 案例 2：

通过数据库的函数，生成一个六位数的随机验证码

思路：获取随机数可以通过 rand() 函数，但是获取出来的随机数是在 0~1 之间的，所以可以在其基础上乘以1000000，然后舍弃小数部分，如果长度不足 6 位，补 0

```sql
select lpad(round(rand()*1000000 , 0), 6, '0');
```

### 3、日期函数

常见的日期函数如下：

| 函数                               | 功能                                                |
| ---------------------------------- | --------------------------------------------------- |
| CURDATE()                          | 返回当前日期                                        |
| CURTIME()                          | 返回当前时间                                        |
| NOW()                              | 返回当前日期和时间                                  |
| YEAR(date)                         | 获取指定 date 的年份                                |
| MONTH(date)                        | 获取指定 date 的月份                                |
| DAY(date)                          | 获取指定 date 的日期                                |
| DATE_ADD(date, INTERVAL expr type) | 返回一个日期/时间值加上一个时间间隔 expr 后的时间值 |
| DATEDIFF(date1,date2)              | 返回起始时间 date1 和 结束时间 date2 之间的天数     |

##### 案例 1：

```sql
-- A. curdate: 当前日期
select curdate();

-- B. curtime: 当前时间
select curtime();

-- C. now: 当前日期和时间
select now();

-- D. YEAR , MONTH , DAY：当前年、月、日
select YEAR(now());
select MONTH(now());
select DAY(now());

-- E. date_add: 增加指定的时间间隔
select date_add(now(), INTERVAL 70 YEAR );

-- F. datediff: 获取两个日期相差的天数
select datediff('2021-10-01', '2021-12-01');
```

##### 案例 2：

查询所有员工的入职天数，并根据入职天数倒序排序

思路：入职天数，就是通过当前日期 - 入职日期，所以需要使用 datediff 函数来完成

```sql
select name, datediff(curdate(), entrydate) as 'entrydays' from emp order by entrydays desc;
```

### 4、流程函数

流程函数也是很常用的一类函数，可以在 SQL 语句中实现条件筛选，从而提高语句的效率

| 函数                                                         | 功能                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| IF(value , t , f)                                            | 如果 value 为 true，则返回 t，否则返回 f                     |
| IFNULL(value1 , value2)                                      | 如果 value1 不为空，返回 value1，否则返回 value2             |
| CASE WHEN [ val1 ] THEN [res1] ... ELSE [ default ] END      | 如果 val1 为 true，返回 res1，… 否则返回 default 默认值      |
| CASE [ expr ] WHEN [ val1 ] THEN [res1] ... ELSE [ default ] END | 如果 expr 的值等于 val1，返回 res1，… 否则返回 default 默认值 |

##### 案例 1：

```sql
-- A. if
select if(false, 'Ok', 'Error');

-- B. ifnull
select ifnull('Ok','Default');
select ifnull('','Default');
select ifnull(null,'Default');

-- C. case when then else end
-- 需求：查询 emp 表的员工姓名和工作地址（北京/上海 ----> 一线城市，其他 ----> 二线城市）
select
    name,
    case workaddress when '北京' then '一线城市' when '上海' then '一线城市' else '二线城市' end as '工作地址'
from emp;
```

##### 案例 2：

```sql
create table score(
    id int comment 'ID',
    name varchar(20) comment '姓名',
    math int comment '数学',
    english int comment '英语',
    chinese int comment '语文'
) comment '学员成绩表';

insert into score(id, name, math, english, chinese) VALUES (1, 'Tom', 67, 88, 95 ), (2, 'Rose' , 23, 66, 90),(3, 'Jack', 56, 98, 76);
```

```sql
select
    id,
    name,
    (case when math >= 85 then '优秀' when math >=60 then '及格' else '不及格' end ) '数学',
    (case when english >= 85 then '优秀' when english >=60 then '及格' else '不及格' end ) '英语',
    (case when chinese >= 85 then '优秀' when chinese >=60 then '及格' else '不及格' end ) '语文'
from score;
```

## 四、MySQL 基础之 —— 约束

### 1、约束概述

约束是作用于表中字段上的规则，用于限制存储在表中的数据

目的：保证数据库中数据的正确、有效性和完整性

| 约束                       | 描述                                                     | 关键字      |
| -------------------------- | -------------------------------------------------------- | ----------- |
| 非空约束                   | 限制该字段的数据不能为 null                              | NOT NULL    |
| 唯一约束                   | 保证该字段的所有数据都是唯一、不重复的                   | UNIQUE      |
| 主键约束                   | 主键是一行数据的唯一标识，要求非空且唯一                 | PRIMARY KEY |
| 默认约束                   | 保存数据时，如果未指定该字段的值，则采用默认值           | DEFAULT     |
| 检查约束（8.0.16版本之后） | 保证字段值满足某一个条件                                 | CHECK       |
| 外键约束                   | 用来让两张表的数据之间建立连接，保证数据的一致性和完整性 | FOREIGN KEY |

> 注意：约束是作用于表中字段上的，可以在创建表 / 修改表的时候添加约束

### 2、约束案例

案例需求：根据需求，完成表结构的创建

| 字段名 | 字段含义    | 字段类型    | 约束条件                   | 约束关键字                  |
| ------ | ----------- | ----------- | -------------------------- | --------------------------- |
| id     | ID 唯一标识 | int         | 主键，并且自动增长         | PRIMARY KEY, AUTO_INCREMENT |
| name   | 姓名        | varchar(10) | 不为空，并且唯一           | NOT NULL , UNIQUE           |
| age    | 年龄        | int         | 大于 0，并且小于等于 120   | CHECK                       |
| status | 状态        | char(1)     | 如果没有指定该值，默认为 1 | DEFAULT                     |
| gender | 性别        | char(1)     | 无                         |                             |

对应的建表语句：

```sql
CREATE TABLE tb_user(
    id int AUTO_INCREMENT PRIMARY KEY COMMENT 'ID 唯一标识',
    name varchar(10) NOT NULL UNIQUE COMMENT '姓名',
    age int check (age > 0 && age <= 120) COMMENT '年龄',
    status char(1) default '1' COMMENT '状态',
    gender char(1) COMMENT '性别'
);
```

在为字段添加约束时，我们只需要在字段之后加上约束的关键字即可，需要关注其语法

```sql
insert into tb_user(name,age,status,gender) values ('Tom1',19,'1','男'),('Tom2',25,'0','男');
insert into tb_user(name,age,status,gender) values ('Tom3',19,'1','男');
insert into tb_user(name,age,status,gender) values (null,19,'1','男');
insert into tb_user(name,age,status,gender) values ('Tom3',19,'1','男');
insert into tb_user(name,age,status,gender) values ('Tom4',80,'1','男');
insert into tb_user(name,age,status,gender) values ('Tom5',-1,'1','男');
insert into tb_user(name,age,status,gender) values ('Tom5',121,'1','男');
insert into tb_user(name,age,gender) values ('Tom5',120,'男');
```

通过图形化界面来创建表结构时选择约束：

![10](/images/mysql/10.png)

### 3、外键约束

#### （1）介绍

外键：用来让两张表的数据之间建立连接，从而保证数据的一致性和完整性

![11](/images/mysql/11.png)

上图中，emp 表的 dept_id 就是外键，关联的是另一张表的主键，也可以称“主表 - 从表”

> 注意：
>
> 目前上述两张表，只是在逻辑上存在这样一层关系，在数据库层面，并未建立外键关联，所以是无法保证数据的一致性和完整性的

没有数据库外键关联的情况下，能够保证一致性和完整性呢，我们来测试一下

#### （2）语法

##### 1）添加外键

建表时添加外键语法：

```sql
CREATE TABLE 表名(
    字段名  数据类型,
    ...
    [CONSTRAINT] [外键名称] FOREIGN KEY (外键字段名) REFERENCES 主表 (主表列名)
);
```

已有表添加外键语法：

```sql
ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY (外键字段名) REFERENCES 主表 (主表列名);
```

案例：

为 emp 表的 dept_id 字段添加外键约束，关联 dept 表的主键 id

```sql
alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id);
```

添加了外键约束之后，我们在 dept 表（父表）删除 id 为 1 的记录，此时将会报错，不能删除或更新父表记录，因为存在外键约束

##### 2）删除外键

语法：

```sql
ALTER TABLE 表名 DROP FOREIGN KEY 外键名称;
```

案例：

删除 emp 表的外键 `fk_emp_dept_id`

```sql
alter table emp drop foreign key fk_emp_dept_id;
```

#### （3）外键删除 / 更新行为

添加了外键之后，再删除父表数据时产生的约束行为，我们就称为删除 / 更新行为。具体的删除 / 更新行为有以下几种：

| 行为        | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| NO ACTION   | 当在父表中删除 / 更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除 / 更新（与 RESTRICT 一致）默认行为 |
| RESTRICT    | 当在父表中删除 / 更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除 / 更新（与 NO ACTION 一致）默认行为 |
| CASCADE     | 当在父表中删除 / 更新对应记录时，首先检查该记录是否有对应外键，如果有，则也删除 / 更新外键在子表中的记录 |
| SET NULL    | 当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则设置子表中该外键值为 null（这就要求该外键允许取 null） |
| SET DEFAULT | 父表有变更时，子表将外键列设置成一个默认的值（Innodb 不支持） |

具体语法：

```sql
ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY (外键字段) REFERENCES 主表名 (主表字段名) ON UPDATE CASCADE ON DELETE CASCADE;
```

##### 1）CASCADE

```sql
alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id) on update cascade on delete cascade ;
```

A．修改父表 id 为 1的记录，将 id 修改为 6 我们发现，原来在子表中 dept_id 值为 1 的记录，现在也变为 6 了，这就是 cascade 级联的效果

> 在一般的业务系统中，不会修改一张表的主键值

B．删除父表 id 为 6 的记录，我们发现父表的数据删除成功了，但是子表中关联的记录也被级联删除了

##### 2）SET NULL

```sql
alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id) on update set null on delete set null ;
```

我们发现父表的记录是可以正常的删除的，父表的数据删除之后，再打开子表 emp，我们发现子表原来 dept_id为 1 的数据，现在都被置为 NULL 了

## 五、MySQL 基础之 —— 多表查询

### 1、多表关系

项目开发中，在进行数据库表结构设计时，会根据业务需求及业务模块之间的关系，分析并设计表结构，由于业务之间相互关联，所以各个表结构之间也存在着各种联系，基本上分为三种：

- 一对多（多对一）
- 多对多
- 一对一

#### （1） 一对多

- 案例：部门与员工的关系
- 关系：一个部门对应多个员工，一个员工对应一个部门
- 实现：在多的一方建立外键，指向一的一方的主键

> 员工表（emp）N端，部门表（dept） 1端，员工表 dept_id 外键关联部门表主键 id

#### （2）多对多

- 案例：学生与课程的关系
- 关系：一个学生可以选修多门课程，一门课程也可以供多个学生选择
- 实现：建立第三张中间表，中间表至少包含两个外键，分别关联两方主键

> 学生表（student） N端，课程表（course） N端，中间表 student_course，studentid 关联学生 id，courseid 关联课程 id

```sql
create table student(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    no varchar(10) comment '学号'
) comment '学生表';

insert into student values (null, '黛绮丝', '2000100101'),(null, '谢逊','2000100102'),(null, '殷天正', '2000100103'),(null, '韦一笑', '2000100104');

create table course(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '课程名称'
) comment '课程表';

insert into course values (null, 'Java'), (null, 'PHP'), (null , 'MySQL') , (null, 'Hadoop');

create table student_course(
    id int auto_increment comment '主键' primary key,
    studentid int not null comment '学生ID',
    courseid int not null comment '课程ID',
    constraint fk_courseid foreign key (courseid) references course (id),
    constraint fk_studentid foreign key (studentid) references student (id)
) comment '学生课程中间表';

insert into student_course values (null,1,1),(null,1,2),(null,1,3),(null,2,2),(null,2,3),(null,3,4);
```

![12](/images/mysql/12.png)

#### （3）一对一

- 案例：用户与用户详情的关系
- 关系：一对一关系，多用于单表拆分，将一张表的基础字段放在一张表中，其他详情字段放在另一张表中，以提升操作效率
- 实现：在任意一方加入外键，关联另外一方的主键，并且设置外键为唯一的（UNIQUE）

> - 用户基本信息表（tb_user）：存储用户基础信息
> - 用户教育信息表（tb_user_edu）：存储用户详情，userid 为外键且加唯一约束，关联 tb_user 的 id

```sql
create table tb_user(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    age int comment '年龄',
    gender char(1) comment '1: 男 , 2: 女',
    phone char(11) comment '手机号'
) comment '用户基本信息表';

create table tb_user_edu(
    id int auto_increment primary key comment '主键ID',
    degree varchar(20) comment '学历',
    major varchar(50) comment '专业',
    primaryschool varchar(50) comment '小学',
    middleschool varchar(50) comment '中学',
    university varchar(50) comment '大学',
    userid int unique comment '用户ID',
    constraint fk_userid foreign key (userid) references tb_user(id)
) comment '用户教育信息表';

insert into tb_user(id, name, age, gender, phone) values
    (null,'黄渤',45,'1','18800001111'),
    (null,'冰冰',35,'2','18800002222'),
    (null,'码云',55,'1','18800008888'),
    (null,'李彦宏',50,'1','18800009999');

insert into tb_user_edu(id, degree, major, primaryschool, middleschool, university, userid) values
    (null,'本科','舞蹈','静安区第一小学','静安区第一中学','北京舞蹈学院',1),
    (null,'硕士','表演','朝阳区第一小学','朝阳区第一中学','北京电影学院',2),
    (null,'本科','英语','杭州市第一小学','杭州市第一中学','杭州师范大学',3),
    (null,'本科','应用数学','阳泉第一小学','阳泉区第一中学','清华大学',4);
```

### 2、多表查询介绍

#### （1）概述

多表查询就是指从多张表中查询数据

原来查询单表数据，执行的SQL形式为：

```sql
select * from emp;
```

那么我们要执行多表查询，就只需要使用逗号分隔多张表即可，如：

```sql
select * from emp , dept;
```

此时，我们看到查询结果中包含了大量的结果集，总共 102 条记录，而这其实就是员工表 emp 所有的记录（17）与部门表dept所有记录（6）的所有组合情况，这种现象称之为笛卡尔积

笛卡尔积：笛卡尔积是指在数学中，两个集合 A 集合 和 B 集合的所有组合情况

> 注意：多表查询必须添加条件消除笛卡尔积，否则会产生大量无效数据

![13](/images/mysql/13.png)

而在多表查询中，我们是需要消除无效的笛卡尔积的，只保留两张表关联部分的数据

![14](/images/mysql/14.png)

```sql
select * from emp , dept where emp.dept_id = dept.id;
```

#### （2）分类

1. 连接查询
   - 内连接：相当于查询A、B交集部分数据
   - 外连接
     - 左外连接：查询左表所有数据，以及两张表交集部分数据
     - 右外连接：查询右表所有数据，以及两张表交集部分数据
     - 自连接：当前表与自身的连接查询，自连接必须使用表别名
2. 子查询

### 3、内连接

内连接查询的是两张表交集部分的数据

![15](/images/mysql/15.png)

内连接的语法分为两种：

- 隐式内连接
- 显式内连接

#### （1）隐式内连接

```sql
SELECT 字段列表 FROM 表1 , 表2 WHERE 条件 ... ;
```

#### （2）显式内连接

```sql
SELECT 字段列表 FROM 表1 [ INNER ] JOIN 表2 ON 连接条件 ... ;
```

#### （3）案例

A. 查询每一个员工的姓名，及关联的部门的名称（隐式内连接实现） ：

```sql
select emp.name , dept.name from emp , dept where emp.dept_id = dept.id ;

-- 为每一张表起别名，简化SQL编写
select e.name,d.name from emp e , dept d where e.dept_id = d.id;
```

B. 查询每一个员工的姓名，及关联的部门的名称（显式内连接实现） 

```sql
select e.name, d.name from emp e inner join dept d on e.dept_id = d.id;

-- 为每一张表起别名，简化SQL编写
select e.name, d.name from emp e join dept d on e.dept_id = d.id;
```

表的别名：

1. `tablea as 别名 1 , tableb as 别名 2 ;`
2. `tablea 别名 1 , tableb 别名 2 ;`
3. 一旦为表起了别名，就不能再使用表名来指定对应的字段了，此时只能够使用别名来指定字段

### 4、外连接

外连接分为两种，分别是：左外连接 和 右外连接

#### （1）左外连接

```sql
SELECT 字段列表 FROM 表1 LEFT [ OUTER ] JOIN 表2 ON 条件 ... ;
```

左外连接相当于查询表1（左表）的所有数据，当然也包含表 1 和表 2 交集部分的数据

#### （2）右外连接

```sql
SELECT 字段列表 FROM 表1 RIGHT [ OUTER ] JOIN 表2 ON 条件 ... ;
```

右外连接相当于查询表 2（右表）的所有数据，当然也包含表 1 和表 2 交集部分的数据

#### （3）案例

A. 查询 emp 表的所有数据，和对应的部门信息 

由于要查询 emp 的所有数据，所以是不能内连接查询的，需要考虑使用外连接查询（左外连接） 

```sql
select e.*, d.name from emp e left outer join dept d on e.dept_id = d.id;

select e.*, d.name from emp e left join dept d on e.dept_id = d.id;
```

B. 查询 dept 表的所有数据，和对应的员工信息（右外连接） 

```sql
select d.*, e.* from emp e right outer join dept d on e.dept_id = d.id;

select d.*, e.* from dept d left outer join emp e on e.dept_id = d.id;
```

#### （4）注意事项

左外连接和右外连接是可以相互替换的，只需要调整在连接查询时 SQL 中，表结构的先后顺序就可以了。而我们在日常开发使用时，更偏向于左外连接

### 5、自连接

#### （1）自连接查询

自连接查询，顾名思义，就是自己连接自己，也就是把一张表连接查询多次

自连接语法：

```sql
SELECT 字段列表 FROM 表A 别名A JOIN 表A 别名B ON 条件 ... ;
```

自连接查询，可以是内连接查询，也可以是外连接查询

##### 案例

A. 查询员工 及其所属领导的名字

```sql
select a.name , b.name from emp a , emp b where a.managerid = b.id;
```

B. 查询所有员工 emp 及其领导的名字 emp，如果员工没有领导，也需要查询出来

```sql
select a.name '员工', b.name '领导' from emp a left join emp b on a.managerid = b.id;
```

##### 注意事项

在自连接查询中，必须要为表起别名，要不然我们不清楚所指定的条件、返回的字段，到底是哪一张表的字段

#### （2）UNION 联合查询

对于 union 查询，就是把多次查询的结果合并起来，形成一个新的查询结果集

```sql
SELECT 字段列表 FROM 表 A ...
UNION [ ALL ]
SELECT 字段列表 FROM 表 B ...;
```

- 联合查询的多张表的**列数必须保持一致，字段类型也需要保持一致**
- `union all`：将全部的数据直接合并在一起，**不去重**
- `union`：会对合并之后的数据**自动去重**

##### 案例

A. 将薪资低于 5000 的员工，和年龄大于 50 岁的员工全部查询出来

该需求也可以用 `or` 多条件查询实现，这里演示 union all

```sql
select * from emp where salary < 5000
union all
select * from emp where age > 50;
```

union all 查询出来的结果，仅仅进行简单的合并，并未去重，如果改成 `union`，重复记录只会保留一条：

```sql
select * from emp where salary < 5000
union
select * from emp where age > 50;
```

### 6、子查询

#### （1）概述

##### 1）概念

SQL语句中嵌套SELECT语句，称为嵌套查询，又称子查询

```sql
SELECT * FROM t1 WHERE column1 = ( SELECT column1 FROM t2 );
```

子查询外部的语句可以是 `INSERT / UPDATE / DELETE / SELECT` 的任何一个

##### 2）分类

1. 根据子查询结果不同，分为：
   - A. 标量子查询（子查询结果为单个值）
   - B. 列子查询（子查询结果为一列）
   - C. 行子查询（子查询结果为一行）
   - D. 表子查询（子查询结果为多行多列）
2. 根据子查询位置，分为：

- A. WHERE 之后
- B. FROM 之后
- C. SELECT 之后 

#### （2）标量子查询

子查询返回的结果是单个值（数字、字符串、日期等），最简单的形式，这种子查询称为标量子查询

常用的操作符：`=`  `<>`  `>`  `>=`  `<`  `<=`

##### 案例

A. 查询 "销售部" 的所有员工信息 

完成这个需求时，我们可以将需求分解为两步： 

① 查询 "销售部" 部门ID

```sql
select id from dept where name = '销售部';
```

② 根据 "销售部" 部门ID，查询员工信息

```sql
select * from emp where dept_id = (select id from dept where name = '销售部');
```

B. 查询在 "方东白" 入职之后的员工信息 

完成这个需求时，我们可以将需求分解为两步： 

① 查询 "方东白" 的入职日期

```sql
select entrydate from emp where name = '方东白';
```

② 查询指定入职日期之后入职的员工信息

```sql
select * from emp where entrydate > (select entrydate from emp where name = '方东白');
```

#### （3）列子查询

子查询返回的结果是一列（可以是多行），这种子查询称为列子查询

常用的操作符：`IN`、`NOT IN`、`ANY`、`SOME`、`ALL`

| 操作符 | 描述                                        |
| ------ | ------------------------------------------- |
| IN     | 在指定的集合范围之内，多选一                |
| NOT IN | 不在指定的集合范围之内                      |
| ANY    | 子查询返回列表中，有任意一个满足即可        |
| SOME   | 与 ANY 等同，使用 SOME 的地方都可以使用 ANY |
| ALL    | 子查询返回列表的所有值都必须满足            |

##### 案例

A. 查询 "销售部" 和 "市场部" 的所有员工信息 

分解为以下两步：

 ① 查询 "销售部" 和 "市场部" 的部门 ID

```sql
select id from dept where name = '销售部' or name = '市场部';
```

② 根据部门 ID，查询员工信息

```sql
select * from emp where dept_id in (select id from dept where name = '销售部' or name = '市场部');
```

B. 查询比 "财务部" 所有人工资都高的员工信息 

分解为以下两步： 

① 查询所有 "财务部" 人员工资

```sql
select id from dept where name = '财务部';
select salary from emp where dept_id = (select id from dept where name = '财务部');
```

② 比财务部所有人工资都高的员工信息

```sql
select * from emp where salary > all (select salary from emp where dept_id = (select id from dept where name = '财务部'));
```

C. 查询比研发部其中任意一人工资高的员工信息 

分解为以下两步： 

① 查询研发部所有人工资

```sql
select salary from emp where dept_id = (select id from dept where name = '研发部');
```

② 比研发部其中任意一人工资高的员工信息

```sql
select * from emp where salary > any (select salary from emp where dept_id = (select id from dept where name = '研发部'))
```

#### （4）行子查询

子查询返回的结果是一行（可以是多列），这种子查询称为行子查询

常用的操作符：`=`、`<>`、`IN`、`NOT IN`

##### 案例

A. 查询与 "张无忌" 的薪资及直属领导相同的员工信息

拆解为两步进行： 

① 查询 "张无忌" 的薪资及直属领导

```sql
select salary, managerid from emp where name = '张无忌';
```

② 查询与 "张无忌" 的薪资及直属领导相同的员工信息；

```sql
select * from emp where (salary,managerid) = (select salary, managerid from emp where name = '张无忌');
```

#### （5）表子查询

子查询返回的结果是多行多列，这种子查询称为表子查询

常用的操作符：`IN`

##### 案例

A. 查询与 "鹿杖客"，"宋远桥" 的职位和薪资相同的员工信息 

分解为两步执行： 

① 查询 "鹿杖客"，"宋远桥" 的职位和薪资

```sql
select job, salary from emp where name = '鹿杖客' or name = '宋远桥';
```

② 查询与 "鹿杖客"，"宋远桥" 的职位和薪资相同的员工信息

```sql
select * from emp where (job,salary) in ( select job, salary from emp where name = '鹿杖客' or name = '宋远桥' );
```

B. 查询入职日期是 "2006-01-01" 之后的员工信息，及其部门信息 

分解为两步执行：

① 入职日期是 "2006-01-01" 之后的员工信息

```sql
select * from emp where entrydate > '2006-01-01';
```

② 查询这部分员工，对应的部门信息；

```sql
select e.*, d.* from (select * from emp where entrydate > '2006-01-01') e left join dept d on e.dept_id = d.id ;
```

### 7、多表查询案例

#### 数据准备

```sql
create table salgrade(
    grade int,
    losal int,
    hisal int
) comment '薪资等级表';

insert into salgrade values (1,0,3000);
insert into salgrade values (2,3001,5000);
insert into salgrade values (3,5001,8000);
insert into salgrade values (4,8001,10000);
insert into salgrade values (5,10001,15000);
insert into salgrade values (6,15001,20000);
insert into salgrade values (7,20001,25000);
insert into salgrade values (8,25001,30000);
```

案例涉及三张表：

- `emp`员工表
- `dept`部门表
- `salgrade`薪资等级表

#### （1）查询员工的姓名、年龄、职位、部门信息（隐式内连接）

```sql
select e.name , e.age , e.job , d.name from emp e , dept d where e.dept_id = d.id;
```

#### （2）查询年龄小于30岁的员工的姓名、年龄、职位、部门信息（显式内连接）

```sql
select e.name , e.age , e.job , d.name from emp e inner join dept d on e.dept_id = d.id where e.age < 30;
```

#### （3）查询拥有员工的部门ID、部门名称

```sql
select distinct d.id , d.name from emp e , dept d where e.dept_id = d.id;
```

#### （4）查询所有年龄大于40岁的员工，及其归属的部门名称；如果员工没有分配部门，也需要展示出来（外连接）

```sql
select e.*, d.name from emp e left join dept d on e.dept_id = d.id where e.age > 40 ;
```

#### （5）查询所有员工的工资等级

```sql
-- 方式一
select e.* , s.grade , s.losal, s.hisal from emp e , salgrade s where e.salary >= s.losal and e.salary <= s.hisal;
-- 方式二
select e.* , s.grade , s.losal, s.hisal from emp e , salgrade s where e.salary between s.losal and s.hisal;
```

#### （6）查询 "研发部" 所有员工的信息及 工资等级

```sql
select e.* , s.grade from emp e , dept d , salgrade s where e.dept_id = d.id and (e.salary between s.losal and s.hisal ) and d.name = '研发部';
```

#### （7）查询 "研发部" 员工的平均工资

```sql
select avg(e.salary) from emp e, dept d where e.dept_id = d.id and d.name = '研发部';
```

#### （8）查询工资比 "灭绝" 高的员工信息。

① 查询 "灭绝" 的薪资

```sql
select salary from emp where name = '灭绝';
```

② 查询比她工资高的员工数据

```sql
select * from emp where salary > ( select salary from emp where name = '灭绝' );
```

#### （9）查询比平均薪资高的员工信息

① 查询员工的平均薪资

```sql
select avg(salary) from emp;
```

② 查询比平均薪资高的员工信息

```sql
select * from emp where salary > ( select avg(salary) from emp );
```

#### （10）查询低于本部门平均工资的员工信息

① 查询指定部门平均薪资

```sql
select avg(e1.salary) from emp e1 where e1.dept_id = 1;
select avg(e1.salary) from emp e1 where e1.dept_id = 2;
```

② 查询低于本部门平均工资的员工信息

```sql
select * from emp e2 where e2.salary < ( select avg(e1.salary) from emp e1 where e1.dept_id = e2.dept_id );
```

#### （11）查询所有的部门信息，并统计部门的员工人数

```sql
select d.id, d.name , ( select count(*) from emp e where e.dept_id = d.id ) '人数' from dept d;
```

#### （12）查询所有学生的选课情况，展示出学生名称，学号，课程名称

```sql
select s.name , s.no , c.name from student s , student_course sc , course c where s.id = sc.studentid and sc.courseid = c.id ;
```

> 备注：以上需求的实现方式可能会很多，SQL写法也有很多，只要能满足我们的需求，查询出符合条件的记录即可

## 六、MySQL 基础之 —— 事务

### 1、事务简介

事务是一组操作的集合，它是一个不可分割的工作单位，事务会把所有的操作作为一个整体一起向系统提交或撤销操作请求，即这些操作要么同时成功，要么同时失败

就比如：张三给李四转账 1000 块钱，张三银行账户的钱减少 1000，而李四银行账户的钱要增加 1000。这一组操作就必须在一个事务的范围内，要么都成功，要么都失败

正常情况：转账这个操作，需要分为三步来完成（查询张三账户余额、张三账户余额 - 1000、李四账户余额  + 1000） ，三步完成之后，张三减少 1000，而李四增加 1000，转账成功

异常情况：转账这个操作，也是分为以下这么三步来完成，在执行第三步是报错了，这样就导致张三减少 1000 块钱，而李四的金额没变，这样就造成了数据的不一致，就出现问题了

为了解决上述的问题，就需要通过数据的事务来完成，我们只需要在业务逻辑执行之前开启事务，执行完毕后提交事务。如果执行过程中报错，则回滚事务，把数据恢复到事务开始之前的状态

- 开启事务（抛异常 → 回滚事务）

  1. 查询张三账户余额

  1. 张三账户余额 - 1000

  1. 李四账户余额 + 1000

- 提交事务

> 注意：默认 MySQL 的事务是自动提交的，也就是说，当执行完一条 DML 语句时，MySQL 会立即隐式的提交事务

### 2、事务操作

#### 数据准备

```sql
drop table if exists account;

create table account(
    id int primary key AUTO_INCREMENT comment 'ID',
    name varchar(10) comment '姓名',
    money double(10,2) comment '余额'
) comment '账户表';

insert into account(name, money) VALUES ('张三',2000), ('李四',2000);
```

#### （1）控制事务方式一

##### 1）查看 / 设置事务提交方式

```sql
SELECT @@autocommit ;   # 查看事务是否自动提交
SET @@autocommit = 0 ;  # 事务设置为手动提交
```

##### 2）提交事务

```sql
COMMIT;
```

##### 3）回滚事务

```sql
ROLLBACK;
```

> 注意：
>
> 上述的这种方式，我们是修改了事务的自动提交行为，把默认的自动提交修改为了手动提交，此时我们执行的 DML 语句都不会提交，需要手动的执行 commit 进行提交

#### （2）控制事务方式二

##### 1）开启事务

```sql
START TRANSACTION 或 BEGIN ;
```

##### 2）提交事务

```sql
COMMIT;
```

##### 3）回滚事务

```sql
ROLLBACK;
```

#### 案例

```sql
-- 开启事务
start transaction

-- 1. 查询张三余额
select * from account where name = '张三';

-- 2. 张三的余额减少 1000
update account set money = money - 1000 where name = '张三';

-- 3. 李四的余额增加 1000
update account set money = money + 1000 where name = '李四';

-- 如果正常执行完毕，则提交事务
commit;

-- 如果执行过程中报错，则回滚事务
rollback;
```

### 3、事务四大特性

- **原子性（Atomicity）**：事务是不可分割的最小操作单元，要么全部成功，要么全部失败
- **一致性（Consistency）**：事务完成时，必须使所有的数据都保持一致状态
- **隔离性（Isolation）**：数据库系统提供的隔离机制，保证事务在不受外部并发操作影响的独立环境下运行
- **持久性（Durability）**：事务一旦提交或回滚，它对数据库中的数据的改变就是永久的

上述就是事务的四大特性，简称 **ACID**

![16](/images/mysql/16.png)

### 4、并发事务问题

1. **脏读**：一个事务读到另外一个事务还没有提交的数据。 比如事务 B 读取到了事务 A 未提交的数据

   ![17](/images/mysql/17.png)

2. **不可重复读**：一个事务先后读取同一条记录，但两次读取的数据不同，称之为不可重复读。事务 A 两次读取同一条记录，但是读取到的数据却是不一样的（事务 B 在中间执行了 update 并提交）

   ![18](/images/mysql/18.png)

3. **幻读**：一个事务按照条件查询数据时，没有对应的数据行，但是在插入数据时，又发现这行数据已经存在，好像出现了“幻影”

   ![19](/images/mysql/19.png)

### 5、事务隔离级别

为了解决并发事务所引发的问题，在数据库中引入了事务隔离级别。主要有以下几种：

| 隔离级别                                     | 脏读 | 不可重复读 | 幻读 |
| -------------------------------------------- | ---- | ---------- | ---- |
| Read uncommitted 读未提交                    | √    | √          | √    |
| Read committed 读已提交                      | ×    | √          | √    |
| Repeatable Read 可重复读（MySQL 的默认级别） | ×    | ×          | √    |
| Serializable 串行化                          | ×    | ×          | ×    |

1）查看事务隔离级别

```sql
SELECT @@TRANSACTION_ISOLATION;
```

2）设置事务隔离级别

```sql
SET [ SESSION | GLOBAL ] TRANSACTION ISOLATION LEVEL { READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE }
```

- SESSION：针对当前会话窗口有效
- GLOBAL：针对所有会话窗口有效

> 注意：
>
> 事务隔离级别越高，数据越安全，但是性能越低，所以我们在设置事务隔离级别的时候需要权衡安全性和性能，一般会用默认级别，不会做修改

## 七、MySQL 进阶之 —— 存储引擎

### 1、MySQL 体系结构

![20](/images/mysql/20.png)

#### （1）连接层（最上层）

负责客户端连接处理：

- 通信：本地 socket、TCP / IP 通信
- 功能：连接管理、授权认证、安全方案、SSL 安全链接
- 线程池：认证通过的客户端分配线程
- 权限校验：验证客户端操作权限

最上层是一些客户端和链接服务，包含本地 sock 通信和大多数基于客户端 / 服务端工具实现的类似于 TCP / IP 的通信。主要完成一些类似于连接处理、授权认证、及相关的安全方案。在该层上引入了线程池的概念，为通过认证安全接入的客户端提供线程。同样在该层上可以实现基于 SSL 的安全链接。服务器也会为安全接入的每个客户端验证它所具有的操作权限

#### （2）服务层（核心层）

MySQL 核心服务功能，是架构最重要一层：

- SQL 接口接收 SQL 语句
- 包含：查询缓存、SQL 解析、SQL 优化、内置函数执行
- 存储引擎相关：过程、函数
- 执行流程：解析 SQL → 生成解析树 → 优化（确定查询顺序、索引选择）→ 生成执行计划
- 查询缓存：`select` 语句优先查缓存，缓存命中直接返回结果，提升大量读操作性能

第二层架构主要完成大多数的核心服务功能，如 SQL 接口，并完成缓存的查询，SQL 的分析和优化，部分内置函数的执行。所有跨存储引擎的功能也在这一层实现，如 过程、函数等。在该层，服务器会解析查询并创建相应的内部解析树，并对其完成相应的优化如确定表的查询的顺序，是否利用索引等，最后生成相应的执行操作。如果是 select 语句，服务器还会查询内部的缓存，如果缓存空间足够大，这样在解决大量读操作的环境中能够很好的提升系统的性能

#### （3）引擎层（存储引擎层）

真正负责**数据存储与提取**：

- 服务器通过 AP I和存储引擎交互
- 插件式架构：可按需选择不同存储引擎（InnoDB、MyISAM 等）
- **索引在这一层实现**

存储引擎层， 存储引擎真正的负责了 MySQL 中数据的存储和提取，服务器通过 API 和存储引擎进行通信。不同的存储引擎具有不同的功能，这样我们可以根据自己的需要，来选取合适的存储引擎。数据库中的索引是在存储引擎层实现的

#### （4） 存储层（数据存储层）

文件系统层面保存各类数据文件：

- 存储内容：redo log、undo log、数据表数据、索引、二进制日志、错误日志、慢查询日志等
- 和存储引擎交互，持久化数据

数据存储层， 主要是将数据 (如: redolog、undolog、数据、索引、二进制日志、错误日志、查询日志、慢查询日志等) 存储在文件系统之上，并完成与存储引擎的交互

#### MySQL 架构特点

插件式存储引擎架构，**查询处理任务 和 数据存储提取相互分离**，业务场景不同可以选用适配的存储引擎

### 2、存储引擎简介

存储引擎是 mysql 数据库的核心，我们也需要在合适的场景选择合适的存储引擎

存储引擎就是存储数据、建立索引、更新/查询数据等技术的实现方式 。存储引擎是基于表的，而不是基于库的，所以存储引擎也可被称为表类型

我们可以在创建表的时候，来指定选择的存储引擎，如果没有指定将自动选择默认的存储引擎

1）建表时指定存储引擎

```sql
CREATE TABLE 表名(
    字段1 字段1类型 [ COMMENT 字段1注释 ],
    ......
    字段n 字段n类型 [COMMENT 字段n注释 ]
) ENGINE = INNODB [ COMMENT 表注释 ] ;
```

2）查询当前数据库支持的存储引擎

```sql
show engines;
```

示例演示： 

A．查询建表语句 --- 默认存储引擎：InnoDB

```sql
show create table account;
CREATE TABLE `account` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(10) DEFAULT NULL COMMENT '姓名',
  `money` double(10,2) DEFAULT NULL COMMENT '余额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='账户表'
```

我们可以看到，创建表时，即使我们没有指定存储疫情，数据库也会自动选择默认的存储引擎

B．创建表 my_myisam，并指定 MyISAM 存储引擎

```sql
create table my_myisam(
    id int,
    name varchar(10)
) engine = MyISAM ;
```

### 3、存储引擎特点

#### （1）InnoDB 

##### 1）介绍

InnoDB 是一种兼顾高可靠性和高性能的通用存储引擎，在 MySQL 5.5 之后，InnoDB 是默认的 MySQL 存储引擎

##### 2）特点

- DML 操作遵循 ACID 模型，支持**事务**
- **行级锁**，提高并发访问性能
- 支持**外键** FOREIGN KEY 约束，保证数据的完整性和正确性

##### 3）文件 

xxx.ibd： xxx 代表的是表名，innoDB 引擎的每张表都会对应这样一个表空间文件，存储该表的表结构（frm-早期的、sdi-新版的）、数据和索引

参数：`innodb_file_per_table`

查看系统变量：

```sql
show variables like 'innodb_file_per_table';
```

| Variable_name         | Value |
| --------------------- | ----- |
| innodb_file_per_table | ON    |

`innodb_file_per_table` 默认打开，也就是说，InnoDB 引擎的每一张表对应一个表空间文件

从 xxx.ibd 文件中提取 sdi 信息：

![21](/images/mysql/21.png)

进入 cmd：

```cmd
ibd2sdi 表名.ibd 
```

sdi 数据字典信息中就包含该表的表结构

##### 4）逻辑存储结构

![22](/images/mysql/22.png)

- 表空间：InnoDB 存储引擎逻辑结构的最高层，ibd 文件其实就是表空间文件，在表空间中可以包含多个 Segment 段
- 段：表空间是由各个段组成的，常见的段有数据段、索引段、回滚段等。InnoDB 中对于段的管理，都是引擎自身完成，不需要人为对其控制，一个段中包含多个区
- 区：区是表空间的单元结构，每个区的大小为 1M。 默认情况下， InnoDB 存储引擎页大小为 16K， 即一个区中一共有 64 个连续的页
- 页：页是组成区的最小单元，页也是 InnoDB 存储引擎磁盘管理的最小单元，每个页的大小默认为 16KB。为了保证页的连续性，InnoDB 存储引擎每次从磁盘申请 4-5 个区
- 行：InnoDB 存储引擎是面向行的，也就是说数据是按行进行存放的，在每一行中除了定义表时所指定的字段以外，还包含两个隐藏字段

### （2）MyISAM 

MyISAM 是 MySQL 早期的默认存储引擎

特点：

- 不支持事务，不支持外键
- 支持表锁，不支持行锁
- 访问速度快

文件：

- xxx.sdi：存储表结构信息，可以直接打开文件查看
- xxx.MYD：存储数据 
- xxx.MYI：存储索引

### （3）Memory 

##### 1）介绍 

Memory 引擎的表数据时存储在内存中的，由于受到硬件问题、或断电问题的影响，只能将这些表作为临时表或缓存使用

##### 2）特点 

- 内存存放，访问速度快
- hash 索引（默认）

##### 3）文件 

xxx.sdi：存储表结构信息

### （4）三种引擎区别

| 特点         | InnoDB            | MyISAM       | Memory |
| ------------ | ----------------- | ------------ | ------ |
| 存储限制     | 64TB              | 有           | 有     |
| 事务安全     | ` 支持`           | `-`          | -      |
| 锁机制       | `支持行锁`        | `只支持表锁` | 表锁   |
| B+tree索引   | 支持              | 支持         | 支持   |
| Hash索引     | -                 | -            | 支持   |
| 全文索引     | 支持(5.6版本之后) | 支持         | -      |
| 空间使用     | 高                | 低           | N/A    |
| 内存使用     | 高                | 低           | 中等   |
| 批量插入速度 | 低                | 高           | 高     |
| 支持外键     | `支持`            | `-`          | -      |

> 面试题： 
>
> InnoDB 引擎与 MyISAM 引擎的区别 ? 
>
> ① InnoDB 引擎，支持事务，而 MyISAM 不支持
>
> ② InnoDB 引擎，支持行锁和表锁，而 MyISAM 仅支持表锁，不支持行锁
>
> ③ InnoDB 引擎，支持外键，而 MyISAM 是不支持的
>
> 主要是上述三点区别，当然也可以从索引结构、存储限制等方面，更加深入的回答，具体参考如下官方文档：
>
>  https://dev.mysql.com/doc/refman/8.0/en/innodb-introduction.html 
>
> https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html

### 4、存储引擎选择

在选择存储引擎时，应该根据应用系统的特点选择合适的存储引擎。对于复杂的应用系统，还可以根据实际情况选择多种存储引擎进行组合

- InnoDB：是 Mysql 的默认存储引擎，支持事务、外键。如果应用对事务的完整性有比较高的要求，在并发条件下要求数据的一致性，数据操作除了插入和查询之外，还包含很多的更新、删除操作，那么 InnoDB 存储引擎是比较合适的选择
- MyISAM：如果应用是以读操作和插入操作为主，只有很少的更新和删除操作，并且对事务的完整性、并发性要求不是很高，那么选择这个存储引擎是非常合适的。如日志、评论等**非业务核心的数据**
- MEMORY：将所有数据保存在内存中，访问速度快，通常用于临时表及**缓存**。MEMORY 的缺陷就是对表的大小有限制，太大的表无法缓存在内存中，而且无法保障数据的安全性

> 补充：
>
> 目前实际业务中，MyISAM 和 MEMORY 已经分别被 MongoDB 和 Redis 数据库替代了

## 八、MySQL 进阶之 —— 索引







## 九、MySQL 进阶之 —— SQL优化









## 十、MySQL 进阶之 —— 视图







## 十一、MySQL 进阶之 —— 存储过程





## 十二、MySQL 进阶之 —— 触发器





## 十三、MySQL 进阶之 —— 锁







## 十四、MySQL 进阶之 —— InnoDB 引擎









## 十五、MySQL 进阶之 —— MySQL 管理











## 十六、MySQL 运维之 —— 日志



















## 十七、MySQL 运维之 —— 主从复制















## 十八、MySQL 运维之 —— 分库分表

















## 十八、MySQL 运维之 —— 读写分离













## 数据准备

### 1、SQL 部分

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

### 2、外键约束部分

```sql
create table dept(
    id int auto_increment comment 'ID' primary key,
    name varchar(50) not null comment '部门名称'
)comment '部门表';

INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'),(3, '财务部'), (4, '销售部'), (5, '总经办');

create table emp(
    id int auto_increment comment 'ID' primary key,
    name varchar(50) not null comment '姓名',
    age int comment '年龄',
    job varchar(20) comment '职位',
    salary int comment '薪资',
    entrydate date comment '入职时间',
    managerid int comment '直属领导 ID',
    dept_id int comment '部门 ID'
)comment '员工表';

INSERT INTO emp (id, name, age, job,salary, entrydate, managerid, dept_id)
VALUES
    (1, '金庸', 66, '总裁',20000, '2000-01-01', null,5),
    (2, '张无忌', 20, '项目经理',12500, '2005-12-05', 1,1),
    (3, '杨逍', 33, '开发', 8400,'2000-11-03', 2,1),
    (4, '韦一笑', 48, '开发',11000, '2002-02-05', 2,1),
    (5, '常遇春', 43, '开发',10500, '2004-09-07', 3,1),
    (6, '小昭', 19, '程序员鼓励师',6600, '2004-10-12', 2,1);
```

### 3、多表查询部分

```sql
create table dept(
    id int auto_increment comment 'ID' primary key,
    name varchar(50) not null comment '部门名称'
)comment '部门表';

INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'), (3, '财务部'), (4, '销售部'), (5, '总经办'), (6, '人事部');

create table emp(
    id int auto_increment comment 'ID' primary key,
    name varchar(50) not null comment '姓名',
    age int comment '年龄',
    job varchar(20) comment '职位',
    salary int comment '薪资',
    entrydate date comment '入职时间',
    managerid int comment '直属领导ID',
    dept_id int comment '部门ID'
)comment '员工表';

alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id);

INSERT INTO emp (id, name, age, job,salary, entrydate, managerid, dept_id) VALUES
    (1, '金庸', 66, '总裁',20000, '2000-01-01', null,5),
    (2, '张无忌', 20, '项目经理',12500, '2005-12-05', 1,1),
    (3, '杨逍', 33, '开发', 8400,'2000-11-03', 2,1),
    (4, '韦一笑', 48, '开发',11000,'2002-02-05', 2,1),
    (5, '常遇春', 43, '开发',10500, '2004-09-07', 3,1),
    (6, '小昭', 19, '程序员鼓励师',6600,'2004-10-12', 2,1),
    (7, '灭绝', 60, '财务总监',8500, '2002-09-12', 1,3),
    (8, '周芷若', 19, '会计',4800,'2006-06-02',7,3),
    (9, '丁敏君', 23, '出纳',5250,'2009-05-13',7,3),
    (10, '赵敏', 20, '市场部总监',12500,'2004-10-12',1,2),
    (11, '鹿杖客', 56, '职员',3750,'2006-10-03',10,2),
    (12, '鹤笔翁', 19, '职员',3750,'2007-05-09',10,2),
    (13, '方东白', 19, '职员',5500,'2009-02-12',10,2),
    (14, '张三丰', 88, '销售总监',14000,'2004-10-12',1,4),
    (15, '俞莲舟', 38, '销售',4600,'2004-10-12',14,4),
    (16, '宋远桥', 40, '销售',4600,'2004-10-12',14,4),
    (17, '陈友谅', 42, null,2000,'2011-10-12',1,null);
```

















