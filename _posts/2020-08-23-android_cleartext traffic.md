---
title: "평문 네트워크 트래픽 설정하기"
excerpt: ""
categories:
 - android
last_modified_at: 2020-08-23T18:25:00
---

평문 네트워크 트래픽 사용 여부를 결정한다. API 28 이상 부터 기본적으로 평문 네트워크 트래픽 사용을 거부한다.

설정을 위해서는 `AndroidManifest.xml` 파일을 아래와 같이 수정한다.

```xml
<application
	...
	<!-- 평문 네트워크 트래픽 사용을 허가한다. 기본값은 false이다. -->
	android:usesCleartextTraffic="true">
```

그러나 위 설정 값이 false라고 해도 모든 평문 트래픽을 차단할 수 없다. Socket API의 트래픽은 평문 트래픽 여부를 알 수 없는 등의 예외가 있다.

# 네트워크 보안 구성으로 평문 트래픽 설정하기

1. 네트워크 보안 구성 파일 생성: `res/xml/network_security_config.xml`

   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <network-security-config>
     <!-- 평문 네트워크 트래픽 사용을 허가한다.
   	API 28 부터는 기본값이 false 이기때문에 값을 false로 설정하는 것은 의미 없다. -->
     <domain-config cleartextTrafficPermitted="true">
       <!-- 허가할 도메인 지정, 지정된 도메인들만 허가한다. -->
       <domain includeSubdomains="true">[도메인]</domain>
     </domain-config>
   </network-security-config>
   ```

2. `AndroidManifest.xml` 파일에 네트워크 보안 구성 파일 지정  

   ```xml
   <application
   	...
   	android:usesCleartextTraffic="false" <!-- 무시됨 -->
   	android:networkSecurityConfig="@xml/network_security_config">
   ```

   `android:networkSecurityConfig` 속성은 API 24 이상 부터 추가되었다. 속성을 통한 네트워크 보안 구성이 있는 경우 `android:usesCleartextTraffic` 설정은 무시된다.

   

