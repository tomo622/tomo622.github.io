---
title: "Lambda Expression"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-06-27T17:38:00
---

JDK1.8 (Java8) 부터 등장하여 함수형 언어의 장점을 갖게 되었다.

### 람다식 작성 규칙

1. 일반 메서드에서 메서드의 이름과 반환 타입을 제거한다.
2. 매개변수 선언부와 함수 몸통 사이에 `->`을 추가한다.
3. 매개변수의 타입이 추론이 가능한 경우에는 매개변수의 타입 역시 생략될 수 있다. (생략하려면 모든 매개변수의 타입을 생략해야한다.)
4. 매개변수가 하나인 경우 매개변수의 괄호`()`를 생략할 수 있다. 이때 매개변수의 타입은 생략되어야 한다.
5. **함수 몸통에 문장이 하나인 경우** 함수 몸통이 **문장**이 아닌 **식**으로 표현할 수 있으며 이때 중괄호`{}`와 세미콜론`;` 이 생략된다. 만약 반환값이 있다면 `return`도 생략된다.



### Function Interface

람다식은 익명 함수 (Anonymous Function) 라고도 한다. 하지만 자바 언어는 모든 함수/메서드가 특정 클래스에 종속되어야 하는 *객체지향의 특성*을 갖기 때문에 익명 함수가 아닌 **익명 클래스의 객체와 동등하다**고 말한다. 정리하자면, 람다식은 익명 함수와 같이 사용되어야 하지만 자바에서는 (함수가 특정 클래스에 종속되어야 한다는) 객체지향의 특성 때문에 익명 클래스로 해당 메서드를 감싼다고 생각하면 된다.

```java
(int a, int b) -> a > b ? a : b
```

```java
new AnonymousObject(){
  public int max(int a, int b){
    return a > b ? a : b;
  }
}
```

자바에서는 인터페이스를 활용하여 위와 같은 특성을 통해 람다식을 다루게 하였다. 인터페이스를 이용하면 익명 객체를 참조할 수 있고 익명 객체의 메서드(람다식)을 호출할 수 있다. 즉, 인터페이스를 참조변수의 타입으로 사용하여 람다식을 다루는 것이다. 이를 함수형 인터페이스 (Function Interface)라 한다. 함수 인터페이스의 조건은 아래와 같다.

- 하나의 추상 메서드만 정의되어야 한다.
- 추상 메서드의 매개변수의 타입과 개수, 반환 타입은 사용하려는 람다식과 일치해야한다.
- static 메서드와 default 메서드는 개수 제한이 없다.
- @FunctionInterface 를 붙이면 컴파일러가 함수형 인터페이스를 올바르게 정의했는지 확인해준다.

```java
@FunctionInterface
interface MyFunctionInterface{
  public abstract int max(int a, int b);
}
```

```java
//익명 클래스로 추상 메서드를 구현
MyFunctionInterface f = new MyFunctionInterface(){
  public int max(int a, int b){
    return a > b ? a : b;
  }
}
```

```java
//람다식으로 추상 메서드를 구현
MyFunctionInterface f = (int a, int b) -> a > b ? a : b;
int big = f.max(5, 3);
```

람다식이 익명 클래스의 객체와 동등하기 때문에 위와 같은 결과가 나올 수 있다.

> 실제 사용 시 이렇게 생각하자.
>
> 함수형 인터페이스는 람다식을 저장할 수 있는 자료형이다. (사실은 함수형 인터페이스로 람다식을 참조하는 것일 뿐 자료형은 아니다.) 단 함수형 인터페이스를 정의할 때 추상 메서드의 매개변수 타입과 개수, 반환 타입은 구현하려는 람다식과 일치되어야 한다. 또한 저장된 람다식은 추상 메서드의 이름으로 참조 가능하다.

이 함수형 인터페이스를 람다식의 참조변수로 사용하므로써 **메서드를 매개변수나 반환 타입으로 사용할 수 있게 되었다.**

람다식은 익명 객체이고 이는 타입이 없기 때문에 위에서 언급한 것 처럼 함수형 인터페이스는 람다식의 자료형은 아니다. 따라서 함수형 인터페이스를 통해 참조해야할 때 형변환이 필요하지만 생략이 가능하다. 따라서 위 코드는 사실 아래와 같다.

```java
MyFunctionInterface f = (MyFunctionInterface)(int a, int b) -> a > b ? a : b;
```

또한 람다식은 함수형 인터페이스로만 변환이 가능하다. 익명 객체라고해서 Object 타입으로 변환 불가능.

```java
Object obj = (Object)(int a, int b) -> a > b ? a : b; //error
Object obj = (Object)((MyFunctionInterface)(int a, int b) -> a > b ? a : b;)
```



### 람다식에서의 변수 참조

- **람다식 내에서 참조하는 지역변수는 상수로 간주되어 람다식 내부나 다른 곳에서도 값을 변경할 수 없다.**
- 람다식은 외부 지역변수와 동일한 이름의 매개변수를 가질 수 없다.



### java.util.function 패키지

자주 사용되는 메서드 형태의 함수형 인터페이스를 미리 정의해둔 패키지

- 매개변수나 반환형이 제네릭 타입인 함수형 인터페이스

| 함수형 인터페이스    | 메서드                 |
| -------------------- | ---------------------- |
| java.lang.Runable    | void run()             |
| Supplier\<T\>        | T get()                |
| Consumer\<T\>        | void accept(T t)       |
| BiConsumer<T, U>     | void accept(T t, U u)  |
| Function<T, R>       | R apply(T t)           |
| UnaryOperator\<T\>   | T apply(T t)           |
| BiFunction<T, U, R>  | R apply(T t, U u)      |
| BiunaryOperator\<T\> | T apply(T t, T t)      |
| Predicate\<T\>       | boolean test(T t)      |
| BiPredicate<T, U>    | boolean test(T t, U u) |



- Java Collection Framework (JCF) 에서 제공되는 함수형 인터페이스
  (Collection Framework 역시 제네릭 타입을 사용)

| 인터페이스 | 메서드                                       |
| ---------- | -------------------------------------------- |
| Map        | void forEach(BiConsumer<K, V> action)        |
|            | void replaceAll(BiFunction<K, V, V> f)       |
| Iterable   | void forEach(Consumer\<T\> action            |
| Collection | boolean removeIf(Predicate\<E\> filter)      |
| List       | void replaceAll(UnaryOperator\<E\> operator) |

```java
//예
ArrayList<Integer> list = new ArrayList<Integer>();
list.forEach(i->System.out.print(i+","));

Supplier<Integer> s = ()->(int)(Math.random()*100)+1;
```



- 기본 타입의 함수형 인터페이스

| 함수형 인터페이스   | 메서드                       |
| ------------------- | ---------------------------- |
| IntFunction\<R\>    | R apply(int value)           |
| ToIntFunction\<T\>  | int applyAsInt(T t)          |
| DoubleToIntFunction | int applyAsInt(double value) |



- Function 합성
  Function 함수형 인터페이스에서 제공되는 default 함수 `andThen`과 `compose`를 활용하여 두 함수를 결합할 수 있다.  

  ```java
  Function<String, Integer> f = (s) -> Integer.parseInt(s, 16); //문자열을 숫자(16진수)로 변환하는 함수
  Function<Integer, String> g = (i) -> Integer.toBinaryString(i); //숫자를 2진 문자열로 변환하는 함수
  
  //f.andThen(g) 은 f 부터
  Function<String, String> h = f.andThen(g); // f->g 문자열을 숫자(16진수)로 변환한 뒤 2진 문자열로 변환하는 함수
  
  //f.compose(g) 는 g 부터
  Function<Integer, Integer> h2 = f.compose(g); //g->f 숫자를 2진 문자열로 변환한 뒤 숫자(16진수)로 변환하는 함수
  ```

  

- Predicate 결합
  Predicate 함수형 인터페이스에서 제공되는 default 함수 `and`, `or`, `negate`를 활용하여 조건식을 결합할 수 있다. 또한 `isEqual`이라는 static 함수도 제공되어 대상을 비교할 수도 있다.

  ```java
  Predicate<Integer> p = i -> i < 100;
  Predicate<Integer> q = i -> i < 200;
  
  Predicate<Integer> h = p.and(q); // i < 100 && i < 200 과 같다
  Predicate<Integer> notH = h.negate(); //조건식 부정
  ```

  ```java
  //문자열 비교
  Predicate<String> r = Predicate.isEqual(str1);
  boolean res = r.test(str2);
  //또는
  boolean res2 = Predicate.isEqual(str1).test(str2);
  ```

  

### 메서드 참조

람다식에서 *하나의 메서드만 호출하는 경우*와 *생성자를 호출하는 경우* 메소드 참조를 이용하여 더욱 간단하게 표현할 수 있다.

| 종류                           | 람다식                                                     | 메서드 참조                                       |
| ------------------------------ | ---------------------------------------------------------- | ------------------------------------------------- |
| static 메서드 참조             | `(x) -> ClassName.method(x)`                               | `ClassName::method`                               |
| 인스턴스 메서드 참조           | `(obj, x) -> obj.method(x)`                                | `ClassName::method`                               |
| 특정 객체 인스턴스 메서드 참조 | `(x) -> obj.method(x)`                                     | `obj::method`                                     |
| 생성자 메서드 참조             | `Supplier<ClassName> s = () -> new ClassName();`           | `Supplier<ClassName> s = ClassName::new;`         |
|                                | `Function<Integer, ClassName> f = (i) -> new ClassName(i)` | `Function<Integer, ClassName> f = ClassName::new` |
|                                | `Function<Integer, int[]> f = (x) -> new int[x];`          | `Function<Integer, int[]> f = int[]::new`         |

