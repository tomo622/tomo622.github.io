---
title: "Data Binding(1)"
excerpt: ""
categories:
 - android
last_modified_at: 2021-02-08T22:52:00
---

# build.gradle 설정

```groovy
android {
  dataBinding {
    enabled = true
  }
}
```

- 모듈에 포함된 모든 레이아웃 XML 파일에 대해 Binding Class 를 자동 생성
- 각 XML 파일 이름을 파스칼 표기법으로 변환하여 Binding Class 이름 지정 (접미사 '-Binding' 추가)
- 레이아웃에서 가져오기(`import`), 변수(`variable`) 및 포함(`include`) 등의 다양한 기능을 사용할 수 있음
- Data Binding 으로 작성된 라이브러리를 사용할 경우에도 위 설정이 필요함



# Data Binding Layout XML File

```xml
<!-- activity_main.xml -->
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android">
    <data>
        <variable name="dataObj" type="com.example.DataClass"/>
    </data>

    <LinearLayout ... >
        <TextView ... android:text="@{dataObj.data1}" />
        <TextView ... android:text="@{dataObj.data2}" />
    </LinearLayout>
</layout>
```

루트 태그 `layout` 이  `data` 및 Root View (`LinearLayout`) 를 감싼다. Root View 는 Data Binding 을 사용하지 않을 때 기존 레이아웃의 Root View 와 같다. 하지만 레이아웃 리소스를 액티비티와 연결하기 위해서 기존에 Root View 에 설정해야했던 `tools:context="<Activity Class Name>"` 속성은 더이상 필요하지 않다. (View Binding 에서도 동일)

View 의 특정 속성에  **표현식 구문** `@{}` 을 이용하여 `data` 에 정의 되는 변수와 `import` 된 클래스를 참조할 수 있다.



### 가져오기(`import`)

레이아웃 파일 내에서 클래스를 참조한다.

- 자료형에 대한 패키지 명을 생략할 수 있다.  

  ```xml
  <data>
    <import type="com.example.DataClass"/>
    <variable name="dataObj" type="DataClass"/>
  </data>
  ```

- `View` 클래스를 가져와 `android:visibility` 속성의 표현식 안에서 참조할 수 있다. 또한 해당 클래스의 정적 필드 및 메서드도 참조 가능하다.

  ```xml
  <data>
    <import type="android.view.View"/>
    <variable name="show" type="boolean"/>
  </data>
  ...
  android:visibility="@{show ? View.VISIBLE : View.GONE}"
  ```

- 클래스 이름 충돌 발생 시 별칭을 지정할 수 있다.  

  ```xml
  <data>
    <import type="android.view.View" />
    <improt tpye="com.example.View" alias="MyView"/>
  </data>
  ```



### 변수(`variable`)

레이아웃에서 사용할 수 있는 변수를 지정한다.

- 변수의 자료형은 컴파일 시점에 검사된다.
- 자동 생성되는 Binding Class 에는 각 변수의 getter, setter 가 정의된다. .java 파일에서는 이 Binding Class 를 이용해 특정 변수의 setter 를 호출하여 값을 설정해야한다. setter 가 호출되기 전까지 각 변수는 자료형에 대한 기본값(`null`, `0`, `false`)을 사용한다.
- `context`

> **TODO**: 이해하지 못 한 내용
>
> 1) 다양한 구성의 레이아웃 파일(가로, 세로 모드)이 서로 다를 때 변수가 결합된다. 이러한 레이아웃 파일 간에 충돌하는 변수가 정의되어서는 안 된다.
>
> 2) `context` 라는 이름의 특수 변수를 생성한다. 이는 `Context` 클래스 객체이고 Root View 의 `getContext()` 메서드를 통해 가져온다. `context` 변수는 이 이름을 사용하는 명시적 변수 선언으로 재정의 된다.



### 포함(`include`)

앱 전체에서 레이아웃을 재사용할 수 있다.

- 포함되는 레이아웃의 결합으로 변수를 전달한다.  

  ```xml
  <!-- activity_main.xml -->
  <?xml version="1.0" encoding="utf-8"?>
  <layout 
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:bind="http://schemas.android.com/apk/res-auto">
    <data>
      ...
      <variable name="dataObj" type="DataClass"/>
    </data>
    <LinearLayout ... >
      <include
  			layout="@layout/activity_sub"
  			bind:dataObj="@{dataObj}"/>
    </LinearLayout>
  </layout>
  ```

  ```xml
  <!-- activity_sub.xml -->
  <?xml version="1.0" encoding="utf-8"?>
  <layout xmlns:android="http://schemas.android.com/apk/res/android">
    <data>
      ...
      <variable name="dataObj" type="DataClass" />
    </data>
    <LinearLayout ... >
      <TextView ... android:text='@{dataObj.data1}' />
    </LinearLayout>
  </layout>
  ```

  

# Data Object

위에서 사용한 **데이터 객체** `DataClass` 의 구현은 아래와 같다.

```java
// DataClass.java
public class DataClass{
  private String data1;
  private String data2;
  
  public DataClass(String data1, String data2){
    this.data1 = data1;
    this.data2 = data2;
  }
  public String getData1(){
    return this.data1;
  }
  public String getData2(){
    return this.data2;
  }
}
```

표현식 구문에서 사용된 `dataObj.data1` 은 데이터 객체가 갖는 `getData1` 메소드에 액세스된다. 만약 데이터 객체의 프로퍼티가 `public` 접근자로 정의 된다면 해당 프로퍼티에 직접 액세스된다.



# Activity 에서 Binding Class 사용하기

```java
// MainActivity.java
public class MainActivity extends AppCompatActivity {
  ActivityMainBinding binding;
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    binding = ActivityMainBinding.inflate(getLayoutInflater());
    setContentView(binding.getRoot());
    
    DataClass dataObj = new DataClass("Hi", "Data Binding!");
    binding.setDataObj(dataObj);
  }
}
```

위 코드에서 레이아웃 리소스의 전개(`inflate`)와 그 결과물인 View 를 액티비티 내용으로 보여주는(`setContentView`) 과정을 `DataBindingUtil.setContentView` 을 사용해 한번에 처리할 수 있다.

```
binding = DataBindingUtil.setContentView(this, R.layout.activity_main);
```



# Fragment 에서 Binding Class 사용하기

```java
// SubFragment.java
public class SubFragment extends Fragment {
  private FragmentSubBinding binding;

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
    binding = FragmentSubBinding.inflate(inflater, container, false);
    // 또는
    // binding = DataBindingUtil.inflate(inflater, R.layout.fragment_sub, container, false);
    View view = binding.getRoot();

    DataClass dataObj = new DataClass("This is", "Fragment!");
    binding.setDataObj(dataObj);

    return view;
  }

  @Override
  public void onDestroyView() {
    super.onDestroyView();
    binding = null;
  }
}
```

View Binding 에서와 마찬가지로 `onDestroyView()` 에서 Binding 객체를 정리해야한다.



### Binding Class 생성 방법

```java
MyLayoutBinding binding;

/* activity 에서 사용 */
binding = MyLayoutBinding.inflate(getLayoutInflater()); 
binding = DataBindingUtil.setContentView(this, R.layout.my_layout); // inflate 와 setContentView 동시에 처리

/* fragment, adapter 에서 사용 */
binding = MyLayoutBinding.inflate(layoutInflater, viewGroup, false);
binding = DataBindingUtil.inflate(layoutInflater, R.layout.my_layout, vieweGroup, false);

/* 이미 생성된 View를 결합 */
binding = MyLayoutBinding.bind(view);
binding = DataBindingUtil.bind(view);
```



# Binding Class

Binding Class 는 `모듈 패키지/databinding` 아래에 컴파일러에 의해 자동으로 생성된다.

위에서도 언급했듯이 각 XML 파일 이름에 접미사 '-Binding' 이 추가된 상태에서 *파스칼 표기법*으로 변환된 이름으로 Binding Class 가 자동 생성된다. 또한 레이아웃의 각 View 가 지닌 ID 값은 *카멜 표기법*으로 변환되어 해당 View 에 대한 인스턴스명으로 사용된다. (View Binding Class 명명 규칙과 동일)

Binding Class 는 `ViewDataBinding` 클래스를 상속 받아 생성된다. 레이아웃의 속성(변수)과 View 의 모든 결합을 갖고 이 둘을 연결하며 표현식에 값을 할당하는 방법이 정의되어 있다. (`ViewDataBinding` 은 `BaseObservable` 를 상속 받고 `ViewBinding` 를 구현한다.)

생성되는 Binding Class 의 이름이나 위치하는 패키지를 변경할 수 있다.

```xml
<data class="MyActivity"> ... </data>
```

```xml
<data class=".MyActivity"> ... </data> <!-- 모듈 패키지 바로 아래에 생성 -->
```

```xml
<data class="com.example.sub.MyActivity"> ... </data>
```



# 표현식 언어

표현식 언어를 이용해 레이아웃의 View와 변수를 연결하는 표현식을 작성한다.

| 종류             | 표현식                     |
| ---------------- | -------------------------- |
| 산술             | `+, -, /, *, %`            |
| 문자열 연결      | `+`                        |
| 논리             | `&&, ||`                   |
| 바이너리         | `&, |, ^`                  |
| 단항             | `+, -, !, ~`               |
| 삼항 연산자      | `?, :`                     |
| Null 병합 연산자 | `??`                       |
| 비교             | `==, >, <(&lt;), >=, <=`   |
| 그룹화           | `(, )`                     |
| 리터럴           | 문자, 문자열, 숫자, `null` |
| 변환             |                            |
| 메서드 호출      |                            |
| 필드 접근        |                            |
| 배열 접근        | `[, ]`                     |
| `instanceof`     |                            |

- 표현식은 `null`(참조) 또는 `0`(`int`), `false`(`boolean`) 를 기본값으로 하는 **Null 포인터 예외 방지 기능**이 있다.

- **동일한 레이아웃의 다른 View** 가 갖는 ID 를 통해 해당 View 를 참조할 수 있다. 이때 레이아웃에 상응하는 Binding Class 에 생성된 해당 View 에 대한 인스턴스 이름을 통해 참조하는 것이기 때문에 카멜 표기법으로 변환된 ID 값을 사용해야 한다.

- 배열, 리스트, 맵과 같은 컬렉션 사용 시 각 클래스가 제공하는 메소드로 원소에 접근할 수 있지만 편의상 `[, ]` 연산자를 통해 접근할 수 도 있다. 맵에서 키로 값을 접근할 경우 `map[key]`, `map.key` 두 가지 방식을 모두 사용할 수 있다.  

  ```xml
  <data>
    ...
    <variable name="index" type="int"/>
    <variable name="key" type="String"/>
  </data>
  ...
  android:text="@{list.get(index)}"
  android:text="@{list[index]}"
  android:text="@{map.get(key)}"
  android:text="@{map[key]}"
  android:text="@{map.key}"
  ```

- 속성 값에 문자열 리터럴이 사용되는 경우 다음 두 가지 방법으로 표현식을 작성할 수 있다.  

  ```xml
  android:text="@{'VALUE'}"
  android:text='@{`VALUE`}'
  ```

- 표현식 안에서 다음과 같이 리소스를 직접 사용할 수 있고 리소스의 매개변수로 변수나 View 참조를 전달할 수 있다.  

  ```xml
  android:padding="@{dimen/paddingValue}"
  android:text="@{string/nameFormat(firstName, lastName)}"
  android:text="@{string/nameFormat(user.firstName, textViewLastName.text)}"
  ```

  >  **Note**: 리소스 유형 별 표현식 참조가 일반 참조와 다를 수 있다. 필요한 경우가 오면 찾아보고 적용하자.

- 속성 값에 기본값을 지정할 수 있다.  

  ```xml
  android:text="@{user.name, default=@string/default_name}"
  android:text='@{user.name, default="USER NAME"}'
  ```

  

# 이벤트 처리

이벤트 속성 명은 대부분 *리스너 메서드의 이름에 따라 결정*된다. 예를들어, `View.OnClickListener` 인터페이스는 `onClick(View v)` 라는 추상 메서드를 갖고있다. 따라서 이에 상응하는 이벤트 속성 명은 `android:onClick` 가 된다.

이벤트를 처리하는 메커니즘으로 **메서드 참조**와 **리스너 결합** 두 가지 방법이 있다.

```xml
<!-- activity_main.xml -->
<data>
  <variable name="handlers" type="com.example.MyHandlers" />
  <variable name="presenter" type="com.example.Presenter" />
</data>
...
<Button ...      
  android:text="METHOD REFERENCES"
  android:onClick="@{handlers::onClickForMethodReferences}" />
<Button ...      
  android:text="LISTENER BINDINGS"
  android:onClick="@{()->presenter.onClickForListenerBindings()}" />
```

```java
// MyHandlers.java
public class MyHandlers {
  // 메서드 참조를 위한 콜백 메서드
  // 매개변수와 변환형이 View.OnClickListener 의 onClick 메서드와 일치해야한다.
  public void onClickForMethodReferences(View view){
    Log.d("MyHandlers", "Clicked for Method References!");
  }
}
```

```java
// Presenter.java
public class Presenter {
  // 리스너 결합을 위한 콜백 메서드
  // 반환형만 View.OnClickListener 의 onClick 메서드와 일치하면된다.
  public void onClickForListenerBindings(){
		Log.d("Presenter", "Clicked for Listener Bindings!");
  }
}
```

```java
// MainActivity.java
public class MainActivity extends AppCompatActivity {
  ActivityMainBinding binding;
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    binding = ActivityMainBinding.inflate(getLayoutInflater());
    setContentView(binding.getRoot());

    MyHandlers handlers = new MyHandlers();
    binding.setHandlers(handlers);
    
    Presenter presenter = new Presenter();
    binding.setPresenter(presenter);
  }
}
```

메소드 참조 방식과 리스너 결합 방식의 차이점은 아래 표와 같다.

|                       | 메소드 참조                           | 리스너 결합                 |
| --------------------- | ------------------------------------- | --------------------------- |
| 표현식 실행 시점      | 데이터 결합 시점                      | 이벤트 발생 시점            |
| 콜백 메서드 정의 조건 | 리스너 메서드와 매개변수, 반환형 일치 | 리스너 메서드와 반환형 일치 |
| 표현식 내용           | 콜백 메서드 명                        | 람다식 (콜백 메서드 호출)   |



### 메소드 참조 보충

- 표현식 계산 결과 `null` 인 경우 리스너를 `null` 로 설정한다. 



### 리스너 결합 보충

- 표현식(람다식) 계산 과정에서 데이터 결합의 `null` **예외와 스레드 안정성이 보장**된다.
- `null` 객체로 인해 표현식을 계산할 수 없는 경우 리스너 메서드의 반환형에 대한 기본값(`null`, `0`, `false`)을 반환한다.

- 리스너 메서드의 *모든 매개변수를 무시*하거나 *모든 매개변수의 이름을 지정*할 수 있다.  

  ```xml
  <!-- onClick(View v)의 매개변수 'v'를 'view'로 지정 -->
  android:onClick="@{(view)->presenter.onClickForListenerBindings()}"
  ```

- 리스너 메서드의 매개변수를 콜백 메서드에서 사용하려는 경우 다음과 같이 구현한다.

  ```java
  // Presenter.java
  public class Presenter {
    public void onClickForListenerBindings(View view){
      Toast.makeText(view.getContext(), "Clicked for Listener Bindings!", Toast.LENGTH_SHORT).show();
    }
  }
  ```

  ```xml
  android:onClick="@{(view)->presenter.onClickForListenerBindings(view)}"
  ```

- 콜백 메서드에서 하나 이상의 매개변수를 받을 수 있다.  

  ```java
  // Presenter.java
  public class Presenter {
    public void onClickForListenerBindings(View view, DataClass dataObj){
      Toast.makeText(view.getContext(), dataObj.getData1(), Toast.LENGTH_SHORT).show();
    }
  }
  ```

  ```xml
  <data>
    ...
    <variable name="dataObj" type="com.example.DataClass" />
  </data>
  ...
  android:onClick="@{(view)->presenter.onClickForListenerBindings(view, dataObj)}"
  ```

> **Note**: 표현식(람다식)에서 복잡한 로직을 구현하는 대신, 호출하는 콜백 메서드 내에 비즈니스 로직을 구현하자.



### 특별한 클릭 이벤트

`View.OnClickListener` 를 사용해 특별한 클릭 이벤트를 구현하는 몇 가지 클래스가 존재한다. 이런 클래스 대한 클릭 이벤트 속성 명을 모두 `android:onClick` 으로 지정하게 되면 충돌이 발생할 수 있다. 때문에 별도의 이벤트 속성 명을 제공한다.

| 클래스       | 리스너 setter                                   | 이벤트 속성명          |
| ------------ | ----------------------------------------------- | ---------------------- |
| SearchView   | setOnSearchClickListener(View.OnClickListener)  | android: onSearchClick |
| ZoomControls | setOnZoomInClickListener(View.OnClickListener)  | android:onZoomIn       |
| ZoomControls | setOnZoomOutClickListener(View.OnClickListener) | android:onZoomOut      |



# Observable Data Object

*Data Binding 에 사용된 객체의 값을 변경한다고 해서 그와 관련한 View 가 자동으로 업데이트 되진 않는다.*

Data Binding 라이브러리는 Observable Data Object 를 통해서 데이터 변경 시 다른 객체(리스너)에게 변경을 알리는 기능을 제공한다.

Observable Data Object 에는 *객체*, *필드* 그리고 *컬렉션* 세 가지 유형이 존재한다.

> **Note**: Observable 이란 객체가 데이터 변경을 다른 객체에 알릴 수 있는 기능을 의미한다. 



### Observable Field

**내부적으로 단일 필드를 갖으며** `get()`, `set()` 메서드를 통해 해당 필드에 접근한다.

안드로이드에서 primitive 타입의 Observable Field 클래스를 제공한다. 아래와 같은 primitive 타입의 Observable Field 는 액세스 작업 중 박싱, 언박싱을 방지하기 위해 `public final` 로 설정해야한다.

[Observable Object](#observable-object) 또한 필드로 사용할 수 있다.

- Primitive Type Observable Field Class:  `ObservableBoolean`, `ObservableByte`, `ObservableChar`, `ObservableShort`, `ObservableInt`, `ObservableLong`, `ObservableFloat`, `ObservableDouble`, `ObservableParcelable`



### Observable Collection

- Observable Collection Class: `ObservableArrayMap`, `ObservableArrayList`, `ObservableMap`, `ObservableList`



### Observable Object

`Observable` 인터페이스를 구현하거나 `BaseObservable` 클래스를 상속 받은 클래스를 통해 생성할 수 있다.

`Observable` 인터페이스를 구현하여 생성하는 경우 객체 속성 변경 알림을 받을 리스너를 직접 추가, 삭제해야 한다. 또한 알림이 전송되는 시점을 개발자가 직접 결정해야 한다. `BaseObservable` 클래스는 이러한 리스너 관리 메커니즘을 구현한 클래스로 Observable Class 구현 시 사용이 편리하다.

`BaseObservable` 을 상속 받은 데이터 클래스는 속성 변경 시 리스너에게 자동으로 알린다.

위에서 언급한 Primitive Type Observable Field Class 는 `BaseObservableField` 클래스를 상속 받았다. 이 `BaseObservableField` 클래스 역시 `BaseObservable` 을 상속 받은 클래스이다.

Observable Data Class 의 구현 방식은 다음과 같다.

- `BaseObservable` 클래스 상속
- getter 메서드에 `@Bindable` 어노테이션 할당
- setter 메서드 내부에 `notifyPropertyChanged()` 메서드 호출

> **Note**: Data Binding 라이브러리는 **Data Binding 에 사용된 리소스의 ID 를 포함하는 `BR` 클래스**를 `모듈 패키지` 아래에 생성한다. `@Bindable` 어노테이션은 컴파일 중에 `BR` 클래스 파일에 항목을 생성한다.



### Test

```java
// DataClass.java
public class DataClass {
  public final ObservableInt observableInt = new ObservableInt();
}
```

```java
// ObservableClass.java
public class ObservableDataClass extends BaseObservable {
  private String str;
  private int i;

  @Bindable
  public String getStr() {
    return str;
  }
  @Bindable
  public int getI() {
    return i;
  }
  public void setStr(String str) {
    this.str = str;
    notifyPropertyChanged(BR.str);
  }
  public void setI(int i) {
    this.i = i;
    notifyPropertyChanged(BR.i);
  }
}
```

```java
// MainActivity.java
public class MainActivity extends AppCompatActivity {
  ...
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    ...
    // Observable Field Test
    final DataClass dataObj = new DataClass();
    dataObj.observableInt.set(1);
    binding.setDataObj(dataObj);
    binding.buttonForObservableFieldTest.setOnClickListener(view->{
      // 1씩 증가, Data Binding 된 UI에 자동으로 반영
      dataObj.observableInt.set(dataObj.observableInt.get()+1);
    });

    // Observable Collection Test
    final ObservableArrayMap<String, Object> user = new ObservableArrayMap<>();
    user.put("name", "unknown");
    user.put("age", 0);
    binding.setUser(user);
    binding.buttonForObservableCollectionTest.setOnClickListener(view-> {
      // user 정보 변경, Data Binding 된 UI에 자동으로 반영
      user.replace("name", "Dohyun");
      user.replace("age", 30);
    });
    
    // Observable Object Test
    final ObservableDataClass observableDataClass = new ObservableDataClass();
    observableDataClass.setStr("empty");
    observableDataClass.setI(0);
    binding.setObservableDataObj(observableDataClass);
    binding.buttonForObservableObjectTest.setOnClickListener(view ->{
      // 데이터 변경, Data Binding 된 UI에 자동으로 반영
      observableDataClass.setStr("Changed");
      observableDataClass.setI(100);
    });
  }
}
```

```xml
<layout xmlns:android="http://schemas.android.com/apk/res/android">
  <data>
    <import type="com.example.DataClass"/>
    <import type="androidx.databinding.ObservableArrayMap"/>
		<import type="com.example.ObservableDataClass"/>
    <variable name="dataObj" type="DataClass" />
    <variable name="user" type="ObservableArrayMap&lt;String, Object>" />
    <variable name="observableDataObj" type="ObservableDataClass" />
  </data>

  <LinearLayout ... >
    <!-- Observable Field Test -->
    <Button ... android:id="@+id/buttonForObservableFieldTest"/>
    <TextView ... android:text='@{Integer.toString(dataObj.observableInt)}'/>
    
    <!-- Observable Collection Test -->
    <Button ... android:id="@+id/buttonForObservableCollectionTest"/>
    <TextView ... android:text='@{"name: " + user.name + ", age: " + user.age.toString()}'/>
    
    <!-- Observable Object Test -->
    <Button ... android:id="@+id/buttonForObservableObjectTest"/>
    <TextView ... android:text='@{"str: " + observableDataObj.str + ", int: " + Integer.toString(observableDataObj.i)}'/>
    
  </LinearLayout>
</layout>
```

> **TODO**: Observable Field 대신 LiveData 사용하기

