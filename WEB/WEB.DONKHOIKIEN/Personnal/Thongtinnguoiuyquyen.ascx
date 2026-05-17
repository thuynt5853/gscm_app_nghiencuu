<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Thongtinnguoiuyquyen.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.Thongtinnguoiuyquyen" %>

    <style type="text/css">
        
        .displayNone{
            display:none;
        }
        .ssize{
            width:20px;
        }
        .xsize{
            width:18px;
        }
    </style>

<script>
    

</script>

        


                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="displayNone" OnClick="lbtimkiem_Click" />

                                                    <asp:Panel ID="pnDuongSu" runat="server">
                                                        <div class="boxchung">
                                                            <h4 class="tleboxchung">Danh sách người ủy quyền</h4>
                                                            <div class="boder">
                                                                <div style="float: left; width: 100%;" class="msg_thongbao">
                                                                    <asp:Literal ID="lttMsgDS" runat="server"></asp:Literal>
                                                                </div>
                                                               <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                                                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                                                

                                                                <asp:Repeater ID="rptDuongSuKhac" runat="server"
                                                                    OnItemCommand="rptDuongSuKhac_ItemCommand">
                                                                    <HeaderTemplate>
                                                                        <div class="CSSTableGenerator">
                                                                            <table>

                                                                                <tr id="row_header">
                                                                                    <td style="width: 20px;">TT</td>
                                                                                    <td>Tư cách tố tụng</td>
                                                                                    
                                                                                    <td>Họ tên</td>
                                                                                    <td style="width:122px">Số CMND/CCCD/Hộ chiếu</td>
                                                                                    
                                                                                    <td style="width: 100px;">Thao tác</td>
                                                                                </tr>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <tr>
                                                                            <td><%# Container.ItemIndex + 1 %>
                                                                                
                                                                            </td>
                                                                            <td>
                                                                                <div style="text-align: justify; float: left;">
                                                                                    <%#Eval("TUCACHTOTUNG") %>
                                                                                </div>
                                                                            </td>

                                                                            <td><%#Eval("TENDUONGSU") %></td>
                                                                            <td><%#Eval("SOCMND") %></td>
                                                                            
                                                                            <td>
                                                                                <div style="text-align: center;">
                                                                                    <asp:ImageButton ID="imgNguoiQuyenSua" CssClass="ssize" runat="server" ImageUrl="/UI/img/edit.png" CommandName="Sua" CommandArgument='<%#Eval("ID_TEMP") %>'
                                                                                        ToolTip="Sửa"></asp:ImageButton>
                                                                                    &nbsp &nbsp
                                                                                    <asp:ImageButton ID="imgNguoiQuyenXoa"  CssClass="xsize" runat="server" ImageUrl="/UI/img/delete.png" CommandName="Xoa" CommandArgument='<%#Eval("ID_TEMP") %>'
                                                                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"></asp:ImageButton>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </ItemTemplate>
                                                                    <FooterTemplate></table></div></FooterTemplate>
                                                                </asp:Repeater>
                                                                
                                                            </div>
                                                        </div>
</asp:Panel>

