<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AKT_Thongtindon.aspx.cs" Inherits="WEB.GSTP.QLAN.DONGHEP.DONKHAC.AKT_Thongtindon" %>

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

        input {
            height: 25px !important;
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
    </style>

    <form id="form1" runat="server">
        <asp:HiddenField ID="hddID" runat="server" Value="0" />
        <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin vụ việc</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr style="display: none;">
                                    <td>Mã vụ việc</td>
                                    <td>
                                        <asp:TextBox ID="txtMaVuViec" CssClass="user"
                                            placeholder="Mã vụ việc tự sinh" ReadOnly="true"
                                            runat="server" Width="98%" MaxLength="50" Enabled="false"></asp:TextBox></td>
                                    <td>Tên vụ việc</td>
                                    <td>
                                        <asp:TextBox ID="txtTenVuViec" CssClass="user" placeholder="Tên vụ việc tự sinh"
                                            ReadOnly="true" runat="server" Width="98%" Enabled="false"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td style="width: 115px;">Hình thức nhận đơn</td>
                                    <td style="width: 260px;">
                                        <asp:DropDownList ID="ddlHinhthucnhandon" CssClass="chosen-select" runat="server" Width="250px">
                                            <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Qua bưu điện"></asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td style="width: 145px;">Loại đơn</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaidon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaidon_SelectedIndexChanged">
                                            <asp:ListItem Value="7" Text="Đơn kháng cáo"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="Đơn khác"></asp:ListItem>
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Ngày ghi trên đơn</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayViet" runat="server" CssClass="user" Width="110px" MaxLength="10" Height="25px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayViet" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayViet" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td>Ngày nhận đơn hoặc ngày ghi trên dấu bưu điện <span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user" Width="110px" MaxLength="10" AutoPostBack="true" Height="25px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                </tr>
                                <tr>

                                    <td>Quan hệ pháp luật <span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlQuanhephapluat" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuanhephapluat_SelectedIndexChanged" Visible="false"></asp:DropDownList>
                                        <asp:TextBox ID="txtQuanhephapluat" CssClass="user" placeholder="" runat="server" Width="250px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>

                                    </td>
                                    <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlQHPLTK" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>
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
                                    <td>Loại quan hệ</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaiQuanhe" CssClass="chosen-select" runat="server" Width="250px">
                                            <asp:ListItem Value="1" Text="Tranh chấp"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Yêu cầu"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>

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
                                <tr>
                                    <td>
                                        <asp:Label ID="lbNoidung" runat="server"></asp:Label></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNoidungkhoikien" CssClass="user" runat="server" Width="671px" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Label ID="lbGhiChu" runat="server"></asp:Label></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="671px" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                   <%--<asp:Panel ID="pnTTKC" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin kháng cáo</h4>--%>
                    <%--<div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <asp:RadioButton ID="rbtKC" runat="server" Text="Kháng cáo" GroupName="KC" Checked="true" />
                                    </tr>
                                    <tr>
                                        <td>Ngày viết đơn KC</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayVDKC" runat="server" CssClass="user" Width="250px" MaxLength="10" Height="25px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayVDKC" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayVDKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 140px;">Ngày kháng cáo <span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayKC" runat="server" CssClass="user" Width="250px" MaxLength="10" Height="25px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayKC" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Tên người kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlNguoiKC" CssClass="chosen-select" runat="server" Width="250px">
                                            </asp:DropDownList>
                                            </td>
                                            <td >Loại kháng cáo<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdLoaiKC" runat="server"
                                                    RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="1">Bản án</asp:ListItem>
                                                    <asp:ListItem Value="2">Quyết định</asp:ListItem>
                                                    <asp:ListItem Value="3">Quyết định khác</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Số BA/QĐ<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;">
                                            <asp:TextBox ID="txtBAQD" CssClass="user" runat="server" Width="250px" Height="25px"></asp:TextBox></td>
                                        <td >Kháng cáo quá hạn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="RdKCQH" runat="server"
                                                RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày QĐ/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQDBA" runat="server" CssClass="user" Width="250px" MaxLength="10" Height="25px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayQDBA" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayQDBA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td >Tòa ra QĐ/BA</td>
                                        <td>
                                            <asp:DropDownList ID="ddlToaQDBA" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="250px">
                                            </asp:DropDownList>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Nội dung kháng cáo</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNDKC" CssClass="user" runat="server" Width="670px" TextMode="MultiLine"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>File đính kèm</td>
                                        <td>
                                            <asp:HiddenField ID="hddFilePath" runat="server" />
                                            <asp:HiddenField ID="hddFileID" runat="server" />
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                            <asp:LinkButton ID="lbtDownload" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                        </td>
                        </tr>
                                </table>
                            </div>--%>
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
                                    <%--<tr>
                                            <td>Hình thức nhận đơn<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdbHinhThucNhanDon" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Qua bưu điện"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            <td colspan="2"></td>
                                        </tr>--%>
                                    <tr>
                                        <td class="KCHNCol1" style="width: 113px;">Ngày viết đơn KC</td>
                                        <td class="KCHNCol2">
                                            <asp:TextBox ID="txtNgayVDKC" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayVDKC" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayVDKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td class="KCHNCol3" style="width: 138px;">Ngày kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td style="width: 285px;">
                                            <asp:TextBox ID="txtNgayKC" runat="server"
                                                AutoPostBack="true"
                                                CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayKC" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayKC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tên người kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlNguoiKC" CssClass="chosen-select" runat="server" Width="253px"></asp:DropDownList>
                                        </td>
                                        <td>Loại kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbLoaiKC" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKC_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Bản án"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Quyết định" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Quyết định khác"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số QĐ/BA</td>
                                        <td>
                                            <asp:DropDownList ID="ddlQDBA" CssClass="chosen-select" runat="server" Width="253px" AutoPostBack="True" OnSelectedIndexChanged="ddlQDBA_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td>Kháng cáo quá hạn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="RdKCQH" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày QĐ/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQDBA" Enabled="false" runat="server" ReadOnly="true" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayQDBA" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayQDBA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Tòa án ra QĐ/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtToaQDBA" ReadOnly="true" Enabled="false"
                                                runat="server" CssClass="user" Width="250px"></asp:TextBox>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Nội dung kháng cáo</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNDKC" runat="server" CssClass="user" Width="677px" TextMode="MultiLine" Height="50px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>File đính kèm</td>
                                        <td>
                                            <asp:HiddenField ID="hddFilePath" runat="server" />
                                            <asp:HiddenField ID="hddFileID" runat="server" />
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                            <asp:LinkButton ID="lbtDownload" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>

                                <%--<div class="boxchung">
                                    <h4 class="tleboxchung">Thông tin tạm ứng án phí</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td style="width: 115px;">Miễn tạm ứng án phí<span class="batbuoc">(*)</span></td>
                                                <td style="width: 259px;">
                                                    <asp:RadioButtonList ID="rdbMienAnphi" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbMienAnphi_SelectedIndexChanged">
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                                <td style="width: 137px;">Số biên lai</td>
                                                <td>
                                                    <asp:TextBox ID="txtSobienlai" runat="server" CssClass="user" Width="110px" MaxLength="20"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tạm ứng án phí</td>
                                                <td>
                                                    <asp:TextBox ID="txtAnphi" runat="server" Style="text-align: right; padding-right: 5px;" CssClass="user" Width="100px"
                                                        onkeypress="return isNumber(event)" onkeyup="javascript:this.value=Comma(this.value);"></asp:TextBox>
                                                </td>
                                                <td>Ngày nộp tạm ứng án phí</td>
                                                <td>
                                                    <asp:TextBox ID="txtNgaynopanphi" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgaynopanphi" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgaynopanphi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                    </tr>
                                </table>
                            </div>
                                    </div>--%>
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
                                        <td>Tòa án ra QĐ/BA</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtToaAnQD_KN" ReadOnly="true" Enabled="false" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 120px;">Người Kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:RadioButtonList ID="rdbDonVi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbDonVi_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Chánh án"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Viện trưởng"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                        <td style="width: 108px;">Cấp kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbCapkhangnghi" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbCapkhangnghi_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Cùng cấp"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Cấp trên"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr id="trDVKN" runat="server" visible="false">
                                        <td>Đơn vị kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlDonViKN" CssClass="chosen-select" runat="server" Width="242px"></asp:DropDownList></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Số kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td style="width:250px;">
                                            <asp:TextBox ID="txtSokhangnghi" runat="server" CssClass="user" Width="242px" MaxLength="20"></asp:TextBox>
                                        </td>
                                        <td>Ngày kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgaykhangnghi" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaykhangnghi" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgaykhangnghi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>

                                        <td>Loại kháng nghị<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdbLoaiKN" runat="server" Width="300px" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbLoaiKN_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Bản án"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Quyết định" Selected="true"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Quyết định khác"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Số QĐ/BA<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlSOQDBAKhangNghi" CssClass="chosen-select" runat="server" Width="242px" AutoPostBack="True" OnSelectedIndexChanged="ddlSOQDBAKhangNghi_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td>Ngày QĐ/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQDBA_KN" runat="server" ReadOnly="true" Enabled="false" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayQDBA_KN" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayQDBA_KN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
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
                    <%--</div>--%>
                    <%--</asp:Panel>--%>
                    <asp:Panel ID="pnTTD" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal1" runat="server" Text="Thông tin đơn"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Người gửi đơn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlNguoidungdon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlNguoidungdon_SelectedIndexChanged"></asp:DropDownList>
                                        </td>
                                        <td style="width: 145px;">Người đứng đơn</td>
                                        <td>
                                            <asp:DropDownList ID="ddlLoaidungdon" CssClass="chosen-select" runat="server" Width="250px">
                                                <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:115px;">Họ tên<span class="batbuoc">(*)</span></td>
                                        <td style="width:260px;">
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
                                        <td class=" ">
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
                                        <td>
                                            <asp:CheckBox ID="chkBoxCMND_DK" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMND_DK_CheckedChanged" />
                                        </td>
                                        <td>Năm sinh<%--<span class="batbuoc">(*)</span>--%></td>
                                        <td>
                                            <asp:TextBox ID="txtNamsinh_DK" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="100px" MaxLength="4" Height="25px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnCaNhanDK" runat="server">
                                        <tr>
                                            <td style="width: 115px;">Giới tính</td>
                                            <td>
                                                <asp:DropDownList ID="ddlGioiTinh_DK" CssClass="chosen-select" runat="server" Width="250px">
                                                    <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                                </asp:DropDownList></td>
                                        </tr>
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
                                        <tr>
                                            <td>Địa chỉ chi tiết</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtDiaChiCT_DK" runat="server" CssClass="user" Width="670px" MaxLength="100" Height="25px"></asp:TextBox></td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Email</td>
                                        <td>
                                            <asp:TextBox ID="txtEmail_DK" runat="server" CssClass="user" Width="250px" MaxLength="100" Height="25px"></asp:TextBox></td>
                                        <td>Điện thoại</td>
                                        <td>
                                            <asp:TextBox ID="txtTel_DK" runat="server" CssClass="user" Width="250px" MaxLength="10" Height="25px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung đơn</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtND_DK" CssClass="user" runat="server" Width="670px" TextMode="MultiLine"></asp:TextBox>
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
