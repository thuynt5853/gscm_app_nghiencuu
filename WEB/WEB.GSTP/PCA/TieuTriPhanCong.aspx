<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
    CodeBehind="TieuTriPhanCong.aspx.cs" Inherits="WEB.GSTP.PCA.TieuTriPhanCong" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                   <%-- <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">                                
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 105px; line-height: 20px; margin-left: 30px;">Cán bộ PC</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="Textphancong" runat="server" CssClass="user" Width="250px" MaxLength="100"></asp:TextBox>                                                    
                                                </div>
                                              </td>
                                             <td>
                                                <div style="float: left; width: 105px; line-height: 20px;">Từ ngày</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </div>
                                              </td>

                                              <td>
                                                <div style="float: left; width: 105px; line-height: 20px; margin-left: 30px;">Đến ngày</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </div>
                                              </td>
                                             <td align="left">
                                                <asp:Button ID="Button1" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                            </td>
                                        </tr>                                        
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>--%>

                   <%-- <tr>
                        <td colspan="2" align="left">

                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>--%>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" 
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                      <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
                                          AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%">
                                    <%--OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">--%>
                                    <Columns>
                                        <asp:BoundColumn DataField="EXPR_LINE" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="RULE_ID" Visible="false"></asp:BoundColumn>
                                         <asp:BoundColumn DataField="SU_DUNG" Visible="false"></asp:BoundColumn>
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
                                                Tên tiêu trí
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("COND")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>      
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Giá trị
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("RESULT")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>                              
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ghi chú
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NOTES")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn> 
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ngày hiệu lực
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGAY_HL")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn> 
                                         <asp:TemplateColumn HeaderText="Lưu" ItemStyle-VerticalAlign="Middle" HeaderStyle-Font-Bold="true"
                                                ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                                <HeaderTemplate>
                                                    Sử dụng                                 
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkCapnhat" runat="server" AutoPostBack="true" Enabled='<%# GetNumber(Eval("KODUNG"))%>' Checked='<%# GetNumber(Eval("SUDUNG"))%>' ToolTip='<%#Eval("COND")%>'  />
                                                </ItemTemplate>
                                                <HeaderStyle Font-Bold="True" Width="50px"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
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
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                        CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>
                     <tr>
                         <td colspan="2">
                             <div style="text-align: center;">
                                <span> <asp:Button ID="Button2" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" /></span>
                                <span> <asp:Label runat="server" ID="txtthongbao" ForeColor="Red"></asp:Label></span>
                            </div>
                        </td>
                    </tr>


                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>