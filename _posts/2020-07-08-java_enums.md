---
title: "Enums"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-07-09T16:03:00
---

- 일반적인 사용


```java
enum E{A, B, C}
E e = E.A;
System.out.println(e); //상수 이름을 출력: A
```



- 비교하기

```java

E e = E.A;

if(e == E.B){}
if(e.equals(E.B)){}
if(e < E.B){} //error. <, > 연산자는 사용할 수 없다.
if(e.compareTo(E.B) > 0){}

switch(e){
  case A: //E.A 로 쓰면 안된다.
    break;
  case B:
    break;
  case C:
    break;
}
```



- java.lang.Enum 사용하기

```java
E[] arr = E.values(); //열거형의 상수를 배열에 담는다.
for(E item : arr){
  System.out.print(item + " "); //상수 이름을 출력: A B C
}

 //열거형 E에서 상수 이름으로 해당 상수를 참조한다.
E e = E.valueOf("test1");
E e = Enum.valueOf(E.class, "test1");
  
E e = E.A;
e.name(); //열거형 상수의 이름을 문자열로 반환
e.ordinal(); //열거형 상수의 순서를 반환(0부터)
e.getDeclaringClass(); //열겨형의 클래스 타입 명을 가져온다.

```



- 변경

```java
enum E{
  A(10), B(100), C(1000);
  
  private final int value;
  
  E(int value){ //기본적으로 private
    this.value = value;
  }
  
  public int getValue(){ return value; }
}

E e = E.A;
e.getValue(); //10
e.ordinal(); //0 (ordinal은 열거형 상수의 순서일 뿐이다.)
```

```java
enum E{
  A(10, 'A'), B(100, 'B'), C(1000, 'C');
  
  private final int value;
  private final char symbol;
  
  E(int value, char symbol){ //기본적으로 private
    this.value = value;
    this.symbol = symbol;
  }
  
  public int getValue(){ return value; }
  public char getSymbol(){ return symbol; }
  public int getSize(){ return 3; } //메서드를 추가할 수 있다.
}
```

```java
enum E{
  A(10){
    int method(int addValue){
      return value + addValue;
    }
  },
  B(100){
    int method(int addValue){
      return value * addValue;
    }
  },
  C(1000){
    int method(int addValue){
      return value - addValue;
    }
  };
  
  protected final int value; //각 상수에서 접근 가능하도록 protected로 선언
  
  E(int value){
    this.value = value;
  }
  
  abstract int method(int addValue); //추상 메서드를 추가할 수 있다.
  
  public int getValue(){ return value; }
}

E e1 = E.A;
E e2 = E.B;
E e3 = E.C;

e1.method(1); //11
e2.method(2); //200
e3.method(3); //997
```

