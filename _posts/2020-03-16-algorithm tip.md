---
title: "알고리즘 Tip"
excerpt: "알고리즘 문제를 풀면서 많이 사용되는 코드를 정리한다."
categories:
 - algorithm
last_modified_at: 2020-03-31T06:20:00
---

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

