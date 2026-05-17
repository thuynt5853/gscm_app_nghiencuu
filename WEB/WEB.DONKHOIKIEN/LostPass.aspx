<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master"
    AutoEventWireup="true" CodeBehind="LostPass.aspx.cs" Inherits="WEB.DONKHOIKIEN.LostPass" %>


<%@ Register Src="~/UserControl/Home_HuongDan.ascx" TagPrefix="uc1" TagName="Home_HuongDan" %>
<%@ Register Src="~/UserControl/Home_ThongBao.ascx" TagPrefix="uc1" TagName="Home_ThongBao" %>
<%@ Register Src="~/UserControl/HuongDan.ascx" TagPrefix="uc1" TagName="HuongDan" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="UI/js/Common.js"></script>
    <style type="text/css">
        .guidonkien_head {
            display: none;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="content_center">
        <div class="content_form">
            <div class="hosoleft">
                <uc1:HuongDan runat="server" ID="HuongDan" />
            </div>
            
            <div class="hosoright">
                <div class="thongtin_lienhe" style="box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                    <div class="dangky_head border_radius_top">
                        <div class="dangky_head_title">Quên thông tin tài khoản</div>
                        <div class="dangky_head_right"></div>
                    </div>
                    <div class="dangky_content">
                        <asp:Panel ID="pn" runat="server">
                        <table style="margin-left:180px;">
                            <tr>
                                <td>Email<span class="batbuoc">*</span></td>
                                <td>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="dangky_tk_textbox"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Số CMND<span class="batbuoc">*</span></td>
                                <td>
                                    <asp:TextBox ID="txtCMND" runat="server" CssClass="dangky_tk_textbox"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Mã xác nhận<span class="batbuoc">*</span></td>
                                <td>
                                    <asp:TextBox ID="txtMaCapCha" runat="server" CssClass="dangky_tt_textbox"
                                        Width="110px" MaxLength="10"></asp:TextBox>
                                    <asp:Image ID="imgCaptCha" runat="server" CssClass="capcha_code" />
                                    <asp:HiddenField ID="hddcapcha" runat="server" Value="" />
                                    <asp:ImageButton ID="cmdRefreshCode" runat="server"
                                        Width="30px" Height="30px" CssClass="refresh_capcha"
                                        ImageUrl="/UI/img/refresh.png" OnClick="cmdRefreshCode_Click" />
                                </td>
                            </tr>
                             <tr>
                                <td colspan="2" style="height: 10px;"></td></tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="cmdSend" runat="server" CssClass="button" Text="Gửi lại mật khẩu"
                                        OnClientClick="return validate();" OnClick="cmdSend_Click" width="100%"/></td>
                            </tr>
                        </table>
                        </asp:Panel>
                        <div style="float: left; width: 100%;">
                            <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!------------------------------------->
    <uc1:Home_HuongDan runat="server" ID="Home_HuongDan" />
    <!------------------------------------->
    <div class="content_info_main">
        <uc1:Home_ThongBao runat="server" ID="Home_ThongBao" />
    </div>
    <script>
        function validate()
        {
            var txtEmail = document.getElementById('<%=txtEmail.ClientID%>');
            if (!Common_CheckEmpty(txtEmail.value)) {
                alert('Bạn chưa nhập địa chỉ "Email". Địa chỉ email này được dùng để đăng nhập hệ thống và nhận lại mật khẩu. Hãy kiểm tra lại!');
                txtEmail.focus();
                return false;
            } else {
                if (!Common_ValidateEmail(txtEmail.value)) {
                    txtEmail.focus();
                    return false;
                }
            }
            //--------------------
            var txtCMND = document.getElementById('<%=txtCMND.ClientID%>');
            if (!Common_CheckEmpty(txtCMND.value)) {
                alert('Bạn chưa nhập "Số CMND". Số CMND này được cập nhật khi đăng ký tài khoản. Hãy kiểm tra lại!');
                txtCMND.focus();
                return false;
            }
            //--------------------
            var txtMaCapCha = document.getElementById('<%=txtMaCapCha.ClientID%>');
            if (!Common_CheckEmpty(txtMaCapCha.value)) {
                alert('Bạn chưa nhập mã xác nhận. Hãy kiểm tra lại!');
                txtMaCapCha.focus();
                return false;
            }
            return true;
        }
    </script>


    <script type="text/javascript">

        function getIMG() {
            $.post("/Ajax/GetCaptCha.ashx", { oldcaptcha: $('#<%=hddcapcha.ClientID %>').val() }, function (data) {
                var reVal = data;
                $('#<%=hddcapcha.ClientID %>').val(reVal);
                $('#<%=imgCaptCha.ClientID %>').attr('src', '/Ajax/ImagesCaptcha.ashx?ImageText=' + reVal);
            });
            $('#<%=txtMaCapCha.ClientID %>').val('');
        }

        $(document).ready(function () {

            $.post("/Ajax/GetCaptCha.ashx", { oldcaptcha: $('#<%=hddcapcha.ClientID %>').val() }, function (data1) {

                var reVal = data1;
                $('#<%=hddcapcha.ClientID %>').val(reVal);
            $('#<%=imgCaptCha.ClientID %>').attr('src', '/Ajax/ImagesCaptcha.ashx?ImageText=' + reVal);
            });
            $('#<%=txtMaCapCha.ClientID %>').val('');
        });
      <%--  $(document).ready(function () {
            $('input[type=text]').on('keypress', function (e) {
                if (e.which == 13)
                    $("#<%= cmdSearch.ClientID %>").click();
           });
        }); --%>
</script>
</asp:Content>

