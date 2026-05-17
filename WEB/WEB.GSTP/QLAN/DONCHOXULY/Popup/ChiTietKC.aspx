<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChiTietKC.aspx.cs" Inherits="WEB.GSTP.QLAN.DONCHOXULY.Popup.ChiTietKC" %>

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
                        <h4 class="tleboxchung">Thông tin Bản án/Quyết định</h4>
                        <div class="boder" style="padding: 10px; margin-right: 10px">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Loại án:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaiAn" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">Ngày BA/QD:</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số BA/QD:</td>
                                    <td>
                                        <asp:TextBox ID="txtSoBAQD" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Cấp xét xử:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlCapXetXu" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Toà ra BA/QD:</td>
                                    <td>
                                        <asp:TextBox ID="txtToaRaBAQD" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tên vụ án:</td>
                                    <td>
                                        <asp:TextBox ID="txtTenVuAn" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblNguyenDon" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtNguyenDon" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblBiDon" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtBiDon" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <asp:Panel runat="server" ID="pnToiDanh" Visible="false">
                                        <td>Tội danh:</td>
                                        <td>
                                            <asp:TextBox ID="txtToiDanh" runat="server" CssClass="user"
                                                Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </asp:Panel>
                                    <asp:Panel runat="server" ID="pnQHPL" Visible="false">
                                        <td>Quan hệ pháp luật:</td>
                                        <td>
                                            <asp:TextBox ID="txtQuanHePhapLuat" runat="server" CssClass="user"
                                                Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </asp:Panel>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin đơn kháng cáo</h4>
                        <div class="boder" style="padding: 10px; margin-right: 10px">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Người kháng cáo là:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNguoiKhangCao" runat="server" CssClass="user"
                                            Width="278px" Height="25px" Enabled="false"></asp:DropDownList>
                                    </td>
                                    <td style="width: 100px;">
                                        <asp:Label ID="lblHoTen" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtHoTenNguoiKhangCao" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tư cách tham gia tố tụng:</td>
                                    <td>
                                        <asp:TextBox ID="txtTCTT" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="2" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Số CMND/ CCCD:</td>
                                    <td>
                                        <asp:TextBox ID="txtSoChungMinhNguoiKhangCao" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>                                    
                                </tr>

                                <asp:Panel ID="pnToChuc" runat="server" Visible="false">
                                    <tr>
                                        <td>Mã số thuế:</td>
                                        <td>
                                            <asp:TextBox ID="txtMaSoThue" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td>Tỉnh:</td>
                                        <td>
                                            <asp:TextBox ID="txtNDD_Tinh" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Huyện:</td>
                                        <td>
                                            <asp:TextBox ID="txtNDD_Huyen" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Địa chỉ chi tiết:</td>
                                        <td>
                                            <asp:TextBox ID="txtNDD_DCChiTiet" CssClass="user"
                                                runat="server" TextMode="multiline" Rows="2" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td>Người đại diện là:</td>
                                        <td>
                                            <asp:TextBox ID="txtNDD_NguoiDaiDien" CssClass="user" runat="server"
                                                Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Chức vụ:</td>
                                        <td>
                                            <asp:TextBox ID="txtNDD_ChucVu" CssClass="user"
                                                runat="server" Width="270px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>

                                <asp:Panel runat="server" ID="pnCaNhan" Visible="false">
                                    <tr>
                                        <td>Năm sinh:</td>
                                        <td>
                                            <asp:TextBox ID="txtNamSinhNguoiKhangCao" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Giới tính:</td>
                                        <td>
                                            <asp:TextBox ID="txtGioiTinhNguoiKhangCao" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nơi cư trú (Tỉnh/TP):</td>
                                        <td>
                                            <asp:TextBox ID="txtNoiCuTruNguoiKhangCao" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                        <td>Quận/Huyện:</td>
                                        <td>
                                            <asp:TextBox ID="txtQuanHuyenNguoiKhangCao" runat="server" CssClass="user"
                                                Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Địa chỉ chi tiết:</td>
                                        <td>
                                            <asp:TextBox ID="txtDiaChiChiTietNguoiKhangCao" runat="server" CssClass="user"
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
                                    <td>Nội dung kháng cáo:</td>
                                    <td>
                                        <asp:TextBox ID="txtNoiDungKhangCao" runat="server" CssClass="user"
                                            Width="270px" TextMode="multiline" Rows="3" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số lượng đơn:</td>
                                    <td>
                                        <asp:TextBox ID="txtSoLuongDon" runat="server" CssClass="user"
                                            Width="270px" Height="20px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
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
