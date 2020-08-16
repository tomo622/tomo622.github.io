---
title: "동등 비교"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-07-19T01:13:00
---

### 동등 비교 연산자(==)

| 대상                             |             |
| -------------------------------- | ----------- |
| Primitive Type VS Primitive Type | 값 비교     |
| Primitive Type VS Reference Type | 값 비교     |
| Reference Type VS Reference Type | 주소값 비교 |

```java
int i1 = 1;
int i2 = 1;
System.out.println(i1 == i2); //값 비교

Integer ii1 = 1;
System.out.println(i1 == ii1); //값 비교

Integer ii2 = 128;
Integer ii3 = 128;
System.out.println(ii2 == ii3); //주소값 비교
```



### equals()

- Object 클래스의 메소드  
- Reference Type 간에 **주소값을 기반**으로 동등 비교를 한다.

```java
//Object Class
public boolean equals(Object obj) {
  return (this == obj); //Reference Type 간 동등 비교 연산자는 주소값을 비교한다.
}
```

- **자바에서 Object 클래스를 상속 받는 대부분의 클래스에서는 값을 기반으로 동등 비교하도록 오버라이딩 되어있다.** *`equals()` 메서드 자체가 값을 비교하는 것이 아니다.* 때문에 주소가 서로 다른 두 객체도 데이터가 모두 일치하다면 동등하다고 판단된다.

```java
Object obj1 = new Object();
Object obj2 = new Object();
System.out.println(obj1.equals(obj2)); //true. 두 객체의 주소값을 비교한다.

ArrayList<Integer> arr1 = new ArrayList<Integer>();
ArrayList<Integer> arr2 = new ArrayList<Integer>();
System.out.println(arr1.equals(arr2)); //true. 두 객체가 갖고있는 데이터가 없다.

arr1.add(new Integer(1));
arr2.add(new Integer(2));
System.out.println(arr1.equals(arr2)); //false. 두 객체가 갖고있는 데이터가 일치하지 않는다.

String str1 = "abc";
String str2 = new String("abc");

System.out.println(str1 == str2); //false. 주소값을 비교하기 때문에
System.out.println(str1.equals(str2)); //true. 데이터를 비교하기 때문에
```

- 사용자 정의 클래스의 경우 `equals()` 의 오버라이딩을 통해 값을 기반으로 동등 비교를 하도록 재정의하지 않는다면 주소값을 기준으로 판단된다.

```java
class MyClass{
  int i;
  String str;
  public MyClass(int i, String str) {
    this.i = i;
    this.str = str;
  }
}
//...
MyClass myClass1 = new MyClass(1, "abc");
MyClass myClass2 = new MyClass(1, "abc");
System.out.println(myClass1.equals(myClass2)); //false. 두 객체가 갖는 데이터는 동일하지만 equals() 메소드는 주소값을 기반으로 판단한다.
```

```java
class MyClass{
  int i;
  String str;
  public MyClass(int i, String str) {
    this.i = i;
    this.str = str;
  }
  
  //객체가 갖는 값을 기반으로 동등 비교하도록 재정의
  @Override
  public boolean equals(Object obj) {
    if(obj == this) //객체간 주소값 비교, 자기 자신의 주소라면 true 반환
      return true;
    if(!(obj instanceof MyClass)) //객체 타입 검사
      return false;
    
    MyClass tmp = (MyClass)obj;
    return this.i == tmp.i && this.str.equals(tmp.str); //데이터 비교
  }
}
//...
MyClass myClass1 = new MyClass(1, "abc");
MyClass myClass2 = new MyClass(1, "abc");
System.out.println(myClass1.equals(myClass2)); //true.
```



### hashCode()

- Object 클래스의 메소드  
- **주소값을 기반**으로 해쉬 값을 생성한다.

```java
//Object Class
public native int hashCode(); //메모리 주소값으로 해쉬 값을 생성하는 네이티브 코드를 호출한다.
```


- 위 `equals()` 메서드와 마찬가지로, **자바에서 Object 클래스를 상속 받는 대부분의 클래스에서는 값을 기반으로 해쉬 값을 생성하도록 오버라이딩 되어있다.**

```java
Object obj1 = new Object();
Object obj2 = new Object();
System.out.println(obj1.hashCode() == obj2.hashCode()); //false. 주소값으로 생성

ArrayList<Integer> arr1 = new ArrayList<Integer>();
ArrayList<Integer> arr2 = new ArrayList<Integer>();
System.out.println(arr1.hashCode() == arr2.hashCode()); //true. 데이터로 생성, 두 객체가 갖고있는 데이터가 없다.

arr1.add(new Integer(1));
arr2.add(new Integer(2));
System.out.println(arr1.hashCode() == arr2.hashCode()); //false. 데이터로 생성, 두 객체가 갖고있는 데이터가 일치하지 않는다.

String str1 = new String("abc");
String str2 = "abc";
System.out.println(str1.hashCode() == str2.hashCode()); //true. 데이터로 생성
```

- 사용자 정의 클래스의 경우 `hashCode()` 의 오버라이딩을 통해 값을 기반으로 해쉬 값을 생성하도록 재정의하지 않는다면 주소값을 기준으로 해쉬 값이 생성된다.

```java
class MyClass{
  int i;
  String str;
  public MyClass(int i, String str) {
    this.i = i;
    this.str = str;
  }
}
//...
MyClass myClass1 = new MyClass(1, "abc");
MyClass myClass2 = new MyClass(1, "abc");
System.out.println(myClass1.hashCode() == myClass2.hashCode()); //false. 주소값을 기반으로 해쉬값을 생성한다.
```

```java
class MyClass{
  int i;
  String str;
  public MyClass(int i, String str) {
    this.i = i;
    this.str = str;
  }
	
  //데이터를 기반으로 해쉬값을 생성할 수 있도록 재정의
  @Override
  public int hashCode() {
    return Objects.hash(i, str); //JDK 1.8 부터 제공되는 Objects.hash() 메서드를 이용하면 매개값을 기반으로 해쉬값을 간단하게 생성할 수 있다.
  }
}
//...
MyClass myClass1 = new MyClass(1, "abc");
MyClass myClass2 = new MyClass(1, "abc");
System.out.println(myClass1.hashCode() == myClass2.hashCode()); //true.
```



### equals() 와 hashCode() 관계

`hashCode()` 는 객체의 유일한 값을 보장하지 못한다. 즉, 서로 다른 객체로 부터 같은 해쉬 값을 얻는 해쉬 값 충돌 (Hash Collision)이 발생할 수 있다. 때문에 자바에는 `hashCode()` 에 대해 다음과 같은 규약이 존재한다.

1. `equals()` 오라버이딩 구현 시 사용된 값(데이터)가 변경되지 않았다면 `hashCode()` 의 반환값에도 변경이 없어야한다.
2. 두 객체에 대한 `equals()` 가 `true` 라면 두 객체는 동일한 `hashCode()` 반환값을 가져야한다.
3. 두 객체에 대한 `equals()` 가 `false` 이어도 두 객체의 `hashCode()` 반환값이 다를 필요는 없다. (하지만 비효율적)

이러한 규약 때문에 `equals()` 와 `hashCode()` 의 재정의 함께하는 것이 좋다.

> 규약 3번 보충)  
> HashSet이나 HashMap 등 객체간 동등 비교가 필요한 클래스에서는 보통 `hashCode()` 를 통해 같은 객체인지 비교한 후 같은 객체라면 `equals()` 로 비교하게 된다. 때문에 위 규약 3번에서 `hashCode()` 반환값이 다를 필요는 없다고 하지만 서로 다른 반환값을 갖는것이 효율적이다.



### String 비교 이슈

- 문자열 초기화 방법 비교

  |           | `String str = new String("abc")`    | `String str = "abc"`                                         |
  | --------- | ----------------------------------- | ------------------------------------------------------------ |
  | 메모리    | Heap                                | String Constant Pool (Heap 영역)                             |
  | 생성 개수 | 매번 새롭게 생성 (매번 다른 주소값) | 1개 (이미 문자열 상수풀에 존재하는 문자열은 그 주소값을 반환) |

```java
String str1 = "aaa"; //문자열 상수풀에 'aaa'가 저장됨
System.out.println(str1 == "aaa"); //true. 'aaa'는 문자열 리터럴로 문자열 상수풀에 저장되어있는 'aaa'와 같은 주소값을 갖는다.

String str2 = "aaa";
System.out.println(str1 == str2); //true.

String str3 = new String("aaa"); //heap 영역에 저장됨
System.out.println(str1 == str3); //false. str1과 다른 주소값을 갖는다.

System.out.println(str1.equals(str3)); //true. 값을 비교한다.
```



### 정수형 타입에 대응하는 Wrapper Type 비교 이슈, Cache  
JVM은 최적화를 위해 정수형 타입에 대응하는 Wrapper Type (Byte, Short, Integer, Long, Character) 에 대해 특정 캐시값을 갖는다. 각 타입에 대한 캐시값 범위는 아래와 같고, Integer 의 경우 설정 값으로 변경 가능하다.

| Type                       | Range    |
| -------------------------- | -------- |
| Byte, Short, Integer, Long | -128~127 |
| Character                  | 0~127    |

캐시값 범위 내의 데이터로 초기화를 하게되면 새로운 인스턴스를 생성하는 것이 아닌 캐싱된 데이터의 주소값을 반환한다. 따라서 캐시값 범위 내에 있는 특정 데이터로 초기화한 여러 객체들은 모두 동일한 주소값을 갖는다.

캐시값 범위 내의 데이터로 초기화를 해도 새로운 주소값을 할당 받고 싶다면 `new` 를 사용하면 된다.

```java
Integer i1 = 1;
Integer i2 = 1;
System.out.println(i1 == i2); //true. 동일한 캐싱 데이터 주소값

Integer i3 = 128;
Integer i4 = 128;
System.out.println(i3 == i4); //false.

Integer i5 = new Integer(1);
Integer i6 = new Integer(1);
System.out.println(i5 == i6); //false.
```



