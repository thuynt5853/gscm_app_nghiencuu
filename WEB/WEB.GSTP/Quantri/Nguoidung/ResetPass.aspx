<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ResetPass.aspx.cs" Inherits="WEB.GSTP.Quantri.Nguoidung.ResetPass" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <div class="box">  
    <div class="box_nd">
        <div class="truong">
              <asp:HiddenField ID="hddID" runat="server" /><br />
     
        <table class="table1" style="margin: 0 auto; width: 65%;">
            <tbody>
                <tr>
                    <td class='cell_label' style="width: 120px;">Tài khoản</td>
                    <td>
                        <asp:TextBox ID="txtUserName" runat="server" Enabled="false" CssClass="user" Width="250px"></asp:TextBox><span style="color: Red; font-style: italic;">(*)</span>
                    </td>
                </tr>
                <tr>
                    <td class='cell_label' style="width: 120px;">Mật khẩu</td>
                    <td>
                        <asp:TextBox ID="txtPass" runat="server" TextMode="Password" CssClass="user" Width="250px"></asp:TextBox><span style="color: Red; font-style: italic;">(*)</span>
                    </td>
                </tr>
                <tr>
                    <td class='cell_label' style="width: 120px;">Nhập lại mật khẩu</td>
                    <td>
                        <asp:TextBox ID="txtRepass" runat="server" TextMode="Password" CssClass="user" Width="250px"></asp:TextBox><span style="color: Red; font-style: italic;">(*)</span>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <p style="color: red;">
                            <asp:Literal ID="lttMsg" runat="server"></asp:Literal></p>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput" Text="Lưu" 
						OnClick="cmdSave_Click" OnClientClick="return Validate();" />
                        <asp:Button ID="cmdBack" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdBack_Click" />

                    </td>
                </tr>
            </tbody>
        </table>
    </div>
   <script type="text/javascript">
       function Validate() {
			var txtPass = document.getElementById('<%=txtPass.ClientID%>');            
            if (!Common_CheckEmpty(txtPass.value)) {
                alert('Bạn chưa nhập mật khẩu !');
                txtPass.focus();
                return false;
            }
            
                var pass = document.getElementById('<%=txtPass.ClientID%>').value;
                if (pass.length < 6) {
                    alert('Mật khẩu tối thiểu 6 ký tự !');
                    txtPass.focus();
                    return false;
                } else if (pass.length > 100) {
                        alert('Mật khẩu nhập quá 100 ký tự !');
                        txtPass.focus();
                        return false;
                    }
			//--------------------------------
			var txtRepass = document.getElementById('<%=txtRepass.ClientID%>');
			if (!Common_CheckEmpty(txtRepass.value)) {
                alert('Bạn chưa nhập phần "Nhập lại mật khẩu"!');
                txtRepass.focus();
                return false;
            }
			
            var repass = txtRepass.value;
            if (repass.length < 6) {
                alert('Mật khẩu tối thiểu 6 ký tự !');
                txtRepass.focus();
                return false;
            } else if (pass.length > 100) {
                    alert('Mật khẩu nhập quá 100 ký tự !');
                    txtRepass.focus();
                    return false;
            }
			//--------------------------------
            if (pass != repass) {
                alert('Nhập lại mật không chính xác !');
                txtPass.focus();
                return false;
            }
			return true;
       }
    </script>
                </div>
    </div>

</asp:Content>
