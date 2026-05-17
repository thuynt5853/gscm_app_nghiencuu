<%@ Page Title="" Language="C#" AutoEventWireup="true"
    MasterPageFile="~/MasterPages/GSTP.Master"
    CodeBehind="ViewBC.aspx.cs"
    Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.XetXuGDT.ViewBC" %>

<%@ Register Assembly="DevExpress.XtraReports.v22.2.Web.WebForms, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div style="padding: 15px;">
        <table class="table1">

            <tr>
                <td>Thẩm phán</td>
                <td>
                    <asp:DropDownList ID="ddlThamphan"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
                        CssClass="chosen-select" runat="server" Width="250px">
                    </asp:DropDownList>
                </td>
                <td>Loại án</td>
                <td>
                    <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                        runat="server" Width="250px">
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td style="width: 100px;">Từ ngày</td>
                <td style="width: 265px;">
                    <asp:TextBox ID="txtNgay_Tu" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay_Tu" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                </td>
                <td style="width: 80px;">Đến ngày</td>
                <td>
                    <asp:TextBox ID="txtNgay_Den" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgay_Den" Format="dd/MM/yyyy" Enabled="true" />
                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgay_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                </td>
            </tr>
                <tr>
                    <td>Tình trạng
                    </td>
                    <td><%-- AutoPostBack="true" OnSelectedIndexChanged="dropTrangThaiXXGDT_SelectedIndexChanged"--%>
                        <asp:DropDownList ID="dropTrangThaiXXGDT"
                           
                            CssClass="chosen-select" runat="server" Width="250px">
                            <asp:ListItem Value="-1" Text="Tất cả"></asp:ListItem>
                            <asp:ListItem Value="0" Text="Thụ lý XX GDT, TT"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Đã xét xử GDT, TT"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>Kết quả xét xử</td>
                    <td colspan="3">
                        <asp:DropDownList ID="ddlKetquaXX" CssClass="chosen-select"
                            runat="server" Width="250px">
                        </asp:DropDownList></td>
                </tr>
            <tr>
                <td class="DonGDTCol1">Tiêu đề báo cáo</td>
                <td colspan="3">
                    <asp:TextBox ID="txtTieuDeBC" runat="server"
                        CssClass="user" Width="601px" MaxLength="250" Text="Danh sách các vụ án"></asp:TextBox></td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <asp:Button ID="btnXemBC" runat="server" CssClass="buttoninput" Text="Xem báo cáo" OnClientClick="return ValidateInput();" OnClick="btnXemBC_Click" />
                </td>
            </tr>
            <tr>
                <td colspan="4" style="padding-top: 10px; font-weight: bold; font-size: 13pt;">
                    <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                    <%--   <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 10px;"></asp:Label>--%>
                </td>
            </tr>
        </table>
    </div>
    <dx:ASPxWebDocumentViewer ID="rptView" runat="server">
        <ClientSideEvents Init="function(s, e) {
                                                    s.previewModel.reportPreview.zoom(0.80);
                                                    }" />
    </dx:ASPxWebDocumentViewer>



    <script type="text/javascript">
        function ValidateInput() {
          <%--  var txtNgay_Den = document.getElementById('<%=txtNgay_Den.ClientID%>');
            if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtNgay_Den, 'đến ngày')) {
                return false;
            }--%>

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
