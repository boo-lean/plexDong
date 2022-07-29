$(function () {
    $(document).off().on('click', '#submitBtn', function () {
        let data = $('#email').val();
        if (data) {
            window.location.replace('/dongs/' + data);
        }
    });
});