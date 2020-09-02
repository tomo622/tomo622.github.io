---
title: "Splash"
excerpt: ""
categories:
 - android
last_modified_at: 2020-09-02T21:50:00
---

# Splash 만들기

Splash 리소스는 `drawable` 아래에 포함

## SplashActivity.java

```java
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class SplashActivity extends AppCompatActivity {
  private static final String TAG = "SplashActivity";
  private final int EXECUTOR_SERVICE_SLEEP_TIME = 1; // seconds
  private final int EXECUTOR_SERVICE_AWAIT_TIME_FOR_TERMINATION = 5; // seconds

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // 람다식 사용을 위해 Java8 설정 필요
    // 1초 뒤에 MainActivity 실행
    ExecutorService executorService = Executors.newSingleThreadExecutor();
    executorService.submit(()->{
      Log.i(TAG, "splash executor service submit after "+ EXECUTOR_SERVICE_SLEEP_TIME + "seconds");
      try {
        TimeUnit.SECONDS.sleep(EXECUTOR_SERVICE_SLEEP_TIME);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
      startActivity(new Intent(getApplication(), MainActivity.class).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
    });

    // ExecutorService 종료
    // submit task 를 기다린 후 종료 (최대 5초)
    // 5초 뒤에 종료되지 않았다면 강제 종료
    try {
      Log.i(TAG, "splash executor service shutdown (await time for termination: " + EXECUTOR_SERVICE_AWAIT_TIME_FOR_TERMINATION + " seconds)");
      executorService.shutdown();
      executorService.awaitTermination(EXECUTOR_SERVICE_AWAIT_TIME_FOR_TERMINATION, TimeUnit.SECONDS);
    } catch (InterruptedException e) {
      Log.e(TAG, "splash executor service interrupt exception: " + e.getMessage());
    }
    finally {
      if(!executorService.isShutdown()){
        Log.e(TAG, "splash executor service shutdown now");
        executorService.shutdownNow();
      }
      finish();
    }
  }
}
```

# Splash 설정

## styles.xml

```xml
<resources>
  ...
  <style name="SplashTheme" parent="Theme.AppCompat.NoActionBar">
    <item name="android:windowBackground">[splash resource]</item>
  </style>
</resources>
```

## AndroidManifest.xml

```xml
<application>
  ...
  <activity 
            android:name=".SplashActivity"
            android:theme="@style/SplashTheme">
    <intent-filter>
      <action android:name="android.intent.action.MAIN" />
      <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
  </activity>
  
  <activity android:name=".MainActivity"/>
</application>
```

