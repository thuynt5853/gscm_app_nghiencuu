<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true"
    CodeBehind="PersonalIndex.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.PersonalIndex" %>

<%@ Register Src="~/Personnal/UC/DSVanBanTongDat.ascx" TagPrefix="uc1" TagName="DSVanBanTongDat" %>
<%@ Register Src="~/Personnal/UC/DsHoSo.ascx" TagPrefix="uc1" TagName="DsHoSo" %>
<%@ Register Src="~/Personnal/UC/TopDKNhanVB.ascx" TagPrefix="uc1" TagName="TopDKNhanVB" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-----------Nhom DS van ban tong dat---------------->
    <div class="right_full_width distance_bottom">
        <uc1:DSVanBanTongDat runat="server" ID="DSVanBanTongDat" />
    </div>
    <!--------Danh sach dk nhan vb tong dat------------------->
    <uc1:TopDKNhanVB runat="server" ID="TopDKNhanVB" />
    <!--------Danh sach ho so------------------->
    <uc1:DsHoSo runat="server" ID="DsHoSo" />
</asp:Content>
