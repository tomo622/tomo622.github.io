---
title: "Native Library 사용하기"
excerpt: ""
categories:
 - android
last_modified_at: 2020-08-18T00:14:00
---

# ABI 빌드를 위한 Gradle 설정

네이티브 라이브러리(`.so`, `.a` 파일)의 사용(포함) 및 빌드해야하는 경우 지원하려는 아키텍쳐를 명시해줘야한다. (본 포스팅에서는 사용하는 경우에 대한 내용만 다룬다.)

`build.gradle`에서 `abiFilters`를 사용해 지원하는  아키텍쳐의 ABI를 지정한다.

```java
android{
  defaultConfig{
    ndk{
      abiFilters 'armeabi-v7a','arm64-v8a','x86','x86_64'
    }
  }
}
```

빌드 결과 단일 APK에 아키텍쳐 별 ABI용 바이너리를 포함한 `fat APK`가 생성된다. `fat APK`는 `multi-architecture binary`라고도 하며 이름에서 알 수 있는 것 처럼 기기 호환성을 넓어지지만 일반 단일 APK 보다 크기가 커진다.

안드로이드 시스템은 **런타임 시 어떤 ABI를 지원하는지 알게되기 때문에** `fat APK` 설치 시 패키지 관리자는 *기기에 가장 알맞은 네이티브 코드를 선택하여 압축을 해제*한다.

> 참고)  
> `fat APK`처럼 기기 호환성은 최대로 유지하면서 APK 크기를 줄이기 위한 방법으로 `App Bundle`과 `다중 APK`을 활용할 수 있다.
>
> `App Bundle` 빌드는 애플리케이션을 Google Play에 게시할 때 사용된다. Google Play에서 사용자의 기기 설정에 최적화된 APK를 자동으로 생성하여 제공한다. 이렇게 Google Play에 게시하지 않는 애플리케이션의 경우 `다중 APK` 빌드를 통해 위에서 언급한 이점을 챙길 수 있다.
>
> Google Play에 올릴 수 없는 애플리케이션을 개발하는 것이 아니라면 개발 과정에서는 `fat APK`로 빌드하고 애플리케이션 출시 시에만 `App Bundle` 빌드를 하면 되겠다.



# APK내의 Native Code의 위치

패키지 관리자와 Play 스토어는 APK 내부에서 아래와 같은 패턴으로 네이티브 코드를 찾는다.

```
/lib/<abi>/lib<name>.so
```



# 기본 ABI와 보조 ABI

- 기본 ABI (Primary ABI): 해당 시스템 이미지 자체에서 사용되는 기계어 코드와 일치하는 ABI
- 보조 ABI (Secondary ABI): 필요한 경우 시스템 이미지에서 지원하는 다른 ABI

기본 ABI로 컴파일 하는 것이 성능에 좋다.

패키지 관리자는 애플리케이션 설치 시 기본 ABI에 해당하는 네이티브 코드 찾는다. 만약 찾을 수 없다면 보조 ABI에 해당하는 네이티브 코드를 찾는다. 네이티브 코드를 하나도 찾지 못한다면 빌드와 설치는 되지만 런타임 시 애플리케이션이 다운된다.

```
// 탐색하는 순서가 정해지는 것 뿐 APK 내의 네이티브 코드 위치와 동일하다.
lib/<primary-abi>/lib<name>.so // 기본 ABI에 해당하는 네이티브 코드 위치
lib/<secondary-abi>/lib<name>.so // 보조 ABI에 해당하는 네이티브 코드 위치
```

아래와 같은 방법으로 현재 CPU가 지원하는 ABI의 목록을 알 수 있다.

```java
//An ordered list of ABIs supported by this device. The most preferred ABI is the first element in the list.
String[] ABIS = Build.SUPPORTED_ABIS;
```



# 다중 APK를 통한 ABI 빌드

ABI를 위한 다중 APK를 구성하면 기기 호환성을 유지하고 APK의 크기는 줄일 수 있다.

`build.gradle`에서 `splits`와 `abi` 블록을 사용해 지원하는  아키텍쳐의 ABI를 지정한다.

```java
android {
  splits {
    abi {
      enable true // true 이면 정의한 ABI에 기반하여 다중 APK를 생성한다. 기본값은 false
      
      // 기본적으로 모든 ABI가 포함된다. 특정한 ABI를 지정하고 싶은 경우 reset()과 include를 사용해야한다.
      // include에 지정된 ABI를 사용하기 위해서는 반드시 reset()이 함께 사용되어야한다.
      reset()			// ABI 기본 목록을 삭제한다. 즉, include와 함께 사용된다.
      include "x86", "x86_64", "armeabi-v7a","arm64-v8a" // 생성해야 하는 ABI 목록을 지정한다.
      
      universalApk false // true이면 단일 APK에 모든 ABI코드와 리소스가 포함된 범용 APK를 생성한다. 기본값은 false
    }
  }
}
```

> 주의)  
> `ndk의 버전을 `build.gradle`에 명시해야한다.  `  
> `abiFilters`를 사용하여 일반적인 `fat APK`를 구성하는 방법과 함께 사용될 수 없다.



# 테스트

**AVD 환경**

- API: 30
- CPU: x86
- 지원 ABI: x86 (primary), armeabi-v7a, armeabi

**Library**

- Kakao Map API
- 지원 ABI: armeabi-v7a, arm64-v8a, armeabi

**fat APK Build**

```java
// build.gradle
android {
  ...
  defaultConfig {
    ...
    ndk.abiFilters 'armeabi-v7a','arm64-v8a','x86','x86_64'
  }
}
```

<img src="https://user-images.githubusercontent.com/19742979/90416074-f4ab6b80-e0ec-11ea-931a-7eb884428229.png" style="display: block; margin-left: auto; margin-right: auto; width: 600px" />

시스템은 해당 기기의 기본 ABI인 x86에 대한 네이티브 라이브러리를 찾지만 라이브러리는 x86을 지원하지 않는다. 첫 번째 보조 ABI인 armeabi-v7a 를 찾았고 이를 설치하게 된다.

**다중 APK**

```java
// build.gradle
android{
  ...
  defaultConfig {
    ...
    ndkVersion "21.3.6528147" // NDK 버전 명시
  }
  splits{
    abi{
      enable true // 모든 ABI를 포함
      universalApk false
    }
  }
}
```

NDK의 버전은 Project Structure 에서 지정해도 된다.

<img src="https://user-images.githubusercontent.com/19742979/90417506-c3339f80-e0ee-11ea-8d69-24a2c81c9eee.png" style="display: block; margin-left: auto; margin-right: auto; width:600px" />

<img src="https://user-images.githubusercontent.com/19742979/90417883-4e149a00-e0ef-11ea-9e7f-09fbc18f1f99.png" style="display: block; margin-left: auto; margin-right: auto; width: 300px" />

NDK에서 지원하는 모든 ABI의 종류 별로 APK 파일이 생성됐다. 시스템은 해당 기기의 아키텍처에 맞는 x86 용 APK를 선택하여 설치하게 된다. 하지만 라이브러리는 x86을 지원하지 않는다. 위 `app-x86-debug.apk` 파일을 열어보면 라이브러리를 포함하지 않는 것을 볼 수 있다. 해당 APK로 설치가 되지만 네이티브 코드를 찾지 못했기 때문에 런타임 시점에 애플리케이션이 종료되버린다.

<img src="https://user-images.githubusercontent.com/19742979/90418381-06424280-e0f0-11ea-80fa-99777df38cee.png" style="display: block; margin-left: auto; margin-right: auto; width: 600px" />

문제를 해결하기 위해 x86 ABI를 포함하지 않도록 해야한다.

```java
// build.gradle
android{
  ...
  splits{
    abi{
      enable true
      reset()
      include "armeabi-v7a", "arm64-v8a"
      universalApk false
    }
  }
}
```
<img src="https://user-images.githubusercontent.com/19742979/90418965-cf206100-e0f0-11ea-99c2-a1f664dd02f7.png" style="display: block; margin-left: auto; margin-right: auto; width: 300px" />

지정된 ABI에 대한 APK 파일만이 생성되었다. 시스템은 해당 기기의 아키텍처를 확인하여 기본 ABI인 x86 용 APK를 찾지만 존재하지 않는다. 보조 ABI를 확인하고 그에 맞는 armeabi-v7a 용 APK를 선택하여 설치하게 된다. `app-armeabi-v7a-debug.apk`를 열어보면 라이브러가 포함되어 있는 것을 볼 수 있다. 애플리케이션이 정상 작동한다.

<img src="https://user-images.githubusercontent.com/19742979/90419123-10b10c00-e0f1-11ea-926a-d984755d7d78.png" style="display: block; margin-left: auto; margin-right: auto; width: 600px" />

또한 파일의 크기는 fat APK 보다 작은 것을 확인할 수 있다. (fat APK 는 3.8MB)

