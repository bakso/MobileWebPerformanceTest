

var startTime = Date.now();

var domreadyTime = 0,
    onloadTime = 0;

document.addEventListener('DOMContentLoaded', function(){
                          domreadyTime = Date.now() - startTime;
                          
                          }, false);

window.addEventListener('load', function(){
    onloadTime = Date.now() - startTime;
    var result = {
                        domreadyTime: domreadyTime.toString(),
                        onloadTime: onloadTime.toString()
                        };
                        reportBackToObjectiveC(result);
}, false);



function reportBackToObjectiveC(result)
{
    window.webkit.messageHandlers.MWPT.postMessage({"result":JSON.stringify(result)});
}