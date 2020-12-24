---
title: "Inflation"
excerpt: "Inflate, LayoutInflater, setContentView"
categories:
 - android
last_modified_at: 2020-12-22T21:28:00
---

# Inflation 이란?

XML 파일의 레이아웃 리소스를 메모리에 객체화 하는 과정



# LayoutInflater

XML 파일의 레이아웃 리소스를 전개하기(Inflate) 위해 안드로이드에서 제공하는 클래스로 해당 내용을 `View` 객체로 인스턴스화 한다.

아래와 같은 방법으로 `LayoutInflater` 객체를 얻을 수 있다.

- Activity.getLayoutInflater  
  정의: `public LayoutInflater getLayoutInflater ()`  
  
  ```java
  LayoutInflater inflater = getLayoutInflater();
  ```
  
- Context.getSystemService  
  정의: `public abstract Object getSystemService (String name)`  
  
  ```java
  LayoutInflater inflater = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);
  ```
  
- LayoutInflater.from  
  정의: `public static LayoutInflater from (Context context)`  
  
  ```java
  LayoutInflater inflater = LayoutInflater.from(this);
  ```



`LayoutInflater` 에서 제공하는 메소드를 통해 XML 파일의 레이아웃 리소스를 `View` 객체로 전개한다. 아래 두 개의 메소드는 타겟으로 하는 XML 레이아웃 리소스의 아이디를 매개변수로 받아 전개를 진행한다.

- `public View inflate (int resource, ViewGroup root)`  
  `root` 에 `null` 을 전달할 경우 전개된 `View` 를 반환하지만, 특정 `ViewGroup` 을 전달할 경우 전개된 `View` 객체는 해당 `root` 에 부착되고 `root` 가 반환된다.

  ```java
  View main = inflater.inflate(R.layout.activity_main, null);
  View sub1 = inflater.inflate(R.layout.activity_sub, (ViewGroup) main); // sub1 == main
  View sub2 = inflater.inflate(R.layout.activity_sub, null); // sub2 != main
  ```


- `public View inflate (int resource, ViewGroup root, boolean attachToRoot)`  
`root` 에 특정 `ViewGroup` 을 전달하고 `attachToRoot` 가 `true` 인 경우 전개된 `View` 객체는 `root` 에 부착되고 `root` 가 반환된다. (이외의 모든 경우는 전개된 `View` 를 반환한다.)  
  `root` 에 특정 `ViewGroup` 을 전달하고 `attachToRoot` 가 `false` 인 경우 `root` 는 전개되는 `View` 에 설정되어 있는  `LayoutParams` 값을 올바르게 만들기 위해서만 사용된다.
  
  ```java
  View main = inflater.inflate(R.layout.activity_main, null);
  View sub = inflater.inflate(R.layout.activity_sub, (ViewGroup) main, true); // sub == main
  ```



# View.inflate

정의: `public static View inflate (Context context, int resource, ViewGroup root)`

`LayoutInflater` 클래스를 랩핑하여 `LayoutInflater` 의 취득과 전개 과정을 한 번에 처리한다.

```java
View main = View.inflate(this, R.layout.activity_main, null);
View sub = View.inflate(this, R.layout.activity_sub, (ViewGroup) main);
```



# Activity.setContentView

다음과 같은 세 개의 메소드 정의를 갖는다.  
`public void setContentView (View view, ViewGroup.LayoutParams params)`  
`public void setContentView (View view)`  
`public void setContentView (int layoutResID)`

`View` 를 매개변수로 받는 경우 액티비티 내용으로 보여준다.  
레이아웃 리소스 아이디를 매개변수로 받는 경우 내부적으로 내용이 전개(inflate) 되고 동일하게 액티비티 내용으로 보여준다.

