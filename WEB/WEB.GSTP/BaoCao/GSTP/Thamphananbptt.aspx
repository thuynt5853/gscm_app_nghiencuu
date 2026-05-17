<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Thamphananbptt.aspx.cs" Inherits="WEB.GSTP.BaoCao.GSTP.Thamphananbptt" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .rpThamPhanCol1 {
            width: 112px;
        }

        .rpThamPhanCol2 {
            width: 210px;
        }

        .rpThamPhanCol3 {
            width: 86px;
        }

        .rpThamPhanCol4 {
            width: 145px;
        }

        .rpThamPhanCol5 {
            width: 115px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <asp:HiddenField ID="hddDonViLoginID" runat="server" Value="0" />
                <table class="table1">
                    <tr>
                        <td><b>Đơn vị</b></td>
                        <td colspan="5">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlToaAn" runat="server" Width="708px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Mã thẩm phán</b></td>
                        <td>
                            <asp:TextBox ID="txtMaTP" CssClass="user" runat="server" Width="192px"></asp:TextBox></td>
                        <td><b>Tên thấm phán</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtTenTP" CssClass="user" runat="server" Width="386px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Địa chỉ</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtDiaChi" CssClass="user" runat="server" Width="440px"></asp:TextBox>
                        </td>
                        <td><b>Giới tính</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="ddlGioiTinh" runat="server" Width="116px">
                                <asp:ListItem Text="-- Tất cả --" Value=""></asp:ListItem>
                                <asp:ListItem Text="Nam" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Nữ" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="rpThamPhanCol1"><b>Số CMND</b></td>
                        <td class="rpThamPhanCol2">
                            <asp:TextBox ID="txtCMND" CssClass="user" runat="server" Width="192px" MaxLength="50"></asp:TextBox></td>
                        <td class="rpThamPhanCol3"><b>Ngày sinh</b></td>
                        <td class="rpThamPhanCol4">
                            <asp:TextBox ID="txtNgaySinh" runat="server" CssClass="user" Width="126px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaySinh" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaySinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td class="rpThamPhanCol5"><b>Số điện thoại</b></td>
                        <td>
                            <asp:TextBox ID="txtDienThoai" CssClass="user" runat="server" Width="108px" MaxLength="50"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Chức danh</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="ddlChucDanh" runat="server" Width="200px"></asp:DropDownList></td>
                        <td><b>Chức vụ</b></td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="ddlChucVu" runat="server" Width="134px"></asp:DropDownList></td>
                        <td><b>Ngày nhận công tác</b></td>
                        <td>
                            <asp:TextBox ID="txtNgayNhanCT" runat="server" CssClass="user" Width="108px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayNhanCT" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayNhanCT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Ngày bổ nhiệm</b></td>
                        <td>
                            <asp:TextBox ID="txtNgayBoNhiem" runat="server" CssClass="user" Width="191px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayBoNhiem" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayBoNhiem" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td><b>Ngày kết thúc</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtNgayKetThuc" runat="server" CssClass="user" Width="126px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayKetThuc" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayKetThuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td><b style="margin-right: 5px;">Loại án</b><asp:CheckBox ID="chkAll" runat="server" Text="(Tất cả)" AutoPostBack="true" OnCheckedChanged="chkAll_CheckedChanged" /></td>
                        <td colspan="5">
                            <table class="table1">
                                <tr>
                                    <td style="width: 98px;">
                                        <asp:CheckBox ID="chkHinhsu" runat="server" Text="Hình sự" /></td>
                                    <td style="width: 98px;">
                                        <asp:CheckBox ID="chkDansu" runat="server" Text="Dân sự" /></td>
                                    <td style="width: 150px;">
                                        <asp:CheckBox ID="chkHNGD" runat="server" Text="Hôn nhân & Gia đình" /></td>
                                    <td>
                                        <asp:CheckBox ID="chkKDTM" runat="server" Text="Kinh doanh thương mại" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chkLaodong" runat="server" Text="Lao động" /></td>
                                    <td>
                                        <asp:CheckBox ID="chkHanhchinh" runat="server" Text="Hành chính" /></td>
                                    <td>
                                        <asp:CheckBox ID="chkPhasan" runat="server" Text="Phá sản" /></td>
                                    <td>
                                        <asp:CheckBox ID="chkXLHC" runat="server" Text="Biện pháp xử lý hành chính" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <asp:Button ID="cmdXem" runat="server" CssClass="buttoninput" Text="Xem báo cáo" OnClick="cmdXem_Click" OnClientClick="return kiemtra();" />
                        </td>
                    </tr>
                </table>
                <rsweb:ReportViewer ID="ReportViewer1" runat="server" PageCountMode="Actual" AsyncRendering="false" Enabled="True" Visible="True"
                    EnableViewState="True"
                    ShowWaitControlCancelLink="False"
                    ShowBackButton="False"
                    ShowCredentialPrompts="False" ShowParameterPrompts="False"
                    ShowDocumentMapButton="false" ShowExportControls="true" ShowFindControls="False"
                    ShowPageNavigationControls="true" ShowPrintButton="true"
                    ShowPromptAreaButton="False" ShowRefreshButton="true" ShowToolBar="true" Width="100%" Height="1400px"
                    ShowZoomControl="False">
                </rsweb:ReportViewer>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function kiemtra() {
            var txtNgaySinh = document.getElementById('<%=txtNgaySinh.ClientID%>');
            if (txtNgaySinh.value.trim().length > 0) {
                var arr = txtNgaySinh.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).');
                    txtNgaySinh.focus();
                    return false;
                }
            }
            var txtNgayNhanCT = document.getElementById('<%=txtNgayNhanCT.ClientID%>');
            if (txtNgayNhanCT.value.trim().length > 0) {
                var arr = txtNgayNhanCT.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày nhận công tác theo định dạng (dd/MM/yyyy).');
                    txtNgayNhanCT.focus();
                    return false;
                }
            }
            var txtNgayBoNhiem = document.getElementById('<%=txtNgayBoNhiem.ClientID%>');
            if (txtNgayBoNhiem.value.trim().length > 0) {
                var arr = txtNgayBoNhiem.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày bổ nhiệm theo định dạng (dd/MM/yyyy).');
                    txtNgayBoNhiem.focus();
                    return false;
                }
            }
            var txtNgayKetThuc = document.getElementById('<%=txtNgayKetThuc.ClientID%>');
            if (txtNgayKetThuc.value.trim().length > 0) {
                var arr = txtNgayKetThuc.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày kết thúc theo định dạng (dd/MM/yyyy).');
                    txtNgayKetThuc.focus();
                    return false;
                }
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
