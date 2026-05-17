<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pDsDonAnGiam.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.AnTH.pDsDonAnGiam" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Danh sách đơn</title>
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
            <h4 class="tleboxchung">Danh sách đơn nhận tự HCTP Văn phòng</h4>
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
                                                     
                                                </div>
                                                  
                                            </div>
                                             
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn> 
                                      <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                        <ItemTemplate>
                                         
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
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
        <asp:Panel ID="pnDonVu1" runat="server">
                <div class="boxchung">
            <h4 class="tleboxchung">Đơn do Vụ Giám đốc kiểm tra nhận</h4>
            <div class="boder" style="padding: 10px;">
                    <asp:DataGrid ID="dgDSDonVu1" runat="server" AutoGenerateColumns="False" CellPadding="4"
                     PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan"  OnItemCommand="dgDon_ItemCommand" >
                                <Columns>
                                     <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateColumn>
                                    
                                    <asp:BoundColumn DataField="NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYTRENDON" HeaderText="Ngày ghi trên đơn" HeaderStyle-Width="60px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="220px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người gửi</HeaderTemplate>
                                        <ItemTemplate>
                                           <b> <%#Eval("NGUOIGUI") %></b><br />
                                          <i><%#Eval("NGUOIGUI_DIACHI") %></i> 
                                            <br />
                                            <i><%#Eval("NOIDUNG") %></i> 
                                                                                       
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>                                    
                                   <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>Nơi chuyển đến</HeaderTemplate>
                                        <ItemTemplate>
                                            <b>Vụ Giám đốc kiểm tra 1 nhận đơn</b>                              
                                              <br />
                                            <div style='width: 100%;''>
                                                <div style='width: 100%;''>
                                                    <div style='width: 100%;''>
                                                    <i>Cán bộ nhận</i>:
                                                    <b><%#Eval("hoten") %></b>
                                                        </div>
                                                    
                                                  </div>
                                                </div> 
                                            </div>   
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn> 
                                      <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                        <ItemTemplate>
                                
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>   
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid> 
            </div>
        </div>
        </asp:Panel>
       
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
