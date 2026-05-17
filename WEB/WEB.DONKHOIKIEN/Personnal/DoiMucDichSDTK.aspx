<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master"
    AutoEventWireup="true" CodeBehind="DoiMucDichSDTK.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.DoiMucDichSDTK" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../UI/js/Common.js"></script>
    <style type="text/css">
        .guidonkien_head {
            display: none;
        }
    </style>
    <asp:HiddenField ID="hddMaDoiMucDichSD" runat="server" Value="DoiMucDichSD" />
    <asp:HiddenField ID="hddCurrDangKyID" runat="server" Value="0" />
    <div class="thongtin_lienhe" style="margin-top: 0px;">
        <div class="dangky_head border_radius_top">
            <div class="dangky_head_title">Soạn đơn khởi kiện</div>
            <div class="dangky_head_right"></div>
        </div>
        <div class="dangky_content">
            <div class="dangky_loaitk" style="display: none;">
                <span>Loại tài khoản:</span>
                <div class="loaitaikhoan">
                    <asp:Literal ID="lttLoaiTK" runat="server"></asp:Literal>
                </div>
            </div>

            <div class="dangky_content_form">
                <div class="dangky_content_form_item">
                    <div id="zone_message"></div>

                    <!------------------------------------------->
                    <asp:Panel ID="pnThongBao" runat="server" Visible="false">
                        <div class="helpcontent" style="margin-bottom: 15px; box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">

                            <asp:Literal ID="lttMsgDoiMucDichSD" runat="server"></asp:Literal>
                            <div style="float: left; margin-top: 10px; text-align: center; width: 100%;">
                                <asp:HiddenField ClientIDMode="Static" ID="Signature1" runat="server" />

                                <asp:Panel ID="pnThongTinCKSo" runat="server" Visible="false">
                                    <div class="zoneleft" style="margin-bottom: 10px; width: 99%; margin-top: 10px; float: left;">
                                        <div class="header_title">
                                            <span style="float: left;">Thông tin chứng thư số</span>
                                            <asp:Literal ID="lttTrangThai" runat="server"></asp:Literal>
                                        </div>
                                        <div class="dk_fullwidth">
                                            <div class="TableHS">
                                                <table>
                                                    <tr>
                                                        <td style="width: 110px;">Tên người đăng ký</td>
                                                        <td style="width: 250px;">
                                                            <asp:Label ID="lblHoTen"
                                                                runat="server" Width="94%"></asp:Label></td>
                                                        <td style="width: 75px;">Quốc tịch</td>
                                                        <td>
                                                            <asp:Label ID="lblQuocTich" runat="server"
                                                                Width="80%" MaxLength="250"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Email</td>
                                                        <td>
                                                            <asp:Literal ID="lttEmail" runat="server"></asp:Literal></td>
                                                        <td>CMND</td>
                                                        <td>
                                                            <asp:Label ID="lblCMND" runat="server"
                                                                Width="80%" MaxLength="250"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Địa chỉ</td>
                                                        <td>
                                                            <asp:Literal ID="lttDiaChi" runat="server"></asp:Literal>
                                                        </td>
                                                        <td>Nơi công tác</td>
                                                        <td>
                                                            <asp:Literal ID="lttDonVi" runat="server"></asp:Literal>
                                                        </td>
                                                    </tr>
                                                    <asp:Panel ID="pnDN" runat="server" Visible="false">
                                                        <tr>
                                                            <td>Mã số thuế</td>
                                                            <td colspan="3">
                                                                <asp:Literal ID="lttMaSoThue" runat="server"></asp:Literal></td>
                                                        </tr>
                                                    </asp:Panel>
                                                    <tr>
                                                        <td>Đơn vị cấp</td>
                                                        <td colspan="3">
                                                            <asp:Literal ID="lttDonViCapCKSo" runat="server"></asp:Literal></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>

                                    </div>
                                </asp:Panel>
                                <%--<asp:Panel ID="pnChonToaAn" runat="server" Visible="false">
                                    <div class="dk_fullwidth"  style="margin-bottom:10px; margin-top:10px; ">
                                        <b style="float: left; width: 100%; text-align: left; line-height: 20px;margin-bottom:10px;">Bước 2: Chọn Tòa án xác nhận</b>
                                        <span style="float: left; width: 100%; text-align: left; line-height: 20px;">Thông tin trong thiết bị chứng thư số của bạn không trùng khớp với thông tin tài khoản bạn đã đăng ký
                                        </span>
                                        <span style="float: left; width: 100%; text-align: left; line-height: 20px;">Bạn cần in mẫu đơn thay đổi mục đích sử dụng và nộp tại tòa án để xác thực thông tin tài khoản.</span>
                                    </div>
                                    <div class="dk_fullwidth" style="margin-bottom:10px;">
                                        <div style="width: 110px; float: left;text-align:left;line-height:30px;">Tòa án xác nhận</div>
                                        <div style="float: left;">
                                            <asp:HiddenField ID="hddToaAnID" runat="server" />
                                            <asp:TextBox ID="txtToaAn" CssClass="textbox" runat="server"
                                                Width="572px" placeholder="(Gõ tên Tòa án vào đây để tìm kiếm và lựa chọn Tòa án để nộp đơn)"
                                                AutoCompleteType="Search"></asp:TextBox>
                                        </div>
                                    </div>
                                </asp:Panel>--%>

                                <asp:Button ClientIDMode="Static" ID="cmdThaydoi"
                                    runat="server" Text="Gửi yêu cầu thay đổi" CssClass="button_checkchkso"
                                   OnClientClick="return confirm('Bạn có thực sự muốn Đăng ký Nộp đơn khởi kiện và nhận văn bản tống đạt ?');"  OnClick="cmdThaydoi_Click" />

                                <asp:Button ClientIDMode="Static" ID="cmdInBieuMau" Visible="false"
                                    runat="server" Text="In biểu mẫu" CssClass="button_checkchkso"
                                    OnClientClick="return validate_doimucdichsd()" OnClick="cmdInBieuMau_Click" />
                            </div>
                        </div>
                    </asp:Panel>

                    <!------------------------------------------->

                    <asp:Panel ID="pnUserLogin" runat="server">
                        <div class="header_title" style="float: left;">
                            Thông tin cá nhân đã đăng ký
                        <asp:Literal ID="lttTenLoaiTK" runat="server" Visible="false"></asp:Literal>
                        </div>
                        <div class="border_content">
                            <div class="dk_fullwidth">
                                <div class="TableHS">
                                    <table>
                                        <tr>
                                            <td style="width: 110px;">Mục đích sử dụng</td>
                                            <td colspan="3">
                                                <asp:Label ID="lblLogin_MucDichSD"
                                                    runat="server" Width="94%"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 110px;">Họ tên</td>
                                            <td style="width: 250px;">
                                                <asp:Label ID="lblLogin_HoTen"
                                                    runat="server" Width="94%"></asp:Label></td>
                                            <td style="width: 75px;">Ngày sinh</td>
                                            <td>
                                                <asp:Label ID="lblLogin_NgaySinh" runat="server"
                                                    Width="80%" MaxLength="250"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>Email</td>
                                            <td>
                                                <asp:Literal ID="lblLogin_Email" runat="server"></asp:Literal></td>
                                            <td>CMND</td>
                                            <td>
                                                <asp:Label ID="lblLogin_CMND" runat="server"
                                                    Width="80%" MaxLength="250"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>Địa chỉ</td>
                                            <td>
                                                <asp:Literal ID="lblLogin_DiaChi" runat="server"></asp:Literal>
                                            </td>
                                            <td>Nơi công tác</td>
                                            <td>
                                                <asp:Literal ID="lblLogin_NoiCongTac" runat="server"></asp:Literal>
                                            </td>
                                        </tr>
                                        <asp:Panel ID="Panel1" runat="server" Visible="false">
                                            <tr>
                                                <td>Mã số thuế</td>
                                                <td colspan="3">
                                                    <asp:Literal ID="lblLogin_MaSoThue" runat="server"></asp:Literal></td>
                                            </tr>
                                        </asp:Panel>
                                        <tr style="display: none;">
                                            <td>Đơn vị cấp</td>
                                            <td colspan="3">
                                                <asp:Literal ID="lblLogin_DonViCap" runat="server"></asp:Literal></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>


                </div>
                <div class="fullwidth">
                    <div class="msg_thongbao">
                        <asp:Literal runat="server" ID="lbthongbao"></asp:Literal>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <asp:HiddenField ID="hddCheckTK" runat="server" Value="0" />
    <script>
        function validate() {
            var zone_message_name = 'zone_message';
            var zone_message = document.getElementById(zone_message_name);
            return true;
        }
        function validate_doimucdichsd() {
            var msg = "";
            var zone_message = document.getElementById('zone_message');
            <%--var hddToaAnID = document.getElementById('<%=hddToaAnID.ClientID%>');
            var txtToaAn = document.getElementById('<%=txtToaAn.ClientID%>');--%>
            if (!Common_CheckEmpty(txtToaAn.value))
                hddToaAnID.value = "";
            var ToaAnId = hddToaAnID.value;
            if (!Common_CheckEmpty(ToaAnId)) {
                zone_message.style.display = "block";
                zone_message.innerText = "Bạn chưa chọn Tòa án nhận đơn. Hãy kiểm tra lại!";
                txtToaAn.focus();
                return false;
            }

           <%-- var hddCheckTK = document.getElementById('<%=hddCheckTK.ClientID%>');
             if (hddCheckTK.value == "0") {
                 //thong tin giua CTS va ThongtinDK ko trung khop--> In bieu mau
                 msg = "Thông tin trong thiết bị chứng thư số của bạn không trùng khớp với thông tin tài khoản bạn đã đăng ký,";
                 msg += " bạn cần in mẫu đơn thay đổi mục đích sử dụng ra và nộp tại tòa án để xác thực thông tin tài khoản."
                 msg += " Bạn muốn thực hiện việc thay đổi thông tin này không?";
                 if (!confirm(msg))
                     return false;
             }--%>

            return true;
        }

        function hide_zone_message() {
            var today = new Date();
            var zone = document.getElementById('zone_message');
            if (zone.style.display != "") {
                zone.style.display = "none";
                zone.innerText = "";
            }
            var t = setTimeout(hide_zone_message, 15000);
        }
        hide_zone_message();

    </script>
    <script type="text/javascript">
        var _signed = false;
        function AuthCallBack(sender, rv) {
            console.log(rv);
            var json_rv = JSON.parse(rv);
            if (json_rv.Status == 0) {
                document.getElementById("Signature1").value = json_rv.Signature;
                _signed = true;
                document.getElementById(sender).click();
            } else {
                _signed = false;
                // alert("Ký số không thành công:" + json_rv.Status + ":" + json_rv.Error);
                alert("Thiết bị chứng thư số chưa được tích hợp vào máy tính/VGCA Sign Service chưa được kích hoạt." + json_rv.Error);
            }
        }

        function exc_auth(sender) {
            if (_signed)
                return true;
            var s1 = "<%=Session["AuthCode"]%>";
            console.log(s1);
            vgca_auth(sender, s1, AuthCallBack);
            return false;
        }

    </script>
    <script type="text/javascript">
        function show_popup_doimucdichsudungTK() {
            var dangkyID = document.getElementById('<%=hddCurrDangKyID.ClientID%>').value;
            var pageURL = "/Personnal/InBC.aspx?type=editmucdichsd&dkID=" + dangkyID;
            var page_width = 880;
            var page_height = 550;
            var left = (screen.width / 2) - (page_width / 2);
            var top = (screen.height / 2) - (page_height / 2);
            var targetWin = window.open(pageURL, 'Đơn xin thay đổi mục đích sử dụng tài khoản'
                , 'toolbar=no,scrollbars=yes,resizable=no'
                + ', width = ' + page_width
                + ', height=' + page_height + ', top=' + top + ', left=' + left);
            return targetWin;
        }
    </script>

    <!--------------------------------------------->
    <script>
        function pageLoad(sender, args) {
            $(function () {
                var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetAllToaNhanDKKOnline") %>';
                $("[id$=txtToaAn]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldm_toaan,
                            data: "{ 'textsearch': '" + request.term + "'}",
                            dataType: "json", type: "POST",
                            contentType: "application/json; charset=utf-8",

                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) },
                            error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddToaAnID]").val(i.item.val); }, minLength: 1
                });
            });

            //--------------------------------------------
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }

    </script>
</asp:Content>

