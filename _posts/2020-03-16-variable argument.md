---
title: "가변인자"
excerpt: "가변인자의 원리에 대해 알아본다."
categories:
 - c language
last_modified_at: 2020-03-16T02:30:00
---

# 가변인자 (Variable Argument)

 가변인자를 갖는 함수를 구현하기 위해서 함수의 마지막 인자에 줄임표(...)를 선언한다. 단, 가변인자 이전에 하나 이상의 고정인자를 가져야한다. 고정인자는 사용되지 않더라도 반드시 필요하다.

```
반환자료형 함수명(자료형 고정인자, ...){ ... }
```

 가변인자가 전달될 때에는 표준변환의 정수 또는 실수의 승격(promotion)을 따른다. 예를들어, 정수 자료형 `char`나 `short`가 가변인자로 전달될 경우 `int`로 형 변환되고, 실수 자료형 `float`이 전달될 경우 `double`로 형 변환된다. (즉, 정수형의 경우 `int` 보다 크기가 작은 자료형의 경우 `int`로 변환, 실수형의 경우 `double` 보다 크기가 작은 자료형의 경우 `double`로 변환한다. 나머지 자료형은 그대로 사용된다.)

 함수가 정해지지 않은 개수와 자료형의 인자를 받아야할 경우 사용한다.



## 매크로

 선언된 가변인자에 접근하기 위해서는 `stdarg.h`에 포함된 매크로를 사용해야한다. (표준 ANSI C89 이전 버전에서는 `varargs.h`, `stdarg.h` 내부에서 `varargs.h` 를 포함하고 있다.)

 매크로의 분석은 Visual Studio 2015, SDK 10 을 기준으로 하였다.

```c
//stdarg.h
#define va_start __crt_va_start
#define va_arg   __crt_va_arg
#define va_end   __crt_va_end
#define va_copy(destination, source) ((destination) = (source))
```

### va_list

 인자 목록 포인터, 현재 읽기 위한 가변인자의 첫 번째 주소를 저장한다. `varargs.h`에 다음과 같이 정의되어있다.

```c
typedef char * va_list;
```

 `char *`을 사용하는 이유는 인자 목록 포인터를 이동시킬 때 1byte 씩 연산하기 위함이다.

### va_start

 인자 목록 포인터(`va_list`)를 전달 된 첫 번째 가변인자의 시작 포인터 위치로 설정한다.

```c
void va_start(
    va_list arg_ptr,	//인자 목록의 포인터
    prev_param			//가변인자 앞에 위치한 매개변수(일반적인 고정인자)
);

void va_start(arg_ptr);	//표준 ANSI C89 이전 버전
```

```c
//vadefs.h
//x86
#define _INTSIZEOF(n)          ((sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1))
#define __crt_va_start_a(ap, v) ((void)(ap = (va_list)_ADDRESSOF(v) + _INTSIZEOF(v)))
//x64
#define __crt_va_start(ap, x) __crt_va_start_a(ap, x)
void __cdecl __va_start(va_list* , ...);
#define __crt_va_start_a(ap, x) ((void)(__va_start(&ap, x)))
```

- x86

  - `_INTSIZEOF(n)`
    자료형의 크기를 인자(`n`)로 받는다. x86 플랫폼에서 스택의 단위 크기인 4byte에 자료형의 크기를 맞추는 매크로이다. 스택 포인터를 이동하면서 가변 인자를 읽기 때문에 필요하다. 예를들어, 자료형 크기가 1~4 인 경우 4를, 5~8 인 경우 8의 결과를 얻는다. 즉, 자료형이 차지하는 스택 단위 크기를 반환한다.
    ![x86_stack](https://user-images.githubusercontent.com/19742979/56410898-ca0f8f80-62b9-11e9-8668-e80f1e1572aa.PNG){: .align-center}

  - `((void)(ap = (va_list)_ADDRESSOF(v) + _INTSIZEOF(v)))`
    `ap`는 인자 목록 주소를 가르키는 포인터이고 `v`는 가변인자 바로 앞에 위치한 고정인자이다. `_ADDRESSOF(v)` 는 인자의 (시작)주소를 반환하는 매크로이다. 해당 매크로는 가변인자 바로 앞에 있는 고정인자의 시작 위치에 고정인자의 자료형이 차지하는 스택 단위 크기(`_INTSIZEOF 사용`)를 더하여 첫 번째 가변인자의 시작 주소를 찾아내고 인자 목록 포인터에 저장한다.
    ![x86_start](https://user-images.githubusercontent.com/19742979/56412489-52dcfa00-62bf-11e9-8e65-25be9edeaf59.PNG){: .align-center}

### va_arg

 인자 목록 포인터(`va_list`)의 위치에서 `type`의 값을 검색한다. 즉, `va_list`의 위치에서 주어진 자료형 만큼 데이터를 읽고 인자 목록 포인터를 이동시킨다. 이동된 인자 목록 포인터는 다음 가변인자의 시작 포인터에 위치하게 된다.

 Linux(gcc)에서 `type`사용 시 `char`, `unsigned char`, `short`, `unsigned short` 대신 `int`를 사용해야하고, `float` 대신 `double`을 사용해야한다. 이는 위에서 설명한 바와 같이 가변인자가 전달될 때에 정수 혹은 실수의 승격에 따라 인자가 형 변환되기 때문이다. (반면, Windwos VS의 경우 `type`으로 `char`, `short`, `float`의 사용을 허용한다. C 표준인 gcc를 따르는게 좋다.)

```c
type va_arg(
	va_list arg_ptr,
    type				//검색할 인자의 자료형
);
```

```c
//vadefs.h
//x86
#define __crt_va_arg(ap, t)     (*(t*)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)))
//x64
#define __crt_va_arg(ap, t)                                               	\
	((sizeof(t) > sizeof(__int64) || (sizeof(t) & (sizeof(t) - 1)) != 0)	\
    ? **(t**)((ap += sizeof(__int64)) - sizeof(__int64))             		\
    :  *(t* )((ap += sizeof(__int64)) - sizeof(__int64)))
```

- x86
  - `(*(t*)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)))`
    첫 번째로 인자 목록 포인터를 가변인자의 자료형이 차지하는 스택 단위 크기 만큼 이동하여 다음 가변인자의 시작 주소를 가르키게 한다. `(ap += _INTSIZEOF(t)` 두 번째로 이동한 스택 포인터 만큼 다시 제자리로 돌아와 현재 읽으려는 가변인자의 시작 주소를 반환한다. `... - _INTSIZEOF(t)` 이때, 가변인자의 자료형으로 형 변환된다. `(t*)`
    ![x86_arg](https://user-images.githubusercontent.com/19742979/56413110-53769000-62c1-11e9-8091-51a2b7349f99.PNG){: .align-center}

### va_copy

  인자 목록의 현재 상태를 복사한다. 

```c
void va_copy(
	va_list dest,//src로 부터 초기화 될 인자 목록
  	va_list src	 //dest로 복사하려는 va_start로 초기화된 또는 va_arg로 업데이트된 인자 목록
);
```

### va_end

  인자 목폭 포인터를 `NULL`로 초기화 시킨다. 
  함수가 종료되기 전에 `va_start` 또는 `va_copy`로 초기화된 인자 목록을 초기화해야한다.

```c
void va_end(
	va_list arg_prt
);
```

```c
//vadefs.h
//x86, x64
#define __crt_va_end(ap)        ((void)(ap = (va_list)0))
```



 위와 같은 매크로들을 사용하여 인자목록에서 첫 번째  가변인자에 대한 포인터를 설정하고 목록에서 인자를 검색하며 인자 처리가 완료되면 포인터를 다시 설정하는 과정을 통해 가변인자를 모두 읽어들인다.



## 미해결

1. 가변인자 전달 시 형 변환(정수, 실수의 승격)을 거치는 이유는?
   함수 호출 시 매개변수가 저장되는 스택의 단위 크기 4byte(x86) 또는 8byte(x64)에 맞추는거라면, x64 환경의 경우에는? 일반 함수의 경우에도 승격을 거치는가?
2. Windwos VS의 경우 `type`으로 `char`, `short`, `float` 를 정말 허용하는가?
   테스트 결과 `float`의 경우 데이터 값이 비정상으로 출력된다.

## TODO

1. x64 매크로 분석



## 테스트

Visual Studio 2015, SDK 10

### 코드1

```c
/**
* 가변인자를 사용하는 여러가지 함수의 형태를 구현한다.
*/

#include <stdio.h>
#include <stdarg.h>

int Sum(int _nCnt, ...);
void PrintStr(char *_szFirst, ...);
void PrintVar(char *_szTypes, ...);

int main()
{
	printf("%d\n", Sum(5, 1, 2, 3, 4, 5));
	printf("\n");
	PrintStr("first", "second", "Third", "Fourth", "exit");
	printf("\n");
	PrintVar("fcsi", 32.4f, 'a', "Test string", 4);
	
	getchar();
}

// 가변인자 개수를 받는 경우
// 가변인자는 모두 같은 자료형을 사용해야한다.
int Sum(int _nCnt, ...)
{
	int nSum = 0;
	int i = 0;
	va_list arg_ptr = NULL;
	
	va_start(arg_ptr, _nCnt);

	for(i = 0; i < _nCnt; i++)
	{
		nSum += va_arg(arg_ptr, int);
	}

	va_end(arg_ptr);

	return nSum;
}

// 가변인자 종료 문자열을 받는 경우
// 고정인자와 가변인자 모두 같은 자료형을 사용해야하며,
// 사용자는 약속된 종료 문자열을 알고있어야한다.
void PrintStr(char *_szFirst, ...)
{
	char *szStr = NULL;
	va_list arg_ptr = NULL;
	
	va_start(arg_ptr, _szFirst);

	printf("%s\n", _szFirst);
	while(1)
	{
		szStr = va_arg(arg_ptr, char*);

		if(szStr == "exit")
		{
			break;
		}
		
		printf("%s\n", szStr);
	}

	va_end(arg_ptr);
}

// 자료형이 다른 가변인자를 받는 경우
// 문자열 고정인자를 통해 가변인자들의 자료형을 받는다.
// 자료형은 약속된 문자로 1:1 매핑된다.
// 문자열 고정인자의 개수와 배열의 순서는 입력 받는 가변인자의 개수와 순서에 일치해야한다.
void PrintVar(char *_szTypes, ...)
{
	union VarType{
		int i;
		float f;
		char c;
		char *s;
	}VarType;

	int i = 0;
	va_list arg_ptr = NULL;

	va_start(arg_ptr, _szTypes);

	for(i = 0; _szTypes[i] != '\0'; i++)
	{
		switch(_szTypes[i])
		{
		case 'i':
			VarType.i = va_arg(arg_ptr, int);
			printf("%i\n", VarType.i);
			break;
		case 'f':
			VarType.f = va_arg(arg_ptr, double);
			printf("%f\n", VarType.f);
			break;
		case 'c':
			VarType.c = va_arg(arg_ptr, char);
			printf("%c\n", VarType.c);
			break;
		case 's':
			VarType.s = va_arg(arg_ptr, char*);
			printf("%s\n", VarType.s);
			break;
		}
	}

	va_end(arg_ptr);
}
```

### 결과1

![variable_argument1](https://user-images.githubusercontent.com/19742979/55769397-9e232b80-5abb-11e9-9b2f-2ff6fa03270f.PNG){: .align-center}

### 코드2

```c
/**
* 가변인자를 읽는 과정에서 va_list가 가리키는 주소의 변화를 본다.
*/

#include <stdio.h>
#include <stdarg.h>

void VariableArgumentFunc(char *_szTypes, ...);

int main()
{
	//각 자료형의 최대값을 저장
	char c = 'a';
	short s = 32767;
	int i = 214748367;
	long l = 2147483647;
	long long L = 9223372036854775807;
	float f = 3.402823466e+38f;
	double d = 1.7976931348623158e+308;
	long double D = 1.7976931348623158e+308l;
	char *str_p = "abcd efgh";
	int int_v = 214748367;
	int *int_p = &int_v;

	VariableArgumentFunc("csilL", c, s, i, l, L);
	VariableArgumentFunc("fdD", f, d, D);
	VariableArgumentFunc("SI", str_p, int_p);

	getchar();
}

void VariableArgumentFunc(char *_szTypes, ...)
{
	union VarType {
		char c;
		short s;
		int i;
		long l;
		long long L;
		float f;
		double d;
		long double D;
		char *S;
		int *I;
	}VarType;

	int i = 0;
	char *pTemp = NULL;
	va_list arg_ptr = NULL;

	va_start(arg_ptr, _szTypes);

	for (i = 0; _szTypes[i] != '\0'; i++)
	{
		pTemp = arg_ptr;

		switch (_szTypes[i])
		{
		case 'c':
			VarType.c = va_arg(arg_ptr, int); //char
			printf("char: %c\n", VarType.c);
			printf("read char(int): 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 's':
			VarType.s = va_arg(arg_ptr, int); //short
			printf("short: %hd\n", VarType.s);
			printf("read short(int): 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'i':
			VarType.i = va_arg(arg_ptr, int);
			printf("int: %d\n", VarType.i);
			printf("read int: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'l':
			VarType.l = va_arg(arg_ptr, long);
			printf("long: %ld\n", VarType.l);
			printf("read long: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'L':
			VarType.L = va_arg(arg_ptr, long long);
			printf("long long: %lld\n", VarType.L);
			printf("read long long: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'f':
			VarType.f = va_arg(arg_ptr, double); //float
			printf("float: %f\n", VarType.f);
			printf("read float: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'd':
			VarType.d = va_arg(arg_ptr, double);
			printf("double: %lf\n", VarType.d);
			printf("read double: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'D':
			VarType.D = va_arg(arg_ptr, long double);
			printf("long double: %Lf\n", VarType.D);
			printf("read long double: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'S':
			VarType.S = va_arg(arg_ptr, char*);
			printf("char*: %s\n", VarType.S);
			printf("read char*: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		case 'I':
			VarType.I = va_arg(arg_ptr, int*);
			printf("int*: %d\n", *(VarType.I));
			printf("read int*: 0x%p -> 0x%p (%d)\n", pTemp, arg_ptr, arg_ptr - pTemp);
			break;
		}

		printf("\n");
	}

	va_end(arg_ptr);
}
```

### 결과2

![variable_argument_x86](https://user-images.githubusercontent.com/19742979/56397967-594c8100-6281-11e9-91ef-d1516e7ea1c6.PNG){: .align-center}

![variable_argument_x64](https://user-images.githubusercontent.com/19742979/56397966-581b5400-6281-11e9-9e23-18fb7412f4cf.PNG){: .align-center}

 위의 결과를 보면 포인터가 각 플랫폼 별 스택의 단위 크기 만큼 이동하고 있다.