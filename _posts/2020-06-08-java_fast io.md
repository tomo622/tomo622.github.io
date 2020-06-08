---
title: "입출력 시간 줄이기"
excerpt: "입출력 시간을 단축시키는 방법 정리"
categories:
 - java language
last_modified_at: 2020-06-08T13:38:00
---


### 입출력의 수가 많은 경우 `BufferedReader` 와 `BufferedWriter`를 사용한다.

```java
BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
String str = br.readLine();
int i = Integer.parseInt(br.readLine());
StringTokenizer st = new StringTokenizer(br.readLine());
str = st.nextToken();
br.close();

BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));
bw.write(str);
bw.flush();
bw.close();
```



### 문자열의 변경 작업이 많은 경우 `StringBuilder`를 사용한다.
  Java의 `String`은 immutable 하다. 즉 문자열의 변경이 불가능하기 때문에 값을 변경할 때 마다 새로 생성되어 메모리와 시간에서 효율적이지 못하다.
  반면, `StringBuffer`와 `StringBuilder`는 mutable 하다. 클래스는 한 번 생성하고 메모리의 값을 변경시켜 문자열을 변경한다. 이 둘의 가장 큰 차이점은 `StringBuffer`는 thread-safe 하고 `StringBuilder` 는 thread-safe 하지 못하다는 것이다.

```java
StringBuilder sb = new StringBuilder();
sb.append("abcdefg");
...
bw.write(sb.toString());
```

  