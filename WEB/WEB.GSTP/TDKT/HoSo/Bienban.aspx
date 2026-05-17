<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Bienban.aspx.cs" Inherits="WEB.GSTP.TDKT.HoSo.Bienban" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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

        .HoSo_BienBan_Col1 {
            width: 117px;
        }

        .HoSo_BienBan_Col2 {
            width: 320px;
        }

        .HoSo_BienBan_Col3 {
            width: 80px;
        }

        .HoSo_BienBan_Load_Left {
            float: left;
        }

        .truong {
            min-height: 375px !important;
        }

        .table2 .header {
            text-align: center;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="HddPageSize" Value="20" runat="server" />
    <asp:HiddenField ID="HdfVuTDKT" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td><b>Loại hình</b></td>
                        <td colspan="3">
                            <asp:DropDownList ID="DropLoaiHinh" Width="305px" runat="server" CssClass="chosen-select"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td><b>Thời gian bắt đầu</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtBatDau_Gio" Width="35px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="2" onkeypress="return isNumber(event)"></asp:TextBox>
                            <span style="font-weight: bold; width: 30px; float: left; margin-left: 5px; margin-top: 6px;">Giờ</span>
                            <asp:TextBox runat="server" ID="TxtBatDau_Phut" Width="35px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="2" onkeypress="return isNumber(event)"></asp:TextBox>
                            <span style="font-weight: bold; float: left; margin-left: 5px; margin-top: 6px; width: 70px;">Phút, Ngày</span>
                            <asp:TextBox ID="TxtNgayBatDau" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TxtNgayBatDau" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="TxtNgayBatDau" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td><b>Số thành viên tham dự</b></td>
                        <td>
                            <asp:DropDownList ID="DropSoThanhVien" Width="208px" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropSoThanhVien_SelectedIndexChanged"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Địa điểm</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="TxtDiaDiem" runat="server" CssClass="user" Width="614px" MaxLength="500"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Chủ trì cuộc họp</b></td>
                        <td>
                            <asp:TextBox ID="TxtChuTri" runat="server" CssClass="user" Width="296px" MaxLength="250"></asp:TextBox></td>
                        <td><b>Chức vụ</b></td>
                        <td>
                            <asp:TextBox ID="TxtChuTri_CV" runat="server" CssClass="user" Width="200px" MaxLength="250" Enabled="false" Text="Chủ tịch Hội đồng TĐKT"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="HoSo_BienBan_Col1"><b>Thư ký cuộc họp</b></td>
                        <td class="HoSo_BienBan_Col2">
                            <asp:TextBox ID="TxtThuKy" runat="server" CssClass="user" Width="296px" MaxLength="250"></asp:TextBox></td>
                        <td class="HoSo_BienBan_Col3"><b>Chức vụ</b></td>
                        <td colspan="2">
                            <asp:TextBox ID="TxtThuKy_CV" runat="server" CssClass="user" Width="200px" MaxLength="250"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Thành viên vắng</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="TxtThanh_Vien_Vang_Mat" runat="server" CssClass="user" TextMode="MultiLine" Rows="2" Width="611px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Thành viên tham dự</b></td>
                        <td colspan="3">
                            <table class="table2" style="width: 620px;">
                                <tr class="header">
                                    <td style="width: 42px;">Thứ tự</td>
                                    <td>Họ tên</td>
                                    <td style="width: 200px;">Chức vụ</td>
                                </tr>
                                <tr id="row_1" runat="server">
                                    <td style="text-align: center;">1</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_1" runat="server" Value="1" />
                                        <asp:TextBox ID="txtHoTen_1" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_1" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_2" runat="server">
                                    <td style="text-align: center;">2</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_2" runat="server" Value="2" />
                                        <asp:TextBox ID="txtHoTen_2" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_2" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_3" runat="server">
                                    <td style="text-align: center;">3</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_3" runat="server" Value="3" />
                                        <asp:TextBox ID="txtHoTen_3" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_3" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_4" runat="server">
                                    <td style="text-align: center;">4</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_4" runat="server" Value="4" />
                                        <asp:TextBox ID="txtHoTen_4" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_4" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_5" runat="server">
                                    <td style="text-align: center;">5</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_5" runat="server" Value="5" />
                                        <asp:TextBox ID="txtHoTen_5" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_5" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_6" runat="server">
                                    <td style="text-align: center;">6</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_6" runat="server" Value="6" />
                                        <asp:TextBox ID="txtHoTen_6" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_6" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_7" runat="server">
                                    <td style="text-align: center;">7</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_7" runat="server" Value="7" />
                                        <asp:TextBox ID="txtHoTen_7" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_7" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_8" runat="server">
                                    <td style="text-align: center;">8</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_8" runat="server" Value="8" />
                                        <asp:TextBox ID="txtHoTen_8" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_8" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_9" runat="server">
                                    <td style="text-align: center;">9</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_9" runat="server" Value="9" />
                                        <asp:TextBox ID="txtHoTen_9" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_9" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_10" runat="server">
                                    <td style="text-align: center;">10</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_10" runat="server" Value="10" />
                                        <asp:TextBox ID="txtHoTen_10" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_10" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_11" runat="server">
                                    <td style="text-align: center;">11</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_11" runat="server" Value="11" />
                                        <asp:TextBox ID="txtHoTen_11" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_11" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_12" runat="server">
                                    <td style="text-align: center;">12</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_12" runat="server" Value="12" />
                                        <asp:TextBox ID="txtHoTen_12" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_12" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_13" runat="server">
                                    <td style="text-align: center;">13</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_13" runat="server" Value="13" />
                                        <asp:TextBox ID="txtHoTen_13" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_13" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_14" runat="server">
                                    <td style="text-align: center;">14</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_14" runat="server" Value="14" />
                                        <asp:TextBox ID="txtHoTen_14" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_14" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_15" runat="server">
                                    <td style="text-align: center;">15</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_15" runat="server" Value="15" />
                                        <asp:TextBox ID="txtHoTen_15" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_15" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_16" runat="server">
                                    <td style="text-align: center;">16</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_16" runat="server" Value="16" />
                                        <asp:TextBox ID="txtHoTen_16" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_16" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_17" runat="server">
                                    <td style="text-align: center;">17</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_17" runat="server" Value="17" />
                                        <asp:TextBox ID="txtHoTen_17" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_17" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_18" runat="server">
                                    <td style="text-align: center;">18</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_18" runat="server" Value="18" />
                                        <asp:TextBox ID="txtHoTen_18" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_18" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_19" runat="server">
                                    <td style="text-align: center;">19</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_19" runat="server" Value="19" />
                                        <asp:TextBox ID="txtHoTen_19" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_19" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="row_20" runat="server">
                                    <td style="text-align: center;">20</td>
                                    <td>
                                        <asp:HiddenField ID="HddThuTu_20" runat="server" Value="20" />
                                        <asp:TextBox ID="txtHoTen_20" runat="server" CssClass="user" Width="98%"></asp:TextBox></td>
                                    <td>
                                        <asp:DropDownList ID="DropChucVu_20" Width="98%" runat="server" CssClass="chosen-select">
                                            <asp:ListItem Text="Chủ tịch Hội đồng TĐKT" Value="Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Phó Chủ tịch Hội đồng TĐKT" Value="Phó Chủ tịch Hội đồng TĐKT"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên" Value="Ủy viên"></asp:ListItem>
                                            <asp:ListItem Text="Ủy viên, thư ký Hội đồng" Value="Ủy viên, thư ký Hội đồng"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Kiểu bình chọn</b></td>
                        <td>
                            <asp:DropDownList ID="DropKieuBinhChon" Width="121px" runat="server" CssClass="chosen-select">
                                <asp:ListItem Text="Biểu quyết" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Bỏ phiếu kín" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Thời gian kết thúc</b></td>
                        <td colspan="3">
                            <asp:TextBox runat="server" ID="TxtKetThuc_Gio" Width="35px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="2" onkeypress="return isNumber(event)"></asp:TextBox>
                            <span style="font-weight: bold; width: 30px; float: left; margin-left: 5px; margin-top: 6px;">Giờ</span>
                            <asp:TextBox runat="server" ID="TxtKetThuc_Phut" Width="35px" CssClass="HoSo_BienBan_Load_Left user align_right" MaxLength="2" onkeypress="return isNumber(event)"></asp:TextBox>
                            <span style="font-weight: bold; float: left; margin-left: 5px; margin-top: 6px; width: 70px;">Phút, Ngày</span>
                            <asp:TextBox ID="TxtNgayKetThuc" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="TxtNgayKetThuc" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="TxtNgayKetThuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="BtnLuu_Click" />
                            <asp:Button ID="BtnXoa" runat="server" CssClass="buttoninput" Visible="false" Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa biên bản này? ');" OnClick="BtnXoa_Click" />
                            <asp:Button ID="BtnQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="BtnQuayLai_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Label runat="server" ID="Lblthongbao" Style="color: red;"></asp:Label></td>
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
        function Validate() {
        }
    </script>
</asp:Content>
