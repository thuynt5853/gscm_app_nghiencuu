<%@ Page Language="C#"  MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="UTTPDi.aspx.cs" Inherits="WEB.GSTP.QLAN.UTTPDi" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <style>
#dvSpliter_1{
    height:100% !important;
}
    
</style>
    <div class="box">
        <div class="box_nd">
            <asp:Panel ID="pnTimKiem" runat="server" Visible="true">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <div style="float: left;">
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Đương sự</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDuongXu" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-left: 10px;">Số thụ lý</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px; margin-left:16px">Ngày thụ lý</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator6" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayThuLy" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Cấp xét xử</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlCapXetXu" CssClass="chosen-select" runat="server" Width="250px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-left: 10px;">Loại án</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="248px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    
                                                <div style="float: left; width: 80px; text-align: left; margin-right: 7px; margin-left:14px">Kết quả UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlKetQuaUT" CssClass="chosen-select" runat="server" Width="259px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    
                                                </div>
                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align:left; margin-right: 7px;">Thư ký</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlThuKy" CssClass="chosen-select" runat="server" Width="249px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-left: 10px;">Thẩm phán</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlThamPhan" CssClass="chosen-select" runat="server" Width="248px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>

                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px; margin-left:14px">Đơn vị UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlDonViUT" CssClass="chosen-select" runat="server" Width="259px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Văn bản UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlVanBanUT" CssClass="chosen-select" runat="server" Width="588px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Đã thụ lý"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px; margin-left:12px">Quốc gia UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlQuocGiaUT" CssClass="chosen-select" runat="server" Width="259px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Tìm kiếm theo</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiTimKiem" CssClass="chosen-select" runat="server" Width="249px">
                                                            <asp:ListItem Value="0" Text="Ngày nhận được UTTP của toa cấp dưới"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Thời gian UT"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Ngày nhận kết quả"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-left: 10px;">Từ ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="241px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 5px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    
                                                </div>
                                                

                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td ><asp:Label runat="server" ID="lblthongbao" ForeColor="Red"></asp:Label></td>
                    </tr>
                    <tr>
                        
                        <td style="text-align:center">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                           <div style="display:none;"><asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" /></div>
                        <asp:Button ID="Button2" runat="server" CssClass="buttoninput" Text="In danh sách" OnClick="btnInDanhSach_Click" />
                        </td>
                    </tr>
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
                                    <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
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
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TOAANID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="23%" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>
                                                Thông tin vụ án/vụ việc
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("THONGTINVUAN") %>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="16%">
                                            <HeaderTemplate>
                                                Văn bản UTTP
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGAYUT_VBUT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="12%">
                                            <HeaderTemplate>
                                                Đơn vị
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                 <%#Eval("DONVIUTTP") %>
                                            </ItemTemplate>
                                            
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="12%">
                                            <HeaderTemplate>
                                                Quốc gia
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("QUOCGIAUTTP") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="7%">
                                            <HeaderTemplate>
                                                Ngày chuyển
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGAYCHUYENUTTP") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn  HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="12%">
                                            <HeaderTemplate>
                                                Kết quả UTTP
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("KETQUAUTTP") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYCHUYENKQUTVETOACAPDUOI" HeaderText="Ngày chuyển KQ về Tòa cấp dưới" HeaderStyle-Width="7%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div>
                                                    <%--<%#Eval("ID") %>--%>
                                                    <div style="display:none"><asp:LinkButton ID="lblSua"  runat="server" Text="Sửa" ForeColor="#0e7eee"
                                                        CausesValidation="false" CommandName="Sua"
                                                        CommandArgument='<%#Eval("DATAID") %>'></asp:LinkButton></div>
                                                    <asp:LinkButton ID="lblCapNhat" runat="server" Text="Sửa" ForeColor="#0e7eee"
                                                        CausesValidation="false" CommandName="CapNhat"
                                                        CommandArgument='<%#Eval("DATAID") %>'></asp:LinkButton>
                                                    
                                                <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee"
                                                    CausesValidation="false" Text="<p>Xóa</p>"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("DATAID") %>' ToolTip="Xóa"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này?? ');"></asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
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
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
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
                    
                </table>
            </div>
                </asp:Panel>
            
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function popup_them_UTTPDi(IsEdit,Data) {
            var link = "/QLAN/UTTP/Popup/pUTTPDi.aspx?IsEdit=" + IsEdit + "&Data=" + Data;
            var width = 850;
            var height = 650;
            PopupCenter(link, "Ủy thác tư pháp đến", width, height);
        }
        function ReLoadGrid() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        function scrollTop() {
            setTimeout(function () {
                window.scrollTo(0, 0);
            },100)
            
        }
    </script>
</asp:Content>
