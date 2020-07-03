---
title: "자료형"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-07-03T23:21:00
---

|                |                |                |                     | Data Type |            | Size(byte)      |
| -------------- | -------------- | -------------- | ------------------- | --------- | ---------- | --------------- |
| Primitive Type | Boolean Type   | -              | -                   | boolean   | -          | 1               |
|                | Numeric Type   | Character Type | -                   | char      | -          | 2 (utf-16)      |
|                |                | Integral Type  | Integer Type        | byte      | -          | 1               |
|                |                |                |                     | short     | -          | 2               |
|                |                |                |                     | int       | -          | 4               |
|                |                |                |                     | long      | -          | 8               |
|                |                |                | Floating Point Type | float     | -          | 4               |
|                |                |                |                     | double    | -          | 8               |
| Reference Type | Array Type     |                |                     |           |            | 전부 4(주소 값) |
|                | Enum Type      |                |                     |           |            |                 |
|                | Interface Type |                |                     |           |            |                 |
|                | Class Type     | -              | -                   | String    |            |                 |
|                |                | Wrapper Type   | -                   | Void      |            |                 |
|                |                |                | -                   | Boolean   |            |                 |
|                |                |                | -                   | Character |            |                 |
|                |                |                | -                   | Number    | Byte       |                 |
|                |                |                |                     |           | Short      |                 |
|                |                |                |                     |           | Integer    |                 |
|                |                |                |                     |           | Long       |                 |
|                |                |                |                     |           | Float      |                 |
|                |                |                |                     |           | Double     |                 |
|                |                |                |                     |           | BigInteger |                 |
|                |                |                |                     |           | BigDecimal |                 |



### Primitive Type VS Reference Type

| Primitive Type                                 | Reference Type       |
| ---------------------------------------------- | -------------------- |
| 컴파일러가 해석하는 자료형, 데이터의 값을 저장 | 데이터의 주소를 저장 |
| `null `저장 불가능                             | `null` 저장 가능     |
| stack에 저장                                   | heap에 저장          |



### Primitive Type 정수형의 사용

정수형을 계산할 때 JVM의 피연산자 스택은 피연산자를 4byte 단위로 저장한다. 4byte 보다 작은 정수형 short, byte는 계산 시 4byte로 변환되기 때문에 효율적이지 못하다. 따라서 효율보다 메모리 절약이 중요할때만 short 나 byte를 사용하는 것이 좋다.



### String

Primitive Type 처럼 사용할 수 있다. 하지만 비교 시 `.equals()` 메소드를 사용해야한다. (Primitive Type은 `==` 사용) 또한 `String`은 immutable 하다. 즉 문자열의 변경이 불가능하기 때문에 값을 변경할 때 마다 새로 생성된다.



### Wrapper Class

Primitive Type의 자료형들을 객체로 다루기 위한 클래스들을 말한다. Wrapper Class 들이 공통으로 갖는 메서드와 static 상수는 아래와 같다.

| 메서드                                                      |                                          |
| ----------------------------------------------------------- | ---------------------------------------- |
| `equals()`                                                  | 주소값이 아닌 객체가 갖는 값을 비교한다. |
| `toString()`                                                | 객체가 갖는 값을 문자열로 변환한다.      |
| `.parse기본형 이름(문자열)` (ex. `Integer.parseInt("100")`) | 문자열을 Primitive Type으로 변환한다.    |
| `.valueOf("문자열")` (ex. `Integer.valueOf("100")`)         | 문자열을 Wrapper Type으로 변환한다.      |

| static 상수 |
| ----------- |
| MAX_VALUE   |
| MIN_VALUE   |
| SIZE        |
| BYTES       |
| TYPE        |

