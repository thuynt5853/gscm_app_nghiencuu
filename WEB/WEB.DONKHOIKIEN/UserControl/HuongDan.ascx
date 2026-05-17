<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HuongDan.ascx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.HuongDan" %>

<div class="leftmenu distance_bottom">
    <div class="leftmenu_header arrow">
        <img src="/UI/img/huongdan_icon.png" class="leftmenu_header_icon" />
        <span><asp:Literal ID="lttTieuDe" runat="server"></asp:Literal></span>
    </div>
    <div class="leftmenu_content">
        <asp:HiddenField ID="hddSoLuong" runat="server" Value="5" />
        <asp:HiddenField ID="hddGroupNews" runat="server" Value="2" />
        <asp:HiddenField ID="hddMaGroup" runat="server" Value="huongdannopdon" />
        <asp:Repeater ID="rpt" runat="server">
            <HeaderTemplate>
                <ul class="huongdantracuu">
            </HeaderTemplate>
            <ItemTemplate>
                <li><a href='/ChiTietTin.aspx?tID=<%#Eval("ID") %>&&cID=<%#Eval("ChuyenMucID") %>'><%#Eval("TieuDe") %></a></li>
            </ItemTemplate>
            <FooterTemplate></ul></FooterTemplate>
        </asp:Repeater>
    </div>
</div>
