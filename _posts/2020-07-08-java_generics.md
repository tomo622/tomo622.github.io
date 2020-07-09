---
title: "Generics"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-07-08T23:03:00
---

### Generics 란?

*컴파일 시 객체의 타입을 체크*해주는 기능으로 객체의 **타입 안정성**을 높이고 **형변환의 번거로움을 줄여준다.**

- 제네릭 타입 제거  
  제네릭 타입 도입 이전의 소스 코드와의 호환을 위해서 제네릭 타입의 제거 과정이 필요하다. 즉 `class MyClass<T>{...}`로 정의된 제네릭 클래스는 타입이 정해진 후 `class MyClass{...}`로 변경된다.
  1. 컴파일러가 제네릭 타입을 이용하여 소스 파일 검사
  2. 필요한 곳에 형변환
  3. 제네릭 타입 제거 (.class 파일에는 제네릭 타입이 없다.)



### 보편적으로 사용되는 기호

| 기호 |         |
| ---- | ------- |
| T    | Type    |
| E    | Element |
| K    | Key     |
| V    | Value   |
| R    | Result  |
| N    | Number  |



### 제한 조건

- 제네릭 타입 배열을 참조 변수로 선언은 할 수 있지만 생성(`new`)할 수는 없다.
- instanceof` 연산자의 피연산자로 제네릭 타입을 사용할 수 없다.



### 제네릭 클래스

- static 멤버에 제네릭 타입을 사용할 수 없다. (static 멤버 변수, 멤버 함수 모두)

```java
class A{...}
class B extends A{...}
class C{...}
interface I {...}

/************************************************
* 제네릭 클래스 정의 방법
************************************************/
class MyClass<T> { //MyClass 자체는 '원시 타입'이라 한다.
  T member;
  
  void setMember(T member){ this.member = member; }
  T getMember(){ return member; }
}

class SubClass<T> extends MyClass<T> {...}

/************************************************
* 제네릭 타입의 제한
************************************************/
class RestrictedClass1<T extends A>{...} //A이거나 그 자식 클래스만 제네릭 타입으로 지정할 수 있다.
class RestrictedClass2<T extends I>{...} //인터페이스로도 제한이 가능하다.
class RestrictedClass3<T extends A&I>{...} //&기호로 두 개 이상의 제한, 이 경우 제네릭 타입은 A이거나 그 자식 클래스 이면서 I 인터페이스를 구현해야한다는 뜻이다.
}

/************************************************
* 제네릭 클래스 생성과 사용
************************************************/
MyClass<String> myClass1 = new MyClass<String>(); //참조 변수와 생성자의 제네릭 타입은 무조건 같아야한다.
MyClass<String> myClass2 = new MyClass<>(); //참조 변수에서 무조건 같은 제네릭 타입이 생성자 타입으로 지정되어야함을 알고있기 때문에 생략 가능
MyClass<A> myClass6 = new MyClass<B>(); //error. 부모-자식 관계의 제네릭 타입은 제네릭 클래스 객체 생성 시 허용되지 않는다. 제네릭 타입은 무조건 같아야한다.
MyClass<String> myClass5 = new SubClass<String>(); //부모-자식 관계의 제네릭 클래스도 제네릭 타입은 일치해야한다.
RestrictedClass1<C> myClass8 = new RestrictedClass1<C>(); // error. C는 A의 자식 클래스가 아니다.

//부모-자식 관계의 제네릭 타입은 제네릭 클래스의 메서드 매개변수로 사용될 때 허용된다.
MyClass<A> myClass7 = new MyClass<A>();
myClass7.setMember(new B());

//JDK 1.5 이전의 코드와 호환을 위해 일반적인(타입을 지정하지 않는) 객체 생성도 허용한다.
//이때, Object 타입으로 간주한다.
//하지만 제네릭 타입을 지정하지 않았다는 경고 메시지(unchecked 또는 unsafe)를 출력한다.
MyClass myClass3 = new MyClass();
MyClass<Object> myClass4 = new MyClass<Object>(); //타입을 Object로 지정하면 경고 메시지는 출력되지 않는다.
```



### 와일드 카드

제네릭 클래스를 매개변수로 받는 메서드가 존재할 때 제네릭 타입이 다른 것만으로는 오버로딩이 성립하지 않기 때문에 제네릭 타입 별 메소드를 정의할 수 없다. (제네릭 타입은 컴파일 시에만 사용되고 제거되기 때문에 오버로딩으로 간주되지 않는다.)

```java
class MyClass{
  void method(GenericClass<String> param){...}
  void method(GenericClass<Integer> param){...}
}
```

이때 와일드 카드(`?`기호)를 아래와 같이 적용할 수 있다.

```java
class MyClass1{
  //모든 타입이 가능하다. <? extends Object> 와 동일하다.
  void method(GenericClass<?> param){...}
}

class MyClass2{
  //A와 그 자식 클래스만 가능 (와일드 카드 상한 제한, A가 최상 임)
  void method(GenericClass<? extends A> param){...}
}
  
class MyClass3{
  //A와 그 부모 클래스만 가능 (와일드 카드 하한 제한, A가 최하 임)
  void method(GenericClass<? super A> param){...}
}
```

와일드 카드의 제한이 걸리기 전에 제네릭 클래스 자체의 제네릭 타입 제한이 먼저 적용된다. 예를들어, `<?>`로 모든 타입을 다 받는 와일드 카드를 사용했을 때 제네릭 클래스의 정의에 이미 `<T extends A>`로 제한되어 있다면 A이거나 그 자식 클래스만 제네릭 타입으로 허용된다.



### 제네릭 메서드

- 메서드 반환 타입 앞에 제네릭 타입을 선언한다. 
- static 멤버 함수에도 적용 가능하다.
- 일반 클래스에서도 제네릭 메서드를 정의할 수 있다. 
- 제네릭 메서드에서 정의된 제네릭 타입은 해당 메서드 안에서만 지역적으로 사용된다.

```java
//제네릭 클래스의 제네릭 타입 T와 별개이다.
class MyClass1<T>{
  static <T> void method1(T param){...}
  static <T> T method2(T param){...}
}

//일반 클래스에도 정의할 수 있다.
class MyClass2{
  public <T> void method(T param){...}
}

//와일드 카드를 대체할 수 있다.(하한 제한은 불가)
class MyClass3{
  //void method1(GenericClass<?> param){...}
  <T> void method1(GenericClass<T> param){...}
}

class MyClass4{
  //void method2(GenericClass<? extends A> param){...}
  <T extends A> void method2(GenericClass<T> param){...}
}

MyClass1.<Integer>methos1(100);

MyClass2 myClass2 = new MyClass2();
myClass2.<Integer>method(100);
myClass2.method(100); //제네릭 메서드 정의 시 제네릭 타입에 제한을 두거나 대부분의 일반적인 타입의 경우 컴파일러가 추정 가능하여 생략할 수 있다.
```



### 제네릭 타입의 형변환

- 원시 타입으로의 형변환은 가능하지만 경고 발생

- 부모-자식 관계의 제네릭 타입의 형변환은 와일드 카드를 이용한다.  

  ```java
  class A{...}
  class B extends A{...}
  class MyClass<T>{...}
  
  MyClass<A> myClass1 = new MyClass<B>(); //error.
  MyClass<? extends A> myClass2 = new MyClass<B>();
  MyClass<B> myClass3 = new MyClass<? extends A>(); //경고 메시지 출력, 확인되지 않은 형변환
  ```

