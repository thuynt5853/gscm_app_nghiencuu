<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Capnhat.aspx.cs"
    Inherits="WEB.GSTP.QTCucTHA.User.Capnhat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 130px;" align="left">Đơn vị<asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td align="left" colspan="3">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlDonvi" runat="server" Width="500px" AutoPostBack="True" OnTextChanged="ddlDonvi_TextChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">Nhóm quyền<asp:Label runat="server" ID="Label3" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td align="left" colspan="3">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlNhomquyen" runat="server" Width="500px">
                            </asp:DropDownList>
                        </td>
                    </tr>

                    <tr>
                        <td align="left">Mã truy cập
                        <asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td style="width: 200px;" align="left">
                            <asp:TextBox ID="txtUsername" CssClass="user" runat="server" Width="95%" MaxLength="100"></asp:TextBox>
                        </td>
                        <td colspan="2">
                            <div style="display: none;">
                                <asp:CheckBox ID="chkIsDomain" runat="server" Text="Là tài khoản domain ?" AutoPostBack="True" OnCheckedChanged="chkIsDomain_CheckedChanged" />
                            </div>
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
                            <%-- <asp:DropDownList ID="ddlCanbo" CssClass="chosen-select" runat="server" Width="195px">
                            </asp:DropDownList>--%>
                            <asp:TextBox ID="txtCanb" CssClass="user" runat="server" Width="200px" MaxLength="250"></asp:TextBox>
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
                    <tr style="display: none;">
                        <td align="left">Phòng ban
                        </td>
                        <td align="left" colspan="3">
                            <div >
                                <asp:DropDownList CssClass="chosen-select" ID="ddlPhongban" runat="server" Width="500px">
                                </asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td style="width: 150px;" align="left">Phân loại đơn khởi kiện trực tuyến
                        </td>
                        <td align="left" colspan="3">
                            <asp:CheckBox ID="chkIsPhanloaidon" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 150px;" align="left">
                            <b>Hiệu lực</b>
                        </td>
                        <td align="left" colspan="3">
                            <asp:CheckBox ID="chkHieuluc" runat="server" Checked="true" />
                        </td>
                    </tr>
                    <tr>
                    </tr>

                    <tr>
                        <td colspan="4">&nbsp;
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
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return kiemtra()" />

                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lblquaylai_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script language="javascript" type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
        function kiemtra() {
            var txtUsername = document.getElementById('<%=txtUsername.ClientID %>');
            var txtEmailControl = document.getElementById('<%=txtEmail.ClientID %>');

            var txtUsername = document.getElementById('<%=txtUsername.ClientID %>');
        if (txtUsername.value.trim() == "" || txtUsername.value.trim() == null) {
            alert('chưa nhập mã truy cập !');
            txtUsername.focus();
            return false;
        }
        if (txtHoten.value.trim() == "" || txtHoten.value.trim() == null) {
            alert('chưa nhập họ và tên !');
            txtHoten.focus();
            return false;
        }
        if (dropdonvi.value == "0") {
            alert('Bạn chưa chọn đơn vị !');
            return false;
        }

        var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;


        if (!filter.test(txtEmailControl.value) && txtEmailControl.value.trim() != '') {
            alert('Bạn phải nhập Email hợp lệ. \nExample@gmail.com');
            txtEmailControl.focus; return false;
        }
        return true;
        }
    </script>
</asp:Content>
