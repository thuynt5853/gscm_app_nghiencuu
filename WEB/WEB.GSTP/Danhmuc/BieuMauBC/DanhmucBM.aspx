<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DanhmucBM.aspx.cs" Inherits="WEB.GSTP.Danhmuc.BieuMauBC.Danhmuc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="Hddsize" Value="20" runat="server" />
    <style>
        .distance_page {
            padding-top: 20px;
        }
    </style>

    <div>
        <div class="distance_page">
        </div>
        <table class="table1">
            <tr>
                <td colspan="4">
                    <table style="width: 100%; margin-top: 25px;">                       
                        <tr>
                            <td style="width:270px">
                                <asp:TextBox runat="server" ID="txttimkiem" Width="90%" CssClass="user" placeholder="Mã tên,tên biểu mẫu:"></asp:TextBox>  </td>
                                <td style="width:150px; float:left"><asp:DropDownList ID="droploaian" class="check" runat="server" CssClass="chosen-select"></asp:DropDownList>

                                </td>
                                <td style="float:left; width:100px"><asp:DropDownList ID="dropHieuLuc" class="check" runat="server" CssClass="chosen-select"></asp:DropDownList></td>
                           
                                <td style="float:left; padding-left:10px;">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
                                <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="BtnThemmoi_Click" />
                                </td>
                          

                        </tr>
                    </table>
                    <%--view--%>
                    <asp:Panel runat="server" ID="pndata" Visible="false">
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
                            AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%"
                            OnItemCommand="dgList_ItemCommand">
                            <Columns>
                                <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                <asp:TemplateColumn HeaderStyle-Width="30px"  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thứ tự
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtThuTu" runat="server" Text='<%#Eval("THUTU")%>' CssClass="user align_right" Width="30px" MaxLength="3" onkeypress="return isNumber(event)"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="50px"  HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Mã biểu mẫu
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("MABM")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Tên biểu mẫu vụ án
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TENBM") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Mã Quyết định
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("MAQD") %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>

                                   <asp:TemplateColumn HeaderText="Hồ sơ?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkHoso"  runat="server"   Checked='<%# GetNumber(Eval("ISHOSO"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderText="Sơ thẩm?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkSotham"  runat="server"   Checked='<%# GetNumber(Eval("ISSOTHAM"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderText="Phúc thẩm?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkPhuctham" runat="server"   Checked='<%# GetNumber(Eval("ISPHUCTHAM"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderText="GĐT, TT?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkGDT"  runat="server"   Checked='<%# GetNumber(Eval("ISGDTTT"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>

                                  <asp:TemplateColumn HeaderText="TĐ tới người khởi kiện?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkNguyendon" runat="server"   Checked='<%# GetNumber(Eval("IS_TD_NGUYENDON"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                 <asp:TemplateColumn HeaderText="TĐ tới đương sự?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkDuongsu"  runat="server"   Checked='<%# GetNumber(Eval("IS_TD_DUONGSU"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                 <asp:TemplateColumn HeaderText="TĐ tới VKS?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkVKS"  runat="server"   Checked='<%# GetNumber(Eval("IS_TD_VKS"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="In biểu mẫu?"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkPrint"  runat="server"   Checked='<%# GetNumber(Eval("ISPRINT"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="Hiệu lực"  HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">                                              
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkHieuluc"  runat="server"   Checked='<%# GetNumber(Eval("ACTIVE"))%>'  />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                            </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px"
                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thao tác
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                            CommandName="Sua" ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                            Text="Xóa" ForeColor="#0e7eee"
                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                            OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
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
                        <div style="float: left; margin-top: 6px;" runat="server" id="div_Order">
                            <asp:Button ID="cmdThutu" runat="server" CssClass="buttoninput" Text="Lưu thông tin" OnClick="cmdThutu_Click" />
                         
                        </div>
                    </asp:Panel>
                    <div>
                        <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                        &nbsp; &nbsp;&nbsp
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                    </div>
                </td>

            </tr>
        </table>
    </div>

    <script>
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
    </script>

</asp:Content>
