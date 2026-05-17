<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true" CodeBehind="ThongBao.aspx.cs" Inherits="WEB.DONKHOIKIEN.ThongBao" %>

<%@ Register Src="~/UserControl/Home_HuongDan.ascx" TagPrefix="uc1" TagName="Home_HuongDan" %>
<%@ Register Src="~/UserControl/Home_ThongBao.ascx" TagPrefix="uc1" TagName="Home_ThongBao" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        

        .content_form {
            margin-top: 0px;
        }

        .dangky_head {
             box-shadow: 1px 78px 10px -77px #c30f12 inset;
        }
    </style>
   <div class="content_center">
        <div class="dangky_tk" style="box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
            <div class="dangky_head border_radius_top">
                <div class="dangky_head_title">Thông báo</div>
                <div class="dangky_head_right"></div>
            </div>
            <div class="dangky_content">
                <div style="float:left; width:100%; ">
                <asp:Literal ID="ltt" runat="server"></asp:Literal></div>
            </div>
        </div>
  </div>
    <uc1:Home_HuongDan runat="server" ID="Home_HuongDan" />
    <div class="content_info_main">
        <uc1:Home_ThongBao runat="server" ID="Home_ThongBao" />
    </div>
      
</asp:Content>

