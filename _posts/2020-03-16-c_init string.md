---
title: "문자열 초기화 시 배열과 포인터 변수의 차이점"
excerpt: "배열과 포인터 변수에 문자열을 초기화할 때 차이점을 알아본다."
categories:
 - c language
last_modified_at: 2020-03-16T02:40:00
---

### 포인터 변수

```c
char *a = "test";
```

 `"test"` 라는 상수 문자열의 첫 번째 주소를 포인터 변수 `a`에 저장한다. 이때 상수 문자열은 Initialized Data 메모리 영역에 위치한다. 이 영역은 할당 후 값의 변경이 불가능하기 때문에 포인터 변수 `a`를 통한 접근은 가능하지만 값의 변경은 불가능하다. (read only)

![pointer_variable](https://user-images.githubusercontent.com/19742979/55703736-62ce2180-5a15-11e9-9e9c-ed2a960772af.PNG){: .align-center}



### 배열

```c
char a[] = "test";
```

 `"test" `라는 상수 문자열의 값을 배열 `a`에 복사한다. `a`가 상수 문자열에 접근하는 것이 아니기 때문에 데이터의 변경이 가능하다.

![array](https://user-images.githubusercontent.com/19742979/55703720-5944b980-5a15-11e9-91ed-2d1d377e7929.PNG){: .align-center}

---



### 테스트 코드

```c
#include <stdio.h>

int main()
{
	char *str1 = "abcd";
	char *str2 = "abcd";
	char str3[] = "abcd";

	printf("const string \"abcd\" address:\n"
		"'a'=0x%p,\n"
		"'b'=0x%p,\n"
		"'c'=0x%p,\n"
		"'d'=0x%p\n",
		&("abcd"[0]), 
		&("abcd"[1]), 
		&("abcd"[2]), 
		&("abcd"[3]));

	printf("\nchar *str1=\"abcd\" address:\n"
		"str1[0]=0x%p,\n"
		"str1[1]=0x%p,\n"
		"str1[2]=0x%p,\n"
		"str1[3]=0x%p\n", 
		&(str1[0]), 
		&(str1[1]), 
		&(str1[2]), 
		&(str1[3]));
	
	printf("\nchar *str2=\"abcd\" address:\n"
		"str2[0]=0x%p,\n"
		"str2[1]=0x%p,\n"
		"str2[2]=0x%p,\n"
		"str2[3]=0x%p\n", 
		&(str2[0]), 
		&(str2[1]), 
		&(str2[2]), 
		&(str2[3]));

	printf("\nchar str3[]=\"abcd\" address:\n"
		"str3[0]=0x%p,\n"
		"str3[1]=0x%p,\n"
		"str3[2]=0x%p,\n"
		"str3[3]=0x%p\n", 
		&(str3[0]), 
		&(str3[1]), 
		&(str3[2]), 
		&(str3[3]));

	/*
	str1[1] = 'x'; //error: 상수 값 변경 시도
	str3[1] = 'x';
	*/

	getchar();
}
```

