---
title: "ViewStub"
excerpt: "findViewById, View Binding, Data Binding"
categories:
 - android
last_modified_at: 2021-02-21T12:28:00
---

런타임에 레이아웃 리소스를 느리게 확장할 수 있는 View 이다. 필요할 때만 View를 로드하여 메모리 사용을 줄이고 렌더링 속도를 높일 수 있다.

최초에 레이아웃이 보이지 않고 크기가 0 인 상태로 View 계층 구조에 존재한다.

런타임 중 ViewStub가 보여지거나(`setVisibility(View.VISIBLE)`) 레이아웃 리소스가 확장(`inflate()`) 되면 ViewStub는 속성으로 지정된 다른 레이아웃을 확장하여 *자신을 대체한다.* 따라서 확장된 새로운 View는 ViewStub의 레이아웃 매개변수와 함께 ViewStub의 부모에 추가된다. 이때 ViewStub는 View 계층 구조에서 사라지고 ViewStub의 ID는 더이상 유효하지 않다.

`layout` 속성에 확장 시 대체할 레이아웃을 지정한다. `inflatedId` 속성을 이용해 ViewStub가 갖는 ID와 별개로 확장 후 대체되는 View에 ID 값을 지정할 수 있다.

```xml
<!-- activity_main.xml -->
<LinearLayout ... >
  <Button ... android:id="@+id/btnInflateViewStub"/>
  <ViewStub
            android:id="@+id/viewStub"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:inflatedId="@+id/viewReplace"
            android:layout="@layout/view_replace"/>
</LinearLayout>
```

```xml
<!-- view_replace.xml -->
<LinearLayout ... >
  <TextView ... android:id="@+id/textView"/>
</LinearLayout>
```

```java
// MainActivity.java
public class MainActivity extends AppCompatActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
   	...
    Button btnInflateViewStub = findViewById(R.id.btnInflateViewStub);
    ViewStub viewStub = findViewById(R.id.viewStub);
    
    viewStub.setOnInflateListener(new ViewStub.OnInflateListener() {
      @Override
      public void onInflate(ViewStub viewStub, View view) {
        ((TextView)view.findViewById(R.id.textView)).setText("REPLACE VIEW");
      }
    });

    btnInflateViewStub.setOnClickListener(view -> {
			viewStub.inflate(); 
      // 또는
      viewStub.setVisibility(View.VISIBLE);
    });
  }
}
```

`View.OnInflateListener` 는 ViewStub가 레이아웃 리소스를 성공적으로 확장 한 후 알림을 수신한다.

`inflate()` 를 사용하여 View를 확장하는 경우 확장된 View를 반환하지만, `setVisibility(View.VISIBLE)` 을 이용해 View를 확장하는 경우 `inflatedId` 값으로 View를 참조해야한다.

