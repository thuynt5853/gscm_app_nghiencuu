<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="BCGiaiQuyetDonDNGDTTT.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.Thongke.BCGiaiQuyetDonDNGDTTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .searchtop {
            display: none;
        }
    </style>
    <div style="padding: 15px; height: 500px;">
        <table class="table1">
            <tr>
                <td colspan="4"></td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 0px; font-size: 15px;"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 55px;"><b>Từ ngày</b></td>
                <td style="width: 265px;">
                    <asp:TextBox ID="txtNgay_Tu" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay_Tu" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                </td>
                <td style="width: 55px;"><b>Đến ngày</b></td>
                <td>
                    <asp:TextBox ID="txtNgay_Den" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgay_Den" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgay_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <div style="margin-top: 8px;">
                        <asp:Button ID="btnXemBC" runat="server" CssClass="buttoninput" Text="Xem báo cáo" OnClientClick="return ValidateInput();" OnClick="btnXemBC_Click" />
                    </div>
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
