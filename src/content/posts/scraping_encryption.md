---
title: 爬虫常见加密算法原理（持续更新中）
date: 2026-08-26
tags: [爬虫, 算法]
description: 介绍爬虫开发中常见的 SHA-1、AES、RSA、MD5、Base64 和 DES 算法原理及其应用场景。
---

在爬虫开发过程中，我们经常会遇到参数加密、请求签名、密码摘要以及数据编码等问题。网站通常会通过不同的加密或编码算法保护接口参数、用户信息和通信数据。理解这些算法的基本原理，有助于我们分析请求流程、定位参数生成逻辑。

需要注意的是，SHA-1 和 MD5 属于哈希算法，Base64 属于编码方式，它们并不是严格意义上的加密算法；AES、RSA 和 DES 才属于用于保护数据机密性的加密算法。

---

## 一、SHA1 算法<sup>[1]</sup>

### SHA 算法起源

SHA (Security Hash Algorithm) 是美国的 NIST 和 NSA 设计的一种标准的 Hash （哈希）算法，SHA 用于数字签名的标准算法的 DSS 中，也是安全性很高的一种 Hash 算法。

是美国国家标准技术研究所发布的国家标准 FIPS PUB 180，最新的标准已经于 2008 年更新到 FIPS PUB 180‑3。其中规定了 SHA‑1，SHA‑224，SHA‑256，SHA‑384，和 SHA‑512 这几种单向散列算法。SHA‑1，SHA‑224 和 SHA‑256 适用于长度不超过 $2^{64}$ 二进制位的消息。SHA‑384 和 SHA‑512 适用于长度不超过 $2^{128}$ 二进制位的消息。

### SHA‑1 算法简介

- 输入：最大的长度为 $(2^{64}-1)$ bit，约等于 2 的 41 次 MB（位）
- 输出：160 位信息摘要
- 处理：输入以 512 位块为单位处理
- 循环次数：对每个分组使用 4 次循环，每次循环 20 步，共 80 步

| 输入内容           | UTF‑8 字节数 | 比特长度 (bit) | 说明                                            |
| ------------------ | ------------ | -------------- | ----------------------------------------------- |
| `“我”`（中文汉字） | 3 字节       | 3×8=24 bit     | UTF‑8 下一个汉字占 3 字节                       |
| `123`（字符串）    | 3 字节       | 3×8=24 bit     | 字符`'1'`、`'2'`、`'3'`，每个 ASCII 字符 1 字节 |
| `“a”`（英文字母）  | 1 字节       | 1×8=8 bit      | 标准 ASCII，1 字节                              |

![2](/images/scraping_encryption/2.png)

### SHA-1 算法加密流程

#### 1、消息分割和填充

将明文数据分割为 n 个 512 位明文数据块，最后一组数据要求长度为 448 位，最后剩下 64 位数据，用来记录报文长度位。

补位规则：第一个数据补1，后面全部补0，直至满足 L mod 512 = 448：

![1](/images/scraping_encryption/1.png)

举个例子：

- 输入：“abc”

- 将输入的字符串转化为 bit 串：01100001 01100010 01100011

- 补位第一步：后面加一位 1 

- 后面补 0 ：加足够位数的 0 

  > 要补多少 0 呢？
  >
  > 字符串“abc”转化成比特位 01100001 01100010 01100011 后一共有24位
  >
  > 最后的 64 位数据需要记录长度，即 000 ······ 00011000  (即 24)
  >
  > 那么还需要补齐 512 - 64（长度位） - 24（原本的的比特位长度） - 1（补的 1 占 1 位） = 423 位


如图所示：

![3](/images/scraping_encryption/3.png)

#### 2、每个 512bit 数据的运算——消息字扩充

![4](/images/scraping_encryption/4.png)

将 512 位的数据分为 16 份 32bit 的数据，用 M[t] 表示：
$$
M[0], M[1] …… M[15]
$$
“扩充”：将 16 份 32bit 数据扩充成 80 份 32bit，得到W[t]：
$$
W[0], W[1] …… W[79]
$$
“扩充”公式：
$$
W_t=
\begin{cases}
M_t & 0 \le t \le 15 \\
ROTL^1(W_{t-3}\oplus W_{t-8}\oplus W_{t-14}\oplus W_{t-16}) & 16 \le t \le 79
\end{cases}
$$
其中符号 $ROTL^{1}$ 表示左移一位，其余符号见下表：

| 符号 | 含义                                            |
| ---- | ----------------------------------------------- |
| ∧    | 按位与 Bitwise AND operation                    |
| ∨    | 按位或 Bitwise OR ("inclusive‑OR") operation    |
| ⊕    | 按位异或 Bitwise XOR ("exclusive‑OR") operation |
| ¬    | 按位取反 Bitwise complement operation           |
| +    | 模 232 加法 Addition modulo 232                 |
| ≪    | 左移 Left‑shift operation                       |
| ≫    | 右移 Right‑shift operation                      |

#### 3、SHA‑1 加密过程——循环压缩运算

将 80 份的明文分组都参与到 80 轮的运算中（4 轮运算，每个运算 20 个步骤）

准备初始缓存区值（初始哈希向量）
$$
H₀⁽⁰⁾ = 67452301 \\
H₁⁽⁰⁾ = efcdab89 \\
H₂⁽⁰⁾ = 98badcfe \\
H₃⁽⁰⁾ = 10325476 \\
H₄⁽⁰⁾ = c3d2e1f0 \\
$$
将缓存赋值给 a,b,c,d,e 五个 32 位变量：
$$
\begin{cases} a = H_0^{(i-1)} \\ b = H_1^{(i-1)} \\ c = H_2^{(i-1)} \\ d = H_3^{(i-1)} \\ e = H_4^{(i-1)} \end{cases}
$$
80 轮迭代循环 `For t = 0 to 79`

```
T = ROTL⁵(a) + f_t(b,c,d) + e + K_t + W_t
e = d
d = c
c = ROTL³⁰(b)
b = a
a = T
```

> 执行 80 次循环
>
> `ROTL⁵(a)`：将 a 循环左移 5 位
>
> `ROTL³⁰(b)`：b 循环左移 30 位
>
> `f_t(b,c,d)`、`K_t`  如下表所示

`fₜ (b,c,d)` 逻辑函数
$$
f_t(b,c,d)=
\begin{cases}
(b \land c)\oplus(\neg b \land d) & 0 \le t \le 19 \\
b\oplus c \oplus d & 20 \le t \le 39 \\
(b\land c)\oplus(b\land d)\oplus(c\land d) & 40 \le t \le 59 \\
b\oplus c \oplus d & 60 \le t \le 79
\end{cases}
$$

`K_t` 固定常量
$$
K_t= \begin{cases} 5\text{a}827999 & 0 \le t \le 19 \\ 6\text{ed}9\text{eba}1 & 20 \le t \le 39 \\ 8\text{f}1\text{bbcdc} & 40 \le t \le 59 \\ \text{ca}62\text{c}1\text{d}6 & 60 \le t \le 79 \end{cases}
$$

分组结束处理

一轮 512bit 分组的 80 轮运算完成后，把得到的 a,b,c,d,e 和本组初始缓存$H_0^{(i-1)} \sim H_4^{(i-1)}$ 分别做模 $2^{32}$ 加法，得到新的缓存 $H_0^{(i)} \sim H_4^{(i)}$ ，作为下一个 512 bit 分组运算的初始值。
$$
\begin{aligned}
H_0^{(i)} &= a + H_0^{(i-1)} \\
H_1^{(i)} &= b + H_1^{(i-1)} \\
H_2^{(i)} &= c + H_2^{(i-1)} \\
H_3^{(i)} &= d + H_3^{(i-1)} \\
H_4^{(i)} &= e + H_4^{(i-1)}
\end{aligned}
$$
全部分组处理完毕后，拼接$H_0H_1H_2H_3H_4$，得到最终 160bit SHA‑1 摘要。

## 二、AES 加密算法



## 三、RSA 非对称加密算法



## 四、MD5 加密算法



## 五、Base64 编码



## 六、DES 加密算法



## 参考资料 / 视频

[FIPS 180-2, Secure Hash Standard (superseded Feb. 25, 2004)](https://csrc.nist.gov/files/pubs/fips/180-2/final/docs/fips180-2.pdf)

[SHA1算法丨 可厉害的土豆 | 哔哩哔哩](https://www.bilibili.com/video/BV1Ua411679P?vd_source=4a65573450fad180901198fa5cc2d849)

