<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DSDonChidao.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.DSDonChidao" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lãnh đạo chỉ đạo</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
     <style>
        body {
            width: 96%;
            margin-left: 2%;
            min-width: 0px;
            padding-top: 5px;
        }

        .tleboxchung {
            padding: 5px 5px;
            top: 5px;
            border: solid 0px #a2c2a8;
        }
    </style>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
           <div class="box">
                  <div class="boder" style="padding: 2%; width: 96%;">
                  <table class="table1">
                        <tr>
                            <td style="width:100px;">Nguyên đơn
                            </td>
                            <td >
                                <asp:TextBox ID="txtNguyendon" Enabled="false" CssClass="user" runat="server" Width="99%" ></asp:TextBox>
                            </td>
                        </tr>  
                      <tr>
                            <td>Bị đơn
                            </td>
                            <td >
                                <asp:TextBox ID="txtBidon" Enabled="false" CssClass="user" runat="server" Width="99%" ></asp:TextBox>
                            </td>
                        </tr>  
                       <tr>
                            <td>Quan hệ pháp luật
                            </td>
                            <td >
                                <asp:TextBox ID="txtQHPL" Enabled="false" CssClass="user" runat="server" Width="99%" ></asp:TextBox>
                            </td>
                        </tr>  
                    <tr>
                        <td colspan="2">
                              <asp:DataGrid ID="dgDon" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%" >
                                <Columns>
                                     <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateColumn>
                                   <asp:BoundColumn DataField="TENLANHDAO" HeaderText="Lãnh đạo" HeaderStyle-Width="170px" ></asp:BoundColumn>
                                    <asp:BoundColumn DataField="CHIDAO_NOIDUNG" HeaderText="Nội dung chỉ đạo"  ></asp:BoundColumn>
                                     <asp:BoundColumn DataField="NGAYNHANDON" HeaderText="Ngày nhận đơn" HeaderStyle-Width="70px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGAYGHITRENDON" HeaderText="Ngày ghi trên đơn" HeaderStyle-Width="70px" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                   
                                    <asp:TemplateColumn HeaderStyle-Width="170px"  HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ghi chú</HeaderTemplate>
                                        <ItemTemplate>
                                          <%#Eval("GHICHU") %>                                                                             
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
       
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>