<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuDon.ascx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.MenuDon" %>
<style>
    .menu_dkk_title {
        float: left;
        width: 85%;
    }

   
</style>
<asp:Panel ID="pn" runat="server">
    <sticknav>
    <div class="leftmenu_ds distance_bottom">
        <div class="leftmenu_ds_head bg_yellow dsdon_title"><a href="/Personnal/DsDon.aspx">Thông tin đơn</a></div>
        <div class="leftmenu_content ds_don_bg_gray">
            <div class="leftmenu_content">
                <ul class="danhsach">
                    <asp:Literal ID="ltt" runat="server"></asp:Literal>
                    <%-- <li><a href='Dsdon.aspx?status=1'>Đơn tạo mới<span>1</span></a></li>
               <li><a href='tracuu.aspx?status=2'>Đơn chờ tiếp nhận<span>0</span></a></li>
                <li><a href='Dsdon.aspx?status=3'>Đơn chờ bổ sung<span>5</span></a></li>
                <li><a href='Dsdon.aspx?status=4'>Đơn đã thụ lý<span>10</span></a></li>--%>
                </ul>
            </div>
        </div>
    </div>
        </sticknav>
</asp:Panel>
