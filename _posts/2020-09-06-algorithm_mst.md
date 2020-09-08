---
title: "MST (Minimum Spanning Tree)"
excerpt: "Spanning Tree, Prim, Kruskal Algorithm"
use_math: true
categories:
 - algorithm
last_modified_at: 2020-09-06T20:28:00
---

# Spanning Tree

신장 트리라고 하며 **모든 정점을 포함하는 트리**이다. 즉 *n개의 정점을 갖는 그래프에서 n-1개의 간선을 갖는 최소 연결 그래프*를 말한다. 때문에 *사이클을 형성할 수 없다*는 특징이 있다.

하나의 그래프에는 여러가지 Spanning Tree가 있을 수 있다.

# Minimum Spanning Tree

Spanning Tree 중 간선의 **가중치 합이 최소인 트리**이다. Spanning Tree의 특징을 그대로 갖는다.

MST의 구현 방법에는 Kruskal 알고리즘과 Prim 알고리즘이 있다. 아래 표는 두 알고리즘의 차이를 보여준다.

|             | Kruskal                                                      | Prim                                |
| ----------- | ------------------------------------------------------------ | ----------------------------------- |
| 사용        | 적은 수의 간선을 갖는 그래프에 적합                          | 많은 수의 간선을 갖는 그래프에 적합 |
|             | 간선 선택을 기준으로 함  <br />간선의 가중치로 오름차순 정렬되어 있어야함 | 정점 선택을 기준으로 함             |
| 시간 복잡도 | $$O(elog_2e)$$                                               | $$O(n^2)$$                          |

# Prim Algorithm

## 과정

1. 시작 정점을 MST 집합에 포함한다.
2. MST 집합에 포함된 정점 중에서 가중치가 가장 작은 간선으로 연결된 목적지 정점을 선택하여 MST 집합에 포함한다. (이때, 이미 MST 집합에 포함되어있는 노드는 제외한다.)
3. MST의 간선 개수가 n-1개가 될 때까지 2단계를 반복한다.

## 구현

```java
int N; // 정점 개수
int E; // 간선 개수
int[][] adMatrix; // 인접행렬
boolean[] visit; // MST 집합에 포함여부
int sum = 0; // 최소 이동 경로의 가중치 합

//...
// 인접행렬에 데이터 넣기
StringTokenizer st = null;
for(int i = 0; i < E; i++) {
  st = new StringTokenizer(br.readLine());
  int from = Integer.parseInt(st.nextToken())-1;
  int to = Integer.parseInt(st.nextToken())-1;
  int weight = Integer.parseInt(st.nextToken());
  adMatrix[from][to] = weight; // 양방향으로 넣어줘야한다.
  adMatrix[to][from] = weight;
}

prim();
System.out.println(sum);
}

private void prim() {
  int cnt = 0; // MST의 간선 개수

  // 시작 정점 지정
  int curNode = 0;
  visit[curNode] = true;
  cnt++;

  // MST의 간선 개수가 n-1개 일 때까지 반복
  while(cnt <= N-1) {
    // 가중치가 가장 작은 인접 노드 찾기
    int min = Integer.MAX_VALUE;
    int minNode = -1;

    for(int n = 0; n < N; n++) {
      if(!visit[n]) continue; // MST 집합에 포함된 정점만 확인

      for(int to = 0; to < N; to++) {
        if(visit[to] || adMatrix[n][to] == 0) continue; // 목적지 정점이 이미 MST 집합의 원소인 경우 제외

        int w = adMatrix[n][to];
        if(min > w) {
          min = w;
          minNode = to;
        }
      }
    }

    if(min != Integer.MAX_VALUE && minNode != -1) {
      System.out.println(curNode + "-" + minNode);

      visit[minNode] = true;
      sum += min;
      curNode = minNode;
      cnt++;
    }
  }
}
}
```

```
// input
7
11
1 7 12
1 4 28
1 2 67
1 5 17
2 4 24
2 5 62
3 5 20
3 6 37
4 7 13
5 6 45
5 7 73

// output
0-6
3-6
0-4
2-4
1-3
2-5
123
```

(아래 Kruskal 알고리즘도 같은 결과를 같는다.)

# Kruskal Algorithm

## 과정

1. 간선의 가중치를 기준으로 오름차순 정렬한다.
2. 첫 번재 간선 부터 선택한다. (가중치가 가장 낮은 것 부터 선택) 이때 사이클을 형성하는 간선은 제외한다.
3. 해당 간선을 MST 집합에 추가한다.
4. 모든 간선을 탐색할 때까지 2-3단계를 반복한다.

2단계에서 사이클이 형성되는지 판별하기 위해 Union-Find가 사용된다. 선택된 간선 양 끝에 있는 정점이 이미 같은 집합에 있는지 확인한다. 두 정점이 이미 같은 집합에 속하는 경우는 이미 연결되어 있다는 뜻이다. 따라서 두 정점을 연결할 경우 사이클이 형성된다.

## 구현

```java
class Edge implements Comparable<Edge>{
  public int n1, n2, w;
  public Edge(int n1, int n2, int w) {
    this.n1 = n1;
    this.n2 = n2;
    this.w = w;
  }

  @Override
  public int compareTo(Edge o) {
    return this.w - o.w;
  }
}

static ArrayList<Edge> edges = new ArrayList<Edge>();
static int N; // 정점 개수 
static int E; // 간선 개수 
static int sum = 0; // 최소 이동 경로의 가중치 합

//... 
// 간선 정보 넣기
StringTokenizer st = null;
for(int i = 0; i < E; i++) {
  st = new StringTokenizer(br.readLine());
  int n1 = Integer.parseInt(st.nextToken())-1;
  int n2 = Integer.parseInt(st.nextToken())-1;
  int w = Integer.parseInt(st.nextToken());
  edges.add(new Edge(n1,n2,w));
}

//...
public void kruskal() {
  Collections.sort(edges); // 가중치 기준 오름차순 정렬

  UnionFind uf = new UnionFind(N);

  for(Edge e : edges) {
    int r1 = uf.find(e.n1);
    int r2 = uf.find(e.n2);

    if(r1 == r2) continue; // 사이클 형성, 두 정점이 이미 같은 집합에 있다. 이미 연결되어 있다.

    // 간선을 선택한다.
    System.out.println(e.n1 + "-" + e.n2);
    sum += e.w;

    // 두 정점을 연결한다.
    uf.union(e.n1, e.n2);

    int t1 = uf.find(e.n1);
    int t2 = uf.find(e.n1);
    if(t1==t2) {
      int a  =1; 
    }
  }
}

//...
class UnionFind{
  //...
}
```

