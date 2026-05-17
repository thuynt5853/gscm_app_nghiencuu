<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="ThongtinanDonKhac.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.ThongtinanDonKhac" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDSBiCao.ascx" TagPrefix="uc1" TagName="uDSBiCao" %>
<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDSNguoiThamGiaToTung.ascx" TagPrefix="uc1" TagName="uDSNguoiThamGiaToTung" %>
<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDsThuLy.ascx" TagPrefix="uc1" TagName="uDsThuLy" %>
<%@ Register Src="~/QLAN/DONGHEP/DONKHAC/DonGhep.ascx" TagPrefix="uc3" TagName="DONGHEPDONKHAC" %>




<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCaoID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCanDauVuID" runat="server" Value="0" />
    <asp:HiddenField ID="hddCaoTrangID" runat="server" Value="0" />
    <asp:HiddenField ID="hddMaGiaiDoan" runat="server" Value="0" />
    <!------------------------------------------->
    <style>
        .button_right {
            float: right;
            text-align: center;
            margin-left: 10px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <%--<div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                        Text="Lưu" OnClick="cmdUpdateVuAn_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdUpdateSelect" runat="server" CssClass="buttoninput"
                        Text="Lưu & Chọn xử lý" OnClientClick="return validate_all();"
                        OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNew" runat="server" CssClass="buttoninput"
                        Text="Lưu & Thêm mới" OnClientClick="return validate_all();"
                        OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput"
                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>--%>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div>
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group">Thông tin bàn giao hồ sơ và cáo trạng của VKS</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:Panel ID="TTVV" runat="server" Enabled="false">
                            <table class="table1">

                                <tr>
                                    <td style="width: 120px;">Trường hợp giao nhận <span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px;">
                                        <asp:DropDownList ID="dropTrangThaiGiaoNhan" CssClass="chosen-select"
                                            runat="server" Width="250px">
                                        </asp:DropDownList></td>
                                    <td style="width: 115px;">Quyết định truy tố</td>
                                    <td>
                                        <asp:DropDownList ID="dropQuyetDinhTruyTo" CssClass="chosen-select" runat="server"
                                            Width="160px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Số bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoBanCaoTrang" runat="server" CssClass="user align_right"
                                            Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Ngày bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBanCaoTrang" runat="server" CssClass="user" Width="153px"
                                            MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBanCaoTrang" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBanCaoTrang" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayBanCaoTrang" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Số bút lục<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoButLuc" CssClass="user align_right" onkeypress="return isNumber(event)"
                                            runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td>Ngày giao<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayGiao" runat="server" CssClass="user" Width="153px"
                                            MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayGiao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayGiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server"
                                            ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayGiao"
                                            InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                    </td>
                                </tr>

                            </table>
                                </asp:Panel>
                        </div>
                    </div>
                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:Panel ID="TTVA" runat="server" Enabled="false">
                            <table class="table1">
                                <asp:Panel ID="pnMaVuAn" runat="server">
                                    <tr>
                                        <td style="width: 120px;">Mã vụ án</td>
                                        <td style="width: 35%;">
                                            <asp:TextBox ID="txtMaVuAn" CssClass="user" placeholder="Mã vụ án tự sinh"
                                                ReadOnly="true" runat="server" Width="150px" MaxLength="50" Enabled="false"></asp:TextBox>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td style="width: 115px;">Tên vụ án<span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px;">
                                        <asp:TextBox ID="txtTenVuAn" CssClass="user" placeholder="Tên bị can đầu vụ - tội danh"
                                            runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                    <td style="width: 120px;">Mức độ nghiêm trọng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="dropLoaiToiPham" CssClass="chosen-select"
                                            runat="server" Width="160px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Tên khác của vụ án</td>
                                    <td>
                                        <asp:TextBox ID="txtTenVuAnKhac" CssClass="user"
                                            runat="server" Width="242px"></asp:TextBox></td>
                                    <td>Ngày xảy ra vụ án</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayXayra" runat="server" CssClass="user" onkeypress="return isNumber(event)"
                                            Width="65px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                            TargetControlID="txtNgayXayra" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                            TargetControlID="txtNgayXayra" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                        Giờ
                                        <asp:DropDownList ID="dropGio" runat="server" CssClass="chosen-select" Width="60">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr style="display: none">
                                    <td>Số bị can </td>
                                    <td>
                                        <asp:TextBox ID="txtSoBiCan" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server" Enabled="false" Text="0"
                                            Width="145px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td>Số bị can tạm giam</td>
                                    <td>
                                        <asp:TextBox ID="txtSoBiCanTamGiam" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server" Enabled="false" Text="0"
                                            Width="145px" MaxLength="60"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                                </asp:Panel>
                        </div>
                    </div>
                    <!-------------------------------->

                    <div style="margin: 5px; width: 99%;">
                        <uc3:DONGHEPDONKHAC runat="server" ID="DONGHEPDONKHAC" />
                    </div>

                    <!-------------------------------->

                    <!-------------------------------->
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                    </div>
                </div>
                <%--<div style="margin: 5px; text-align: center; width: 95%; margin-bottom: 100px;">
                    <asp:Button ID="cmdUpdateVuAnB" runat="server" CssClass="buttoninput"
                        Text="Lưu" OnClientClick="return validate_all();" OnClick="cmdUpdateVuAn_Click" />
                    <asp:Button ID="cmdUpdateSelectB" runat="server" CssClass="buttoninput"
                        Text="Lưu & Chọn xử lý" OnClick="cmdUpdateSelect_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdUpdateAndNewB" runat="server" CssClass="buttoninput"
                        Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput"
                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>--%>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';
            $("[id$=txtTamtru]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddTamtruID]").val(i.item.val); }, minLength: 1
            });
            //----------------
            $("[id$=txtHKTT]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddHKTTID]").val(i.item.val); }, minLength: 1
            });
            //-----------------------------------------------
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>


    <script>
        function validate() {
            if (!validate_thongtinhoso())
                return false;
            //---------------------
            if (!validate_thongtin_vuan())
                return false;
            return true;
        }
        function validate_all() {
            if (!validate_thongtinhoso())
                return false;
            //---------------------
            if (!validate_thongtin_vuan())
                return false;
            //---------------------
            if (!validate_thuly())
                return false;
            return true;
        }

        function validate_thongtinhoso() {
            var dropTrangThaiGiaoNhan = document.getElementById('<%=dropTrangThaiGiaoNhan.ClientID%>');
            var value_change = dropTrangThaiGiaoNhan.options[dropTrangThaiGiaoNhan.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn trường hợp giao nhận. Hãy kiểm tra lại!');
                dropTrangThaiGiaoNhan.focus();
                return false;
            }

            //-----------------------------
            var txtSoBanCaoTrang = document.getElementById('<%=txtSoBanCaoTrang.ClientID%>');
            if (!Common_CheckEmpty(txtSoBanCaoTrang.value)) {
                alert('Bạn chưa nhập số bản cáo trạng.Hãy kiểm tra lại!');
                txtSoBanCaoTrang.focus();
                return false;
            }
            //-----------------------------
            var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBanCaoTrang, 'Ngày bản cáo trạng'))
                return false;

            //-----------------------------
            var txtSoButLuc = document.getElementById('<%=txtSoButLuc.ClientID%>');
            if (!Common_CheckEmpty(txtSoButLuc.value)) {
                alert('Bạn chưa nhập số bút lục.Hãy kiểm tra lại!');
                txtSoButLuc.focus();
                return false;
            }

            //-----------------------------
            var txtNgayGiao = document.getElementById('<%=txtNgayGiao.ClientID%>');
            if (!CheckDateTimeControl(txtNgayGiao, 'Ngày giao bút lục'))
                return false;
            //-----------------------------
            var txtTenVuAn = document.getElementById('<%=txtTenVuAn.ClientID%>');
            if (!Common_CheckEmpty(txtTenVuAn.value)) {
                alert('Bạn chưa nhập tên vụ án!');
                txtTenVuAn.focus();
                return false;
            }
            return true;
        }

        function validate_thongtin_vuan() {
            var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBanCaoTrang, 'Ngày bản cáo trạng'))
                return false;

            <%--var txtNgayXayra = document.getElementById('<%=txtNgayXayra.ClientID%>');
            if (!CheckDateTimeControl(txtNgayXayra, 'Ngày xảy ra vụ án'))
                return false;--%>

            if (!SoSanh2Date(txtNgayBanCaoTrang, 'Ngày bản cáo trạng', txtNgayXayra.value, 'Ngày xảy ra vụ án')) {
                txtNgayXayra.focus();
                return false;
            }
            return true;
        }

        function Set_Date_NgayGiaoHS() {
            var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
            var txtNgayGiao = document.getElementById('<%=txtNgayGiao.ClientID%>');

            var Empty_date = '__/__/____';
            if ((Common_CheckEmpty(txtNgayBanCaoTrang.value)) && (txtNgayBanCaoTrang.value != Empty_date))
                txtNgayGiao.value = txtNgayBanCaoTrang.value;
        }

    </script>
    <script>
        function popup_them_bc(VuAnID) {
            var link = "/QLAN/AHS/Hoso/popup/pBiCao.aspx?hsID=" + VuAnID;
            var width = 850;
            var height = 1000;
            PopupCenter(link, "Cập nhật thông tin bị can", width, height);
        }
        function popup_them_NguoiTGTT(VuAnID) {
            var link = "/QLAN/AHS/Hoso/Popup/pNguoiThamGiaTT.aspx?hsID=" + VuAnID;
            var width = 850;
            var height = 650;
            PopupCenter(link, "Người tham gia đối tượng", width, height);
        }
        function popupCaoTrang() {
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var link = "/QLAN/AHS/Hoso/popup/pCaoTrang.aspx?hsID=" + hddVuAnID.value
            var width = 950;
            var height = 550;
            PopupCenter(link, "Cáo trạng", width, height);
        }
        function popupDieuLuatAD() {
            var width = 950;
            var height = 550;
            var hddCaoTrangID = document.getElementById('<%=hddCaoTrangID.ClientID%>');
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var hddBiCaoID = document.getElementById('<%=hddBiCaoID.ClientID%>');
            var link = "/QLAN/AHS/Hoso/popup/pChonToiDanh.aspx?hsID=" + hddVuAnID.value + "&bID=" + hddBiCaoID.value;
            PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>

</asp:Content>



