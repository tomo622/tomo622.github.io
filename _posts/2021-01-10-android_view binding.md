---
title: "View Binding"
excerpt: ""
categories:
 - android
last_modified_at: 2021-01-11T01:25:00
---

# build.gradle 설정

```groovy
android {
	viewBinding{
		enabled=true
	}
}
```

- 모듈에 포함된 모든 레이아웃 XML 파일에 대해 Binding Class 가 자동 생성
- 각 XML 파일 이름을 파스칼 표기법으로 변환하여 Binding Class 이름 지정 (접미사 '-Binding' 추가)
- 각 XML 파일에 구현되어 있는 Root View 와 ID 값을 갖는 모든 View 에 대한 참조 포함



# Layout XML File

```xml
<!-- activity_main.xml -->

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
	xmlns:android="http://schemas.android.com/apk/res/android"
  android:layout_width="match_parent"
	android:layout_height="match_parent" >
  
	<TextView
    android:id="@+id/textView"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Hello" />

  <TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text=" World!" />
  
</LinearLayout>
```

레이아웃 리소스를 액티비티와 연결하기 위해서 기존에 Root View 에 설정해야했던 `tools:context="<Activity Class Name>"` 속성은 더이상 필요하지 않다.

ID 속성을 지정하지 않은 두번째 TextView 는 참조할 수 없다.



# Activity 에서 Binding Class 사용하기

```java
// MainActivity.java

public class MainActivity extends AppCompatActivity{
  private ActivityMainBinding binding;
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    binding = ActivityMainBinding.inflate(getLayoutInflater());
    setContentView(binding.getRoot());
    
    binding.textView.setText("Hi");
  }
}
```



# 생성된 Binding Class 분석

Binding Class 는 `<PROJECT>/app/build/generated/data_binding_base_class_source_out/<debug|release>/out/<PACKAGE PATH>/databinding/` 하위에 컴파일러에 의해 자동으로 생성된다.

```java
// ActivityMainBinding.java

public final class ActivityMainBinding implements ViewBinding {
  @NonNull
  private final LinearLayout rootView;

  @NonNull
  public final TextView textView;

  private ActivityMainBinding(@NonNull LinearLayout rootView, @NonNull TextView textView) {
    this.rootView = rootView;
    this.textView = textView;
  }

  @Override
  @NonNull
  public LinearLayout getRoot() {
    return rootView;
  }

  @NonNull
  public static ActivityMainBinding inflate(@NonNull LayoutInflater inflater) {
    return inflate(inflater, null, false);
  }

  @NonNull
  public static ActivityMainBinding inflate(@NonNull LayoutInflater inflater,
      @Nullable ViewGroup parent, boolean attachToParent) {
    View root = inflater.inflate(R.layout.activity_main, parent, false);
    if (attachToParent) {
      parent.addView(root);
    }
    return bind(root);
  }

  @NonNull
  public static ActivityMainBinding bind(@NonNull View rootView) {
    int id;
    missingId: {
      id = R.id.textView;
      TextView textView = rootView.findViewById(id);
      if (textView == null) {
        break missingId;
      }

      return new ActivityMainBinding((LinearLayout) rootView, textView);
    }
    String missingId = rootView.getResources().getResourceName(id);
    throw new NullPointerException("Missing required view with ID: ".concat(missingId));
  }
}

```

1. `inflate(...)` 메소드를 호출하게 되면 내부에서는 `inflater` 를 통해 상응하는 XML 파일의 레이아웃 리소스를 `View` 객체로 전개하여 `bind(...)` 메소드에 전달한다. 이때 `View` 객체는 Root View 이다.
2. `bind(...)` 에서는 전달 받은 `View` 객체를 통해 하위의 모든 View 를 찾아 인스턴스화 한다. 이때 리소스 ID 를 사용하기 때문에 레이아웃 리소스 파일에서 ID 속성이 명시되어 있지 않으면 인스턴스화 할 수 없다.
3. 마지막으로, 전개된 Root View 와 인스턴스화 된 모든 View 를 생성자에 전달하면서 Binding 객체를 생성한다.



# Fragment 에서 Binding Class 사용하기

```java
// SubFragment.java

public class SubFragment extends Fragment{
  private FragmentSubBinding binding;
  
  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    binding = ActivityMainBinding.inflate(inflater, container, false);
    View view = binding.getRoot();

    binding.textView.setText("Hi");
    
    return view;
}

	@Override
	public void onDestroyView() {
		super.onDestroyView();
		binding = null;
  }
}
```

`onDestroyView()` 에서 Binding 객체를 정리해야한다.



# View Binding 무시하기

특정 레이아웃에서는 View Binding 를 피하고 싶은 경우, 아래와 같이 해당 레이아웃 파일의 Root View 에 `tools:viewBindingIgnore="true"`속성을 추가한다.

```xml
<!-- activity_main.xml -->

<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
	xmlns:android="http://schemas.android.com/apk/res/android"
 	xmlns:tools="http://schemas.android.com/tools"
  android:layout_width="match_parent"
	android:layout_height="match_parent" 
	tools:viewBindingIgnore="true" >
  ...
```

컴파일러는 해당 레이아웃 XML 파일에 상응하는 Binding Class 파일을 생성하지 않는다.

