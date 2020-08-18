---
title: "중첩 스크롤 Touch 이벤트 처리"
excerpt: ""
use_math: true
categories:
 - android
last_modified_at: 2020-08-15T01:07:00
---

View의 터치 이벤트가 부모 ViewGroup으로 전달되는 것을 막기 위해 일반적으로 다음과 같이 처리한다.

```java
myView.setOnTouchListener(new View.OnTouchListener() {
  @Override
  public boolean onTouch(View view, MotionEvent motionEvent) {
    return true; // true를 반환하면 부모 ViewGroup으로 터치 이벤트가 전달되지 않음
  }
});
```

하지만 중첩 스크롤 구성에서는 위 방법으로 문제를 해결할 수 없다. 

여기서 중첩 스크롤의 구성이란 일반적인 클릭, 터치의 조작이 아닌 스크롤, 스와이프, 제스처 등의 조작이 가능한 뷰들의 중첩이라고 생각하면 될 것 같다. 예를들어 두 개 이상의 `(Nested)ScrollView` 중첩, `(Nested)ScrollView`와 `RecyclerView`, `ViewPager`와 `MapView(지도를 표시하는 뷰)` 등 다양한 조합이 가능하다.

중첩 스크롤 구성에서 위와 같은 방법으로 구현한 코드와 결과이다.

```java
// NestedScrollView와 ScrollView의 중첩
scrollViewChild.setOnTouchListener(new View.OnTouchListener() {
  @Override
  public boolean onTouch(View view, MotionEvent motionEvent) {
    return true;
  }
});
```

<img src="https://user-images.githubusercontent.com/19742979/90317311-71124300-df63-11ea-846b-43469ab5cc26.gif" style="width:250px; display:block; margin-left:auto; margin-right:auto"/>

`ViewParent`의 `requestDisallowInterceptTouchEvent(boolean)` 메소드를 사용하여 이 문제를 해결할 수 있다. 파라미터를 `true`로 전달하게 되면, 자신의 부모 뷰가 터치 이벤트를 가로채지 않도록 해준다.

```java
scrollViewChild.setOnTouchListener(new View.OnTouchListener() {
  @Override
  public boolean onTouch(View view, MotionEvent motionEvent) {
    view.getParent().requestDisallowInterceptTouchEvent(true);
    return false;
  }
});
```

<img src="https://user-images.githubusercontent.com/19742979/90317257-f5b09180-df62-11ea-9671-10ef1abbf87c.gif" style="width:250px; display:block; margin-left:auto; margin-right:auto"/>