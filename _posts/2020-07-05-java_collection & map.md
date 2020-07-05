---
title: "Collection과 Map"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-07-05T14:01:00
---

### Collection과 Map Inteface의 계층

Collection 과 Map 모두 Collections Framework의 멤버이다.

(**Collections Framework ?**  자바에서 데이터 그룹을 다루는 표준화된 프로그래밍 방식을 체계화해둔 것)

|            |              |         |                           |                           |
| ---------- | ------------ | ------- | ------------------------- | ------------------------- |
| *Iterable* | *Collection* | *List*  | **ArrayList**             |                           |
|            |              |         | **LinkedList**            |                           |
|            |              |         | **Vector**                | **Stack**                 |
|            |              | *Queue* | **PriorityQueue**         |                           |
|            |              |         | **<del>LinkedList</del>** |                           |
|            |              |         | *Deque*                   | **ArrayDeque**            |
|            |              |         |                           | **<del>LinkedList</del>** |
|            |              | *Set*   | **HashSet**               | **LinkedHashSet**         |
|            |              |         | *SortedSet*               | **TreeSet**               |
| -          | -            | *Map*   | **HashMap**               | **LinkedHashMap**         |
|            |              |         | *SortedMap*               | **TreeMap**               |
|            |              |         | **Hashtable**             | **Properties**            |

*(Interface*, **Class**)



### List

**데이터 저장 순서를 유지**하는 데이터 집합으로 **데이터의 중복을 허용**한다.

- ArrayList 와 Vector  
  ArrayList는 Vector를 개선한 것으로 구현 원리와 기능이 비슷하다. 둘 다 배열을 기반으로 만들어져 데이터가 **연속적**이다.

  - 내부적인 배열의 크기는 변경할 수 없기 때문에 용량 변경 시 새로운 배열을 생성한 후 데이터를 복사해서 옮겨줘야 한다.  
  - 순차적인 데이터의 추가, 삭제는 가장 빠르다. (순차적인 추가, 삭제는 추가는 앞에서 부터, 삭제는 뒤에서 부터 진행되는 것을 말한다.)
  - 비순차적인 데이터의 추가, 삭제는 느리다. (중간에 데이터를 추가, 삭제 할 경우 데이터의 이동이 필요하다.)

  - 임의의 요소에 대한 접근성이 좋다.

- LinkedList  
  불연속적인 데이터의 주소값을 연결한 구조이기 때문에 데이터가 **비연속적**이다.

  - 비순차적인 데이터의 추가, 삭제가 효율적이다.
  - 임의의 요소에 대한 접근성이 좋지 않다. (비연속적인 데이터 구조 때문에 목표 지점까지 처음부터 탐색해야한다.) 데이터가 많아질수록 비효율적이다.
  - 내부적으로는 단방향이 아닌 Doubly-Linked List 로 구현되어 있다.

- ArrayList VS LinkedList  

  |                                | ArrayList | LinkedList |
  | ------------------------------ | --------- | ---------- |
  | 임의의 요소에 대한 접근성      | 빠르다    | 느리다     |
  | 비순차적인 데이터의 추가, 삭제 | 느리다    | 빠르다     |
  | 순차적인 데이터의 추가, 삭제   | 빠르다    | 느리다     |

  데이터의 추가, 삭제가 잦다면 LinkedList를 사용하는 것이 좋다.

- Stack  
  순차적으로(추가는 앞에서 부터, 삭제는 뒤에서 부터) 데이터를 추가, 삭제를 하는 Stack은 배열 기반인 Vector를 상속받는다.



### Queue

자바에서는 인터페이스 형태로만 제공한다. Queue의 인터페이스를 구현한 클래스를 사용하면 된다. 대표적으로는 LinkedList와 PriorityQueue가 있다.  
항상 맨 앞의 데이터를 삭제하는 Queue의 경우 LinkedList를 활용하여 구현하는 것이 좋다. (배열 기반의 자료구조를 사용하게 되면 맨 앞 데이터의 공백을 채우기 위해 데이터 이동이 발생한다.)

- PriorityQueue  
  - 우선순위가 높은 데이터 부터 꺼내진다.
  - null 저장 불가
  - Heap의 형태로 데이터가 저장된다. (Heap은 배열 기반으로 만들어진 자료구조)
- Deque  
  양쪽 끝에서 추가, 삭제할 수 있는 (덕분에 Stack과 Queue의 기능을 모두 갖는다.) Queue의 변형으로 Queue 와 마찬가지로 인터페이스 형태로만 제공된다. 이를 구현한 대표적인 클래스는 ArrayDeque와 LinkedList 가 있다.



### Set

**데이터 저장 순서가 유지되지 않는** 데이터 집합으로 **데이터의 중복을 허용하지 않는다.**

- HashSet  
  HashSet은 새로운 요소를 추가할 때 기존에 존재하는 요소인지 확인하기 위해 추가하려는 요소의 `equals()` 메서드와 `hashCode()` 메서드를 호출한다. 만약 사용자 지정 클래스의 객체를 HashSet에 대상으로 사용할 경우 두 메서드를 오버라이딩하여 목적에 맞게 사용할 수 있다. (HashMap 사용 시에도 마찬가지이다.)

  ```java
  class MyClass{
    String str;
    int i;
    
    //...
    @Override
    public boolean equals(Object obj){
    	if(obj instanceof MyClass){
        MyClass tmp = (MyClass)obj;
        return str.equals(tmp.str) && i == tmp.i;
      } 
      return false;
    }
    
   	@Override
    public int hashCode(){
      return Objects.hash(str, i); //JDK 1.8
    }
  }
  
  //...
  Set s = new HashSet<MyClass>();
  s.add(new MyClass(1, "a"));
  s.add(new MyClass(1, "a")); //false 반환
  ```

  - `hashCode()` 오버라이딩 구현 조건  
    1. `equals()` 오버라이딩 구현 시 사용된 멤버변수의 값이 바뀌지 않는다면 `hashCode()`은 반환값은 항상 동일해야한다.
    2. 두 객체에 대한 `equals()`가 `true`라면 두 객체에 대한 `hashCode()` 반환값은 동일해야한다.
    3. 두 객체에 대한 `equals()`가 `false`인 경우에도 객체에 대한  `hashCode()` 반환값은 동일해도 된다. (두 객체에 대한 `hashCode()` 반환값이 같다고 해서 `equals()` 메서드의 결과가 반드시 `true` 이어야 하는 것은 아니다.) 하지만 효율성이 떨어진다.

  

  참고) `hashCode()`  
  `String` : 문자열 내용으로 해시코드를 생성하기 때문에 같은 문자열에 대해서는 항상 동일하다.  
  `Object` : 객체의 주소로 해시코드를 생성하기 때문에 실행때 마다 달라진다.



- LinkedHashSet  
  데이터의 저장 순서를 유지하면서 데이터를 중복을 허용하지 않는다.



### Map

*Key와 Value의 쌍으로 이루어진 데이터(Entry)* 집합으로 **데이터 저장 순서가 유지되지 않으며 Key의 중복은 허용하지 않지만 Value의 중복은 허용한다.**

- HashMap 과 Hashtable  
  HashMap는 Hashtable를 개선한 것으로 구현 원리와 기능이 비슷하다.  

  - HashMap은 Key와 Value 값으로 null 을 허용한다.
  - 이미 존재하는 Key 값을 이용하여 다른 Value를 넣을때 가장 최근에 삽입된 데이터가 저장된다.
  - Hashing을 사용하기 때문에 많은 양의 데이터 검색에 효율적이다.
  - 위 HashSet 과 마찬가지로 사용자 지정 클래스의 객체를 대상으로 할 때에는 `equals()` 메서드와 `hashCode()` 메서드의 오버라이딩이 필요하다.

  ```java
  //HashMap의 탐색
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  //...
  for(Entry<String, Integer> e : map.entrySet()){
    e.getKey();
    e.getValue();
  }
  ```

  참고) Hashing  
  해시함수를 이용하여 데이터를 해시테이블에 저장하고 검색하는 기법으로 데이터가 저장되어 있는 곳을 알려주기 때문에 다량의 데이터 검색에 유용하다. 해싱을 이용한 컬렉션 클래스는 HashMap, HashSet 등이 있다.  
  해시함수에서 사용되는 자료구조는 배열과 링크드리스트의 조합이다.

