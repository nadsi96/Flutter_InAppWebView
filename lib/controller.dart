import 'package:get/get.dart';

class Controller extends GetxController{
  var num = ['', ''].obs;
  var result = ''.obs;
  var operator = ''.obs;
  var pos = 0;

  void setNumFromWeb(String sNum, {idx: 0}){
    if(idx < num.value.length){
      if(num.value[idx].length < 4){
        num.value[idx] += sNum;
        num.refresh();
      }
    }
  }

  String? getNum({idx: 0}){
    if(idx < num.value.length){
      return num.value[idx];
    }
    return null;
  }

  void setOperator(opr){
    if(num.value[0] != ''){
      switch(opr){
        case "add":
          opr = "+";
          break;
        case "sub":
          opr = "-";
          break;
        case "mul":
          opr = "*";
          break;
        case "div":
          opr = "/";
          break;
        default:
          return;
      }
      operator.value = opr;
      pos = 1;
    }
  }
  void eraseContent(){
    result.value = '';

    if(num.value[1].length > 0){
      print("before num2 = ${num.value[1]}");
      num.value[1] = num.value[1].substring(0, num.value[1].length-1);
      print("after num2 = ${num.value[1]}");
    }
    else if(operator.value != ''){
      operator.value = '';
      pos = 0;
      return;
    }
    else if(num.value[0] != ''){
      print("before num1 = ${num.value[0]}");
      num.value[0] = num.value[0].substring(0, num.value[0].length-1);
      print("after num1 = ${num.value[0]}");
    }

    num.refresh();
  }

  void setResult(){
    var num1 = int.parse(num.value[0]);
    var num2 = int.parse(num.value[1]);
    // var result = 0;
    switch(operator.value){
      case "+":
        result.value = (num1 + num2).toString();
        break;
      case "-":
        result.value = (num1 - num2).toString();
        break;
      case "*":
        result.value = (num1 * num2).toString();
        break;
      case "/":
        result.value = (num1 / num2).toString();
        break;
      default:
        return;
    }
  }
}