<%@ Page Title="" Language="C#"
    AutoEventWireup="true" CodeBehind="Lichsutacdong.aspx.cs"
    Inherits="WEB.GSTP.Danhmuc.Toaan.Lichsutacdong" %>

<%@ Register
    Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head><title></title></head>
<body>
     <asp:Label
                                                            ID="lblThongBaoSapNhap"
                                                            runat="server"
                                                            ForeColor="Red"></asp:Label>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="80" runat="server" />
    <asp:DataGrid
                                                    ID="dgSapNhap"
                                                    runat="server"
                                                    AutoGenerateColumns="False"
                                                    CellPadding="4"
                                                    GridLines="None"
                                                    CssClass="table2"
                                                    HeaderStyle-CssClass="header"
                                                    AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan"
                                                    Width="100%"
                                                    OnItemCommand="dgSapNhap_ItemCommand"
                                                    OnItemDataBound="dgSapNhap_ItemDataBound">
                                                    <Columns>
                                                        <asp:BoundColumn
                                                            DataField="ID"
                                                            Visible="false"></asp:BoundColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-Width="50px"
                                                            ItemStyle-Width="50px"
                                                            HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Thứ tự </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Container.ItemIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Loại sáp nhập </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("LOAITEN") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-Width="120px"
                                                            ItemStyle-Width="120px"
                                                            HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Ngày bắt đầu hiệu lực
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("NGAYHIEULUC") != null ?
                                Convert.ToDateTime(Eval("NGAYHIEULUC")).ToString("dd/MM/yyyy")
                                : "" %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-Width="120px"
                                                            ItemStyle-Width="120px"
                                                            HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Ngày kết thúc hiệu lực
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("NGAYHETHIEULUC") != DBNull.Value ?
                                Convert.ToDateTime(Eval("NGAYHETHIEULUC")).ToString("dd/MM/yyyy")
                                : "" %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Đơn vị cũ </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("TOAANTEN") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Đơn vị mới </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("TOTOAANTEN") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                       
                                                       
                                                    </Columns>
                                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                </asp:DataGrid>
</body>
</html>
