---
title: LeetCode Hot 100 题（持续更新中）
date: 2026-08-28
tags: [LeetCode, 算法题解]
description: 本系列为 Leetcode 力扣热题 100 题讲解合集，每道题提供 Python 语言不同方法的解题代码以及详拆解解题思路，欢迎对照练习
---

## 题目 001：两数之和 [ 简单 ]

[1. 两数之和 - 力扣（LeetCode）](https://leetcode.cn/problems/two-sum/description/)

#哈希

### 题目描述

给定一个整数数组 `nums` 和一个整数目标值 `target`，请你在该数组中找出**和为目标值** *`target`* 的那**两个**整数，并返回它们的数组下标。

你可以假设每种输入只会对应一个答案，并且你不能使用两次相同的元素。

你可以按任意顺序返回答案。

### 示例

**示例 1：**

```
输入：nums = [2,7,11,15], target = 9
输出：[0,1]
解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
```

**示例 2：**

```
输入：nums = [3,2,4], target = 6
输出：[1,2]
```

**示例 3：**

```
输入：nums = [3,3], target = 6
输出：[0,1]
```

### 提示

- `2 <= nums.length <= 104`
- `-109 <= nums[i] <= 109`
- `-109 <= target <= 109`
- **只会存在一个有效答案**

### 解题思路

1. **暴力法**  
   
   - 以 ` nums`  = [2,7,11,15], ` target`  = 9 为例，选定第一个数 2 ，依次判断与后面的数字相加是否等于`target`  ，再选定第二个数，如上执行。
   -  左指针固定，移动右指针，若不满足和为 ` target` 则左指针右移一位。
   
2. **哈希表法**  
   
   - 建立哈希表
   
     | key  | value |
     | :--: | :---: |
     |  15  |   0   |
     |  11  |   1   |
     |  2   |   2   |
     |  7   |   3   |
   
   - 当查第一个数 15 时，用 ` target`  减去 15 ，在表里查是否有 ` target`  - 15 这个数值，此时时间复杂度是O(1)，对比遍历的时间复杂度是 O(n)。

### 代码（Python）

#### 暴力法

```python
class Solution(object):
    def twoSum(self, nums, target):
        n = len(nums)
        for i in range(n):
            for j in range(i+1, n):
                if nums[i] + nums[j] == target:
                    return [i, j]
```

#### 哈希表法

```python
class Solution(object):
    def twoSum(self, nums, target):
        hashmap = {}   # key:数组值，value:对应下标
        for i, num in enumerate(nums):
            need = target - num
            if need in hashmap:
                # 找到，返回之前存的下标和当前下标
                return [hashmap[need], i]
            # 没找到，把当前数存入哈希表
            hashmap[num] = i
```







## 题目 002：字母异位词分组 [ 中等 ]

[49. 字母异位词分组 - 力扣（LeetCode）](https://leetcode.cn/problems/group-anagrams/description/?envType=study-plan-v2&envId=top-100-liked)

#哈希

### 题目描述

给你一个字符串数组，请你将 **字母异位词** 组合在一起。可以按任意顺序返回结果列表。

### 示例

**示例 1:**

**输入:** strs = ["eat", "tea", "tan", "ate", "nat", "bat"]

**输出:** [["bat"],["nat","tan"],["ate","eat","tea"]]

**解释：**

- 在 strs 中没有字符串可以通过重新排列来形成 `"bat"`。
- 字符串 `"nat"` 和 `"tan"` 是字母异位词，因为它们可以重新排列以形成彼此。
- 字符串 `"ate"` ，`"eat"` 和 `"tea"` 是字母异位词，因为它们可以重新排列以形成彼此。

**示例 2:**

**输入:** strs = [""]

**输出:** [[""]]

**示例 3:**

**输入:** strs = ["a"]

**输出:** [["a"]]

### 提示

- `1 <= strs.length <= 104`
- `0 <= strs[i].length <= 100`
- `strs[i]` 仅包含小写字母

### 解题思路

1. **字典排序法**  

   - 分组后的每个单词排序得到的应该是同一数值

   - 建立字典，排序后的值为 key，原来的值为 value

     | key  | value             |
     | ---- | ----------------- |
     | eat  | [ eat，tea，ate ] |
     | ant  | [ tan，nta ]      |
     | abt  | [ abt，tba ]      |

2. **计数哈希法**  

   - 每个单词 a —> z 排序，统计字母出现次数，得到 [ 0，1，0，0，······，0，1 ]，将其作为哈希表的 key
   - 但是数组无法被哈希，需要将其转化成 tuple 元组类型


### 代码（Python）

#### 字典排序法

```python
class Solution(object):
    def groupAnagrams(self, strs):
        if len(strs) < 2:
            return [strs]
        
        result = {}
        for s in strs:
            # sorted("cba") ——> [ 'a', 'b', 'c' ] (列表)
            temp = ''.join(sorted(s))                   # 列表转字符串
            result[temp] = result.get(temp, []) + [s]   # 没有 temp 返回空 list 
        
        return result.values()
```

#### 计数哈希法

```python
class Solution(object):
    def groupAnagrams(self, strs):
        if len(strs) < 2:
            return [strs]
        
        result = {}
        for s in strs:
            count_table = [0]*26
            for c in s:
                count_table[ord(c)-ord('a')] += 1
            key = tuple(count_table)
            result[key] = result.get(key, []) + [s]
            
        return list(result.values())
```







## 题目 003：最长连续序列 [ 中等 ]

[128. 最长连续序列 - 力扣（LeetCode）](https://leetcode.cn/problems/longest-consecutive-sequence/description/?envType=study-plan-v2&envId=top-100-liked)

#哈希

### 题目描述

给定一个未排序的整数数组 `nums` ，找出数字连续的最长序列（不要求序列元素在原数组中连续）的长度。

请你设计并实现时间复杂度为 `O(n)` 的算法解决此问题。

### 示例

**示例 1：**

```
输入：nums = [100,4,200,1,3,2]
输出：4
解释：最长数字连续序列是 [1, 2, 3, 4]。它的长度为 4。
```

**示例 2：**

```
输入：nums = [0,3,7,2,5,8,4,6,0,1]
输出：9
```

**示例 3：**

```
输入：nums = [1,0,1,2]
输出：3
```

### 提示

- `0 <= nums.length <= 105`
- `-109 <= nums[i] <= 109`

### 解题思路

- `x in num_set`：判断存在，**平均 O (1)**，一瞬间完成（set 集合的特性：集合底层是哈希表）

- 把全部数字存入**集合 set**，O (1) 时间判断某个数字是否存在
- 不能直接逐个数字往后遍历（会大量重复计算，变成 O (n²)）
- 只从序列的起点开始算
  - 如果 `x‑1` 不在集合中，说明 `x` 是一段连续序列的开头
  - 然后不断看 `x+1、x+2…` 是否存在，统计这段连续序列长度
  - 如果 `x‑1` 在集合，说明 x 不是起点，直接跳过，不计算
- 更新全局最大长度

> 关键点：每个数字只会被访问一次，整体时间复杂度 O (n)


### 代码（Python）

```python
class Solution(object):
    def longestConsecutive(self, nums):
        max_len = 0
        num_set = set(nums)
        for x in num_set:
            # x-1 不在集合，x 是序列的起点
            if x - 1 not in num_set:
                cur_num = x
                cur_len = 1 
                # 不断往后找连续数字
                while cur_num + 1 in num_set:
                    cur_num += 1
                    cur_len +=1
                max_len = max(max_len, cur_len)
		return max_len
```







## 题目 004：移动零 [ 简单 ]

[283. 移动零 - 力扣（LeetCode）](https://leetcode.cn/problems/move-zeroes/description/?envType=study-plan-v2&envId=top-100-liked)

#双指针

### 题目描述

给定一个数组 `nums`，编写一个函数将所有 `0` 移动到数组的末尾，同时保持非零元素的相对顺序。

**请注意** ，必须在不复制数组的情况下原地对数组进行操作。

### 示例

**示例 1:**

```
输入: nums = [0,1,0,3,12]
输出: [1,3,12,0,0]
```

**示例 2:**

```
输入: nums = [0]
输出: [0]
```

### 提示

- `1 <= nums.length <= 104`
- `-231 <= nums[i] <= 231 - 1`

### 解题思路

**快慢指针法**  

- 左指针与右指针同时指向第一位数
- **左指针 left**：指向应该放置非零数的位置
- **右指针 right**：遍历数组，寻找非零元素
- right 不断向后遍历；遇到非 0 数字，把这个数放到 left 位置；left 右移，right 继续向后遍历


### 代码（Python）

```python
class Solution(object):
    def moveZeroes(self, nums):
        left = 0
        # right 遍历找非零，放到 left 位置
        for right in range(len(nums)):
            if nums[right] != 0:
                nums[ledt] = num[right]
                left += 1
        # left之后全部置0
        for i in range(left, len(nums)):
            nums[i] = 0
```







## 题目 008：无重复字符的最长子串 [ 中等 ]

[3. 无重复字符的最长子串 - 力扣（LeetCode）](https://leetcode.cn/problems/longest-substring-without-repeating-characters/description/)

#滑动窗口

### 题目描述

给定一个字符串 `s` ，请你找出其中不含有重复字符的 **最长 子串** 的长度。

### 示例

**示例 1:**

```
输入: s = "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。注意 "bca" 和 "cab" 也是正确答案。
```

**示例 2:**

```
输入: s = "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
```

**示例 3:**

```
输入: s = "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```

### 提示

- `0 <= s.length <= 105`
- `s` 由英文字母、数字、符号和空格组成

### 解题思路

**双指针-滑动窗口法**  

- 左右指针指向字符串开头，右指针右移，当不满足“不含有重复字符”的条件时右指针保持不动，移除重复的字符，左指针右移，直到满足条件
- 随着指针移动，将字符依次记录在 set 表中
- length 为当前长度，max_length 为记录的最大长度

![11](/images/algorithm-LeetCode/11.png)

### 代码（Python）

#### **双指针-滑动窗口法**  

```python
class Solution(object):
    def lengthOfLongestSubstring(self, s):
        char_set = set()
        left = 0
        max_len = 0
        for right in range(len(s)):
            # 若当前字符已经在窗口内，收缩左边界
            while s[right] in char_set:
                char_set.remove(s[left])
                left += 1
            # 将右边界字符加入窗口
            char_set.add(s[right])
            # 更新最大长度
            max_len = max(max_len, right - left + 1)
        return max_len
```







## 题目 028：两数相加 [ 中等]

[2. 两数相加 - 力扣（LeetCode）](https://leetcode.cn/problems/add-two-numbers/description/)

#链表

### 题目描述

给你两个 **非空** 的链表，表示两个非负的整数。它们每位数字都是按照 **逆序** 的方式存储的，并且每个节点只能存储 **一位** 数字。

请你将两个数相加，并以相同形式返回一个表示和的链表。

你可以假设除了数字 0 之外，这两个数都不会以 0 开头。

### 示例

**示例 1：**

![1](/images/algorithm-LeetCode/1.png)

```
输入：l1 = [2,4,3], l2 = [5,6,4]
输出：[7,0,8]
解释：342 + 465 = 807.
```

**示例 2：**

```
输入：l1 = [0], l2 = [0]
输出：[0]
```

**示例 3：**

```
输入：l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
输出：[8,9,9,9,0,0,0,1]
```

### 提示

- 每个链表中的节点数在范围 `[1, 100]` 内
- `0 <= Node.val <= 9`
- 题目数据保证列表表示的数字不含前导零

### 解题思路

#### 链表相关知识

链表（Linked list）是一种常用的数据结构，它由一系列节点组成，每个节点包含**数据域**和**指针域**。指针域存储了下一个节点的地址，从而建立起各节点之间的线性关系

![2](/images/algorithm-LeetCode/2.png)

Python 中的数据类型只有**列表**和**自定义的类和对象**可以表示链表的节点。如果用列表来表示链表的节点，节点中的指针域无法表示，我们通过类来表示节点

在 Python 中，类的实例化实际上是创建一个对象，这个对象存储在内存中。当我们调用类的方法时，实际上是在操作这个对象的引用（地址），<a id="node-desc">因此可以用类来表示链表的节点</a>

```python
class ListNode:
    def __init__(self, data):
        self.val = data       # 链表的数据域，可以由多个变量组成
        self.next = None      # 链表的指针域
        
if __name__ == '__main__':
    head = ListNode(1)
```

此时链表节点的数据域为 1，指针域为空，即下一个节点为空

![3](/images/algorithm-LeetCode/3.png)

![4](/images/algorithm-LeetCode/4.png)

如何在 head 节点后面增加节点呢？

我们只需要给 head 的指针域赋值为新节点的地址，[之前我们介绍过](#node-desc)，当我们调用类的方法时，实际上是在操作这个对象的引用（地址），因此我们只需要在 head 节点的 next 赋值新节点类的名称即可

```python
class ListNode:
    def __init__(self, data):
        self.val = data   
        self.next = None      
        
if __name__ == '__main__':
    head = ListNode(1)
    head.next = ListNode(123)
```

![5](/images/algorithm-LeetCode/5.png)

点击查看下一个节点

![6](/images/algorithm-LeetCode/6.png)

继续添加节点，并且给指针赋值：

```python
class ListNode:
    def __init__(self, data):
        self.val = data   
        self.next = None      
        
if __name__ == '__main__':
    head = ListNode(1)
    head.next = ListNode(123)
    head.next.next = ListNode(456)
    head.next.next.next = ListNode(789)
    
    tmp = head
```

![7](/images/algorithm-LeetCode/7.png)

接下来：

```python
    tmp = tmp.next
```

表示 tmp 指向下一个节点

![8](/images/algorithm-LeetCode/8.png)

如何让节点“123”后面的节点断开呢？

```python
# 操作 head 或 tmp 均可

head.next.next = None
tmp.next = None
```

此时“123”后面的节点由 GC 回收，内存释放。GC（Garbage Collection，垃圾收集器）用于自动管理内存并回收不再使用的对象所占用的资源

如果我们用 .next 添加节点比较繁琐，我们可以封装一个方法：

```python
class ListNode:
    def __init__(self, data):
        self.val = data   
        self.next = None  

# 从链表节点尾部添加节点
def insert_node(node, value):
    if node is None:
        return
    
	# 创建一个新节点
    new_node = ListNode(value)
    cur = node     # 指向头节点
    while cur.next is not None:
        cur = cur.next  
    cur.next = new_node
    
if __name__ == '__main__':
    head = ListNode(1)
    insert_node(head, 123)
    insert_node(head, 456)
    insert_node(head, 789)
```

![9](/images/algorithm-LeetCode/9.png)

让我们封装一个方法，打印链表

```python
def print_node(node):
    cur = node
    while cur is not None:
        print(cur.val, end="\t")
        cur = cur.next
```

![10](/images/algorithm-LeetCode/10.png)

#### 递归相关知识点

递归：函数自己调用自己

从前有座山，山上有座庙，庙里有个老和尚在讲故事，讲的什么呢？从前有座山，山上有座庙，庙里有个老和尚在讲故事 ······

如果递归没有终止条件，函数会无限运行下去，最终导致程序崩溃 —— 栈溢出（StackOverflow）

写一个递归函数的步骤：

- 明确函数的功能
- 写出基本情况 Base case（大问题 ——> 小问题 ——> ······ ——> 基本情况）
- 写出递归情况：不满足基本情况时，函数自己调用自己

```python
# 计算阶乘

def fun(n):
    if n <= 0:
        return 1
    
    return n * fun(n-1)
```

递归调用的执行阶段：

- 递进：函数逐层调用自身，直到满足终止条件
- 回归：从递进阶段的最深层的地方开始逐层返回，每次返回时执行当前层递归调用

#### 解题

让我们回到题目，开始解题

1. **迭代法**  

   - 从左至右依次相加，如果满十则保留个位，下一个数 +1
   - //：整除的数。12 / 10 = 1
   - %：取余的数。12 % 10 = 2
   - next1 判断进位（0  / 1）

2. **递归法**  

   | res  |      |      |      |
   | :--: | :--: | :--: | :--: |
   |  L1  |  7   |  8   |  9   |
   |  L2  |  3   |  4   |      |

   - 第一个节点 4 + 7 = 10 ······ 1，将进位 next1 加到 L1 的下一个节点 5 + 1 = 6
   - 当递归到 L1 最后一个节点时，L2 没有元素了，将其补为 0 节点，next1 为1 继续往下递归

| res  |  0   |  3   |   0   |   1   |
| :--: | :--: | :--: | :---: | :---: |
|  L1  |  7   |  8   |   9   | **1** |
|  L2  |  3   |  4   | **0** | **0** |

### 代码（Python）

#### 迭代法

```python
class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution(object):
    def addTwoNumbers(self, l1, l2):    
        result = ListNode()
        cur = result
        next1 = 0

        while l1 is not None or l2 is not None or next1 != 0:
            val1 = l1.val if l1 else 0
            val2 = l2.val if l2 else 0

            total = val1 + val2 + next1
            digit = total % 10
            next1 = total // 10

            cur.next = ListNode(digit)
            cur = cur.next

            if l1:
                l1 = l1.next
            if l2:
                l2 = l2.next

        return result.next
```

**注意：**

`result` 始终指向 0，而 `cur` 会随着 `while` 不断向后移动，而我们的答案从 `0` 后面开始添加，所以我们需要返回 `result.next`

#### 递归法

```python
class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution(object):
    def addTwoNumbers(self, l1, l2):
        def dfs(node1, node2, carry):
            # 递归终止：都为空且没有进位
            if not node1 and not node2 and carry == 0:
                return None
            v1 = node1.val if node1 else 0
            v2 = node2.val if node2 else 0
            total = v1 + v2 + carry
            digit = total % 10
            new_carry = total // 10
            
            # 创建当前节点，递归求后面的链表
            cur_node = ListNode(digit)
            cur_node.next = dfs(
                node1.next if node1 else None,
                node2.next if node2 else None,
                new_carry
            )
            return cur_node
        
        return dfs(l1, l2, 0)  
```







## 题目 067：寻找两个正序数组的中位数 [ 困难 ]

[4. 寻找两个正序数组的中位数 - 力扣（LeetCode）](https://leetcode.cn/problems/median-of-two-sorted-arrays/description/)

#二分查找

### 题目描述

给定两个大小分别为 `m` 和 `n` 的正序（从小到大）数组 `nums1` 和 `nums2`。请你找出并返回这两个正序数组的 **中位数** 。

算法的时间复杂度应该为 `O(log (m+n))` 。

### 示例

**示例 1：**

```
输入：nums1 = [1,3], nums2 = [2]
输出：2.00000
解释：合并数组 = [1,2,3] ，中位数 2
```

**示例 2：**

```
输入：nums1 = [1,2], nums2 = [3,4]
输出：2.50000
解释：合并数组 = [1,2,3,4] ，中位数 (2 + 3) / 2 = 2.5
```

### 提示

- `nums1.length == m`
- `nums2.length == n`
- `0 <= m <= 1000`
- `0 <= n <= 1000`
- `1 <= m + n <= 2000`
- `-106 <= nums1[i], nums2[i] <= 106`

### 解题思路

1. **暴力法**  

   - 当两个有序数组的长度之和为奇数时，中位数只有一个，将它返回即可
   - 当两个有序数组的长度之和为偶数时，中位数有两个，返回合并、排序以后位于中间的两个数的平均数
   - 先合并两个有序数组，找到中位数。时间复杂度：O((m+n)log (m+n))，不符合题意

2. **合并两个有序数组** 

3. **二分查找法** 

   - “ 算法的时间复杂度应该为 `O(log (m+n))` ”提示我们用二分查找法

   - 中位数：在只有一个有序数组时，中位数把数组分割为两个部分

   - 数组长度为偶数时，中位数有两个，其中一个是左边数组的最大值，另一个是右边数组的最小值

     ![12](/images/algorithm-LeetCode/12.png)

   - 数组长度为奇数时，中位数有一个，不妨把它分到左边数组

     ![13](/images/algorithm-LeetCode/13.png)

   - 在有两个有序数组时，仍然可以把两个数组分割成两个部分

     ![14](/images/algorithm-LeetCode/14.png)

   - 我们使用一条分割线把两个数组分别分割为两部分：（1）红线左边和右边的元素个数相等，或者左边元素的个数比右边元素的个数多一个；（2）红线左边的所有元素的数值 <= 红线右边的所有元素的数值。那么中位数就一定只与红线两侧的元素有关，确定这条红线的位置使用二分查找

   - 当两个数组的元素个数之合为奇数的时候，有：$size_{left} = size_{right} + 1$

     ![15](/images/algorithm-LeetCode/15.png)

   - 分割线左边元素的最大值就是数组的中位数

   - 当两个数组的元素个数之合为偶数的时候，有：$size_{left} = size_{right} $

     ![16](/images/algorithm-LeetCode/16.png)

   - 分割线左边元素的最大值就是数组的其中一个中位数，分割线右边元素的最小值就是数组的另一个中位数

   - 中位数要保持的两个条件：

     ![17](/images/algorithm-LeetCode/17.png)

     ![18](/images/algorithm-LeetCode/18.png)

   - 即左上角的数小于等于右下角的数，左下角的数小于等于右上角的数。那么只要不符合交叉小于等于，我们就需要调整分割线位置

### 代码（Python）

#### 

```python
class Solution(object):
    def findMedianSortedArrays(self, nums1, nums2):
        
```







## 题目 0： [  ]



#

### 题目描述



### 示例



### 提示



### 解题思路

1. **法**  
   - 
2. **法**  
   - 


### 代码（Python）

#### 

```python

```

1
