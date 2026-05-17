<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DangVanBanTongDat_CongThongTin.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.DangVanBanTongDat_CongThongTin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <div class="boder" style="padding: 10px;">
                    <table class="table1" style="width: 53%; margin: auto;">
                        <tr>
                            <td style="width: 90px;"><b>Tòa án</b></td>
                            <td>
                                <asp:DropDownList CssClass="chosen-select" ID="ddlDonVi" runat="server" Width="408px"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Tên vụ việc</b></td>
                            <td>
                                <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="400px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Số BA/QĐ</b></td>
                            <td>
                                <asp:TextBox ID="txtSoBAQD" CssClass="user" runat="server" Width="400px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Loại thông báo</b></td>
                            <td>
                                <asp:DropDownList ID="ddlLoai" CssClass="chosen-select" runat="server" Width="408px">
                                    <asp:ListItem Text="--- Tất cả ---" Value="99"></asp:ListItem>
                                    <asp:ListItem Text="Thông báo thụ lý hành chính" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Thông báo tống đạt" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Thông báo kết quả ủy thác tư pháp" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="Thông báo tìm người vắng mặt" Value="4"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Trạng thái</b></td>
                            <td>
                                <asp:RadioButtonList ID="rdoTrangThai" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="0" Selected="True">Chưa đăng</asp:ListItem>
                                    <asp:ListItem Value="1">Đã đăng</asp:ListItem>
                                    <asp:ListItem Value="2">Gỡ xuống</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Button ID="BtnTimKiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="BtnTimKiem_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="width: 100%; margin-top: 10px; margin-bottom: 10px;">
                    <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>
                </div>
                <asp:HiddenField ID="hddPageSize" Value="10" runat="server" />
                <asp:HiddenField ID="hddPageIndexCT" Value="1" runat="server" />
                <asp:HiddenField ID="hddTotalPageCT" Value="1" runat="server" />
                <div style="text-transform: uppercase; font-weight: bold; float: left;">
                    <asp:Literal ID="ltlDanhSach" runat="server"></asp:Literal>
                </div>
                <div style="float: right;">
                    <asp:Button ID="BtnGuiCongThongTinDienTu" Visible="false" runat="server" CssClass="buttoninput" Text="Đăng lên Cổng thông tin điện tử" OnClick="BtnGuiCongThongTinDienTu_Click" />
                </div>
                <div class="phantrang" id="PhanTrangT" runat="server">
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
                <asp:Panel ID="pnDaDangTai" runat="server">
                    <asp:DataGrid ID="dgListDaDangTai" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgListDaDangTai_ItemCommand">
                        <Columns>
                            <asp:BoundColumn DataField="TT" HeaderText="TT" HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="MABM" HeaderText="Mã văn bản" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TENBM" HeaderText="Tên văn bản" HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="160px">
                                <HeaderTemplate>Tệp văn bản</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                        CommandArgument='<%#Eval("ID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn DataField="NGAYDANG_CTTDT" HeaderText="Ngày đăng" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                </asp:Panel>
                <asp:Panel ID="pnChuaDangTai" runat="server" Visible="false">
                    <asp:DataGrid ID="dgListChuaDangTai" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                <HeaderTemplate>Chọn</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkIsSend" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn DataField="MABM" HeaderText="Mã văn bản" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TENBM" HeaderText="Tên văn bản" HeaderStyle-Width="350px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                </asp:Panel>
                <asp:Panel ID="pnGoXuong" runat="server" Visible="false">
                    <asp:DataGrid ID="DgListGoXuong" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TT" HeaderText="TT" HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="MABM" HeaderText="Mã văn bản" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TENBM" HeaderText="Tên văn bản" HeaderStyle-Width="350px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                </asp:Panel>
                <div class="phantrang" id="PhanTrangB" runat="server">
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
