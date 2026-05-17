<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uDsToiDanh.ascx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.Popup.uDsToiDanh" %>

<asp:Panel ID="pnThem" runat="server">
    <a href="javascript:;" onclick="popupDieuLuatAD();" style="float: right;"
        class="buttonpopup">Thêm điều luật áp dụng cho bị can đầu vụ</a>
</asp:Panel>

<asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<span class="msg_error">
    <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
<asp:Panel ID="pnPagingTop" runat="server">
    <div class="phantrang">
        <div class="sobanghi">
            <div style="float: left; font-weight: bold;">Các điều luật, quy định áp dụng cho bị can</div>
            <%--<asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>--%>
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
        <td width="10%">
            <div align="center"><strong>Tên bộ luật</strong></div>
        </td>
        <td width="10%">
            <div align="center"><strong>Ngày ban hành</strong></div>
        </td>
        <td width="50px">
            <div align="center"><strong>Điểm</strong></div>
        </td>
        <td width="50px">
            <div align="center"><strong>Khoản</strong></div>
        </td>
        <td width="50px">
            <div align="center"><strong>Điều</strong></div>
        </td>
        <td>
            <div align="center"><strong>Tội danh</strong></div>
        </td>
        <td width="70">
            <div align="center"><strong>Thao tác</strong></div>
        </td>
    </tr>
    <asp:Repeater ID="rpt" runat="server"
        OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
        <ItemTemplate>
            <tr>
                <td>
                    <div align="center"><%# Eval("STT") %></div>
                </td>
                <td><%#Eval("TenBoLuat") %></td>

                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayBanHanh")) %></td>

                <td><%# Eval("Diem") %></td>
                <td><%# Eval("Khoan") %></td>
                <td><%# Eval("Dieu") %></td>
                <td><%# Eval("TenToiDanh") %></td>

                <td>
                    <div align="center">
                        <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
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
    function PopupCenter(pageURL, title, w, h) {
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        return targetWin;
    }
    function popupDieuLuatAD() {
        var width = 950;
        var height = 550;

        var link = "/QLAN/AHS/Hoso/popup/pChonToiDanh.aspx?hsID=<%=VuAnID%>&bID=<%=BiCaoID%>";
        PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
    }

</script>
<%--  </div>
</div>--%>
