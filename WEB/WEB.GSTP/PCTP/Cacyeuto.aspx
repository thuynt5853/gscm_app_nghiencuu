<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Cacyeuto.aspx.cs" Inherits="WEB.GSTP.PCTP.Cacyeuto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="box">
    <div class="box_nd">
         <div class="boxchung">
                    <h4 class="tleboxchung">Các yếu tố chi phối kết quả phân công ngẫu nhiên</h4>
                    <div class="boder" style="padding: 10px;">
                      <table class="table1"> 
                <tr>
                    <td colspan="2">                           
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                               >
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>   
                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            TT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                           <%# Container.DataSetIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>   
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="40%" >
                                        <HeaderTemplate>
                                            Nội dung
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NOIDUNG") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                           Kết quả
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("DIENGIAI") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>                                   
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>
                          
                    </td>
                </tr>            
            </table>
                    </div>
                </div>

      
    </div>
</div>
    
</asp:Content>