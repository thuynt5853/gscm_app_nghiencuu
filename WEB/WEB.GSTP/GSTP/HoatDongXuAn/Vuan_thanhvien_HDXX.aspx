<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Vuan_thanhvien_HDXX.aspx.cs" Inherits="WEB.GSTP.GSTP.HoatDongXuAn.Vuan_thanhvien_HDXX" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        input[type=checkbox] {
            margin: 2px 9px 2px 0px;
        }

        .table2 td a {
            color: #333333;
            text-decoration: none;
        }

            .table2 td a:hover {
                text-decoration: none;
                color: #0E7EEE;
            }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Tìm kiếm</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td><b>Vai trò trong vụ án</b></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlVaiTro" CssClass="chosen-select" runat="server" Width="321px">
                                    <asp:ListItem Value="THAMPHANHDXX" Text="Thẩm phán thành viên hội đồng xét xử"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Tên vụ án/vụ việc</b></td>
                            <td colspan="3">
                                <asp:TextBox ID="txtTenVuAn" runat="server" CssClass="user" Width="313px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 120px"><b>Ngày phân công từ</b></td>
                            <td style="width: 147px">
                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="94px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td style="width: 58px"><b>Đến ngày</b></td>
                            <td>
                                <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="94px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Trạng thái của vụ án</b></td>
                            <td colspan="3">
                                <asp:CheckBoxList ID="chkListTrangThai" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                    <asp:ListItem Value="huy" Text="Vụ án bị hủy"></asp:ListItem>
                                    <asp:ListItem Value="sua" Text="Vụ án bị sửa"></asp:ListItem>
                                    <asp:ListItem Value="treo" Text="Vụ án áp dụng án treo"></asp:ListItem>
                                    <asp:ListItem Value="quahan" Text="Vụ án quá hạn"></asp:ListItem>
                                    <asp:ListItem Value="tamdc" Text="Vụ án tạm đình chỉ"></asp:ListItem>
                                    <asp:ListItem Value="tamthoi" Text="Vụ án có áp dụng các biện pháp khẩn cấp tạm thời"></asp:ListItem>
                                    <asp:ListItem Value="dinhchi" Text="Vụ án bị đình chỉ"></asp:ListItem>
                                </asp:CheckBoxList>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="3">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validate();" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td>
                            <span style="font-weight: bold; text-transform: uppercase;">Danh sách vụ án là thành viên HĐXX</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="lblthongbao" ForeColor="Red" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Panel runat="server" ID="pndata">
                                <div class="phantrang" id="PhanTrangTren" runat="server">
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
                                    AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound" OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-CssClass="header_td" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Container.ItemIndex +1%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Tên vụ án, vụ việc" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtTenVuAn" runat="server" CausesValidation="false" Text='<%#Eval("TenVuAn") %>' CommandName="ChiTiet" CommandArgument='<%#Eval("VuAnID")+"#"+Eval("LinhVuc")+"#"+Eval("MAGIAIDOAN") %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TenToaAn" HeaderText="Tòa xét xử" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="175px"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LinhVuc" HeaderText="Lĩnh vực" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="65px"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TenMaGiaiDoan" HeaderText="Giai đoạn" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="65px"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderText="Ngày phân công" HeaderStyle-Width="65px">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNgayPhanCong" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderText="Trạng thái" HeaderStyle-Width="114px">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTrangThai" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="MaVuAn" HeaderText="Mã vụ án" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="80px"></asp:BoundColumn>
                                    </Columns>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang" id="PhanTrangDuoi" runat="server">
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

        function validate() {
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            var lengthTuNgay = txtTuNgay.value.trim().length;
            if (lengthTuNgay > 0) {

                if (!IsTrueDate(txtTuNgay.value)) {
                    txtTuNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            var lengthDenNgay = txtDenNgay.value.trim().length;
            if (lengthDenNgay > 0) {
                if (!IsTrueDate(txtDenNgay.value)) {
                    txtDenNgay.focus();
                    return false;
                }
            }

            if (lengthTuNgay > 0 && lengthDenNgay > 0) {
                var arrTuNgay = txtTuNgay.value.split('/');
                var TuNgay = new Date(arrTuNgay[2] + '-' + arrTuNgay[1] + '-' + arrTuNgay[0]);
                var arrDenNgay = txtDenNgay.value.split('/');
                var DenNgay = new Date(arrDenNgay[2] + '-' + arrDenNgay[1] + '-' + arrDenNgay[0]);
                if (TuNgay > DenNgay) {
                    alert('Đến ngày phải lớn hơn hoặc bằng Từ ngày.');
                    txtDenNgay.focus();
                    return false;
                }
            }
            return true;
        }
        function CallPopupAHS_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/HinhSu.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Hình sự", width, height);
        }
        function CallPopupADS_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/DanSu.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Dân sự", width, height);
        }
        function CallPopupAHN_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/HonNhanGiaDinh.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Hôn nhân gia đình", width, height);
        }
        function CallPopupAKT_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/KinhDoanhThuongMai.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Kinh doanh thương mai", width, height);
        }
        function CallPopupALD_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/LaoDong.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Lao động", width, height);
        }
        function CallPopupAHC_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/HanhChinh.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Hành chính", width, height);
        }
        function CallPopupAPS_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/PhaSan.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Phá sản", width, height);
        }
        function CallPopupBPXLHC_DGQ() {
            var link = "/BaoCao/Thongtinvuviec/BPXLHC.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Biện pháp xử lý hành chính", width, height);
        }
    </script>
</asp:Content>
