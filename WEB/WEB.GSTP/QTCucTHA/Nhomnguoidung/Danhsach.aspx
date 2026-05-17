<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QTCucTHA.Nhomnguoidung.Danhsach" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<div class="box">
   
    <div class="box_nd">
        <div class="truong">
            <table class="table1">
             
                <tr>
                    <td style="width: 150px;" align="left">
                        <b>Loại đơn vị</b>
                    </td>
                    <td align="left" >
                        <asp:DropDownList  CssClass="chosen-select"  ID="ddlDonvi" runat="server" Width="500px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;" align="left">
                        <b>Tên nhóm</b>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtTennhom" CssClass="user" runat="server" Width="90%"></asp:TextBox>
                    </td>
                </tr>             
               
                <tr>
                    <td colspan="2" align="left">
                   <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;" align="left">
                    </td>
                    <td align="left" >
                          <asp:Button ID="cmdTimkiem" runat="server" cssclass="buttoninput" Text="Tìm kiếm"  onclick="lbtimkiem_Click"  />
                                
                          <asp:Button ID="cmdThemmoi" runat="server" cssclass="buttoninput" Text="Thêm mới"  onclick="btnThemmoi_Click"  />
                    </td>
                </tr>
                <tr>
                <td colspan="2" align="left">
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                           <asp:LinkButton ID="lbTBack" Visible="false" runat="server" CausesValidation="false" CssClass="back"  onclick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" Visible="false"  runat="server" CausesValidation="false" CssClass="active" Text="1"  onclick="lbTFirst_Click"></asp:LinkButton>						
                            <asp:Label ID="lbTStep1" Visible="false"  runat="server"   Text="..."   ></asp:Label>
                            <asp:LinkButton ID="lbTStep2" Visible="false"  runat="server" CausesValidation="false" CssClass="so" Text="2"   onclick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3"  Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="3"  onclick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" Visible="false"  runat="server" CausesValidation="false" CssClass="so" Text="4"  onclick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5"  Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="5"  onclick="lbTStep_Click"></asp:LinkButton>
							<asp:Label ID="lbTStep6" Visible="false"  runat="server"    Text="..."  ></asp:Label>
                            <asp:LinkButton ID="lbTLast" Visible="false"  runat="server" CausesValidation="false" CssClass="so" Text="100"  onclick="lbTLast_Click"></asp:LinkButton>
							<asp:LinkButton ID="lbTNext"  Visible="false" runat="server" CausesValidation="false" CssClass="next"  onclick="lbTNext_Click"></asp:LinkButton>
					
                        </div>
                    </div>
                    <div>
                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%"
                            OnItemCommand="dgList_ItemCommand">
                            <Columns>
                                <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                <asp:TemplateColumn ItemStyle-Width="40px" HeaderStyle-Width="40px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        STT
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                       <%# Container.ItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn ItemStyle-Width="300px" HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Tên nhóm
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TEN")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                       Loại đơn vị
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TENDONVI")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="250px"  HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thao tác
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                         <asp:LinkButton ID="lbPhanquyen" runat="server" Text="Phân quyền"  ForeColor="#0e7eee" CausesValidation="false" CommandName="Phanquyen"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        &nbsp;&nbsp;
                                        <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua"  ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa"  ForeColor="#0e7eee"
                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa nhóm này? ');"></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" ></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateColumn>
                            </Columns>
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        </asp:DataGrid>
                    </div>
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack"  Visible="false" runat="server" CausesValidation="false" CssClass="back" onclick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst"  Visible="false" runat="server" CausesValidation="false" CssClass="active" Text="1"  onclick="lbTFirst_Click"></asp:LinkButton>						
                            <asp:Label ID="lbBStep1" Visible="false"  runat="server" Text="..." ></asp:Label>
                            <asp:LinkButton ID="lbBStep2"  Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="2" onclick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3"  Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="3" onclick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4"  Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="4" onclick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5"  Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="5"  onclick="lbTStep_Click"></asp:LinkButton>
							<asp:Label ID="lbBStep6"  Visible="false"  runat="server" Text="..." ></asp:Label>
                            <asp:LinkButton ID="lbBLast"  Visible="false" runat="server" CausesValidation="false" CssClass="so" Text="100" onclick="lbTLast_Click"></asp:LinkButton>
							<asp:LinkButton ID="lbBNext"  Visible="false" runat="server" CausesValidation="false" CssClass="next"  onclick="lbTNext_Click"></asp:LinkButton>
						
                        </div>
                    </div>                
                </td>
                </tr>
            </table>
        </div>
    </div>
</div>
      <script type="text/javascript">          
        function pageLoad(sender, args) {       
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
