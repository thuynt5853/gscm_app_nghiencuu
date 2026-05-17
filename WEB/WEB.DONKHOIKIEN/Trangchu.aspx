<%@ Page Async="true"  Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true" CodeBehind="Trangchu.aspx.cs" Inherits="WEB.DONKHOIKIEN.Trangchu" %>

<%@ Register Src="~/UserControl/Home_TraCuuHS.ascx" TagPrefix="uc1" TagName="Home_TraCuuHS" %>
<%@ Register Src="~/UserControl/Home_HuongDan.ascx" TagPrefix="uc1" TagName="Home_HuongDan" %>
<%@ Register Src="~/UserControl/Home_ThongBao.ascx" TagPrefix="uc1" TagName="Home_ThongBao" %>
<%@ Register Src="~/UserControl/Home_Login.ascx" TagPrefix="uc1" TagName="Home_Login" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        /*.content_body {
            background: url('UI/img/bg_content.png');
        }*/
    </style>
    <!--<uc1:Home_TraCuuHS runat="server" ID="Home_TraCuuHS" />-->
    <div class="content_gt">
        <div class="content_gt_center">
            <div class="content_gt_center_left">
                <b>Hệ thống gửi, nhận đơn khởi kiện,</b>
                <b>tài liệu, chứng cứ và cấp, tống đạt,</b>
                <b>thông báo văn bản tố tụng</b>
            </div>
            <div id="adangnhap" runat="server">
                <div id="login_form" style="display:none;">
                    <uc1:Home_Login runat="server" ID="Home_Login" /></div>
               
                <div class="content_gt_center_right" id="form_login_lk">
                    <a class="aDangnhap" href="Login.aspx">Đăng nhập</a>
                    <a class="aDangky" href="DangKy.aspx">
                        <div class="divDangkyopacity"></div>
                        <div class="divDangky">Đăng ký</div>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!------------------------------------->
    <uc1:Home_HuongDan runat="server" ID="Home_HuongDan" />
    <!------------------------------------->
    <%--<div class="content_info_main">
        <uc1:Home_ThongBao runat="server" ID="Home_ThongBao" />
    </div>--%>
    <asp:HiddenField ID="hddStatus" runat="server" Value="0" />
</asp:Content>



