<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Danhmuc.Phongban.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="80" runat="server" />
    <style type="text/css">
        .btnTimKiemCss {
            margin-left: 5px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 30%; vertical-align: top; border-right: 1px solid #ccc;">
                            <div style="margin: -10px;">
                                <asp:TreeView ID="treemenu" runat="server" NodeWrap="True" ShowLines="True" OnSelectedNodeChanged="treemenu_SelectedNodeChanged">
                                    <NodeStyle ImageUrl="../../UI/img/folder.gif" HorizontalPadding="3" Width="100%" CssClass="tree_menu"
                                        VerticalPadding="3px" />
                                    <ParentNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <RootNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <SelectedNodeStyle Font-Bold="True" />
                                </asp:TreeView>
                            </div>
                        </td>
                        <td style="width: 70%; vertical-align: top; text-align: left">
                            <table style="width: 100%; padding: 3px; border-spacing: 3px;">
                               
                                <tr>
                                    <td style="width: 100px;">Tên tòa án<asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="90%" Enabled="false"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Tên phòng ban<asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="90%" MaxLength="250"></asp:TextBox></td>
                                </tr>  
                                  <tr>
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:TextBox ID="txtDiachi" CssClass="user" runat="server" Width="90%" MaxLength="250"></asp:TextBox></td>
                                </tr>  
                                <tr>
                                    <td>Loại phòng ban</td>
                                    <td>
                                         <asp:DropDownList ID="ddlLoai" CssClass="chosen-select" runat="server" Width="250px">
                                                <asp:ListItem Value="0" Text="Tiếp nhận đơn" ></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Giải quyết đơn GĐT,TT"></asp:ListItem>
                                             <asp:ListItem Value="2" Text="Giải quyết đơn KN,TC"></asp:ListItem>
                                            </asp:DropDownList>
                                        <i>(Sử dụng trong GĐT,TT)</i>

                                    </td>
                                </tr>
                               <tr>
                                   <td>Lĩnh vực</td>
                                   <td>
                                       <table>
                                           <tr>
                                               <td style="width:90px;"><asp:CheckBox ID="chkHinhSu" CssClass="check" runat="server" Text="Hình sự" /></td>
                                               <td style="width:90px;"><asp:CheckBox ID="chkDanSu" class="check " runat="server" Text="Dân sự" /></td>
                                               <td style="width:90px;"><asp:CheckBox ID="chkHonNhanGD" class="check" runat="server"  Text="HN&GĐ" /></td>
                                               <td ><asp:CheckBox ID="chkKDTM" class="check" runat="server"  Text="KD&TM" /></td>
                                           </tr>
                                            <tr>
                                               <td style="width:90px;"> <asp:CheckBox ID="chkLaoDong" class="check" runat="server" Text="Lao động" /></td>
                                               <td style="width:90px;"><asp:CheckBox ID="chkHanhChinh" class="check" runat="server"  Text="Hành chính" /></td>
                                               <td style="width:90px;"><asp:CheckBox ID="chkPhasan" class="check" runat="server"  Text="Phá sản" /></td>
                                               <td ><asp:CheckBox ID="chkXLHC" class="check" runat="server" Text="BP XLHC" /></td>
                                           </tr>
                                       </table>                                         
                                   </td>
                               </tr>
                                <tr>
                                    <td>
                                        Hiệu lực
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" class="check" runat="server" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td>Hậu tố công văn</td>
                                    <td>
                                        <asp:TextBox ID="txtHauto" CssClass="user" runat="server" Width="90%" MaxLength="20"></asp:TextBox></td>
                                </tr>  
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return ValidateDataInput();" />
                                         <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div>
                                             <asp:HiddenField ID="hddID" runat="server" Value="0" />
                                            <asp:HiddenField ID="hddToaAnID" runat="server" Value="0" />
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </div>
                                        <asp:Panel runat="server" ID="pndata">
                                          
                                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                ItemStyle-CssClass="chan" Width="100%"
                                               OnItemCommand="dgList_ItemCommand"
                                                >
                                                <Columns>
                                                    <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                                                                                    
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Tên phòng ban
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("TENPHONGBAN") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Thao tác
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                            &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <HeaderStyle CssClass="header"></HeaderStyle>
                                                <ItemStyle CssClass="chan"></ItemStyle>
                                                <PagerStyle Visible="false"></PagerStyle>
                                            </asp:DataGrid>
                                        
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">

      
        function pageLoad(sender, args) { 
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
