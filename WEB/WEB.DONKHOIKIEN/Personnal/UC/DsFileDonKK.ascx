<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DsFileDonKK.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.DsFileDonKK" %>
<asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
    <HeaderTemplate>
        <div class="CSSTableGenerator">
            <table>                
                    <tr id="row_header">
                        <td style="width: 20px;">TT</td>
                        <td>Tên tài liệu</td>
                        <td style="width: 70px;">Tải file</td>
                        <td style="width: 70px;">Thao tác</td>
                    </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td><%# Container.ItemIndex + 1 %>
                <asp:HiddenField ID="hddTaiLieuID" runat="server"
                    Value=' <%#Eval("ID") %>' />
            </td>
            <td>
                <div style="text-align: justify; float: left;">
                    <%#Eval("TenTaiLieu") %>
                </div>
            </td>

            <td>
                <div style="text-align: center;">
                    <asp:ImageButton ID="cmdDowload" ImageUrl="/UI/img/dowload.png"
                        runat="server" ToolTip="Tải file" Width="20px" CommandArgument='<%#Eval("ID").ToString() %>'
                        CommandName="dowload"></asp:ImageButton>
                </div>
            </td>
        </tr>
    </ItemTemplate>
    <FooterTemplate></table></div></FooterTemplate>
</asp:Repeater>
