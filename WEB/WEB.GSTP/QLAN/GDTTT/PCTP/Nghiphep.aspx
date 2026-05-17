<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Nghiphep.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.PCTP.Nghiphep" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />    
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td>Thẩm phán</td>
                        <td >
                            <asp:DropDownList CssClass="chosen-select" ID="ddlThamphan" runat="server" Width="350px"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td>Hình thức</td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="ddlHinhthuc" runat="server" Width="350px">
                                <asp:ListItem Value="0" Text="Nghỉ phép"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Đi công tác"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Đi học"></asp:ListItem>
                                <asp:ListItem Value="3" Text="Nghỉ ốm"></asp:ListItem>
                                <asp:ListItem Value="4" Text="Khác"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 110px;">Ngày nghỉ từ</td>
                        <td >
                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="142px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>Đến hết ngày</td>
                        <td >
                         <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="142px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="2" style="text-align: left;">
                           <asp:HiddenField ID="hddID" runat="server" Value="0" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td >
                            <asp:Button ID="cmdLuu" runat="server" CssClass="buttoninput" OnClick="cmdLuu_Click" Text="Lưu" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" OnClick="cmdLammoi_Click" Text="Làm mới"  />
                        </td>
                    </tr>
                    <tr>
                      <td colspan="2"> <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table style="width: 500px; margin-top: 10px;">
                                <tr>
                                    <td style="width:90px;">
                                        <asp:DropDownList ID="ddlNam" CssClass="chosen-select"  runat="server" Width="88px"></asp:DropDownList>
                                    </td>
                                    <td style="width: 150px;">
                                        <asp:TextBox runat="server" ID="txttimkiem" Width="99%" CssClass="user" placeholder="Tên thẩm phán"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput btnTimKiemCss" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
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
                                 AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
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
                                    <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tên cán bộ
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("HOTEN")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="150px" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Chức danh
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENCHUCDANH")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-Width="150px" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Chức vụ
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENCHUCVU")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="120px"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="SONGAY" HeaderText="Số ngày" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ></asp:BoundColumn>
                                    <asp:BoundColumn DataField="TUNGAY" HeaderText="Từ ngày" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"  ></asp:BoundColumn>
                                     <asp:BoundColumn DataField="DENNGAY" HeaderText="Đến ngày" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"  ></asp:BoundColumn>
                                    <asp:BoundColumn DataField="TENHINHTHUC" HeaderText="Hình thức" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  ></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" ForeColor="#0e7eee" CausesValidation="false" CommandName="Sua"
                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Xóa"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa cán bộ này? ');"></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
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
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
