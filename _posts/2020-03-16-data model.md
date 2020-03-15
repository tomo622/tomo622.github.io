---
title: "데이터 모델"
excerpt: "데이터 모델을 정리한다."
categories:
 - c language
last_modified_at: 2020-03-16T02:31:00
---

## 데이터 모델 (Data Model)

 C언어의 정수 자료형은 운영체제, CPU의 플랫폼(32bit 또는 64bit)에 따라 다른 크기를 갖는다. 데이터 모델의 명칭에서 'S'는 `short`, 'I'는 `int`, 'L'은 `long`, 'LL'은 `long long`, 'P'는 `pointer`를 의미한다.

| 데이터 모델    | short | int  | long | long long | pointer |                                    |
| -------------- | ----- | ---- | ---- | --------- | ------- | ---------------------------------- |
| IP16L32        | 16    | 16   | 32   | -         | 16      | 16bit: MS-DOS                      |
| I16LP32        | 16    | 16   | 32   | -         | 32      | 16bit: MS-DOS                      |
| ILP32          | 16    | 32   | 32   | 64        | 32      | 32bit : UNIX, LINUX, OS X, Windows |
| LLP64, IL32P64 | 16    | 32   | 32   | 64        | 64      | 64bit : Windows                    |
| LP64, I32LP64  | 16    | 32   | 64   | 64        | 64      | 64bit : UNIX, LINUX, OS X          |
| ILP64          | 16    | 64   | 64   | 64        | 64      |                                    |
| SILP64         | 16    | 64   | 64   | 64        | 64      |                                    |

### 테스트 코드

```c
/*
* 운영체제와 컴파일러가 타겟팅하는 플랫폼의 종류에 따른 정수 자료형의 크기를 본다.
*/
#include <stdio.h>

int main()
{
	char *a = NULL;

	printf("%d\n", sizeof(a));

	getchar();
}
```

### 결과

- 테스트 운영체제: Windows 10 x64

![32bit_compiler](https://user-images.githubusercontent.com/19742979/55766455-c016b100-5aaf-11e9-8c40-73bfbe5f937f.PNG){: .align-center}

![64bit_compiler](https://user-images.githubusercontent.com/19742979/55766457-c147de00-5aaf-11e9-9b11-ca2a34034937.PNG){: .align-center}

