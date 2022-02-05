let g_numPad = [];
let g_operator = {};
let g_result;

function onLoad(){
    for(let i = 0; i < 10; i++){
        g_numPad.push(document.getElementById(`pad${i}`));
        setPadEvent(g_numPad[i], i, true);
    }
    console.log(g_numPad);

    g_operator["add"] = document.getElementById('pad_add');
    g_operator["sub"] = document.getElementById('pad_sub');
    g_operator["div"] = document.getElementById('pad_div');
    g_operator["mul"] = document.getElementById('pad_mul');
    g_operator["eql"] = document.getElementById('pad_equal');

    console.log(g_operator)
    console.log(Object.keys(g_operator));
    for(let key of Object.keys(g_operator)){
        console.log(key);
        setPadEvent(g_operator[key], key, false);
    }

    g_result = document.getElementById("result");
}

function setPadEvent(element, idx, flag){
    element.addEventListener("click", function(){
        webToApp(idx.toString(), flag);
    })
}

function webToApp(msg, isNum){
    if(isNum){
        window.flutter_inappwebview.callHandler('sendNum', "!!!!WebToApp!!!!", msg);
    }
    else{
        if(["add", "sub", "div", "mul"].includes(msg)){
            window.flutter_inappwebview.callHandler('sendOperator', "!!!!WebToApp!!!!", msg);
        }
        else if(msg == "eql"){
            window.flutter_inappwebview.callHandler('sendEqual', "!!!!WebToApp!!!!", msg);
        }
    }
}

function fromApp(msg){
    if(msg){
        let msgs = msg.split('|');
        if(msgs.length == 2){
            if(msgs[0] == "fromFlutter"){
                if(msgs[1] == "android_backBtn"){
                    openMsgBox();
                }
                else{
                    console.log(msgs[1]);
                    g_result.innerHTML = msgs[1] || '';
                }
            }
            else if(msgs[0] == "fromKotlin"){
                if(msgs[1] == "android_backBtn"){
                    openMsgBox();
                }
                else{
                    g_result.innerHTML = msgs[1] || '';
                }
            }
        }
    }

}

function openMsgBox(){
    let msgBox = document.getElementById("msgbox");
    if(!msgBox){
        msgBox = document.createElement("div");
        msgBox.id = "msgbox";
        msgBox.className += "msgbox";

        let blinder = document.createElement("div");
        blinder.className += "blinder";
        blinder.style.backgroundColor = "rgb(0,0,0,0.5)";

        let contents = document.createElement("div");
        contents.className += "contents";

        let title = document.createElement("div");
        title.className += "title";
        title.innerHTML = "Alert";

        let msg = document.createElement("div");
        msg.className += 'msg';
        msg.innerHTML = "Android Back Btn Click";

        let btn = document.createElement("div");
        btn.className += "btn";
        btn.id = "btn";
        btn.innerHTML = "Close";
        btn.addEventListener("click", function(){
            msgBox.remove();
        })

        contents.appendChild(title);
        contents.appendChild(msg);
        contents.appendChild(btn);

        msgBox.appendChild(blinder);
        msgBox.appendChild(contents);

        document.body.appendChild(msgBox);

    }
}