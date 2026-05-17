<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Thongtindon.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.Hoso.Thongtindon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/APS/Hoso/Popup/pDuongSuKhac.ascx" TagPrefix="uc1" TagName="DsPSDuongSu" %>
<%@ Register Src="~/QLAN/DONGHEP/DonGhep.ascx" TagPrefix="uc2" TagName="DONGHEP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .msg_error {
            width: 50% !important;
        }

        .displayNone {
            display: none;
        }
    </style>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdUpdateSelect" runat="server" CssClass="buttoninput" Text="Lưu & Chọn xử lý" OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNew" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin vụ việc</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr style="display: none;">
                                <td style="width: 145px;">Mã vụ việc</td>
                                <td style="width: 222px;">
                                    <asp:TextBox ID="txtMaVuViec" CssClass="user"
                                        placeholder="Mã vụ việc tự sinh" ReadOnly="true"
                                        runat="server" Width="98%" MaxLength="50" Enabled="false"></asp:TextBox></td>
                                <td style="width: 145px;">Tên vụ việc</td>
                                <td>
                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" placeholder="Tên vụ việc tự sinh"
                                        ReadOnly="true" runat="server" Width="98%" TextMode="MultiLine" Rows="2" Height="40px" Enabled="false"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Hình thức nhận đơn</td>
                                <td>
                                    <asp:DropDownList ID="ddlHinhthucnhandon" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Qua bưu điện"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Trực tuyến"></asp:ListItem>
                                    </asp:DropDownList></td>
                                <td>Loại đơn</td>
                                <td>
                                    <asp:DropDownList ID="ddlLoaidon" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Đơn khởi kiện"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Đơn từ Tòa án khác chuyển đến"></asp:ListItem>
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td style="width: 145px;">Ngày ghi trên đơn <span class="batbuoc">(*)</span></td>
                                <td style="width: 260px;">
                                    <asp:TextBox ID="txtNgayViet" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayViet" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayViet" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayViet" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <td style="width: 145px;">Ngày nhận đơn hoặc ngày ghi trên dấu bưu điện <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayNhan" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>Loại quan hệ</td>
                                <td>
                                    <asp:DropDownList ID="ddlLoaiQuanhe" CssClass="chosen-select"
                                        runat="server" Width="200px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiQuanhe_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Yêu cầu"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Quan hệ pháp luật</td>
                                <td>
                                    <asp:DropDownList ID="ddlQuanhephapluat" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                            </tr>

                            <tr>
                                <td>Cán bộ nhận đơn<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlCanbonhandon" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList>
                                </td>
                                <td>Thẩm phán ký nhận đơn</td>
                                <td>
                                    <asp:DropDownList ID="ddlThamphankynhandon" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                            </tr>
                            <tr style="display: none;">
                                <td>Yếu tố nước ngoài<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlYeutonuocngoai" Enabled="false" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Không"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Đơn yêu cầu của người khác</td>
                                <td>
                                    <asp:TextBox ID="txtDonkiencuanguoikhac" CssClass="user" runat="server" Width="98%"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Nội dung đơn</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungkhoikien" CssClass="user" runat="server" Width="663px" TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Literal ID="lstTitleNguyendon" runat="server"
                            Text="Thông tin người yêu cầu (đại diện)"></asp:Literal>
                    </h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 145px;">Đối tượng yêu cầu<span class="batbuoc">(*)</span></td>
                                <td style="width: 260px;">
                                    <asp:DropDownList ID="ddlLoaiNguyendon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiNguyendon_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 100px;">Người yêu cầu<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtTennguyendon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                                <td style="width: 70px;">Quốc tịch<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlND_Quoctich" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlND_Quoctich_SelectedIndexChanged"></asp:DropDownList></td>
                            </tr>
                            <asp:Panel ID="pnNDTochuc" runat="server" Visible="false">
                                <tr>
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNDD_Tinh_NguyenDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlNDD_Tinh_NguyenDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlNDD_Huyen_NguyenDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtND_NDD_Diachichitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người đại diện</td>
                                    <td>

                                        <asp:TextBox ID="txtND_NDD_Ten" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                    <td>Chức vụ</td>
                                    <td>
                                        <asp:TextBox ID="txtND_NDD_Chucvu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                </tr>
                            </asp:Panel>
                            <%--<tr>
                                <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<asp:Literal ID="ltCMNDND" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtND_CMND" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td style="width: 70px;">Quốc tịch<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlND_Quoctich" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlND_Quoctich_SelectedIndexChanged"></asp:DropDownList></td>
                            </tr>--%>
                            <tr>
                                <td>Thẻ căn cước <asp:Literal ID="ltCCCDND" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtND_CCCD" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                                <td>Hộ chiếu <asp:Literal ID="ltHCND" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtND_HoChieu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Số CMND <asp:Literal ID="ltCMNDND" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtND_CMND" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:CheckBox ID="chkBoxCMNDND" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMNDND_CheckedChanged" />
                                </td>
                            </tr>
                            <asp:Panel ID="pnNDCanhan" runat="server">
                                <tr>
                                    <td>Giới tính</td>
                                    <td>
                                        <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select" runat="server" Width="250px">
                                             <asp:ListItem Value="0" Text="Chọn" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Nữ"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>Ngày sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user" Width="90px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        Năm sinh<span class="batbuoc">(*)</span>
                                        <asp:TextBox ID="txtND_Namsinh" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="70px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:CheckBox ID="chkND_ONuocNgoai" AutoPostBack="true" runat="server" Text="Có yếu tố nước ngoài" OnCheckedChanged="chkND_ONuocNgoai_CheckedChanged" />
                                    </td>
                                </tr>
                                <%-- <tr>
                                    <td>Thường trú<asp:Label ID="lblND_Batbuoc1" runat="server" ForeColor="Red" Text="(*)"></asp:Label></td>
                                    <td >
                                        <asp:DropDownList ID="ddlThuongTru_Tinh_NguyenDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlThuongTru_Tinh_NguyenDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlThuongTru_Huyen_NguyenDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtND_HKTT_Chitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>--%>
                                <tr>
                                    <td>Nơi cư trú<asp:Label ID="lblND_Batbuoc2" runat="server" ForeColor="Red" Text="(*)"></asp:Label></td>
                                    <td>
                                        <asp:DropDownList ID="ddlTamTru_Tinh_NguyenDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlTamTru_Tinh_NguyenDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlTamTru_Huyen_NguyenDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Nơi làm việc</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtND_NoiLamViec" CssClass="user" runat="server" Width="590px" MaxLength="500"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Email</td>
                                <td>
                                    <asp:TextBox ID="txtND_Email" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Điện thoại</td>
                                <td>
                                    <asp:TextBox ID="txtND_Dienthoai" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                    Fax
                                    <asp:TextBox ID="txtND_Fax" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Literal ID="lstTitleBidon" runat="server"
                            Text="Thông tin doanh nghiệp, HTX bị tuyên bố phá sản"></asp:Literal></h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 145px;">Loại hình doanh nghiệp<span class="batbuoc">(*)</span></td>
                                <td style="width: 260px;">
                                    <asp:DropDownList ID="ddlLoaiBidon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiBidon_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td style="width: 100px;">
                                    <asp:Label ID="lstNganhKT" runat="server" Text="Ngành kinh tế"></asp:Label></td>
                                <td>
                                    <asp:DropDownList ID="ddlNganhKT" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tên đối tượng bị yêu cầu<span class="batbuoc">(*)</span>
                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtBD_Ten" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                                <td>Quốc tịch<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlBD_Quoctich" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlBD_Quoctich_SelectedIndexChanged"></asp:DropDownList></td>
                            </tr>
                            <asp:Panel ID="pnBD_Tochuc" runat="server" Visible="true">
                                <tr>
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNDD_Tinh_BiDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlNDD_Tinh_BiDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlNDD_Huyen_BiDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_NDD_Diachichitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người đại diện</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_NDD_ten" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                    <td>Chức vụ</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_NDD_Chucvu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                </tr>
                            </asp:Panel>
                            <%--<tr>
                                <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<asp:Literal ID="ltCMNDBD" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtBD_CMND" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Quốc tịch<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlBD_Quoctich" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlBD_Quoctich_SelectedIndexChanged"></asp:DropDownList></td>
                            </tr>--%>
                            <tr>
                                <td>Thẻ căn cước <asp:Literal ID="ltCCCDBD" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtBD_CCCD" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                                <td>Hộ chiếu <asp:Literal ID="ltHCDBD" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtBD_HoChieu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Số CMND <asp:Literal ID="ltCMNDBD" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtBD_CMND" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:CheckBox ID="chkBoxCMNDBD" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMNDBD_CheckedChanged" />
                                </td>
                            </tr>
                            <asp:Panel ID="pnBD_Canhan" runat="server" Visible="false">
                                <tr>
                                    <td>Giới tính</td>
                                    <td>
                                        <asp:DropDownList ID="ddlBD_Gioitinh" CssClass="chosen-select" runat="server" Width="250px">
                                             <asp:ListItem Value="0" Text="Chọn" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Nữ"></asp:ListItem>
                                        </asp:DropDownList>
                                    <td>Ngày sinh</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_Ngaysinh" runat="server" CssClass="user" Width="90px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtBD_Ngaysinh_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtBD_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtBD_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        Năm sinh
                                        <asp:TextBox ID="txtBD_Namsinh" CssClass="user" runat="server" onkeypress="return isNumber(event)" Width="60px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:CheckBox ID="chkBD_ONuocNgoai" AutoPostBack="true" runat="server" Text="Có yếu tố nước ngoài" OnCheckedChanged="chkBD_ONuocNgoai_CheckedChanged" />
                                    </td>
                                </tr>
                                <%--   <tr>
                                    <td>Thường trú<asp:Label ID="lblBD_Batbuoc1" runat="server" ForeColor="Red" Text="(*)"></asp:Label></td>
                                    <td >
                                        <asp:DropDownList ID="ddlThuongTru_Tinh_BiDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlThuongTru_Tinh_BiDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlThuongTru_Huyen_BiDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_HKTT_Chitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>--%>
                                <tr>
                                    <td>Nơi cư trú</td>
                                    <td>
                                        <asp:DropDownList ID="ddlTamTru_Tinh_BiDon" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlTamTru_Tinh_BiDon_SelectedIndexChanged"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlTamTru_Huyen_BiDon" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                    </td>
                                    <td>Chi tiết</td>
                                    <td>
                                        <asp:TextBox ID="txtBD_Tamtru_Chitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Nơi làm việc</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtBD_NoiLamViec" CssClass="user" runat="server" Width="590px" MaxLength="500"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Email</td>
                                <td>
                                    <asp:TextBox ID="txtBD_Email" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Điện thoại</td>
                                <td>
                                    <asp:TextBox ID="txtBD_Dienthoai" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                    Fax
                                    <asp:TextBox ID="txtBD_Fax" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div style="margin: 5px; width: 99%;">
                    <uc1:DsPSDuongSu runat="server" ID="DsPSDuongSu1" />
                </div>
                <div style="margin: 5px; width: 99%;">
                    <uc2:DONGHEP runat="server" ID="DONGHEP" />
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdateB" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdUpdateSelectB" runat="server" CssClass="buttoninput" Text="Lưu & Chọn xử lý"
                        OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNewB" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới"
                        OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput" Text="Quay lại"
                        OnClick="cmdQuaylai_Click" />
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
