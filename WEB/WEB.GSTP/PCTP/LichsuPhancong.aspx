<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="LichsuPhancong.aspx.cs" Inherits="WEB.GSTP.PCTP.LichsuPhancong" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<div class="box">
    <div class="box_nd">
         <div class="boxchung">
                    <h4 class="tleboxchung">Lịch sử phân công ngẫu nhiên</h4>
                    <div class="boder" style="padding: 10px;">
                      <table class="table1"> 
                <tr>
                    <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
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
                                   <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="115px" HeaderStyle-HorizontalAlign="Center"  DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>     
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px" >
                                        <HeaderTemplate>
                                            Người thực hiện
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("HOTEN") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                           Loại phân công
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENLOAIPHANCONG") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:BoundColumn DataField="TUNGAY" HeaderText="Ngày nhận đơn từ" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                      <asp:BoundColumn DataField="DENNGAY" HeaderText="Đến ngày" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            
                                            <a style="color:#0e7eee;cursor:pointer;" onclick='popup_in(<%#Eval("ID") %>)'>In danh sách</a>

                                          </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:HiddenField ID="hdicha" runat="server" />
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                    </td>
                </tr>            
            </table>
                    </div>
                </div>

      
    </div>
</div>
     <script type="text/javascript">
                                function popup_in(ID) {                                  
                                    var link = "/BaoCao/PCTP/ViewReport.aspx?cid=" + ID;
                                        var width = 1100;
                                        var height = 700;
                                        PopupReport(link, "Phân công thẩm phán giải quyết đơn", width, height);
                                }
                                function PopupReport(pageURL, title, w, h) {
                                   var left = (screen.width / 2) - (w / 2);
                                    var top = (screen.height / 2) - (h / 2);
                                    //OpenPopUpPage(pageURL, null, w, h);
                                    var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                                   return targetWin;
                               }
                            </script>
</asp:Content>
