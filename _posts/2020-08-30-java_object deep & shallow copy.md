---
title: "객체의 깊은 복사와 얕은 복사"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-08-30T21:11:00
---

- 깊은 복사 (Deep Copy)  
  객체가 갖고있는 멤버 변수의 **값을 복사**
- 얕은 복사 (Shallow Copy)  
  객체의 **주소값을 복사**, 원본 객체와 복사본 객체는 서로 영향을 준다.

# 깊은 복사가 가능한 클래스 구현

`Cloneable` 인터페이스를 구현하여 `Cloneable.clone()` 메소드를 `public` 으로 오버라이드해야 한다.

```java
class A implements Cloneable{
  public int i;
  public String str;

  public A() {}

  @Override
  public Object clone() throws CloneNotSupportedException {
    return super.clone();
  }
}
```



# 테스트

```java
A a1 = new A();
a1.i = 1;
a1.str = "A";

// Deep Copy
A a2 = null;
try {
  a2 = (A) a1.clone();
} catch (CloneNotSupportedException e) {
  e.printStackTrace();
}

// Shallow Copy
A a3 = a1;

System.out.println("a1 "+ a1.hashCode() + "(original object): "+a1.i + ", " + a1.str);
System.out.println("a2 "+ a2.hashCode() + "(deep copy object): "+a2.i + ", " + a2.str);
System.out.println("a3 "+ a3.hashCode() + "(shallow copy object): "+a3.i + ", " + a3.str);

// 데이터 변경
a2.i = 2;
a2.str = "B";

a3.i = 3;
a3.str = "C";

System.out.println("a1 "+ a1.hashCode() + "(original object): "+a1.i + ", " + a1.str);
System.out.println("a2 "+ a2.hashCode() + "(deep copy object): "+a2.i + ", " + a2.str);
System.out.println("a3 "+ a3.hashCode() + "(shallow copy object): "+a3.i + ", " + a3.str);
```

```
a1 99347477(original object): 1, A
a2 566034357(deep copy object): 1, A		// 값만 복사됨
a3 99347477(shallow copy object): 1, A 	// 주소값이 복사됨

a1 99347477(original object): 3, C			// 원본 데이터에 영향을 줌
a2 566034357(deep copy object): 2, B		// 원본 데이터에 영향을 주지 않음
a3 99347477(shallow copy object): 3, C
```

# Reference Type 을 멤버 변수로 갖는 경우

`Cloneable`의 구현 클래스가 깊은 복사를 수행해도 Reference Type은 얕은 복사가 된다.

```java
class A implements Cloneable{
  public B b;
  
  public A() {}
  
  @Override
  public Object clone() throws CloneNotSupportedException {
    return super.clone();
  }
}

class B {
  public int i;
  public String str;

  public B() {}
}
...
A a1 = new A();
a1.b = new B();
a1.b.i = 1;
a1.b.str = "1";

// Deep Copy
A a2 = null;
try {
  a2 = (A) a1.clone();
} catch (CloneNotSupportedException e) {
  e.printStackTrace();
}

System.out.println("b of a1 "+ a1.b.hashCode() + "(original object): "+a1.b.i + ", " + a1.b.str);
System.out.println("b of a2 "+ a2.b.hashCode() + "(deep copy object): "+a2.b.i + ", " + a2.b.str);

// 데이터 변경
a2.b.i = 2;
a2.b.str = "2";

System.out.println("b of a1 "+ a1.b.hashCode() + "(original object): "+a1.b.i + ", " + a1.b.str);
System.out.println("b of a2 "+ a2.b.hashCode() + "(deep copy object): "+a2.b.i + ", " + a2.b.str);
```

```
b of a1 566034357(original object): 1, 1
b of a2 566034357(deep copy object): 1, 1

// 깊은 복사를 수행한 객체의 reference type 멤버변수는 얕은 복사가 수행되었다.
b of a1 566034357(original object): 3, 3
b of a2 566034357(deep copy object): 3, 3
```

객체의 깊은 복사와 동시에 해당 객체가 갖는 Reference Type 멤버 변수 또한 깊은 복사를 수행하기 위해서는 별도의 작업이 필요하다. 이를 위해 멤버 변수로 같은 클래스 또한 `Cloneable` 인터페이스를 구현하고 `Cloneable.clone()` 메소드를 오버라이드 해야한다.

대상 클래스의 `Cloneable.clone()` 메소드에서는 이 Reference Type 멤버 변수에 대한 깊은 복사를 반드시 구현해야한다.

```java
class A implements Cloneable{
  public B b;
  
  public A() {}
  
  @Override
  public Object clone() throws CloneNotSupportedException {
    A a = (A)super.clone();
		a.b = (B)a.b.clone(); // reference type 멤버 변수에 대한 깊은 복사
    return a;
  }
}

class B implements Cloneable{
  public int i;
  public String str;
	
  public B() {}
  
  @Override
  public Object clone() throws CloneNotSupportedException {
    return super.clone();
  }
}
...
```

```
b of a1 566034357(original object): 1, 1
b of a2 940553268(deep copy object): 1, 1

// reference type 멤버변수 까지 깊은 복사가 수행되었다.
b of a1 566034357(original object): 3, 3
b of a2 940553268(deep copy object): 2, 2
```

