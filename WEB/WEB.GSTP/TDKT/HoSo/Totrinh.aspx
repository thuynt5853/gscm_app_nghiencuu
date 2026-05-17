<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Totrinh.aspx.cs" Inherits="WEB.GSTP.TDKT.HoSo.Totrinh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        .msg_error {
            text-align: left !important;
        }

        .box {
            padding-bottom: 0px !important;
        }

        .HoSo_ToTrinh_Col1 {
            width: 94px;
        }

        .HoSo_ToTrinh_Col2 {
            width: 224px;
        }

        .HoSo_ToTrinh_Col3 {
            width: 65px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="HddPageSize" Value="20" runat="server" />
    <asp:HiddenField ID="HdfVuTDKT" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td><b>Đơn vị đề nghị</b></td>
                        <td colspan="3">
                            <asp:DropDownList ID="DropDonVi_DeNghi" Width="411px" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropDonVi_DeNghi_SelectedIndexChanged"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="HoSo_ToTrinh_Col1"><b>Đơn vị cấp trên</b></td>
                        <td colspan="3">
                            <asp:DropDownList ID="DropDonVi_CapTren" Width="411px" runat="server" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="HoSo_ToTrinh_Col1"><b>Số tờ trình<span style="color: red;"> (*)</span></b></td>
                        <td class="HoSo_ToTrinh_Col2">
                            <asp:TextBox ID="TxtSoToTrinh" runat="server" CssClass="user" Width="200px" MaxLength="100"></asp:TextBox></td>
                        <td class="HoSo_ToTrinh_Col3"><b>Ngày trình</b></td>
                        <td>
                            <asp:TextBox ID="TxtNgayTrinh" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TxtNgayTrinh" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="TxtNgayTrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Về việc<span style="color: red;"> (*)</span></b></td>
                        <td colspan="3">
                            <asp:TextBox ID="TxtVeViec" runat="server" CssClass="user" Width="403px" MaxLength="500"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Người ký</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="TxtNguoiKy" runat="server" CssClass="user" Width="403px" MaxLength="250"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="BtnLuu_Click" />
                            <asp:Button ID="BtnXoa" runat="server" CssClass="buttoninput" Visible="false" Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa tờ trình này? ');" OnClick="BtnXoa_Click" />
                            <asp:Button ID="BtnQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="BtnQuayLai_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Label runat="server" ID="Lblthongbao" Style="color: red;"></asp:Label></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function Validate() {
            var TxtSoToTrinh = document.getElementById('<%=TxtSoToTrinh.ClientID%>');
            var Length = TxtSoToTrinh.value.trim().length;
            if (Length == 0) {
                alert('Số tờ trình không được để trống. Hãy nhập lại.');
                TxtSoToTrinh.focus();
                return false;
            } else if (Length > 100) {
                alert('Số tờ trình không được quá 100 ký tự. Hãy nhập lại.');
                TxtSoToTrinh.focus();
                return false;
            }
            var TxtNgayTrinh = document.getElementById('<%=TxtNgayTrinh.ClientID%>');
            Length = TxtNgayTrinh.value.trim().length;
            if (Length > 0) {
                if (!Common_IsTrueDate(TxtNgayTrinh.value)) {
                    TxtNgayTrinh.focus();
                    return false;
                }
                var now = new Date();
                var temp = TxtNgayTrinh.value.split('/');
                var DateTemp = new Date(temp[2], temp[1] - 1, temp[0]);
                if (now < DateTemp) {
                    alert('Ngày trình phải nhỏ hơn hoặc bằng ngày hiện tại!');
                    TxtNgayTrinh.focus();
                    return false;
                }
            }
            var TxtVeViec = document.getElementById('<%=TxtVeViec.ClientID%>');
            Length = TxtVeViec.value.trim().length;
            if (Length == 0) {
                alert('Về việc không được để trống. Hãy nhập lại.');
                TxtVeViec.focus();
                return false;
            } else if (Length > 500) {
                alert('Về việc không được quá 500 ký tự. Hãy nhập lại.');
                TxtVeViec.focus();
                return false;
            }
            var TxtNguoiKy = document.getElementById('<%=TxtNguoiKy.ClientID%>');
            Length = TxtNguoiKy.value.trim().length;
            if (Length > 250) {
                alert('Người ký không quá 250 ký tự. Hãy nhập lại.');
                TxtNguoiKy.focus();
                return false;
            }
        }
    </script>
</asp:Content>
