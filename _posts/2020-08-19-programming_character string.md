---
title: "문자의 표현"
excerpt: ""
use_math: true
categories:
 - programming
last_modified_at: 2020-08-19T00:29:00
---

- ASCII, American Standard Code for Information Interchange : 128(=$2^7$)개의 문자집합을 제공하는 7bit 부호로 제어문자, 기호, 숫자(0~9), 영대소문자(A~Z, a~z) 를 표현하는 숫자 코드로 이루어진다.
- Extended ASCII : 일반적으로 byte(=8bit)를 사용하는 데이터에서 ASCII 코드를 사용할 때 1bit가 남는다. 이 1bit를 활용하여 255(=$2^8$)개의 문자집합을 제공한다. 추가된 128개의 문자집합 구성은 국가마다 다르게 사용할 수 있다. 이와 관련하여 한글을 표현하기 위한 문자집합은 '확장 완성형 CP(Code Page) 949'가 주로 사용된다.
- Unicode : 전 세계의 모든 문자를 표현하기 위해 만들어졌다. 2byte (보충 문자를 포함하면 21bit) 로 표현한다.
  - Character Set : 유니코드에 포함되는 문자집합을 의미한다. 각 문자집합은 UTF-8, UTF-16 등의 번호로 구분되고 이를 유니코드 인코딩이라 한다.
  - UTF-8 : 하나의 문자를 1~4byte 가변 크기로 표현
  - UTF-16 : 모든 문자를 2byte의 고정 크기로 표현