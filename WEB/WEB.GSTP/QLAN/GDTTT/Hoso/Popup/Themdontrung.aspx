<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="Themdontrung.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.Themdontrung" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thêm mới đơn trùng</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>   
</head>
       <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

         .DonGDTCol1 {
            width: 110px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 70px;
        }

        .DonGDTCol4 {
            width: 90px;
        }

        .DonGDTCol5 {
            width: 60px;
        }
    </style>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>   
           <div class="boxchung">
            <h4 class="tleboxchung">Thông tin đơn</h4>
            <div class="boder" style="padding: 10px;">         
                <table class="table1">                   
                     <tr>
                        <td class="DonGDTCol1">Người gửi đơn</td>
                        <td class="DonGDTCol2">
                            <asp:TextBox ID="txtNguoigui" runat="server" Enabled="false" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox> </td>
                        <td class="DonGDTCol3">Số BA/QĐ</td>
                        <td class="DonGDTCol4">
                            <asp:TextBox ID="txtSoQDBA" runat="server"  Enabled="false" CssClass="user" Width="82px" MaxLength="50"></asp:TextBox>
                        </td>
                         <td class="DonGDTCol5">Ngày</td>
                        <td>
                            <asp:TextBox ID="txtNgayBAQD" runat="server"  Enabled="false" CssClass="user" Width="112px" MaxLength="10"></asp:TextBox>                            
                        </td>
                         </tr>
                    <tr>
                        <td>Tòa ra BA/QĐ</td>
                        <td colspan="5"><asp:TextBox ID="txtToaXX" runat="server"  Enabled="false" CssClass="user" Width="608px" MaxLength="250"></asp:TextBox></td>
                        
                    </tr>
                  <tr>
                      <td>
                          Số lượng trùng
                      </td>
                      <td colspan="5">
                           <asp:DropDownList ID="ddlSoLuong" CssClass="chosen-select" runat="server" Width="230px" AutoPostBack="True" OnSelectedIndexChanged="ddlSoLuong_SelectedIndexChanged"></asp:DropDownList>
                      </td>
                  </tr>
                  
                     
                    <tr>
                        <td colspan="6">
                            <div style="width:100%;">
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan"   OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="TT"  HeaderStyle-Width="20px" HeaderText="STT" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>                                    
                                    <asp:TemplateColumn HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số hiệu đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtSohieudon" runat="server" Text='<%# Eval("SOHIEUDON")%>' CssClass="user" Width="60px" MaxLength="10"></asp:TextBox>                                           
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                   <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày nhận đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgaynhandon" runat="server" Text='<%# Eval("NGAYNHANDON")%>' CssClass="user" Width="75px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="txtNgaynhandon_CalendarExtender" runat="server" TargetControlID="txtNgaynhandon" Format="dd/MM/yyyy" />
                                            <cc1:MaskedEditExtender ID="txtNgaynhandon_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhandon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày ghi trên đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgayghitrendon" runat="server" Text='<%# Eval("NGAYGHIDON")%>' CssClass="user" Width="75px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="txtNgayghitrendon_CalendarExtender" runat="server" TargetControlID="txtNgayghitrendon" Format="dd/MM/yyyy" />
                                            <cc1:MaskedEditExtender ID="txtNgayghitrendon_MaskedEditExtender3" runat="server" TargetControlID="txtNgayghitrendon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Công văn?</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkIsCV" runat="server"  AutoPostBack="true" Checked='<%# GetNumber(Eval("HINHTHUCDON"))%>'
                                                     ToolTip='<%#Eval("TT")%>'    OnCheckedChanged="chkIsCV_CheckedChanged" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số công văn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtSoCV" Visible="false" runat="server"  CssClass="user" Width="65px" MaxLength="50"></asp:TextBox>                                           
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ngày CV</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgayCV"  Visible="false"  runat="server" Text='<%# Eval("NGAYGHIDON")%>' CssClass="user" Width="75px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="txtNgayCV_CalendarExtender" runat="server" TargetControlID="txtNgayCV" Format="dd/MM/yyyy" />
                                            <cc1:MaskedEditExtender ID="txtNgayCV_MaskedEditExtender3" runat="server" TargetControlID="txtNgayCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trong ngành?</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkIsTrongnganh" Visible="false" runat="server"   AutoPostBack="true" Checked='<%# GetNumber(Eval("LOAIDONVI"))%>'
                                                     ToolTip='<%#Eval("TT")%>'    OnCheckedChanged="chkIsTrongnganh_CheckedChanged" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                       <asp:TemplateColumn HeaderStyle-Width="250px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Đơn vị gửi  </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtDonvi"  Visible="false" runat="server"  CssClass="user" Width="242px" MaxLength="250"></asp:TextBox>                                           
                                            <asp:DropDownList ID="ddlDonvi"  Visible="false" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                                </div>
                        </td>
                    </tr>     
                      <tr>
                        <td colspan="6">
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>  
                    <tr>
                      <td colspan="6" align="center">
                          <asp:Button ID="cmdLuu" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu danh sách" OnClick="cmdLuu_Click" />
                      </td>
                  </tr>
                </table>
           </div>
               </div>
    </form>
</body>
    <script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
