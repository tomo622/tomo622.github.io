---
title: "NDK (Native Development Kit)"
excerpt: ""
categories:
 - android
last_modified_at: 2020-08-17T13:35:00
---

안드로이드에서 C, C++ 코드를 사용할 수 있게 해주는 도구 모음이다.

안드로이드는 자바와 마찬가지로 네이티브 코드를 사용하기 위해 JNI (Java Native Interface)를 사용하고 있다.

`.so`파일(네이티브 공유 라이브러리), `.a`파일(네이티브 정적 라이브러리)를 빌드할 수 있다. NDK가 `.so`파일을 빌드할 때 ABI (Application Binary Interface)의 정의에 따라서 다양한 CPU 아키텍처에 대응한다. 이는 ABI에 앱의 기계어 코드가 런타임 시 시스템과 어떻게 상호작용할지 정의되어 있기 때문에 가능하다.

> 추가)  
> ABI에는 Calling Convention이 정의되어 있고 이는 CPU 아키텍처에 따라 다르다. NDK는 ABI의 정보를 통해 각 CPU 아키텍처에 맞춰 `.so`파일을 빌드하거나 사용할 수 있는 것이다.
>
> NDK에서 지원하는 ABI는 안드로이드 개발자 페이지를 참고하면 된다.

