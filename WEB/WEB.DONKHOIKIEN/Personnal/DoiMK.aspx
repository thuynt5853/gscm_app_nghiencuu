<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true"
    CodeBehind="DoiMK.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.DoiMK" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .border_content {
            border: 1px solid #eee;
        }

        .dk_fullwidth {
            border-bottom: 1px solid #eee;
        }
    </style>
    <div class="thongtin_lienhe" style="margin-top: 0px;">
        <div class="right_full_width_head">
            <div class="dangky_head_title">Cập nhật mật khẩu</div>
            <div class="dangky_head_right">
            </div>
        </div>
        <div style="float: left; width: 60%; margin-left: 20%; padding:20px 0px; ">
            
            <div class="border_content">
                <div class="dk_fullwidth">
                    <div class="dk_item">
                        <span>Email </span><span class="batbuoc">*</span>
                        <asp:TextBox ID="txtEMAIL" runat="server" Enabled ="false"
                            CssClass="dangky_tk_textbox"></asp:TextBox>
                    </div>
                </div>
                <div class="dk_fullwidth">
                    <div class="dk_item">
                        <span>Mật khẩu cũ</span><span class="batbuoc">*</span>
                        <asp:TextBox ID="txtOldPass" runat="server" TextMode="Password"
                            CssClass="dangky_tk_textbox"></asp:TextBox>
                    </div>
                </div>
                <div class="dk_fullwidth">
                    <div class="dk_item border_right" style="width: 48.5%; float: left;">
                        <span>Mật khẩu mới</span><span class="batbuoc">*</span>
                        <asp:TextBox ID="txtPASSWORD" runat="server"
                            CssClass="dangky_tk_textbox" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="dk_item" style="float: right; width: 48.5%;">
                        <span>Nhập lại mật khẩu mới</span><span class="batbuoc">*</span>
                        <asp:TextBox ID="txtREPASSWORD" runat="server" TextMode="Password"
                            CssClass="dangky_tk_textbox"></asp:TextBox>
                    </div>
                </div>

                <div class="fullwidth" style="text-align: center;">
                    <div class="msg_thongbao">
                        <asp:Literal runat="server" ID="lbthongbao"></asp:Literal></div>
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput bg_do"
                        Text="Cập nhật" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                </div>
            </div>
        </div>
    </div>
    <script>
        function validate() {
            //--------------------
            var txtEmail = document.getElementById('<%=txtEMAIL.ClientID%>');
              if (!Common_CheckEmpty(txtEmail.value)) {
                  alert('Bạn chưa nhập "Địa chỉ email". Hãy kiểm tra lại!');
                  txtEmail.focus();
                  return false;
              }
              else {
                  if (!Common_ValidateEmail(txtEmail.value)) {
                      txtEmail.focus();
                      return false;
                  }
              }

              //--------------------
              var txtOldPass = document.getElementById('<%=txtOldPass.ClientID%>');
              if (!Common_CheckEmpty(txtOldPass.value)) {
                  alert('Bạn chưa nhập "Mật khẩu cũ". Hãy kiểm tra lại!');
                  txtOldPass.focus();
                  return false;
              }
              //--------------------
              var txtPass = document.getElementById('<%=txtPASSWORD.ClientID%>');
              if (!Common_CheckEmpty(txtPass.value)) {
                  alert('Bạn chưa nhập "Mật khẩu mới". Hãy kiểm tra lại!');
                  txtPass.focus();
                  return false;
              }

              //--------------------
              var txtRePass = document.getElementById('<%=txtREPASSWORD.ClientID%>');
            if (!Common_CheckEmpty(txtRePass.value)) {
                alert('Bạn chưa nhập mục "Nhập lại mật khẩu mới". Hãy kiểm tra lại!');
                txtRePass.focus();
                return false;
            }

            if (txtPass.value != txtRePass.value) {
                alert('Bạn nhập mục "Nhập lại mật khẩu mới" chưa khớp với "Mật khẩu mới". Hãy kiểm tra lại!');
                txtRePass.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
