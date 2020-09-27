---
title: "알고리즘 연습"
excerpt: ""
use_math: true
categories:
 - algorithm
last_modified_at: 2020-09-05T23:32:00
---

>[배열의 범위 내에서만 인덱스 증가시키기](##배열의-범위-내에서만-인덱스-증가시키기)  
>[배열 순서 뒤집기](#배열-순서-뒤집기)  
>[배열 내에서 이동 시 이동 횟수 줄이기](#배열-내에서-이동-시-이동-횟수-줄이기)  
>[크기가 같은 2차원 배열과 1차원 배열의 동시 탐색](#크기가-같은-2차원-배열과-1차원-배열의-동시-탐색)  
>[리스트 탐색하면서 특정 요소 제거하기](#리스트-탐색하면서-특정-요소-제거하기)
>
>[Map(2차원 배열)에서 일정 개수 선택하기](#map2차원-배열에서-일정-개수-선택하기)  
>[Map(2차원 배열)의 테두리 시계/반시계 방향 회전시키기](#map2차원-배열의-테두리-시계반시계-방향-회전시키기)  
>[Map(2차원 배열) 내리기](#map2차원-배열-내리기)  
>[Map(2차원 배열) 시계방향으로 90도 회전시키기](#map2차원-배열-시계방향으로-90도-회전시키기)
>
>[주사위 굴리기](#주사위-굴리기)  
>[달팽이 만들기](#달팽이-만들기)  
>[소용돌이 만들기](#소용돌이-만들기)



# 배열의 범위 내에서만 인덱스 증가시키기

```java
for(int i = 0; i < 10; i++){
    int index = i%arr.length;
}
```



# 배열 순서 뒤집기

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



# 배열 내에서 이동 시 이동 횟수 줄이기

- 고정된 크기의 배열 내에서 정해진 이동 횟수만큼 이동한다.
- 배열 양 끝에 닿으면 방향을 바꾸어 이동한다.

정해진 이동 횟수만큼 반복문을 수행하면 비효율적이다.  
'*이동 결과는 정해진 이동 횟수를 왕복 이동거리로 나눈 나머지의 결과와 같다*'는 원리를 이용하면 **이동 횟수를 왕복 이동거리 내로 줄일 수 있다.**

$왕복 이동거리 = (배열 길이 - 1) * 2$  
$이동 결과 = 이동 횟수 % 왕복 이동거리$

```java
final int ARR_SIZE = 6;
final int MOVE_CNT = 45;
final int[] dc = {-1, 1}; //좌우

int cur = 3; //현재 위치(인덱스)
int dir = 1; //현재 이동 방향(우)

int returnCnt = (ARR_SIZE-1)*2; //왕복 이동거리
int moveCnt = MOVE_CNT % returnCnt;

int next;
for(int i = 0; i < moveCnt; i++) {
  next = cur + dc[dir];
  
  if(!(next >= 0 && next < ARR_SIZE)) {
    dir = dir+1 == 2 ? 0 : dir+1;
    next = cur + dc[dir];
  }
  
  cur = next;
}

System.out.println(cur); //결과: 2
```



# 크기가 같은 2차원 배열과 1차원 배열의 동시 탐색

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



# 리스트 탐색하면서 특정 요소 제거하기

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



# Map(2차원 배열)에서 일정 개수 선택하기

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



# Map(2차원 배열)의 테두리 시계/반시계 방향 회전시키기

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



# Map(2차원 배열) 내리기

```java
int[][] map = {
  {1,1,1,1},
  {1,1,0,0},
  {1,0,0,0},
  {1,1,1,0},
  {1,0,1,0}
};
int ROW_LENGTH = 5;
int COL_LENGTH = 4;

//...
for(int c = 0; c < COL_LENGTH; c++) {
  int r = ROW_LENGTH-1;

  int er = -1; // empty row, 처음 빈곳이 발견되는 row index 저장

  while(r >= 0) {
    if(map[r][c] == 0) {
      if(er == -1) er = r; // 처음 빈곳이 발견되는 경우
    }
    else {
      if(er != -1) { // 데이터를 발견하면 빈곳이 발견된 위치로 이동시킨다.
        map[er][c] = map[r][c];
        map[r][c] = 0;
        er--; // 원래 빈곳이었던 위치 바로 위로 빈 곳을 지정한다.
      }
    }

    r--;
  }
}
```



# Map(2차원 배열) 시계방향으로 90도 회전시키기

```java
int N = 4;
int[][] map = {
  {1,2,3,4},
  {5,6,7,8},
  {9,10,11,12},
  {13,14,15,16}
};

// ...
int[][] temp = new int[N][N];

// 0,0 -> 0,3
// 0,1 -> 1,3
// 0,2 -> 2,3
// 0,3 -> 3,3
// 1,0 -> 0,2
// 1,1 -> 1,2
// ...
// r,c -> c,N-r-1
for(int r = 0; r < N; r++) {
  for(int c = 0; c < N; c++) {
    int nr = c;
    int nc = N-r-1;
    temp[nr][nc] = map[r][c];
  }
}

map = temp;
```



# 주사위 굴리기

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



# 달팽이 만들기

```java
int N = 4;
int[][] map = new int[N][N];
int[] dr = {-1,1,0,0};
int[] dc = {0,0,-1,1};
int[] cw = {3,1,2,0}; // 시계방향

// ...
int r = 0;
int c = 0;
int nr, nc;
int d = 0;

map[r][c] = 1;
for(int n = 2; n <= N*N; n++) {
  nr = r + dr[cw[d]];
  nc = c + dc[cw[d]];

  // 벽에 닿거나 이미 존재한다면 다음 방향으로 진행;
  if(!(nr >= 0 && nr < N && nc >= 0 && nc < N) || map[nr][nc] != 0) {
    d++;
    if(d == 4) d = 0;
    n--; // 번호는 증가시키지 않는다.
  }
  else {
    map[nr][nc] = n;
    r = nr;
    c = nc;
  }
}
```



# 소용돌이 만들기

- NxN 배열의 네 모퉁이에서 시작하는 소용돌이 그리기
- 시계/반시계 방향으로 소용돌이 만들기

```java
int N = 5;
boolean clockwise = true;

static final int[] dr = {-1, 1, 0, 0};
static final int[] dc = {0, 0, -1, 1};
// 4개의 소용돌이 선분의 시계방향 경로
static final int[][] cw = {
  {3,1,2,0},
  {1,2,0,3},
  {2,0,3,1},
  {0,3,1,2}
};
// 4개의 소용돌이 선분의 반시계방향 경로
static final int[][] ccw = {
  {1,3,0,2},
  {2,1,3,0},
  {0,2,1,3},
  {3,0,2,1}
};

// ...
// 시작위치
int[] startR = {0, 0, n-1, n-1};
int[] startC = {0, n-1, n-1, 0};

// 회전 방향 정보
int[][] cwInfo = clockwise ? cw : ccw;

int[][] map = new int[n][n];

// 4개의 소용돌이 선분을 순서대로 진행시킨다.
for(int o = 0; o < 4; o++) {
  int r = startR[o];
  int c = startC[o];

  // 소용돌이 확장 범위 패딩 값
  int pad = 1;

  int d = 0; // 소용돌이 확장 방향 인덱스

  int cnt = 1;
  map[r][c] = cnt++;

  // 각 소용돌이 선분 확장
  while(true) {
    int dir = cwInfo[o][d];

    int nr, nc;
    while(true) {
      nr = r + dr[dir];
      nc = c + dc[dir];

      if(!(nr >= 0 && nr < n && nc >= 0 && nc < n)) break;

      // 진행 종료 조건
      if(dir == 0) {
        if(!(nr >= 0+pad)) break;
      }
      else if(dir == 1) {
        if(!(nr < n-pad)) break;
      }
      else if(dir == 2) {
        if(!(nc >= 0+pad)) break;
      }
      else {
        if(!(nc < n-pad)) break;
      }

      r = nr;
      c = nc;

      map[r][c] = cnt++;
    }

    // 확장 종료 조건
    if(n%2 != 0 && r == n/2 && c == n/2) break;
    else if(n%2 == 0 && 
            ((r == n/2 && c == n/2) ||
             (r == n/2 && c == n/2-1) ||
             (r == n/2-1 && c == n/2-1) ||
             (r == n/2-1 && c == n/2))) break;

    pad++;
    if(pad > n/2) pad = n/2; // 주의!) 패딩 값은 중앙 지점을 넘을 수 없다.
    d++;
    if(d == 4) d = 0;
  }
}
```
```
// N: 5 clockwise: true
1 2 3 4 1 
4 5 6 5 2 
3 6 7 6 3 
2 5 6 5 4 
1 4 3 2 1

// N: 6 clockwise: false
1 5 4 3 2 1 
2 6 8 7 6 5 
3 7 9 9 8 4 
4 8 9 9 7 3 
5 6 7 8 6 2 
1 2 3 4 5 1 

// N; 9 clockwise: false
1 8 7 6 5 4 3 2 1 
2 9 14 13 12 11 10 9 8 
3 10 15 18 17 16 15 14 7 
4 11 16 19 20 19 18 13 6 
5 12 17 20 21 20 17 12 5 
6 13 18 19 20 19 16 11 4 
7 14 15 16 17 18 15 10 3 
8 9 10 11 12 13 14 9 2 
1 2 3 4 5 6 7 8 1
```

