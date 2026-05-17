<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uDsThuLy.ascx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.Popup.uDsThuLy" %>


 <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
<table class="table2" width="100%" border="1">
    <tr class="header">
        <td width="42">
            <div align="center"><strong>TT</strong></div>
        </td>
        <td>
            <div align="center"><strong>Mã thụ lý</strong></div>
        </td>
        <td>
            <div align="center"><strong>Số thụ lý</strong></div>
        </td>
        <td>
            <div align="center"><strong>TH thụ lý</strong></div>
        </td>
        <td width="10%">
            <div align="center"><strong>Ngày thụ lý</strong></div>
        </td>
        <td width="10%">
            <div align="center"><strong>Từ ngày</strong></div>
        </td>
        <td width="10%">
            <div align="center"><strong>Đến ngày</strong></div>
        </td>

        <td width="70">
            <div align="center"><strong>Thao tác</strong></div>
        </td>
    </tr>
    <asp:Repeater ID="rpt" runat="server"
        OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
        <ItemTemplate>
            <tr>
                <td><div align="center"><%# Container.ItemIndex + 1 %></div></td>
                <td><%#Eval("MaThuLy") %></td>
                <td><%#Eval("SoThuLy") %></td>
                <td><%#Eval("TruongHopThuLy") %></td>
                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayThuLy")) %></td>
                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("ThoiHanTuNgay")) %></td>
                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("ThoiHanDenNgay")) %></td>
                <td> <div align="center">
                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
               </div> </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
</table>

<asp:Literal ID="lstMsgB" runat="server"></asp:Literal>