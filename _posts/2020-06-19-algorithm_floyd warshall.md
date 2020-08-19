---
title: "Floyd-Warshall"
excerpt: ""
use_math: true
categories:
 - algorithm
last_modified_at: 2020-06-19T21:32:00
---

### 이론

- **가중치가 음이거나 양인 음수 사이클이 없는 가중 그래프에서 모든 정점들 사이의 최단거리 탐색**
  
- 음수 사이클이란 변의 가중치의 합이 음수를 갖는 사이클

- 시간 복잡도  
  $O(n^3)$

- 과정  

  1. 그래프를 인접행렬로 표현 (간선 없는 경우 가중치는 INF, 자기 자신의 경우 가중치 0)
  
  2. 경유지를 경유하지 않는 가중치의 합과 경유지를 거쳐 갈 때의 가중치의 합 중 작은 값을 선택하여 인접 행렬의 가중치를 갱신한다.
  
  3. 모든 정점을 한 번씩 경유지(K)로 지정하여 인접행렬을 갱신한다.
  
  4. 인접행렬의 최종 상태는 각 정점들 사이의 최단 거리(최소 가중치)를 나타낸다.  
      ![floyd-warshall1](https://user-images.githubusercontent.com/19742979/85133979-b6253c00-b276-11ea-8c3e-71cd42962cc6.png)  
      ![floyd-warshall2](https://user-images.githubusercontent.com/19742979/85133987-b7566900-b276-11ea-80d4-7e3c302e9d2a.png)  
      ![floyd-warshall3](https://user-images.githubusercontent.com/19742979/85133988-b7eeff80-b276-11ea-95a4-9c32c8c2be24.png)  
      ![floyd-warshall4](https://user-images.githubusercontent.com/19742979/85133990-b7eeff80-b276-11ea-9583-5ed3279a4de3.png)   
      (1,1)=0 vs (1,2)+(2,1)=4+INF -> 0  
      (1,2)=4 vs (1,2)+(2,2)=4+0 -> 4  
      (1,3)=-1 vs (1,2)+(2,3)=4-2 -> -1  
      (1,4)=8 vs (1,2)+(2,4)=4-10->-6  
      ![floyd-warshall5](https://user-images.githubusercontent.com/19742979/85133992-b8879600-b276-11ea-92ee-dcd1f563f38e.png)



### BFS와의 비교

|      | BFS                                                | Floyd-Warshall                                       |
| ---- | -------------------------------------------------- | ---------------------------------------------------- |
| 대상 | 가중치가 없거나 모두 같은 가중치를 갖는 비선형구조 | 가중치가 음이거나 양인 음수 사이클이 없는 비선형구조 |
| 목적 | 완전탐색, 최단거리, 확산                           | 모든 정점들 사이의 최단거리                          |



### 활용

- 음수 사이클의 감지  
  Floyd-Warshall의 결과에서 인접행렬의 대각 성분에 음수가 발견되는 경우, 하나 이상의 음수 사이클이 존재한다.



### 코드

```java
final int NODE_CNT = 4; //정점 개수
final int EDGE_CNT = 6; //간선 개수

final int[] weight = {4,-1,8,-2,-10,3}; //가중치
//간선 정보
final int[] edge_from = {0,0,0,1,1,2};
final int[] edge_to = {1,2,3,2,3,3};

//...
int[][] adMatrix = new int[NODE_CNT][NODE_CNT]; //인접행렬

for(int i = 0; i < NODE_CNT; i++) {
    for(int j = 0; j < NODE_CNT; j++) {
        if(i!=j)
            adMatrix[i][j] = Integer.MAX_VALUE;//INF
    }
}

for(int i = 0; i < EDGE_CNT; i++) {
    adMatrix[edge_from[i]][edge_to[i]] = weight[i];
}

//...
public void floyd_warshall(int[][] ad) {
    //k: 경유지, s: 출발지, e: 도착지
    for(int k = 0; k < NODE_CNT; k++) {
        for(int s = 0; s < NODE_CNT; s++) {
            for(int e = 0; e < NODE_CNT; e++) {
                int k_w; //경유지를 거쳐서 가는 가중치
                if(ad[s][k] >= Integer.MAX_VALUE || ad[k][e] >= Integer.MAX_VALUE)
                    k_w = Integer.MAX_VALUE;
                else
                    k_w = ad[s][k] + ad[k][e];

                ad[s][e] = Math.min(k_w, ad[s][e]); //경유지를 거치지 않고 가는 가중치와 비교하여 작은 가중치로 갱신
            }
        }
    }
}
```

```java
// 최단거리 경로 복원하기
// 플로이드 워셜은 최단 거리만 제공, 최단 거리 경로를 재현하기 위해서는 별도의 수정 필요
```

