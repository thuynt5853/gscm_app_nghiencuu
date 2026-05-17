hdTinhId

    <%--/* - GTEL-Phạm Đức
       - Mở popup thông tin bị can khi lấy dữ liệu từ API 037 tương tự logic của án Hôn Nhân
       - 17-09-2025 10h:00  */--%>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pGetBiCao037.aspx.cs" Inherits="WEB.GSTP.QLAN.AHN.Hoso.Popup.pGetBiCao037" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin Công dân từ Hệ thống Cơ sở dữ liệu quốc gia về dân cư</title>
    
    <style>
        .checkbox-large input[type="checkbox"] {
            transform: scale(1.0);
            margin-right: 10px;
        }

        .form-group {
            margin-bottom: 12px;
            display: flex;
            align-items: center;
        }

        .form-group label {
            min-width: 180px;
            font-weight: bold;
        }

        .group-title {
            margin-top: 25px;
            font-size: 20px;
            font-weight: bold;
            color: #2c3e50;
        }

        .btn-container {
                text-align: center;
                margin-top: 30px;
        }

        .btn {
            padding: 5px 10px;
            font-size: 20px;
            margin: 0 5px;
            border-radius: 6px;
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #0056b3;
        }
         h1 {
              text-align: center;   /* căn giữa ngang */
              font-weight: bold;    /* in đậm */
              font-size: 28px;      /* chữ to hơn */
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%; margin: auto; padding: 20px;">

            <asp:HiddenField ID="hdGioiTinhId" runat="server" />
            <asp:HiddenField ID="hdTinhId" runat="server" />
            <asp:HiddenField ID="hdXaId" runat="server" />
            <asp:HiddenField ID="hdQueQuanTinhId" runat="server" />
            <asp:HiddenField ID="hdQueQuanXaId" runat="server" />
            <h1><strong>Thông tin Công dân từ Hệ thống Cơ sở dữ liệu quốc gia về dân cư</strong></h1>
            <!-- 1. Thông tin cá nhân -->
            <div class="group-title">1. Thông tin cá nhân</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkHoTen" runat="server" Enabled ="false" Checked="true" /><label>Họ và tên:</label><asp:Label ID="lblHoTen" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkCCCD" runat="server"  Enabled ="false" Checked="true" /><label>Số CCCD:</label><asp:Label ID="lblCCCD" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkCMND" runat="server" Enabled ="false" Checked="true" /><label>Số CMND:</label><asp:Label ID="lblCMND" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkGioiTinh" runat="server"  Enabled ="false" Checked="true"/><label>Giới tính:</label><asp:Label ID="lblGioiTinh" runat="server" Text=""/></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkNgaySinh" runat="server" Enabled ="false" Checked="true" /><label>Ngày sinh:</label><asp:Label ID="lblNgaySinh" runat="server" Text="" /></div>
            
            <!-- 2. Địa chỉ -->
            <div class="group-title">2. Nơi ở hiện tại</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiTinh" runat="server" /><label>Tỉnh:</label><asp:Label ID="lblTinh" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiXa" runat="server" /><label>Xã:</label><asp:Label ID="lblHuyen" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiChiTiet" runat="server" /><label>Địa chỉ chi tiết:</label><asp:Label ID="lblDiaChiChiTiet" runat="server" Text="" /></div>
            
            <div class="group-title">3. Nơi đăng ký khai sinh</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkQueQuanTinh" runat="server"  /><label>Tỉnh:</label><asp:Label ID="lblQueQuanTinh" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkQueQuanXa" runat="server" /><label>Xã:</label><asp:Label ID="lblQueQuanXa" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkQueQuanChiTiet" runat="server" /><label>Địa chỉ chi tiết:</label><asp:Label ID="lblQueQuanChiTiet" runat="server" Text="" /></div>
            
            <div class="group-title">4. Thường trú</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkTTTinh" runat="server" Enabled ="false" /><label>Tỉnh:</label><asp:Label ID="lblThuongTruTinh" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkTTXã" runat="server" Enabled ="false" /><label>Xã:</label><asp:Label ID="lblThuongTruXa" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkTTChiTiet" runat="server" Enabled ="false" /><label>Địa chỉ chi tiết:</label><asp:Label ID="lblThuongTruChiTiet" runat="server" Text="" /></div>
            <div class="group-title">3. Thông tin cha</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkHoTenCha" runat="server" /><label>Họ tên cha:</label><asp:Label ID="lblHoTenCha" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkNamSinhCha" runat="server" /><label>Năm sinh cha:</label><asp:Label ID="lblNamSinhCha" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiCha" runat="server" /><label>Địa chỉ cha:</label><asp:Label ID="lblDiaChiCha" runat="server" Text="" /></div>

            <!-- 3. Thông tin mẹ -->
            <div class="group-title">4. Thông tin mẹ</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkHoTenMe" runat="server" /><label>Họ tên mẹ:</label><asp:Label ID="lblHoTenMe" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkNamSinhMe" runat="server" /><label>Năm sinh mẹ:</label><asp:Label ID="lblNamSinhMe" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiMe" runat="server" /><label>Địa chỉ mẹ:</label><asp:Label ID="lblDiaChiMe" runat="server" Text="" /></div>

            <!-- 4. Thông tin vợ/chồng -->
            <div class="group-title">5. Thông tin vợ/chồng</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkHoTenVoChong" runat="server" /><label>Họ tên vợ/chồng:</label><asp:Label ID="lblHoTenVoChong" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkNamSinhVoChong" runat="server" /><label>Năm sinh vợ/chồng:</label><asp:Label ID="lblNamSinhVoChong" runat="server" Text="" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiVoChong" runat="server" /><label>Địa chỉ vợ/chồng:</label><asp:Label ID="lblDiaChiVoChong" runat="server" Text="" /></div>

            <%--<!-- 3. Thông tin cha -->
            <div class="group-title">3. Thông tin cha</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkHoTenCha" runat="server" /><label>Họ tên cha:</label><asp:Label ID="lblHoTenCha" runat="server" Text="Nguyễn Văn B" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkNamSinhCha" runat="server" /><label>Năm sinh cha:</label><asp:Label ID="lblNamSinhCha" runat="server" Text="1960" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiCha" runat="server" /><label>Địa chỉ cha:</label><asp:Label ID="lblDiaChiCha" runat="server" Text="Số 1 Trần Hưng Đạo, Hà Nội" /></div>

            <!-- 3. Thông tin mẹ -->
            <div class="group-title">4. Thông tin mẹ</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkHoTenMe" runat="server" /><label>Họ tên mẹ:</label><asp:Label ID="lblHoTenMe" runat="server" Text="Trần Thị C" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkNamSinhMe" runat="server" /><label>Năm sinh mẹ:</label><asp:Label ID="lblNamSinhMe" runat="server" Text="1965" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiMe" runat="server" /><label>Địa chỉ mẹ:</label><asp:Label ID="lblDiaChiMe" runat="server" Text="Số 2 Trần Hưng Đạo, Hà Nội" /></div>

            <!-- 4. Thông tin vợ/chồng -->
            <div class="group-title">5. Thông tin vợ/chồng</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkHoTenVo" runat="server" /><label>Họ tên vợ/chồng:</label><asp:Label ID="lblHoTenVo" runat="server" Text="Lê Thị D" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkNamSinhVo" runat="server" /><label>Năm sinh vợ/chồng:</label><asp:Label ID="lblNamSinhVo" runat="server" Text="1991" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiVo" runat="server" /><label>Địa chỉ vợ/chồng:</label><asp:Label ID="lblDiaChiVo" runat="server" Text="Số 3 Trần Hưng Đạo, Hà Nội" /></div>

            
            <!-- 6. Người đại diện -->
            <div class="group-title">6. Người đại diện</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkTenNguoiDaiDien" runat="server" /><label>Họ tên người đại diện:</label><asp:Label ID="lblTenNguoiDaiDien" runat="server" Text="Phạm Văn E" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkQuanHeNguoiDaiDien" runat="server" /><label>Quan hệ:</label><asp:Label ID="lblQuanHeNguoiDaiDien" runat="server" Text="Chú" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiNguoiDaiDien" runat="server" /><label>Địa chỉ:</label><asp:Label ID="lblDiaChiNguoiDaiDien" runat="server" Text="Số 5 Hàng Bài, Hà Nội" /></div>

            <!-- 7. Chủ hộ -->
            <div class="group-title">7. Chủ hộ</div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkTenChuHo" runat="server" /><label>Họ tên chủ hộ:</label><asp:Label ID="lblTenChuHo" runat="server" Text="Nguyễn Văn F" /></div>
            <div class="form-group checkbox-large"><asp:CheckBox ID="chkDiaChiChuHo" runat="server" /><label>Địa chỉ chủ hộ:</label><asp:Label ID="lblDiaChiChuHo" runat="server" Text="Số 6 Hai Bà Trưng, Hà Nội" /></div>
            --%>
            <!-- Nút xử lý -->
            <div class="btn-container">
                <asp:Button ID="btnLayThongTin" runat="server" Text="Lấy thông tin" CssClass="btn btn-primary" OnClick="btnLayThongTin_Click"  />
                <asp:Button ID="btnHuy" runat="server" Text="Đóng" CssClass="btn btn-danger" OnClientClick="window.close(); return false;"/>
            </div>
        </div>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script type="text/html">
    function layThongTin(){

    }
</script>
</html>
