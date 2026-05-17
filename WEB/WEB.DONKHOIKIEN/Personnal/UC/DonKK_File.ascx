<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DonKK_File.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.DonKK_File" %>

<asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
    <HeaderTemplate>
        <div class="boxchung" style="margin-top: 0px;">
            <h4 class="tleboxchung">
                <asp:Literal ID="Literal4" runat="server" Text="Danh mục tài liệu, chứng cứ kèm theo gồm có"></asp:Literal>
            </h4>
            <div class="boder" style="padding: 10px;">
                <div class="CSSTableGenerator" style="float: none;">
                    <table>

                        <tr id="row_header">
                            <td style="width: 20px;">TT</td>
                            <td>Tên tài liệu</td>
                            <td style="width: 70px;">Tải file</td>
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
                    <asp:ImageButton ID="cmdSua" ImageUrl="/UI/img/dowload.png"
                        runat="server" ToolTip="Tải file xuống" Width="20px" CommandArgument='<%#Eval("ID").ToString() %>'
                        CommandName="dowload"></asp:ImageButton>
                </div>
            </td>
            <%--<asp:Panel ID="pnDowload" runat="server">
                        <td>
                            <asp:ImageButton ID="cmdXoa" runat="server" ImageUrl="/UI/img/xoa.gif"
                                CommandArgument='<%#Eval("ID").ToString() %>' CommandName="Delete" ToolTip="Xóa"
                                OnClientClick="return confirm('Bạn có thực sự muốn xóa văn bản này?');" Width="20px"></asp:ImageButton></td>
                    </asp:Panel>--%>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        </table></div>  </div>
</div>
    </FooterTemplate>
</asp:Repeater>

