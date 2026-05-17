<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uDsNhanThanBiCao.ascx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.Popup.uDsNhanThanBiCao" %>

<%--<div style="float: left; width: 100%; display: block;">--%>
<%--<asp:LinkButton ID="lkThemNhanThan" runat="server" 
        OnClientClick="popup_edit(0);" 
        CssClass="buttonpopup them_user">Thêm nhân thân bị can</asp:LinkButton>--%>
<!--------------------------->
<span class="msg_error">
    <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
<asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
<table class="table2" width="100%" border="1">
    <tr class="header">
        <td width="42">
            <div align="center"><strong>TT</strong></div>
        </td>
        <td>
            <div align="center"><strong>Họ tên</strong></div>
        </td>

        <td width="70px">
            <div align="center"><strong>Năm sinh</strong></div>
        </td>
        <td width="70px">
            <div align="center"><strong>Mối QH</strong></div>
        </td>
        <td width="70">
            <div align="center"><strong>Thao tác</strong></div>
        </td>
    </tr>
    <asp:Repeater ID="rptNhanThan" runat="server"
        OnItemCommand="rptNhanThan_ItemCommand" OnItemDataBound="rptNhanThan_ItemDataBound">
        <ItemTemplate>
            <tr>
                <td>
                    <div align="center"><%# Eval("STT") %></div>
                </td>
                <td><%#Eval("HoTen") %></td>
                <td><%# (Convert.ToInt32(Eval("NgaySinh_Nam")+"")==0) ? "":Eval("NgaySinh_Nam").ToString() %></td>
                <td><%# Eval("TenMoiQuanHe") %></td>
                <td>
                    <div align="center">
                        <asp:Literal ID="lttSua" runat="server"></asp:Literal>
                        &nbsp;&nbsp;
                           <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                               CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                    </div>
                </td>
            </tr>
        </ItemTemplate>

    </asp:Repeater>
</table>
<%--</div>--%>
<script>
    function popup_edit(NguoiID) {
        var link = "";
        if (NguoiID > 0)
            link = "/QLAN/AHS/Hoso/popup/pNhanThan.aspx?hsID=<%=VuAnID%>&bID=<%=BiCanID %>&uID=" + NguoiID;
        else
            link = "/QLAN/AHS/Hoso/popup/pNhanThan.aspx?hsID=<%=VuAnID%>&bID=<%=BiCanID %>";
        var width = 650;
        var height = 450;
        PopupCenter(link, "Cập nhật thông tin nhân thân của bị can", width, height);
    }

</script>
