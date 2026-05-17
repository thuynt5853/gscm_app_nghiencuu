<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
CodeBehind="Chuyenmuc.aspx.cs" Inherits="WEB.GSTP.QTDKK.Tinbai.Chuyenmuc" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <style type="text/css">
        .tdWidthTblToaAn {
            width: 120px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 20%; vertical-align: top; border-right: 1px solid #ccc;">
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
                                    <td colspan="2" style="text-align: left;">
                                        <asp:Button ID="btnNew" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnNew_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 120px;"><b>Mã danh mục</b><asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="200px" MaxLength="50"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td><b>Tên danh mục</b><asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="100%" MaxLength="250"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td><b>Danh mục cha</b></td>
                                    <td>
                                        <asp:DropDownList CssClass="user" ID="dropParent" runat="server" Width="101%" OnSelectedIndexChanged="dropParent_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Thứ tự</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList CssClass="user" ID="dropThuTu" runat="server" Width="71px"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Hiệu lực</b>
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" class="check" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Cập nhật" OnClick="btnUpdate_Click" OnClientClick="return ValidateDataInput();" />
                                        <asp:Button ID="cmdDel" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnDel_Click" OnClientClick="return confirm('Bạn chắc chắn muốn xóa ?');" />
                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <asp:HiddenField ID="hddToaAnID" runat="server" Value="0" />
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </div>
                                        <table style="width: 300px; margin-top: 10px; border-spacing: 5px;">
                                            <tr>
                                                <td style="width: 150px;">
                                                    <asp:TextBox runat="server" ID="txttimkiem" Width="100%" CssClass="user" placeholder="Mã, tên tòa án"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Button ID="Btntimkiem" runat="server" CssClass="buttoninput btnTimKiemCss" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                        <asp:Panel runat="server" ID="pndata">
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
                                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                ItemStyle-CssClass="chan" Width="100%"
                                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                                <Columns>
                                                    <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="40px" ItemStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Thứ tự
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList CssClass="user" ID="DropThuTuChildren" runat="server" Width="98%"></asp:DropDownList>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Mã
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("MACHUYENMUC")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Tên tòa án
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("TENCHUYENMUC") %>
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
                                            <div class="phantrang">
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
                                            <div style="float: left; margin-top: 6px;" runat="server" id="div_Order">
                                                <asp:Button ID="cmdThutu" runat="server" CssClass="buttoninput" Text="Cập nhật thứ tự" OnClick="cmdThutu_Click" />
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
    <script>
        function Validate() {
            var txtMa = document.getElementById('<%=txtMa.ClientID%>');
            if (!Common_CheckEmpty(txtMa.value)) {
                alert('Bạn chưa nhập mã. Hãy kiểm tra lại!');
                txtMa.focus();
                return false;
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
