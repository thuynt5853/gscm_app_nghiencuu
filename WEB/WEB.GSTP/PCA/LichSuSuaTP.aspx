<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LichSuSuaTP.aspx.cs" Inherits="WEB.GSTP.PCA.LichSuSuaTP" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
    <title>Lịch sử sửa phẩm phán</title>
</head>
<body>
    <form id="form1" runat="server">
         <div style="width:1000px; height:400px;">             
             <div>                           
                 <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%">
                                    <Columns>
                                       
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                STT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("RNUM")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>   
                                         <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TEN_VU_AN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>                                           
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thẩm phán
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("THAM_PHAN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>                              
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ngày sửa
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGAY_SUA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn> 
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Người sửa
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("HOTEN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>   
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Lý do
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                 <%#Eval("LY_DO")%>
                                            </ItemTemplate>                                 
                                        </asp:TemplateColumn> 
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
             </div>
        </div>
    </form>
</body>
    <script src="/UI/js/init.js"></script>
</html>
