---
title: "최대공약수와 최소공배수"
excerpt: "GCD (Greatest Common Divisor), LCM (Least Common Multiple), Euclidean Algorithm"
use_math: true
categories:
 - algorithm
last_modified_at: 2020-12-13T15:25:00
---

# 유클리드 호제법
- 2개의 자연수 a, b에 대해서 a를 b로 나눈 나머지를 r이라 하면(단, a>b), a와 b의 최대공약수는 b와 r의 최대공약수와 같다.
- 2개의 자연수 a, b 의 최대공약수와 최소공배수를 각각 g, l 이라 했을 때, $a * b = g * l$ 이 성립한다.

```java
 int GCD(int n1, int n2) {
  while(n2 != 0) {
    // n1, n2 크기 순서 상관 없음
    // n1이 n2 보다 작으면 n1은 그대로 나머지가 되고 다음 회차에서 순서가 뒤바뀐다.
    int temp = n1%n2;
    n1 = n2;
    n2 = temp;
  }
  return n1;
}

int LCM(int gcd, int n1, int n2) {
  // GCD*LCM == n1*n2;
  return n1*n2/gcd;
}
```

