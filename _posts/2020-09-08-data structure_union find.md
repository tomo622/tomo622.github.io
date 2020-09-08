---
title: "Union-Find"
excerpt: ""
use_math: true
categories:
 - data structure
last_modified_at: 2020-09-06T20:28:00
---

서로소 부분 집합들로 이루어진 원소들에 대한 정보를 저장하고 조작하는 자료구조이다. 서로소 집합(Disjoint Set), 병합-찾기 집합(Merge-Find Set) 이라고도 불린다. (서로소 집합이란, 공통 원소가 없는 집합을 말한다.)

트리 구조로 구현된다.

Union-Find는 다음 세 가지 연산을 제공한다.

- Union: 두 개의 집합을 하나로 합친다.
- Find: 어떤 원소에 대한 대표 원소를 반환한다.
- MakeSet: 특정 한 원소만을 가지는 집합을 만든다.

`union()` 수행 시 시간 복잡도는 `find()` 연산 시간 복잡도에 의지한다. (`union()` 내부에서 `find()` 연산이 사용됨)

# 최적화

## Path Compression

Union-Find의 트리 구조는 최악의 경우 연결 리스트 형태를 갖는다. 즉 n개의 노드를 갖는 트리라면, n-1의 높이를 갖게 되어 `find()` 연산 시 $$O(n)$$ 의 시간 복잡도를 갖게된다.

Path Compression은 이와 같은 문제를 해결하기 위한 최적화 기법으로, `find()` 연산을 수행 하면서 만나는 모든 노드들의 부모 노드를 root 노드로 변경한다. 이 과정을 통해 트리 구조가 평탄해진다.

## Union by rank

이 역시 트리의 높이가 커져 실행 시간이 늘어나는 것을 방지하기 위한 최적화 기법이다. Path Compression은 `find()` 수행 시에 최적화를 하는 방법이라면, Union by rank는 `union()` 수행 시에 최적화한다.

높이가 작은 트리를 높이가 더 높은 트리의 root 아래에 추가하는 방법이다. 하지만 실제 구현 시 Path Compression과 함께 사용될 경우 각 트리의 정확한 높이를 관리하기 어렵다. 따라서 rank 값을 두어 관리하게 된다.

- rank 값은 최초 `makeSet()` 연산을 통해 한 개의 원소를 갖는 모든 트리에서 0으로 초기화 된다.
- `union()` 연산 시 **같은 rank 값을 갖는 두 트리가 합쳐질 경우** 상단이 되는 트리의 **rank 값을 1 증가** 시킨다.
- rank 값이 차이가 있는 경우 rank가 높은 트리의 root 아래에 다른 트리를 추가한다.

## 구현

```java
class UnionFind{
  private int nodeCount;
  private int[] parent;
  private int[] rank;

  public UnionFind(int nodeCount) {
    this.nodeCount = nodeCount;
    parent = new int[nodeCount];
    rank = new int[nodeCount];

    init();
  }

  public void init() {
    for(int i = 0; i < nodeCount; i++) {
      makeSet(i);
    }
  }

  public void makeSet(int n) {		
    parent[n] = n;
    rank[n] = 0;
  }

  public int find(int n) {		
    if (parent[n] == n) {
      return n;
    }
    else {
      return parent[n] = find(parent[n]); // path compression
    }
  }

  public void union(int n1, int n2) { 		
    n1 = find(n1);
    n2 = find(n2);

    if(n1 == n2)
      return;

    // union by rank
    if(rank[n1] < rank[n2]) {
      parent[n1] = n2;
    } else {
      parent[n2] = n1;

      if(rank[n1] == rank[n2])
        rank[n1]++;
    }
  }
}
```

## 테스트

```java
final int NODE_COUND = 10;
UnionFind uf = new UnionFind(NODE_COUND);
uf.union(0, 1);
uf.union(2, 3);
uf.union(4, 9);
uf.union(1, 2);
uf.union(5, 4);
uf.union(7, 4);
//{0,1,2,3},{4,5,7,9},{6},{8}
for(int i = 0; i < NODE_COUND; i++) {
  System.out.println("root of " + i + " is " + uf.find(i));
}
```

```
root of 0 is 0
root of 1 is 0
root of 2 is 0
root of 3 is 0
root of 4 is 4
root of 5 is 4
root of 6 is 6
root of 7 is 4
root of 8 is 8
root of 9 is 4
```

