$(document).ready(function(){
    console.log('dom ready');


    function render(data){
        var html = '';
        data.captureImages.forEach(function(item){
            html += ('<li>'+
                    '<div class="label">'+item.label+'</div>'+
                    '<div class="imgBox"><img src="data:image/png;base64,'+item.image+'" alt=""/></div>'+
                    '</li>');
        });
        $('#J_Result .imageList').html(html);
        $('#J_OnloadTime').html(data.onloadTime);
        $('#J_Result').fadeIn();
    }

    $('#J_MainForm').bind('submit', function(ev){
        $.post('/', $(this).serialize(), function(data){
            console.log(JSON.stringify(data));
            render(data);
        }, 'json');
        return false;
    });
});