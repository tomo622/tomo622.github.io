---
title: "순열"
excerpt: "1부터 n까지의 수가 갖는 모든 순열과 사전 순으로 정렬된 순열 집합에서 이전 순열과 다음 순열을 구하는 방법에 대해 정리한다."
categories:
 - algorithm
last_modified_at: 2020-03-31T03:08:00
---

### 순열 (Permutation)

- 순서를 고려해 n개 나열하기
- 사전 순으로 정렬된 순열: 순열 집합에서 중 첫 번째 순열은 오름차순으로 정렬되어 있고 마지막 순열은 내림차순으로 정렬되어 있다.

#### 1. 1부터 n까지의 수가 갖는 모든 순열 (사전 순)

##### 재귀함수

```java
final int N = //수의 개수
int[] arr = new int[N]; //순열 저장
boolean[] visit = new boolean[N];

void permutation(int cnt){
    if(cnt == N){
        //순열 출력...
        return;
    }
    
    for(int i = 0; i < N; ++i){
        if(visit[i]) continue;
        
        visit[i] = true;
        arr[cnt] = i+1;
        permutation(cnt+1);
        arr[cnt] = 0; //없어도 된다.
        visit[i] = false;
    }
}
```

#### 비트연산

위 재귀함수를 이용한 구현에서는 방문 체크를 위해 `boolean` 배열을 사용했지만 이번에는 플래그의 비트연산을 통해 방문 체크를 한다.
수의 인덱스 만큼 비트를 밀고 현재의 플래그 비트와 AND(&) 연산을 통해 해당 위치의 비트가 1인지 확인한다. 1인 비트는 그 수를 방문했음을 나타낸다. 아직 방문하지 않은 수는 방문 표시를 하기 위해 수의 인덱스 만큼 밀어낸 비트를 OR(|) 연산으로 플래그에 반영해 준다.
플래그 : 0001 0010
...
인덱스 1번의 방문 확인 : 0001 0010 & 0000 0010 -> 0000 0010 방문 했음
인덱스 2번의 방문 확인 : 0001 0010 & 0000 0100 -> 0000 0000 방문하지 않았음
인덱스 2번 방문  : 0001 0010 | 0000 0100 ->0001 0110
...

```java
final int N = //수의 개수
int[] arr = new int[N]; //순열 저장

void permutation(int cnt, int flag){
		if(cnt == N) {
			//순열 출력...
			return;
		}
  
		for(int i = 0; i < N; i++) {
			if((flag & 1<<i) != 0) continue;
			
			nums[cnt] = i+1;
			permutation(cnt+1, flag | 1<<i);
			nums[cnt] = 0;
		}
}
```




#### 2. 다음 순열 찾기

1. 오른쪽 부터 탐색하여 왼쪽이 작은 수를 찾는다.
2. 다시 오른쪽 부터 탐색하여 1번에서 찾는 작은 수 보다 큰 수를 찾는다.
3. 두 수의 자리를 바꾼다.
4. 1번에서 찾은 수 위치의 오른쪽 수들을 전부 뒤집는다.

예) 7 2 3 6 5 4 1 다음의 순열은?

1. 7 2 (3) 6 5 4 1
2. 7 2 (3) 6 5 (4) 1
3. 7 2 (4) 6 5 3 1
4. 7 2 4 1 3 5 6

```java
final int N = //수의 개수
int[] arr = {/*기준 순열 저장*/};

void nextPermutation(){
    //왼쪽이 작은 수 찾기
    int idx = -1;
    for(int i = N-1; i > 0; --i){
        if(arr[i] > arr[i-1]){
            idx = i-1;
            break;
        }
    }
    
    //왼쪽이 작은 수를 못 찾는 경우는 사전 순으로 마지막의 순열인 경우이다.(내림차순 정렬 상태)
    //다음 순열이 없기때문에 종료
    if(idx == -1){
        return;
    }
    
    //찾은 작은 수 보다 큰 수 찾기
    int biggerIdx = -1;
    for(int i = N-1; i > idx; --i){
        if(arr[idx] < arr[i]){
            biggerIdx = i;
            break;
        }
    }
    
    //찾은 두 수 자리 교환
    int temp = arr[idx];
    arr[idx] = arr[biggerIdx];
    arr[biggerIdx] = temp;
    
    //찾은 작은 수 위치의 오른쪽으로 순서 뒤집기
    int startIdx = idx+1;
    int endIdx = N-1;
    
    while(startIdx < endIdx){
        temp = arr[startIdx];
        arr[startIdx] = arr[endIdx];
        arr[endIdx] = temp;
        startIdx++;
        endIdx--;
    }
    
    //순열 출력...
}
```



#### 3. 이전 순열 찾기

다음 순열을 찾는 방법을 반대로 한다.

1. 오른쪽 부터 탐색하여 왼쪽이 큰 수를 찾는다.
2. 다시 오른쪽 부터 탐색하여 1번에서 찾은 큰 수 보다 작은 수를 찾는다.
3. 두 수의 자리를 바꾼다.
4. 1번에서 찾은 수 위치의 오른쪽 수들을 전부 뒤집는다.

예) 2 1 3 4이전의 순열은?

1. (2) 1 3 4
2. (2) (1)  3 4
3. (1) 2 3 4
4. 1 4 3 2

```java
final int N = //수의 개수
int[] arr = {/*기준 순열 저장*/};

void prePermutation(){
    //왼쪽이 큰 수 찾기
    int idx = -1;
    for(int i = N-1; i > 0; --i){
        if(arr[i] < arr[i-1]){
            idx = i-1;
            break;
        }
    }
    
    //왼쪽이 큰 수를 못 찾는 경우는 사전 순으로 첫 번째 순열인 경우이다.(오름차순 정렬 상태)
    //이전 순열이 없기때문에 종료
    if(idx == -1){
        return;
    }
    
    //찾은 큰 수 보다 작은 수 찾기
    int smallerIdx = -1;
    for(int i = N-1; i > idx; --i){
        if(arr[i] < arr[idx]){
            smallerIdx = i;
            break;
        }
    }
    
    //찾은 두 수 자리 교환
    int temp = arr[idx];
    arr[idx] = arr[smallerIdx];
    arr[smallerIdx] = temp;
    
    //찾은 큰 수 위치의 오른쪽으로 순서 뒤집기
    int startIdx = idx+1;
    int endIdx = N-1;
    
    while(startIdx < endIdx){
        temp = arr[startIdx];
        arr[startIdx] = arr[endIdx];
        arr[endIdx] = temp;
        startIdx++;
        endIdx--;
    }
    
    //순열 출력...
}
```

