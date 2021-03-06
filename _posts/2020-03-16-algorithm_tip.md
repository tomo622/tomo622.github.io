---
title: "알고리즘 Tip"
excerpt: ""
use_math: true
categories:
 - algorithm
last_modified_at: 2020-07-07T23:28:00
---

### 생각

- 반시계 회전은 시계방향 회전을 3회 한 것과 동일하다.
- 반복문 안에서 함수를 여러번 호출하기 보다는 함수 내부에서 반복문을 수행하고 결과를 반환하자.
- 문제 조건에서 범위가 큰 경우 생각해볼만 한 것들
  - 자료형 : int -> long
  - 정해진 케이스에 따라 정해진 답이 반복된다면 메모이제이션
  - 범위를 반으로 나누어 실행해도 동일한 답을 얻을 수 있다면 Meet in the middle



### 자주 실수하는 것

- 나누기 연산 시 나누는 수가 0인 경우 예외처리 (예외처리 안하면 런타임 에러 발생)
- 재귀함수나 DFS를 통해 Map (2차원 배열)을 탐색할 때, 원본 Map을 Copy 해 두고 다음 탐색을 위해 Map을 복원하는 과정이 필요하다. 이때 **clone을 사용하여 값을 복사**하는 것이 좋다.

