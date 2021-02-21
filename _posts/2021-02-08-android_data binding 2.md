---
title: "Data Binding(2)"
excerpt: ""
categories:
 - android
last_modified_at: 2021-02-21T17:26:00
---

# ViewStub 에 Data Binding 적용하기

Data Binding 라이브러리는 레이아웃에 ViewStub가 존재하는 경우 Binding Class 생성 시 이를 `ViewStubProxy` 로 대체한다. 

### ViewStubProxy

ViewStubProxy는 내부적으로 ViewStub 객체와 확장된 View 를 참조할 멤버변수를 모두 포함하고 있다. 따라서 전개 이전엔 ViewStub를, 전개 후엔 확장된 View를 접근할 수 있다. 또한 내부에서 `ViewStub.OnInflateListener` 를 생성하여 등록한다.

```java
// ViewStubProxy.java
...
private ViewStub mViewStub;
private ViewDataBinding mViewDataBinding; // 확장된 View에 대한 Binding Class
private View mRoot; // 확장된 View를 담는 멤버변수
...
// ViewStub의 전개가 성공한 후 호출되는 리스너
private OnInflateListener mProxyListener = new OnInflateListener() {
  @Override
  public void onInflate(ViewStub stub, View inflated) {
    // 확장된 View를 멤버변수로 저장
    mRoot = inflated;
    // 확장된 View에 Data Binding이 사용된 경우 해당 Binging Class에 결합하여 binding 객체 생성
    // 때문에 확장된 View에 대한 Binding Class에 접근할 수 있다.
    mViewDataBinding = DataBindingUtil.bind(mContainingBinding.mBindingComponent,
                                            inflated, stub.getLayoutResource());
    mViewStub = null;

    //아래 setOnInflateListener(ViewStub.OnInflateListener) 메서드로 등록된 리스너가 존재한다면 이벤트를 전달한다.
    if (mOnInflateListener != null) {
      mOnInflateListener.onInflate(stub, inflated);
      mOnInflateListener = null;
    }
    mContainingBinding.invalidateAll();
    mContainingBinding.forceExecuteBindings();
  }
};

public void setOnInflateListener(@Nullable OnInflateListener listener) {
  if (mViewStub != null) {
    mOnInflateListener = listener;
  }
}

public ViewDataBinding getBinding() {
  return mViewDataBinding;
}

public ViewStub getViewStub() {
  return mViewStub;
}
```

ViewStubProxy 사용 시 확장되는 View에 Data Binding이 사용된 경우 **전개 성공 후 데이터 결합이 진행되어야 한다.** 따라서 `ViewStubProxy.setOnInflateListener` 에 리스너를 등록하여 이벤트 발생 시점에 결합을 설정한다.

```xml
<!-- activity_main.xml -->
<?xml version="1.0" encoding="utf-8"?>
<layout ... >
	...
  <LinearLayout ... >
    <Button ... android:id="@+id/buttonInflateViewStub"/>
    <ViewStub
              android:id="@+id/viewStub"
              android:inflatedId="@+id/viewReplace"
              android:layout_width="match_parent"
              android:layout_height="match_parent"
              android:layout="@layout/view_replace"/>
  </LinearLayout>
</layout>
```

```xml
<!-- view_replace.xml -->
<layout ... >
  <data>
    <variable name="data" type="String" />
  </data>

  <LinearLayout ... >
    <TextView
              android:layout_width="wrap_content"
              android:layout_height="wrap_content"
              android:layout_gravity="center"
              android:text="@{data}"/>
  </LinearLayout>
</layout>
```

```java
// MainActivity.java

public class MainActivity extends AppCompatActivity {
  ActivityMainBinding binding;
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    ...
    binding.viewStub.setOnInflateListener(new ViewStub.OnInflateListener() {
      // ViewStub 전개 성공 후 호출
      @Override
      public void onInflate(ViewStub viewStub, View view) {
        // 확장된 View에 대한 데이터 결합 진행
        ViewReplaceBinding viewReplaceBinding = (ViewReplaceBinding) binding.viewStub.getBinding(); // 확장된 View에 대한 Binding Class 객체 참조
        viewReplaceBinding.setData("REPLACE VIEW");
      }
    });

    binding.buttonInflateViewStub.setOnClickListener(view->{
      binding.viewStub.getViewStub().inflate(); // ViewStub(ViewStubProxy) 전개
    });
  }
}
```



즉시 결합, 고급결합, 백그라운드 스레드