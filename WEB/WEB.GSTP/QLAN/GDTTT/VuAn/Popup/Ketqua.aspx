<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Ketqua.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.Ketqua" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Kết quả giải quyết</title>
    <%--<link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>--%>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
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
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .col1 {
            width: 110px;
        }

        .col2 {
            width: 206px;
        }

        .col3 {
            width: 105px;
        }

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }
    </style>
    <asp:Panel runat="server">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            

            <ContentTemplate>
                <asp:HiddenField ID="lstDataUS" Value="" runat="server" />
                <div class="boxchung">
                    <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                            <table class="table_info_va">
                                <tr>
                                    <td style="width: 110px;">Vụ án:</td>
                                    <td colspan="3" style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtTenVuan" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số thụ lý:</td>
                                    <td style="width: 250px;"><b>
                                        <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                    <td style="width: 105px">Ngày thụ lý:</td>
                                    <td><b>
                                        <asp:Literal ID="txtVuAn_NgayThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Loại án:</td>
                                    <td><b>
                                        <asp:Literal ID="txtVuan_Loaian" runat="server"></asp:Literal></b>
                                    </td>
                                    <td>Thủ tục GQ:</td>
                                    <td><b>
                                        <asp:Literal ID="txtVuan_LoaiGDTT" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số BA/QĐ:</td>
                                    <td><b>
                                        <asp:Literal ID="txtVuAn_SoBanAn" runat="server"></asp:Literal></b>
                                    </td>
                                    <td>Ngày BA/QĐ:</td>
                                    <td><b>
                                        <asp:Literal ID="txtVuAn_NgayBanAn" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nguyên đơn/ Người khởi kiện:</td>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                    </td>
                                    <td>Bị đơn/ Người  bị kiện:</td>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Người khiếu nại:</td>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuan_NguoiGui" runat="server"></asp:Literal></b>
                                    </td>
                                    <td>Trạng thái Hồ sơ:</td>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuan_TrangthaiHS" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ghi chú:</td>
                                    <td style="vertical-align: top;" colspan="3"><b>
                                        <asp:Literal ID="txtVuan_Ghichu" runat="server"></asp:Literal></b>
                                    </td>

                                </tr>

                            </table>
                        </div>
                    </div>
                    <!-------------------------------------------------->
                    <div style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                        <h4 class="tleboxchung">Thông tin QĐ hoãn thi hành án</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1" style="width: 95%; margin: 0 auto;">
                                <tr>
                                    <td class="col1">Hoãn thi hành án ?</td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdHoanTHA" runat="server" Font-Bold="true"
                                            RepeatDirection="Horizontal"
                                            AutoPostBack="True" OnSelectedIndexChanged="rdHoanTHA_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Selected="True" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>

                                <asp:Panel ID="pnHoanTHA" runat="server">
                                    <tr>
                                        <td>Ngày<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtHTA_Ngay" runat="server"
                                                onkeypress="return isNumber(event)"
                                                CssClass="user" Width="232px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtHTA_Ngay_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtHTA_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtHTA_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td class="col4">Số<span class="batbuoc">*</span></td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtHTA_So" runat="server"
                                                onkeypress="return isNumber(event)"
                                                CssClass="user" Width="232px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Người ký<span class="batbuoc">*</span></td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="dropHTA_NguoiKy" CssClass="chosen-select"
                                                runat="server" Width="240">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateHoanTHA" runat="server" CssClass="buttoninput"
                                                OnClientClick="return validate_HoanTHA();"
                                                Text="Lưu" OnClick="cmdUpdateHoanTHA_Click" />
                                            <asp:Button ID="cmdXoaHoanTHA" runat="server"
                                                CssClass="buttoninput"
                                                Text="Xóa Hoãn THA" OnClick="cmdXoaHoanTHA_Click" />
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td colspan="4">
                                        <asp:Label runat="server" Font-Bold="true" ID="lttMsgHoanTHA" ForeColor="Red"></asp:Label></td>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div style="float: left; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Kết quả giải quyết đơn</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1" style="width: 95%; margin: 0 auto;">
                                <tr>
                                    <td class="col1">Kết quả GQ</td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdbLoai" runat="server"
                                            Font-Bold="true" RepeatDirection="Horizontal"
                                            AutoPostBack="True" OnSelectedIndexChanged="rdbLoai_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Selected="True" Text="Trả lời đơn"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Kháng nghị"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Xếp đơn"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Xử lý khác"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="VKS đang GQ"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnDon" runat="server">
                                    <tr>
                                        <td>Chọn đơn</td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="dropDon" CssClass="chosen-select" multiple runat="server" Width="240px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbl_GQD_NgayCV" runat="server" Text="Ngày phát hành của Vụ"></asp:Label><span class="batbuoc">*</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtGQD_NgayCV" runat="server" CssClass="user"
                                            onkeypress="return isNumber(event)"
                                            Width="232px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtGQD_NgayCV_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtGQD_NgayCV" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtGQD_NgayCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                </tr>
                                <asp:Panel ID="pnTLD" runat="server">
                                    <tr>
                                        
                                        <td class="col3">Ngày<span class="batbuoc"></span></td>
                                        <td>
                                            <asp:TextBox ID="txtTLD_Ngay" runat="server"
                                                onkeypress="return isNumber(event)"
                                                AutoPostBack="true" OnTextChanged="txtTLD_Ngay_TextChanged"
                                                CssClass="user" Width="232px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTLD_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTLD_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td class="col5">Số<span class="batbuoc"></span></td>
                                        <td class="col5">
                                            <asp:TextBox ID="txtTLD_So"
                                                runat="server" CssClass="user" Width="262px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Literal ID="lttNguoiKy" runat="server" Text="Người ký"></asp:Literal></td>
                                        <td runat="server" id="txtTLD_NguoiKy_td" colspan="3">
                                            <asp:TextBox ID="txtTLD_NguoiKy" runat="server" CssClass="user" Width="232px" MaxLength="240"></asp:TextBox>
                                        </td>
                                        <td runat="server" id="dropTLD_NguoiKy_td" colspan="3">
                                            <asp:DropDownList ID="dropTLD_NguoiKy" CssClass="chosen-select"
                                                runat="server" OnSelectedIndexChanged="dropTLD_NguoiKy_SelectedIndexChanged" Width="240px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnQDKN" Visible="false" runat="server">
                                    <tr>
                                        
                                        <td class="col3">Ngày<span class="batbuoc"></span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="232px"
                                                onkeypress="return isNumber(event)" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgayQD_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td class="col5">Số<span class="batbuoc"></span></td>
                                        <td class="col5">
                                            <asp:TextBox ID="txtSoQD" runat="server"
                                                CssClass="user" Width="215px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Thẩm quyền XX<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlThamquyenXX" CssClass="chosen-select"
                                                runat="server" Width="240px">
                                            </asp:DropDownList>
                                        </td>
                                        <td>Người ký</td>
                                        <td runat="server" id="txtKN_NguoiKy_td">
                                            <asp:TextBox ID="txtKN_NguoiKy" runat="server" CssClass="user" Width="225px" MaxLength="240"></asp:TextBox>
                                        </td>
                                        <td runat="server" id="dropKN_NguoiKy_td" colspan="3">
                                            <asp:DropDownList ID="dropKN_NguoiKy" CssClass="chosen-select"
                                                runat="server" OnSelectedIndexChanged="dropKN_NguoiKy_SelectedIndexChanged" Width="225px">
                                            </asp:DropDownList>
                                        </td>
                                        <tr>
                                            <td>Nội dung kháng nghị
                                            </td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtKN_Noidung" CssClass="user" runat="server" Width="625px" TextMode="MultiLine"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </tr>

                                </asp:Panel>
                                <asp:Panel ID="pnXepDon" runat="server" Visible="false">
                                    <tr>
                                        
                                        <td class="col3">Ngày<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayXepDon" runat="server"
                                                onkeypress="return isNumber(event)"
                                                CssClass="user" Width="232px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgayXepDon_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayXepDon" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayXepDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td class="col5">Số</td>
                                        <td class="col5">
                                            <asp:TextBox ID="txtSoXepDon" runat="server"
                                                CssClass="user" Width="262px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Literal ID="Literal1" runat="server" Text="Người QĐ xếp đơn"></asp:Literal></td>
                                        <td runat="server" id="txtNguoiDuyetXepDon_td">
                                            <asp:TextBox ID="txtNguoiDuyetXepDon" runat="server" CssClass="user" Width="262px" MaxLength="240"></asp:TextBox>
                                        </td>
                                        <td runat="server" id="dropNguoiDuyetXepDon_td" colspan="3">
                                            <asp:DropDownList ID="dropNguoiDuyetXepDon" CssClass="chosen-select"
                                                runat="server" OnSelectedIndexChanged="dropNguoiDuyetXepDon_SelectedIndexChanged" Width="270px">
                                            </asp:DropDownList>
                                        </td>
                                           
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnXuLyKhac" runat="server" Visible="false">
                                    <tr>
                                        <td class="col1">Số</td>
                                        <td class="col2">
                                            <asp:TextBox ID="txt_xlk_so" runat="server"
                                                CssClass="user" Width="232px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Người ký</td>
                                        <td colspan="3" runat="server" id="txtKN_NguoiKy_xlk_td">
                                            <asp:TextBox ID="txtKN_NguoiKy_xlk" runat="server" CssClass="user" Width="232px" MaxLength="240"></asp:TextBox>
                                        </td>
                                        <td runat="server" id="DropKN_NguoiKy_xlk_td" colspan="3">
                                            <asp:DropDownList ID="DropKN_NguoiKy_xlk" CssClass="chosen-select"
                                                runat="server" OnSelectedIndexChanged="dropKN_NguoiKy_xlk_SelectedIndexChanged" Width="270px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung<span class="batbuoc">*
                                        </td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNoiDung_xlk" CssClass="user" runat="server" Width="625px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnVKS_GQ" runat="server" Visible="false">
                                    <tr>
                                        
                                        <td class="col3">Ngày<span class="batbuoc"></span></td>
                                        <td>
                                            <asp:TextBox ID="txtTB_Ngay" runat="server"
                                                onkeypress="return isNumber(event)"
                                                CssClass="user" Width="232px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtTB_Ngay_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtTB_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtTB_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td class="col5">TB Số<span class="batbuoc"></span></td>
                                        <td class="col5">
                                            <asp:TextBox ID="txtTB_So" runat="server" CssClass="user" Width="215px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col1">Người ký</td>
                                        <td colspan="3" runat="server" id="txtTB_NguoiKy_td">
                                            <asp:TextBox ID="txtTB_NguoiKy" runat="server" CssClass="user" Width="232px" MaxLength="240"></asp:TextBox>
                                        </td>
                                        <td runat="server" id="DropTB_NguoiKy_td" colspan="3">
                                            <asp:DropDownList ID="DropTB_NguoiKy" CssClass="chosen-select"
                                                runat="server" OnSelectedIndexChanged="dropTB_NguoiKy_SelectedIndexChanged" Width="270px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </asp:Panel>

                                <!-----------Phan noi dung chung----------------->
                                <tr>
                                    <td>Ghi chú
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="625px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="4">
                                        <div>
                                            <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                            <asp:Label runat="server" Font-Bold="true" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                            OnClientClick="return validate();"
                                            Text="Lưu" OnClick="cmdUpdate_Click" />
                                        <asp:Button ID="cmdXoa" runat="server" CssClass="buttoninput"
                                            Text="Xóa KQ giải quyết" OnClick="cmdXoa_Click"
                                            OnClientClick="return confirm('Bạn muốn xóa kết quả giải quyết đơn?');" />
                                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                    </td>
                                </tr>

                                <%-- Danh sach Khang Nghi --%>
                                <tr>
                                    <td colspan="4">
                                        <asp:Repeater ID="rptKhangNghi" runat="server" OnItemCommand="rptKhangNghi_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">
                                                        <td colspan="2"><strong>KHÁNG NGHỊ </strong>
                                                        </td>
                                                        <td colspan="7" style="background: #ffffff;"></td>
                                                    </tr>
                                                    <tr class="header">
                                                        <td width="30px">
                                                            <div align="center"><strong>STT</strong></div>
                                                        </td>
                                                        <td width="100">
                                                            <div align="center"><strong>Họ tên</strong></div>
                                                        </td>
                                                        <td width="120px">
                                                            <div align="center"><strong>Địa chỉ</strong></div>
                                                        </td>
                                                        <td width="70px"><strong>Số & Ngày thụ lý</strong></td>
                                                        <td width="70px">
                                                            <div align="center"><strong>Số & Ngày Kháng Nghị</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Người Kháng nghị</strong></div>
                                                        </td>

                                                        <td width="80px">
                                                            <div align="center"><strong>Ngày phát hành</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Ghi chú</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Thao tác</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="text-align: center;"><%# Container.ItemIndex + 1 %></td>

                                                    <td><%# Eval("NguoiNhan") %></td>
                                                    <td><%# Eval("DIACHINHAN") %></td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("TL_So") + (String.IsNullOrEmpty(Eval("TL_So")+"") ? "": (String.IsNullOrEmpty(Eval("TL_Ngay")+"") ?"":"<br/>"+ Eval("TL_Ngay")))%>

                                                    </td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("So") %><br />
                                                        <%# string.Format("{0:dd/MM/yyyy}",Eval("Ngay")) %></td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("NGUOIKY") %>
                                                    </td>
                                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYPHATHANH")) %></td>
                                                    <td><%# Eval("GhiChu") %></td>
                                                    <td style="text-align: center;">
                                                        <asp:LinkButton ID="lkSuaKN" runat="server"
                                                            Text="Sửa" ForeColor="#0e7eee"
                                                            CommandName="Sua" CommandArgument='<%#Eval("ID")%>'></asp:LinkButton>
                                                        &nbsp;&nbsp;
                                                        <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                            Text="Xóa" ForeColor="#0e7eee"
                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa trả lời đơn này? ');"></asp:LinkButton>

                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>

                                <%-- Danh sach các Tra loi don --%>
                                <tr>
                                    <td colspan="4">
                                        <asp:Repeater ID="rptTraLoiDon" runat="server" OnItemCommand="rptTraLoiDon_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">

                                                        <td colspan="2"><strong>TRẢ LỜI ĐƠN</strong>
                                                        </td>
                                                        <td colspan="6" style="background: #ffffff;"></td>
                                                    </tr>
                                                    <tr class="header">
                                                        <td width="30px">
                                                            <div align="center"><strong>STT</strong></div>
                                                        </td>
                                                        <td width="100">
                                                            <div align="center"><strong>Họ tên</strong></div>
                                                        </td>
                                                        <td width="120px">
                                                            <div align="center"><strong>Địa chỉ</strong></div>
                                                        </td>
                                                        <td width="70px"><strong>Số & Ngày thụ lý</strong></td>
                                                        <td width="70px">
                                                            <div align="center"><strong>Số & Ngày TLĐ</strong></div>
                                                        </td>

                                                        <td width="80px">
                                                            <div align="center"><strong>Ngày phát hành</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Ghi chú</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Thao tác</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="text-align: center;"><%# Container.ItemIndex + 1 %></td>

                                                    <td><%# Eval("NguoiNhan") %></td>
                                                    <td><%# Eval("DIACHINHAN") %></td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("TL_So") + (String.IsNullOrEmpty(Eval("TL_So")+"") ? "": (String.IsNullOrEmpty(Eval("TL_Ngay")+"") ?"":"<br/>"+ Eval("TL_Ngay")))%>

                                                    </td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("So") %><br />
                                                        <%# string.Format("{0:dd/MM/yyyy}",Eval("Ngay")) %></td>
                                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYPHATHANH")) %></td>
                                                    <td><%# Eval("GhiChu") %></td>
                                                    <td style="text-align: center;">
                                                        <asp:LinkButton ID="lkSuaKN" runat="server"
                                                            Text="Sửa" ForeColor="#0e7eee"
                                                            CommandName="Sua" CommandArgument='<%#Eval("ID")%>'></asp:LinkButton>
                                                        &nbsp;&nbsp;
                                                        <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                            Text="Xóa" ForeColor="#0e7eee"
                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa trả lời đơn này? ');"></asp:LinkButton>

                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>

                                <%-- Danh sach các Xếp don --%>
                                <tr>
                                    <td colspan="4">
                                        <asp:Repeater ID="rptXepDon" runat="server" OnItemCommand="rptXepDon_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">

                                                        <td colspan="2"><strong>XẾP ĐƠN</strong>
                                                        </td>
                                                        <td colspan="6" style="background: #ffffff;"></td>
                                                    </tr>
                                                    <tr class="header">
                                                        <td width="30px">
                                                            <div align="center"><strong>STT</strong></div>
                                                        </td>
                                                        <td width="100">
                                                            <div align="center"><strong>Họ tên</strong></div>
                                                        </td>
                                                        <td width="120px">
                                                            <div align="center"><strong>Địa chỉ</strong></div>
                                                        </td>
                                                        <td width="70px"><strong>Số & Ngày thụ lý</strong></td>
                                                        <td width="70px">
                                                            <div align="center"><strong>Số & Ngày TLĐ</strong></div>
                                                        </td>

                                                        <td width="80px">
                                                            <div align="center"><strong>Ngày phát hành</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Ghi chú</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Thao tác</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="text-align: center;"><%# Container.ItemIndex + 1 %></td>

                                                    <td><%# Eval("NguoiNhan") %></td>
                                                    <td><%# Eval("DIACHINHAN") %></td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("TL_So") + (String.IsNullOrEmpty(Eval("TL_So")+"") ? "": (String.IsNullOrEmpty(Eval("TL_Ngay")+"") ?"":"<br/>"+ Eval("TL_Ngay")))%>

                                                    </td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("So") %><br />
                                                        <%# string.Format("{0:dd/MM/yyyy}",Eval("Ngay")) %></td>
                                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYPHATHANH")) %></td>
                                                    <td><%# Eval("GhiChu") %></td>
                                                    <td style="text-align: center;">
                                                        <asp:LinkButton ID="lkSuaKN" runat="server"
                                                            Text="Sửa" ForeColor="#0e7eee"
                                                            CommandName="Sua" CommandArgument='<%#Eval("ID")%>'></asp:LinkButton>
                                                        &nbsp;&nbsp;
                                                        <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                            Text="Xóa" ForeColor="#0e7eee"
                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa trả lời đơn này? ');"></asp:LinkButton>

                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>

                                 <%-- Danh sach các Xu ly khac --%>
                                <tr>
                                    <td colspan="4">
                                        <asp:Repeater ID="rptXuLyKhac" runat="server" OnItemCommand="rptXuLyKhac_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">

                                                        <td colspan="2"><strong>XỬ LÝ KHÁC</strong>
                                                        </td>
                                                        <td colspan="6" style="background: #ffffff;"></td>
                                                    </tr>
                                                    <tr class="header">
                                                        <td width="30px">
                                                            <div align="center"><strong>STT</strong></div>
                                                        </td>
                                                        <td width="100">
                                                            <div align="center"><strong>Họ tên</strong></div>
                                                        </td>
                                                        <td width="120px">
                                                            <div align="center"><strong>Địa chỉ</strong></div>
                                                        </td>
                                                        <td width="70px"><strong>Số & Ngày thụ lý</strong></td>
                                                        <td width="70px">
                                                            <div align="center"><strong>Số & Ngày TLĐ</strong></div>
                                                        </td>

                                                        <td width="80px">
                                                            <div align="center"><strong>Ngày phát hành</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Ghi chú</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Thao tác</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="text-align: center;"><%# Container.ItemIndex + 1 %></td>

                                                    <td><%# Eval("NguoiNhan") %></td>
                                                    <td><%# Eval("DIACHINHAN") %></td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("TL_So") + (String.IsNullOrEmpty(Eval("TL_So")+"") ? "": (String.IsNullOrEmpty(Eval("TL_Ngay")+"") ?"":"<br/>"+ Eval("TL_Ngay")))%>

                                                    </td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("So") %><br />
                                                        <%# string.Format("{0:dd/MM/yyyy}",Eval("Ngay")) %></td>
                                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYPHATHANH")) %></td>
                                                    <td><%# Eval("GhiChu") %></td>
                                                    <td style="text-align: center;">
                                                        <asp:LinkButton ID="lkSuaKN" runat="server"
                                                            Text="Sửa" ForeColor="#0e7eee"
                                                            CommandName="Sua" CommandArgument='<%#Eval("ID")%>'></asp:LinkButton>
                                                        &nbsp;&nbsp;
                                                        <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                            Text="Xóa" ForeColor="#0e7eee"
                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa trả lời đơn này? ');"></asp:LinkButton>

                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>

                                <%-- Danh sach VKS đang GQ --%>
                                <tr>
                                    <td colspan="4">
                                        <asp:Repeater ID="rptVKS" runat="server" OnItemCommand="rptVKS_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">

                                                        <td colspan="2"><strong>VKS đang GQ</strong>
                                                        </td>
                                                        <td colspan="6" style="background: #ffffff;"></td>
                                                    </tr>
                                                    <tr class="header">
                                                        <td width="30px">
                                                            <div align="center"><strong>STT</strong></div>
                                                        </td>
                                                        <td width="100">
                                                            <div align="center"><strong>Họ tên</strong></div>
                                                        </td>
                                                        <td width="120px">
                                                            <div align="center"><strong>Địa chỉ</strong></div>
                                                        </td>
                                                        <td width="70px"><strong>Số & Ngày thụ lý</strong></td>
                                                        <td width="70px">
                                                            <div align="center"><strong>Số & Ngày TLĐ</strong></div>
                                                        </td>

                                                        <td width="80px">
                                                            <div align="center"><strong>Ngày phát hành</strong></div>
                                                        </td>
                                                        <td>
                                                            <div align="center"><strong>Ghi chú</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Thao tác</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="text-align: center;"><%# Container.ItemIndex + 1 %></td>

                                                    <td><%# Eval("NguoiNhan") %></td>
                                                    <td><%# Eval("DIACHINHAN") %></td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("TL_So") + (String.IsNullOrEmpty(Eval("TL_So")+"") ? "": (String.IsNullOrEmpty(Eval("TL_Ngay")+"") ?"":"<br/>"+ Eval("TL_Ngay")))%>

                                                    </td>
                                                    <td style="text-align: center;">
                                                        <%# Eval("So") %><br />
                                                        <%# string.Format("{0:dd/MM/yyyy}",Eval("Ngay")) %></td>
                                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYPHATHANH")) %></td>
                                                    <td><%# Eval("GhiChu") %></td>
                                                    <td style="text-align: center;">
                                                        <asp:LinkButton ID="lkSuaKN" runat="server"
                                                            Text="Sửa" ForeColor="#0e7eee"
                                                            CommandName="Sua" CommandArgument='<%#Eval("ID")%>'></asp:LinkButton>
                                                        &nbsp;&nbsp;
                                                        <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                            Text="Xóa" ForeColor="#0e7eee"
                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa trả lời đơn này? ');"></asp:LinkButton>

                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>

                                <!---------------------------------->
                                <asp:Panel ID="pnThongBaoAQH" runat="server" Visible="false">
                                    <tr>
                                        <td colspan="4">Thông báo tới</td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <asp:Repeater ID="rpt" runat="server">
                                                <HeaderTemplate>
                                                    <table class="table2" width="100%" border="1">
                                                        <tr class="header">
                                                            <td width="40px">
                                                                <div align="center"><strong>TT</strong></div>
                                                            </td>
                                                            <td width="150px">
                                                                <div align="center"><strong>Họ tên</strong></div>
                                                            </td>
                                                            <td>
                                                                <div align="center"><strong>Địa chỉ</strong></div>
                                                            </td>

                                                            <td width="80px">
                                                                <div align="center"><strong>Đối tượng</strong></div>
                                                            </td>
                                                            <%--   <td width="50px" style="">
                                                                <div align="center"><strong>Gửi ?</strong></div>
                                                            </td>--%>

                                                            <td width="80px" style="">
                                                                <div align="center"><strong>Số</strong></div>
                                                            </td>
                                                            <td width="80px" style="">
                                                                <div align="center"><strong>Ngày</strong></div>
                                                            </td>
                                                            <td style="">
                                                                <div align="center"><strong>Ghi chú</strong></div>
                                                            </td>

                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td><%# Container.ItemIndex + 1 %></td>
                                                        <td>
                                                            <asp:HiddenField ID="hddDonID" runat="server" Value='<%#Eval("DonID") %>' />
                                                            <asp:HiddenField ID="hddThongBaoID" runat="server" Value='<%#Eval("ThongBaoID") %>' />
                                                            <asp:Literal ID="lttHoTen" runat="server" Text='<%#Eval("TenCQChuyenDon") %>'></asp:Literal>
                                                        </td>
                                                        <td>
                                                            <asp:Literal ID="lttAddress" runat="server" Text='<%#Eval("CQChuyenDon_DiaChi") %>'></asp:Literal>
                                                        </td>
                                                        <td><%#Eval("LOAIDS")%></td>
                                                        <%--<td style="text-align: center; ">
                                                            <asp:CheckBox ID="chkIsSend" runat="server"
                                                                Checked='<%# Convert.ToDecimal(Eval("ThongBaoID")+"")>0 ? true:false  %>' /></td>--%>
                                                        <td style="">
                                                            <asp:TextBox ID="txtSo" onkeypress="return isNumber(event)" Text='<%#Eval("SO") %>'
                                                                runat="server" CssClass="user" Width="70px" MaxLength="50"></asp:TextBox>
                                                        </td>
                                                        <td style="">
                                                            <asp:TextBox ID="txtNgay" runat="server"
                                                                onkeypress="return isNumber(event)" Text='<%#Eval("NGAY") %>'
                                                                CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                        </td>
                                                        <td style="">
                                                            <asp:TextBox ID="txtGhiChu" Text='<%#Eval("GhiChu") %>'
                                                                runat="server" CssClass="user" Width="90%"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <asp:Repeater ID="rptTB" runat="server">
                                                <HeaderTemplate>
                                                    <table class="table2" width="100%" border="1">
                                                        <tr class="header">
                                                            <td width="40px">
                                                                <div align="center"><strong>STT</strong></div>
                                                            </td>
                                                            <td width="80px">
                                                                <div align="center"><strong>Số</strong></div>
                                                            </td>
                                                            <td width="80px">
                                                                <div align="center"><strong>Ngày</strong></div>
                                                            </td>
                                                            <td>
                                                                <div align="center"><strong>Ghi chú</strong></div>
                                                            </td>
                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td><%# Container.ItemIndex + 1 %></td>

                                                        <td><%# Eval("So") %></td>
                                                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGay")) %></td>

                                                        <td><%# String.IsNullOrEmpty(Eval("NGuoiNhan")+"")? "": ((Eval("NGuoiNhan")+"" )
                                                                                                                 + (String.IsNullOrEmpty(Eval("NGuoiNhan")+"")?"":"<br/>")
                                                                                                                ) %>
                                                            <%# Eval("GhiChu") %></td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <asp:Button ID="cmdUpdateThongBaoAnQH" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateThongBaoAnQH_Click" />
                                            <asp:Button ID="Button1" runat="server" CssClass="buttoninput"
                                                Text="Xoá" OnClick="cmdDeleteThongBaoAnQH_Click" />
                                        </td>
                                    </tr>
                                </asp:Panel>

                                <!-----------Dinh kem file - tam thoi ko dung---------------------->
                                <tr style="display: none;">
                                    <td>Đính kèm tệp</td>
                                    <td colspan="3">
                                        <asp:HiddenField ID="hddFilePath" runat="server" />
                                        <asp:CheckBox ID="chkKySo" Visible="false" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                        <br />
                                        <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                        <asp:HiddenField ID="hddSessionID" runat="server" />
                                        <asp:HiddenField ID="hddURLKS" runat="server" />
                                        <div id="zonekyso" style="display: none; margin-bottom: 5px; margin-top: 10px;">
                                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình</button><br />
                                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                            </ul>
                                        </div>
                                        <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                            <asp:Image ID="Throbber" runat="server"
                                                ImageUrl="~/UI/img/loading-gear.gif" />
                                        </div>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td></td>
                                    <td colspan="3">
                                        <asp:LinkButton ID="lbtDownload" Visible="false"
                                            runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                                </tr>
                                <!---------------------------------->

                                <%--<tr>
                                    <td>Ghi chú
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="625px"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td align="center" colspan="4">
                                        <div>
                                            <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                            <asp:Label runat="server" Font-Bold="true" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                            OnClientClick="return validate();"
                                            Text="Lưu" OnClick="cmdUpdate_Click" />
                                        <asp:Button ID="cmdXoa" runat="server" CssClass="buttoninput"
                                            Text="Xóa KQ giải quyết" OnClick="cmdXoa_Click"
                                            OnClientClick="return confirm('Bạn muốn xóa kết quả giải quyết đơn?');" />
                                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                    </td>
                                </tr>--%>
                            </table>
                        </div>
                    </div>
                </div>

                <script>
                    function validate_HoanTHA() {
                        var rdHoanTHA = document.getElementById('<%=rdHoanTHA.ClientID%>');
                        var selected_value = GetStatusRadioButtonList(rdHoanTHA);
                        if (selected_value == "1") {
                            var txtHTA_So = document.getElementById('<%=txtHTA_So.ClientID%>');
                            if (!Common_CheckEmpty(txtHTA_So.value)) {
                                alert('Bạn chưa nhập số quyết định Hoãn thi hành án. Hãy kiểm tra lại!');
                                txtHTA_So.focus();
                                return false;
                            }

                            var txtHTA_Ngay = document.getElementById('<%=txtHTA_Ngay.ClientID%>');
                            if (!CheckDateTimeControl(txtHTA_Ngay, 'ngày quyết định Hoãn thi hành án'))
                                return false;

                            var dropHTA_NguoiKy = document.getElementById('<%=dropHTA_NguoiKy.ClientID%>');
                            var value_change = dropHTA_NguoiKy.options[dropHTA_NguoiKy.selectedIndex].value;
                            if (value_change == "0") {
                                alert("Bạn chưa chọn mục 'Người ký'. Hãy kiểm tra lại!");
                                dropHTA_NguoiKy.focus();
                                return false;
                            }
                        }
                        return true;
                    }
                    function validate() {
                        var txtGQD_NgayCV = document.getElementById('<%=txtGQD_NgayCV.ClientID%>');
                        if (!CheckDateTimeControl(txtGQD_NgayCV, 'ngày phát hành của Vụ'))
                            return false;

                        var rdbLoai = document.getElementById('<%=rdbLoai.ClientID%>');
                        selected_value = GetStatusRadioButtonList(rdbLoai);
                        if (selected_value == "0") {
                            //tra loi don
                          <%--  var txtTLD_So = document.getElementById('<%=txtTLD_So.ClientID%>');
                            if (!Common_CheckEmpty(txtTLD_So.value)) {
                                alert('Bạn chưa nhập số thông báo. Hãy kiểm tra lại!');
                                txtTLD_So.focus();
                                return false;
                            }

                            var txtTLD_Ngay = document.getElementById('<%=txtTLD_Ngay.ClientID%>');
                            if (!CheckDateTimeControl(txtTLD_Ngay, 'ngày thông báo'))
                                return false;--%>
                        }
                        else if (selected_value == "1") {
                            //Khang nghi
                           <%-- var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
                            if (!Common_CheckEmpty(txtSoQD.value)) {
                                alert('Bạn chưa nhập số quyết định. Hãy kiểm tra lại!');
                                txtSoQD.focus();
                                return false;
                            }
                            var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
                            if (!CheckDateTimeControl(txtNgayQD, 'ngày quyết định'))
                                return false;--%>

                            var ddlThamquyenXX = document.getElementById('<%=ddlThamquyenXX.ClientID%>');
                            var value_change = ddlThamquyenXX.options[ddlThamquyenXX.selectedIndex].value;
                            if (value_change == "0") {
                                alert("Bạn chưa chọn mục 'Thẩm quyền XX'. Hãy kiểm tra lại!");
                                ddlThamquyenXX.focus();
                                return false;
                            }
                        }
                        else if (selected_value == "2") {
                            var txtNgayXepDon = document.getElementById('<%=txtNgayXepDon.ClientID%>');
                            if (!CheckDateTimeControl(txtNgayXepDon, 'ngày xếp đơn'))
                                return false;
                        }
                        else if (selected_value == "3") {
                            var txtNoiDung_xlk = document.getElementById('<%=txtNoiDung_xlk.ClientID%>');
                            if (!Common_CheckEmpty(txtNoiDung_xlk.value)) {
                                alert('Bạn chưa nhập nội dung xử lý!');
                                txtNoiDung_xlk.focus();
                                return false;
                            }
                        }

                        return true;
                    }
                    function ReloadParent() {
                        window.onunload = function (e) {
                            opener.LoadDsDon();
                        };
                    }

                    function ddlMultiSelect_fu() {
                    $('#<%=dropDon.ClientID %>').chosen().change(function (e, params) {
                        var values = $('#<%=dropDon.ClientID %>').chosen().val();
                        console.log(values);
                        document.getElementById('<%=lstDataUS.ClientID%>').value = values;
                        //tamnc 17/03/2022//
                    });
                    }
                    function ddlMultiSelect_fu_setvalue() {
                        var my_val = document.getElementById('<%=lstDataUS.ClientID%>').value;
                        var str_array = my_val.split(',');
                        $('#<%=dropDon.ClientID %>').val(str_array).trigger("chosen:updated");
                        console.log(str_array);
                    }
                </script>
                <script>
                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                        ddlMultiSelect_fu();
                    }</script>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                        &nbsp;&nbsp;
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
</asp:Panel>
</body>

<script>
    Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
    function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }
</script>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
