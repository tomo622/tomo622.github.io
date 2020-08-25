---
title: "Application Class"
excerpt: ""
categories:
 - android
last_modified_at: 2020-08-25T22:50:00
---

어플리케이션의 **전역적 상태**를 유지하기 위한 기본 클래스이다. 이를 상속 받아 서브 클래스를 구성할 수 있으며 프로세스 실행 시 *가장 먼저 자동으로 인스턴스화 된다.* 생성된 객체는 어플리케이션 실행 동안 유지되고 어느 액티비티에서도 접근 가능하다. (`Application` 클래스가 싱크톤인 것은 아니다.)

위 특징들로 인하여 어플리케이션의 공유 데이터를 저장하는 용도로 자주 사용된다.

# Application Subclass

1. `Application` 클래스를 상속 받는다.

```java
public class ApplicationSubClass extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
    }
}
```

2. `AndroidManifest.xml` 에 등록한다.

```xml
<application
	android:name=".ApplicationSubClass"
	... >
</application>
```

3. `Activity.getApplication()` 또는 `Context.getApplicationContext()` 를 통해 접근한다.

```java
ApplicationSubClass app = (ApplicationSubClass)getApplication();
```

