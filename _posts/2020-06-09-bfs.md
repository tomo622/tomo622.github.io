---
title: "BFS (Breadth First Search)"
excerpt: ""
categories:
 - algorithm
last_modified_at: 2020-06-10T01:10:00
---

### 이론

- 맹목적 탐색

- 트리, 그래프 같은 비선형구조의 완전탐색 방법 중 하나

- 경로가 긴 경우 공간, 시간 복잡도가 급격히 증가

- 두 노드 사이의 임의의 경로 탐색

- 가중치가 없거나 모두 같은 가중치를 갖는 경우 두 노드 사이의 최단 경로 보장  
  출발 노드로 부터 인접한 모든 노드를 우선적으로 탐색하는 BFS의 특성 상, 도착 노드는 항상 최단 경로를 갖는다.  
  가중치가 있는 그래프의 경우 이동해온 경로와 누적된 가중치의 값은 비례하지 않을 수 있기 때문에 최단 경로를 보장할 수 없다.

- 시간 복잡도

  |             | 시간 복잡도 |
  | ----------- | ----------- |
  | 인접 행렬   | $O(N^2)$    |
  | 인접 리스트 | $O(N+E)$    |

- 과정  

  1. 출발 노드를 방문하고 큐에 넣는다.
  2. 큐에서 노드를 꺼내 자식 노드를 방문하고 큐에 넣는다. 이미 방문했던 노드는 제외한다.
  3. 큐가 모두 비워질 때까지 2번 과정을 반복한다.  ![bfs_2](https://user-images.githubusercontent.com/19742979/71103178-03a7ea00-21fd-11ea-83cc-ef41a447ed82.png)
          ![bfs_3](https://user-images.githubusercontent.com/19742979/71103180-03a7ea00-21fd-11ea-9a97-2ee6f6ae41fd.png)
          ![bfs_4](https://user-images.githubusercontent.com/19742979/71103177-03a7ea00-21fd-11ea-82f4-995b08353898.png)

- 연결되어 있지 않은 그래프가 존재하는 경우  
  ![bfs_1](https://user-images.githubusercontent.com/19742979/71006485-ba866600-2128-11ea-9f99-aad1a2de684a.png)



### 문제에서의 활용

- **최단거리**를 구하거나 어떤 데이터를 **확산**시키는 경우 자주 사용된다.
- 특정 조건에 부합하면서 *인접하는* 모든 데이터를 *한 번에 제거/변경해야 하는 경우*에 활용할 수 있다.



### 코드

```java
final int NODE_CNT = 7; //정점 개수
final int EDGE_CNT = 7; //간선 개수
//간선 정보
final int[] edge_from = {0,0,1,1,3,4,2};
final int[] edge_to = {1,2,3,4,5,5,6};

//...
int[][] adMatrix = new int[NODE_CNT][NODE_CNT]; //인접행렬

for(int i = 0; i < EDGE_CNT; i++) {
    adMatrix[edge_from[i]][edge_to[i]] = 1;
}

//...
public void bfs(final int ad[][], final int first) {
    Queue<Integer> q = new LinkedList<Integer>();
    boolean[] visit = new boolean[NODE_CNT];

    q.add(first);
    visit[first] = true;

    int cur;
    while(!q.isEmpty()) {
        cur = q.poll();

        for(int i = 0; i < NODE_CNT; i++) {
            if(ad[cur][i] != 1 || visit[i]) continue;

            q.add(i);
            visit[i] = true;
        }
    }
}
```

```java
final int NODE_CNT = 7; //정점 개수
final int EDGE_CNT = 7; //간선 개수
//간선 정보
final int[] edge_from = {0,0,1,1,3,4,2};
final int[] edge_to = {1,2,3,4,5,5,6};

//...
List<Integer>[] adList = new ArrayList[NODE_CNT]; //인접리스트

for(int i = 0; i < NODE_CNT; i++) {
    adList[i] = new ArrayList<Integer>();
}
for(int i = 0; i < EDGE_CNT; i++) {
    adList[edge_from[i]].add(edge_to[i]);
}

//...
private static void bfs(final List<Integer>[] ad, final int first) {
    Queue<Integer> q = new LinkedList<Integer>();
    boolean[] visit = new boolean[NODE_CNT];

    q.add(first);
    visit[first] = true;

    int cur;
    while(!q.isEmpty()) {
        cur = q.poll();

        for(Integer n : ad[cur]) {
            if(visit[n]) continue;

            q.add(n);
            visit[n] = true;
        }
    }
}
```

```java
class Point {
    public int r,c;
    public Point(int r, int c) {
        this.r = r;
        this.c = c;
    }
}
final int N = 5; //맵의 가로, 세로 크기
final int[] dr = {-1,1,0,0};
final int[] dc = {0,0,-1,1};

//...
int[][] map = {
    {0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0}
};

//...
//확산
private static void bfs(int[][] map, final Point start) {
    Queue<Point> q = new LinkedList<Point>();

    q.add(start);
    map[start.r][start.c] = 1;

    Point cur;
    int nr, nc;
    while(!q.isEmpty()) {
        cur = q.poll();
        
        for(int d = 0; d < 4; d++) {
            nr = cur.r + dr[d];
            nc = cur.c + dc[d];

            if(!(nr >= 0 && nr < N && nc >= 0 && nc < N) || map[nr][nc] != 0) continue;

            q.add(new Point(nr,nc));
            map[nr][nc] = 1;
        }
    }
}
```

```java
//...
int[][] map = {
    {0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0},
    {0, 0, 0, 1, 0},
    {0, 0, 0, 0, 0}
};

//...
//최단거리 찾기
private static int bfs(int[][] map, final Point start) {
    Queue<Point> q = new LinkedList<Point>();
    boolean[][] visit = new boolean[N][N];

    q.add(start);
    visit[start.r][start.c] = true;

    Point cur;
    int nr, nc;
    int length;
    int depth = 0; //BFS의 깊이가 목표를 찾았을 때의 최단거리가 된다.
    while(!q.isEmpty()) {
        length = q.size();
        depth++;

        for(int i = 0; i < length; i++) {
            cur = q.poll();	

            for(int d = 0; d < 4; d++) {
                nr = cur.r + dr[d];
                nc = cur.c + dc[d];

                if(!(nr >= 0 && nr < N && nc >= 0 && nc < N) || visit[nr][nc]) continue;

                if(map[nr][nc] == 1) return depth; //목표를 찾으면 바로 반환한다.
                
                q.add(new Point(nr,nc));
                visit[nr][nc] = true;
            }
        }
    }

    return -1;
}
```

