---
title: "알고리즘 Tip"
excerpt: "알고리즘 문제를 풀면서 많이 사용되는 코드를 정리한다."
categories:
 - algorithm
last_modified_at: 2020-04-20T22:28:00
---

#### 입출력 시간 줄이기 (Java)

- 입출력의 수가 많은 경우 `BufferedReader` 와 `BufferedWriter`를 사용한다.

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

  

- 문자열의 변경 작업이 많은 경우 `StringBuilder`를 사용한다.
  Java의 `String`은 immutable 하다. 즉 문자열의 변경이 불가능하기 때문에 값을 변경할 때 마다 새로 생성되어 메모리와 시간에서 효율적이지 못하다.
  반면, `StringBuffer`와 `StringBuilder`는 mutable 하다. 클래스는 한 번 생성하고 메모리의 값을 변경시켜 문자열을 변경한다. 이 둘의 가장 큰 차이점은 `StringBuffer`는 thread-safe 하고 `StringBuilder` 는 thread-safe 하지 못하다는 것이다.

  ```java
  StringBuilder sb = new StringBuilder();
  sb.append("abcdefg");
...
  bw.write(sb.toString());
  ```
  
  

#### 배열의 범위 내에서만 인덱스 증가시키기

```java
for(int i = 0; i < 10; i++){
    int index = i%arr.length;
}
```

#### 배열 순서 뒤집기

```java
int[] arr = {/*배열 저장*/};

int start = //시작 지점 인덱스
int end = //끝 지점 인덱스
int temp;

while(start < end){
    temp = arr[start];
    arr[start] = arr[end];
    arr[end] = temp;
    
    start++;
    end--;
}
```

