<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChiTietKK.aspx.cs" Inherits="WEB.GSTP.QLAN.DONCHOXULY.Popup.ChiTietKK" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin chi tiết</title>
    
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                    <style type="text/css">
                        body {
                            width: 98%;
                            margin-left: 1%;
                            min-width: 0px;
                            overflow: auto;
                        }
                        .check_list_vertical table td {
                            padding-right: 15px;
                        }
                        .boxchung {
                            height: auto;
                            overflow: auto;
                        }
                    </style>

                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin bì thư</h4>
                        <div class="boder" style="padding: 10px; margin-right: 10px">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Nguồn đến:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguonDen" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">Đơn vị nhận:</td>
                                    <td>
                                        <asp:TextBox ID="txtDonViNhan" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Loại văn bản:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaiVanBan" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                    <td>Đơn vị giải quyết:</td>
                                    <td>
                                        <asp:TextBox ID="txtDonViGiaiQuyet" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số đến:</td>
                                    <td>
                                        <asp:TextBox ID="txtSoDen" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Người nhận:</td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiNhan" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ngày đến/ Ngày nhận trực tiếp:</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayDen" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Ngày giao:</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayGiao" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người gửi/ Đơn vị gửi:</td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiGui" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Địa chỉ gửi:</td>
                                    <td>
                                        <asp:TextBox ID="txtDiaChiGui" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Chi tiết:</td>
                                    <td>
                                        <asp:TextBox ID="txtDiaChiGuiChiTiet" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ghi chú:</td>
                                    <td>
                                        <asp:TextBox ID="txtGhiChu" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="3" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin người khởi kiện</h4>
                        <div class="boder" style="padding: 10px; margin-right: 10px">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Người khởi kiện là:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguoiKhoiKien" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">
                                        <asp:Label ID="lblHoTenNKK" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtHoTenNguoiKhoiKien" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>

                                <asp:Panel ID="pnNDToChuc" runat="server" Visible="false">
                                    <tr>
                                        <td>Mã số thuế:</td>
                                        <td>
                                            <asp:TextBox ID="txtMaSoThueNKK" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td>Tỉnh:</td>
                                        <td>
                                            <asp:TextBox ID="txtND_NDD_Tinh" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Huyện:</td>
                                        <td>
                                            <asp:TextBox ID="txtND_NDD_Huyen" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Địa chỉ chi tiết:</td>
                                        <td>
                                            <asp:TextBox ID="txtND_NDD_DCChiTiet" CssClass="user"
                                                runat="server" TextMode="multiline" Rows="2" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td>Người đại diện là:</td>
                                        <td>
                                            <asp:TextBox ID="txtND_NDD_NguoiDaiDien" CssClass="user" runat="server"
                                                Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Chức vụ:</td>
                                        <td>
                                            <asp:TextBox ID="txtND_NDD_ChucVu" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>

                                <tr>
                                    <td>Số CMND/ CCCD:</td>
                                    <td>
                                        <asp:TextBox ID="txtSoChungMinhNguoiKhoiKien" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td colspan="2"></td>
                                </tr>

                                <asp:Panel runat="server" ID="pnNDCaNhan" Visible="false">
                                    <tr>
                                        <td>Năm sinh:</td>
                                        <td>
                                            <asp:TextBox ID="txtNamSinhNguoiKhoiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Giới tính:</td>
                                        <td>
                                            <asp:TextBox ID="txtGioiTinhNguoiKhoiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nơi cư trú (Tỉnh/TP):</td>
                                        <td>
                                            <asp:TextBox ID="txtNoiCuTruNguoiKhoiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Quận/Huyện:</td>
                                        <td>
                                            <asp:TextBox ID="txtQuanHuyenNguoiKhoiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Địa chỉ chi tiết:</td>
                                        <td>
                                            <asp:TextBox ID="txtDiaChiChiTietNguoiKhoiKien" runat="server" CssClass="user"
                                                Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                
                                <tr>
                                    <td>Email:</td>
                                    <td>
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Điện thoại:</td>
                                    <td>
                                        <asp:TextBox ID="txtDienThoai" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nội dung khởi kiện:</td>
                                    <td>
                                        <asp:TextBox ID="txtNoiDungKhoiKien" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="3" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Loại án:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaiAn" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                    <td>Số lượng đơn:</td>
                                    <td>
                                        <asp:TextBox ID="txtSoLuongDon" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin người bị kiện</h4>
                        <div class="boder" style="padding: 10px; margin-right: 10px">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Người bị kiện là:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguoiBiKien" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">
                                        <asp:Label ID="lblHoTenNBK" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtHoTenNguoiBiKien" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>

                                <asp:Panel ID="pnBDToChuc" runat="server" Visible="false">
                                    <tr>
                                        <td>Mã số thuế:</td>
                                        <td>
                                            <asp:TextBox ID="txtMaSoThueNBK" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td>Tỉnh:</td>
                                        <td>
                                            <asp:TextBox ID="txtBD_NDD_Tinh" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Huyện:</td>
                                        <td>
                                            <asp:TextBox ID="txtBD_NDD_Huyen" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Địa chỉ chi tiết:</td>
                                        <td>
                                            <asp:TextBox ID="txtBD_NDD_DCChiTiet" CssClass="user"
                                                runat="server" TextMode="multiline" Rows="2" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td>Người đại diện là:</td>
                                        <td>
                                            <asp:TextBox ID="txtBD_NDD_NguoiDaiDien" CssClass="user" runat="server"
                                                Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Chức vụ:</td>
                                        <td>
                                            <asp:TextBox ID="txtBD_NDD_ChucVu" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>

                                <tr>
                                    <td>Số CMND/ CCCD:</td>
                                    <td>
                                        <asp:TextBox ID="txtSoChungMinhNguoiBiKien" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td colspan="2"></td>
                                </tr>
                                
                                <asp:Panel runat="server" ID="pnBDCaNhan" Visible="false">
                                    <tr>
                                        <td>Năm sinh:</td>
                                        <td>
                                            <asp:TextBox ID="txtNamSinhNguoiBiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Giới tính:</td>
                                        <td>
                                            <asp:TextBox ID="txtGioiTinhNguoiBiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nơi cư trú (Tỉnh/TP):</td>
                                        <td>
                                            <asp:TextBox ID="txtNoiCuTruNguoiBiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Quận/Huyện:</td>
                                        <td>
                                            <asp:TextBox ID="txtQuanHuyenNguoiBiKien" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Địa chỉ chi tiết:</td>
                                        <td>
                                            <asp:TextBox ID="txtDiaChiChiTietNguoiBiKien" runat="server" CssClass="user"
                                                Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>

                            </table>
                        </div>
                    </div>

                    <div style="padding:10px 0 25px 0; text-align: center">
                        <input type="button" class="buttoninput" onclick="ReloadParent();" value="Đóng" />
                    </div>

                </div>
                <script>
                    function ReloadParent() {
                        window.close();
                    }
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>

