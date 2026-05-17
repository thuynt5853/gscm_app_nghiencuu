<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Baocao.ImportBaocao.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />

    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung bg_title_group">TỔNG HỢP SỐ LIỆU BÁO CÁO</h4>
                    <div class="boder" style="padding: 5px 10px;">
                        <table class="table1" style="margin: 10px 0px 10px 0px;">
                            <tr>
                                <td style="width: 140px;">Cấp tòa</td>
                                <td style="width: 145px;">
                                    <asp:DropDownList ID="Drop_Levels" runat="server" CssClass="chosen-select" Width="140px" CausesValidation="false"></asp:DropDownList>
                                </td>
                                <td style="width: 150px;">Tòa án</td>
                                <td style="width: 245px;">
                                    <asp:DropDownList ID="Drop_courts" runat="server" Width="240px" CssClass="chosen-select"
                                        skin="WebBlue" filter="Contains" DataTextField="COURT_NAME"
                                        DataValueField="ID" AutoPostBack="true" enableembeddedskins="true" allowcustomtext="true"
                                        markfirstmatch="true">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 110px;">
                                    <asp:Label ID="lbToaTrucThuoc" Text="Tòa án trực thuộc" runat="server" Visible="false" /></td>
                                <td>
                                    <asp:DropDownList ID="Drop_courts_ext" runat="server" Width="130px" CssClass="chosen-select" Visible="false"
                                        skin="WebBlue" filter="Contains" DataTextField="COURT_NAME"
                                        DataValueField="ID" AutoPostBack="true" enableembeddedskins="true" allowcustomtext="true"
                                        markfirstmatch="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <td>Loại án</td>
                                <td>
                                    <asp:DropDownList ID="ddlLoaiAn" runat="server" Width="140px" CssClass="chosen-select" AutoPostBack="true" CausesValidation="false" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td>Báo cáo tổng hợp số liệu</td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlBaoCao" runat="server" Width="240px" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBaoCao_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                             <%--   <td>Ngày tổng hợp số liệu<span class="batbuoc">(*)</span></td>
                                <td colspan="5">
                                    <asp:TextBox ID="txtNgay" runat="server" CssClass="user" Width="132px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>--%>

                                 <td>Từ ngày:<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgay" runat="server" CssClass="user" Width="133px" MaxLength="10" ToolTip="Từ ngày"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Đến ngày:<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="233px" MaxLength="10" ToolTip="Tới ngày" Enabled="true"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>

                            <tr>
                                <td></td>
                                <td colspan="5">
                                    <div style="margin-top: 10px; color: red;">
                                        <asp:Literal ID="lstMsg" runat="server"></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdCheckChange" runat="server" CssClass="buttoninput" Text="Kiểm tra" OnClick="cmdCheckChange_Click" />
                    <asp:Button ID="cmdTongHop" runat="server" CssClass="buttoninput" Text="Tổng hợp" OnClientClick="return validate_thongtin();" OnClick="cmdTongHop_Click" />
                </div>
                <table class="table1">
                    <tr>
                        <td style="text-align: left;">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red" Visible="False"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="phantrang" id="div_PhanTrang_T" runat="server">
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
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            STT
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("stt")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Ngày tổng hợp
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGAY_DB")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Đơn vị
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TEN")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Bắt đầu tổng hợp dữ liệu
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("BATDAU_DB")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Kết thúc tổng hợp dữ liệu
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("KETTHUC_DB")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án hình sự
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("AHS")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án dân sự
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("ADS")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án hôn nhân
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("AHN")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án kinh tế
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("AKT")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án lao động
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("ALD")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án hành chính
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("AHC")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Tuyên bố phá sản
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("APS")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Xử lý hành chính
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("XLHC")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Đơn tư pháp
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("DTP")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Mẫu thống kê khác
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" name="name" value="" disabled <%#Eval("KHAC")%> />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang" id="div_PhanTrang_D" runat="server">
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

    <script>
        function validate_thongtin() {
            var txtNgay = document.getElementById('<%=txtNgay.ClientID%>');
            if (!CheckDateTimeControl(txtNgay, "ngày tổng hợp số liệu")) {
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>