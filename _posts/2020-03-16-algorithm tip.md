---
title: "알고리즘 Tip"
excerpt: "알고리즘 문제를 풀면서 많이 사용되는 코드를 정리한다."
categories:
 - algorithm
last_modified_at: 2020-06-09T10:48:00
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



### 주사위 굴리기

주사위에 1~6 까지 숫자가 적혀있고 네 방향으로 주사위를 굴렸을 때의 주사위 상태를 출력한다.   
교체되는 인덱스의 변화를 생각하고 역순으로 교체하면 쉽게 구현할 수 있다.

```java
/* 주사위 인덱스 전개도
*   0
* 1 2 3
*   4
*   5
*/
// 굴리는 방향에 따른 인덱스 변화(인덱스 2번이 위를 향하고 4번이 앞을 향하고 있는 상태)
// 오 : 2->3->5->1->2
// 왼 : 2->1->5->3->2
// 위 : 2->0->5->4->2
// 아래 : 2->4->5->0->2

int[] dice = {1,2,3,4,5,6};
int[] rotations = {0,1,2,3}; //주사위 회전 정보 0:오, 1:왼, 2:위, 3:아래
//...
for(int r: rotations){
    rotations(dice, r);
}
//...
public void rotation(int[] dice, int r){
    int temp;
    switch(r){
        case 0:
            temp = dice[2];
            dice[2] = dice[1];
            dice[1] = dice[5];
            dice[5] = dice[3];
            dice[3] = temp;
            break;
     case 1:
            temp = dice[2];
            dice[2] = dice[3];
            dice[3] = dice[5];
            dice[5] = dice[1];
            dice[1] = temp;
            break;
     case 2:
            temp = dice[2];
            dice[2] = dice[4];
            dice[4] = dice[5];
            dice[5] = dice[0];
            dice[0] = temp;
            break;
     case 3:
            temp = dice[2];
            dice[2] = dice[0];
            dice[0] = dice[5];
            dice[5] = dice[4];
            dice[4] = temp;
            break;
    }
}
```