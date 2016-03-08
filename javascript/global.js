
$(document).ready(function () {

    // hide all div containers
    $('#collapsible-panels div').show();
    // append click event to the a element
    $('#controlSpan').click(function (e) {
        // slide down the corresponding div if hidden, or slide up if shown
        $(this).toggleClass("glyphicon-chevron-down");
        $("#contentdiv").slideToggle('slow');
        // set the current item as active
        //$(this).parent().toggleClass('active');
        e.preventDefault();
    });
});

function operateFormatter(value, row, index) {
    switch (value) {
        case "License Review":
            return [
            '<a class="like" href="#">',
                '<i class="fa fa-clock-o" style="color:#F9CC63;"> <span style="font-family:helvetica;">' + value + '</span></i>',
            '</a>'
            ].join('');
            break;
        case "Approved":
            return [
            '<a class="like" href="#" >',
                '<i class="fa fa-check-circle" style="color:#6F98A5;"> <span style="font-family:helvetica;">' + value + '</span></i>',
            '</a>'
            ].join('');
            break;
        case "Rejected":
            return [
            '<a class="like" href="#" >',
                '<i class="fa fa-times-circle" style="color:#EA5023;"> <span style="font-family:helvetica;">' + value + '</span></i>',
            '</a>'
            ].join('');
            break;
    }
}

function LinkStyle(value, row, index) {
    return [
            '<a href="#">'
                 + value +
            '</a>'
    ].join('');
}

function SorterNum(a, b) {
    a = +a.substring(1);
    b = +b.substring(1);
    if (a > b) return 1;
    if (a < b) return -1;
    return 0;
}
function SorterCol(a, b) {
    a = +a.substring(3);
    b = +b.substring(3);
    if (a > b) return 1;
    if (a < b) return -1;
    return 0;
}

//removed init of slider as not required anymore.


//removed multiselect code
/*$(document).ready(function () {
    $('#ddlSrchGlobal').multiselect({
    });
});*/
