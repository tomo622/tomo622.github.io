# JavaScript

HTML 문서에 `<script>` 태그를 이용하여 삽입할 수 있다.

HTML 문서에서 `<script>`의 위치 : 가독성과 브라우저 동작의 효율을 위해 `</body>` 바로 위에 작성하는 것이 좋다. (`<html>` 태그 사이에 있으면 동작에 이상은 없다.)
이유 -> 1. 브라우저의 렌더링이 끝난 후 자바스크립 코드를 파싱하기 때문에 화면 출력 지연을 방지할 수 있다. 2. DOM Tree가 생성되기 전에 자바스크립트 코드에서 DOM을 조작하는 행위를 방지할 수 있다. 
참고로 화면의 출력이 끝나고 DOM의 조작이 필요할때는 자바스크립트에서는 `window.onload`, JQuery에서는 `$(document).ready` 등과 같이 따로 설정이 필요하다.

참고: `<script>`를  `</body>` 바로 위에 위치시키지 않고 사용하기 위해서는 `<script>` 태그에 `async/defer` 속성을 이용할 수 있다.

참고: css는 가능한 빨리 적용되어야 하기 때문에 `<head`> 태그 사이에 위치시키는 것이 좋다.


# Theory

### DOM (Document Object Model)

### 브라우저 동작 방식

![web_image1](https://user-images.githubusercontent.com/19742979/76080871-3c30b600-5feb-11ea-86ca-87f6251df472.png) {: .align-center}
참고: HTML을 읽어 내려가는 과정에서 자바스크립트 `<script`> 태그를 발견하면 HTML 파싱을 중단하고 자바스크립트 코드를 파싱한다. 화면 출력 지연의 원인이 될 수  있다.