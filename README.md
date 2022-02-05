# InAppWebView
flutter_inappwebview

InAppWebView를 사용하여 화면에 웹페이지를 띄우고, 띄운 웹페이지와 메시지를 주고 받음


실행시 화면상의 버튼패드부분 = 웹페이지

하단 출력화면 = flutter 코드



# build.gradle 수정

defaultConfig
```gradle
android minSdkVersion : 17 // 수정
multiDexEnabled true       // 추가
```

추가 >>
```gradle
packagingOptions {
        exclude 'META-INF/NOTICE'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/DEPENDENCIES'
        exclude 'META-INF/ASL2.0'
        exclude 'META-INF/DEPENDENCIES.txt'
        exclude 'META-INF/LICENSE.txt'
        exclude 'META-INF/NOTICE.txt'
        exclude 'META-INF/notice.txt'
        exclude 'META-INF/license.txt'
        exclude 'META-INF/LGPL2.1'
    }
    ```
   
