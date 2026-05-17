<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pDuongSu.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Hoso.Popup.pDuongSu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bị can, bị can</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>

    <style>
    body {
        width: 98%;
        margin-left: 1%;
        min-width: 0px;
    }

    .box {
        height: 500px;
        overflow: auto;
    }
</style>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hddID" runat="server" Value="0" />
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <style>
            .align_right {
                text-align: right;
            }
        </style>
        <div style="margin: 5px; text-align: center; width: 95%">
            <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput"
                Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
            <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
        </div>
        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
            <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
        </div>
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">1. Thông tin bị can, bị can</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 120px;">Tên đối tượng<span class="batbuoc">(*)</span></td>
                                    <td style="width: 200px;">
                                        <asp:TextBox ID="txtTenBiCan" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                    </td>
                                    <td style="width: 105px;">Tên khác</td>
                                    <td>
                                        <asp:TextBox ID="txtTenKhac" CssClass="user" runat="server" Width="68%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Giới tính</td>
                                    <td>
                                        <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select" runat="server" Width="150">
                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td>Ngày sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtNgaysinh" runat="server" CssClass="user" Width="100px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgaysinh_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        Năm sinh<asp:TextBox ID="txtNamSinh" runat="server" CssClass="user" Width="70px" MaxLength="10" placeholder="Năm sinh"></asp:TextBox><span class="batbuoc">(*)</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Quốc tịch<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="dropQuocTich" CssClass="chosen-select"
                                            runat="server" Width="150px" AutoPostBack="True" OnSelectedIndexChanged="dropQuocTich_SelectedIndexChanged">
                                        </asp:DropDownList></td>
                                    <td>Dân tộc</td>
                                    <td>
                                        <asp:DropDownList ID="dropDanToc" CssClass="chosen-select"
                                            runat="server" Width="150px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>CMND/Thẻ căn cước/Hộ chiếu</td>
                                    <td>
                                        <asp:TextBox ID="txtCMND" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Thường trú<span class="batbuoc">(*)</span></td>
                                    <td colspan="2">
                                        <asp:DropDownList ID="ddlThuongTruTinh" CssClass="chosen-select" runat="server" Width="49%" AutoPostBack="true" OnSelectedIndexChanged="ddlThuongTruTinh_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlThuongTruHuyen" CssClass="chosen-select" runat="server" Width="49%"></asp:DropDownList>
                                    </td>
                                    <td>
                                        <span style="float: left; margin-top: 6px; width: 29%;">Thường trú chi tiết</span>
                                        <asp:TextBox ID="txtHKTT_Chitiet" CssClass="user" runat="server" Width="69%" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nơi sinh sống<span class="batbuoc">(*)</span></td>
                                    <td colspan="2">
                                        <asp:DropDownList ID="ddlNoiSongTinh" CssClass="chosen-select" runat="server" Width="49%" AutoPostBack="true" OnSelectedIndexChanged="ddlNoiSongTinh_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlNoiSongHuyen" CssClass="chosen-select" runat="server" Width="49%"></asp:DropDownList>
                                    </td>
                                    <td>
                                        <span style="float: left; margin-top: 6px; width: 29%;">Nơi sinh sống chi tiết</span>
                                        <asp:TextBox ID="txtTamtru_Chitiet" CssClass="user" runat="server" Width="69%" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tôn giáo</td>
                                    <td>
                                        <asp:DropDownList ID="dropTonGiao" CssClass="chosen-select" runat="server" Width="150">
                                        </asp:DropDownList></td>
                                    <td>Nghề nghiệp</td>
                                    <td>
                                        <asp:DropDownList ID="dropNgheNghiep" CssClass="chosen-select" runat="server" Width="150">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Trình độ văn hóa<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="dropTrinhDoVH" CssClass="chosen-select" runat="server" Width="155px">
                                        </asp:DropDownList></td>

                                    <td>Tình trạng giam giữ</td>
                                    <td>
                                        <asp:DropDownList ID="dropTinhTrangGiamGiu" CssClass="chosen-select" runat="server" Width="155px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="height: 5px;"></td>
                                </tr>
                                <tr id="row_thongtinbo">
                                    <td>Họ tên bố</td>
                                    <td>
                                        <asp:TextBox ID="txtHoTenBo" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox></td>
                                    <td>Năm sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtNamSinhBo" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="100px" MaxLength="50"></asp:TextBox></td>
                                </tr>
                                <tr id="row_thongtinme">
                                    <td>Họ tên mẹ</td>
                                    <td>
                                        <asp:TextBox ID="txtHotenMe" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox></td>
                                    <td>Năm sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtNamSinhMe" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="100px" MaxLength="50"></asp:TextBox></td>
                                </tr>

                                <tr>
                                    <td>Nghiện hút</td>
                                    <td>
                                        <asp:RadioButtonList ID="rdNGhienHut" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                    <td>Tái phạm</td>
                                    <td>
                                        <asp:RadioButtonList ID="rdTinhTrangTaiPham" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tiền án</td>
                                    <td>
                                        <asp:TextBox ID="txtTienAn" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="145px" MaxLength="50" Text="0"></asp:TextBox></td>
                                    <td>Tiền sự</td>
                                    <td>
                                        <asp:TextBox ID="txtTienSu" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="100px" MaxLength="50" Text="0"></asp:TextBox></td>
                                </tr>
                                <!---------------------------------------------->
                                <tr>
                                    <td>Trẻ vị thành niên</td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdTreViThanhNien" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdTreViThanhNien_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                                <asp:Panel ID="pnTreViThanhNien" runat="server" Visible="false">
                                    <tr>
                                        <td>Trẻ mồ côi cha hoặc mẹ</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdTreMoCoi" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                        <td style="width: 80px;">Trẻ lang thang</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdTreLangThang" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Trẻ bỏ học</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdTreBoHoc" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                        <td>Bố mẹ ly hôn</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdLyHon" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Có người đủ 18 tuổi trở lên xúi giục</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdNguoiXuiGiuc" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                            </table>

                        </div>

                    </div>

                </div>
            </div>
        </div>
        <div style="float: left; width: 100%;">
            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
            </div>
            <div style="margin: 5px; text-align: center; width: 95%; float: left;">
                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                    Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
            </div>
        </div>
    </form>

    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }

        function validate() {
            //-----------------------------
            var txtTen = document.getElementById('<%=txtTenBiCan.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên bị can.Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            //-----------------------------
            var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
            if (!Common_CheckEmpty(txtNamSinh.value)) {
                alert('Bạn chưa nhập năm sinh của bị can.Hãy kiểm tra lại!');
                txtNamSinh.focus();
                return false;
            }

            //-----------------------------
            var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
            var value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn mục "quốc tịch". Hãy kiểm tra lại!');
                dropQuocTich.focus();
                return false;
            }

            //-----------------------------
            var dropDanToc = document.getElementById('<%=dropDanToc.ClientID%>');
            value_change = dropDanToc.options[dropDanToc.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn mục "Dân tộc". Hãy kiểm tra lại!');
                dropDanToc.focus();
                return false;
            }



            //-------------------------------------------------
            var dropTrinhDoVH = document.getElementById('<%=dropTrinhDoVH.ClientID%>');
            value_change = dropTrinhDoVH.options[dropTrinhDoVH.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn mục "trình độ văn hóa". Hãy kiểm tra lại!');
                dropTrinhDoVH.focus();
                return false;
            }
            if (!validate_bienphapnc())
                return false

            return true;
        }


    </script>

</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
