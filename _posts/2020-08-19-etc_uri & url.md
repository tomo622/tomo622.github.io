---
title: "URI와 URL의 차이"
excerpt: ""
use_math: true
categories:
 - etc
last_modified_at: 2020-08-19T00:18:00
---

- URI (Uniform Resource **Identifier**): 인터넷에 존재하는 **자원을 내타내는** 유일한 주소, 하위 개념으로는 URL과 URN이 있다.
- URL (Uniform Resource **Locator**): 네트워크 상에서 **자원의 위치**를 알려주기 위한 규약

위에서 강조한 부분(bold 처리) 처럼 URI는 자원 자체를 의미하고 (그러기 위해서는 다른 자원들과 *식별이 가능해야함*) URL은 해당 자원의 위치일 뿐이다. 아래 예시를 통해 차이를 알 수 있다.

http://endic.naver.com/endic.nhn?docid=1232950
http://endic.naver.com/endic.nhn?docid=1232690  
위 두 주소는 같은 URL 이지만 다른 URI 이다. 여기서 URL의 영역은 자원의 위치를 나타내는 http://endic.naver.com/endic.nhn 까지 이고, 뒤에 따라오는 '?docid=1232950' 를 통해 자원에 대한 식별이 가능해지기 때문에 URI라 할 수 있다.

http://img0.gmodules.com/ig/images/korea/logo.gif  
반면 위 주소는 주소 자체로 위치이면서 식별이 가능하기 때문에 같은 URL이면서 같은 URI라 할 수 있다.

> 출처)  
> <https://lambdaexp.tistory.com/39>