<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pUTTPDi.aspx.cs" Inherits="WEB.GSTP.QLAN.UTTP.Popup.pUTTPDi" %>

<%--MasterPageFile="~/MasterPages/GSTP.Master"--%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật quyết định và hình phạt</title>
   
    
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
            min-height: 0px;
        }



        .box {
            overflow: auto;
            position: absolute;
            width:100%
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }
        input{
            height:28px !important;
        }
         
         </style>
</head>
<body>
    
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
        <div class="box_nd">
            <asp:Panel ID="pnThemUTTPDi" runat="server" Visible="true">
                 <asp:HiddenField ID="hddid" runat="server" Value="0" />
                <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
                <asp:HiddenField ID="hddLoaiAn" runat="server" Value="0" />
                <asp:HiddenField ID="dhhIdDoiTuongTongDat" runat="server" Value="0" />
                <asp:HiddenField ID="dhhBieuMauID" runat="server" Value="0" />
                <asp:HiddenField ID="hddQuocGiaUT" runat="server" Value="0" />
                <asp:HiddenField ID="hddDonviUT" runat="server" Value="0" />
                <div class="boxchung">
                                <h4 class="tleboxchung">Cập nhật/sửa thông tin UTTP</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td style="width:83px">
                                                <asp:Label ID="lblTrangThai"  runat="server" Text="Đơn vị UT"></asp:Label></td>
                                            <td style="width:330px">
                                                <asp:TextBox ID="txtDonviUT" Enabled="false" runat="server" CssClass="user" Width="330px"></asp:TextBox>
                                            </td>

                                            <td style="width:80px">
                                                <asp:Label ID="Label1" runat="server" Text="Ngày nhận UTTP từ tòa cấp dưới"></asp:Label></td>
                                            <td >
                                                <asp:TextBox ID="txttNgayNhanUTTPTuToaCapDuoi" runat="server" CssClass="user" Width="219px" MaxLength="10" AutoPostBack="true"  OnTextChanged="txttNgayNhanUTTPTuToaCapDuoi_SelectedIndexChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txttNgayNhanUTTPTuToaCapDuoi" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txttNgayNhanUTTPTuToaCapDuoi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:93px">
                                                <asp:Label ID="lblCoQuanUT" runat="server" Text="Cơ quan UT"></asp:Label>
                                            </td>
                                            <td style="width:330px">
                                                <asp:TextBox ID="txttCoQuanUT" runat="server" CssClass="user" Width="330px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td >
                                                <asp:Label ID="lblQuocGia" runat="server" Text="Quốc Gia"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtQuocGiaUT" Enabled="false" runat="server" CssClass="user" Width="219px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:80px">Văn bản UT</td>
                                            <td colspan="4">
                                                <asp:TextBox ID="txttVanBanUT" Enabled="false" TextMode="MultiLine" runat="server" CssClass="user" Width="648px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:80px">Nội dung</td>
                                            <td colspan="4">
                                                <asp:TextBox Enabled="false" TextMode="MultiLine" ID="txttNoiDung" runat="server" CssClass="user" Width="648px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:80px">Ngày chuyển UTTP</td>
                                            <td style="width:330px">
                                                <asp:TextBox ID="txttNgayChuyenUTTP" runat="server" CssClass="user" Width="330px" MaxLength="10" AutoPostBack="true" OnTextChanged="txttNgayChuyenUTTP_SelectedIndexChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txttNgayChuyenUTTP" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txttNgayChuyenUTTP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Ngày nhận được kết quả</td>
                                            <td >
                                                <asp:TextBox ID="txttNgayNhanDuocketQua" runat="server" CssClass="user" Width="219px" MaxLength="10" AutoPostBack="true" OnTextChanged="txttNgayNhanDuocketQua_SelectedIndexChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txttNgayNhanDuocketQua" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txttNgayNhanDuocketQua" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:80px">Ghi chú</td>
                                            <td style="width:330px">
                                                <asp:TextBox TextMode="MultiLine" ID="txttGhiChu" runat="server" CssClass="user" Width="330px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Ngày chuyển KQ UT về tòa cấp dưới</td>
                                            <td>
                                                <asp:TextBox ID="txttNgayChuyenKQUTVeToaCapDuoi" runat="server" CssClass="user" Width="219px" MaxLength="10" OnTextChanged="txttNgayChuyenKQUTVeToaCapDuoi_SelectedIndexChanged" AutoPostBack="true"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txttNgayChuyenKQUTVeToaCapDuoi" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txttNgayChuyenKQUTVeToaCapDuoi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: center;" colspan="4">
                                                <%--<asp:Button ID="cmdCapnhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="lbLuuAndQuayLai_Click" />--%>
                                                <asp:Button ID="Button2" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="lbLuuAndQuayLai_Click" />
                                                <asp:Button ID="cmdQuayLai" runat="server" CssClass="buttoninput" Text="Đóng" OnClick="btnQuayLai_Click" />
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left;" colspan="4">
                                                <asp:Label runat="server" ID="lbthongBaoUpdate" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                </asp:Panel>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function ReloadParent() {
            window.onunload = function (e) {
                opener.ReLoadGrid();
            };
            window.close();
        }
    </script>
    </form>
</body>
</html>

