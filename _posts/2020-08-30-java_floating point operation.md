---
title: "소수점 처리"
excerpt: "반올림, 올림, 버림"
categories:
 - java language
last_modified_at: 2020-08-30T18:38:00
---

`Math.round()`, `Math.ceil()`, `Math.floor()` 는 각각 소수점 첫번째 자리에서 반올림, 올림, 내림을 수행한다.

```java
double num1 = 123.3123;
double num2 = 123.5123;
double num3 = 123.7123;

System.out.println(num1 + " round > " + Math.round(num1));
System.out.println(num2 + " round > " + Math.round(num2));
System.out.println(num3 + " round > " + Math.round(num3));

System.out.println(num1 + " ceil > " + Math.ceil(num1));

System.out.println(num3 + " floor > " + Math.floor(num3));
```

```
123.3123 round > 123
123.5123 round > 124
123.7123 round > 124
123.3123 ceil > 124.0
123.7123 floor > 123.0
```

원하는 소수점 위치에서 각각의 연산을 처리하려는 경우 목표로하는 소수점 위치를 소수점 첫번째 자리로 바꿔준 뒤 연산 수행 후 다시 자리를 돌려 놓으면 된다.   
예를들어, 소수점 두번째 자리에서 반올림을 수행하는 경우 첫번째 자리로 이동시키기 위해 10을 곱해준 뒤 연산 후 다시 10.0으로 나눠준다. 이때 정수 10으로 나누게 되면 결과값이 정수로 나오기 때문에 주의한다.

```java
double num1 = 123.3723;
		
System.out.println(num1 + " round > " + Math.round(num1*10)/10.0);
```

```
123.3723 round > 123.4
```

나머지 올림, 내림 연산도 동일하게 적용 가능하다.

