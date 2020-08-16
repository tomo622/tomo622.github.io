---
title: "Annotation"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-07-08T00:03:00
---

### Annotation 이란?

프로그램의 소스코드 안에 **다른 프로그램을 위한 정보**를 미리 약속된 형식(`@` 태그)으로 포함시킨 것으로 프로그래밍 언어에 영향을 미치지 않으면서 다른 프로그램에게 정보를 제공한다. 예를들어, `@brief` 는 javadoc.exe 라는 프로그램에서 필요로 하는 정보일 뿐 다른 프로그램이나 코드에는 영향을 주지 않는다.



### JDK 표준 애너테이션

| Annotation           |  |
| -------------------- | ---- |
| @Override            | - 메서드에만 적용 가능<br />- 부모 클래스의 메서드를 오버라이딩할 때 컴파일러에게 알린다.<br />- 컴파일러는 부모 클래스에 해당 메서드가 존재하는지 확인해준다. |
| @Deprecated          | - 클래스나 메서드의 사용을 권장하지 않음을 의미한다.<br />- 해당 메서드나 클래스가 사용된 코드를 컴파일 시 경고 메시지를 출력한다. |
| @SuppressWarnings    | - 묵인할 수 밖에 없는 경고 메시지를 출력하지 않게 한다. |
| @SafeVarargs         | - static이나 final이 붙은 메서드와 생성자에만 적용 가능<br />- 오버라이드 될 수 있는 메서드에 적용 불가<br />- 메서드에 사용된 가변인자의 타입이 안정성을 갖는다고 알린다.<br />- 주로, 제네릭 타입의 가변인자를 메서드에 사용할 때 unchecked 경고 메시지를 억제하기 위해 사용한다. (`@SuppressWarnings("varargs")`와 함께 사용된다.) |
| @FunctionalInterface | - 함수형 인터페이스에 적용<br />- 컴파일러가 함수형 인터페이스를 올바르게 선언했는지 확인해준다. |
| @Native              | - native 메서드에서 참조되는 상수 앞에 붙인다. |

이외에 애너테이션을 정의하는데 사용되는 Meta Annotation 이 있다.

- SuppressWarnings 의 경고 메시지 종류  

  | 경고 메시지 종류 |                                                         |
  | ---------------- | ------------------------------------------------------- |
  | deprecation      | @Deprecated 의 경고 메시지                              |
  | unchecked        | 제네릭스 타입을 지정하지 않았을 때 발생하는 경고 메시지 |
  | rawtypes         | 제네릭스를 사용하지 않았을 때 발생하는 경고 메시지      |
  | varargs          | 가변인자의 타입이 제네릭 타입일 때 발생하는 경고 메시지 |

  지정된 경고 메시지를 출력하지 않는다.  
  사용 예) `@SuppressWarnings("unchecked")`, `@SuppressWarnings({"unchecked", "deprecation"})`

  참고) 경고 메시지 보기 컴파일 옵션

  - \> javac **-Xlint** test.java : 경고 메시지 타입과 함께 경고 메시지를 출력한다.
  - \> javac **-Xlint:unchecked** test.java : unchecked 와 관련된 경고 메시지만 출력한다.

- SafeVarargs 사용 이유  
  다음과 같이 제네릭 타입의 가변인자를 사용하는 메서드가 있다.

  ```java
  public static <T> List<T> asList(T...a){
    return new ArrayList<T>(a);
  }
  ```

  위 메서드는 *가변인자의 제네릭스 타입을 지정하지 않았기 때문에 unchecked* 경고와 *가변인자의 타입이 제네릭 타입이기 때문에 varargs* 경고를 출력한다. 하지만 위 메서드는 컴파일 시 문제가 없다.  
  unchecked 에 의한 경고 메시지를 억제하기 위해 SafeVarargs가 사용된다. 하지만 varargs의 경고 메시지를 억제할 수 없기 때문에 주로 `@SuppressWarnings("varargs")`와 함께 사용한다.

  SafeVarargs를 사용하면 해당 메서드를 호출하는 곳에서의 unchecked 경고 메시지도 함께 억제된다. (`@SuppressWarnings("unchecked")`로 대체할 수 있지만 해당 메서드를 호출하는 곳에서도 애너테이션을 추가해줘야한다.)

