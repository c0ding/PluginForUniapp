
      !(function(){
        var uniAppViewReadyCallback = function(){
          setCssToHead(["wx-uni-image { height: ",[0,40],"; width: ",[0,40],"; }\n.",[1],"xxxxx { font-size: ",[0,72],"; }\n",],undefined,{path:"./pages/test/test.wxss"})();
document.dispatchEvent(new CustomEvent("generateFuncReady", { detail: { generateFunc: $gwx('./pages/test/test.wxml') } }));
        }
        if(window.__uniAppViewReady__){
          uniAppViewReadyCallback()
        }else{
          document.addEventListener('uniAppViewReady',uniAppViewReadyCallback)
        }
      })();
      