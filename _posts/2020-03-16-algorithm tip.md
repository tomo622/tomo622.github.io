---
title: "알고리즘 Tip"
excerpt: "알고리즘 문제를 풀면서 많이 사용되는 코드를 정리한다."
categories:
 - algorithm
last_modified_at: 2020-07-05T14:57:00
---

### 생각

- 반시계 회전은 시계방향 회전을 3회 한 것과 동일하다.
- 반복문 안에서 함수를 여러번 호출하기 보다는 함수 내부에서 반복문을 수행하고 결과를 반환하자.
- 문제 조건에서 범위가 큰 경우 생각해볼만 한 것들
  - 자료형 : int -> long
  - 정해진 케이스에 따라 정해진 답이 반복된다면 메모이제이션
  - 범위를 반으로 나누어 실행해도 동일한 답을 얻을 수 있다면 Meet in the middle



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



### Map(2차원 배열)의 테두리 시계/반시계 방향 회전시키기

```java
final int ROW_SIZE = 4;
final int COL_SIZE = 4;
//상하좌우
final int[] dr = {-1, 1, 0, 0};
final int[] dc = {0, 0, -1, 1};
final int[] cw = {3, 1, 2, 0}; //clockwise, 시계방향(우-하-좌-상)
final int[] ccw = {1, 3, 0, 2}; //counter-clockwise, 반시계방향(하-우-상-좌)

int[][] map = {...}
//...
rotate(map, copyMap, cw); //시계방향으로 회전
rotate(map, copyMap, ccw); //반시계방향으로 회전

void rotate(int[][] map, int[][] copyMap, int[] cd) {
  int cr, cc, nr, nc;
  cr = 0; cc = 0;

  for(int d = 0; d < 4; d++) {
    while(true) {
      nr = cr + dr[cd[d]];
      nc = cc + dc[cd[d]];

      if(!(nr >= 0 && nr < ROW_SIZE && nc >= 0 && nc < COL_SIZE)) break;

      copyMap[nr][nc] = map[cr][cc];

      cr = nr;
      cc = nc;

      if(cr == 0 && cc == 0) break;
    }
  }
}
```



### 크기가 같은 2차원 배열과 1차원 배열의 동시 탐색

```java
int[] arr = {1,2,3,4,5,6,7,8};
{% raw %}int[][] map = {{1,2,3,4},{5,6,7,8}};{% endraw %}

final int ROW_SIZE = map.length;
final int COL_SIZE = map[0].length;

for(int i = 0; i < ROW_SIZE; i++) {
    for(int j = 0; j < COL_SIZE; j++) {
        int arrIdx = j+i*COL_SIZE;
        System.out.println("arr:" + arr[arrIdx] + ", map:" + map[i][j]);
    }
}
```



### 리스트 탐색하면서 특정 요소 제거하기

동적으로 크기가 변하는 리스트를 사용할 때 탐색을 진행하며 특정 요소를 제거해야하는 경우

```java
ArrayList<Integer> list = new ArrayList<Integer>();
//...

// 동적으로 크기가 변하는 리스트를 탐색하며 특정 요소를 제거할때 반복문의 제어변수와 리스트의 크기가 일치하지 않아 에러가 발생한다.
for(int i = 0; i < list.size(); i++){ //error.
  Integer item = list.get(i);
  if(!조건){
    list.remove(i);
  }
}

// 1. 임의의 리스트에 조건에 부합되는 요소들만 저장하여 탐색이 종료된 후 리스트를 교체하는 방법
ArrayList<Integer> temp = new ArrayList<Integer>();

for(int i = 0; i < list.size(); i++){
  Integer item = list.get(i);
  if(조건){
    temp.add(list.get(i));
  }
}

list = temp;

// 2. 리스트의 뒤에서 부터 탐색하며 제거해나가는 방법
for(int i = list.size()-1; i >= 0; i--){
  if(!조건){
    list.remove(i);
  }
}

```

