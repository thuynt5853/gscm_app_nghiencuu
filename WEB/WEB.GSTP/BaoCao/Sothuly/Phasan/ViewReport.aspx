<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ViewReport.aspx.cs" Inherits="WEB.GSTP.BaoCao.Sothuly.Phasan.ViewReport" %>

<%@ Register Assembly="DevExpress.XtraReports.v22.2.Web.WebForms, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../../UI/js/Common.js"></script>
    <div style="padding: 15px;">
        <table class="table1">
            <tr>
                <td colspan="4"></td>
            </tr>
            <tr>
                <td><b>Đơn vị</b></td>
                <td>
                    <asp:DropDownList ID="ddlDonVi" CssClass="chosen-select"
                        runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlDonVi_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
                <td colspan="2">
                    <asp:CheckBox ID="chkAll" runat="server" TextAlign="Right" Text="Bao gồm cả các đơn vị cấp dưới." />
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
                    <asp:TextBox ID="txtNgay_Den" runat="server" CssClass="user" Width="128px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgay_Den" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgay_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <asp:Button ID="btnXemBC" runat="server" CssClass="buttoninput" Text="Xem báo cáo" OnClientClick="return ValidateInput();" OnClick="btnXemBC_Click" />
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:Label ID="lblmsg" runat="server" style="color: red; float: left; padding-top: 10px;"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
    <dx:ASPxWebDocumentViewer ID="rptView" runat="server">
        <ClientSideEvents Init="function(s, e) {
                                                 s.previewModel.reportPreview.zoom(0.5);
                                               }" />
    </dx:ASPxWebDocumentViewer>
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
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
