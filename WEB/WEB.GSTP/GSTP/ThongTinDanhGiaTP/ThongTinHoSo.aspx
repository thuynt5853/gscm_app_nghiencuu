<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongTinHoSo.aspx.cs" Inherits="WEB.GSTP.GSTP.ThongTinDanhGiaTP.ThongTinHoSo" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 175px;"><b>Thẩm phán tự đánh giá<span class="batbuoc">(*)</span></b></td>
                            <td>
                                <asp:TextBox ID="txtDanhGia_TP" runat="server" CssClass="user" Width="99%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="border_buttom">
                            <td><b>Ủy ban thẩm phán đánh giá<span class="batbuoc">(*)</span></b></td>
                            <td>
                                <asp:TextBox ID="txtDanhGia_UBTP" runat="server" CssClass="user" Width="99%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Button ID="cmdCapNhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return CheckUpdate();" OnClick="cmdCapNhat_Click" />
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Label runat="server" ID="lbthongbaoUpdate" ForeColor="Red"></asp:Label></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function CheckUpdate() {
            var txtDanhGia_TP = document.getElementById('<%=txtDanhGia_TP.ClientID%>');
            var LengthDanhGia_TP = txtDanhGia_TP.value.trim().length;
            if (LengthDanhGia_TP == 0) {
                alert('Bạn chưa nhập nội dung đánh giá. Hãy nhập lại!');
                txtDanhGia_TP.focus();
                return false;
            } else if (LengthDanhGia_TP > 1000) {
                alert('Không nhập nội dung đánh giá quá 1000 ký tự. Hãy nhập lại!');
                txtDanhGia_TP.focus();
                return false;
            }
            var txtDanhGia_UBTP = document.getElementById('<%=txtDanhGia_UBTP.ClientID%>');
            var LengthDanhGia_UBTP = txtDanhGia_UBTP.value.trim().length;
            if (LengthDanhGia_UBTP == 0) {
                alert('Bạn chưa nhập nội dung đánh giá. Hãy nhập lại!');
                txtDanhGia_UBTP.focus();
                return false;
            } else if (LengthDanhGia_UBTP > 1000) {
                alert('Không nhập nội dung đánh giá quá 1000 ký tự. Hãy nhập lại!');
                txtDanhGia_UBTP.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
