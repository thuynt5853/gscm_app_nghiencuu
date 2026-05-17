<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WEB.GSTP.TDKT.HoSo.Edit" %>
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

        .HoSo_TDKT_Col1 {
            width: 80px;
        }
    </style>
    <asp:HiddenField ID="hddID" Value="0" runat="server" />
    <asp:HiddenField ID="HdfVuTDKT" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong" style="min-height: 735px; margin-bottom: 0px;">
                <table class="table1">
                    <tr>
                        <td><b>Đơn vị<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:DropDownList ID="DropToaAn" Width="526px" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="HoSo_TDKT_Col1"><b>Mã hồ sơ</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtMa" Width="518px" CssClass="user" MaxLength="100"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Tên hồ sơ<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtTen" Width="518px" CssClass="user" MaxLength="500"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Loại đề nghị</b></td>
                        <td>
                            <asp:DropDownList ID="DropLoaiDeNghi" Width="526px" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropLoaiDeNghi_SelectedIndexChanged">
                                <asp:ListItem Text="Thi đua" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Khen thưởng" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Kỷ luật" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Danh sách<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:DropDownList ID="DropDanhSach" Width="526px" runat="server" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="BtnLuu_Click" />
                            <asp:Button ID="BtnLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="BtnLamMoi_Click" />
                            <asp:Button ID="BtnQuayLai" runat="server" Style="margin-top: 10px;" CssClass="buttoninput" Text="Quay lại" OnClick="BtnQuayLai_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Label runat="server" ID="Lblthongbao" CssClass="msg_error"></asp:Label>
                        </td>
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
            var DropDonVi = document.getElementById('<%=DropToaAn.ClientID%>');
            var val = DropDonVi.options[DropDonVi.selectedIndex].value;
            if (val == 0) {
                alert('Chưa chọn đơn vị. Hãy chọn lại.');
                DropDonVi.focus();
                return false;
            }
            var TxtMa = document.getElementById('<%=TxtMa.ClientID%>');
            var Length = TxtMa.value.trim().length;
            if (Length > 100) {
                alert('Mã hồ sơ không được quá 100 ký tự. Hãy nhập lại.');
                TxtMa.focus();
                return false;
            }
            var TxtTen = document.getElementById('<%=TxtTen.ClientID%>');
            Length = TxtTen.value.trim().length;
            if (Length == 0) {
                alert('Tên hồ sơ không được để trống. Hãy nhập lại.');
                TxtTen.focus();
                return false;
            } else if (Length > 500) {
                alert('Tên hồ sơ không được quá 500 ký tự. Hãy nhập lại.');
                TxtTen.focus();
                return false;
            }
            var DropDanhSach = document.getElementById('<%=DropDanhSach.ClientID%>');
            val = DropDanhSach.options[DropDanhSach.selectedIndex].value;
            if (val == 0) {
                alert('Chưa chọn danh sách. Hãy chọn lại.');
                DropDanhSach.focus();
                return false;
            }
        }
    </script>
</asp:Content>
