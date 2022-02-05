import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'controller.dart';


// build.gradle

// multiDexEnabled true
// packagingOptions {
//         exclude 'META-INF/NOTICE'
//         exclude 'META-INF/LICENSE'
//         exclude 'META-INF/DEPENDENCIES'
//         exclude 'META-INF/ASL2.0'
//         exclude 'META-INF/DEPENDENCIES.txt'
//         exclude 'META-INF/LICENSE.txt'
//         exclude 'META-INF/NOTICE.txt'
//         exclude 'META-INF/notice.txt'
//         exclude 'META-INF/license.txt'
//         exclude 'META-INF/LGPL2.1'
//     }

Future main() async{

  // chrome에서 webview 디버깅 할 수 있도록 설정
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final controller = Get.put(Controller());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final WIDTH = Get.width / 4;

  final String title;
  final controller = Get.find<Controller>();
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        if(inAppWebViewController != null){
          var msg = "fromFlutter|android_backBtn";
          inAppWebViewController.evaluateJavascript(source: "fromApp('$msg')");
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: InAppWebView(
                  initialFile: "assets/prac.html", // local html
                  // initialUrlRequest: // server html
                  // URLRequest(url: Uri.parse("https://inappwebview.dev/")),
                  initialOptions: InAppWebViewGroupOptions(
                    // disable scaling
                    crossPlatform: InAppWebViewOptions(
                      supportZoom: false
                    )
                  ),
                  onWebViewCreated: (controller) {
                    // 화면 첫 생성시만
                    inAppWebViewController = controller;
                  },
                  onLoadStop: (controller, url) {
                    // 화면 로딩 후 (화면 업데이트된 후)
                    getMessageFromWeb();
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    // 콘솔 찍히는거 출력
                    print("____________________Console Message");
                    print(consoleMessage);
                  },
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    SizedBox(
                      width: WIDTH,
                      child: Obx((){

                        return Text((controller.getNum(idx: 0) ?? ''));
                      }),
                    ),
                    SizedBox(
                      width: WIDTH / 2,
                      child: Obx((){

                        return Text(controller.operator.value);
                      }),
                    ),
                    SizedBox(
                      width: WIDTH,
                      child: Obx((){

                        return Text((controller.getNum(idx: 1) ?? ''));
                      }),
                    ),
                    SizedBox(
                      width: WIDTH / 2,
                      child: const Text('='),
                    ),
                    SizedBox(
                      width: WIDTH,
                      child: Obx((){

                        return Text(controller.result.value);
                      }),
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            controller.eraseContent();
            print("controller.result.value________________________");
            print(controller.result.value);
            print("----------------------------------------------");
            sendMessageToWeb(controller.result.value);
          },
          child: const Text("<"),
        ),
      ),
    );
  }


  // 웹에서 메시지 받
  void getMessageFromWeb(){
    print("================================");
    inAppWebViewController.addJavaScriptHandler(handlerName: 'sendNum', callback: (msgs){
      print("get msg from Web");
      print(msgs);
      print(msgs.runtimeType);
      print(msgs[1].runtimeType);
      controller.setNumFromWeb(msgs[1], idx: controller.pos);
    });
    inAppWebViewController.addJavaScriptHandler(handlerName: 'sendOperator', callback: (msgs){
      print("get msg from Web");
      print(msgs);
      print(msgs.runtimeType);
      controller.setOperator(msgs[1]);
    });
    inAppWebViewController.addJavaScriptHandler(handlerName: 'sendEqual', callback: (msgs){
      print("get msg from Web");
      print(msgs);
      print(msgs.runtimeType);
      controller.setResult();

      sendMessageToWeb(controller.result.value);
    });
    print("================================");
  }

  // 웹으로 메시지 던지기
  void sendMessageToWeb(msg){
    if(inAppWebViewController != null){
      msg = 'fromFlutter|$msg';
      print("========================sendMessageToWeb");
      print(msg);
      inAppWebViewController.evaluateJavascript(source: "fromApp('$msg')");
    }
  }
}
