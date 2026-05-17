<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="AHS_Thongtindon.aspx.cs" Inherits="WEB.GSTP.QLAN.DONGHEP.DONKHAC.AHS_Thongtindon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật quyết định và hình phạt</title>


    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
    <style>
        body {
            min-width: 0px;
            min-height: 0px;
        }

        .box {
            padding-bottom: 0px !important;
        }

        #chkND_ONuocNgoai, #chkBD_ONuocNgoai {
            height: 22px !important;
            position: absolute;
        }

        #chkISBVQLNK {
            height: 22px !important;
        }

        label[for=chkND_ONuocNgoai], label[for=chkBD_ONuocNgoai] {
            margin-left: 25px
        }
    </style>
</head>
<body>
    <style type="text/css">
        .msg_error {
            width: 50% !important;
        }

        .auto-style1 {
            width: 260px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddID" runat="server" Value="0" />
        <asp:HiddenField ID="hddBiCaoID" runat="server" Value="0" />
        <asp:HiddenField ID="hddBiCanDauVuID" runat="server" Value="0" />
        <asp:HiddenField ID="hddCaoTrangID" runat="server" Value="0" />
        <asp:HiddenField ID="hddMaGiaiDoan" runat="server" Value="0" />
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <%--<div class="boxchung">
                        <h4 class="tleboxchung bg_title_group">Thông tin bàn giao hồ sơ và cáo trạng của VKS</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 120px;">Trường hợp giao nhận <span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px;">
                                        <asp:DropDownList ID="dropTrangThaiGiaoNhan" CssClass="chosen-select"
                                            runat="server" Width="250px">
                                        </asp:DropDownList></td>

                                    <td style="width: 115px;">Quyết định truy tố</td>
                                    <td>
                                        <asp:DropDownList ID="dropQuyetDinhTruyTo" CssClass="chosen-select" runat="server"
                                            Width="160px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Số bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoBanCaoTrang" runat="server" CssClass="user align_right"
                                            Width="242px" Height="25px"></asp:TextBox>
                                    </td>
                                    <td>Ngày bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBanCaoTrang" runat="server" CssClass="user" Width="153px"
                                            MaxLength="10" onkeypress="return isNumber(event)" Enabled="false" Height="25px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBanCaoTrang" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBanCaoTrang" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayBanCaoTrang" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Số bút lục<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoButLuc" CssClass="user align_right" onkeypress="return isNumber(event)"
                                            runat="server" Width="242px" MaxLength="50" Height="26px"></asp:TextBox>
                                    </td>
                                    <td>Ngày giao<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayGiao" runat="server" CssClass="user" Width="153px"
                                            MaxLength="10" onkeypress="return isNumber(event)" Enabled="false" Height="25px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayGiao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayGiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server"
                                            ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayGiao"
                                            InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>--%>
                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <table class="table1">
                                <asp:Panel ID="pnMaVuAn" runat="server">
                                    <tr>
                                        <td style="width: 120px;">Loại đơn</td>
                                        <td style="width: 250px;">
                                            <asp:DropDownList ID="ddlLoaidon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaidon_SelectedIndexChanged">
                                                <asp:ListItem Value="7" Text="Đơn kháng cáo"></asp:ListItem>
                                                <asp:ListItem Value="8" Text="Đơn khác"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 115px">Mã vụ án</td>
                                        <td>
                                            <asp:TextBox ID="txtMaVuAn" CssClass="user" placeholder="Mã vụ án tự sinh"
                                                ReadOnly="true" runat="server" Width="160px" MaxLength="50" Enabled="false"></asp:TextBox>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>

                                </asp:Panel>
                                <tr>
                                    <td>Tên vụ án<span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px;">
                                        <asp:TextBox ID="txtTenVuAn" CssClass="user" placeholder="Tên bị can đầu vụ - tội danh"
                                            runat="server" Width="242px" Height="25px" Enabled="false"></asp:TextBox>
                                    </td>
                                    <td style="width: 120px;">Mức độ nghiêm trọng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="dropLoaiToiPham" CssClass="chosen-select"
                                            runat="server" Width="160px" Enabled="false">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Tên khác của vụ án</td>
                                    <td>
                                        <asp:TextBox ID="txtTenVuAnKhac" CssClass="user"
                                            runat="server" Width="242px" Height="25px" Enabled="false"></asp:TextBox></td>
                                    <td>Ngày xảy ra vụ án</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayXayra" runat="server" CssClass="user" onkeypress="return isNumber(event)"
                                            Width="65px" MaxLength="10" Enabled="false" Height="25px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server"
                                            TargetControlID="txtNgayXayra" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server"
                                            TargetControlID="txtNgayXayra" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                        Giờ
                                        <asp:DropDownList ID="dropGio" runat="server" CssClass="chosen-select" Width="60" Enabled="false">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr style="display: none">
                                    <td>Số bị can </td>
                                    <td>
                                        <asp:TextBox ID="txtSoBiCan" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server" Enabled="false" Text="0"
                                            Width="145px" MaxLength="50" Height="25px"></asp:TextBox>
                                    </td>
                                    <td>Số bị can tạm giam</td>
                                    <td>
                                        <asp:TextBox ID="txtSoBiCanTamGiam" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server" Enabled="false" Text="0"
                                            Width="145px" MaxLength="60"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbNoidung" runat="server"></asp:Label></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNoidungkhoikien" CssClass="user" runat="server" Width="500px" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:Panel ID="pnKhangCao" runat="server" Visible="true">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin kháng cáo</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td colspan="4">
                                            <asp:RadioButtonList ID="rdbPanelKC" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKC_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Kháng cáo" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Người kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbLoaiNguoiKC" runat="server"
                                                RepeatDirection="Horizontal"
                                                AutoPostBack="true"  OnSelectedIndexChanged="rdbLoaiNguoiKC_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Bị can" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Khác"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                        <td class="KCHNCol3">Loại kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbLoaiKC" runat="server" RepeatDirection="Horizontal"
                                                AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKC_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Bản án" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Quyết định"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Quyết định khác"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="KCHNCol1">Tên người kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td class="KCHNCol2">
                                            <asp:DropDownList ID="ddlNguoikhangcao" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                        </td>
                                        <asp:PlaceHolder ID="plNguoiBiKC" runat="server" Visible="false">
                                            <td>Người bị kháng cáo<span class="batbuoc">(*)</span></td>
                                        </asp:PlaceHolder>
                                
                                        <td>
                                            <asp:ListBox ID="lbNguoiBiKC"  CssClass="chosen-select"  runat="server" Width="250px" SelectionMode="Multiple" AutoPostBack="True"></asp:ListBox>
                                            <%--<asp:DropDownList ID="ddlNguoiBiKC" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True"></asp:DropDownList>--%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <%--<td class="KCHNCol1">Ngày viết đơn KC</td>
                                        <td class="KCHNCol2">
                                            <asp:TextBox ID="txtNgayvietdonKC" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayvietdonKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>--%>
                                        <td>Ngày kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgaykhangcao" runat="server"
                                                AutoPostBack ="true" OnTextChanged="txtNgaykhangcao_TextChanged"
                                                CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaykhangcao" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaykhangcao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Kháng cáo quá hạn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbQuahan_KC" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số QĐ/BA</td>
                                        <td>
                                            <asp:DropDownList ID="ddlSOQDBA_KC" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBA_KC_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td>Ngày QĐ/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQDBA_KC" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="157px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayQDBA_KC" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayQDBA_KC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án ra QĐ/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtToaAnQD_KC" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Yêu cầu kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td colspan="3">
                                            <asp:CheckBoxList ID="chkYeuCauKC" runat="server" RepeatDirection="Horizontal" RepeatColumns="2"></asp:CheckBoxList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung kháng cáo</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNoidungKC" runat="server" CssClass="user" Width="99.8%" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>File đính kèm</td>
                                        <td>
                                            <asp:HiddenField ID="hddFilePath_KC" runat="server" />
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoadKhangCao" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKhangCao_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                        </td>
                                        <td colspan="2">
                                            <asp:LinkButton ID="lbtDownloadKhangCao" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangCao_Click"></asp:LinkButton></td>
                                    </tr>

                                </table>
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnKhangNghi" runat="server" Visible="false">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin kháng nghị</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td colspan="4">
                                            <asp:RadioButtonList ID="rdbPanelKN" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelKN_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Kháng cáo" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 135px;">Người kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td style="width: 305px;">
                                            <asp:RadioButtonList ID="rdbDonVi" runat="server" RepeatDirection="Horizontal">
                                                <%--  <asp:ListItem Value="0" Text="Chánh án" ></asp:ListItem>--%>
                                                <asp:ListItem Value="1" Text="Viện trưởng" Selected="True"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                        <td style="width: 115px;">Cấp kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbCapkhangnghi" runat="server"
                                                RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Text="Cùng cấp"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Cấp trên"></asp:ListItem>
                                            </asp:RadioButtonList></td>
                                    </tr>
                                    <tr>
                                        <td>Người bị kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:ListBox ID="lbNguoiBiKN" CssClass="chosen-select" runat="server" Width="250px" SelectionMode="Multiple" AutoPostBack="True" Height="16px"></asp:ListBox>
                                            <%--<asp:DropDownList ID="ddlNguoiBiKN" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlNguoiBiKN_SelectedIndexChanged"></asp:DropDownList>--%>
                                        </td>
                                        <td>Loại kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbLoaiKN" runat="server" Width="300px" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKN_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Bản án" Selected="true"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Quyết định"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Quyết định khác"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr id="trDVKN" runat="server" visible="false">
                                        <td>Đơn vị kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlDonViKN" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Số kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSokhangnghi" runat="server" CssClass="user" Width="242px" MaxLength="20" Height="25px"></asp:TextBox>
                                        </td>
                                        <td>Ngày kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgaykhangnghi" runat="server" CssClass="user" Width="162px" MaxLength="10" Height="25px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaykhangnghi" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaykhangnghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số QĐ/BA</td>
                                        <td>
                                            <asp:DropDownList ID="ddlSOQDBAKhangNghi" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBAKhangNghi_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td>Ngày QĐ/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQDBA_KN" runat="server" ReadOnly="true" Enabled="false" CssClass="user" Width="162px" MaxLength="10" Height="25px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayQDBA_KN" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayQDBA_KN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tòa án ra QĐ/BA</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtToaAnQD_KN" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="242px" Height="25px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Yêu cầu kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td colspan="3">
                                            <asp:CheckBoxList ID="chkYeuCauKN" runat="server" RepeatDirection="Horizontal" RepeatColumns="2"></asp:CheckBoxList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung kháng nghị</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNoidungKN" runat="server" CssClass="user" Width="100%" TextMode="MultiLine" Height="50px" MaxLength="1000"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>File đính kèm</td>
                                        <td>
                                            <asp:HiddenField ID="hddFilePath_KN" runat="server" />
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoadKhangNghi" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKhangNghi_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                        </td>
                                        <td colspan="2">
                                            <asp:LinkButton ID="lbtDownloadKhangNghi" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadKhangNghi_Click"></asp:LinkButton></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnTTD" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal1" runat="server" Text="Thông tin đơn"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Danh sách người đứng đơn<span class="batbuoc">(*)</span></td>
                                        <td class="auto-style1">
                                            <asp:DropDownList ID="ddlNguoidungdon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlNguoidungdon_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td style="width: 115px;">Người đứng đơn</td>
                                        <td>
                                            <asp:DropDownList ID="ddlLoaidungdon" CssClass="chosen-select" runat="server" Width="250px">
                                                <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Họ tên<span class="batbuoc">(*)</span></td>
                                        <td class="auto-style1">
                                            <asp:TextBox ID="txtHoTen_DK" CssClass="user" runat="server" Width="250px" MaxLength="250" Height="25px"></asp:TextBox>
                                        </td>
                                        <td style="width: 115px;">
                                            <asp:Label ID="lbTCTT" runat="server">Tư cách tham gia tố tụng<span class="batbuoc">(*)</span></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="ddlTuCachToTung_DK" CssClass="chosen-select" runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Số CMND/CCCD<span class="batbuoc">(*)</span></td>
                                        <td class="auto-style1">
                                            <asp:TextBox ID="txtCMND_Dk" CssClass="user" runat="server" Width="250px" Height="25px"></asp:TextBox>
                                        </td>
                                        <td style="width: 75px;">Ngày sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtNgaysinh_DK" runat="server" CssClass="user" Width="100px" MaxLength="10" Height="25px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgaysinh_DK" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgaysinh_DK" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td class="auto-style1">
                                            <asp:CheckBox ID="chkBoxCMND_DK" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMND_DK_CheckedChanged" />
                                        </td>
                                        <td>Năm sinh<%--<span class="batbuoc">(*)</span>--%></td>
                                        <td>
                                            <asp:TextBox ID="txtNamsinh_DK" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="100px" MaxLength="4" Height="25px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Giới tính</td>
                                        <td>
                                            <asp:DropDownList ID="ddlGioiTinh_DK" CssClass="chosen-select" runat="server" Width="250px">
                                                <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                            </asp:DropDownList></td>
                                    </tr>
                                    <asp:Panel ID="pnCaNhanDK" runat="server">
                                        <tr>
                                            <td>Nơi cư trú (Tỉnh/TP)</td>
                                            <td>
                                                <asp:DropDownList ID="ddlTamtru_Tinh_DK" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlTamTru_Tinh_DK_SelectedIndexChanged"></asp:DropDownList>
                                            </td>
                                            <td>Quận/Huyện</td>
                                            <td>
                                                <asp:DropDownList ID="ddlTamtru_Huyen_DK" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Địa chỉ chi tiết</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtDiaChiCT_DK" runat="server" CssClass="user" Width="640px" MaxLength="100" Height="25px"></asp:TextBox></td>
                                    </tr>
                                    <asp:Panel ID="pnTGTT" runat="server">
                                        <tr>
                                            <td>Email</td>
                                            <td class="auto-style1">
                                                <asp:TextBox ID="txtEmail_DK" runat="server" CssClass="user" Width="250px" MaxLength="100" Height="25px"></asp:TextBox></td>
                                            <td>Điện thoại</td>
                                            <td>
                                                <asp:TextBox ID="txtTel_DK" runat="server" CssClass="user" Width="250px" MaxLength="10" Height="25px"></asp:TextBox></td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Nội dung đơn</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtND_DK" CssClass="user" runat="server" Width="640px" TextMode="MultiLine"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </asp:Panel>
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                    </div>
                    <div style="margin: 5px; text-align: center; width: 95%; margin-bottom: 70px;">
                        <asp:Button ID="cmdUpdateB" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" />

                        <asp:Button ID="cmdUpdateAndNewB" runat="server" CssClass="buttoninput" Text="Lưu & Thêm mới"
                            OnClick="cmdUpdateAndNew_Click" />
                        <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput" Text="Quay lại"
                            OnClick="cmdQuaylai_Click" />
                    </div>
                </div>
            </div>
        </div>
        <script>
            function ReloadParent() {
                window.onunload = function (e) {
                    opener.ReLoadGrid();
                };
            }
        </script>
    </form>
</body>
<script type="text/javascript">

    function pageLoad(sender, args) {
        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: false }, '.chosen-select-width': { width: '95%' } }
        for (var selector in config) {
            $(selector).chosen(config[selector]);
        }
    }
    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }

    function Setfocus(controlid) {
        var ctrl = document.getElementById(controlid);
        ctrl.focus();
    }
</script>
</html>
