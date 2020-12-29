---
title: "Array 와 List 변환"
excerpt: ""
categories:
 - java language
last_modified_at: 2020-12-29T23:20:00
---

# Array to List

```java
Integer[] arr = {0, 1, 2, 3};
List<Integer> list = Arrays.asList(arr);
```

`Arrays.asList` 의 정의 `public static <T> List<T> asList(T... a)`

제네릭 타입으로 원시 타입을 지정할 수 없다. 때문에 위에서 배열의 자료형으로 원시 타입을 사용할 수 없다. (`int[] arr` 을 `List<Integer>` 로 변환할 수 없다.)



# List to Array

```java
List<Integer> list = new ArrayList<Integer>();
list.add(0);
list.add(1);
list.add(2);
Integer[] arr = list.toArray(new Integer[list.size()]);
```

`List.toArray` 의 정의 `<T> T[] toArray(T[] a)`

제네릭 타입이기 때문에 위와 같은 이유로 배열의 자료형으로 원시 타입을 사용할 수 없다.

