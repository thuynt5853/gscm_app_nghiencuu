<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Thongtintonghop.aspx.cs" Inherits="WEB.GSTP.GSTP.Thongtintonghop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .TTChungCol1 {
            width: 34%;
            font-weight: bold;
            float: left;
            margin-top: 6px;
        }

        .TTChungCol2 {
            width: 20%;
            float: left;
            margin-top: 6px;
        }

        .TTChungCol3 {
            width: 11%;
            float: left;
            font-weight: bold;
            margin-top: 6px;
        }

        .TTChungCol4 {
            margin-top: 6px;
            float: left;
        }


        .HdxxCol2 {
            float: left;
            width: 15%;
            margin-top: 6px;
        }

        .HdxxCol3 {
            float: left;
            width: 11%;
            margin-top: 6px;
        }

        .HdxxCol4 {
            float: left;
            margin-top: 6px;
        }

        .row_Chan {
            float: left;
            height: 30px;
            width: 100%;
        }

        .row_Le {
            float: left;
            height: 30px;
            background-color: #f2f2f2;
            width: 100%;
        }

        .tleGroupTTCTP {
            background-color: #f0a400;
            color: #ffffff;
            height: 22px;
            text-transform: uppercase;
            width: 170px;
            text-align: center;
            border-radius: 10px;
            position: absolute;
            margin-left: 13px;
        }

        .tleGroupTTHDXXTP {
            background-color: #be1e1e;
            color: #ffffff;
            height: 22px;
            text-transform: uppercase;
            width: 372px;
            text-align: center;
            border-radius: 10px;
            position: absolute;
            margin-left: 13px;
        }

        .tleGroupTTKLTP {
            background-color: #1ca736;
            color: #ffffff;
            height: 22px;
            text-transform: uppercase;
            width: 170px;
            text-align: center;
            border-radius: 10px;
            position: absolute;
            margin-left: 13px;
        }

        .tleh4TTTP {
            margin-top: 4px;
        }

        .tbl_header_hdxx {
            background: #db212d;
            padding: 2px;
            font-weight: bold;
            height: 30px;
            color: #ffffff;
        }

        .box {
            padding-bottom: 0px !important;
        }

        .truong {
            margin-bottom: 0px !important;
            border: none !important;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <div class="tleGroupTTCTP">
                        <h4 class="tleh4TTTP">Thông tin chung</h4>
                    </div>
                    <div class="boder" style="padding: 10px; margin-top: 11px;">
                        <table class="table1" style="margin-top: 10px;">
                            <tr class="row_Le">
                                <td class="TTChungCol1">Họ tên:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="txtTen" runat="server" CssClass="user"></asp:Label></td>
                                <td class="TTChungCol3">Giới tính:</td>
                                <td class="TTChungCol4">
                                    <asp:Label ID="txtGioiTinh" runat="server" CssClass="user"></asp:Label></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">Chức danh:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="txtChucDanh" runat="server" CssClass="user"></asp:Label></td>
                                <td class="TTChungCol3">Ngày sinh:</td>
                                <td class="TTChungCol4">
                                    <asp:Label ID="txtNgaySinh" runat="server" CssClass="user"></asp:Label></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">Quyết định bổ nhiệm thẩm phán:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="txtQD" runat="server" CssClass="user"></asp:Label></td>
                                <td class="TTChungCol3">Đơn vị công tác:</td>
                                <td class="TTChungCol4">
                                    <asp:Label ID="txtDonVi" runat="server" CssClass="user"></asp:Label></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <div class="tleGroupTTHDXXTP">
                        <h4 class="tleh4TTTP">Hoạt động xét xử và công bố BA,QĐ của Thẩm phán</h4>
                    </div>
                    <div class="boder" style="padding: 10px; margin-top: 11px;">
                        <table class="table1" style="margin-top: 10px;">
                            <tr class="tbl_header_hdxx">
                                <td class="TTChungCol1">Nội dung</td>
                                <td class="TTChungCol2">Số lượng</td>
                                <td class="HdxxCol3">Định mức</td>
                                <td class="HdxxCol3">Tỷ lệ %</td>
                                <td class="TTChungCol4">Danh sách</td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">1. Tổng số vụ án được phân công giải quyết:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblPhanCong_GiaiQuyet_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblPhanCong_GiaiQuyet_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblPhanCong_GiaiQuyet_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                   <asp:LinkButton ID="LbtVuAnPhanCong" runat="server" OnClick="LbtVuAnPhanCong_Click">Danh sách</asp:LinkButton> </td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">2. Số vụ án là thành viên HĐXX:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lbl_HDXX_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lbl_HDXX_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lbl_HDXX_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="LbtVuAnThanhVienHDXX" runat="server" CssClass="user" OnClick="LbtVuAnThanhVienHDXX_Click">Danh sách</asp:LinkButton>
                                </td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">3. Tổng số vụ án đã giải quyết:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblDaGiaiQuyet_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblDaGiaiQuyet_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblDaGiaiQuyet_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnDaGiaiQuyet" runat="server" CssClass="user" OnClick="LbtVuAnDaGiaiQuyet_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">4. Tổng số vụ án có kháng cáo/kháng nghị:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblKCKN_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblKCKN_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblKCKN_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnKhangCaoKhangNghi" runat="server" CssClass="user" OnClick="LbtVuAnKhangCaoKhangNghi_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">5. Tổng số vụ án vi phạm thời hạn tạm giam:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblThoiHan_TamGiam_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblThoiHan_TamGiam_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblThoiHan_TamGiam_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnViPhamThoiHanTamGiam" runat="server" CssClass="user" OnClick="LbtVuAnViPhamThoiHanTamGiam_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">6. Tổng số vụ án bị hủy:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnHuy_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnHuy_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnHuy_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="lbtVuAnHuy" runat="server" CssClass="user" OnClick="lbtVuAnHuy_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">7. Số vụ án bị hủy do nguyên nhân chủ quan:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnHuy_ChuQuan_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnHuy_ChuQuan_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnHuy_ChuQuan_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnHuy_ChuQuan" runat="server" CssClass="user" OnClick="LbtVuAnHuy_ChuQuan_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">8. Tổng số vụ án bị sửa:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnSua_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnSua_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnSua_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="lbtVuAnSua" runat="server" CssClass="user" OnClick="lbtVuAnSua_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">9. Số vụ án bị sửa do nguyên nhân chủ quan:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnSua_ChuQuan_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnSua_ChuQuan_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnSua_ChuQuan_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnSua_ChuQuan" runat="server" CssClass="user" OnClick="LbtVuAnSua_ChuQuan_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">10. Số vụ án áp dụng án treo:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnTreo_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnTreo_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnTreo_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="lbtVuAnTreo" runat="server" CssClass="user" OnClick="lbtVuAnTreo_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">11. Số vụ án áp dụng các biện pháp khẩn cấp tạm thời:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnBPTT_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnBPTT_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnBPTT_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="lbtBienPhapTamThoi" runat="server" CssClass="user" OnClick="lbtBienPhapTamThoi_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">12. Số vụ án tạm đình chỉ:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnTDC_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnTDC_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnTDC_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="lbtAnTamDinhChi" runat="server" CssClass="user" OnClick="lbtAnTamDinhChi_Click1">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">13. Số vụ án bị đình chỉ:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnDC_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnDC_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnDC_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="lbtAnBiDinhChi" runat="server" CssClass="user" OnClick="lbtAnBiDinhChi_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">14. Số vụ án quá hạn:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAn_QuaHan_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAn_QuaHan_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAn_QuaHan_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4">
                                    <asp:LinkButton ID="lbtVuAnQuaHan" runat="server" CssClass="user" OnClick="lbtVuAnQuaHan_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">15. Tổng số vụ án tổ chức phiên tòa rút kinh nghiệm:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnRutKN_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnRutKN_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnRutKN_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnRutKinhNghiem" runat="server" CssClass="user" OnClick="LbtVuAnRutKinhNghiem_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">16. Tổng số vụ án hòa giải, đối thoại thành công:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnHoaGiai_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnHoaGiai_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnHoaGiai_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnHoaGiai_DoiThoai" runat="server" CssClass="user" OnClick="LbtVuAnHoaGiai_DoiThoai_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">17. Tổng số vụ án có áp dụng án lệ:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAnLe_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnLe_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAnLe_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnApDungAnLe" runat="server" CssClass="user" OnClick="LbtVuAnApDungAnLe_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">18. Tổng số hồ sơ vụ án VKS chưa trả:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblAn_VKS_ChuaTra_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAn_VKS_ChuaTra_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblAn_VKS_ChuaTra_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"><asp:LinkButton ID="LbtVuAnVKSChuaTraHoSo" runat="server" CssClass="user" OnClick="LbtVuAnVKSChuaTraHoSo_Click">Danh sách</asp:LinkButton></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">19. Tổng số BA/QĐ đã công bố:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblBAQD_DaCongBo_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_DaCongBo_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_DaCongBo_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">20. Tổng số BA/QĐ công bố chậm:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblBAQD_CongBoCham_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_CongBoCham_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_CongBoCham_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">21. Tổng số BA/QĐ có đính chính:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblBAQD_DinhChinh_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_DinhChinh_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_DinhChinh_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">22. Tổng số BA/QĐ đã gỡ xuống:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblBAQD_GoXuong_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_GoXuong_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_GoXuong_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"></td>
                            </tr>
                            <tr class="row_Le">
                                <td class="TTChungCol1">23. Tổng số BA/QĐ có ý kiến phản hồi:</td>
                                <td class="TTChungCol2">
                                    <asp:Label ID="lblBAQD_YKien_PhanHoi_SL" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_YKien_PhanHoi_DM" runat="server"></asp:Label></td>
                                <td class="HdxxCol3">
                                    <asp:Label ID="lblBAQD_YKien_PhanHoi_TyLe" runat="server"></asp:Label></td>
                                <td class="TTChungCol4"></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <div class="tleGroupTTKLTP">
                        <h4 class="tleh4TTTP">Khen thưởng, kỷ luật</h4>
                    </div>
                    <div class="boder" style="padding: 10px; margin-top: 11px;">
                        <table class="table1" style="margin-top: 10px;">
                            <tr class="row_Le">
                                <td class="TTChungCol1">Khen thưởng, kỷ luật:</td>
                                <td class="TTChungCol2">
                                    <asp:LinkButton ID="lbtKhenThuong" runat="server" CssClass="user" OnClick="lbtKhenThuong_Click"></asp:LinkButton></td>
                            </tr>
                            <tr class="row_Chan">
                                <td class="TTChungCol1">Khiếu nại, tố cáo:</td>
                                <td class="TTChungCol2">
                                    <asp:LinkButton ID="lbtKhieuNai" runat="server" CssClass="user" OnClick="lbtKhieuNai_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div style="width: 100%;">
                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>