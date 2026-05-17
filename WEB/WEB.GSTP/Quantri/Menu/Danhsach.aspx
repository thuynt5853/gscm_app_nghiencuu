<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Quantri.Menu.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">

        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 30%; vertical-align: top; border-right: 1px solid #ccc;" valign="top">
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
                        <td style="width: 70%; vertical-align: top;" align="left">
                            <table width="100%" cellpadding="3" cellspacing="3">
                                <tr>
                                    <td colspan="2" align="left">


                                        <asp:Button ID="cmdNew" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnNew_Click" />

                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 120px;">Tên menu
                                        <asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label>

                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="100%"
                                            MaxLength="255"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Menu cấp trên
                                    </td>
                                    <td>
                                        <asp:DropDownList CssClass="chosen-select" ID="dropParent" runat="server" Width="250px" OnSelectedIndexChanged="dropParent_SelectedIndexChanged"
                                            AutoPostBack="True">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Phân hệ
                                    </td>
                                    <td>
                                        <asp:DropDownList CssClass="chosen-select" ID="dropchuongtrinh" runat="server" Width="250px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Mã chức năng
                                        <asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label>

                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtMaaction" CssClass="user" runat="server" Width="100%"
                                            MaxLength="100"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Đường dẫn vật lý
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDuongdan" CssClass="user" runat="server" Width="100%"
                                            MaxLength="500"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Mô tả
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtMota" CssClass="user" runat="server" Width="100%"
                                            MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Thứ tự
                                    </td>
                                    <td>
                                        <asp:DropDownList CssClass="user" ID="dropthutu" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Cho phép sử dụng
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" class="check" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Cho phép thực hiện link ?
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkIsPhannhom" class="check" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Là Action ?
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkAction" class="check" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Không hiển thị trên cây chức năng vụ án ?
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkIsNotMenu" class="check" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table id="quyen" runat="server">
                                            <tr>
                                                <td colspan="2" align="left">
                                                     <div class="boxchung">
                                                        <h4 class="tleboxchung">Cấu hình hiển thị theo giai đoạn vụ việc/vụ án</h4>
                                                        <div class="boder" style="padding: 10px;">
                                                            <asp:CheckBox ID="chkViewSotham" class="check" runat="server" Text="Sơ thẩm" />
                                                                  &nbsp; &nbsp;  &nbsp; &nbsp;
                                                            <asp:CheckBox ID="chkViewPhuctham" class="check" Text="Phúc thẩm" runat="server" />
                                                                  &nbsp; &nbsp;  
                                                            <asp:CheckBox ID="chkViewPhucthamQDK" class="check" Text="Phúc thẩm KC/KN QĐ TĐC và QĐ khác" runat="server" />
                                                                  &nbsp; &nbsp;
                                                        </div>
                                                    </div>

                                                    <div class="boxchung">
                                                        <h4 class="tleboxchung">Cấu hình quyền theo chức năng</h4>
                                                        <div class="boder" style="padding: 10px;">
                                                            <asp:CheckBox ID="chkthemmoi" class="check" runat="server" Text="Thêm mới" />
                                                            &nbsp; &nbsp;  &nbsp; &nbsp;
                                    <asp:CheckBox ID="chkCapnhat" class="check" Text="Cập nhật" runat="server" />
                                                            &nbsp;&nbsp; &nbsp; &nbsp;                                  
                                    <asp:CheckBox ID="chkxoa" class="check" runat="server" />
                                                            &nbsp;Xóa &nbsp; &nbsp; &nbsp;
                                                        </div>
                                                    </div>
                                                    <div class="boxchung">
                                                        <h4 class="tleboxchung">Cấu hình quyền theo phân cấp tòa án</h4>
                                                        <div class="boder" style="padding: 10px;">
                                                            <asp:CheckBox ID="chkSotham" class="check" Text="Cấp huyện" runat="server" />
                                                            &nbsp; &nbsp; &nbsp;
                                    <asp:CheckBox ID="chkPhuctham" class="check" Text="Cấp tỉnh" runat="server" />
                                                            &nbsp; &nbsp; &nbsp; &nbsp;                                  
                                    <asp:CheckBox ID="chkToicao" class="check" Text="Cấp cao" runat="server" />
                                                            &nbsp; &nbsp; &nbsp; &nbsp;
                                                            <asp:CheckBox ID="chkQuantri" class="check" Text="Tối cao" runat="server" />
                                                            &nbsp; &nbsp;  
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"></td>
                                </tr>

                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return kiemtratrong()" />
                                        <asp:Button ID="cmdDel" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnDel_Click" OnClientClick="return confirm('Bạn chắc chắn muốn xóa ?');" />

                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />



                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <asp:HiddenField ID="hddid" runat="server" />
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </div>
                                        <asp:Panel runat="server" ID="pndata">
                                            <div class="phantrang">
                                                <div class="sobanghi">
                                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                                </div>
                                                <div class="sotrang">
                                                    <asp:LinkButton ID="lbTBack" Visible="false" runat="server" CausesValidation="false" CssClass="back" OnClick="lbTBack_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTFirst" Visible="false" runat="server" CausesValidation="false" CssClass="active" Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbTStep1" Visible="false" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbTStep2" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTStep3" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTStep4" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTStep5" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbTStep6" Visible="false" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbTLast" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTNext" Visible="false" runat="server" CausesValidation="false" CssClass="next" OnClick="lbTNext_Click"></asp:LinkButton>
                                                </div>
                                            </div>
                                            <div>
                                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%"
                                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                                    <Columns>
                                                        <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                            <HeaderTemplate>
                                                                Thứ tự
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:DropDownList CssClass="user" ID="ddlThutu" runat="server">
                                                                </asp:DropDownList>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" Width="30px"></HeaderStyle>
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn ItemStyle-Width="100px" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Tên menu
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%#Eval("TenMenu")%>
                                                            </ItemTemplate>

                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Đường dẫn vật lý
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%#Eval("duongdan")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Thao tác
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa menu này? ');"></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" Width="50px"></HeaderStyle>
                                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </div>
                                            <div class="phantrang">
                                                <div class="sobanghi">
                                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                                </div>
                                                <div class="sotrang">
                                                    <asp:LinkButton ID="lbBBack" Visible="false" runat="server" CausesValidation="false" CssClass="back" OnClick="lbTBack_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBFirst" Visible="false" runat="server" CausesValidation="false" CssClass="active" Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbBStep1" Visible="false" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbBStep2" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBStep3" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBStep4" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBStep5" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbBStep6" Visible="false" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbBLast" Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBNext" Visible="false" runat="server" CausesValidation="false" CssClass="next" OnClick="lbTNext_Click"></asp:LinkButton>
                                                </div>
                                            </div>
                                            <div style="float: left; margin-top: 6px;" runat="server" id="div_Order">
                                                <asp:Button ID="cmdCNThutu" runat="server" CssClass="buttoninput" Text="Lưu thứ tự" OnClick="cmdThutu_Click" />
                                            </div>
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
        function kiemtratrong() {
            if (Tenmenu() != true) { return false; }
            return true;

        }
        function Tenmenu() {
            var txtTenControl = document.getElementById('<%=txtTen.ClientID %>');
            var txtMaactionControl = document.getElementById('<%=txtMaaction.ClientID %>');
            if (txtTenControl.value.trim() == "" || txtTenControl.value.trim() == null) {
                alert('Bạn hãy nhập tên menu!');
                txtTenControl.focus();
                return false;
            } else {
                if (txtMaactionControl.value.trim() == "" || txtMaactionControl.value.trim() == null) {
                    alert('Bạn hãy nhập mã chức năng!');
                    txtTenControl.focus();
                    return false;
                }
                return true;
            }
        }
    </script>

</asp:Content>
