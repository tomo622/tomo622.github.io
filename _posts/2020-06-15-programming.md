---
title: "Programming"
excerpt: ""
categories:
 - computer science
last_modified_at: 2020-06-15T18:25:00
---

> [1급 객체 (First Class Object)](#1급-객체-first-class-object)
>
> [람다식 (Lambda Expression)](#람다식-lambda-expression)
>
> [함수와 메서드의 차이](#함수와-메서드의-차이)

---

### 1급 객체 (First Class Object)

1. 모든 요소는 함수의 실제 매개변수가 될 수 있다.
2. 모든 요소는 함수의 반환 값이 될 수 있다.
3. 모든 요소는 할당 명령문의 대상이 될 수 있다.
4. 모든 요소는 동일 비교의 대상이 될 수 있다.

---

### 람다식 (Lambda Expression)

함수/메서드를 하나의 식으로 표현한 것으로 익명 함수 (Anonymous Function) 이라고도 하며 이름이 없는 형태의 함수를 뜻하며 다음과 같은 특징을 갖는다.

1. 고계함수의 인수가 될 수 있다.
2. 고계함수의 결과가 될 수 있다.

여기서 고계함수 (Higher Order Function)은 함수를 다루는 함수를 뜻한다.

만약 함수가 한 번 사용되거나 제한된 횟수로 사용된다면 람다식을 사용하는 것이 편하다. 람다식은 코드의 길이를 줄여주고 가독성을 높여준다.

이 람다는 최근 함수형 프로그래밍 (Functional Programming)을 가능하게 했다.

---

### 함수와 메서드의 차이

메서드는 함수와 같은 의미다. 하지만 객체지향 개념에서 함수는 특정 클래스에 반드시 속해야 한다는 제약이 있어 기존 함수와 구분하기 위하여 메서드라는 용어를 사용하게 되었다.

