<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pPhatHanh.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pPhatHanh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Văn bản phát hành</title>

    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>  
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <style type="text/css">
                        body {
                            width: 98%;
                            margin-left: 1%;
                            min-width: 0px;
                            overflow: auto;
                        }

                        .check_list_vertical table td {
                            padding-right: 15px;
                        }

                        .boxchung {
                            padding-top: 10px;
                        }

                        .auto-style1 {
                            height: 36px;
                        }

                        .auto-style2 {
                            height: 36px;
                        }

                        .lable_td {
                            width: 117px;
                        }

                        .checkbox {
                            width: 100%;
                        }

                            .checkbox label {
                                margin-left: 5px;
                            }

                        .text_Right_css {
                            text-align: right;
                        }
                    </style>

                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin phát hành</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <asp:Panel ID="pnVBPH" runat="server">
                                    <tr>
                                        <td class="lable_td">Văn bản phát hành</td>
                                        <td colspan="4" style="width: 350px;">
                                            <asp:DropDownList ID="dropVBPH" CssClass="user" runat="server"
                                                Width="390px" AutoPostBack="True" OnSelectedIndexChanged="dropVBPH_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </asp:Panel>                                
                                <tr>
                                    <td class="lable_td">Tên văn bản phát hành</td>
                                    <td colspan="4" style="width: 350px;">
                                        <asp:TextBox ID="txtTenVBPH" CssClass="user" runat="server" Width="381px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td ID="lbtNoiNhan" runat="server" style="width: 160px;" visible="false">Nơi nhận</td>
                                    <td colspan="4">
                                        <asp:Panel ID="pnDoiTuong" runat="server">
                                            <asp:Repeater ID="rptDoiTuong" runat="server" OnItemCommand="rptDoiTuong_ItemCommand" OnItemDataBound="rptDoiTuong_ItemDataBound">
                                                <HeaderTemplate>
                                                     <table class="table2" width="100%" border="1">
                                                        <tr class="header">
                                                            <td width="42">
                                                                <div align="center"><strong>STT</strong></div>
                                                            </td>                                                           
                                                            <td width="200px">
                                                                <div align="center"><strong>Tên đương sự</strong></div>
                                                            </td>
                                                            <td width="100px">
                                                                <div align="center"><strong>Tư cách tố tụng</strong></div>
                                                            </td>
                                                            <td width="200px">
                                                                <div align="center"><strong>Địa chỉ</strong></div>
                                                            </td>
                                                            <td width="50px">
                                                                <div align="center"><strong>Đối tượng tống đạt</strong></div>
                                                            </td>
                                                            <td width="60px">
                                                                <div align="center"><strong>Ngày gửi</strong></div>
                                                            </td>
                                                            <td width="50px">
                                                                <div align="center"><strong>Hình thức gửi</strong></div>
                                                            </td>
                                                            <td width="40px"></td>
                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td width="15px" style="text-align: center;">
                                                            <asp:HiddenField ID="hddID" runat="server" Value='<%#Eval("ID") %>' />
                                                            <asp:HiddenField ID="hddDoiTuong" runat="server" Value='<%#Eval("DOITUONG") %>' />
                                                            <asp:HiddenField ID="hddTrangThai" runat="server" Value='<%#Eval("TRANGTHAI") %>' />
                                                            <asp:HiddenField ID="hddBoSung" runat="server" Value='<%#Eval("ISBOSUNG") %>' />
                                                            <asp:HiddenField ID="hddPhatHanhLaiID" runat="server" Value='<%#Eval("PHATHANHLAI_ID") %>' />
                                                            <%# Container.ItemIndex + 1 %></td>
                                                        <td>
                                                            <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                runat="server" Text='<%#Eval("NOINHAN") %>'></asp:TextBox></td>
                                                        <td>
                                                            <asp:TextBox ID="txtTCTT" Width="96%" CssClass="user"
                                                                runat="server" Text='<%#Eval("TUCACHTOTUNG") %>'></asp:TextBox></td>
                                                        <td>
                                                            <asp:TextBox ID="txtDiaChi" Width="96%" CssClass="user"
                                                                runat="server" Text='<%#Eval("DIACHI") %>'></asp:TextBox></td>
                                                        <td align="center">
                                                             <asp:CheckBox ID="chkTongDat" runat="server" Checked='<%#Convert.ToBoolean(Eval("CHECKTONGDAT")) %>'/>
                                                        </td>
                                                        <td align="center">
                                                            <asp:TextBox ID="txtNgaygui" Visible='<%# GetNumber(Eval("HINHTHUCGUI"))%>' runat="server" Text='<%# GetTextDate(Eval("NGAYGUI"))%>' CssClass="user" Width="68px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="txtNgaygui_CalendarExtender" runat="server" TargetControlID="txtNgaygui" Format="dd/MM/yyyy" />
                                                            <cc1:MaskedEditExtender ID="txtNgaygui_MaskedEditExtender3" runat="server" TargetControlID="txtNgaygui" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" />
                                                        <td>
                                                             <asp:DropDownList ID="dropHinhThucGui" CssClass="user chosen-select" runat="server" Width="130" AutoPostBack="true" OnSelectedIndexChanged="dropHinhThucGui_SelectedIndexChanged">
                                                                <%--<asp:ListItem Value="2" Text="Qua bưu điện" Selected="True"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Thừa phát lại"></asp:ListItem>
                                                                <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                                <asp:ListItem Value="5" Text="Niêm yết công khai"></asp:ListItem>--%>
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td>
                                                            <div class="tooltip" style="margin-top:3px;">
                                                                <asp:ImageButton ID="cmdAdd" runat="server" ToolTip="Thêm" CssClass="grid_button" Visible="false"
                                                                    CommandName="Them" CommandArgument='<%# Container.ItemIndex%>'
                                                                    ImageUrl="~/UI/img/new.png" Width="18px" />
                                                                <span class="tooltiptext  tooltip-bottom">Thêm</span>
                                                            </div>
                                                            <div class="tooltip" style="margin-top:3px;">
                                                                <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button" Visible="false"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                    ImageUrl="~/UI/img/delete.png" Width="17px"
                                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                                <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </asp:Panel>
                                        <asp:Panel  ID="pnDonVi" runat="server">
                                            <asp:Repeater ID="rptDonVi" runat="server" OnItemCommand="rptDonVi_ItemCommand" OnItemDataBound="rptDonVi_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table class="table2" width="100%" border="1">
                                                        <tr class="header">
                                                            <td width="42">
                                                                <div align="center"><strong>STT</strong></div>
                                                            </td>                                                           
                                                            <td width="260px">
                                                                <div align="center"><strong>Tên đơn vị</strong></div>
                                                            </td>
                                                            <td width="250px">
                                                                <div align="center"><strong>Địa chỉ</strong></div>
                                                            </td>
                                                            <td width="50px">
                                                                <div align="center"><strong>Đối tượng tống đạt</strong></div>
                                                            </td>
                                                            <td width="60px">
                                                                <div align="center"><strong>Ngày gửi</strong></div>
                                                            </td>
                                                            <td width="80px">
                                                                <div align="center"><strong>Hình thức gửi</strong></div>
                                                            </td>
                                                            <td width="40px"></td>
                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td width="15px" style="text-align: center;">
                                                            <asp:HiddenField ID="hddID" runat="server" Value='<%#Eval("ID") %>' />
                                                            <asp:HiddenField ID="hddDoiTuong" runat="server" Value='<%#Eval("DOITUONG") %>' />
                                                            <asp:HiddenField ID="hddTrangThai" runat="server" Value='<%#Eval("TRANGTHAI") %>' />
                                                            <asp:HiddenField ID="hddBoSung" runat="server" Value='<%#Eval("ISBOSUNG") %>' />
                                                            <asp:HiddenField ID="hddPhatHanhLaiID" runat="server" Value='<%#Eval("PHATHANHLAI_ID") %>' />
                                                            <%# Container.ItemIndex + 1 %></td>
                                                        <td>
                                                            <asp:TextBox ID="txtTenDonVi" Width="96%" CssClass="user"
                                                                runat="server" Text='<%#Eval("NOINHAN") %>'></asp:TextBox>
                                                            <asp:HiddenField ID="hddDonViID" runat="server" Value='<%#Eval("NOINHANID") %>' /> 
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtDiaChi" Width="96%" CssClass="user"
                                                                runat="server" Text='<%#Eval("DIACHI") %>'></asp:TextBox></td>
                                                        <td align="center">
                                                             <asp:CheckBox ID="chkTongDat" runat="server" Checked='<%#Convert.ToBoolean(Eval("CHECKTONGDAT")) %>'/>
                                                        </td>
                                                        <td align="center">
                                                            <asp:TextBox ID="txtNgaygui" Visible='<%# GetNumber(Eval("HINHTHUCGUI"))%>' runat="server" Text='<%# GetTextDate(Eval("NGAYGUI"))%>' CssClass="user" Width="68px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="txtNgaygui_CalendarExtender" runat="server" TargetControlID="txtNgaygui" Format="dd/MM/yyyy" />
                                                            <cc1:MaskedEditExtender ID="txtNgaygui_MaskedEditExtender3" runat="server" TargetControlID="txtNgaygui" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" />
                                                        </td>
                                                        <td>
                                                             <asp:DropDownList ID="dropHinhThucGui" CssClass="user chosen-select" runat="server" Width="130" AutoPostBack="true" OnSelectedIndexChanged="dropHinhThucGui_SelectedIndexChanged">
                                                                <%--<asp:ListItem Value="2" Text="Qua bưu điện" Selected="True"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Thừa phát lại"></asp:ListItem>
                                                                <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                                <asp:ListItem Value="5" Text="Niêm yết công khai"></asp:ListItem>--%>
                                                            </asp:DropDownList> 
                                                        </td>
                                                        <td>
                                                            <div class="tooltip" style="margin-top:3px;">
                                                                <asp:ImageButton ID="cmdAdd" runat="server" ToolTip="Thêm" CssClass="grid_button" Visible="false"
                                                                    CommandName="Them" CommandArgument='<%#Eval("ID") %>'
                                                                    ImageUrl="~/UI/img/new.png" Width="18px" />
                                                                <span class="tooltiptext  tooltip-bottom">Thêm</span>
                                                            </div>
                                                            <div class="tooltip" style="margin-top:3px;">
                                                                <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button" Visible="false"
                                                                    CommandName="Xoa" CommandArgument='<%# Container.ItemIndex%>'
                                                                    ImageUrl="~/UI/img/delete.png" Width="17px"
                                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                                <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div style="text-align: center; margin-top: 5px;">
                                            <asp:Button ID="cmdPhatHanh" runat="server" CssClass="buttoninput" Text="Phát hành" OnClick="cmdPhatHanh_Click" />
                                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click"/>
                                            <input type="button" class="buttoninput" onclick="ReloadParent();" value="Hủy" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:HiddenField ID="hddID" Value="0" runat="server" />
                                        <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="boxchung">
                        <h4 class="tleboxchung">Các văn bản đã phát hành</h4>                    
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <div>
                                            <div style="float: left; width: 45px; text-align: left; margin-right: 10px; margin-top:5px;">Ngày<span class="must_input">(*)</span></div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtNgayThuHoi" runat="server" CssClass="user" Width="120px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayThuHoi" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayThuHoi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </div>
                                            <div style="float: left; width: 60px; text-align: left; margin-left: 20px; margin-top:5px;">Lý do<span class="must_input">(*)</span></div>
                                            <div style="float: left;">
                                                <asp:TextBox ID="txtLyDo" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                            </div>
                                            <div style="float: left; width: 95px; text-align: left; margin-left: 20px;">
                                                <asp:Button ID="cmdThuHoi" runat="server" CssClass="buttoninput" Text="Thu hồi" OnClick="cmdThuHoi_Click"/>
                                            </div>
                                            <div style="float: left;">
                                                <asp:Label runat="server" ID="lbThongbao" ForeColor="Red" Font-Size="13px"></asp:Label>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>                                        
                                        <div style="float: left; width: 95px; text-align: left;">
                                            <asp:Button ID="btnPHBS" runat="server" CssClass="buttoninput" Text="Phát hành bổ sung" OnClick="btnPHBS_Click"/>
                                        </div>
                                        <div style="float: left; width: 95px; text-align: left; margin-left: 60px;">
                                            <asp:Button ID="btnSua" runat="server" CssClass="buttoninput" Text="Sửa" OnClick="btnSua_Click"/>
                                        </div>
                                        <div style="float: left; width: 95px; text-align: left;">
                                            <asp:Button ID="btnXoa" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnXoa_Click"/>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                           
                            <asp:DataGrid ID="dgDS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" OnItemCommand="dgDS_ItemCommand" OnItemDataBound="dgDS_ItemDataBound">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkThuHoi" AutoPostBack="true" ToolTip='<%#Eval("TONGDAT_GDKT_ID")%>' runat="server" />
                                            <asp:HiddenField ID="hddID" runat="server" Value='<%# Eval("TONGDAT_GDKT_ID") %>'/>
                                            <asp:HiddenField ID="hddHasSua" runat="server" Value='<%# Eval("HASSUA") %>'/>
                                            <asp:HiddenField ID="hddHasThuHoi" runat="server" Value='<%# Eval("HASTHUHOI") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            TT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                           <%-- <%# Container.DataSetIndex + 1 %>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="TENVANBAN" HeaderText="Tên văn bản" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="160px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NOINHAN" HeaderText="Nơi nhận" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="200px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYGUI" HeaderText="Ngày gửi" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYPHATHANH" HeaderText="Ngày phát hành" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="TRANGTHAI" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                         <%--   <asp:HiddenField ID="hddHasSua" runat="server" Value='<%# Eval("HASSUA") %>' />--%>
                                            <%--<div class="tooltip">
                                                <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa" CssClass="grid_button"
                                                    CommandName="Sua" CommandArgument='<%#Eval("TONGDAT_GDKT_ID") %>'
                                                    ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                <span class="tooltiptext  tooltip-bottom">Sửa</span>
                                            </div>
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("TONGDAT_GDKT_ID") %>'
                                                    ImageUrl="~/UI/img/delete.png" Width="17px"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                            </div>--%>
                                            <div class="tooltip">
                                                <asp:LinkButton ID="cmdPhatHanhLai" Visible="false" runat="server" Text="Phát hành lại" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                CommandName="PhatHanhLai" CommandArgument='<%#Eval("ID") +"#"+ Convert.ToInt16( Eval("TONGDAT_GDKT_ID")+"")%>'></asp:LinkButton>
                                            </div>
                                            <div class="tooltip">
                                                <asp:LinkButton ID="cmdVBHDSua" Visible="false" runat="server" Text="VBĐH sửa" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                CommandName="VBDH_SUA" CommandArgument='<%#Eval("ID") +"#"+ Convert.ToInt16( Eval("TONGDAT_GDKT_ID")+"") %>'></asp:LinkButton>
                                            </div>
                                            <div class="tooltip">
                                                <asp:LinkButton ID="cmdVBDHDong" Visible="false" runat="server" Text="VBĐH đang sửa" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                CommandName="VBDH_DONG" CommandArgument='<%#Eval("ID") +"#"+ Convert.ToInt16( Eval("TONGDAT_GDKT_ID")+"")%>'></asp:LinkButton>
                                            </div>
                                            <%--<div class="tooltip">                                                
                                                <asp:ImageButton ID="cmdPHBS" runat="server" ToolTip="Phát hành bổ sung" CssClass="grid_button"
                                                    CommandName="PHBS" CommandArgument='<%#Eval("TONGDAT_GDKT_ID") %>'
                                                    ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                <span class="tooltiptext  tooltip-bottom">Phát hành bổ sung</span>
                                            </div>--%>
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
                </div>
                <script>
                    function ReloadParent() {
                        OnClose();
                    }
                </script>
                <script type="text/javascript">
                    function OnClose() {
                        if (window.opener != null && !window.opener.closed) {
                            window.opener.HideModalDiv();
                        }
                        window.close();
                    }
                    window.onunload = OnClose;
                </script>

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>


