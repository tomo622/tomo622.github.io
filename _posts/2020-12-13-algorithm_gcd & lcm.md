---
title: "최대공약수와 최소공배수"
excerpt: "GCD (Greatest Common Divisor), LCM (Least Common Multiple), Euclidean Algorithm"
use_math: true
categories:
 - algorithm
last_modified_at: 2020-12-13T15:25:00
---

# 최대공약수 찾기 (유클리드 호제법)

2개의 자연수 a, b에 대해서 a를 b로 나눈 나머지를 r이라 하면(단, a>b), a와 b의 최대공약수는 b와 r의 최대공약수와 같다. 이 성질에 따라, b를 r로 나눈 나머지 r'를 구하고, 다시 r을 r'로 나눈 나머지를 구하는 과정을 반복하여 나머지가 0이 되었을 때 나누는 수가 a와 b의 최대공약수이다.

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
```

> 출처) [위키백과-유클리드 호제법](https://ko.wikipedia.org/wiki/%EC%9C%A0%ED%81%B4%EB%A6%AC%EB%93%9C_%ED%98%B8%EC%A0%9C%EB%B2%95)



# 최소공배수 찾기

2개의 자연수 a, b 의 최대공약수와 최소공배수를 각각 g, l 이라 했을 때, $a * b = g * l$ 이 성립한다.

```java
int LCM(int gcd, int n1, int n2) {
  // GCD*LCM == n1*n2;
  return n1*n2/gcd;
}
```



# 관련 문제

## 대각선이 지나는 격자점의 개수 구하기

<img width="656" alt="algorithm_gcd   lcm_image1" src="https://user-images.githubusercontent.com/19742979/104930631-c0641000-59e8-11eb-85d2-f795e79bd697.png">

`대각선이 지나는 격자점의 개수 = 가로와 세로의 최대공약수 - 1`



## 대각선이 지나는 격자 개수 구하기

<img width="674" alt="algorithm_gcd   lcm_image2" src="https://user-images.githubusercontent.com/19742979/104930867-04efab80-59e9-11eb-9585-fa4fe5091b04.png">

`대각선이 지나는 격자 개수 = 가로 + 세로 - 1 - 가로와 세로의 최대공약수`

