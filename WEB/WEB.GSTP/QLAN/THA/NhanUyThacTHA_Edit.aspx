<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="NhanUyThacTHA_Edit.aspx.cs"
    Inherits="WEB.GSTP.QLAN.THA.NhanUyThacTHA_Edit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>

    <!----------------------------------------------------->
    <asp:HiddenField ID="HddID" runat="server" Value="0" />
    <asp:HiddenField ID="Hddindex" runat="server" Value="1" />
    <asp:HiddenField ID="HddPage" runat="server" Value="20" />
    <asp:HiddenField ID="hddLoaiUyThac" runat="server" Value="0" />
    <!----------------------------------------------------->
    <div style="margin-left: 1%; width: 98%; float: left;">
        <div style="margin: 15px 1%; text-align: center; width: 98%; color: red;">
            <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
        </div>
        <div class="boxchung">
            <h4 class="tleboxchung">Thông tin ủy thác thi hành án</h4>
            <div class="boder" style="padding: 5px 10px;">
                <%--<table class="table1">
                    <tr>
                        <td class="cell_label">Mã vụ án</td>
                        <td>
                            <asp:Literal ID="lttMaVuAn" runat="server"></asp:Literal>
                        </td>
                        <td class="cell_label">Tên vụ án</td>
                        <td>
                            <asp:Literal ID="lttTenVuAn" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td class="cell_label">Mã bị án</td>
                        <td>
                            <asp:Literal ID="lttMaBiAn" runat="server"></asp:Literal>
                        </td>
                        <td class="cell_label">Tên bị án</td>
                        <td>
                            <asp:Literal ID="lttTenBiAn" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td class="cell_label">Quyết định ủy thác THA</td>
                        <td colspan="3">
                            <asp:Literal ID="lttQDUyThac" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td class="cell_label">Tòa án ủy thác<span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:Literal ID="lttToaUyThac" runat="server"></asp:Literal>
                        </td>
                        <td class="cell_label">Người nhập<span class="batbuoc">(*)</span> </td>
                        <td>
                            <asp:Literal ID="lttNguoiNhapUyThac" runat="server"></asp:Literal>
                        </td>
                    </tr>

                    <!---------------------------------------------->
                    <tr>
                        <td class="cell_label">Ngày ủy thác<span class="batbuoc">(*)</span>
                        </td>
                        <td colspan="3">
                            <asp:Literal ID="lttNgayUyThac" runat="server"></asp:Literal>
                        </td>
                    </tr>
                </table>--%>

                  <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True"
                                GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Mã bị án</HeaderTemplate>
                                        <ItemTemplate><%# Eval("MaBiCan")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tên bị án</HeaderTemplate>
                                        <ItemTemplate>
                                          <%# Eval("TenBiCan")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Mã vụ án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("BA_MaVuAn")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tên vụ án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("BA_TenVuAn")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Quyết định ủy thác thi hành án</HeaderTemplate>
                                        <ItemTemplate>
                                               <%# Eval("SoQD") %>-<%# Eval("TenQD") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tòa án ủy thác</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# Eval("TenToaAnUyThac") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày ủy thác</HeaderTemplate>
                                        <ItemTemplate>
                                                  <%# string.Format("{0:dd/MM/yyyy}", Eval("NgayUyThac")) %>                 
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người nhập</HeaderTemplate>
                                        <ItemTemplate>
                                                <%# Eval("TenNguoiNhap") %>              
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>
            </div>
            <h4 class="tleboxchung" >Xử lý ủy thác thi hành án</h4>
            <div class="boder" style="padding: 5px 10px; height:200px">
                <table class="table1" style="margin-top:15px">
                    <tr>
                        <td style="width: 120px">Ngày nhận<span class="batbuoc">(*)</span>
                        </td>
                        <td style="width: 222px">
                            <asp:TextBox ID="txtNgayNhan" runat="server" Width="222px" 
                                CssClass="user"></asp:TextBox>
                             <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy"/>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                          
                        </td>
                        <td  style="width: 120px">Người ký <span class="batbuoc">(*)</span> </td>
                        <td>
                            <asp:DropDownList ID="dropNguoiKy" runat="server" Enabled="true"
                                CssClass="chosen-select" Width="230px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>Ghi chú</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtGhichu" runat="server"
                                Width="590px" CssClass="user"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="padding-top: 10px; text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClientClick="return validate();" OnClick="cmdUpdate_Click" />
                            <asp:Button ID="cmdResert" runat="server" CssClass="buttoninput"
                                Text="Làm mới" OnClick="cmdResert_Click" /></td>
                    </tr>
                </table>
                <div style="padding-top: 10px; text-align: center; width: 95%; float: left; margin-left: 2%; color: red; font-weight: bold;">
                    <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                </div>

            </div>
        </div>

    </div>
    <script>
        function validate() {
            var ddlNguoiki = document.getElementById('<%=dropNguoiKy.ClientID%>');
            var value_change = ddlNguoiki.options[ddlNguoiki.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn người ký. Hãy kiểm tra lại!');
                ddlNguoiki.focus();
                return false;
            }
            var txtNgayNhan = document.getElementById('<%=txtNgayNhan.ClientID%>');
            if (!CheckDateTimeControl(txtNgayNhan, 'mục "Ngày nhận"'))
                return false;
            return true;
        }
    </script>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>

