<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pNguoiThamGiaTT.aspx.cs" Inherits="WEB.GSTP.QLAN.AKT.TaoHS.Popup.pNguoiThamGiaTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register src="uDSNguoiThamGiaToTung.ascx" tagname="uDSNguoiThamGiaToTung" tagprefix="uc1" %>





<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật thông tin người tham gia tố tụng</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>

    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            padding-top: 5px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }

        .form_tt {
            padding-top: 10px;
            margin: 0 auto;
            width: 850px;
            position: relative;
        }
        .mt10{
            margin-top:10px;
        }
        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }
        .clcheckbox{
            margin-left:10px;
            display:inline-block;
            margin-top:5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hddid" runat="server" Value="0" />
        <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
        <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
        <asp:HiddenField ID="lstDataDuongSu" Value="" runat="server" />
        <div class="box">

            <div class="form_tt">
                <h4 class="tleboxchung">Thông tin người tham gia tố tụng</h4>
                
                <div class="boder" style="padding: 10px;">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                      <table>
                         <tr>
                            <td  style="width: 150px;">Tư cách tham gia tố tụng<span class="batbuoc">(*)</span></td>
                            <td  style="width: 300px;" colspan="1">
                                <asp:DropDownList ID="ddlTucachTGTT" CssClass="chosen-select" runat="server" Width="270px">
                                </asp:DropDownList>
                            </td>

                             <td style="width:200px">Số CMND/ Thẻ căn cước/ Hộ chiếu<span id="ltCMNDBD"></span></td>
                                <td style="width:200px">
                                    <asp:TextBox ID="txtBD_CMND" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox></td>

                            <td style="width:116px"><asp:CheckBox ID="chkBoxCMNDBD"  runat="server" Text="Không có"  />
                                </td>

                        </tr>
                        <tr>
                            <td style="width:150px" class="AKT_ToTung_Col1">Họ tên người TGTT<span class="batbuoc">(*)</span></td>
                            <td class="AKT_ToTung_Col2">
                                <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="270px"></asp:TextBox>
                            </td>
                            <td class="AKT_ToTung_Col3">Ngày tham gia</td>
                            <td>
                                <asp:TextBox ID="txtNgaythamgia" runat="server" CssClass="user" Width="80px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythamgia" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaythamgia" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width:150px">Nơi tạm trú</td>
                            <td>
                                <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server" Width="270px" MaxLength="250"></asp:TextBox></td>
                            <td>Nơi ĐKHKTT</td>
                            <td>
                                <asp:TextBox ID="txtND_HKTT_Chitiet" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width:150px">Giới tính</td>
                            <td>
                                
                                    <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select" runat="server" Width="108px">
                                        <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList>
                                
                               
                                <span class="lblTitleTT">Ngày sinh</span>
                                <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user floatF" Width="100px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td>Năm sinh</td>
                            <td>
                                <asp:TextBox ID="txtND_Namsinh" CssClass="user Text_AlignR" onkeypress="return isNumber(event)" runat="server" Width="80px" MaxLength="4"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:150px">Điện thoại</td>
                            <td>
                                <asp:TextBox ID="txtDienThoai" CssClass="user floatF Text_AlignR" runat="server" Width="116px" onkeypress="return isNumber(event)"></asp:TextBox>
                                <span class="lblTitleTT">Fax</span>
                                <asp:TextBox ID="txtFax" CssClass="user floatF Text_AlignR" runat="server" Width="116px" onkeypress="return isNumber(event)"></asp:TextBox>
                            </td>
                            <td>Email</td>
                            <td>
                                <asp:TextBox ID="txtEmail" CssClass="user" runat="server" Width="200px"></asp:TextBox></td>

                        </tr>
                        <tr>
                           <asp:Panel ID="pnItemDs" runat="server">
                            <table >
                            <tr>
                                <td style="width:96px">Đại diện cho</td>
                                <td style="border: 1px solid #b9b7b7;padding: 5px 0px 12px 0px;width: 632px;background-color: #f5f4f4;">
                                
                                    <asp:Panel runat="server" ID="pnDuongSuDON_GHEP">
                                    
                                    </asp:Panel>
                                
                                </td>

                                <td colspan="3"></td>
                            </tr>
                            </table>
                        </asp:Panel>

                        </tr>
                           <div style="text-align:center;">
                                <td colspan="4">
                                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput mt10" Text="Lưu"
                                        OnClientClick="return ValidDataInput();" OnClick="btnUpdate_Click" />
                                    <input type="button" class="buttoninput mt10" onclick="window.onunload = function (e) {opener.LoadDsNguoiThamGiaTT();};window.close();" value="Đóng" />
                                    <%--<asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />--%>
                                </td>
                            </div> 
                        <tr><td colspan="4">
                            <uc1:uDSNguoiThamGiaToTung ID="uDSNguoiThamGiaToTung1" runat="server" />
                        </td></tr>
                    </table>
                    
                </div>
            </div>

        </div>
    </form>
    <script>


        $(document).ready(function () {
            loadeventchange();
            setValidateCMND();
        })
        function loadeventchange() {
            if ($('#<%=chkBoxCMNDBD.ClientID%>').is(':checked')) {
                ltCMNDBD.innerHTML = "";
            }
            else {
                ltCMNDBD.innerHTML = "<span style='color:red'>(*)</span>";
            }
            $('#<%=pnDuongSuDON_GHEP.ClientID%>').off('change');
            $('#<%=pnDuongSuDON_GHEP.ClientID%>').on('change', '.clcheckbox input:first-child', function (e) {
                let data = $('#<%=lstDataDuongSu.ClientID%>').val();
                


                if (data == '') {
                    data = ',';
                }
                else {
                    if (data[0] != ',') {
                        data = ',' + data;
                    }
                    if (data[data.length - 1] != ',') {
                        data = data + ',';
                    }
                }
                let tcttcheck = $(this).attr('tctt');
                let idcheck = $(this).parent(".clcheckbox").attr('title');
                $('.clcheckbox input:first-child').each(function () {
                    let idcurrent = $(this).parent(".clcheckbox").attr('title');
                    let tcttcurent = $(this).attr('tctt');
                    if (this.checked && idcheck != idcurrent) {
                        if (tcttcheck != tcttcurent) {
                            ischeck = false;
                            data = data.replace("," + $(this).parent(".clcheckbox").attr('title') + ",", ",");
                            $(this).prop('checked', false);
                        }
                    }
                })
                if (this.checked) {
                    //thêm
                    data += $(this).parent(".clcheckbox").attr('title') + ",";
                }
                else {
                    data = data.replace("," + $(this).parent(".clcheckbox").attr('title') + ",", ",");
                }

                if (data == '') {
                    data = ',';
                }
                else {
                    if (data[0] != ',') {
                        data = ',' + data;
                    }
                    if (data[data.length - 1] != ',') {
                        data = data + ',';
                    }
                }
                console.log(data);
                $('#<%=lstDataDuongSu.ClientID%>').val(data);
            })



        }
        function setValidateCMND() {
            var ltCMNDBD = document.getElementById('ltCMNDBD');
            ltCMNDBD.innerHTML = "<span style='color:red'>(*)</span>";
            $(document).off('change');
            $(document).on('change', '#<%=chkBoxCMNDBD.ClientID%>', function () {
                var ltCMNDBD = document.getElementById('ltCMNDBD');
                if ($(this).is(':checked')) {
                    ltCMNDBD.innerHTML = "";
                }
                else {
                    ltCMNDBD.innerHTML = "<span style='color:red'>(*)</span>";
                }
            })
        }


        function ValidDataInput() {
             var ddlTucachTGTT = document.getElementById('<%=ddlTucachTGTT.ClientID%>');
            var val = ddlTucachTGTT.options[ddlTucachTGTT.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn tư cách tham gia tố tụng. Hãy chọn lại!');
                ddlTucachTGTT.focus();
                return false;
            }
            if (!$('#<%=chkBoxCMNDBD.ClientID%>').is(':checked')) {
                var txtBD_CMND = document.getElementById('<%=txtBD_CMND.ClientID%>');
                if (txtBD_CMND.value.trim().length == 0) {
                    alert('Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu. Hãy chọn lại!');
                    txtBD_CMND.focus();
                    return false;
                }
            }
            var txtHoten = document.getElementById('<%=txtHoten.ClientID%>');
            if (!Common_CheckTextBox(txtHoten, "Họ tên người tham gia tố tụng")) {
                     return false;
                 }
                 var lengthHoten = txtHoten.value.trim().length;
                 if (lengthHoten > 250) {
                     alert('Họ tên người tham gia tố tụng không nhập quá 250 ký tự. Hãy nhập lại!');
                     txtHoten.focus();
                     return false;
                 }

                 <%--var txtNgaythamgia = document.getElementById('<%=txtNgaythamgia.ClientID%>');
            if (!CheckDateTimeControl(txtNgaythamgia, "Ngày tham gia"))
                return false;--%>

            var txtND_TTChitiet = document.getElementById('<%=txtND_TTChitiet.ClientID%>');
            if (Common_CheckEmpty(txtND_TTChitiet.value)) {
                if (txtND_TTChitiet.value.trim().length > 250) {
                    alert('Nơi tạm trú chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtND_TTChitiet.focus();
                    return false;
                }
            }

            var txtND_HKTT_Chitiet = document.getElementById('<%=txtND_HKTT_Chitiet.ClientID%>');
            if (Common_CheckEmpty(txtND_HKTT_Chitiet.value)) {
                if (txtND_HKTT_Chitiet.value.trim().length > 250) {
                    alert('Nơi ĐKHKTT chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtND_HKTT_Chitiet.focus();
                    return false;
                }
            }

            var txtND_Ngaysinh = document.getElementById('<%=txtND_Ngaysinh.ClientID%>');
            if (Common_CheckEmpty(txtND_Ngaysinh.value)) {
                if (!CheckDateTimeControl(txtND_Ngaysinh.value))
                    return false;
            }

            <%--var txtNDD_Hoten = document.getElementById('<%=txtNDD_Hoten.ClientID%>');
            if (Common_CheckEmpty(txtNDD_Hoten.value)) {
                if (txtNDD_Hoten.value.trim().length > 250) {
                    alert('Tên người đại diện không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtNDD_Hoten.focus();
                    return false;
                }
            }--%>
            return true;
        }
    </script>

    <script>
        function ReloadParent() {
            //alert('goi ham form cha');
            window.onunload = function (e) {
                opener.LoadDsNguoiThamGiaTT();
            };
            window.close();
        }

        function ClosePopup() {
            var hddIsReloadParent = document.getElementById('<%=hddIsReloadParent.ClientID%>');
            var value = parseInt(hddIsReloadParent.value);
            if (value == 0)
                window.close();
            else
                ReloadParent();
        }
    </script>

    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        //-------load parent page when close popup---------------
        //window.onunload = refreshParent;
        //function refreshParent() {
        //    window.opener.location.reload();
        //}

    </script>
</body>
</html>
