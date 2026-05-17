<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pDuongsu.aspx.cs" Inherits="WEB.GSTP.QLAN.ADS.TaoHS.Popup.pDuongsu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/ADS/TaoHS/Popup/pDuongSuKhac.ascx" TagPrefix="uc1" TagName="pDuongSuKhac" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin đương sự</title>

    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>

    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin đương sự mới</h4>
                            <div class="boder" style="padding: 10px;">
                                <asp:HiddenField ID="hdfNgayNhanDon" runat="server" Value="" />
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Đương sự là<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;">
                                            <asp:DropDownList ID="ddlLoaiNguyendon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiNguyendon_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 70px;">Tư cách tố tụng<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlTucachTotung" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tên đương sự<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtTennguyendon" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                        <td colspan="2">
                                            <asp:CheckBox ID="chkISBVQLNK" Visible="false" runat="server" Text="Khởi kiện bảo vệ quyền và lợi ích hợp pháp của người khác, lợi ích công cộng và nhà nước" />

                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnNDTochuc" runat="server" Visible="false">
                                        <tr>
                                            <td>Địa chỉ</td>
                                            <td>
                                                <asp:DropDownList ID="ddl_NDD_Tinh" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddl_NDD_Tinh_SelectedIndexChanged"></asp:DropDownList>
                                                <asp:DropDownList ID="ddl_NDD_Huyen" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                            </td>
                                            <td>Chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtND_NDD_Diachichitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Người đại diện</td>
                                            <td>
                                                <asp:TextBox ID="txtND_NDD_Ten" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                            <td>Chức vụ</td>
                                            <td>
                                                <asp:TextBox ID="txtND_NDD_Chucvu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<asp:Literal ID="ltCMNDND" runat="server"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtND_CMND" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                        <td>Quốc tịch<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlND_Quoctich" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlND_Quoctich_SelectedIndexChanged"></asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:CheckBox ID="chkBoxCMNDND" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMNDND_CheckedChanged" />
                                    </td>
                                </tr>
                                    <asp:Panel ID="pnNDCanhan" runat="server">
                                        <tr>
                                            <td>Giới tính</td>
                                            <td>
                                                <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select" runat="server" Width="250px">
                                                    <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Ngày sinh</td>
                                            <td>
                                                <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user" Width="65px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                Năm sinh
                                                <asp:TextBox ID="txtND_Namsinh" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="35px" MaxLength="4" AutoPostBack="true" OnTextChanged="txtND_Namsinh_TextChanged"></asp:TextBox>
                                                <%--Tuổi
                                        <asp:TextBox ID="txtND_Tuoi" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="20px" MaxLength="2"></asp:TextBox>
                                         --%>   </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="3">
                                                <asp:CheckBox ID="chkONuocNgoai" AutoPostBack="true" runat="server" Text="Có yếu tố nước ngoài" OnCheckedChanged="chkONuocNgoai_CheckedChanged" />
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>Nơi cư trú</td>
                                            <td>
                                                <asp:DropDownList ID="ddlNoiSongTinh" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlNoiSongTinh_SelectedIndexChanged"></asp:DropDownList>
                                                <asp:DropDownList ID="ddlNoiSongHuyen" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                            </td>
                                            <td>Chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nơi làm việc</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtNoiLamViec" CssClass="user" runat="server" Width="590px" MaxLength="500"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Email</td>
                                        <td>
                                            <asp:TextBox ID="txtEmail" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                        <td>Điện thoại</td>
                                        <td>
                                            <asp:TextBox ID="txtDienthoai" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                            Fax
                                    <asp:TextBox ID="txtFax" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <div>
                                                <asp:HiddenField ID="hddDsid" runat="server" Value="0" />
                                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />
                                            <input type="button" class="buttoninput" onclick="window.onunload = function (e) {opener.LoadDsNguoiDuongSu();};window.close();" value="Đóng" />
                                            <%--<input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />--%>
                                        </td>
                                    </tr>
                                    <tr><td colspan="4">
                                        <uc1:pDuongSuKhac runat="server" ID="pDuongSuKhac" />
                                        </td></tr>
                                </table>
                            </div>
                            

                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
            function Setfocus(controlid) {
                var ctrl = document.getElementById(controlid);
                ctrl.focus();
            }
        </script>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
