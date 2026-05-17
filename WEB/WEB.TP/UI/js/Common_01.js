
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

function Common_CheckExistHTMLTag(control) {
    var StrTemp = control.value;
    var _pattern = /^[a-zA-Z0-9-_]*[^\'=<>|]*[a-zA-Z0-9-_\s]*$/;
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

function Common_CheckStringEmpty(string_root, controlName) {
    retval = true;
    _pattern = /\s/g;
    if (string_root.replace(_pattern, "") == "") {
        alert("Hãy nhập thông tin cho " + controlName + "!");
        retval = false;
    }
    else {
        retval = true;
    }
    return retval;
}

function Common_CheckTextBox(control, control_name) {
    var string_root = control.value;
    if (!Common_CheckEmpty(string_root)) {
        alert('Bạn chưa nhập ' + control_name + '. Hãy kiểm tra lại !');
        control.focus();
        return false;
    }
    if (!Common_CheckExistHTMLTag(control)) {
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
//--------------------------------------------
function GetStatusRadioButtonList(control_clientID) {
    var rb = control_clientID; 
    var inputs = rb.getElementsByTagName('input');
    var flag = false;
    var selected;
    for (var i = 0; i < inputs.length; i++) {
        if (inputs[i].checked) {
            selected = inputs[i];
            flag = true;
            break;
        }
    }
    if (flag)
        return selected.value;
}

//----KT: radiobuttonlist chua chọn gia tri nao--> xuat hien thong bao (message_no_change)
function CheckChangeRadioButtonList(control_clientID, message_no_change) {
    var giatri = GetStatusRadioButtonList(control_clientID);
   
    if ((giatri != 0) && (giatri != 1)) {
        alert(message_no_change);
        control_clientID.focus();
        return false;
    }
    return true;
}
function PopupCenter(pageURL, title, w, h) {
    var left = (screen.width / 2) - (w / 2);
    var top = (screen.height / 2) - (h / 2);
    var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
    return targetWin;
}

//-----------------------------------------------------------------
function CheckDateTimeControl(controlID, controlname) {
    var Empty_date = '__/__/____';
    var control_value = controlID.value;
    if (!Common_CheckEmpty(control_value) || control_value == Empty_date) {
        alert('Bạn chưa chọn ' + controlname + '. Hãy kiểm tra lại!');
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

        if (now < temp) {
            alert(controlname + ' phải nhỏ hơn hoặc bằng ngày hiện tại!');
            controlID.focus();
            return false;
        }
    }
    return true;
}
//-----------------------------------------------
function CheckDateTimeControl_KoSoSanhNgayHienTai(controlID, controlname) {
    var Empty_date = '__/__/____';
    var control_value = controlID.value;
    if (!Common_CheckEmpty(control_value) || control_value == Empty_date) {
        alert('Bạn chưa chọn ' + controlname + '. Hãy kiểm tra lại!');
        controlID.focus();
        return false;
    }
    else {
        if (!Common_IsTrueDate(controlID.value)) {
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
function SoSanh2Date(controlDate, name_controlDate, ngay_dung_sosanh, name_ngay_dung_sosanh)
{
    var _Start_Date;
    var _End_Date;
    var ngay_bat_dau = controlDate.value;

    //---------------------------------------
    if (Common_CheckEmpty(ngay_bat_dau)) {
        _Start_Date = ngay_bat_dau.split('/');
        _Start_Date = new Date(_Start_Date[2], _Start_Date[1] - 1, _Start_Date[0]);
    }

    //---------------------------------------
    if (Common_CheckEmpty(ngay_dung_sosanh)) {
        _End_Date = ngay_dung_sosanh.split('/');
        _End_Date = new Date(_End_Date[2], _End_Date[1] - 1, _End_Date[0])
    }

    //---------------------------------------
    if ((Common_CheckEmpty(ngay_bat_dau)) && (Common_CheckEmpty(ngay_dung_sosanh))) {
        if (_Start_Date < _End_Date) {
            alert('Xin vui lòng kiểm tra lại. ' + name_controlDate + ' bắt buộc phải lớn hơn hoặc bằng ' + name_ngay_dung_sosanh + '!');
            controlDate.focus();
            return false;
        }
    }
    return true;
}

function SoSanh2Date_NhoHon(controlDate, name_controlDate, ngay_dung_sosanh, name_ngay_dung_sosanh) {
    var _Start_Date;
    var _End_Date;
    var ngay_bat_dau = controlDate.value;

    //---------------------------------------
    if (Common_CheckEmpty(ngay_bat_dau)) {
        _Start_Date = ngay_bat_dau.split('/');
        _Start_Date = new Date(_Start_Date[2], _Start_Date[1] - 1, _Start_Date[0]);
    }

    //---------------------------------------
    if (Common_CheckEmpty(ngay_dung_sosanh)) {
        _End_Date = ngay_dung_sosanh.split('/');
        _End_Date = new Date(_End_Date[2], _End_Date[1] - 1, _End_Date[0])
    }

    //---------------------------------------
    if ((Common_CheckEmpty(ngay_bat_dau)) && (Common_CheckEmpty(ngay_dung_sosanh))) {
       
        if (_Start_Date > _End_Date) {
            alert('Xin vui lòng kiểm tra lại. ' + name_controlDate + ' bắt buộc phải nhỏ hơn hoặc bằng ' + name_ngay_dung_sosanh + '!');
            controlDate.focus();
            return false;
        }
    }
    return true;
}

////--------------------------------
//function Common_CheckLengthString(control, soluongkytu) {
//    var noidung = control.value;
//    var noidung_length = noidung.length;
//    if (noidung_length > soluongkytu) {
//        control.focus();
//        return false;
//    }
//    return true;
//}

