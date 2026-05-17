<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="RutKCKN_Sotham.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.RutKCKN_Sotham" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="box_nd" style="width: 99%;">

            <div class="truong">
                <table class="table1">
                    <tr><td><b  style="text-transform:uppercase;">DANH SÁCH KHÁNG CÁO, KHÁNG NGHỊ</b></td>
                        
                    </tr>
                    <tr>
                        <td>
                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="200" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                         <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="KCKNID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="IsKhangCao" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="KCKNName" HeaderText="Kháng cáo, kháng nghị" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người kháng cáo, cấp kháng nghị" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại" HeaderStyle-Width="118px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số BA/QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ngày rút</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtNgayRut" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgayRut_CalendarExtender3" runat="server" TargetControlID="txtNgayRut" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="txtNgayRut_MaskedEditExtender2" runat="server" TargetControlID="txtNgayRut" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="110px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tình trạng</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="ddlTinhTrang" CssClass="chosen-select" runat="server" Width="110px">
                                                    <asp:ListItem Value="0" Text="Chưa rút" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Rút một phần"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Rút toàn bộ"></asp:ListItem>
                                                </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Nội dung</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtNoidung" runat="server" CssClass="user" Width="96%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                    <div class="tooltip">
                                                        <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID")+"$"+ Eval("IsKhangCao") %>'
                                                            ImageUrl="~/UI/img/delete.png" Width="17px"
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa ? ');" />
                                                        <span class="tooltiptext  tooltip-bottom">Xóa Kháng cáo</span>
                                                    </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return ValidDataInput();" OnClick="btnUpdate_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
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
