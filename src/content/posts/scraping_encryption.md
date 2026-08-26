---
title: 爬虫常见加密算法原理（持续更新中）
date: 2026-08-26
tags: [爬虫, 算法]
description: 介绍爬虫开发中常见的 SHA-1、AES、RSA、MD5、Base64 和 DES 算法原理及其应用场景。
---

在爬虫开发过程中，我们经常会遇到参数加密、请求签名、密码摘要以及数据编码等问题。网站通常会通过不同的加密或编码算法保护接口参数、用户信息和通信数据。理解这些算法的基本原理，有助于我们分析请求流程、定位参数生成逻辑，并正确区分“加密”、“哈希”和“编码”这几个容易混淆的概念。

需要注意的是，SHA-1 和 MD5 属于哈希算法，Base64 属于编码方式，它们并不是严格意义上的加密算法；AES、RSA 和 DES 才属于用于保护数据机密性的加密算法。

---

## 一、SHA1 算法

### SHA 算法起源

SHA (Security Hash Algorithm) 是美国的 NIST 和 NSA 设计的一种标准的 Hash 算法，SHA 用于数字签名的标准算法的 DSS 中，也是安全性很高的一种 Hash 算法。

是美国国家标准技术研究所发布的国家标准 FIPS PUB 180，最新的标准已经于 2008 年更新到 FIPS PUB 180‑3。其中规定了 SHA‑1，SHA‑224，SHA‑256，SHA‑384，和 SHA‑512 这几种单向散列算法。SHA‑1，SHA‑224 和 SHA‑256 适用于长度不超过 $2^{64}$ 二进制位的消息。SHA‑384 和 SHA‑512 适用于长度不超过 $2^{128}$ 二进制位的消息。

### SHA‑1 算法简介

- 输入：最大的长度为 $(2^{64}-1)$ bit，约等于 2 的 41 次 MB（位）
- 输出：160 位信息摘要
- 处理：输入以 512 位块为单位处理
- 循环次数：对每个分组使用 4 次循环，每次循环 20 步，共 80 步

### SHA-1 算法加密流程

#### 1、消息分割和填充

将明文数据分割为 n 个 512 位明文数据块：

![1](/images/scraping_encryption/1.png)

最后一组数据要求长度为 448 位。

最后剩下 64 位数据，用来记录报文长度位。

补位规则：第一个数据补1，后面全部补0：

![2](/images/scraping_encryption/2.png)

![3](/images/scraping_encryption/3.png)

#### 2、每个 512bit 数据的运算——消息字扩充

将 512 位的数据分为 16 份 32bit 的数据：\( M[0], M[1] …… M[15] \)

扩充：将 16 份 32bit 数据扩充成 80 份 32bit，得到 \( W[0], W[1] …… W[79] \)

扩充公式：
$$
W_t=
\begin{cases}
M_t & 0 \le t \le 15 \\
ROTL^1(W_{t-3}\oplus W_{t-8}\oplus W_{t-14}\oplus W_{t-16}) & 16 \le t \le 79
\end{cases}
$$
![4](/images/scraping_encryption/4.png)

符号简介：

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

准备初始缓存区值（初始哈希向量）

```
H₀⁽⁰⁾ = 67452301
H₁⁽⁰⁾ = efcdab89
H₂⁽⁰⁾ = 98badcfe
H₃⁽⁰⁾ = 10325476
H₄⁽⁰⁾ = c3d2e1f0
```

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

> 执行 80 次循环；`ROTL⁵(a)`：将 a 循环左移 5 位；`ROTL³⁰(b)`：b 循环左移 30 位；核心为 T 值运算。

fₜ (b,c,d) 逻辑函数（随轮数 t 切换）
$$
f_t(b,c,d)=
\begin{cases}
(b \land c)\oplus(\neg b \land d) & 0 \le t \le 19 \\
b\oplus c \oplus d & 20 \le t \le 39 \\
(b\land c)\oplus(b\land d)\oplus(c\land d) & 40 \le t \le 59 \\
b\oplus c \oplus d & 60 \le t \le 79
\end{cases}
$$

> fₜ  (b,c,d) 是非线性运算函数，输入 b、c、d，根据轮数 t 选用不同逻辑。

#### \(K_t\) 固定常量（分四段）

$$
K_t= \begin{cases} 5\text{a}827999 & 0 \le t \le 19 \\ 6\text{ed}9\text{eba}1 & 20 \le t \le 39 \\ 8\text{f}1\text{bbcdc} & 40 \le t \le 59 \\ \text{ca}62\text{c}1\text{d}6 & 60 \le t \le 79 \end{cases}
$$

- $W_{t}$：第二步扩充得到的 80 个 32bit 消息字。

分组结束处理

一轮 512bit 分组的 80 轮运算完成后，把得到的 a,b,c,d,e 和本组初始缓存$H_0^{(i-1)} \sim H_4^{(i-1)}$ 分别做模 $2^{32}$加法，得到新的缓存 $H_0^{(i)} \sim H_4^{(i)}$ ，作为下一个 512bit 分组运算的初始值。

全部分组处理完毕，拼接$H_0H_1H_2H_3H_4$，得到最终 160bit SHA‑1 摘要。

## 二、AES 加密算法



## 三、RSA 非对称加密算法



## 四、MD5 加密算法



## 五、Base64 编码



## 六、DES 加密算法

