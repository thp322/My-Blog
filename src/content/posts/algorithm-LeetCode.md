---
title: LeetCode 300题（持续更新中）
date: 2026-08-28
tags: [LeetCode, 算法题解]
description: 本系列为Leetcode力扣 1-300 题讲解合集，每道题提供 Python / C++ / Java 三种语言的解题代码，欢迎对照练习
---

## 题目 001：两数之和 [ 简单 ]

[1. 两数之和 - 力扣（LeetCode）](https://leetcode.cn/problems/two-sum/description/)

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

### 代码（Python、C++、Java）

#### python - 暴力法

```python
class Solution(object):
    def twoSum(self, nums, target):
        n = len(nums)
        for i in range(n):
            for j in range(i+1, n):
                if nums[i] + nums[j] == target:
                    return [i, j]
```

#### python - 哈希表法

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

#### C++ - 暴力法

```c++
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        int n = nums.size();
        for(int i = 0; i < n; i++){
            for(int j = i + 1; j < n ; j++){
                if(nums[i] + nums[j] == target){
                    return {i, j}
                }
            }
        }
        return {};   // 题目保证一定有解，此处仅满足编译
    }
};
```

#### C++ - 哈希表法

```c++
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        // unordered_map 哈希表 key:数值，value:下标
        unordered_map<int, int> hashmap;
        for (int i = 0; i < nums.size(); i++) {
            int need = target - nums[i];
            // 查找需要的数是否已经存在哈希表中
            if (hashmap.find(need) != hashmap.end()) {
                return {hashmap[need], i};
            }
            // 当前元素存入哈希表
            hashmap[nums[i]] = i;
        }
        return {}; 
    }
};
```

#### Java - 暴力法

```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (nums[i] + nums[j] == target) {
                    return new int[]{i, j};
                }
            }
        }
        return new int[]{};   // 题目保证一定有解，此处仅满足编译
    }
}
```

#### Java - 哈希表法

```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        HashMap<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int need = target - nums[i];
            if (map.containsKey(need)) {
                return new int[]{map.get(need), i};
            }
            map.put(nums[i], i);
        }
        return new int[]{};
    }
}
```

### 总结

| Python             | C++                                   | Java                    |
| ------------------ | ------------------------------------- | ----------------------- |
| `need in hashmap`  | `hashmap.find(need) != hashmap.end()` | `map.containsKey(need)` |
| `hashmap[num]`     | `hashmap[num]`                        | `map.get(num)`          |
| `hashmap[num] = i` | `hashmap[nums[i]] = i`                | `map.put(num, i)`       |

## 题目 002：两数相加 [ 中等]

[2. 两数相加 - 力扣（LeetCode）](https://leetcode.cn/problems/add-two-numbers/description/)

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

#### 解题

让我们回到题目，开始解题

1. **迭代法**  
   - 从左至右依次相加，如果满十则保留个位，下一个数 +1
   - /：整除的数。12 / 10 = 1
   - %：取余的数。12 % 10 = 2
2. **递归法**  
   - 111


### 代码（Python、C++、Java）

#### python - 迭代法

```python
class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution(object):
    def addTwoNumbers(self, l1, l2):
        total = 0
        next = 0
        result = ListNode()
        cur = result
        
        while l1 is not None or l2 is not None or carry != 0:
            # 如果链表走到空，取0
            val1 = l1.val if l1 else 0
            val2 = l2.val if l2 else 0
            
            total = val1 + val2 + next
            digit = total % 10           # 当前位数字
            carry = total // 10          # 更新进位 0或1
            
            # 创建新节点，接到结果链表
            cur.next = ListNode(digit)
            cur = cur.next
            
            # l1 l2往后走，如果不为None
            if l1:
                    l1 = l1.next
                if l2:
                    l2 = l2.next

            return dummy.next
```

#### C++ - 

```c++

```

#### Java - 

```java

```

### 总结

## 题目 0： [  ]



### 题目描述



### 示例



### 提示



### 解题思路

1. **法**  
   - 
2. **法**  
   - 


### 代码（Python、C++、Java）

#### python - 

```python

```

#### C++ - 

```c++

```

#### Java - 

```java

```

### 总结
