$(document).ready(function(){
    console.log('dom ready');

    var loading = $('#J_Loading');


    function render(data){
        if(data.errMsg){
            alert(data.errMsg);
            $('#J_IdelIndicator').html('Working');
            return ;
        }

        loading.removeClass('show');

        var html = '';
        data.captureImages.forEach(function(item){
            html += ('<li>'+
                    '<div class="label">'+item.label+'</div>'+
                    '<div class="imgBox"><img src="data:image/png;base64,'+item.image+'" alt=""/></div>'+
                    '</li>');
        });
        $('#J_Result .imageList').html(html);
        $('#J_OnloadTime').html(data.onloadTime);
        $('#J_DOMReadyTime').html(data.domreadyTime);
        $('#J_Result').fadeIn();
        $('#J_IdelIndicator').html('Idle');
    }

    $('#J_MainForm').bind('submit', function(ev){
        if(!validForm()){
            alert('Shot interval or duration invalid!');
            return false;
        }

        loading.addClass('show');
        $('#J_IdelIndicator').html('Working');
        $.post('/', $(this).serialize(), function(data){
            console.log(data);
            render(data);
        }, 'json');
        return false;
    });

    $('#J_QueryBtn').bind('click', function(){
        var isTaskLoading = false;
        if(loading.hasClass('show')){
            isTaskLoading = true;
        }else{
            loading.addClass('show');
        }

        $.get('/status', function(data){
            if(!isTaskLoading) loading.removeClass('show');
            $('#J_IdelIndicator').html(data.working);
        });
    });

    $.get('/status', function(data){
        $('#J_IdelIndicator').html(data.working);
    });


    function validForm(){
        var shotInterval = $('#J_ShotInterval').val();
        var duration = $('#J_Duration').val();

        if(!(/[\d\.]+/.test(shotInterval))){
            return false;
        }

        if(!(/[\d\.]+/.test(duration))){
            return false;
        }

        return true;
    }
});
