<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Capnhat.aspx.cs" Inherits="WEB.GSTP.Quantri.Nguoidung.Capnhat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 130px;" align="left">Đơn vị<asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td align="left" colspan="3">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlDonvi" runat="server" Width="522px" AutoPostBack="True" OnTextChanged="ddlDonvi_TextChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">Nhóm quyền<asp:Label runat="server" ID="Label3" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td align="left" colspan="3">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlNhomquyen" runat="server" Width="522px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">Đơn vị trực thuộc
                        </td>
                        <td align="left" colspan="3">
                            <asp:DropDownList AutoPostBack="true" OnSelectedIndexChanged="ddlPhongban_SelectedIndexChanged" CssClass="chosen-select" ID="ddlPhongban" runat="server" Width="522px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">Phòng ban
                        </td>
                        <td align="left" colspan="3">
                            <asp:DropDownList AutoPostBack="true" OnSelectedIndexChanged="ddlPhongban_sub_SelectedIndexChanged" CssClass="chosen-select" ID="ddlPhongban_sub" runat="server" Width="522px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">Tài khoản
                        <asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td style="width: 200px;" align="left">
                            <asp:TextBox ID="txtUsername" CssClass="user" runat="server" Width="95%" MaxLength="100"></asp:TextBox>
                        </td>
                        <td colspan="2">
                            <asp:CheckBox ID="chkIsDomain" runat="server" Text="Là tài khoản domain ?" AutoPostBack="True" OnCheckedChanged="chkIsDomain_CheckedChanged" />
                        </td>
                    </tr>
                    <tr>
                        <td>Mật khẩu</td>
                        <td>
                            <asp:TextBox ID="txtPass" CssClass="user" TextMode="Password" runat="server" Width="95%" MaxLength="100"></asp:TextBox>
                        </td>
                        <td style="width: 100px;" align="left">Nhập lại mật khẩu
                        </td>
                        <td>
                            <asp:TextBox ID="txtRePass" CssClass="user" TextMode="Password" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">Họ và tên    
                            <asp:Label runat="server" ID="Label4" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCanbo" CssClass="chosen-select" runat="server" Width="195px">
                            </asp:DropDownList>
                        </td>
                        <td>Điện thoại
                        </td>
                        <td>
                            <asp:TextBox ID="txtDienthoai" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 150px;" align="left">Mức độ quyền
                        </td>
                        <td align="left">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlLoaiNhom" runat="server" Width="125px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Email
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtEmail" CssClass="user" runat="server" Width="95%" MaxLength="250"></asp:TextBox>
                        </td>

                        <td>Biệt danh
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 150px;" align="left">Phân loại đơn khởi kiện trực tuyến
                        </td>
                        <td align="left">
                            <asp:CheckBox ID="chkIsPhanloaidon" runat="server" />
                        </td>
                        <td align="left" colspan="2">
                            <asp:CheckBox ID="chkHieuluc" runat="server" Text="Hiệu lực" />
                        </td>
                    </tr>

                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return kiemtra();" />

                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lblquaylai_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script>        
        function kiemtra() {
            var ddlDonvi = document.getElementById('<%=ddlDonvi.ClientID%>');
            var value_change = ddlDonvi.options[ddlDonvi.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn đơn vị !');
                ddlDonvi.focus();
                return false;
            }

            var txtUsername = document.getElementById('<%=txtUsername.ClientID %>');
            if (!Common_CheckEmpty(txtUsername.value)) {
                alert('Chưa nhập tài khoản đăng nhập!');
                txtUsername.focus();
                return false;
            }

            var ddlCanbo = document.getElementById('<%=ddlCanbo.ClientID%>');
            value_change = ddlCanbo.options[ddlCanbo.selectedIndex].value;
            if (value_change == "0") {
                alert('Chưa chọn cán bộ sử dụng tài khoản!');
                ddlCanbo.focus();
                return false;
            }

            var txtEmailControl = document.getElementById('<%=txtEmail.ClientID %>');
            if (Common_CheckEmpty(txtEmailControl.value)) {
                var email_string = txtEmailControl.value;
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(email_string) && email_string.trim() != '') {
                    alert('Bạn phải nhập Email hợp lệ. \n VD: Example@gmail.com');
                    txtEmailControl.focus;
                    return false;
                }
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
