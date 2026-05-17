<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="BAQDDaCongBo.aspx.cs" Inherits="WEB.GSTP.GSTP.HoatDongCongBoBAQD.BAQDDaCongBo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
               <h4 class="tleboxchung">Thông tin thẩm phán đã công bố</h4>
                <div class="boder" style="padding: 10px;">
                 <asp:Literal ID="li_DSTP_CBBA" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
