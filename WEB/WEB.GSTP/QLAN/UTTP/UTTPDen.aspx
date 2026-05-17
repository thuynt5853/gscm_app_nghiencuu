<%@ Page Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="UTTPDen.aspx.cs" Inherits="WEB.GSTP.QLAN.UTTPDen" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style>
    
    
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
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Quốc gia UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlQuocGiaUT" CssClass="chosen-select" runat="server" Width="246px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-left: 10px;">Kết quả thực hiện UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlKetQuaThucHienUT" CssClass="chosen-select" runat="server" Width="253px">
                                                            <asp:ListItem Value="0" Selected Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Đã thực hiện"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Từ chối thực hiện"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Chưa thực hiện"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>

                                                    
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;margin-left: 14px;">Người thực hiện UT</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlNguoiThucHienUT" CssClass="chosen-select" runat="server" Width="256px">
                                                            
                                                        </asp:DropDownList>
                                                    </div>
                                                    
                                                
                                                </div>
                                                
                                                <div style="float: left;margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Tìm kiếm theo</div>
                                                    <div style="float: left;">
                                                        
                                                        <asp:DropDownList ID="ddlLoaiTimKiem" CssClass="chosen-select" runat="server" Width="246px">
                                                             <asp:ListItem Value="1" Selected Text="Ngày nhận được UT"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Ngày có kết quả UT"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-left: 10px;">Từ ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="246px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="246px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    
                                                </div>
                                                
                                                <div style="float: left;margin-top:8px">
                                                    <div style="float: left; width: 80px; text-align: left; margin-right: 7px;">Nội dung</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtNoiDung" CssClass="user" runat="server" Width="582px"></asp:TextBox>
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
                        <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 0px; font-size: 15px;"></asp:Label>
                    </tr>
                    <tr>
                        <td style="text-align:center">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                           <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                            <asp:Button ID="Button2" runat="server" CssClass="buttoninput" Text="In danh sách" OnClick="btnInDanhSach_Click" />
                        </td>
                    </tr>
                    
                </table>
                <asp:Panel runat="server" ID="pndata" Visible="true">
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
                                OnItemCommand="dgList_ItemCommand">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="4%" ItemStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thứ tự
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                           <%# Container.DataSetIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="15%">
                                        <HeaderTemplate>
                                            Cơ quan UTTP
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("COQUANUT") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="10%">
                                        <HeaderTemplate>
                                            Quốc gia UTTP
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENQUOCGIAUT") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:BoundColumn DataField="NGAYNHANUTTP" ItemStyle-HorizontalAlign="Center" HeaderText="Ngày nhận UTTP" HeaderStyle-Width="6%" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"  HeaderStyle-Width="13%">
                                        <HeaderTemplate>
                                            Văn bản UTTP
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("VANBANUT") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="8%">
                                        <HeaderTemplate>
                                            Kết quả UTTP
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENKETQUAUT") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                     <asp:BoundColumn DataField="NGAYCOKETQUAUT" ItemStyle-HorizontalAlign="Center" HeaderText="Ngày có kết quả UTTP" HeaderStyle-Width="6%" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="10%">
                                        <HeaderTemplate>
                                            Người thực hiện
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENNGUOITHUCHIENUT") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                   
                                    <asp:TemplateColumn HeaderStyle-Width="5%" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thao tác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lblSua" runat="server" Text="<div>Sửa</div>" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                CommandArgument='<%#Eval("ID")%>'></asp:LinkButton>
                                            <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="<div>Xóa</div>"  ForeColor="#0e7eee"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
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
                            
                        </asp:Panel>
            </div>
                </asp:Panel>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function popup_them_UTTPDen(UTTPDenID) {
            var link = "/QLAN/UTTP/Popup/pUTTPDen.aspx?UTTPDenID=" + UTTPDenID;
            var width = 850;
            var height = 650;
            PopupCenter(link, "Ủy thác tư pháp đến", width, height);
        }
        function ReLoadGrid() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
    </script>
</asp:Content>
