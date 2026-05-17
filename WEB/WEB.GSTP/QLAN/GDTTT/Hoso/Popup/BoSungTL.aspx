<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BoSungTL.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.BoSungTL" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lịch sử đơn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>          
                        <div class="boxchung">
                            <h4 class="tleboxchung">Bổ sung tài liệu</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1" style="width:470px;margin:auto;">
                                    <tr>
                                        <td style="width: 105px;">Ngày bổ sung<span class="batbuoc">(*)</span></td>
                                        <td style="width: 120px;">
                                            <asp:TextBox ID="txtNgayBoSung" runat="server" CssClass="user" Width="110px" MaxLength="10" ></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBoSung" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBoSung" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 80px;">Số hiệu</td>
                                        <td>
                                            <asp:TextBox ID="txtSohieudon" runat="server" CssClass="user" Width="110px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Kết quả</td>
                                        <td colspan="3">
                                            <asp:RadioButtonList ID="rdbTrangThai" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbTrangThai_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Đơn đủ điều kiện" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Đơn chưa đủ điều kiện"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr runat="server" id="trThuly">
                                        <td>Số thụ lý<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoThuLy" runat="server" CssClass="user" onkeypress="return isNumber(event)" Width="110px" MaxLength="50"></asp:TextBox>
                                        </td>
                                        <td>Ngày thụ lý<span class="batbuoc">*</span></td>
                                        <td>
                                             <asp:TextBox ID="txtNgaythuly" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                    <tr>
                                        <td>Lý do</td>
                                        <td colspan="3">
                                            <asp:CheckBoxList ID="chkLydoCDDK" runat="server" RepeatDirection="Horizontal" RepeatColumns="2"  AutoPostBack="True" OnSelectedIndexChanged="chkLydoCDDK_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Bản án, quyết định"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Xác nhận"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Lý do khác"></asp:ListItem>
                                        </asp:CheckBoxList>
                                        </td>
                                    </tr>
                                     <tr runat="server" id="trLydokhac" visible="false">
                                         <td></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtLydoCDDK_Khac" runat="server" CssClass="user" TextMode="MultiLine" Width="330px" Rows="2"></asp:TextBox>
                                    </td>
                                </tr>
                                        </asp:Panel>
                                     <tr runat="server" id="tr1">
                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtGhichu" runat="server" CssClass="user" Width="330px" MaxLength="250"></asp:TextBox>
                                        </td>                                        
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <div>
                                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />

                                            <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                        </td>
                                    </tr>
                                    </table>
                                  </div>
                        </div>
                 
            <div class="boxchung">
            <h4 class="tleboxchung">Quá trình bổ sung tài liệu</h4>
            <div class="boder" style="padding: 10px;">
                    <asp:DataGrid ID="dgDS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan"  OnItemCommand="dgDS_ItemCommand">
                    <Columns>
                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>TT</HeaderTemplate>
                            <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:BoundColumn DataField="SOHIEU" HeaderText="Số hiệu" HeaderStyle-Width="50px" ></asp:BoundColumn>
                        <asp:BoundColumn DataField="NGAYBOSUNG" HeaderText="Ngày bổ sung" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                       <asp:TemplateColumn HeaderStyle-Width="105px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Kết quả</HeaderTemplate>
                            <ItemTemplate>
                                <%#Eval("TENTRANGTHAI") %>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="75px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Thiếu Bản án?</HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkBA" Enabled="false" runat="server" Checked='<%#GetBool(Eval("ISBA")) %>' />
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="65px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Thiếu xác nhận?</HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkXacnhan" Enabled="false" runat="server" Checked='<%#GetBool(Eval("ISXACNHAN")) %>' />
                            </ItemTemplate>
                        </asp:TemplateColumn>  
                        <asp:TemplateColumn HeaderStyle-Width="105px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Lý do khác</HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkKhac" Enabled="false" runat="server" Checked='<%#GetBool(Eval("ISKHAC")) %>' />
                                <br />
                                <%#Eval("LYDOKHAC") %>
                            </ItemTemplate>
                        </asp:TemplateColumn> 
                         <asp:TemplateColumn  ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Ghi chú</HeaderTemplate>
                            <ItemTemplate>                                
                                <%#Eval("GHICHU") %>
                            </ItemTemplate>
                        </asp:TemplateColumn> 
                          <asp:TemplateColumn HeaderStyle-Width="35px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Sửa</HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa" CssClass="grid_button"
                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") %>'
                                                    ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                <span class="tooltiptext  tooltip-bottom">Sửa</span>
                                            </div>

                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Xóa</HeaderTemplate>
                                        <ItemTemplate>
                                           <div class="tooltip">
                                                    <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                        ImageUrl="~/UI/img/delete.png" Width="17px"
                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                    <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                                </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                    </Columns>
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:DataGrid>                      
            </div>
        </div>
      <%-- <script>
            function Reload_KQ() {
                window.onunload = function (e) {
                    opener.Loads_KQ();
                };
                //window.close();
            }
        </script>--%>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
