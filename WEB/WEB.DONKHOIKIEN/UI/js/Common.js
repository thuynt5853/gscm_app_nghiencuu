
function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}
function Common_ValidateEmail(string_Email) {
    //Kiem tra dinh dang email
    var retval = false;
    var _pattern = /^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$/;
    if (!string_Email.match(_pattern)) {
        alert("Định dạng email không hợp lệ.Hãy kiểm tra lại!");
        retval = false;
    }
    else { retval = true; }
    return retval;
}
function Common_ValidateEmail_ShowZoneMsg(string_Email, zone_message_name) {
    //Kiem tra dinh dang email
    var zone_message = document.getElementById(zone_message_name);

    var retval = false;
    var _pattern = /^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$/;
    if (!string_Email.match(_pattern)) {
        zone_message.style.display = "block";
        zone_message.innerText = 'Định dạng email không hợp lệ.Hãy kiểm tra lại!';
        control.focus();
    }
    return retval;
}
function Common_ValidateEmail2(control) {
    //Kiem tra dinh dang email
    var string_Email = control.value;
    var retval = false;
    var _pattern = /^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$/;
    if (!string_Email.match(_pattern))
    {       
        control.focus();
        retval = false;
    }
    else { retval = true; }
    return retval;
}
function Common_CheckExistHTMLTag(control) {
    var StrTemp = control.value;
    var _pattern = /^[a-zA-Z0-9-_]*[^\'=<>|]*[a-zA-Z0-9-_\s]*$/;
   // var _pattern = /<\/?[^>]*=@$%&!~>/;
    if (!StrTemp.match(_pattern)) {
        alert("Chuỗi kí tự '" + StrTemp + "' có chứa các cụm kí tự đặc biệt có thể gây nhầm lẫn cho hệ thống .Hãy kiểm tra lại!");
        control.focus();
        return false;
    }
    return true;
}

//kiem tra xau trong
function Common_CheckEmpty(string_root) {
    retval = true;
    _pattern = /\s/g;
    if (string_root.replace(_pattern, "") == "") {
        return false;
    }
    else {
        return true;
    }
}

function Common_CheckTextBox(control, control_name) {
    var string_root = control.value;
    if (!Common_CheckEmpty(string_root)) {
        alert('Bạn chưa nhập ' + control_name +'. Hãy kiểm tra lại !');
        control.focus();
        return false;
    }
    
    if (!Common_CheckExistHTMLTag(control))
    {
            control.focus();
            return false;
        }
    return true;
}

//--------------------------------------
//kiem tra noi dung FckEditor 
function Common_CheckEmptyFCKEditor(FckEditorClientID) {
    var field = FckEditorClientID; //FCKeditorAPI.GetInstance('FckEditorClientID'); 
    var fulltext = field.GetHTML(true).replace(/ /g, '');
    var fulltext = fulltext.replace(/&nbsp;/g, '');
    var fulltext = fulltext.replace(/<p>/g, '');
    var fulltext = fulltext.replace(/<\/p>/g, '');
    if (fulltext == "") {
        alert('Bạn nhập thiếu thông tin phần nội dung!');
        return false;
    }
    return true;
}

//kiem tra noi dung FckEditor 
function Common_CheckEmptyFCKEditor_ByName(FckEditorClientID, controlName) {
    var field = FckEditorClientID; //FCKeditorAPI.GetInstance('FckEditorClientID'); 
    var fulltext = field.GetHTML(true).replace(/ /g, '');
    var fulltext = fulltext.replace(/&nbsp;/g, '');
    var fulltext = fulltext.replace(/<p>/g, '');
    var fulltext = fulltext.replace(/<\/p>/g, '');
    if (fulltext == "") {
        alert('Bạn nhập thiếu thông tin phần' + controlName + '!');
        return false;
    }
    return true;
}
function CheckNumber(str) {
    var isNumber = true;
    if (Common_CheckEmpty(str)) {
        for (var i = 0; i < str.length; i++) {
            if (str.charAt(i) < '0' || str.charAt(i) > '9') {
                isNumber = false;
                break;
            }
        }
    }
    return isNumber;
}

//--------------------------------------------------
function CheckDateTimeControl(controlID, controlname) {
    var Empty_date = '__/__/____';
    var control_value = controlID.value;
    if (!Common_CheckEmpty(control_value) || control_value == Empty_date) {
        alert('Bạn chưa chọn ' + controlname + '.Hãy kiểm tra lại!');
        controlID.focus();
        return false;
    }
    else {
        if (!Common_IsTrueDate(controlID.value)) {
            controlID.focus();
            return false;
        }
        //--------------------------
        var now = new Date();
        var temp = control_value.split('/');
        temp = new Date(temp[2], temp[1] - 1, temp[0]);

        if (temp>now) {
            alert(controlname + ' phải nhỏ hơn hoặc bằng ngày hiện tại!');
            controlID.focus();
            return false;
        }
    }
    return true;
}
function Common_IsTrueDate(chuoi_ngay_thang) {
    var format_date = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/;

    var matchArray = chuoi_ngay_thang.match(format_date); // is the format ok?

    if (matchArray == null) {
        alert("Hãy kiểm tra lại dữ liệu ngày tháng nhập vào. Kiểu ngày tháng đúng như sau: ngày/tháng/năm");
        return false;
    }
    var arr = chuoi_ngay_thang.split('/');
    day = arr[0]; // parse date into variables
    month = arr[1];
    year = arr[2];

    if (day < 1 || day > 31) {
        alert("Hãy kiểm tra lại kiểu ngày tháng nhập vào. Ngày phải trong khoảng từ 1 đến 31.");
        return false;
    }
    if (month < 1 || month > 12) { // check month range
        alert("Hãy kiểm tra lại kiểu ngày tháng nhập vào. Tháng phải trong khoảng từ 1 đến 12.");
        return false;
    }
    if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31) {
        alert("Hãy kiểm tra lại kiểu ngày tháng nhập vào. Tháng " + month + " không có 31 ngày.");
        return false;
    }

    if (month == 2) { // check for february 29th
        var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
        if (day > 29 || (day == 29 && !isleap)) {
            alert("Hãy kiểm tra lại kiểu ngày tháng nhập vào. Tháng 2 năm " + year + " không có " + day + " ngày.");
            return false;
        }
    }
    return true; // date is valid
}
function SoSanhDate(controlStartDate, controlEndDate) {
    var ngay_bat_dau = controlStartDate.value;
    var ngay_ket_thuc = controlEndDate.value;

    var now = new Date();
    var _Start_Date;
    var _End_Date;

    //---------------------------------------           
    if (Common_CheckEmpty(ngay_bat_dau)) {
        _Start_Date = ngay_bat_dau.split('/');
        _Start_Date = new Date(_Start_Date[2], _Start_Date[1] - 1, _Start_Date[0]);
    }

    //---------------------------------------
    if (Common_CheckEmpty(ngay_ket_thuc)) {
        _End_Date = ngay_ket_thuc.split('/');
        _End_Date = new Date(_End_Date[2], _End_Date[1] - 1, _End_Date[0])
    }

    //---------------------------------------
    if ((Common_CheckEmpty(ngay_bat_dau)) && (Common_CheckEmpty(ngay_ket_thuc))) {
        if (_Start_Date < _End_Date) {
            controlStartDate.focus();
            return false;
        }
    }
    return true;
}
//--------------------------------
function SoSanh2Date(controlStartDate, name_controlStartDate, ngay_dung_sosanh, name_ngay_dung_sosanh) {
    var ngay_bat_dau = controlStartDate.value;
    var ngay_ket_thuc = ngay_dung_sosanh;

    var now = new Date();
    var _Start_Date;
    var _End_Date;

    //---------------------------------------           
    if (Common_CheckEmpty(ngay_bat_dau)) {
        _Start_Date = ngay_bat_dau.split('/');
        _Start_Date = new Date(_Start_Date[2], _Start_Date[1] - 1, _Start_Date[0]);
    }

    //---------------------------------------
    if (Common_CheckEmpty(ngay_ket_thuc)) {
        _End_Date = ngay_ket_thuc.split('/');
        _End_Date = new Date(_End_Date[2], _End_Date[1] - 1, _End_Date[0])
    }

    //---------------------------------------
    if ((Common_CheckEmpty(ngay_bat_dau)) && (Common_CheckEmpty(ngay_ket_thuc))) {
        if (_Start_Date < _End_Date) {
            alert('Xin vui lòng kiểm tra lại. ' + name_controlStartDate + ' bắt buộc phải lớn hơn hoặc bằng ' + name_ngay_dung_sosanh + ' là : ' + ngay_dung_sosanh + '!');
            controlStartDate.focus();
            return false;
        }
    }
    return true;
}
//--------------------------
function ReloadPageParent() {
    //-------load parent page when close popup---------------
    window.onunload = refreshParent;
    function refreshParent() {
        window.opener.location.reload();
    }
}
//-------------------

function Common_CheckTextBox2(control, control_name, zone_show_msg) {
    var string_root = control.value;
    var zone_message = document.getElementById(zone_show_msg);

    if (!Common_CheckEmpty(string_root))
    {
        zone_message.style.display = "block";
        zone_message.innerText = 'Bạn chưa nhập ' + control_name + '. Hãy kiểm tra lại !';
        control.focus();
        return false;
    }

    //---------------------
    var _pattern = /^[a-zA-Z0-9-_]*[^\'=<>|]*[a-zA-Z0-9-_\s]*$/;
    if (!string_root.match(_pattern))
    {
        zone_message.style.display = "block";
        zone_message.innerText = "Mục "+ control_name + " có chứa các cụm kí tự đặc biệt có thể gây nhầm lẫn cho hệ thống .Hãy kiểm tra lại!";
        control.focus();
        return false;
    }
    return true;
}
//function Common_ShowMessageZone(msgcontent, zone_show_msg) {
//    var zone_message = document.getElementById(zone_show_msg);
//    if (!Common_CheckEmpty(msgcontent)) {
//        zone_message.style.display = "block";
//        zone_message.innerText = msgcontent;
//        return false;
//    }
//    return false;
//}



function CheckDateTimeControl2(controlID, controlname, zone_show_message) {
    var Empty_date = '__/__/____';
    var zone_message = document.getElementById(zone_show_message);
    var control_value = controlID.value;
    if (!Common_CheckEmpty(control_value) || control_value == Empty_date) {
        zone_message.style.display = "block";
        zone_message.innerText = 'Bạn chưa chọn ' + controlname + '.Hãy kiểm tra lại!';
        controlID.focus();
        return false;
    }
    else {
        if (!Common_IsTrueDate(controlID.value)) {
            controlID.focus();
            return false;
        }
        //--------------------------
        var now = new Date();
        var temp = control_value.split('/');
        temp = new Date(temp[2], temp[1] - 1, temp[0]);

        if (temp > now) {
            zone_message.style.display = "block";
            zone_message.innerText = controlname + ' phải nhỏ hơn hoặc bằng ngày hiện tại!';
            controlID.focus();
            return false;
        }
    }
    return true;
}

function Common_CheckLengthString(control, soluongkytu) {
    var noidung = control.value;
    var noidung_length = noidung.length;
    if (noidung_length > soluongkytu) {
        control.focus();
        return false;
    }
    return true;
}