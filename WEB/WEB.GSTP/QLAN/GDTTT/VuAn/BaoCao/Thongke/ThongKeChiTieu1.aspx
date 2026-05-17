<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongKeChiTieu1.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.Thongke.ThongKeChiTieu1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <style type="text/css">
        .searchtop {
            display: none;
        }
    </style>
    <script src="../../../../UI/js/Common.js"></script>
    <div style="padding: 15px;">
        <table class="table1">
            <tr>
                <td colspan="4"></td>
            </tr>
            <tr>
                <td style="width: 200px; text-align:right"><b>Năm tính chỉ tiêu: Từ ngày</b></td>
                <td style="width: 265px;">
                    <asp:TextBox ID="txtNgay_Tu_ky" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay_Tu_ky" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay_Tu_ky" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                </td>
                <td style="width: 55px;"><b>Đến ngày</b></td>
                <td>
                    <asp:TextBox ID="txtNgay_Den_ky" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgay_Den_ky" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgay_Den_ky" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                </td>
                
            </tr>
            <tr>
                <td style="width: 200px; text-align:right"><b>Lãnh đạo</b></td>
                <td style="width: 265px;">
                    <asp:DropDownList ID="ddlPhoVuTruong" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                </td>
                <td style="width: 55px;"><b>Thẩm tra viên</b></td>
                <td>
                    <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                </td>
            </tr>
             <tr>
                <td style="width: 200px; text-align:right"><b>Thống kê chỉ tiêu: Từ ngày</b></td>
                <td style="width: 265px;">
                    <asp:TextBox ID="txtNgay_Tu" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgay_Tu" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgay_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                </td>
                <td style="width: 55px;"><b>Đến ngày</b></td>
                <td>
                    <asp:TextBox ID="txtNgay_Den" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgay_Den" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgay_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                </td>
                
            </tr>
            <tr>
                <td></td>
                <td style="text-align:right;">
                    <asp:Button ID="btnXemBC" runat="server" CssClass="buttoninput" Text="Xem báo cáo"  OnClick="btnXemBC_Click" />
                </td>
                <td colspan="2">
                    <asp:Button ID="btnXuatBC" runat="server" CssClass="buttoninput" Text="Xuất báo cáo"  OnClick="btnXuatBC_Click" />
                </td>
            </tr>
            <tr  style="height:400px">
                <td colspan="4">
                    <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 10px;"></asp:Label>
                    <asp:Label ID="lblNoidungBC" runat="server"  Style="padding-top: 20px;"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
  


    <script type="text/javascript">
        function ValidateInput() {
            var txtNgay_Tu = document.getElementById('<%=txtNgay_Tu.ClientID%>');
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgay_Tu, 'từ ngày')) {
                return false;
            }
            var txtNgay_Den = document.getElementById('<%=txtNgay_Den.ClientID%>');
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgay_Den, 'đến ngày')) {
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
