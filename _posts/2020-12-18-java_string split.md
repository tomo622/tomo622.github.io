---
title: "문자열 자르기"
excerpt: "String.split, String.substring, StringTokenizer"
categories:
 - java language
last_modified_at: 2020-12-18T00:22:00
---

# String.split 사용 시 주의점

**정규식 문자열을 매개변수로** 받기 때문에 아래와 같은 경우 주의해야한다.

```java
String str = "192.168.123.123";
String[] toks = str.split("."); // 빈 문자열 반환
```

정규식에서 `.` 은 '하나의 문자' 를 의미하는 메타문자이기 때문에 빈 문자열이 반한된다. 이 문제를 해결하기 위해서 다음과 같이 수정한다.

```java
String[] toks = str.split("\\.");
```

정규식에서 `.` 를 메타문자가 아닌 일반 문자로 인식하게 하기위해 `\.` 으로 escape 시켜야한다. 또 이를 Java 의 문자열로 표현해야하기 때문에 결국 `\\.` 가 된다.

`StringTokenizer` 를 사용하여 해결하는 방법도 있다.

```java
StringTokenizer st = new StringTokenizer(str, ".");
while(st.hasMoreTokens()){
  st.nextToken();
}
```



# String.substring 사용법

```java
// 메소드 정의
public String substring(int beginIndex) {...} 							// beginIndex ~ 끝까지
public String substring(int beginIndex, int endIndex){...} 	// beginIndex ~ endIndex 전까지
```

```java
String str = "ABCDE";
System.out.println(str.substring(2)); 		// 인덱스 2 부터 끝까지, 결과: CDE
System.out.println(str.substring(1, 3)); 	// 인덱스 1 부터 3 전까지, 결과: BC
```

