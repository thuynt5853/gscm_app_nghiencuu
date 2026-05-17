<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true" CodeBehind="DangKyTK.aspx.cs" Inherits="WEB.DONKHOIKIEN.DangKyTK" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Personnal/UC/Help.ascx" TagPrefix="uc1" TagName="Help" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .other_width {
            width: 97.5%;
        }

        .content_body {
            /*background: #d02629 url('/UI/img/bg_red.png') no-repeat;*/
            /*-webkit-box-shadow: inset 1px 86px 10px -77px #c30f12;
            -moz-box-shadow: inset 1px 86px 10px -77px #c30f12;
            box-shadow: inset 1px 86px 10px -77px #c30f12;*/
        }

        .content_form {
            margin-top: 0px;
        }

        .dangky_head {
            box-shadow: 1px 78px 10px -77px #c30f12 inset;
        }

        .no_ok { /*background:#c70f0d;*/
            background: url('/UI/img/warning16.png') no-repeat;
            float: left;
            margin-left: 5px;
            width: 17px;
            height: 16px;
        }

        .ok { /*background:green;*/
            background: url('/UI/img/ok.png') no-repeat;
            border-radius: 100%;
            padding: 8px;
            float: left;
            margin-left: 5px;
        }
         .zoneright:last-child{margin-bottom:0px;}
    </style>

    <asp:HiddenField ID="hddTrangThai" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowPopup" runat="server" Value="0" />
    <div class="content_center">
        <div class="dangky_tk" style="box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
            <div class="dangky_head border_radius_top">
                <div class="dangky_head_title">Đăng ký tài khoản</div>
                <div class="dangky_head_right" style="margin-right: 20px;">
                    <uc1:Help runat="server" ID="Help" />
                </div>
            </div>
            <div class="dangky_content">
                <asp:Panel ID="pnChuKySo" runat="server">
                    <div class="dk_fullwidth">
                        <b>Bước 1: Xác nhận chứng thư số</b>
                    </div>
                    <!----------------------------------------------->
                    <asp:Panel ID="pnThongTinCKSo" runat="server">
                        <div class="zoneleft" style="margin-bottom: 0px; width: 99%; margin-top: 10px; float: left;">
                            <div class="header_title">
                                <span style="float: left;">Thông tin chứng thư số</span>
                                <asp:Literal ID="lttTrangThai" runat="server"></asp:Literal>
                            </div>
                            <div class="border_content" style="width: 97%; padding: 12px 1.5%;">
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
                        </div>
                    </asp:Panel>
                    <div style="float: left; margin-top: 10px; text-align: center; width: 100%;">
                        <asp:HiddenField ClientIDMode="Static" ID="Signature1" runat="server" />
                        <asp:Button ClientIDMode="Static" ID="cmdCheckChuKySo"
                            runat="server" Text="Kiểm tra chứng thư số" CssClass="button_checkchkso"
                            OnClientClick="return exc_auth('cmdCheckChuKySo');" OnClick="cmdCheckChuKySo_Click" />
                        <asp:Button ClientIDMode="Static" ID="cmdNext"
                            runat="server" Text="Tiếp tục" CssClass="button_checkchkso"
                            OnClick="cmdNext_Click" />
                    </div>
                    <div style="float: left; width: 100%;">
                        <asp:HiddenField ID="hddMa" runat="server" Value="hdsd_chukyso" />
                        <asp:Literal ID="lttGhiChu" runat="server"></asp:Literal>
                    </div>
                    <asp:Literal ID="lttThongBao" runat="server"></asp:Literal>
                </asp:Panel>

                <asp:Panel ID="pnDangKy" runat="server">
                    <b>Bước 2: Cập nhật thông tin tài khoản</b><br />
                    <div class="dangky_loaitk">
                        <div class="dk_fullwidth">
                            <span class="titleloaitaikhoan">Loại tài khoản</span> <span class="loaitk"></span>
                            <div class="dv_USERTYPE">
                                <asp:RadioButtonList ID="radUSERTYPE" CssClass="dangky_rd" runat="server"
                                    OnSelectedIndexChanged="radUSERTYPE_SelectedIndexChanged"
                                    RepeatDirection="Horizontal" AutoPostBack="True">
                                    <asp:ListItem Value="1" Selected="True"><b>Cá nhân</b></asp:ListItem>
                                    <asp:ListItem Value="2"><b>Doanh nghiệp</b></asp:ListItem>
                                    <asp:ListItem Value="3"><b>Cơ quan/ Tổ chức</b></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                    </div>
                    <div class="dangky_content_form">
                        <div class="fullwidth">
                            <div class="msg_warning">
                                Những thông tin có dấu <span class="batbuoc">*</span>  là phần bắt buộc
                            </div>
                            <asp:Literal runat="server" ID="lblThongBaoTop"></asp:Literal>
                        </div>
                        <div class="zoneleft" style="margin-bottom: 0px;">
                            <div class="header_title">
                                <asp:Literal ID="lttTenLoaiTK" runat="server"></asp:Literal>
                            </div>

                            <div class="border_content">
                                <asp:Panel ID="pnIsUyQuyen" runat="server">
                                    <div class="div_ttcanhan">
                                        <div class="TitleUyQuyen"  style="line-height:35px;font-weight:bold;">Bạn là </div>
                                         <asp:DropDownList ID="dropTuCachTT" runat="server" CssClass="dangky_tk_dropbox" Width="50%">
                                        </asp:DropDownList>
                                    </div>
                                </asp:Panel>
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_hoten border_right">
                                        <span>Họ và tên</span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtNDD_HOTEN" runat="server"
                                            CssClass="dangky_tk_textbox" placeholder="  ...."></asp:TextBox>
                                    </div>
                                    <div class="dk_item dk_gioitinh">
                                        <span>Giới tính </span><span class="batbuoc">*</span>
                                        <asp:DropDownList ID="dropNDD_GIOITINH" runat="server"
                                            CssClass="dangky_tk_dropbox" placeholder="  Chọn giới tính">
                                            <asp:ListItem Value="1">Nam</asp:ListItem>
                                            <asp:ListItem Value="2">Nữ</asp:ListItem>
                                            <asp:ListItem Value="3">Khác</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_ngaysinh border_right">
                                        <div style="float: left; width: 55%">
                                            <span>Ngày sinh </span><span class="batbuoc">*</span>
                                            <asp:TextBox ID="txtNDD_NGAYSINH" runat="server" CssClass="dangky_tk_textbox"
                                                placeholder="  ......./....../....." Width="95%" MaxLength="10"
                                                AutoPostBack="true" OnTextChanged="txtNDD_NGAYSINH_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNDD_NGAYSINH" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNDD_NGAYSINH" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </div>
                                        <div style="float: right; width: 43%">
                                            <span>Năm sinh</span><span class="batbuoc">*</span>
                                            <asp:TextBox ID="txtNamSinh" runat="server" placeholder="  ...."
                                                CssClass="dangky_tk_textbox" Width="80%" MaxLength="10"
                                                onkeypress="return isNumber(event)" AutoPostBack="true" OnTextChanged="txtNamSinh_TextChanged"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="dk_item" style="float: right; width: 47%;">
                                        <span>Quốc tịch</span>
                                        <asp:DropDownList ID="dropQuocTich" runat="server"
                                            CssClass="dangky_tk_dropbox" placeholder="Quốc tịch">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <!------------------------------>
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_hoten border_right">
                                        <span>Số CMND/ Thẻ căn cước/ Hộ chiếu </span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtNDD_CMND" runat="server" placeholder="  ...."
                                            CssClass="dangky_tk_textbox"></asp:TextBox>

                                    </div>
                                    <div class="dk_item dk_gioitinh">
                                        <span style="float: left; width: 90%;">Ngày cấp</span>
                                        <asp:TextBox ID="txtNgayCapCMND" runat="server"
                                            CssClass="dangky_tk_textbox"
                                            placeholder="  ..../.../....." Width="94%"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayCapCMND" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayCapCMND" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </div>
                                </div>
                                <div class="dk_fullwidth">
                                    <div class="dk_item">
                                        <span style="float: left;">Nơi cấp CMND/ Thẻ căn cước/ Hộ chiếu </span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtNoiCapCMND" runat="server" placeholder="  ...."
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                </div>
                                <!------------------------------>
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_diachi border_right">
                                        <span>Điện thoại di động</span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtMOBILE" runat="server" placeholder="  ...."
                                            CssClass="dangky_tk_textbox"
                                            onkeypress="return isNumber(event)"></asp:TextBox>
                                    </div>
                                    <div style="float: right; width: 47%;" class="dk_item">
                                        <span>Điện thoại cố định</span>
                                        <asp:TextBox ID="txtTelephone" runat="server"
                                            placeholder="  ...." CssClass="dangky_tk_textbox" Width="94%"
                                            onkeypress="return isNumber(event)"></asp:TextBox>
                                    </div>
                                </div>
                                <!-----------thuong tru------------------->
                                <div style="display: none;">
                                    <div class="dk_fullwidth">
                                        <div class="dk_item dk_diachi border_right">
                                            <span>Tỉnh/ Thành phố thường trú</span>
                                            <asp:DropDownList ID="dropTinh" runat="server" placeholder="  Tỉnh"
                                                CssClass="dangky_tk_dropbox" AutoPostBack="True"
                                                OnSelectedIndexChanged="dropTinh_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: right; width: 47%;" class="dk_item">
                                            <span>Quận/ Huyện</span>
                                            <asp:DropDownList ID="dropQuan" runat="server" placeholder="  Quận"
                                                CssClass="dangky_tk_dropbox">
                                            </asp:DropDownList>

                                        </div>
                                    </div>
                                    <div class="dk_fullwidth">
                                        <div class="dk_item">
                                            <span>Địa chỉ chi tiết hộ khẩu thường trú</span>
                                            <asp:TextBox ID="txtDiaChiCT" runat="server"
                                                placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                                CssClass="dangky_tk_textbox"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <!---------tam tru--------------------->
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_diachi border_right">
                                        <span>Tỉnh/Thành phố nơi cư trú</span><span class="batbuoc">*</span>
                                        <asp:DropDownList ID="dropTamTru_Tinh" runat="server" placeholder="  Tỉnh"
                                            CssClass="dangky_tk_dropbox" AutoPostBack="True"
                                            OnSelectedIndexChanged="dropTamTru_Tinh_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: right; width: 47%;" class="dk_item">
                                        <span>Quận/ Huyện</span><span class="batbuoc">*</span>
                                        <asp:DropDownList ID="dropTamTru_Huyen" runat="server" placeholder="  Quận"
                                            CssClass="dangky_tk_dropbox">
                                        </asp:DropDownList>

                                    </div>
                                </div>
                                <div class="dk_fullwidth">
                                    <div class="dk_item">
                                        <span>Địa chỉ chi tiết nơi cư trú hiện tại</span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtTamTru_ChiTiet" runat="server"
                                            placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                </div>
                                <!------------------------------>
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_diachi border_right">
                                        <span>Chức vụ</span>
                                        <asp:TextBox ID="txtNDD_ChucVu" runat="server" placeholder="  ...."
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
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
                                        <asp:TextBox ID="txtNgheNghiep" runat="server" placeholder="  ....."
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <asp:Panel ID="plDoanhNghiep" runat="server" Visible="False">
                            <div class="zoneright">
                                <div class="header_title">
                                    <asp:Literal ID="lttTitleDN" runat="server"></asp:Literal>
                                </div>
                                <div class="border_content">
                                    <asp:Panel ID="pnDNMaSoThue" runat="server">
                                        <div class="dk_fullwidth">
                                            <div class="dk_item dk_ngaysinh border_right">
                                                <span>Mã số thuế</span><span class="batbuoc">*</span>
                                                <asp:TextBox ID="txtDN_MASOTHUE" runat="server" onkeypress="return isNumber(event)"
                                                    CssClass="dangky_tk_textbox"
                                                    placeholder="  ...."></asp:TextBox>
                                            </div>
                                            <div class="dk_item dk_dienthoai">
                                                <span>Số giấy phép kinh doanh</span><span class="batbuoc">*</span>
                                                <asp:TextBox ID="txtDN_GPDKKD" runat="server"
                                                    CssClass="dangky_tk_textbox"
                                                    placeholder="  ...."></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <div class="dk_fullwidth">
                                        <div class="dk_item">
                                            <span>
                                                <asp:Literal ID="lttTenDN" runat="server"></asp:Literal></span>
                                            <span class="batbuoc">*</span>
                                            <asp:TextBox ID="txtDN_TENVN" runat="server"
                                                CssClass="dangky_tk_textbox"
                                                placeholder="  ...."></asp:TextBox>
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
                                                <span>Tên tiếng anh</span>
                                                <asp:TextBox ID="txtDN_TENEN" runat="server"
                                                    CssClass="dangky_tk_textbox"
                                                    placeholder="  ...."></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <div class="dk_fullwidth">
                                        <div class="dk_item dk_ngaysinh border_right" style="width: 30%;">
                                            <span>Điện thoại</span>
                                            <asp:TextBox ID="txtDN_DienThoai" runat="server"
                                                CssClass="dangky_tk_textbox" onkeypress="return isNumber(event)"
                                                placeholder="  ...."></asp:TextBox>
                                        </div>
                                        <div class="dk_item dk_dienthoai"
                                            style="width: 65%; margin-left: 3%; float: left;">
                                            <span>Địa chỉ</span>
                                            <asp:TextBox ID="txtDN_DiaChi" runat="server"
                                                CssClass="dangky_tk_textbox other_width"
                                                placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <div class="zoneright">
                            <div class="header_title">thông tin tài khoản</div>
                            <div class="border_content">
                                <div class="dk_fullwidth">
                                    <div class="dk_item" style="padding-bottom: 0px;">
                                        <span style="width: 100%; float: left; padding-bottom: 5px;">Mục đích sử dụng</span>
                                        <asp:RadioButtonList ID="rdMucDichSD" CssClass="dangky_rd_mucdichsd" runat="server" RepeatDirection="Vertical">
                                            <asp:ListItem Value="1" Selected="True"><b>Nộp đơn khởi kiện và nhận văn bản tống đạt</b></asp:ListItem>

                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="dk_fullwidth">
                                    <div class="dk_item">
                                        <span>Email giao dịch điện tử với Tòa án<br />
                                            (<i>Sử dụng làm tài khoản đăng nhập hệ thống</i>)</span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtEMAIL" runat="server" placeholder="  ...."
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                </div>
                              
                                <div class="dk_fullwidth"> 
                                    <div class="dk_item dk_diachi border_right">
                                        <span>Mật khẩu tài khoản đăng nhập</span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtPASSWORD" runat="server" placeholder="  ...." TextMode="Password" CssClass="dangky_tk_textbox"></asp:TextBox>

                                    </div>
                                    <div style="float: right; width: 47%;" class="dk_item">
                                        <span>Nhập lại mật khẩu tài khoản</span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtREPASSWORD" placeholder="  ...." TextMode="Password" runat="server"
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="zoneright" id="zoneThemUyQuyen" style="display: none; margin-bottom: 0px;">
                            <%-- <a href="#close" title="Close" class="close" >X</a>
                            <a href="javascript:;" title="Đóng" class="close" onclick="close_popup()">X</a>--%>
                            <div class="header_title">
                                Thông tin người ủy quyền
                            </div>

                            <div class="border_content">
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_hoten border_right">
                                        <span>Họ và tên</span><span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtNUQ_HOTEN" runat="server"
                                            CssClass="dangky_tk_textbox" placeholder="  ...."></asp:TextBox>
                                    </div>
                                    <div class="dk_item dk_gioitinh">
                                        <span>Giới tính </span><span class="batbuoc">*</span>
                                        <asp:DropDownList ID="dropNUQ_GIOITINH" runat="server"
                                            CssClass="dangky_tk_dropbox" placeholder="  Chọn giới tính">
                                            <asp:ListItem Value="1">Nam</asp:ListItem>
                                            <asp:ListItem Value="2">Nữ</asp:ListItem>
                                            <asp:ListItem Value="3">Khác</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_hoten border_right">
                                        <div style="float: left; width: 50%">
                                            <span>Ngày sinh </span>
                                            <asp:TextBox ID="txtNUQ_NGAYSINH" runat="server" CssClass="dangky_tk_textbox"
                                                placeholder="  ......./....../....." Width="95%" MaxLength="10"
                                                AutoPostBack="true" OnTextChanged="txtNUQ_NGAYSINH_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                TargetControlID="txtNUQ_NGAYSINH" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3"
                                                runat="server" TargetControlID="txtNUQ_NGAYSINH"
                                                Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" />
                                        </div>
                                        <div style="float: right; width: 43%; text-align: right;">
                                            <span>Năm sinh</span><span class="batbuoc">*</span>
                                            <asp:TextBox ID="txtNUQ_NamSinh" runat="server" placeholder="  ...."
                                                CssClass="dangky_tk_textbox" Width="95%" MaxLength="10"
                                                onkeypress="return isNumber(event)"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="dk_item dk_gioitinh">
                                        <span>Quốc tịch</span>
                                        <asp:DropDownList ID="dropNUQ_QuocTich" runat="server"
                                            CssClass="dangky_tk_dropbox" placeholder="Quốc tịch" Width="99%">
                                        </asp:DropDownList>
                                    </div>

                                </div>
                                <!------------------------------>
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_hoten border_right">
                                        <span>Số CMND/ Thẻ căn cước/ Hộ chiếu </span>
                                        <span class="batbuoc">*</span>
                                        <asp:TextBox ID="txtNUQ_CMND" runat="server" placeholder="  ...."
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                    <div class="dk_item dk_gioitinh">
                                        <span style="float: left; width: 90%;">Ngày cấp</span>
                                        <asp:TextBox ID="txtNUQ_NgayCapCMND" runat="server"
                                            CssClass="dangky_tk_textbox"
                                            placeholder="  ..../.../....." Width="94%"></asp:TextBox>
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
                                            placeholder="  ...." CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                </div>


                                <!------------------------------>
                                <div class="dk_fullwidth">
                                    <div class="dk_item dk_ngaysinh border_right">
                                        <span>Điện thoại di động</span>
                                        <asp:TextBox ID="txtNUQ_Mobile" runat="server"
                                            placeholder="  ...." onkeypress="return isNumber(event)"
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                    <div class="dk_item" style="float: right; width: 47%;">
                                        <span>Hòm thư điện tử</span>
                                        <asp:TextBox ID="txtNUQ_Email" runat="server" placeholder="  ...."
                                            CssClass="dangky_tk_textbox"
                                            Width="91%"></asp:TextBox>
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
                                            CssClass="dangky_tk_dropbox">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="dk_fullwidth">
                                    <div class="dk_item">
                                        <span>Địa chỉ chi tiết </span>
                                        <asp:TextBox ID="txtNUQ_DCChiTiet" runat="server"
                                            placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã … "
                                            CssClass="dangky_tk_textbox"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="dk_fullwidth">
                                    <div class="dk_item" style="float: left; width: 48%">
                                        <span>Loại ủy quyền</span>
                                        <asp:DropDownList ID="dropLoaiUyQuyen" runat="server"
                                            CssClass="dangky_tk_dropbox" placeholder="Quốc tịch">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="dk_item" style="float: right; width: 48%">
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
                                <!------------------------------>
                                <div class="dk_fullwidth">
                                    <div class="dk_item">
                                        <span style="float: left;">Giấy ủy quyền</span>
                                        <asp:FileUpload ID="fileupload" runat="server" />
                                    </div>
                                </div>
                                <!------------------------------>
                            </div>
                        </div>
                            <div class="fullwidth" style="font-size:14px; text-align:justify ;line-height:25px;">
                                <div style="width:100%;height:200px;overflow-y:scroll;margin: 10px 0px 10px 0px;">
                                    <asp:Literal ID ="lttMsgDK" runat="server"></asp:Literal>
                                </div>
                             
                            <asp:CheckBox ID="chkConfirm" runat="server" Font-Bold="true" Text="Tôi đã đọc và đồng ý với các quy định giao dịch điện tử" />
                        </div>
                        <div class="fullwidth" style="margin-top: 0px; margin-bottom: 5px;">                          
                            <div class="msg_thongbao">
                                <asp:Literal runat="server" ID="lbthongbao"></asp:Literal>
                            </div>
                        </div>
                        <div class="fullwidth" style="text-align: center; margin-top: 0px; margin-bottom: 5px;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="button_checkchkso"
                                Text="Đồng ý" OnClick="cmdUpdate_Click"
                                OnClientClick="return validate();" />

                            <asp:Button ID="btnKhongDongY" runat="server" CssClass="button_checkchkso"
                                Text="Không đồng ý" OnClick="cmdNotUpdate_Click" />
                        </div>
                    </div>
                </asp:Panel>

               
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hidDVCQGCode" runat="server" />
    <script>
        function GetLoaiTaiKhoan() {
            var rb = document.getElementById("<%=radUSERTYPE.ClientID%>");
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
        //--------------
      <%--  function GetTrangThaiUyQuyen() {
            var rdIsUyQuyen = document.getElementById("<%=rdIsUyQuyen.ClientID%>");
            var inputs = rdIsUyQuyen.getElementsByTagName('input');
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
        }--%>
        function CheckUyQuyen() {
            
            var status_uyquyen = 0;
            var loaitk = GetLoaiTaiKhoan();
            if (loaitk == 1) {
                var dropTuCachTT = document.getElementById('<%= dropTuCachTT.ClientID%>');
                var value_change = dropTuCachTT.options[dropTuCachTT.selectedIndex].value;
                if (value_change == "DUOCUYQUYEN")
                    status_uyquyen = 2;
            }
            var hddTrangThai = document.getElementById('<%=hddTrangThai.ClientID%>');
            var hddShowPopup = document.getElementById('<%=hddShowPopup.ClientID%>');

            if (loaitk == 1) {
                if (status_uyquyen == 2) {
                    hddTrangThai.value = "1";
                    document.getElementById('zoneThemUyQuyen').style.display = "";
                    hddShowPopup.value = "1";
                }
                else {
                    hddTrangThai.value = "0";
                    document.getElementById('zoneThemUyQuyen').style.display = "none";
                    hddShowPopup.value = "0";
                }
            }
            else {
                hddTrangThai.value = "0";
                document.getElementById('zoneThemUyQuyen').style.display = "none";
                hddShowPopup.value = "0";
            }
        }

        //--------------------------
        function close_popup() {
            var hddShowPopup = document.getElementById('<%=hddShowPopup.ClientID%>');
            hddShowPopup.value = "0";
            document.getElementById('openModal').style = "opacity: 0;pointer-events: none;";
        }
        function show_popup() {
            var hddShowPopup = document.getElementById('<%=hddShowPopup.ClientID%>');
            hddShowPopup.value = "1";
            document.getElementById('openModal').style = "opacity: 1;pointer-events: auto;";
        }
        //--------------------------
        $(document).ready(function () {

            CheckUyQuyen();

            if (document.getElementById('<%=hddTrangThai.ClientID%>').value == "1")
                document.getElementById('zoneThemUyQuyen').style.display = "";
            else
                document.getElementById('zoneThemUyQuyen').style.display = "none";

            var rb = document.getElementById("<%=radUSERTYPE.ClientID%>");
            if (rb.value == "1" && document.getElementById('<%=hddShowPopup.ClientID%>').value == "1") {
                document.getElementById('zoneThemUyQuyen').style.display = "";
                // show_popup();
            }

        });
    </script>
    <script>
        //------------------------------------------------
        function validate() {
            var sonam = 0;
            var NDD_NamSinh = 0;

            
            var loaitk = GetLoaiTaiKhoan();

            var status_uyquyen = 0;
            if (loaitk == 1) {
                var dropTuCachTT = document.getElementById('<%= dropTuCachTT.ClientID%>');
                var value_change = dropTuCachTT.options[dropTuCachTT.selectedIndex].value;
                if (value_change == "DUOCUYQUYEN")
                    status_uyquyen = 2;
                else
                    status_uyquyen = 1;
            }
            //-------------------------------
            var txtNDD_HOTEN = document.getElementById('<%=txtNDD_HOTEN.ClientID%>');
            if (!Common_CheckTextBox(txtNDD_HOTEN, 'Họ và tên'))
                return false;

            //--------------------
            var CurrYear = '<%=CurrYear%>';

            var txtNDD_NGAYSINH = document.getElementById('<%=txtNDD_NGAYSINH.ClientID%>');
            if (!CheckDateTimeControl(txtNDD_NGAYSINH, 'Ngày sinh'))
                return false;

            var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
            if (!Common_CheckEmpty(txtNamSinh.value)) {
                alert('Bạn chưa nhập "Năm sinh". Hãy kiểm tra lại!');
                txtNamSinh.focus();
                return false;
            }
            else {
                NDD_NamSinh = parseInt(txtNamSinh.value);
                if (CurrYear >= NDD_NamSinh) {
                    sonam = CurrYear - NDD_NamSinh;
                    if (sonam < 14) {
                        if (loaitk == "1") {
                            if (status_uyquyen == "2")
                                alert('Người đại diện chưa đủ 14 tuổi. Hãy kiểm tra lại!');
                            else
                                alert('Cá nhân đăng ký tài khoản chưa đủ 14 tuổi. Hãy kiểm tra lại');
                        }
                        else
                            alert('Người đại diện chưa đủ 14 tuổi. Hãy kiểm tra lại!');
                        txtNamSinh.focus();
                        return false;
                    }
                }
                else {
                    alert('Năm sinh không được lớn hơn năm hiện tại. Hãy kiểm tra lại');
                    txtNamSinh.focus();
                    return false;
                }
            }

            //--------------------
            var txtNDD_CMND = document.getElementById('<%=txtNDD_CMND.ClientID%>');
            if (!Common_CheckTextBox(txtNDD_CMND, 'Số CMND/ Thẻ căn cước/ Hộ chiếu'))
                return false;

            var txtNgayCapCMND = document.getElementById('<%=txtNgayCapCMND.ClientID%>');
            if (Common_CheckEmpty(txtNgayCapCMND.value)) {
                if (!CheckDateTimeControl(txtNgayCapCMND, 'Ngày cấp CMND/ Thẻ căn cước/ Hộ chiếu'))
                    return false;

                //----------------------------
                NDD_NamSinh = parseInt(txtNamSinh.value);
                var temp = txtNgayCapCMND.value.split('/');
                var Nam_CapCMND = parseInt(temp[2]);
                sonam = Nam_CapCMND - NDD_NamSinh;
                if (sonam < 14) {
                    if (loaitk == "1") {
                        if (status_uyquyen == "2")
                            alert('Người đại diện chưa đủ 14 tuổi. Hãy kiểm tra lại!');
                        else
                            alert('Cá nhân đăng ký tài khoản chưa đủ 14 tuổi. Hãy kiểm tra lại');
                    }
                    else
                        alert('Người đại diện chưa đủ 14 tuổi. Hãy kiểm tra lại!');
                    txtNgayCapCMND.focus();
                    return false;
                }
            }

            var txtNoiCapCMND = document.getElementById('<%=txtNoiCapCMND.ClientID%>');
            if (!Common_CheckEmpty(txtNoiCapCMND.value)) {
                if (!Common_CheckTextBox(txtNoiCapCMND, 'Nơi cấp CMND/ Thẻ căn cước/ Hộ chiếu'))
                    return false;
            }          //--------------------
            var txtMOBILE = document.getElementById('<%=txtMOBILE.ClientID%>');
            if (!Common_CheckEmpty(txtMOBILE.value)) {
                alert('Bạn chưa nhập "Số điện thoại". Hãy kiểm tra lại!');
                txtMOBILE.focus();
                return false;
            } else {
                var sodienthoai = txtMOBILE.value;
                if (sodienthoai.length < 10) {
                    alert('Số điện thoại di động phải nhiều hơn 9 ký tự');
                    txtMOBILE.focus();
                    return false;
                }
            }
            //check tỉnh thành phố
            var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
            if (dropQuocTich.value=='2') {
                //kiểm tra có nhập nơi cư trú dropTamTru_Tinh
                var dropTamTru_Tinh = document.getElementById('<%=dropTamTru_Tinh.ClientID%>');
                if (dropTamTru_Tinh.value=='0') {
                    alert('Bạn chưa chọn Tỉnh/Thành phố nơi cư trú . Hãy kiểm tra lại!');
                    dropTamTru_Tinh.focus();
                    return false;
                }
                //dropTamTru_Huyen
                var dropTamTru_Huyen = document.getElementById('<%=dropTamTru_Huyen.ClientID%>');
                if (dropTamTru_Huyen.value == '0') {
                    alert('Bạn chưa chọn Quận/ Huyện . Hãy kiểm tra lại!');
                    dropTamTru_Huyen.focus();
                    return false;
                }
            }


            //txtTamTru_ChiTiet
            var txtTamTru_ChiTiet = document.getElementById('<%=txtTamTru_ChiTiet.ClientID%>');
            if (!Common_CheckEmpty(txtTamTru_ChiTiet.value)) {
                if (!Common_CheckTextBox(txtTamTru_ChiTiet, 'Địa chỉ chi tiết nơi cư trú hiện tại'))
                    return false;
            }

            //--------------------------------
            if (loaitk == 2) {
                if (!Validate_ThongTinDN())
                    return false;
            }
            if (loaitk == 3) {
                if (!Validate_ThongTinTC())
                    return false;
            }
            //--------------------
            var txtEmail = document.getElementById('<%=txtEMAIL.ClientID%>');
            if (!Common_CheckEmpty(txtEmail.value)) {
                alert('Bạn chưa nhập "Địa chỉ email". Hãy kiểm tra lại!');
                txtEmail.focus();
                return false;
            }
            else {
                if (!Common_ValidateEmail(txtEmail.value)) {
                    txtEmail.focus();
                    return false;
                }
            }

            //--------------------
            if (document.getElementById('<%=hidDVCQGCode.ClientID%>').value.length == 0) {
                //chi kiem tra mat khau trong truong hop dang ky ko phai tu DVCQG
                var txtPass = document.getElementById('<%=txtPASSWORD.ClientID%>');
                if (!Common_CheckEmpty(txtPass.value)) {
                    alert('Bạn chưa nhập "Mật khẩu". Hãy kiểm tra lại!');
                    txtPass.focus();
                    return false;
                }

                //--------------------
                var txtRePass = document.getElementById('<%=txtREPASSWORD.ClientID%>');
                if (!Common_CheckEmpty(txtRePass.value)) {
                    alert('Bạn chưa nhập mục "Nhập lại mật khẩu". Hãy kiểm tra lại!');
                    txtRePass.focus();
                    return false;
                }
            

                if (txtPass.value != txtRePass.value) {
                    alert('Bạn nhập mục "Nhập lại mật khẩu" chưa khớp với "Mật khẩu". Hãy kiểm tra lại!');
                    txtRePass.focus();
                    return false;
                }
            }

            //-----------------------
            if (loaitk == 1) {
                if (status_uyquyen == 2)
                {
                    if (!Validate_NguoiUyQuyen())
                        return false;
                }
            }
            //----------------------
            if (!validate_confirm_dk())
                return false;
            //----------------------
            return true;
        }
        function validate_confirm_dk() {
            var chkConfirm = document.getElementById('<%=chkConfirm.ClientID%>');
            if (!chkConfirm.checked) {
                alert('Mục xác nhận đồng ý với các quy định giao dịch điện tử chưa được chọn. Hãy kiểm tra lại!');
                chkConfirm.focus();
                return false;
            }
            return true;
        }

        function Validate_ThongTinDN() {
            var txtDN_MASOTHUE = document.getElementById('<%= txtDN_MASOTHUE.ClientID%>');
            if (!Common_CheckTextBox(txtDN_MASOTHUE, 'mã số thuế'))
                return false;
            var txtDN_GPDKKD = document.getElementById('<%= txtDN_GPDKKD.ClientID%>');
            if (!Common_CheckTextBox(txtDN_GPDKKD, 'Số giấy phép đăng ký kinh doanh'))
                return false;
            var txtDN_TENVN = document.getElementById('<%= txtDN_TENVN.ClientID%>');
            if (!Common_CheckTextBox(txtDN_TENVN, 'Tên doanh nghiệp bằng tiếng Việt'))
                return false;
            return true;
        }
        function Validate_ThongTinTC() {
            var txtDN_TENVN = document.getElementById('<%= txtDN_TENVN.ClientID%>');
            if (!Common_CheckTextBox(txtDN_TENVN, 'Tên tổ chức bằng tiếng Việt'))
                return false;
            return true;
        }
        function Validate_NguoiUyQuyen() {

            var txtNUQ_HOTEN = document.getElementById('<%=txtNUQ_HOTEN.ClientID%>');
            if (!Common_CheckTextBox(txtNUQ_HOTEN, 'Họ và tên người ủy quyền'))
                return false;
            //--------------------
            var txtNgayUyQuyen = document.getElementById('<%=txtNgayUyQuyen.ClientID%>');
            if (!CheckDateTimeControl(txtNgayUyQuyen, 'Ngày ủy quyền'))
                return false;
            //--------------------
            var txtNUQ_NGAYSINH = document.getElementById('<%=txtNUQ_NGAYSINH.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_NGAYSINH, 'Ngày sinh người ủy quyền')) {
                if (!CheckDateTimeControl(txtNUQ_NGAYSINH, 'Ngày sinh người ủy quyền'))
                    return false;
            }

            var txtNUQ_NamSinh = document.getElementById('<%=txtNUQ_NamSinh.ClientID%>');
            if (!Common_CheckEmpty(txtNUQ_NamSinh.value)) {
                alert('Bạn chưa nhập "Năm sinh" người ủy quyền. Hãy kiểm tra lại!');
                txtNUQ_NamSinh.focus();
                return false;
            }
            var CurrentYear = '<%=CurrYear%>';
            if (txtNUQ_NamSinh.value > CurrentYear) {
                alert('Năm sinh không được lớn hơn năm hiện tại là năm ' + CurrentYear + '. Hãy kiểm tra lại!');
                txtNUQ_NamSinh.focus();
                return false;
            }

            //--------------------
            var txtNUQ_CMND = document.getElementById('<%=txtNUQ_CMND.ClientID%>');
            if (!Common_CheckTextBox(txtNUQ_CMND, 'Số CMND/ Thẻ căn cước/ Hộ chiếu'))
                return false;

            var txtNUQ_NgayCapCMND = document.getElementById('<%=txtNUQ_NgayCapCMND.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_NgayCapCMND.value)) {
                if (!CheckDateTimeControl(txtNUQ_NgayCapCMND, 'Ngày cấp CMND/ Thẻ căn cước/ Hộ chiếu'))
                    return false;
            }
            var txtNUQ_NoiCapCMND = document.getElementById('<%=txtNUQ_NoiCapCMND.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_NoiCapCMND.value)) {
                if (!Common_CheckTextBox(txtNUQ_NoiCapCMND, 'Nơi cấp CMND/ Thẻ căn cước/ Hộ chiếu'))
                    return false;
            }
            //--------------------
            var txtNUQ_Email = document.getElementById('<%=txtNUQ_Email.ClientID%>');
            if (Common_CheckEmpty(txtNUQ_Email.value)) {
                if (!Common_ValidateEmail(txtNUQ_Email.value)) {
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
            var allowedFiles = [".doc", ".docx", ".pdf", ".jpg", ".jpeg", ".png"];
            var fileUpload = document.getElementById('<%= fileupload.ClientID %>');
            //if (!Common_CheckEmpty(fileUpload.value)) {
            //    alert('Bạn chưa cung cấp giấy ủy quyền dưới dạng file mềm. Hãy kiểm tra lại!');
            //    fileUpload.focus();
            //    return false;
            //}
            var regex = new RegExp("([a-zA-Z0-9\s_\\.\-:])+(" + allowedFiles.join('|') + ")$");
            if (!regex.test(fileUpload.value.toLowerCase())) {
                alert('Giấy ủy quyền chỉ cho phép chọn một trong các định dạng file: .doc, .docx, .pdf, .jpg, .jpeg, .png. Bạn hãy kiểm tra lại!');
                return false;
            }
            //lblError.innerHTML = "";
            return true;
        }

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
</asp:Content>





