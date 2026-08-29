---
title: 算法每日一题——LeetCode 题01：两数之和 [简单]
date: 2026-08-28
tags: [LeetCode, 算法题解]
description: 本系列每道题提供 Python / C++ / Java 三种语言的解题代码，欢迎对照练习。本节通过暴力法和哈希表法解题
---

## 题目

[LeetCode 题01：两数之和](https://leetcode.cn/problems/two-sum/description/)

## 题目描述

给定一个整数数组 `nums` 和一个整数目标值 `target`，请你在该数组中找出**和为目标值** *`target`* 的那**两个**整数，并返回它们的数组下标。

你可以假设每种输入只会对应一个答案，并且你不能使用两次相同的元素。

你可以按任意顺序返回答案。

## 示例

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

## 提示

- `2 <= nums.length <= 104`
- `-109 <= nums[i] <= 109`
- `-109 <= target <= 109`
- **只会存在一个有效答案**

## 解题思路

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

## 代码（Python、C++、Java）

### python - 暴力法

```python
class Solution(object):
    def twoSum(self, nums, target):
        n = len(nums)
        for i in range(n):
            for j in range(i+1, n):
                if nums[i] + nums[j] == target:
                    return [i, j]
```

### python - 哈希表法

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

### C++ - 暴力法

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

### C++ - 哈希表法

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

### Java - 暴力法

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

### Java - 哈希表法

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

## 总结

| Python             | C++                                   | Java                    |
| ------------------ | ------------------------------------- | ----------------------- |
| `need in hashmap`  | `hashmap.find(need) != hashmap.end()` | `map.containsKey(need)` |
| `hashmap[num]`     | `hashmap[num]`                        | `map.get(num)`          |
| `hashmap[num] = i` | `hashmap[nums[i]] = i`                | `map.put(num, i)`       |
