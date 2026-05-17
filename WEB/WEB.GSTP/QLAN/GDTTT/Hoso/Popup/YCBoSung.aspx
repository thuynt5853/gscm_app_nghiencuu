<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YCBoSung.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.YCBoSung" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Yêu cầu bổ sung</title>
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
            <h4 class="tleboxchung">Yêu cầu bổ sung</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1" style="margin: auto;" id="tblYC">
                    <asp:Panel ID="pnYC" runat="server">
                        <tr>
                            <td style="width: 100px;">Số thông báo<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:TextBox ID="txtSoThongBao" runat="server" CssClass="user" Width="110px" MaxLength="50" style="margin-left:8px;"></asp:TextBox>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="txtNgayThongBao" EventName="TextChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>    
                                
                            </td>
                            <td style="width: 80px;">Ngày thông báo<span class="batbuoc">(*)</span></td>
                            <td style="width: 140px;">
                                <asp:TextBox ID="txtNgayThongBao" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayThongBao" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayThongBao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td style="width: 105px;">Người ký<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNguoiKy" runat="server" CssClass="user" Width="110px" MaxLength="60"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>                          
                            <td>Lý do<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                 <asp:CheckBoxList ID="chkLydoCDDK" runat="server" RepeatDirection="Vertical" RepeatColumns="3" AutoPostBack="True" OnSelectedIndexChanged="chkLydoCDDK_SelectedIndexChanged">
                                    <asp:ListItem Value="0" Text="Bản án, quyết định"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Xác nhận"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Lý do khác"></asp:ListItem>
                                </asp:CheckBoxList>                           
                            </td>
                             <td>Lần thứ<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList CssClass="user" ID="dropLanThu" Width="118px" runat="server" ToolTip="Lựa chọn lần thứ">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </asp:Panel>
                    

                        <tr runat="server" id="trLydokhac">
                            <td></td>
                            <td colspan="5">
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                    <ContentTemplate>
                                            <asp:TextBox ID="txtNoiDung" runat="server" CssClass="user" TextMode="MultiLine" Width="610px" Rows="2" Visible="false" style="margin-left:8px;"></asp:TextBox>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="chkLydoCDDK" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>                                
                            </td>
                        </tr>
                    
                    <asp:Panel ID="pnKQ" runat="server" Visible="false">

                        <tr>
                            <td>Kết quả<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:RadioButtonList ID="rdbKQ" runat="server" RepeatDirection="Horizontal" Width="275px">
                                    <asp:ListItem Value="1" Text="Chưa hoàn thành"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Hoàn thành "></asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td style="width: 105px;">Ngày bổ sung</td>
                            <td style="width: 120px;" colspan="3">
                                <asp:TextBox ID="txtNgayBS" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayBS" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Nội dung</td>
                            <td colspan="5">
                                <%--<asp:UpdatePanel ID="UpdatePanel5" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                            <asp:TextBox ID="txtNoiDungKQ" runat="server" CssClass="user" TextMode="MultiLine" Width="670px" Rows="2"></asp:TextBox>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="rdbKQ" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>  --%> 
                                <asp:TextBox ID="txtNoiDungKQ" runat="server" CssClass="user" TextMode="MultiLine" Width="610px" Rows="2" style="margin-left:8px;"></asp:TextBox>
                            </td>
                        </tr>
                    </asp:Panel>
                    <tr>
                        <td colspan="4" align="center">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" align="center">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="ChangeCheck();"/>
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" OnClientClick="ChangeCheck();"/>
                            <input type="button" class="buttoninput" onclick="OnClosePopup();" value="Đóng" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="boxchung">
            <h4 class="tleboxchung">Quá trình yêu cầu bổ sung</h4>
            <div class="boder" style="padding: 10px;">
                <div>
                    <asp:Button ID="btnNBInThongbao" Width="170px" runat="server" CssClass="buttonprint" Text="In thông báo YCBS" OnClientClick="ChangeCheck();" OnClick="btnNBInThongbao_Click" />
                    <asp:Button ID="btnNBInThongbaoTG" Width="170px" runat="server" CssClass="buttonprint" Text="In thông báo YCBS(TG)" OnClientClick="ChangeCheck();" OnClick="btnNBInThongbaoTG_Click" />
                </div>
                <asp:DataGrid ID="dgDS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" OnItemCommand="dgDS_ItemCommand" OnItemDataBound="dgDS_ItemDataBound">
                    <Columns>

                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkChon" ToolTip='<%# Container.ItemIndex %>' runat="server" />
                                <asp:HiddenField ID="hddID" Value='<%# Container.ItemIndex %>' runat="server" />
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:BoundColumn DataField="LANTHU" HeaderText="Lần thứ" HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOTHONGBAO" HeaderText="Số thông báo" HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="NGAYTHONGBAO" HeaderText="Ngày thông báo" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="40px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="NGUOIKY" HeaderText="Người ký" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENLYDO" HeaderText="Lý do" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px"></asp:BoundColumn>
                        <asp:BoundColumn DataField="NGAYBS" HeaderText="Ngày bổ sung" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="40px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Cập nhật kết quả</HeaderTemplate>
                            <ItemTemplate>
                                <div class="tooltip">
                                    <asp:ImageButton ID="cmdCapNhat" runat="server" ToolTip="Cập nhật kết quả" CssClass="grid_button"
                                        CommandName="KetQua" CommandArgument='<%#Eval("ID") %>'
                                        ImageUrl="~/UI/img/edit.png" Width="18px" OnClientClick="ChangeCheck();"/> 
                                    <span class="tooltiptext  tooltip-bottom">Cập nhật kết quả</span>
                                </div>

                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Sửa</HeaderTemplate>
                            <ItemTemplate>
                                <div class="tooltip">
                                    <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa" CssClass="grid_button"
                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'
                                        ImageUrl="~/UI/img/edit_doc.png" Width="18px" OnClientClick="ChangeCheck();"/>
                                    <span class="tooltiptext  tooltip-bottom">Sửa</span>
                                </div>

                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Xóa</HeaderTemplate>
                            <ItemTemplate>
                                <div class="tooltip">
                                    <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                        ImageUrl="~/UI/img/delete.png" Width="17px"
                                        OnClientClick="ChangeCheck(); return confirm('Bạn thực sự muốn xóa? ');"/>
                                    <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                            <HeaderTemplate>Chi tiết</HeaderTemplate>
                            <ItemTemplate>
                                <div class="tooltip">
                                    <asp:ImageButton ID="cmdView" runat="server" ToolTip="Chi tiết" CssClass="grid_button"
                                        CommandName="ChiTiet" CommandArgument='<%#Eval("ID") %>'
                                        ImageUrl="~/UI/img/edit_doc.png" Width="18px"  OnClientClick="ChangeCheck();"/>
                                    <span class="tooltiptext  tooltip-bottom">Chi tiết</span>
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

    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
<script type = "text/javascript">
    var check = true;
    function OnClosePopup()
    {
        window.close();
        window.opener.HideModalDiv();
    }
    function ChangeCheck()
    {
        check = false;
    }
    function OnClose() {
        if (window.opener != null && !window.opener.closed && check == true) {
            window.opener.HideModalDiv();
        }
        else {
            check = true;
        }
    }
    window.onbeforeunload = OnClose;
</script>
</html>

