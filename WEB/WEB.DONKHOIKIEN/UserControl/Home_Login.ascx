<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Home_Login.ascx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.Home_Login" %>

<div class="bound_login">
   <style>
       .csscaptcha
       {
           position:absolute;
           margin-left: 8px;
       }
       .cssrefresh
       {
           position: absolute;
            right: 10px;
            top: 15px;
            width: 20px;
       }
   </style>
    <div class="login">
        <div class="login_header">
            <asp:Literal ID="lttHeader" runat="server"></asp:Literal>
        </div>
        <div class="login_content">
          
            <asp:Panel ID="pnLogin" runat="server">
                <asp:TextBox ID="txtUserName" runat="server"
                    placeholder="Tên truy cập" CssClass="textbox_login" Width="95%" />
                <asp:TextBox ID="txtPass" runat="server" placeholder="Mật khẩu" CssClass="textbox_login" Width="95%" TextMode="Password" />
                <div class="forgetpass" style="display: none;">
                    <div class="checkbox">
                        <asp:CheckBox ID="chkRememPass" runat="server" Text="Ghi nhớ mật khẩu" />
                    </div>
                    <span class="line">|</span>
                    <%--<span class="lost_pass"><a href="LostPass.aspx">Quên mật khẩu</a></span>--%>
                </div>
                <div style="position:relative">
                    <asp:TextBox ID="txtCaptcha" runat="server"
                    placeholder="Nhập mã xác thực" CssClass="textbox_login" Width="40%" />
                    <asp:Image ID="imCaptcha" ImageUrl="" CssClass="csscaptcha" runat="server" />
                    <asp:ImageButton CssClass="cssrefresh" OnClick="cmdRefresh_Click" ImageUrl="~/UI/img/ico2.png" runat="server" />
                </div>
                <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                <div class="dangnhap">
                    <asp:Button ID="cmdLogin" runat="server" 
                        CssClass="dangnhap_btn" Text="Đăng nhập"
                        OnClientClick="return CheckLogin();" OnClick="cmdLogin_Click" />
                </div>
            </asp:Panel>

            <div class="dangky">
                <div style="text-align: center; float: left; margin-left: 10%;">
                    <%--Bạn chưa có tài khoản?--%>
                    <span class="lost_pass" style="float: left;">
                        <a href="LostPass.aspx">Quên mật khẩu</a></span>
                    <span class="line">|</span>
                    <span><a href="DangKy.aspx">Đăng ký</a></span>
                </div>
            </div>

            <asp:Panel ID="pnHelp" runat="server" Visible="false">
            <div style="float: left; width: 100%; margin-top:5px;">
                <div class="helpcontent">
                    <b class="helpcontent_title"><a href="javascript:;">Hướng dẫn:</a></b>
                    <p>Nhập tên truy cập, mật khẩu đã đăng ký tài khoản trong hệ thống. Bấm chọn nút "Đăng nhập" để tiến hành đăng nhập vào hệ thống</p>
                </div>
            </div></asp:Panel>
        </div>
    </div>


</div>
<script type="text/javascript">
    $(document).ready(function () {
        $('input[type=text]').on('keypress', function (e) {
            if (e.which == 13) {
                if (CheckLogin())
                    $("#<%= cmdLogin.ClientID %>").click();
            }
        });
    });
</script>
<script>
    function CheckLogin() {
        var txtUserName = document.getElementById('<%= txtUserName.ClientID%>');
        var txtPass = document.getElementById('<%= txtPass.ClientID%>');
        var txtCaptcha = document.getElementById('<%= txtCaptcha.ClientID%>');
        if (!Common_CheckEmpty(txtUserName.value)) {
            alert('Bạn chưa nhập tên truy cập! Hãy kiểm tra lại');
            txtUserName.focus();
            return false;
        }
        if (!Common_CheckEmpty(txtPass.value)) {
            alert('Bạn chưa nhập mật khẩu! Hãy kiểm tra lại');
            txtPass.focus();
            return false;
        }
        if (!Common_CheckEmpty(txtCaptcha.value)) {
            alert('Bạn chưa nhập mã xác thực! Hãy kiểm tra lại');
            txtCaptcha.focus();
            return false;
        }
        return true;
    }

</script>
