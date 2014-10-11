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
    var iframe = document.createElement("iframe");
    iframe.setAttribute("src", 'mwpt://data/?testResult='+encodeURIComponent(JSON.stringify(result)));
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
}