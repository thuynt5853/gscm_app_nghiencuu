<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.TDKT.HoSo.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        .msg_error {
            text-align: left !important;
        }

        .box {
            padding-bottom: 0px !important;
        }

        .HoSo_TDKT_Col1 {
            width: 80px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="HddPageSize" Value="20" runat="server" />
    <asp:HiddenField ID="hddID" Value="0" runat="server" />
    <asp:HiddenField ID="HdfVuTDKT" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong" style="min-height: 735px; margin-bottom: 0px;">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="BtnThemMoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="BtnThemMoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Đơn vị</b></td>
                        <td>
                            <asp:DropDownList ID="DropToaAn" Width="526px" runat="server" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="HoSo_TDKT_Col1"><b>Mã hồ sơ</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtMa" Width="518px" CssClass="user" MaxLength="100"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Tên hồ sơ</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtTen" Width="518px" CssClass="user" MaxLength="500"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Trạng thái</b></td>
                        <td>
                            <asp:DropDownList ID="DropTrangThai" Width="526px" runat="server" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="BtnTimkiem" runat="server" Style="margin-top: 10px;" CssClass="buttoninput" Text="Tìm kiếm" OnClick="BtnTimkiem_Click" />
                            <asp:Button ID="BtnLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="BtnLamMoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Label runat="server" ID="Lblthongbao" CssClass="msg_error"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Panel ID="PnlData" runat="server">
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
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="STT" HeaderText="Thứ tự" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="MA_HOSO" HeaderText="Mã hồ sơ" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TEN_HOSO" HeaderText="Tên hồ sơ" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENDONVI" HeaderText="Đơn vị" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="46px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tờ trình</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtToTrinh" runat="server" Text="Tờ trình" CausesValidation="false"
                                                    CommandName="ToTrinh" ForeColor="#0e7eee" ToolTip="Tờ trình"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="false" HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Biên bản họp</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtBienBan_Hop" runat="server" Text="Biên bản" CausesValidation="false"
                                                    CommandName="BienBanHop" ForeColor="#0e7eee" ToolTip="Biên bản họp"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Biên bản kiểm phiếu</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtBienBan_KiemPhieu" runat="server" Text="Biên bản" CausesValidation="false"
                                                    CommandName="BienBanKiemPhieu" ForeColor="#0e7eee" ToolTip="Biên bản kiểm phiếu"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="false" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Báo cáo thành tích</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtBaoCao" runat="server" Text="Báo cáo" CausesValidation="false"
                                                    CommandName="BaoCao" ForeColor="#0e7eee" ToolTip="Báo cáo thành tích"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="false" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Danh sách file điện tử</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtDanhSachFile" runat="server" Text="Danh sách" CausesValidation="false"
                                                    CommandName="DanhSachFile" ForeColor="#0e7eee" ToolTip="Danh sách file điện tử"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="THOI_GIAN_THAM_DINH" HeaderText="Thời gian thẩm định còn lại" HeaderStyle-Width="58px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TEN_TRANG_THAI" HeaderText="Trạng thái" HeaderStyle-Width="58px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="68px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LbtHoanTat" runat="server" Text="Hoàn tất" CausesValidation="false"
                                                    CommandName="HoanTat" ForeColor="#0e7eee" ToolTip="Hoàn tất hồ sơ"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                                <asp:HyperLink ID="lkSpace_Vu_TDKT" runat="server" Text="<br />"></asp:HyperLink>

                                                <asp:LinkButton ID="LbtTraLai" runat="server" Text="Trả lại" CausesValidation="false"
                                                    CommandName="TraLai" ForeColor="#0e7eee" ToolTip="Trả lại"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                                <asp:LinkButton ID="LbtGuiVuTDKT" runat="server" Text="Gửi trình" CausesValidation="false"
                                                    CommandName="Gui" ForeColor="#0e7eee" ToolTip="Gửi trình Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                                <asp:HyperLink ID="lkSpace_GuiTrinh" runat="server" Text="<br />"></asp:HyperLink>

                                                <asp:LinkButton ID="LbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                                    CommandName="Sua" ForeColor="#0e7eee" ToolTip="Sửa"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'></asp:LinkButton>
                                                <asp:HyperLink ID="lkSpace" runat="server" Text="  "></asp:HyperLink>
                                                <asp:LinkButton ID="LbtXoa" runat="server" Text="Xóa" CausesValidation="false"
                                                    CommandName="Xoa" ForeColor="#0e7eee" ToolTip="Xóa"
                                                    CommandArgument='<%#Eval("ID")+";"+Eval("DANH_SACH_ID")%>'
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa hồ sơ này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
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
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
    </script>
</asp:Content>
