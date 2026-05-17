<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pNguoiThamGiaTT.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.TaoHS.Popup.pNguoiThamGiaTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/AHS/TaoHS/Popup/uDSNguoiThamGiaToTung.ascx" TagPrefix="uc1" TagName="uDSNguoiThamGiaToTung" %>


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
            width: 760px;
            position: relative;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
        <asp:HiddenField ID="hddTuCachTT_BiHai_ID" runat="server" Value="0" />
        <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
        <div class="box">

            <div class="form_tt">
                <h4 class="tleboxchung">Thông tin người tham gia tố tụng</h4>
                <div class="boder" style="padding: 10px; width: 735px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 120px;">Đối tượng<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="dropLoaiDoiTuong"
                                    CssClass="chosen-select" runat="server" Width="250"
                                    AutoPostBack="true" OnSelectedIndexChanged="dropLoaiDoiTuong_SelectedIndexChanged">
                                    <asp:ListItem Value="0" Text="Cá nhân"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Cơ quan"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Tổ chức"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Tư cách tham gia<span class="batbuoc">(*)</span></td>
                            <td style="width: 250px;">
                                <asp:DropDownList ID="ddlTuCachTGTT"
                                    CssClass="chosen-select" runat="server" Width="250px"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlTuCachTGTT_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 93px;">
                                <asp:Literal ID="lblHoTen" runat="server" Text="Họ tên"></asp:Literal><span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtHoten" CssClass="user" runat="server"
                                    MaxLength="250" Width="207px"></asp:TextBox>
                            </td>
                        </tr>
                        <asp:Panel ID="pnNguoiDD" runat="server" Visible="false">
                            <tr>
                                <td>Người đại diện</td>
                                <td>
                                    <asp:TextBox ID="txtNDD_HoTen" CssClass="user" runat="server"
                                        MaxLength="250" Width="242px"></asp:TextBox>
                                </td>
                                <td>Chức vụ</td>
                                <td>
                                    <asp:TextBox ID="txtNDD_ChucVu" CssClass="user" runat="server"
                                        MaxLength="250" Width="207px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>CMND</td>
                                <td>
                                    <asp:TextBox ID="txtNDD_CMND" CssClass="user" runat="server"
                                        MaxLength="250" Width="242px"></asp:TextBox>
                                </td>
                                <td>Điện thoại</td>
                                <td>
                                    <asp:TextBox ID="txtNDD_Mobile" CssClass="user" runat="server"
                                        MaxLength="250" Width="207px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Email</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNDD_Email" CssClass="user" runat="server"
                                        MaxLength="250" Width="568px"></asp:TextBox>
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnCaNhan" runat="server">
                            <tr>
                                <td>Giới tính</td>
                                <td>
                                    <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Nam" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Ngày sinh</td>
                                <td>
                                    <asp:TextBox ID="txtNgaysinh" runat="server" CssClass="user"
                                        MaxLength="10" Width="80px"
                                        AutoPostBack="True" OnTextChanged="txtNgaysinh_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    Năm sinh
                                    <asp:TextBox ID="txtNamsinh" CssClass="user align_right"
                                        onkeypress="return isNumber(event)" runat="server"
                                        Width="58px" MaxLength="4"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Nghề nghiệp</td>
                                <td>
                                    <asp:DropDownList ID="ddlNgheNghiep" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                    </asp:DropDownList>
                                </td>
                                <td>Ngày tham gia</td>
                                <td>
                                    <asp:TextBox ID="txtNgaythamgia" runat="server" CssClass="user" Width="206px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythamgia" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaythamgia" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgaythamgia" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnTreViThanhNien" runat="server" Visible="false">
                            <tr>
                                <td>Trẻ vị thành niên<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdTreViThanhNien" runat="server"
                                        RepeatDirection="Horizontal" AutoPostBack="true"
                                        OnSelectedIndexChanged="rdTreViThanhNien_SelectedIndexChanged">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <asp:Panel ID="pnTreVTNCo" runat="server" Enabled="false">
                                    <td>Phân loại độ tuổi</td>
                                    <td>
                                        <asp:DropDownList ID="ddlPLTuoi"
                                            CssClass="chosen-select" runat="server" Width="214px">
                                            <asp:ListItem Value="1" Text="Dưới 16 tuổi" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Dưới 16 tuổi bị tổn thương nghiêm trọng về tâm lý"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Từ đủ 16 đến dưới 18 tuổi"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Từ đủ 16 đến dưới 18 tuổi bị tổn thương nghiêm trọng về tâm lý"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </asp:Panel>
                                <asp:Panel ID="pnTreVTNKhong" runat="server" Visible="true">
                                    <td colspan="2"></td>
                                </asp:Panel>
                            </tr>
                        </asp:Panel>

                        <tr>
                            <td>Địa chỉ chi tiết</td>
                            <td colspan="3">
                                <asp:TextBox ID="txtDiaChiChitiet" CssClass="user"
                                    runat="server" MaxLength="250" Width="568px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="3">
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu & Thoát"
                                    OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                                <asp:Button ID="cmdUpdateAndNext" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới"
                                    OnClientClick="return validate();" OnClick="cmdUpdateAndNext_Click" />

                                <input type="button" class="buttoninput" onclick="ClosePopup()" value="Đóng" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="3">
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                        <tr><td colspan="4">
                            <uc1:uDSNguoiThamGiaToTung runat="server" ID="uDSNguoiThamGiaToTung" />
                        </td></tr>
                    </table>
                </div>
            </div>

        </div>
    </form>
    <script>
        function validate() {
            var dropLoaiDoiTuong = document.getElementById('<%=dropLoaiDoiTuong.ClientID%>');
            var loaidoituong = dropLoaiDoiTuong.options[dropLoaiDoiTuong.selectedIndex].value;

            var ddlTuCachTGTT = document.getElementById('<%=ddlTuCachTGTT.ClientID%>');
            var tucachtt = ddlTuCachTGTT.options[ddlTuCachTGTT.selectedIndex].value;

            var hddTuCachTT_BiHai_ID = document.getElementById('<%=hddTuCachTT_BiHai_ID.ClientID%>');
            var ConfigBiHaiID = hddTuCachTT_BiHai_ID.value;

            var temp_hoten = "";
            if (loaidoituong == "0")
                temp_hoten = "Họ tên người tham gia tố tụng";
            else if (loaidoituong == "1")
                temp_hoten = "Tên cơ quan";
            else if (loaidoituong == "0")
                temp_hoten = "Tên tổ chức";
            //alert(temp_hoten);

            //-----------------------------
            var length_value = 0;
            var txtHoten = document.getElementById('<%=txtHoten.ClientID%>');
            if (!Common_CheckEmpty(txtHoten.value)) {
                alert('Bạn chưa nhập "' + temp_hoten + '". Hãy kiểm tra lại!');
                txtHoten.focus();
                return false;
            }
            length_value = txtHoten.value.length;
            if (length_value > 250) {
                alert(temp_hoten + ' không nhập quá 250 ký tự. Hãy kiểm tra lại!');
                txtHoten.focus();
                return false;
            }

            //-------------------------------
            var txtNgaysinh = document.getElementById('<%=txtNgaysinh.ClientID%>');
            if (Common_CheckEmpty(txtNgaysinh.value)) {
                if (!CheckDateTimeControl(txtNgaysinh, 'Ngày sinh của người tham gia tố tụng'))
                    return false;
            }
            
            //-------------------------------------
            if (loaidoituong == "0" && tucachtt == ConfigBiHaiID) {
                var rdTreViThanhNien = document.getElementById('<%=rdTreViThanhNien.ClientID%>');
                msg = 'Mục "Trẻ vị thành niên" bắt buộc phải chọn.';
                msg += 'Hãy kiểm tra lại!';

                if (!CheckChangeRadioButtonList(rdTreViThanhNien, msg))
                    return false;
            }

            //-------------------------------
            var txtNgaythamgia = document.getElementById('<%=txtNgaythamgia.ClientID%>');
            if (Common_CheckEmpty(txtNgaythamgia.value)) {
                if (!CheckDateTimeControl(txtNgaythamgia, 'Ngày tham gia tố tụng'))
                    return false;
            }
            var txtDiaChiChitiet = document.getElementById('<%=txtDiaChiChitiet.ClientID%>');
            if (Common_CheckEmpty(txtDiaChiChitiet.value)) {
                length_value = txtDiaChiChitiet.value.length;
                if (length_value > 250) {
                    {
                        alert('Địa chỉ chi tiết không quá 250 ký tự. Hãy kiểm tra lại!');
                        txtDiaChiChitiet.focus();
                        return false;
                    }
                }
            }
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
