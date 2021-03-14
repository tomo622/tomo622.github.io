---
title: "수명 주기 인식"
excerpt: ""
categories:
 - android
last_modified_at: 2021-03-14T17:24:00
---

일반적으로 `onStart`, `onStop` 등과 같은 수명 주기 메서드에 구성요소나 UI 관리를 위한 구현 코드가 많이 배치되어 유지 관리가 어렵고 수명 주기 메서드의 흐름대로 동작할 것이라고 보장할 수 없다.

수명 주기 인식을 위한 `androidx.lifecycle` 패키지는 액티비티나 프래그먼트 같은 구성요소의 수명 주기 상태 변경에 따라 작업을 실행할 수 있는 클래스 및 인터페이스를 제공한다.



# LifecycleOwner Interface

Lifecycle를 소유하는 단일 메서드(`getLifecycle()`) 인터페이스

> **참고**: 애플리케이션 전체 프로세스의 수명 주기를 관리하는 경우 ProcessLifecycleOwner Class를 사용

액티비티나 프래그먼트 같은 구성요소는 이 인터페이스를 구현하여 Lifecycle 객체에 수명 주기 상태를 제공한다. `Fragment` 와 `AppComatActivity` 에는 이미 LifecycleOnwer 인터페이스가 구현되어 있다.



### LifecycleOwner Interface 구현하기

`Lifecycle` 을 확장한 `LifecycleRegistry` 를 사용하여 이벤트를 전달한다.

```java
public class MainActivity extends Activity implements LifecycleOwner {
 	...
  LifecycleRegistry lifecycleRegistry;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    ...
    lifecycleRegistry = new LifecycleRegistry(this);
    lifecycleRegistry.setCurrentState(Lifecycle.State.CREATED);
  }

  @Override
  protected void onStart() {
    super.onStart();
    lifecycleRegistry.setCurrentState(Lifecycle.State.STARTED);
  }

  @Override
  protected void onResume() {
    super.onResume();
    lifecycleRegistry.setCurrentState(Lifecycle.State.RESUMED);
  }

  @NonNull
  @Override
  public Lifecycle getLifecycle() {
    return lifecycleRegistry;
  }
}
```



# Lifecycle Class

- 특정 *구성요소*(LifecycleOwner)에 종속되어 있음
- *구성요소의* 수명 주기 상태 정보 저장
- 현재 *구성요소의* 수명 주기 상태 조회(`getCurrentState()`)
- *구성요소*의 수명 주기 상태 변경 알림을 받을 관찰자(LifecycleObserver) 추가(`addObserver(LifecycleObserver)`), 삭제(`removeObserver(LifecycleObserver)`)
- `Lifecycle.Event`, `Lifecycle.State` 두 가지의 열거를 사용하여 수명 주기 상태를 추적  
  <img width="568" alt="android_lifecycle aware_img1" src="https://user-images.githubusercontent.com/19742979/110801936-1060a400-82c1-11eb-94af-23f2193d241f.png">



# LifecycleObserver Interface

`@OnLifecycleEvent` 애너테이션을 추가하여 구성요소(LifecycleOwner)의 수명 주기 상태를 모니터링한다.

*액티비티나 프래그먼트 같은 구성요소의 수명 주기 메서드에 집중 되던 로직들이 각 관찰자에게 분산된다.*  



# 사용법

```java
// 변경 전
public class MainActivity extends AppCompatActivity {
  private Normal normal;
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    ...
    normal = new Normal();
  }

  @Override
  protected void onStart() {
    super.onStart();
    
    // 수명 주기 메서드에 로직이 집중됨
    normal.method1();
    normal.method2();
  }
  
  class Normal{
    public void method1(){
      Log.d("NORMAL", "method1");
    }

    public void method2(){
      Log.d("NORMAL", "method2");
    }
  }
}
```

위와 같은 일반적인 코드에 수명 주기 인식을 적용하면 아래와 같이 변경된다.

```java
// 변경 후
public class MainActivity extends AppCompatActivity {
	...
  Observer observer;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    ...
    observer = new Observer(getLifecycle());
    observer.checkLifecycleMethod("from onCreate");
  }

  @Override
  protected void onStart() {
    super.onStart();
    observer.checkLifecycleMethod("from onStart");
  }

  @Override
  protected void onResume() {
    super.onResume();
    observer.checkLifecycleMethod("from onResume");
  }
  
  class Observer implements LifecycleObserver{
    private Lifecycle lifecycle;

    public Observer(Lifecycle lifecycle){
      this.lifecycle = lifecycle;
      lifecycle.addObserver(this); // LifecycleOwner에서 직접 추가해도 된다.
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    private void method1(){
      Log.d("OBSERVER", "method1");
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    private void method2(){
      Log.d("OBSERVER", "method2");
    }

    // Lifecycle의 현재 상태를 확인한 후에 로직을 실행한다.
    public void checkLifecycleMethod(String callby){
      if(lifecycle.getCurrentState().isAtLeast(Lifecycle.State.STARTED)){
        Log.d("OBSERVER", "Lifecycle Owner Started! (" + callby + ")");
      }
    }
  }
}
```

```
[결과]
OBSERVER: method2
OBSERVER: method1
OBSERVER: Lifecycle Owner Started! (from onResume)
```

> **참고**: `Lifecycle.State.isAtLeast(Liftcycle.State)` 메서드는 주어진 상태보다 크거나 같은지 비교한다.

