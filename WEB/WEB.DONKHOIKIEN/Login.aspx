<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WEB.DONKHOIKIEN.Login" %>

<%@ Register Src="~/UserControl/Home_Login.ascx" TagPrefix="uc1" TagName="Home_Login" %>

<%@ Register Src="~/UserControl/Home_HuongDan.ascx" TagPrefix="uc1" TagName="Home_HuongDan" %>
<%@ Register Src="~/UserControl/Home_ThongBao.ascx" TagPrefix="uc1" TagName="Home_ThongBao" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content_gt">
        <div class="content_gt_center">
              <div class="content_gt_center_left">
                <b>Hệ thống gửi, nhận đơn khởi kiện,</b>
                <b>tài liệu, chứng cứ và cấp, tống đạt,</b>
                <b>thông báo văn bản tố tụng</b>
            </div>
            <div id="adangnhap" runat="server">
                <uc1:Home_Login runat="server" ID="Home_Login" />
            </div>
        </div>
    </div>
    <%-- manhnd bo huong dan tao tai khoan --%>
    <%--<uc1:Home_HuongDan runat="server" ID="Home_HuongDan" />--%>
    <!------------------------------------->
  

</asp:Content>
