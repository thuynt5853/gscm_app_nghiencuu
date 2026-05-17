<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master"
    AutoEventWireup="true" CodeBehind="TaiKhoanInfo.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.TaiKhoanInfo" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .guidonkien_head {
            display: none;
        }
    </style>
    <asp:HiddenField ID="hidDVCQGCode" runat="server" />

    <div class="thongtin_lienhe" style="margin-top: 0px;">
        <div class="dangky_head border_radius_top">
            <div class="dangky_head_title">Thông tin tài khoản</div>
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
                    <div class="header_title" style="float: left;">
                        Thông tin cá nhân
                        <asp:Literal ID="lttTenLoaiTK" runat="server" Visible="false"></asp:Literal>
                    </div>

                    <!------------------------------------------->
                    <div id="zone_message"></div>

                    <!------------------------------------------->
                    <div class="msg_warning" style="float: right; margin-top: 0px; margin-bottom: 7px;">
                        Những thông tin có dấu <span class="batbuoc">*</span>  là phần bắt buộc
                    </div>
                    <div class="dk_fullwidth" id="tabDVCQG" runat="server" visible="false" style="color: red; font-weight: bold; font-style:italic;">
                        (*)Đây là lần đầu tiên bạn thực hiện thủ tục nộp đơn khởi kiện trên hệ thống, xin vui lòng cập nhật đầy đủ thông tin hồ sơ
                    </div>
                    <div class="dk_fullwidth">
                        <div class="msg_thongbao">
                            <asp:Literal runat="server" ID="lttThongBaoTop"></asp:Literal>
                        </div>
                    </div>
                    <div class="border_content">
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span style="float: left; margin-top: 0px; margin-bottom: 0px; font-weight: bold;">Mục đích sử dụng</span>
                                <asp:RadioButtonList ID="rdMucDichSD"
                                    Enabled="false"
                                    CssClass="dangky_rd_mucdichsd"
                                    runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="1" Selected="True"><b>Nộp đơn khởi kiện và nhận văn bản tống đạt</b></asp:ListItem>
                                    <asp:ListItem Value="2"><b>Chỉ nhận văn bản tống đạt</b></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="TitleUyQuyen" style="line-height: 35px; font-weight: bold;">
                                Tư cách tố tụng
                            </div>
                            <asp:DropDownList ID="dropTuCachTT" runat="server"
                                CssClass="dangky_tk_dropbox" Width="55%"
                                AutoPostBack="true" OnSelectedIndexChanged="dropTuCachTT_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_hoten border_right">
                                <span>Họ và tên</span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtNDD_HOTEN" runat="server" Enabled="false" CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                            <div class="dk_item dk_gioitinh">
                                <span>Giới tính </span><span class="batbuoc">*</span>
                                <asp:DropDownList ID="dropNDD_GIOITINH" runat="server"
                                    CssClass="dangky_tk_dropbox right" placeholder="Chọn giới tính">
                                    <asp:ListItem Value="1">Nam</asp:ListItem>
                                    <asp:ListItem Value="2">Nữ</asp:ListItem>
                                    <asp:ListItem Value="3">Khác</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span>Email giao dịch điện tử với Tòa án</span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtEMAIL" runat="server" Width="95.5%"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                        </div>
                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <div style="float: left; width: 55%">
                                    <span>Ngày sinh </span><span class="batbuoc">*</span>
                                    <asp:TextBox ID="txtNDD_NGAYSINH" runat="server" CssClass="dangky_tk_textbox"
                                        placeholder="......./....../....." Width="95%" MaxLength="10"
                                        AutoPostBack="true" OnTextChanged="txtNDD_NGAYSINH_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNDD_NGAYSINH" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNDD_NGAYSINH" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                </div>
                                <div style="float: right; width: 35%">
                                    <span>Năm sinh</span><span class="batbuoc">*</span>
                                    <asp:TextBox ID="txtNamSinh" runat="server"
                                        AutoPostBack="true" OnTextChanged="txtNamSinh_TextChanged"
                                        CssClass="dangky_tk_textbox right" Width="95%" MaxLength="10"></asp:TextBox>

                                </div>
                            </div>
                            <div class="dk_item" style="float: right; width: 47%;">
                                <span>Quốc tịch</span>
                                <asp:DropDownList ID="dropQuocTich" runat="server"
                                    CssClass="dangky_tk_dropbox right" placeholder="Quốc tịch">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_hoten border_right">
                                <span>Số CMND/ Thẻ căn cước/ Hộ chiếu </span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtNDD_CMND" runat="server"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                            <div class="dk_item dk_gioitinh">
                                <span style="margin-left: 10px;">Ngày cấp</span>
                                <asp:TextBox ID="txtNgayCapCMND" runat="server"
                                    CssClass="dangky_tk_textbox right"
                                    placeholder="..../.../....." Width="90%"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayCapCMND" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayCapCMND" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                            </div>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span>Nơi cấp CMND/ Thẻ căn cước/ Hộ chiếu </span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtNoiCapCMND" runat="server" CssClass="dangky_tk_textbox" Width="95.5%"></asp:TextBox>
                            </div>
                        </div>

                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <span>Điện thoại di động</span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtMOBILE" runat="server"
                                    onkeypress="return isNumber(event)" Width="95%"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>

                            </div>
                            <div style="float: right; width: 47%;" class="dk_item">
                                <span>Điện thoại cố định</span>
                                <asp:TextBox ID="txtTelephone" runat="server" onkeypress="return isNumber(event)" CssClass="dangky_tk_textbox right"></asp:TextBox>

                            </div>
                        </div>

                        <!---------tam tru--------------------->
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <span>Tỉnh/ Thành phố tạm trú</span><span class="batbuoc">*</span>
                                <asp:DropDownList ID="dropTamTru_Tinh" runat="server" placeholder="  Tỉnh"
                                    CssClass="dangky_tk_dropbox" AutoPostBack="True"
                                    OnSelectedIndexChanged="dropTamTru_Tinh_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="float: right; width: 47%;" class="dk_item">
                                <span>Quận/ Huyện</span><span class="batbuoc">*</span>
                                <asp:DropDownList ID="dropTamTru_Huyen" runat="server" placeholder="  Quận"
                                    CssClass="dangky_tk_dropbox right">
                                </asp:DropDownList>

                            </div>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span>Địa chỉ chi tiết nơi cư trú hiện tại <i style="margin-left: 5px;">(Địa chỉ này dùng để nhận các văn bản, thông báo từ Tòa án)</i></span>
                                <span class="batbuoc">*</span>

                                <asp:TextBox ID="txtTamTru_ChiTiet" Width="95.5%" runat="server" placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                        </div>
                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <span>Chức vụ</span>
                                <asp:TextBox ID="txtNDD_ChucVu" runat="server" placeholder="  ...."
                                    CssClass="dangky_tk_textbox" Width="95%"></asp:TextBox>
                            </div>
                            <div style="float: right; width: 47%;" class="dk_item">
                                <span style="float: left; width: 90%;">Nơi công tác
                                </span>
                                <asp:TextBox ID="txtNDD_CQ" runat="server" placeholder="  ...."
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span>Nghề nghiệp</span>
                                <asp:TextBox ID="txtNgheNghiep" runat="server" placeholder="  ....." Width="95.5%"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <asp:Panel ID="plDoanhNghiep" runat="server" Visible="False">

                    <div class="header_title">
                        <asp:Literal ID="lttTitleDN" runat="server"></asp:Literal>
                    </div>
                    <div class="border_content">
                        <asp:Panel ID="pnDNMaSoThue" runat="server">
                            <div class="dk_fullwidth">
                                <div class="dk_item dk_diachi border_right">
                                    <span>Mã số thuế</span><span class="batbuoc">*</span>
                                    <asp:TextBox ID="txtDN_MASOTHUE" runat="server"
                                        CssClass="dangky_tk_textbox" onkeypress="return isNumber(event)"
                                        placeholder="...."></asp:TextBox>
                                </div>
                                <div class="dk_item dk_dienthoai">
                                    <span>Số giấy phép kinh doanh</span><span class="batbuoc">*</span>
                                    <asp:TextBox ID="txtDN_GPDKKD" runat="server"
                                        CssClass="dangky_tk_textbox" onkeypress="return isNumber(event)"
                                        placeholder="...."></asp:TextBox>
                                </div>
                            </div>
                        </asp:Panel>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span>
                                    <asp:Literal ID="lttTenDN" runat="server"></asp:Literal></span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtDN_TENVN" runat="server"
                                    CssClass="dangky_tk_textbox"
                                    placeholder="...."></asp:TextBox>
                            </div>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span>Tên khác</span>
                                <asp:TextBox ID="txtDN_othername" runat="server"
                                    CssClass="dangky_tk_textbox"
                                    placeholder="  ...."></asp:TextBox>
                            </div>
                        </div>
                        <asp:Panel ID="pnEngName" runat="server">
                            <div class="dk_fullwidth">
                                <div class="dk_item">
                                    <span>Tên tiếng Anh</span>
                                    <asp:TextBox ID="txtDN_TENEN" runat="server"
                                        CssClass="dangky_tk_textbox"
                                        placeholder="...."></asp:TextBox>
                                </div>
                            </div>
                        </asp:Panel>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right" style="width: 30%;">
                                <span>Điện thoại</span>
                                <asp:TextBox ID="txtDN_DienThoai" runat="server"
                                    CssClass="dangky_tk_textbox" onkeypress="return isNumber(event)"
                                    placeholder="  ...."></asp:TextBox>
                            </div>
                            <div class="dk_item dk_dienthoai"
                                style="width: 65%; margin-left: 3%; float: left;">
                                <span>Địa chỉ</span>
                                <asp:TextBox ID="txtDN_DiaChi" runat="server" Width="97.5%"
                                    CssClass="dangky_tk_textbox other_width"
                                    placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnUyQuyen" runat="server">
                    <div class="header_title">
                        Thông tin người ủy quyền
                    </div>

                    <div class="border_content">
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <span>Họ và tên</span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtNUQ_HOTEN" runat="server" Width="95%"
                                    CssClass="dangky_tk_textbox" placeholder="  ...."></asp:TextBox>
                            </div>
                            <div class="dk_item" style="float: right; width: 47%;">
                                <div style="float: left; width: 37%">
                                    <span>Giới tính </span><span class="batbuoc">*</span>
                                    <asp:DropDownList ID="dropNUQ_GIOITINH" runat="server"
                                        Width="100%"
                                        CssClass="dangky_tk_dropbox" placeholder="  Chọn giới tính">
                                        <asp:ListItem Value="1">Nam</asp:ListItem>
                                        <asp:ListItem Value="2">Nữ</asp:ListItem>
                                        <asp:ListItem Value="3">Khác</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div style="float: right; width: 51%">
                                    <span>Ngày ủy quyền</span><span class="batbuoc">*</span>
                                    <asp:TextBox ID="txtNgayUyQuyen" runat="server"
                                        CssClass="dangky_tk_textbox"
                                        placeholder="  ..../.../....." Width="95%"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server"
                                        TargetControlID="txtNgayUyQuyen" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server"
                                        TargetControlID="txtNgayUyQuyen" Mask="99/99/9999"
                                        MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </div>
                            </div>
                        </div>

                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <div style="float: left; width: 55%">
                                    <span>Ngày sinh </span>
                                    <asp:TextBox ID="txtNUQ_NGAYSINH" runat="server" CssClass="dangky_tk_textbox"
                                        placeholder="  ......./....../....." Width="95%" MaxLength="10"
                                        AutoPostBack="true" OnTextChanged="txtNUQ_NGAYSINH_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNUQ_NGAYSINH" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3"
                                        runat="server" TargetControlID="txtNUQ_NGAYSINH"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                        ErrorTooltipEnabled="true" />
                                </div>
                                <div style="float: right; width: 35%">
                                    <span>Năm sinh</span><span class="batbuoc">*</span>
                                    <asp:TextBox ID="txtNUQ_NamSinh" runat="server" placeholder="  ...."
                                        CssClass="dangky_tk_textbox" Width="95%" MaxLength="10"
                                        onkeypress="return isNumber(event)"></asp:TextBox>
                                </div>
                            </div>
                            <div class="dk_item" style="float: right; width: 47%;">
                                <span>Quốc tịch</span>
                                <asp:DropDownList ID="dropNUQ_QuocTich" runat="server"
                                    CssClass="dangky_tk_dropbox right" placeholder="Quốc tịch">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_hoten border_right">
                                <span>Số CMND/ Thẻ căn cước/ Hộ chiếu </span><span class="batbuoc">*</span>
                                <asp:TextBox ID="txtNUQ_CMND" runat="server"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                            <div class="dk_item dk_gioitinh">
                                <span style="margin-left: 10px;">Ngày cấp</span>
                                <asp:TextBox ID="txtNUQ_NgayCapCMND" runat="server"
                                    CssClass="dangky_tk_textbox right"
                                    placeholder="..../.../....." Width="90%"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server"
                                    TargetControlID="txtNUQ_NgayCapCMND" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                    TargetControlID="txtNUQ_NgayCapCMND" Mask="99/99/9999"
                                    MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                            </div>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span style="float: left;">Nơi cấp CMND/ Thẻ căn cước/ Hộ chiếu </span>
                                <asp:TextBox ID="txtNUQ_NoiCapCMND" runat="server"
                                    Width="95.5%"
                                    placeholder="  ...." CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                        </div>

                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <span>Điện thoại di động</span>
                                <asp:TextBox ID="txtNUQ_Mobile" runat="server" placeholder="  ...." onkeypress="return isNumber(event)"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                            <div class="dk_item" style="float: right; width: 47%;">
                                <span>Email giao dịch điện tử với Tòa án</span>
                                <asp:TextBox ID="txtNUQ_Email" runat="server" placeholder="  ...."
                                    CssClass="dangky_tk_textbox"
                                    Width="95%"></asp:TextBox>
                            </div>
                        </div>
                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item dk_diachi border_right">
                                <span>Tỉnh/ Thành phố</span>
                                <asp:DropDownList ID="dropNUQ_Tinh" runat="server" placeholder="  Tỉnh"
                                    CssClass="dangky_tk_dropbox" AutoPostBack="True"
                                    OnSelectedIndexChanged="dropNUQ_Tinh_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="float: right; width: 47%;" class="dk_item">
                                <span>Quận/ Huyện</span>
                                <asp:DropDownList ID="dropNUQ_QuanHuyen" runat="server" placeholder="  Quận"
                                    CssClass="dangky_tk_dropbox right">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="dk_fullwidth">
                            <div class="dk_item">
                                <span>Địa chỉ chi tiết </span>
                                <asp:TextBox ID="txtNUQ_DCChiTiet" runat="server"
                                    Width="95.5%"
                                    placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                    CssClass="dangky_tk_textbox"></asp:TextBox>
                            </div>
                        </div>
                        <!------------------------------>
                        <div class="dk_fullwidth">
                            <div class="dk_item" style="width: 100%;">
                                <span style="float: left;">Giấy ủy quyền</span>
                                <div style="float: left; margin-right: 10px; margin-left: 10px;">
                                    <asp:FileUpload ID="file_upload" runat="server" />
                                </div>

                            </div>
                            <div class="dk_item" style="width: 100%; margin-top: 10px;">
                                <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />

                                <div class="CSSTableGenerator" style="width: 100%;">
                                    <table style="width: 100%;">
                                        <tr id="row_header">

                                            <td>Tên tài liệu</td>
                                            <td style="width: 70px;">Xem file</td>
                                        </tr>
                                        <asp:Panel ID="pnGiayUyQuyen" runat="server" Visible="false">
                                            <tr>
                                                <td>
                                                    <asp:LinkButton ID="lkFileUyQuyen" runat="server" OnClick="lkFileUyQuyen_Click"></asp:LinkButton></td>
                                                <td style="text-align: center;">
                                                    <asp:ImageButton ID="cmdDowload" ImageUrl="/UI/img/dowload.png"
                                                        runat="server" ToolTip="Tải file xuống" Width="20px" OnClick="cmdDowload_Click"></asp:ImageButton>
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <!------------------------------>
                    </div>
                </asp:Panel>
                <div class="fullwidth">
                    <div class="msg_warning">
                        Những thông tin có dấu <span class="batbuoc">*</span>  là phần bắt buộc
                    </div>
                    <div class="msg_thongbao">
                        <asp:Literal runat="server" ID="lbthongbao"></asp:Literal>
                    </div>
                </div>
                <div class="fullwidth" style="text-align: center;">
                    <asp:Button ID="cmdUpdate" runat="server"
                        CssClass="buttoninput bg_do" Text="Cập nhật"
                        OnClientClick="return validate();" OnClick="cmdUpdate_Click" />
                </div>
            </div>
        </div>
    </div>
    <script>

        function validate() {
            var zone_message_name = 'zone_message';
            var zone_message = document.getElementById(zone_message_name);

            if (!validate_nguoitaotk())
                return false;

            var dropTuCachTT = document.getElementById('<%=dropTuCachTT.ClientID%>');
            value_change = dropTuCachTT.options[dropTuCachTT.selectedIndex].value;
            if (value_change == "DUOCUYQUYEN") {
                if (!Validate_NguoiUyQuyen())
                    return false;
            }
            return true;
        }
        function validate_nguoitaotk() {
            var zone_message_name = 'zone_message';
            var zone_message = document.getElementById(zone_message_name);

            var txtHoTen = document.getElementById('<%=txtNDD_HOTEN.ClientID%>');
            if (!Common_CheckTextBox2(txtHoTen, 'Họ và tên', zone_message_name))
                return false;

            //--------------------
            var dropGioiTinh = document.getElementById('<%=dropNDD_GIOITINH.ClientID%>');
            value_change = dropGioiTinh.options[dropGioiTinh.selectedIndex].value;
            if (value_change == "0") {
                zone_message.style.display = "block";
                zone_message.innerText = 'Bạn chưa chọn giới tính. Hãy kiểm tra lại!';
                dropGioiTinh.focus();
                return false;
            }

            //--------------------
            var CurrentYear = '<%=CurrentYear%>';
            var now = new Date();
            var temp;

            var txtNDD_NGAYSINH = document.getElementById('<%=txtNDD_NGAYSINH.ClientID%>');
            if (!Common_CheckEmpty(txtNDD_NGAYSINH.value)) {
                zone_message.style.display = "block";
                zone_message.innerText = "Bạn chưa chọn ngày sinh. Hãy kiểm tra lại!";
                txtNDD_NGAYSINH.focus();
                return false;
            }

            temp = txtNDD_NGAYSINH.value.split('/');
            temp = new Date(temp[2], temp[1] - 1, temp[0]);
            if (temp > now) {
                zone_message.style.display = "block";
                zone_message.innerText = 'Ngày sinh phải nhỏ hơn hoặc bằng ngày hiện tại!';
                txtNDD_NGAYSINH.focus();
                return false;
            }
            //-----------------------
            var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
            if (!Common_CheckTextBox2(txtNamSinh, 'Năm sinh', zone_message_name))
                return false;

            var nam_sinh = parseInt(txtNamSinh.value);
            if (nam_sinh > CurrentYear) {
                zone_message.style.display = "block";
                zone_message.innerText = 'Năm sinh không được lớn hơn năm hiện tại là năm ' + CurrentYear + '. Hãy kiểm tra lại!';
                txtNamSinh.focus();
                return false;
            }
            var sonam = CurrentYear - nam_sinh;
            if (sonam < 14) {
                zone_message.style.display = "block";
                zone_message.innerText = 'Người dùng "' + txtHoTen.value + '" chưa đủ 14 tuổi. Hãy kiểm tra lại!';
                txtNamSinh.focus();
                return false;
            }

            //--------------------
            var txtSoCMND = document.getElementById('<%=txtNDD_CMND.ClientID%>');
            if (!Common_CheckTextBox2(txtSoCMND, 'Số CMND/ Thẻ căn cước/ Hộ chiếu', zone_message_name))
                return false;

            var txtNgayCapCMND = document.getElementById('<%=txtNgayCapCMND.ClientID%>');
            if (Common_CheckEmpty(txtNgayCapCMND.value)) {
                temp = txtNgayCapCMND.value.split('/');
                temp = new Date(temp[2], temp[1] - 1, temp[0]);
                if (temp > now) {
                    zone_message.style.display = "block";
                    zone_message.innerText = 'Ngày cấp CMND/ Thẻ căn cước/ Hộ chiếu phải nhỏ hơn hoặc bằng ngày hiện tại!';
                    txtNgayCapCMND.focus();
                    return false;
                }
                //------------------------
                var arr_temp = txtNgayCapCMND.value.split('/');
                var NgayCapCMND = new Date(arr_temp[2], arr_temp[1] - 1, arr_temp[0]);
                var nam_cap_cmnd = parseInt(arr_temp[2]);

                var sonam = nam_cap_cmnd - nam_sinh;
                if (sonam < 14) {
                    zone_message.style.display = "block";
                    zone_message.innerText = 'Người dùng "' + txtHoTen.value + '" chưa đủ 14 tuổi. Hãy kiểm tra lại!';
                    txtNgayCapCMND.focus();
                    return false;
                }
            }

            var txtNoiCapCMND = document.getElementById('<%=txtNoiCapCMND.ClientID%>');
            if (!Common_CheckTextBox2(txtNoiCapCMND, 'Nơi cấp CMND/ Thẻ căn cước/ Hộ chiếu', zone_message_name))
                    return false;

            //--------------------
            var txtDienThoai = document.getElementById('<%=txtMOBILE.ClientID%>');
            if (!Common_CheckTextBox2(txtDienThoai, 'Số điện thoại', zone_message_name))
                return false;
            //--------------
            if (!validate_quoctich())
                return false;
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

    <script>

        function validate_quoctich() {
            var zone_message_name = 'zone_message';
            var zone_message = document.getElementById(zone_message_name);
            var QuocTichVN = '<%=QuocTichVN%>';
            //--------------------------------
            var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
            var value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;
            if (value_change == "") {
                zone_message.style.display = "block";
                zone_message.innerText = 'Bạn chưa chọn mục "quốc tịch". Hãy kiểm tra lại!';
                dropQuocTich.focus();
                return false;
            }
            //-----------------------------------------
            if (value_change == QuocTichVN) {
                //--------check nhap ho khau tam tru---------
                var ddlTamTru_Tinh = document.getElementById('<%=dropTamTru_Tinh.ClientID%>');
                value_change = ddlTamTru_Tinh.options[ddlTamTru_Tinh.selectedIndex].value;
                if (value_change == "0") {
                    zone_message.style.display = "block";
                    zone_message.innerText = 'Bạn chưa chọn mục "Tỉnh/TP của nơi Tạm trú". Hãy kiểm tra lại!';
                    ddlTamTru_Tinh.focus();
                    return false;
                }

                var ddlTamTru_Huyen = document.getElementById('<%=dropTamTru_Huyen.ClientID%>');
                value_change = ddlTamTru_Huyen.options[ddlTamTru_Huyen.selectedIndex].value;
                if (value_change == "0") {
                    zone_message.style.display = "block";
                    zone_message.innerText = 'Bạn chưa chọn mục "Quận/Huyện của nơi Tạm trú". Hãy kiểm tra lại!';
                    ddlTamTru_Huyen.focus();
                    return false;
                }
                var txtTamTru_ChiTiet = document.getElementById('<%=txtTamTru_ChiTiet.ClientID%>');
                if (!Common_CheckTextBox2(txtTamTru_ChiTiet, "Địa chỉ chi tiết nơi cư trú hiện tại", zone_message_name))
                    return false;
            }
            return true;
        }

        function GetLoaiTaiKhoan() {
            var rb = document.getElementById("<%=rdMucDichSD.ClientID%>");
            var inputs = rb.getElementsByTagName('input');
            var flag = false;
            var selected;
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].checked) {
                    selected = inputs[i];
                    flag = true;
                    break;
                }
            }
            if (flag)
                return selected.value;
        }

        function GetValueRadioList(control_client_id) {
            var rb = document.getElementById(control_client_id);
            var inputs = rb.getElementsByTagName('input');
            var flag = false;
            var selected;
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].checked) {
                    selected = inputs[i];
                    flag = true;
                    break;
                }
            }
            if (flag)
                return selected.value;
        }
    </script>
    <script>
        function Validate_NguoiUyQuyen() {
            var zone_message_name = 'zone_message';
            var zone_message = document.getElementById(zone_message_name);

            //--------------------
            var txtNUQ_HOTEN = document.getElementById('<%=txtNUQ_HOTEN.ClientID%>');
            if (!Common_CheckTextBox2(txtNUQ_HOTEN, 'Họ và tên người ủy quyền', zone_message_name))
                return false;
            //--------------------
            var txtNgayUyQuyen = document.getElementById('<%=txtNgayUyQuyen.ClientID%>');
            if (!CheckDateTimeControl2(txtNgayUyQuyen, 'Ngày ủy quyền', zone_message_name))
                return false;
            //--------------------
            var txtNUQ_NGAYSINH = document.getElementById('<%=txtNUQ_NGAYSINH.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_NGAYSINH.value)) {
                if (!CheckDateTimeControl2(txtNUQ_NGAYSINH, 'Ngày sinh người ủy quyền', zone_message_name))
                    return false;
            }

            var txtNUQ_NamSinh = document.getElementById('<%=txtNUQ_NamSinh.ClientID%>');
            if (!Common_CheckTextBox2(txtNUQ_NamSinh, "Năm sinh người ủy quyền", zone_message_name))
                return false;

            var CurrentYear = '<%=CurrentYear%>';
            var nam_sinh = parseInt(txtNUQ_NamSinh);
            if (nam_sinh > CurrentYear) {
                alert('Năm sinh không được lớn hơn năm ' + CurrentYear + '. Hãy kiểm tra lại!');
                txtNUQ_NamSinh.focus();
                return false;
            }

            //--------------------
            var txtNUQ_CMND = document.getElementById('<%=txtNUQ_CMND.ClientID%>');
            if (!Common_CheckTextBox2(txtNUQ_CMND, "Số CMND/ Thẻ căn cước/ Hộ chiếu của người ủy quyền", zone_message_name))
                return false;

            var txtNUQ_NgayCapCMND = document.getElementById('<%=txtNUQ_NgayCapCMND.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_NgayCapCMND.value)) {
                if (!CheckDateTimeControl2(txtNUQ_NgayCapCMND, 'Ngày cấp CMND/ Thẻ căn cước/ Hộ chiếu của người ủy quyền', zone_message_name))
                    return false;
            }
            var txtNUQ_NoiCapCMND = document.getElementById('<%=txtNUQ_NoiCapCMND.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_NoiCapCMND.value)) {
                if (!Common_CheckTextBox2(txtNUQ_NoiCapCMND, 'Nơi cấp CMND/ Thẻ căn cước/ Hộ chiếu của người ủy quyền', zone_message_name))
                    return false;
            }
            //--------------------
            var txtNUQ_Email = document.getElementById('<%=txtNUQ_Email.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_Email.value)) {
                if (!Common_ValidateEmail_ShowZoneMsg(txtNUQ_Email.value, zone_message_name)) {
                    txtNUQ_Email.focus();
                    return false;
                }
            }

            //--------------------
            if (!ValidateFileUpload())
                return false;
            return true;
        }
        function ValidateFileUpload() {
            var zone_message_name = 'zone_message';
            var zone_message = document.getElementById(zone_message_name);
            var allowedFiles = [".doc", ".docx", ".pdf", ".jpg", ".jpeg", ".png"];

            var fileUpload = document.getElementById('<%= file_upload.ClientID %>');
            var hddFileKySo = document.getElementById('<%=hddFileKySo.ClientID%>');
            if (hddFileKySo.value == "0") {
                if (!Common_CheckEmpty(fileUpload.value)) {
                    fileUpload.focus();
                    zone_message.style.display = "block";
                    zone_message.innerText = 'Bạn chưa cung cấp giấy ủy quyền dưới dạng file mềm. Hãy kiểm tra lại!';
                    return false;
                }
                var regex = new RegExp("([a-zA-Z0-9\s_\\.\-:])+(" + allowedFiles.join('|') + ")$");
                if (!regex.test(fileUpload.value.toLowerCase())) {
                    zone_message.style.display = "block";
                    zone_message.innerText = 'Giấy ủy quyền chỉ cho phép chọn một trong các định dạng file: .doc, .docx, .pdf, .jpg, .jpeg, .png. Bạn hãy kiểm tra lại!';
                    return false;
                }
            }
            else
                hddFileCu.value = "1"
            return true;
        }

    </script>

</asp:Content>
