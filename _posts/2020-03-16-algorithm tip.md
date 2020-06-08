---
title: "알고리즘 Tip"
excerpt: "알고리즘 문제를 풀면서 많이 사용되는 코드를 정리한다."
categories:
 - algorithm
last_modified_at: 2020-06-08T13:12:00
---

### 배열의 범위 내에서만 인덱스 증가시키기

```java
for(int i = 0; i < 10; i++){
    int index = i%arr.length;
}
```



### 배열 순서 뒤집기

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



### Map(2차원 배열)에서 일정 개수 선택하기

```java
int N = //목표 개수
int[][] map = //맵 생성
  
private static void recursive(int cnt, int cr, int cc) {
  if(cnt == N) {
    //선택된 셀 출력
    return;
  }
		  
  for(int r = cr; r < N; r++) {
    for(int c = cc; c < M; c++) {
      if(map[r][c] != 0) continue;

      map[r][c] = 1; //맵에 직접 표시할 수 없는 경우 'boolean[][] visit' 사용
      recursive(cnt+1, r, c+1);
      map[r][c] = 0;
    }
    cc=0; //다음 행 탐색 시작 시 첫번째 열 부터 탐색할 수 있도록
  }
}
```

