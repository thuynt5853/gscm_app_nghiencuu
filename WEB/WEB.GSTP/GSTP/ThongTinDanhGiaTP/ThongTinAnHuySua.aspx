<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongTinAnHuySua.aspx.cs" Inherits="WEB.GSTP.GSTP.ThongTinDanhGiaTP.ThongTinAnHuySua" %>

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
                color: #0E7EEE;
            }
    </style>
    <asp:HiddenField ID="hddDanhGiaID" Value="0" runat="server" />
    <asp:HiddenField ID="hddLoaiAn" Value="" runat="server" />
    <asp:HiddenField ID="hddVuAnID" Value="0" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="box">
        <div class="box_nd">
            <asp:Panel ID="pnThongTin" runat="server">
                <div class="boxchung">
                    <h4 class="tleboxchung">Tìm kiếm</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 102px;"><b>Tên vụ án/vụ việc</b></td>
                                <td style="width: 260px;">
                                    <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                <td style="width: 100px;"><b>Mã vụ án/vụ việc</b></td>
                                <td>
                                    <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td><b>Số QĐ/BA</b></td>
                                <td>
                                    <asp:TextBox ID="txtSoQDBA" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                <td><b>Ngày QĐ/BA</b></td>
                                <td>
                                    <asp:TextBox ID="txtNgayQDBA" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayQDBA" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayQDBA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td><b>Loại án</b></td>
                                <td>
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlLoaiAn" runat="server" Width="250px"></asp:DropDownList>
                                </td>
                                <td><b>Án sửa, hủy?</b></td>
                                <td>
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlAnHuySua" runat="server" Width="250px">
                                        <asp:ListItem Value="TatCa" Text="-- Tất cả --"></asp:ListItem>
                                        <asp:ListItem Value="AnHuy" Text="Án hủy"></asp:ListItem>
                                        <asp:ListItem Value="AnSua" Text="Án sửa"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Trạng thái</b></td>
                                <td colspan="3">
                                    <asp:DropDownList CssClass="chosen-select" ID="ddlTrangThai" runat="server" Width="250px">
                                        <asp:ListItem Value="TatCa" Text="-- Tất cả --"></asp:ListItem>
                                        <asp:ListItem Value="ChuaDanhGia" Text="Chưa đánh giá"></asp:ListItem>
                                        <asp:ListItem Value="DaDanhGia" Text="Đã đánh giá"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validate();" /></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="truong">
                    <span style="font-weight: bold; text-transform: uppercase; float: left; margin-top: 10px;">Thông tin các đánh giá của thẩm phán, Ủy ban thẩm phán về án sửa, án hủy</span>
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
                        AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand">
                        <Columns>
                            <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>STT</HeaderTemplate>
                                <ItemTemplate><%#Container.ItemIndex +1%></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderText="Tên vụ án, vụ việc" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtTenVuAn" runat="server" CausesValidation="false" Text='<%#Eval("TenVuAn") %>' CommandName="ChiTiet" CommandArgument='<%#Eval("ID")+"#"+Eval("TenVuAn")+"#"+Eval("AnSuaHuy_Ten")+"#"+Eval("LinhVuc")+"#"+Eval("LoaiAn")+"#"+Eval("VuAnID")+"#"+Eval("LOAIAN_SHORT") %>'></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn DataField="AnSuaHuy_Ten" HeaderText="Án sửa, hủy?" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="50px"></asp:BoundColumn>
                            <asp:BoundColumn DataField="VaiTro" HeaderText="Vai trò" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="100px"></asp:BoundColumn>
                            <asp:BoundColumn DataField="LinhVuc" HeaderText="Lĩnh vực" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="60px"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TenTrangThai" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="84px"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Thao tác</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lblSua" runat="server" Text="Đánh giá" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee" ToolTip="Đánh giá"
                                        CommandArgument='<%#Eval("ID")+"#"+Eval("TenVuAn")+"#"+Eval("AnSuaHuy_Ten")+"#"+Eval("LinhVuc")+"#"+Eval("LoaiAn")+"#"+Eval("VuAnID")+"#"+Eval("LOAIAN_SHORT") %>'></asp:LinkButton>
                                    &nbsp;&nbsp;
                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa đánh giá" ForeColor="#0e7eee"
                                    CommandName="Xoa" CommandArgument='<%#Eval("ID")+"#"+Eval("TenVuAn")+"#"+Eval("AnSuaHuy_Ten")+"#"+Eval("LinhVuc")+"#"+Eval("LoaiAn")+"#"+Eval("VuAnID")+"#"+Eval("LOAIAN_SHORT") %>' ToolTip="Xóa đánh giá" OnClientClick="return confirm('Bạn thực sự muốn xóa đánh giá này? ');"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
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
                </div>
            </asp:Panel>
            <asp:Panel ID="pnUpdate" runat="server" Visible="false">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr class="border_buttom">
                                <td style="width: 175px;"><b>Tên vụ án/vụ việc</b></td>
                                <td>
                                    <asp:TextBox ID="txtTenVuAn" CssClass="user" runat="server" Width="99%" Enabled="false"></asp:TextBox>
                                </td>
                            </tr>
                            <tr class="border_buttom">
                                <td><b>Án sửa, hủy?</b></td>
                                <td>
                                    <asp:TextBox ID="txtAnSuaHuy" CssClass="user" runat="server" Width="99%" Enabled="false"></asp:TextBox>
                                </td>
                            </tr>

                            <tr class="border_buttom">
                                <td><b>Loại án</b></td>
                                <td>
                                    <asp:TextBox ID="txtLoaiAn" CssClass="user" runat="server" Width="99%" Enabled="false"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td><b>Thẩm phán tự đánh giá<span class="batbuoc">(*)</span></b></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbChuQuanKhachQuan_TP" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Chủ quan"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Khách quan"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr class="border_buttom">
                                <td><b>Lý do<span class="batbuoc">(*)</span></b></td>
                                <td>
                                    <asp:TextBox ID="txtLyDo_TP" runat="server" CssClass="user" Width="99%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td><b>Ủy ban thẩm phán đánh giá<span class="batbuoc">(*)</span></b></td>
                                <td>
                                    <asp:RadioButtonList ID="rdbChuQuanKhachQuan_UBTP" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Chủ quan"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Khách quan"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr class="border_buttom">
                                <td><b>Lý do<span class="batbuoc">(*)</span></b></td>
                                <td>
                                    <asp:TextBox ID="txtLyDo_UBTP" runat="server" CssClass="user" Width="99%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="cmdCapNhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return CheckUpdate();" OnClick="cmdCapNhat_Click" />
                                    <asp:Button ID="cmdQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuayLai_Click" /></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Label runat="server" ID="lbthongbaoUpdate" ForeColor="Red"></asp:Label></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function validate() {
            var txtNgayQDBA = document.getElementById('<%=txtNgayQDBA.ClientID%>');
            if (txtNgayQDBA.value.trim().length > 0) {
                var arr = txtNgayQDBA.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày QĐ/BA theo định dạng (dd/MM/yyyy).');
                    txtNgayQDBA.focus();
                    return false;
                }
            }
            return true;
        }
        function CheckUpdate() {
            var rdbChuQuanKhachQuan_TP = document.getElementById('<%=rdbChuQuanKhachQuan_TP.ClientID%>');
            var msg = 'Bạn chưa chọn đánh giá khách quan hay chủ quan. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbChuQuanKhachQuan_TP, msg))
                return false;
            var rdbChuQuanKhachQuan_UBTP = document.getElementById('<%=rdbChuQuanKhachQuan_UBTP.ClientID%>');
            if (!CheckChangeRadioButtonList(rdbChuQuanKhachQuan_UBTP, msg))
                return false;
            var txtLyDo_TP = document.getElementById('<%=txtLyDo_TP.ClientID%>');
            var LengthLyDo_TP = txtLyDo_TP.value.trim().length;
            if (LengthLyDo_TP == 0) {
                alert('Bạn chưa nhập lý do. Hãy nhập lại!');
                txtLyDo_TP.focus();
                return false;
            } else if (LengthLyDo_TP > 1000) {
                alert('Không nhập lý do quá 1000 ký tự. Hãy nhập lại!');
                txtLyDo_TP.focus();
                return false;
            }
            var txtLyDo_UBTP = document.getElementById('<%=txtLyDo_UBTP.ClientID%>');
            var LengthLyDo_UBTP = txtLyDo_UBTP.value.trim().length;
            if (LengthLyDo_UBTP == 0) {
                alert('Bạn chưa nhập lý do. Hãy nhập lại!');
                txtLyDo_UBTP.focus();
                return false;
            } else if (LengthLyDo_UBTP > 1000) {
                alert('Không nhập lý do quá 1000 ký tự. Hãy nhập lại!');
                txtLyDo_UBTP.focus();
                return false;
            }
            return true;
        }
        function CallPopupInforAHS() {
            var link = "/BaoCao/Thongtinvuviec/HinhSu.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Hình sự", width, height);
        }
        function CallPopupInforADS() {
            var link = "/BaoCao/Thongtinvuviec/DanSu.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Dân sự", width, height);
        }
        function CallPopupInforAHN() {
            var link = "/BaoCao/Thongtinvuviec/HonNhanGiaDinh.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Hôn nhân gia đình", width, height);
        }
        function CallPopupInforAKT() {
            var link = "/BaoCao/Thongtinvuviec/KinhDoanhThuongMai.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Kinh doanh thương mai", width, height);
        }
        function CallPopupInforALD() {
            var link = "/BaoCao/Thongtinvuviec/LaoDong.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Lao động", width, height);
        }
        function CallPopupInforAHC() {
            var link = "/BaoCao/Thongtinvuviec/HanhChinh.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Hành chính", width, height);
        }
        function CallPopupInforAPS() {
            var link = "/BaoCao/Thongtinvuviec/PhaSan.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Phá sản", width, height);
        }
        function CallPopupInforBPXLHC() {
            var link = "/BaoCao/Thongtinvuviec/BPXLHC.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Biện pháp xử lý hành chính", width, height);
        }
    </script>
</asp:Content>