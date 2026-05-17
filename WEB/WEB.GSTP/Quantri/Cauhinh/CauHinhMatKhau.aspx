<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
CodeBehind="CauHinhMatKhau.aspx.cs" Inherits="WEB.GSTP.Quantri.Cauhinh.CauHinhMatKhau" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 303px;"><b>1. Độ dài tối thiểu của mật khẩu</b>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDoDaiToiThieu" CssClass="user" runat="server" Width="3%" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>2. Phải có chữ hoa</b></td>
                        <td>
                            <asp:CheckBox ID="chkPhaiCoChuHoa" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>3. Phải có chữ thường</b></td>
                        <td>
                            <asp:CheckBox ID="txtPhaiCoChuThuong" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>4. Phải có số</b></td>
                        <td>
                            <asp:CheckBox ID="chkPhaiCoSo" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>5. Phải có ký tự đặc biệt</b></td>
                        <td>
                            <asp:CheckBox ID="chkPhaiCoKyTuDacBiet" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>6. Không chứa tên tài khoản</b></td>
                        <td>
                            <asp:CheckBox ID="chkKhongChuaTenTaiKhoan" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>7. Không chứa tên người sử dụng</b></td>
                        <td>
                            <asp:CheckBox ID="chkKhongChuaHoTen" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>8. Không chứa số điện thoại</b></td>
                        <td>
                            <asp:CheckBox ID="chkKhongChuaSoDienThoai" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>9. Không chứa chuỗi “ngày”+”tháng”+”năm sinh” (DDMMYYYY hoặc DDMMYY)</b></td>
                        <td>
                            <asp:CheckBox ID="chkKhongChuaNamSinh" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>10. Số lần đăng nhập sai liên tiếp sẽ khóa tài khoản</b></td>
                        <td>
                            <asp:TextBox ID="txtSoLanDangNhapSai" CssClass="user" runat="server" Width="3%" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>11. Thời gian yêu cầu phải thay đổi mật khẩu (tháng)</b></td>
                        <td>
                            <asp:TextBox ID="txtThoiGianYeuCauThayDoiMK" CssClass="user" runat="server" Width="3%" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>12. Mật khẩu mới không trùng với mật khẩu cũ</b></td>
                        <td>
                            <asp:CheckBox ID="chkTrungMatKhau" class="check" Text="" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Cập nhật"
                                OnClick="btnUpdate_Click" OnClientClick="return Validate()" />
                            <%--<asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput"
                                Text="Làm mới" OnClick="btnLammoi_Click" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hddmatkhau" Value="0" runat="server" />
    <script>
       <%-- function Validate() {
            var txtMa = document.getElementById('<%=txtMa.ClientID%>');
            if (!Common_CheckEmpty(txtMa.value)) {
                alert('Bạn chưa nhập mã cấu hình. Hãy kiểm tra lại!');
                txtMa.focus();
                return false;
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên cấu hình. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }

            //Thông tin tài khoản
            //--------------------
            var txtEmail = document.getElementById('<%=txtEmail.ClientID%>');
            if (txtEmail.value.trim() != "") {
                if (!Common_ValidateEmail(txtEmail.value)) {
                    txtEmail.focus();
                    return false;
                }
            }
            return true;
        }--%>
    </script>
</asp:Content>
