<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uDSNguoiThamGiaToTung.ascx.cs" Inherits="WEB.GSTP.QLAN.AKT.TaoHS.Popup.uDSNguoiThamGiaToTung" %>


<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

<asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
<span class="msg_error">
    <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
<asp:Panel ID="pnPagingTop" runat="server">
    <div class="phantrang">
        <div class="sobanghi">
            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
        </div>
        <div class="sotrang">
            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                OnClick="lbTBack_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                OnClick="lbTNext_Click"></asp:LinkButton>
        </div>
    </div>
</asp:Panel>

<table class="table2" width="100%" border="1">
    <tr class="header">
        <td width="42">
            <div align="center"><strong>TT</strong></div>
        </td>
        
        <td width="20%">
            <div align="center"><strong>Họ và tên</strong></div>
        </td>
        <td width="20%">
            <div align="center"><strong>Tư cách TGTT</strong></div>
        </td>
        <td>
            <div align="center"><strong>Địa chỉ</strong></div>
        </td>
        <td>
            <div align="center"><strong>Tên đương sự</strong></div>
        </td>
        <td width="100px">
            <div align="center"><strong>Ngày tham gia</strong></div>
        </td>
        <td width="70px">
            <div align="center"><strong>Thao tác</strong></div>
        </td>
    </tr>


    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
        <ItemTemplate>
            <tr>
                <td>
                    <div align="center"><%# Container.ItemIndex + 1 %></div>
                </td>
                <td><%#Eval("HOTEN") %></td>
                <td><%# Eval("TENTC") %></td>
                
                <td><%# Eval("Tamtru") %></td>
                <td><%# Eval("TENDUONGSU") %></td>
                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYTHAMGIA")) %></td>
                <td>
                    <div align="center">
                        <asp:Literal ID="lttSua" runat="server"></asp:Literal>
                        &nbsp;&nbsp;
                        <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                            ToolTip="Xóa"
                            OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                    </div>
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>

</table>
<asp:Panel ID="pnPagingBottom" runat="server">
    <div class="phantrang_bottom">
        <div class="sobanghi">
            <asp:HiddenField ID="hdicha" runat="server" />
            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
        </div>
        <div class="sotrang">
            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                OnClick="lbTBack_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                OnClick="lbTNext_Click"></asp:LinkButton>
        </div>
    </div>
</asp:Panel>
<script>
    function popup_form_edit(curr_id) {
        var link = "";
        if (curr_id > 0)
            link = "/QLAN/AKT/TaoHS/Popup/pNguoiThamGiaTT.aspx?hsID=<%=Donid%>&uID=" + curr_id;
        else
            link = "/QLAN/AKT/TaoHS/Popup/pNguoiThamGiaTT.aspx?hsID=<%=Donid%>";
        var width = 950;
        var height = 350;
        PopupCenter(link, "Người tham gia đối tượng", width, height);
    }
</script>


