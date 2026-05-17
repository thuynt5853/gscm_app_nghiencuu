<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pDsVuan.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.AnTH.pDsVuan" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vụ án</title>
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
            <h4 class="tleboxchung">Danh sách Các vụ án</h4>
            <div class="boder" style="padding: 10px;">                
                <table class="table1">  
                    <tr>
                        <td>
                            <asp:DataGrid ID="dgDsVuan" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="10" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan"  OnItemCommand="dgDsVuan_ItemCommand"  OnItemDataBound="dgDsVuan_ItemDataBound">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="60px">
                                       <HeaderTemplate>                   
                                       </HeaderTemplate>
                                       <ItemTemplate>
                                            <asp:Button ID="cmdChonVuan" runat="server" Text="Chọn" CssClass="buttonchitiet" CausesValidation="false" CommandName="Select" CommandArgument='<%#Eval("vuanid")%>' />  
                                       </ItemTemplate>
                                       <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                       <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%# Container.ItemIndex + 1 %></ItemTemplate>

                                    </asp:TemplateColumn>
                                   <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM", "{0:dd/MM/yyyy}")%>
                                            <br />
                                            <%#Eval("TOAXETXU")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="60px" ></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="60px" ></asp:BoundColumn>

                                    <asp:BoundColumn DataField="TOIDANH" HeaderText="Tội danh" HeaderStyle-Width="60px" ></asp:BoundColumn>
                                   <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo Vụ<br />
                                            Thẩm phán
                                               
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMTRAVIEN")+"")? "":("TTV:<b style='margin-left:3px;'>"+Eval("TENTHAMTRAVIEN")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( Eval("MaChucVuLD") + ":<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b>")%>
                                        </ItemTemplate>
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
    <script>
         function ReloadParent() {
                window.onunload = function (e) {
                    opener.LoadThemmoiDon();
                    window.close();
                };
                // window.close();
        }
        </script>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
