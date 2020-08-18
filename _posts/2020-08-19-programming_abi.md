---
title: "ABI (Application Binary Interface)"
excerpt: "ABI, Calling Convention"
use_math: true
categories:
 - programming
last_modified_at: 2020-08-19T00:33:00
---


응용 프로그램과 운영 체제 또는 응용 프로그램과 해당 라이브러리, 마지막으로 응용 프로그램의 구성요소 간에서 사용되는 *낮은 수준의 인터페이스*이다. API가 소스 코드에서 사용된다면 *ABI는 바이너리에서 호환이 가능*하다는 점이 다르다.

- 레지스터 파일 구조, 스택 구성, 메모리 액세스 타입 등의 정보가 포함된다.
- 사용 가능한 CPU 명령 집합
- 런타임 시 메모리 저장 및 로드의 엔디언
- 애플리케이션과 시스템 간 데이터 전달 규칙
- C++ Name Mangling 방식
- ABI에는 해당 어플리케이션과 자신, 커널, 라이브러리 등과 어떻게 상호작용하는지 정의된다.
- <u>호출 규약 (Calling Convention)</u>이 정의된다.
- 어셈블리어로 프로그래밍하지 않는 이상 명시적으로 제공될 필요가 없다.
- 특정 언어에 의존하지 않는다.



# Calling Convention

매개변수를 수신하는 방법과 결과를 반환하는 방법에 대한 낮은 수준의 구현 체계이다. 매개변수, 반환값, 반환 주소, 범위 링크 등이 어디에 위치되어지는지(레지스터, 스택, 메모리와 같은 위치를 의미함)와 호출자와 수신자 사이에서 함수 호출을 준비하고 환경을 되돌리는 작업이 어떻게 나누어지는지 등에 대한 정보가 정의된다.

Calling Convention 은 매개 변수, 반환 값, 반환 주소의 위치, 호출 방법 등 다양한 방법으로 정의 될 수 있다. 이러한 조건들의 정의는 컴파일러나 CPU 아키텍처 별로 달라진다.

CPU 아키텍처에는 하나 이상의 Calling Convention이 반드시 존재한다.

> 출처) <https://en.wikipedia.org/wiki/Calling_convention#Compiler_variation>

