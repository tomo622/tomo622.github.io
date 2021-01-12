---
title: "Splash"
excerpt: ""
categories:
 - android
last_modified_at: 2020-09-02T21:50:00
---

# splash.xml (Animation Resource)

`res` 아래에 `anim` 디렉터리를 생성하고 Splash Animation 리소스를 만든다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<alpha
       xmlns:android="http://schemas.android.com/apk/res/android"
       android:duration="1000"
       android:fromAlpha="0.0"
       android:toAlpha="1.0" />
```



# SplashActivity.java

```java
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

public class SplashActivity extends AppCompatActivity {
  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    LayoutInflater layoutInflater = getLayoutInflater();
    View rootView = layoutInflater.inflate(R.layout.activity_splash, null, false);
    setContentView(rootView);

    Animation animation = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.splash);
    animation.setAnimationListener(new Animation.AnimationListener() {
      @Override
      public void onAnimationStart(Animation animation) {
      }

      @Override
      public void onAnimationEnd(Animation animation) {
        startActivity(new Intent(getApplication(), MainActivity.class).setFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION));
      }

      @Override
      public void onAnimationRepeat(Animation animation) {
      }
    });
    rootView.startAnimation(animation);
  }
}
```



# AndroidManifest.xml

```xml
<application>
  ...
  <activity
            android:name=".SplashActivity"
            android:theme="@style/Theme.AppCompat.NoActionBar"
            android:noHistory="true">
    <intent-filter>
      <action android:name="android.intent.action.MAIN" />
      <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
  </activity>
  ...
</application>
```

