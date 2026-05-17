<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true" CodeBehind="ChiTietTin.aspx.cs" Inherits="WEB.DONKHOIKIEN.ChiTietTin" %>

<%@ Register Src="~/UserControl/MenuTin.ascx" TagPrefix="uc1" TagName="MenuTin" %>
<%@ Register Src="~/UserControl/HuongDan.ascx" TagPrefix="uc1" TagName="HuongDan" %>
<%@ Register Src="~/UserControl/Home_HuongDan.ascx" TagPrefix="uc1" TagName="Home_HuongDan" %>
<%@ Register Src="~/UserControl/Home_ThongBao.ascx" TagPrefix="uc1" TagName="Home_ThongBao" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content_center">
        <div class="content_form">
            <div class="hosoleft">
                <uc1:HuongDan runat="server" ID="HuongDan" />
            </div>
            <div class="hosoright">
                <div class="fullwidth">
                    <div class="News_Detail">
                        <h1 class="News_Detail_Title"><asp:Literal ID="lstTieuDe" runat="server"></asp:Literal>
                        </h1>
                        <div class="sapo_tin">
                            <asp:Literal ID="lstTrichDan" runat="server"></asp:Literal>
                        </div>
                        <div class="detail_content_news">
                             <asp:Literal ID="lstNoiDung" runat="server"></asp:Literal>
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
</asp:Content>
