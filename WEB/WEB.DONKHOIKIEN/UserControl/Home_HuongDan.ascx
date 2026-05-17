<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Home_HuongDan.ascx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.Home_HuongDan" %>
<asp:Panel ID="pn" runat="server">
    <div class="hotro_bottom">
        <div class="content_center">
           
            <div style="width: 98%; float: left; padding-left: 2%; margin-bottom: 25px;">
             <div class="hotro_item_top">CÁC BƯỚC THỰC HIỆN CỦA QUY TRÌNH ĐĂNG KÝ GỬI ĐƠN, NHẬN VĂN BẢN TRỰC TUYẾN</div>
                <div class="hotro_item" style="width:21%;">
                    <a onclick='dangky(1)'>
                        <div class="hotro_icon_dk"></div>
                        <div class="hotro_icon_top"><b>01</b></div>
                        <div class="hotro_icon_bottom">
                            <span class='buoc4' style="width: 150px;">Đăng ký
                                <div style="font-size: 11px;">(Bắt buộc có chữ ký số)</div>
                            </span>

                        </div>
                    </a>
                </div>
                <div class="hotro_item" style="width:19%;">
                    <a onclick='dangnhap()'>
                        <div class="hotro_icon_dn"></div>
                        <div class="hotro_icon_top"><b>02</b></div>
                        <div class="hotro_icon_bottom">
                            <span>Đăng nhập</span>
                        </div>
                    </a>
                </div>
                <div class="hotro_item" style="width:22%;">
                    <a onclick='nopdon()'>
                        <div class="hotro_icon_nd"></div>
                        <div class="hotro_icon_top"><b>03</b></div>
                        <div class="hotro_icon_bottom" style="float: left; width: 160px;">
                            <span class='buoc4' style="font-size:14px;">Gửi đơn, đăng ký nhận vb tống đạt</span>
                           
                        </div>
                    </a>
                </div>
                <div class="hotro_item_nkq" style="width:22%;">
                    <a onclick='nhanvb()'>
                        <div class="hotro_icon_nkq_top"></div>
                        <div class="hotro_icon_top" style="margin-left:70px;"><b>04</b></div>
                        <div class="hotro_icon_bottom" style="float: left; width: 170px;margin-left:70px;">
                            <span class='buoc4' style="font-size:14px;">Nhận vb, thông báo của Tòa án</span>
                           
                        </div>
                    </a>
                </div>
                <div class="hotro_item"  style="width:180px;">
                    <a onclick='javascript:;'>
                        <div class="hotro_icon_stop"></div>
                        <div class="hotro_icon_top2"><b>05</b></div>
                        <div class="hotro_icon_bottom" style="float: left; width: 110px;">
                          <span class='buoc4' style="font-size:14px;">Ngừng giao dịch điện tử</span>
                        </div>                        
                    </a>
                </div>
            </div>
            <!---------------Quy trinh ko chung thu so----------->
             <div style="width: 98%; float: left; padding-left: 2%; ">
                <div class="hotro_item_top">CÁC BƯỚC THỰC HIỆN CỦA Quy trình đăng ký nhận Văn bản trực tuyến</div>
                 <div class="hotro_item" style="width:210px;">
                    <a onclick='dangky(0)'>
                        <div class="hotro_icon_dk"></div>
                        <div class="hotro_icon_top"><b>01</b></div>
                        <div class="hotro_icon_bottom">
                            <span class='buoc4' style="width: 130px;">Đăng ký
                                <div style="font-size: 11px;">(không bắt buộc có chữ ký số)</div>
                            </span>

                        </div>
                    </a>
                </div>
                <div class="hotro_item" style="width:180px;">
                    <a onclick='dangnhap()'>
                        <div class="hotro_icon_dn"></div>
                        <div class="hotro_icon_top"><b>02</b></div>
                        <div class="hotro_icon_bottom">
                            <span>Đăng nhập</span>
                        </div>
                    </a>
                </div>

                 <div class="hotro_item" style="width:190px;">
                    <a onclick='dknhanvb()'>
                        <div class="hotro_icon_dkvb"></div>
                        <div class="hotro_icon_top"><b>03</b></div>
                        <div class="hotro_icon_bottom" style="float: left; width: 120px;">
                            <span class='buoc4' style="font-size:14px;">Đăng ký nhận vb tống đạt</span>
                           
                        </div>
                    </a>
                </div>

             <div class="hotro_item_nkq" style="width:220px;">
                    <a onclick='nhanvb()'>
                        <div class="hotro_icon_nkq_top"></div>
                        <div class="hotro_icon_top" style="margin-left:70px;"><b>04</b></div>
                        <div class="hotro_icon_bottom" style="float: left; width: 150px;margin-left:70px;">
                            <span class='buoc4' style="font-size:14px;">Nhận vb, thông báo của Tòa án</span>
                           
                        </div>
                    </a>
                </div>
               <div class="hotro_item" style="width:165px;">
                    <a onclick='dknhanvb()'>
                        <div class="hotro_icon_xetduyet"></div>
                        <div class="hotro_icon_top"><b>05</b></div>
                        <div class="hotro_icon_bottom" style="float: left; width: 95px;">
                            <span class='buoc4' style="font-size:14px;">Xác nhận<br />tại Tòa án</span>
                        </div>
                    </a>
                </div>
                <div class="hotro_item"  style="width:180px;">
                    <a onclick='javascript:;'>
                        <div class="hotro_icon_stop"></div>
                        <div class="hotro_icon_top2"><b>06</b></div>
                        <div class="hotro_icon_bottom" style="float: left; width: 110px;">
                          <span class='buoc4' style="font-size:14px;">Ngừng giao dịch điện tử</span>
                        </div>                        
                    </a>
                </div>
        </div>
    </div>
    </div>
    <script>
        function dangky(iskyso) {
            var user_id = '<%=UserID%>';
            if (user_id == 0) {
                if (iskyso == 1)
                    window.location.href = "/DangKyTK.aspx";
                else
                    window.location.href = "/DangKy.aspx?ks=0";
            }

        }
        function dangnhap() {
            var user_id = '<%=UserID%>';
            if (user_id == 0)
                window.location.href = "/login.aspx";
        }
        function nopdon() {
            var temp_msg = "";
            var user_id = '<%=UserID%>';
            var MucDichSD = '<%=MucDichSD%>';
            if (user_id > 0) {
                if (MucDichSD != 2)
                    window.location.href = "/Personnal/GuiDonKien.aspx";
                else {
                    temp_msg = "Bạn cần đăng nhập vào hệ thống bằng tài khoản ";
                    temp_msg += "sử dụng chữ ký số để có thể gửi đơn khởi kiện!";
                    alert(temp_msg);
                }
            }
            else {
                temp_msg = "Bạn cần đăng nhập vào hệ thống bằng tài khoản ";
                temp_msg += "sử dụng chữ ký số để có thể gửi đơn khởi kiện!";
                alert(temp_msg);
            }
        }
        function dknhanvb() {
            var temp_msg = "";
            var user_id = '<%=UserID%>';
            if (user_id > 0)
                window.location.href = "/Personnal/DangKyNhanVB.aspx";
            else {
                temp_msg = "Bạn cần đăng nhập vào hệ thống ";
                temp_msg += "để có thể đăng ký nhận văn bản, thông báo từ Tòa án!";
                alert(temp_msg);
            }
        }
        function nhanvb() {
            var temp_msg = "";
            var user_id = '<%=UserID%>';
            if (user_id > 0)
                window.location.href = "/Personnal/VBTongDat.aspx";
            else {
                temp_msg = "Bạn cần đăng nhập vào hệ thống ";
                temp_msg += "để nhận văn bản, thông báo từ Tòa án!";
                alert(temp_msg);
            }
        }

    </script>
</asp:Panel>
