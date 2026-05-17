<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lichsudon.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.Lichsudon" %>


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

        .Lable_Popup_Add_VV {
            width: 117px;
        }

        .Input_Popup_Add_VV {
            width: 250px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <div class="boxchung">
            <h4 class="tleboxchung">Danh sách đơn trùng</h4>
            <div class="boder" style="padding: 10px;">                
                <table class="table1">  
                    <tr>
                        <td>
                              <asp:DataGrid ID="dgDon" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan"  OnItemCommand="dgDon_ItemCommand" >
                                <Columns>
                                     <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="SOHIEUDON" HeaderText="Số hiệu" HeaderStyle-Width="50px" ></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYNHANDON" HeaderText="Ngày nhận" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYGHITRENDON" HeaderText="Ngày ghi trên đơn" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="220px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người gửi</HeaderTemplate>
                                        <ItemTemplate>
                                           <b> <%#Eval("DONGKHIEUNAI") %></b><br />
                                          <i><%#Eval("Diachigui") %></i>               
                                             <br />                                             
                                            <%# (Eval("arrCongvan")+"")=="" ? "":"(" + Eval("arrCongvan") + ")" %>  
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>                                    
                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>Nơi chuyển đến</HeaderTemplate>
                                        <ItemTemplate>
                                            <b style="color:#0e7eee;"><%#Eval("TRANGTHAICHUYEN") %>:</b></i>  <b><%#Eval("NOICHUYEN") %></b> <i>(Số <%#Eval("CD_SOCV") %> - <%# GetDate(Eval("CD_NGAYCV")) %>)</i>                              
                                              <br />
                                            <div style='width: 100%; display: <%#Eval("IsShowNB") %>'>
                                                <div style='width: 100%; display: <%#Eval("IsShowDDK") %>'>
                                                    <div style='width: 100%; display: <%#Eval("IsShowTLMOI") %>'>
                                                    <b>Thụ lý mới</b><br />
                                                    <i>Số: </i><%#Eval("TL_SO") %> - <%# GetDate(Eval("TL_NGAY")) %>
                                                    <br />
                                                    <i>Thẩm phán</i><br />
                                                    <b><%#Eval("TENTHAMPHAN") %></b>
                                                        </div>
                                                     <div style='width: 100%; display: <%#Eval("IsShowDATL") %>'>
                                                      <b>Đã thụ lý</b>
                                                  </div>
                                                </div>
                                                  <div style='width: 100%; display: <%#Eval("IsShowCDDK") %>'>
                                                      <b>Đơn chưa đủ điều kiện</b>
                                                        <i>TB YCBS số: </i><%#Eval("TB1_SO") %> &nbsp;<i>Ngày: </i><%# GetDate(Eval("TB1_NGAY")) %> </b>
                                                  </div>
                                            </div>
                                             <div style='width: 100%; display: <%#Eval("IsShowTK") %>'>
                                                 <b>Chuyển đơn</b>
                                             </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn> 
                                      <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                        <ItemTemplate>
                                          <%#Eval("CV_TRALOI_NOIDUNG") %>    
                                            <br />
                                          <i>Ghi chú: </i>  <%#Eval("GHICHU") %>
                                                                             
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>   
                                  
                                     <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Hủy trùng</HeaderTemplate>
                                        <ItemTemplate>
                                           <div class="tooltip">
                                                    <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Hủy trùng đơn" CssClass="grid_button"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                        ImageUrl="~/UI/img/delete.png" Width="17px"
                                                        OnClientClick="return confirm('Bạn thực sự muốn hủy trùng đơn? ');" />
                                                    <span class="tooltiptext  tooltip-bottom">Hủy trùng</span>
                                                </div>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:Panel ID="pnBoSung" runat="server">
                <div class="boxchung">
            <h4 class="tleboxchung">Quá trình bổ sung tài liệu</h4>
            <div class="boder" style="padding: 10px;">
                    <asp:DataGrid ID="dgDS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" >
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
        </asp:Panel>
        <div class="boxchung" style="display:none;">
            <h4 class="tleboxchung">Lịch sử đơn</h4>
            <div class="boder" style="padding: 10px;">                
                <table class="table1">                   
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                              <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan">
                                <Columns>
                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>Đơn vị chuyển</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("PHONGBANCHUYEN") %> - <%#Eval("TENTOACHUYEN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>Đơn vị nhận</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("PHONGBANNHAN") %> - <%#Eval("TENTOANHAN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="NGAYCHUYEN" HeaderText="Ngày chuyển" HeaderStyle-Width="90px" DataFormatString="{0:dd/MM/yyyy HH:MM}"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-Width="90px" DataFormatString="{0:dd/MM/yyyy HH:MM}"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="TENTRANGTHAI" HeaderText="Trạng thái" HeaderStyle-Width="90px" ></asp:BoundColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
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
