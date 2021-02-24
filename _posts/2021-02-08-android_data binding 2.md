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



# RecyclerView Adapter 에 Data Binding 적용하기

```xml
<!-- activity_main.xml -->
<layout ... >
  <LinearLayout ... >
    <androidx.recyclerview.widget.RecyclerView ... android:id="@+id/recyclerView" />
  </LinearLayout>
</layout>
```

```xml
<!-- view_item -->
<?xml version="1.0" encoding="utf-8"?>
<layout ... >
  <data>
    <variable name="data" type="String" />
  </data>
  <LinearLayout ... >
    <TextView ... android:text="@{data}"/>
  </LinearLayout>
</layout>
```

```java
// MainActivity.java
public class MainActivity extends AppCompatActivity {
	...
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    ... 
    ArrayList<String> items = new ArrayList<>();
    for(int i = 0; i < 100; i++){
      items.add(Integer.toString(i));
    }
    MyAdapter adapter = new MyAdapter(items);

    binding.recyclerView.setAdapter(adapter);
    binding.recyclerView.setLayoutManager(new LinearLayoutManager(this));
  }
}
```

```java
public class MyAdapter extends RecyclerView.Adapter<MyAdapter.MyViewHolder> {
  ArrayList<String> items = new ArrayList<>();

  public MyAdapter(ArrayList<String> items){
    this.items = items;
  }

  @NonNull
  @Override
  public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
    View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.view_item, parent, false);
    return new MyViewHolder(view);
  }

  @Override
  public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
    final String item = items.get(position);
    holder.getBinding().setData(item);
    holder.getBinding().executePendingBindings();
  }

  @Override
  public int getItemCount() {
    return items.size();
  }

  public class MyViewHolder extends RecyclerView.ViewHolder{
    private ViewItemBinding binding;

    public MyViewHolder(@NonNull View itemView) {
      super(itemView);
      binding = ViewItemBinding.bind(itemView);
    }

    public ViewItemBinding getBinding(){
      return binding;
    }
  }
}
```

결합된 데이터 변경 시 이에 대한 UI의 업데이트는 가까운 미래(프레임 변경 이전)에 예약된다. 때문에 데이터가 변경된다고 해서 관련된 View에 즉각적인 영향을 미치진 않는다.

이러한 메커니즘은 변경된 데이터에 대한 UI 업데이트를 한 번에 처리함으로써 성능상의 이점을 얻을 수 있다.

데이터 변경 시 즉각적인 View의 변화를 위해서는 `ViewDataBinding.executePendingBindings()` 메서드를 호출한다. `ViewDataBinding.executePendingBindings()` 메서드는 보류중인 모든 변경에 대한 UI를 업데이트한다. 단, 이는 UI 스레드에서 실행되기 때문에 자주 호출되지 않는것이 좋다.



# 백그라운드 스레드

Data Binding은 백그라운드 스레드에서 데이터 모델의 변경이 가능하다. 단, 컬렉션은 불가능하다.