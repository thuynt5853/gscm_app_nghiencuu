<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pBiCao.aspx.cs"
    Inherits="WEB.GSTP.QLAN.AHS.TaoHS.Popup.pBiCao" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin bị cáo</title>

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
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 550px;
            overflow: auto;
            position: absolute;
            top: 65px;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .row_change, .row_change td {
            background: yellow;
        }

        .row_no_change {
            background: white;
        }

        .align_right {
            text-align: right;
        }

        .title_hp {
            font-weight: bold;
            text-transform: uppercase;
            float: left;
            width: 100%;
            margin-bottom: 5px;
            border-top: dashed 1px #dcdcdc;
            padding-top: 10px;
            margin-top: 10px;
        }

        .margin_top {
            margin-top: 5px;
            float: left;
        }

        .span_date {
            margin-right: 5px;
        }

        #tblHP tr, td {
            vertical-align: top;
            padding-bottom: 2px;
        }

            #tblHP tr, td a {
                color: #333;
            }

        .highlightRow {
            background-color: yellow;
        }

        .link_save {
            margin-left: 0px;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
                <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />

                <%-- region Thêm hình phạt --%>
                <asp:HiddenField ID="hddCurrToiDanhID" runat="server" Value="0" />
                <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />

                <%-- endregion Thêm hình phạt --%>

                <asp:HiddenField ID="hddID" runat="server" Value="0" />
                <asp:HiddenField ID="hddBiCanDauVuID" runat="server" Value="0" />
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <asp:HiddenField ID="hddShowCommand" Value="True" runat="server" />
                <div id="zone_message"></div>
                <!----------------------------------------->
                <div style="margin: 5px; text-align: center; width: 95%; position: absolute; top: 10px;">
                    <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput"
                        Text="Lưu và thoát" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                    <asp:Button ID="cmdUpdateAndNext2" runat="server" CssClass="buttoninput"
                        Text="Lưu và nhập tiếp" OnClick="cmdUpdateAndNext_Click" OnClientClick="return validate();" />
                    <input type="button" class="buttoninput" onclick="ClosePopup()" value="Thoát" />
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                    </div>
                </div>
                <div style="display: none">
                    <asp:Button ID="cmdLoadDsToiDanh" runat="server"
                        Text="Load ds toidanh" OnClick="cmdLoadDsToiDanh_Click" />
                </div>
                <div class="box">


                    <div class="box_nd">
                        <div class="boxchung">
                            <h4 class="tleboxchung">1. Thông tin bị cáo</h4>
                            <div class="boder">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Đối tượng phạm tội</td>
                                        <td style="width: 250px;">

                                            <asp:DropDownList ID="dropDoiTuongPhamToi"
                                                CssClass="chosen-select" runat="server" Width="250">
                                                <asp:ListItem Value="0" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Pháp nhân thương mại"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Pháp nhân phi thương mại"></asp:ListItem>
                                            </asp:DropDownList></td>
                                        <td style="width: 110px;">Bị cáo đầu vụ</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdBiCanDauVu" runat="server"
                                                RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Selected="True">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                    </tr>
                                    <tr>
                                        <td>Tên bị cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                        </td>
                                        <td>Ngày sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtNgaysinh" runat="server" CssClass="user" Width="100px"
                                                onkeypress="return isNumber(event)"
                                                AutoPostBack="true" OnTextChanged="txtNgaysinh_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            Năm sinh <span class="batbuoc">(*)</span>
                                            <asp:TextBox ID="txtNamSinh" runat="server" CssClass="user align_right"
                                                AutoPostBack="true" OnTextChanged="txtNamSinh_TextChanged"
                                                onkeypress="return isNumber(event)"
                                                Width="52px" MaxLength="4"></asp:TextBox>
                                        </td>

                                    </tr>

                                    <tr>
                                        <td>Giới tính</td>
                                        <td>
                                            <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select" runat="server"
                                                Width="250px">
                                                <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                            </asp:DropDownList></td>

                                        <td>Quốc tịch<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="dropQuocTich" CssClass="chosen-select"
                                                runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="dropQuocTich_SelectedIndexChanged">
                                            </asp:DropDownList></td>
                                    </tr>

                                    <asp:Panel ID="pnHoKhau" runat="server">
                                        <tr>
                                            <td>Hộ khẩu thường trú<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="ddlHKTT_Tinh" CssClass="chosen-select" runat="server"
                                                    Width="120px"
                                                    AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlHKTT_Tinh_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <div style="float: right;">
                                                    <asp:DropDownList ID="ddlHKTT_Huyen" CssClass="chosen-select float_right"
                                                        runat="server" Width="120px">
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                            <td>Địa chỉ chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtHKTT_Chitiet" CssClass="user"
                                                    runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Nơi sinh sống<span id="zoneTamtru"></span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlTamTru_Tinh" CssClass="chosen-select" runat="server"
                                                Width="120px"
                                                AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlTamTru_Tinh_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            <div style="float: right;">
                                                <asp:DropDownList ID="ddlTamTru_Huyen" CssClass="chosen-select"
                                                    runat="server" Width="120px">
                                                </asp:DropDownList>
                                            </div>
                                        </td>
                                        <td>Địa chỉ chi tiết</td>
                                        <td>
                                            <asp:TextBox ID="txtTamtru_Chitiet" CssClass="user"
                                                runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>CMND/Thẻ căn cước/Hộ chiếu<asp:Literal ID="ltCMNDND" runat="server"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtND_CMND" CssClass="user"
                                                runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                        <td>
                                            <asp:CheckBox ID="chkBoxCMNDND" AutoPostBack="true" runat="server" Text="Không có" OnCheckedChanged="chkBoxCMNDND_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Trẻ vị thành niên<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdTreViThanhNien"
                                                runat="server" RepeatDirection="Horizontal" AutoPostBack="true">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <!-------------------------------------->
                        <div class="boxchung">
                            <h4 class="tleboxchung">2. Nhân thân bị cáo</h4>
                            <div class="boder">

                                <table class="table1">
                                    <tr>
                                        <td style="width: 40px;">Bố
                                            <asp:HiddenField ID="hddNT_Bo" runat="server" />
                                        </td>
                                        <td style="width: 180px;">
                                            <asp:TextBox ID="txtBo_HoTen" CssClass="user"
                                                runat="server" placeholder="Họ tên" Width="170px"></asp:TextBox></td>
                                        <td style="width: 60px;">Năm sinh</td>
                                        <td style="width: 50px;">
                                            <asp:TextBox ID="txtBo_NamSinh" CssClass="user" runat="server"
                                                onkeypress="return isNumber(event)" Width="40px"></asp:TextBox></td>
                                        <td style="width: 45px;">Địa chỉ</td>
                                        <td style="width: 180px;">
                                            <asp:TextBox ID="txtBo_Diachi" CssClass="user" Width="170px"
                                                runat="server" placeholder="Địa chỉ thường trú"></asp:TextBox></td>
                                        <td style="width: 55px;">Ghi chú</td>
                                        <td>
                                            <asp:TextBox ID="txtBo_GhiChu" CssClass="user" runat="server"
                                                Width="150px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>Mẹ
                                            <asp:HiddenField ID="hddNT_Me" runat="server" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtMe_HoTen" CssClass="user" runat="server"
                                                placeholder="Họ tên" Width="170px"></asp:TextBox></td>
                                        <td>Năm sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtMe_NamSinh" CssClass="user" runat="server"
                                                onkeypress="return isNumber(event)" Width="40px"></asp:TextBox></td>
                                        <td>Địa chỉ</td>
                                        <td>
                                            <asp:TextBox ID="txtMe_Diachi" CssClass="user" Width="170px" runat="server" placeholder="Địa chỉ thường trú"></asp:TextBox></td>
                                        <td>Ghi chú</td>
                                        <td>
                                            <asp:TextBox ID="txtMe_GhiChu" CssClass="user" runat="server"
                                                Width="150px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>Vợ/Chồng<asp:HiddenField ID="hddNT_BanDoi" runat="server" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtBanDoi_HoTen" CssClass="user" runat="server"
                                                placeholder="Họ tên" Width="170px"></asp:TextBox></td>
                                        <td>Năm sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtBanDoi_NamSinh" CssClass="user" runat="server" onkeypress="return isNumber(event)" Width="40px"></asp:TextBox></td>
                                        <td>Địa chỉ</td>
                                        <td>
                                            <asp:TextBox ID="txtBanDoi_Diachi" CssClass="user" Width="170px" runat="server" placeholder="Địa chỉ thường trú"></asp:TextBox></td>
                                        <td>Ghi chú</td>
                                        <td>

                                            <asp:TextBox ID="txtBanDoi_GhiChu" CssClass="user" runat="server" Width="150px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>Con
                                            <asp:HiddenField ID="hddNT_Con1" runat="server" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtCon1_HoTen" CssClass="user" runat="server"
                                                placeholder="Họ tên" Width="170px"></asp:TextBox></td>
                                        <td>Năm sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtCon1_NamSinh" CssClass="user" runat="server" onkeypress="return isNumber(event)" Width="40px"></asp:TextBox></td>
                                        <td>Địa chỉ</td>
                                        <td>
                                            <asp:TextBox ID="txtCon1_Diachi" CssClass="user" Width="170px" runat="server" placeholder="Địa chỉ thường trú"></asp:TextBox></td>
                                        <td>Ghi chú</td>
                                        <td>

                                            <asp:TextBox ID="txtCon1_GhiChu" CssClass="user" runat="server" Width="150px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>Con
                                            <asp:HiddenField ID="hddNT_Con2" runat="server" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtCon2_HoTen" CssClass="user" runat="server"
                                                placeholder="Họ tên" Width="170px"></asp:TextBox></td>
                                        <td>Năm sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtCon2_NamSinh" CssClass="user" runat="server" onkeypress="return isNumber(event)" Width="40px"></asp:TextBox></td>
                                        <td>Địa chỉ</td>
                                        <td>
                                            <asp:TextBox ID="txtCon2_Diachi" CssClass="user" Width="170px" runat="server" placeholder="Địa chỉ thường trú"></asp:TextBox></td>
                                        <td>Ghi chú</td>
                                        <td>
                                            <asp:TextBox ID="txtCon2_GhiChu" CssClass="user" runat="server" Width="150px"></asp:TextBox>
                                        </td>
                                    </tr>

                                </table>
                                <div style="float: left; width: 100%;">
                                    <asp:LinkButton ID="lkThemCon" runat="server" OnClick="lkThemCon_Click"
                                        CssClass="buttonpopup them_user">Thêm</asp:LinkButton>
                                    <asp:Literal ID="lttMsgNT" runat="server"></asp:Literal>
                                    <asp:Repeater ID="rptOtherNT" runat="server" OnItemCommand="rptOtherNT_ItemCommand">
                                        <HeaderTemplate>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Họ tên</strong></div>
                                                    </td>
                                                    <td width="70px">
                                                        <div align="center"><strong>Năm sinh</strong></div>
                                                    </td>
                                                    <td width="70px">
                                                        <div align="center"><strong>Mối QH</strong></div>
                                                    </td>
                                                    <td width="70">
                                                        <div align="center"><strong>Thao tác</strong></div>
                                                    </td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div align="center"><%# Container.ItemIndex + 1 %></div>
                                                </td>
                                                <td><%#Eval("HoTen") %></td>
                                                <td><%# (Convert.ToInt32(Eval("NgaySinh_Nam")+"")==0) ? "":Eval("NgaySinh_Nam").ToString() %></td>
                                                <td><%# Eval("TenMoiQuanHe") %></td>
                                                <td>
                                                    <div align="center">
                                                        <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                            CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></table></FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>

                        <!-------------------------------------->
                        <div class="boxchung">
                            <h4 class="tleboxchung">3. Biện pháp ngăn chặn sơ thẩm</h4>
                            <div class="boder">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 135px;">Biện pháp ngăn chặn?<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdNganChan" runat="server"
                                                RepeatDirection="Horizontal"
                                                AutoPostBack="true" OnSelectedIndexChanged="rdNganChan_SelectedIndexChanged">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                    </tr>

                                    <asp:Panel ID="pnBienPhapNganChan" runat="server" Visible="false">
                                        <tr>
                                            <td>Biện pháp ngăn chặn<span class="batbuoc">(*)</span></td>
                                            <td style="width: 230px;">
                                                <asp:DropDownList ID="dropBienPhapNganChan" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList></td>
                                            <td style="width: 110px;">Đơn vị ra quyết định<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="dropDV" CssClass="chosen-select" runat="server"
                                                    Width="240px">
                                                </asp:DropDownList></td>
                                        </tr>

                                        <tr>
                                            <td>Ngày bắt đầu có hiệu lực<span class="batbuoc">(*)</span></td>
                                            <td colspan="4">
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtNgayBatDau" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayBatDau"
                                                        Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBatDau"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                                <div style="float: left; margin-left: 20px; margin-top: 5px;">Thời gian tạm giam</div>
                                                <div style="float: left; margin-left: 8px;">
                                                    <asp:TextBox ID="txtSoNgay" runat="server"
                                                        onkeypress="return isNumber(event)"
                                                        CssClass="user" Width="50px" MaxLength="10"
                                                        AutoPostBack="true" OnTextChanged="txtSoNgay_TextChanged"></asp:TextBox>
                                                    ngày
                                                </div>
                                                <div style="float: left; margin-left: 30px; margin-top: 5px;">Ngày hết hiệu lực hoặc ngày được tha</div>
                                                <div style="float: left; margin-left: 7px;">
                                                    <asp:TextBox ID="txtNgayKT" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayKT"
                                                        Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayKT"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                </table>
                            </div>
                        </div>
                        <div class="boxchung">
                            <h4 class="tleboxchung">3.1 Biện pháp ngăn chặn phúc thẩm</h4>
                            <div class="boder">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 135px;">Biện pháp ngăn chặn?<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdNganChan_pt" runat="server"
                                                RepeatDirection="Horizontal"
                                                AutoPostBack="true" OnSelectedIndexChanged="rdNganChan_pt_SelectedIndexChanged">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                    </tr>

                                    <asp:Panel ID="pnBienPhapNganChan_pt" runat="server" Visible="false">
                                        <tr>
                                            <td>Biện pháp ngăn chặn<span class="batbuoc">(*)</span></td>
                                            <td style="width: 230px;">
                                                <asp:DropDownList ID="dropBienPhapNganChan_pt" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList></td>
                                            <td style="width: 110px;">Đơn vị ra quyết định<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="dropDV_pt" CssClass="chosen-select" runat="server"
                                                    Width="240px">
                                                </asp:DropDownList></td>
                                        </tr>

                                        <tr>
                                            <td>Ngày bắt đầu có hiệu lực<span class="batbuoc">(*)</span></td>
                                            <td colspan="4">
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtNgayBatDau_pt" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBatDau_pt"
                                                        Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBatDau_pt"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                                <div style="float: left; margin-left: 20px; margin-top: 5px;">Thời gian tạm giam</div>
                                                <div style="float: left; margin-left: 8px;">
                                                    <asp:TextBox ID="txtSoNgay_pt" runat="server"
                                                        onkeypress="return isNumber(event)"
                                                        CssClass="user" Width="50px" MaxLength="10"
                                                        AutoPostBack="true" OnTextChanged="txtSoNgay_pt_TextChanged"></asp:TextBox>
                                                    ngày
                                                </div>
                                                <div style="float: left; margin-left: 30px; margin-top: 5px;">Ngày hết hiệu lực hoặc ngày được tha</div>
                                                <div style="float: left; margin-left: 7px;">
                                                    <asp:TextBox ID="txtNgayKT_pt" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayKT_pt"
                                                        Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayKT_pt"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                </table>
                            </div>
                        </div>
                        <!-------------------------------------->
                        <asp:Panel ID="pnToiDanh" runat="server">
                            <div class="boxchung">
                                <h4 class="tleboxchung">4. Điều luật áp dụng cho bị cáo</h4>
                                <div class="boder">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 70px;"><b>Bộ luật</b><span class="batbuoc">(*)</span></td>
                                            <td>
                                                <div style="float: left; margin-right: 5px;">
                                                    <asp:DropDownList ID="dropBoLuat" runat="server" CssClass="chosen-select" Width="315px" Height="31px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropBoLuat_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                                <asp:LinkButton ID="lkChoiceToiDanh" runat="server"
                                                    OnClientClick="return validate_bican();" OnClick="lkChoiceToiDanh_Click"
                                                    CssClass="link_choice">Chọn điều luật</asp:LinkButton>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Điểm</b></td>
                                            <td>
                                                <span style="float: left; margin-right: 10PX;">
                                                    <asp:TextBox ID="txtDiem" runat="server" CssClass="user" Width="60px"></asp:TextBox>

                                                    <!----------->
                                                    <b style="width: 50px;">Khoản</b><span class="batbuoc">(*)</span>
                                                    <asp:TextBox ID="txtKhoan" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                                    <!----------->
                                                    <b style="width: 50px;">Điều<span class="batbuoc">(*)</span></b>
                                                    <asp:TextBox ID="txtDieu" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                                </span>
                                                <!----------->
                                                <asp:Button ID="cmdThemDieuLuat" runat="server" CssClass="buttonpopup link_save"
                                                    Text="Lưu điều luật" OnClick="cmdThemDieuLuat_Click"
                                                    OnClientClick="return validate_themtoidanh();" Width="128px" />

                                                <asp:Button ID="cmdGetToiDanhDauVu" runat="server" Visible="false"
                                                    CssClass="buttonpopup link_save"
                                                    Text="Áp dụng tội danh của bị cáo đầu vụ"
                                                    OnClick="cmdGetToiDanhDauVu_Click"
                                                    OnClientClick="return validate_bican();" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td colspan="2">
                                                <div>
                                                    <asp:HiddenField ID="hddToiDanh" runat="server" Value="0" />
                                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                                </div>
                                                <asp:Panel runat="server" ID="pndata" Visible="false">
                                                    <div class="phantrang">
                                                        <div class="sobanghi">
                                                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                                        </div>
                                                        <div class="sotrang">
                                                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                                        </div>
                                                    </div>
                                                    <asp:HiddenField ID="hddOld" runat="server" Value="" />
                                                    <asp:Repeater ID="rpt" runat="server"
                                                        OnItemDataBound="rpt_ItemDataBound" OnItemCommand="rpt_ItemCommand">
                                                        <HeaderTemplate>
                                                            <table class="table2" width="100%" border="1">
                                                                <tr class="header">
                                                                    <td width="42">
                                                                        <div align="center"><strong>STT</strong></div>
                                                                    </td>
                                                                    <td width="150px">
                                                                        <div align="center"><strong>Bộ luật</strong></div>
                                                                    </td>
                                                                    <td width="50px">
                                                                        <div align="center"><strong>Điều</strong></div>
                                                                    </td>
                                                                    <td width="50px">
                                                                        <div align="center"><strong>Khoản</strong></div>
                                                                    </td>

                                                                    <td width="50px">
                                                                        <div align="center"><strong>Điểm</strong></div>
                                                                    </td>
                                                                    <td>
                                                                        <div align="center"><strong>Tội danh</strong></div>
                                                                    </td>
                                                                    <td width="60px">
                                                                        <div align="center"><strong>Thao tác</strong></div>
                                                                    </td>
                                                                </tr>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td>
                                                                    <div style="float: left; width: 100%; text-align: center;">
                                                                        <asp:LinkButton ID="lk" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("STT") %>'></asp:LinkButton>
                                                                        <asp:Image ID="Image" ImageUrl="../../../../../UI/img/check.png" runat="server" Visible="false" />
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%#Eval("TenBoLuat") %>'></asp:LinkButton></td>
                                                                <td>
                                                                    <asp:LinkButton ID="LinkButton4" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("Dieu") %>'></asp:LinkButton></td>
                                                                <td>
                                                                    <asp:LinkButton ID="LinkButton3" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("Khoan") %>'></asp:LinkButton></td>
                                                                <td>
                                                                    <asp:LinkButton ID="LinkButton2" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("Diem") %>'></asp:LinkButton></td>
                                                                <td>
                                                                    <asp:HiddenField ID="hddArrSapXep" runat="server" Value='<%#Eval("ArrSapXep") %>' />
                                                                    <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("Loai") %>' />
                                                                    <asp:HiddenField ID="hddToiDanhID" runat="server" Value='<%#Eval("ToiDanhID") %>' />
                                                                    <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID") %>' />
                                                                    <asp:HiddenField ID="hddLoaiToiPham" runat="server" Value='<%#Eval("LoaiToiPham") %>' />

                                                                    <asp:Literal ID="lttChiTiet" runat="server"></asp:Literal>

                                                                    <asp:TextBox ID="txtTenToiDanh" CssClass="user" Width="98%"
                                                                        Font-Bold="true" runat="server" Text='<%#Eval("TENTOIDANH") %>'
                                                                        Visible='<%# Convert.ToInt16( Eval("IsEdit")+"")==1?true:false  %>'></asp:TextBox>
                                                                    <div style='display: <%# Convert.ToInt16( Eval("IsEdit")+"")==1? "none":"block"  %>'>
                                                                        <%#Eval("TENTOIDANH") %>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:LinkButton ID="lkXoa" runat="server" Text="Xóa"
                                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"
                                                                            CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="xoa"></asp:LinkButton>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate></table></FooterTemplate>
                                                    </asp:Repeater>
                                                    <div class="phantrang">
                                                        <div class="sobanghi">
                                                            <asp:HiddenField ID="hdicha" runat="server" />
                                                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                                        </div>
                                                        <div class="sotrang">
                                                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                                <asp:Panel ID="pnHinhPhat" runat="server" Visible="false">
                                                    <b class="title_hp">
                                                        <asp:Literal ID="lttToiDanh" runat="server"></asp:Literal></b>

                                                    <div style="float: left; width: 100%; text-align: center;">
                                                        <asp:Button ID="cmdSaveHinhPhat" runat="server" CssClass="buttoninput"
                                                            Text="Lưu hình phạt" OnClick="cmdSaveHinhPhat_Click" />
                                                    </div>
                                                    <div style="margin: 5px; text-align: center; width: 60%; color: red; float: right;">
                                                        <asp:Literal ID="lblThongBaoHP" runat="server"></asp:Literal>
                                                    </div>
                                                    <!------------------------------------------>
                                                    <asp:HiddenField ID="hddHinhPhatChange" runat="server" Value="0" />
                                                    <asp:HiddenField ID="hddGroupChange" runat="server" Value="0" />
                                                    <div class="boxchung">
                                                        <h4 class="tleboxchung bg_title_group bg_green">
                                                            <asp:Literal ID="lttNhomHPChinh" runat="server"></asp:Literal></h4>
                                                        <div class="boder" style="padding: 20px 10px;">
                                                            <asp:Repeater ID="rptHPChinh" runat="server"
                                                                OnItemDataBound="rptHP_ItemDataBound">
                                                                <HeaderTemplate>
                                                                    <table style="width: 100%;" id="tblHP">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td style="width: 35%;"><%# Eval("TenHinhPhat") %></td>
                                                                        <td style="width: 50px;">
                                                                            <div style="float: left; width: 100%; text-align: center;">
                                                                                <asp:CheckBox ID="chk" ToolTip='<%#Eval("ID") %>' runat="server" AutoPostBack="true" />
                                                                            </div>
                                                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("ID") %>' />
                                                                        </td>
                                                                        <td>
                                                                            <asp:Panel ID="pnZoneHinhPhat" runat="server" Enabled="false">
                                                                                <asp:RadioButtonList ID="rdDefaultTrue" runat="server"
                                                                                    RepeatDirection="Horizontal" Visible="false">
                                                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                                                </asp:RadioButtonList>
                                                                                <!-------------------------->
                                                                                <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                                                    RepeatDirection="Horizontal" Visible="false">
                                                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                                                </asp:RadioButtonList>
                                                                                <!-------------------------->
                                                                                <asp:TextBox ID="txtSohoc" CssClass="user align_right" Width="100px"
                                                                                    runat="server" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>
                                                                                <!-------------------------->
                                                                                <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                                                    <asp:TextBox ID="txtNam" CssClass="user align_right" Width="40px" runat="server"
                                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                    <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                                                    <asp:TextBox ID="txtThang" CssClass="user align_right" Width="40px" runat="server"
                                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                    <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                                                    <asp:TextBox ID="txtNgay" CssClass="user align_right" Width="40px" runat="server"
                                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                    <span class='span_date'>ngày</span>
                                                                                </asp:Panel>
                                                                                <!-------------------------->
                                                                                <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                                                    <asp:TextBox ID="txtKhac1" CssClass="user align_right" Width="100px" runat="server"
                                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                    hoặc
                                                                                <asp:TextBox ID="txtKhac2" runat="server" CssClass="user"
                                                                                    Width="100px" Text=""></asp:TextBox>
                                                                                </asp:Panel>

                                                                                <!-------------------------->
                                                                                <asp:CheckBox ID="chkAnTreo" runat="server" AutoPostBack="true"
                                                                                    Text="Hưởng án treo" CssClass="margin_top" /><br />

                                                                                <asp:Panel ID="pnThoiGianThuThach" runat="server" Visible="false">
                                                                                    <div style="float: left; width: 95%">
                                                                                        <span>Thử thách: </span>
                                                                                        <asp:TextBox ID="txtTGTT_Nam" CssClass="user align_right" Width="40px" runat="server"
                                                                                            Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                        <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                                                        <asp:TextBox ID="txtTGTT_Thang" CssClass="user align_right" Width="40px" runat="server"
                                                                                            Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                        <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                                                        <asp:TextBox ID="txtTGTT_Ngay" CssClass="user align_right" Width="40px" runat="server"
                                                                                            Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                        <span class='span_date'>ngày</span>
                                                                                    </div>
                                                                                </asp:Panel>
                                                                            </asp:Panel>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                                <FooterTemplate></table></FooterTemplate>
                                                            </asp:Repeater>
                                                        </div>
                                                    </div>
                                                    <!---------------------------------------->
                                                    <div class="boxchung">
                                                        <h4 class="tleboxchung bg_title_group bg_green">
                                                            <asp:Literal ID="lttNhomHPBoSung" runat="server"></asp:Literal></h4>
                                                        <div class="boder" style="padding: 20px 10px;">
                                                            <asp:Repeater ID="rptHPBoSung" runat="server"
                                                                OnItemDataBound="rptHPBoSung_ItemDataBound">
                                                                <HeaderTemplate>
                                                                    <table style="width: 100%;" id="tblHPBoSung">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td style="width: 35%;"><%# Eval("TenHinhPhat") %></td>
                                                                        <td style="width: 50px;">
                                                                            <div style="float: left; width: 100%; text-align: center;">
                                                                                <asp:CheckBox ID="chk" ToolTip='<%#Eval("ID") %>' runat="server" Visible="false" />
                                                                            </div>
                                                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("ID") %>' />
                                                                        </td>
                                                                        <td>

                                                                            <asp:CheckBox ID="chkDefaultTrue" runat="server" Visible="false" />
                                                                            <asp:CheckBox ID="chkTrueFalse" runat="server" Visible="false" />
                                                                            <asp:TextBox ID="txtSohoc" CssClass="user align_right" Width="100px"
                                                                                runat="server" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>

                                                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                                                <asp:TextBox ID="txtNam" CssClass="user align_right" Width="40px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                <span class='span_date'>năm&nbsp;&nbsp;</span>

                                                                                <asp:TextBox ID="txtThang" CssClass="user align_right" Width="40px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                <span class='span_date'>tháng&nbsp;&nbsp;</span>

                                                                                <asp:TextBox ID="txtNgay" CssClass="user align_right" Width="40px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                <span class='span_date'>ngày</span>
                                                                            </asp:Panel>

                                                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                                                <asp:TextBox ID="txtKhac1" CssClass="user align_right" Width="100px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                hoặc
                                                                                <asp:TextBox ID="txtKhac2" runat="server" CssClass="user" Width="100px" Text=""></asp:TextBox>
                                                                            </asp:Panel>

                                                                            <asp:CheckBox ID="chkAnTreo" runat="server" Text="Hưởng án treo" CssClass="margin_top" />
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                                <FooterTemplate></table></FooterTemplate>
                                                            </asp:Repeater>
                                                        </div>
                                                    </div>
                                                    <!------------------------------------------->
                                                    <div class="boxchung">
                                                        <h4 class="tleboxchung bg_title_group bg_green">
                                                            <asp:Literal ID="lttNhomQDKhac" runat="server"></asp:Literal></h4>
                                                        <div class="boder" style="padding: 20px 10px;">
                                                            <asp:Repeater ID="rptQDKhac" runat="server" OnItemDataBound="rptHP_ItemDataBound">
                                                                <HeaderTemplate>
                                                                    <table style="width: 100%;" id="tblQuyetDinhKhac">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>

                                                                        <td style="width: 35%;"><%# Eval("TenHinhPhat") %></td>
                                                                        <td style="width: 50px;">
                                                                            <div style="float: left; width: 100%; text-align: center;">
                                                                                <asp:CheckBox ID="chk" ToolTip='<%#Eval("ID") %>' runat="server" AutoPostBack="true" />
                                                                            </div>
                                                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("ID") %>' />
                                                                        </td>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="rdDefaultTrue" runat="server"
                                                                                RepeatDirection="Horizontal" Visible="false">
                                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                            <!-------------------------->
                                                                            <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                                                RepeatDirection="Horizontal" Visible="false">
                                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                            <!-------------------------->
                                                                            <asp:TextBox ID="txtSohoc" CssClass="user align_right" Width="100px"
                                                                                runat="server" onkeypress="return isNumber(event)" Visible="false">
                                                                            </asp:TextBox>
                                                                            <!-------------------------->
                                                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                                                <asp:TextBox ID="txtNam" CssClass="user align_right" Width="40px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                                                <asp:TextBox ID="txtThang" CssClass="user align_right" Width="40px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                                                <asp:TextBox ID="txtNgay" CssClass="user align_right" Width="40px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                <span class='span_date'>ngày</span>
                                                                            </asp:Panel>
                                                                            <!-------------------------->
                                                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                                                <asp:TextBox ID="txtKhac1" CssClass="user align_right" Width="100px" runat="server"
                                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                                hoặc
                                                                                <asp:TextBox ID="txtKhac2" runat="server" CssClass="user"
                                                                                    Width="100px" Text=""></asp:TextBox>
                                                                            </asp:Panel>
                                                                            <!-------------------------->

                                                                            <asp:CheckBox ID="chkAnTreo" runat="server" Text="Hưởng án treo" CssClass="margin_top" />
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                                <FooterTemplate></table></FooterTemplate>
                                                            </asp:Repeater>
                                                        </div>
                                                    </div>
                                                    <!------------------------------------------>
                                                    <div style="float: left; width: 100%; text-align: center;">
                                                        <asp:Button ID="cmdSaveHinhPhat2" runat="server" CssClass="buttoninput"
                                                            Text="Lưu hình phạt" OnClick="cmdSaveHinhPhat_Click" />
                                                    </div>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </asp:Panel>

                    </div>
                    <div style="float: left; width: 100%; margin-bottom: 100px;">
                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                            <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                        </div>

                    </div>
                </div>
                <div style="display: none; margin: 5px; text-align: center; width: 95%; float: left; position: absolute; bottom: 10px; margin-bottom: 100px;">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                        Text="Lưu và thoát" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                    <asp:Button ID="cmdUpdateAndNext" runat="server" CssClass="buttoninput"
                        Text="Lưu và nhập tiếp" OnClick="cmdUpdateAndNext_Click" OnClientClick="return validate();" />
                    <input type="button" class="buttoninput" onclick="window.close();" value="Thoát" />
                </div>

                <script>
                    function OpenPopup(pageURL, title, w, h) {
                        var left = (screen.width / 2) - (w / 2);
                        var top = (screen.height / 2) - (h / 2);
                        var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                        return targetWin;
                    }

                    function ChangeHP(hinhphatid, grouphp) {
                        // alert(hinhphatid +", "+ grouphp);
                        var hddGroupChange = document.getElementById('<%=hddGroupChange.ClientID%>');
                        var hdd = document.getElementById('<%=hddHinhPhatChange.ClientID%>');
                        var hdd_value = hdd.value;
                        if (hdd_value == hinhphatid) {
                            hdd.value = "0";
                            hddGroupChange.value = "0";
                        }
                        else {
                            hdd.value = hinhphatid;
                            hddGroupChange.value = grouphp;
                        }
                        //alert(hdd.value);
                    }
                </script>

            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
    <script>
        function PopupCenter(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function popupChonToiDanh(VuAnID, bi_cao) {
            if (!validate_bican())
                return false;
            else {
                //-----------------------
                var width = 950;
                var height = 750;
                var hddID = document.getElementById('<%=hddID.ClientID%>');
                var bi_cao = hddID.value;
                var link = "/QLAN/AHS/TaoHS/popup/pChonToiDanh.aspx?hsID=" + VuAnID + "&bID=" + bi_cao;
                PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
            }
            return true;
        }

        function popup_edit_nhanthan(VuAnID, BiCanID) {
            var link = "";
            link = "/QLAN/AHS/TaoHS/popup/pNhanThan.aspx?type=CON&hsID=" + VuAnID + "&bID=" + BiCanID;
            var width = 650;
            var height = 450;
            PopupCenter(link, "Cập nhật thông tin nhân thân của bị cáo", width, height);
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>

    <script>

</script>

    <script>
        function validate() {
            if (!validate_bican())
                return false;

            if (!validate_nhanthan())
                return false;

            if (!validate_bienphapnc())
                return false;
            //alert(1);
            return true;
        }

        function validate_bican() {
            var msg = "";
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên bị cáo. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            //------------------------------
            var txtNgaysinh = document.getElementById('<%=txtNgaysinh.ClientID%>');

            if (Common_CheckEmpty(txtNgaysinh.value)) {
                var ngaysinh = txtNgaysinh.value;
                if (!CheckDateTimeControl(txtNgaysinh, 'Ngày sinh của bị cáo'))
                    return false;
                //-------------------------------

            }
            var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
            if (!Common_CheckEmpty(txtNamSinh.value)) {
                alert('Bạn chưa nhập năm sinh của bị cáo. Hãy kiểm tra lại!');
                txtNamSinh.focus();
                return false;
            }
            var rdTreViThanhNien = document.getElementById('<%=rdTreViThanhNien.ClientID%>');
            msg = 'Mục "Trẻ vị thành niên" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreViThanhNien, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdTreViThanhNien);
                if (selected_value == 1) {
                    if (!validate_trevithanhnien())
                        return false;
                }
            }
            //-----------------------------
            if (!validate_quoctich())
                return false;
            //----------------------------

            return true;
        }
        function validate_trevithanhnien() {

            return true;
        }

        function validate_bienphapnc() {
            var rdNganChan = document.getElementById('<%=rdNganChan.ClientID%>');
            msg = 'Mục "Biện pháp ngăn chặn" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdNganChan, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdNganChan);
                //alert(selected_value);
                if (selected_value == 1) {
                    var bienphapvalue = document.getElementById('<%=dropBienPhapNganChan.ClientID%>');
                    if (bienphapvalue.value == 0) {
                        alert("Bạn chưa chọn biện pháp ngăn chặn!");
                        return false;
                    }
                    var donvibpncvalue = document.getElementById('<%=dropDV.ClientID%>');
                    if (donvibpncvalue.value == 0) {
                        alert("Bạn chưa chọn đơn vị ra quyết định ngăn chặn!");
                        return false;
                    }
                    var txtNgayBatDau = document.getElementById('<%=txtNgayBatDau.ClientID%>');
                    if (!Common_CheckEmpty(txtNgayBatDau.value)) {
                        alert('Bạn chưa nhập ngày bắt đầu có hiệu lực. Hãy kiểm tra lại!');
                        txtNgayBatDau.focus();
                        return false;
                    }
                    if (!Common_IsTrueDate(txtNgayBatDau.value))
                        return false;
                    //----------------------
                    var txtNgayKT = document.getElementById('<%=txtNgayKT.ClientID%>');
                    if (Common_CheckEmpty(txtNgayKT.value)) {
                        var ngaybatdau = txtNgayBatDau.value;
                        if (!SoSanh2Date(txtNgayKT, 'Ngày hết hiệu lực hoặc ngày được tha', ngaybatdau, 'Ngày bắt đầu có hiệu lực'))
                            return false;
                    }
                }
            }
            return true;
        }
        function validate_quoctich() {
            var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
            var value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn mục "quốc tịch". Hãy kiểm tra lại!');
                dropQuocTich.focus();
                return false;
            }
            //-----------------------------------------
            var QuocTichVN = '<%=QuocTichVN%>';
            var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
            value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;

            if (value_change == QuocTichVN) {
                document.getElementById('zoneTamtru').innerHTML = "<span class='batbuoc'>(*)</span>";

                //--------check nhap ho khau thuong tru---------
                var ddlHKTT_Tinh = document.getElementById('<%=ddlHKTT_Tinh.ClientID%>');
                var ddlHKTT_Huyen = document.getElementById('<%=ddlHKTT_Huyen.ClientID%>');

                value_change = ddlHKTT_Tinh.options[ddlHKTT_Tinh.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn mục "Tỉnh/TP của hộ khẩu thường trú". Hãy kiểm tra lại!');
                    ddlHKTT_Tinh.focus();
                    return false;
                }
                //value_change = ddlHKTT_Huyen.options[ddlHKTT_Huyen.selectedIndex].value;
                //if (value_change == "0") {
                //    alert('Bạn chưa chọn mục "Quận/Huyện của hộ khẩu thường trú". Hãy kiểm tra lại!');
                //    ddlHKTT_Huyen.focus();
                //    return false;
                //}

                //--------check nhap ho khau tam tru---------
                var ddlTamTru_Tinh = document.getElementById('<%=ddlTamTru_Tinh.ClientID%>');
                var ddlTamTru_Huyen = document.getElementById('<%=ddlTamTru_Huyen.ClientID%>');
                value_change = ddlTamTru_Tinh.options[ddlTamTru_Tinh.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn mục "Nơi sinh sống". Hãy kiểm tra lại!');
                    ddlTamTru_Tinh.focus();
                    return false;
                }
                //value_change = ddlTamTru_Huyen.options[ddlTamTru_Huyen.selectedIndex].value;
                //if (value_change == "0") {
                //    alert('Bạn chưa chọn mục "Quận/Huyện của nơi Tạm trú". Hãy kiểm tra lại!');
                //    ddlTamTru_Huyen.focus();
                //    return false;
                //}
            }
            else
                document.getElementById('zoneTamtru').innerHTML = "";
            return true;
        }
        //-----------------------------------------
        function validate_nhanthan() {
            var hoten = "";
            var namsinh_length = 0;
            var txtNamSinh_BiCan = document.getElementById('<%=txtNamSinh.ClientID%>');
            var namsinh_bican = parseInt(txtNamSinh_BiCan.value);

            var namsinh = 0;
            //----------bo----------------------
            var txtBo_HoTen = document.getElementById('<%=txtBo_HoTen.ClientID%>');
            if (Common_CheckEmpty(txtBo_HoTen.value)) {
                hoten = txtBo_HoTen.value;
                if (hoten.length > 250) {
                    alert('Họ tên cần nhập ít hơn 250 ký tự. Hãy kiểm tra lại!');
                    txtBo_HoTen.focus();
                    return false;
                }
                //-----------------------------    
                var txtBo_NamSinh = document.getElementById('<%=txtBo_NamSinh.ClientID%>');

                if (Common_CheckEmpty(txtBo_NamSinh.value)) {
                    namsinh = parseInt(txtBo_NamSinh.value);
                    if (namsinh > namsinh_bican) {
                        alert('Năm sinh của bố bị cáo phải nhỏ hơn năm sinh của bị cáo. Hãy kiểm tra lại!');
                        txtBo_NamSinh.focus();
                        return false;
                    }
                }
            }

            //----------Me-------------------
            var txtMe_HoTen = document.getElementById('<%=txtMe_HoTen.ClientID%>');
            if (Common_CheckEmpty(txtMe_HoTen.value)) {
                hoten = txtMe_HoTen.value;
                if (hoten.length > 250) {
                    alert('Họ tên cần nhập ít hơn 250 ký tự. Hãy kiểm tra lại!');
                    txtMe_HoTen.focus();
                    return false;
                }
                //-----------------------------    
                var txtMe_NamSinh = document.getElementById('<%=txtMe_NamSinh.ClientID%>');
                if (Common_CheckEmpty(txtMe_NamSinh.value)) {
                    namsinh = parseInt(txtMe_NamSinh.value);
                    if (namsinh > namsinh_bican) {
                        alert('Năm sinh của mẹ bị cáo phải nhỏ hơn năm sinh của bị cáo. Hãy kiểm tra lại!');
                        txtMe_NamSinh.focus();
                        return false;
                    }
                }
            }

            //----------Vo/Chong-----------------
            var txtBanDoi_HoTen = document.getElementById('<%=txtBanDoi_HoTen.ClientID%>');
            if (Common_CheckEmpty(txtBanDoi_HoTen.value)) {
                hoten = txtBanDoi_HoTen.value;
                if (hoten.length > 250) {
                    alert('Họ tên cần nhập ít hơn 250 ký tự. Hãy kiểm tra lại!');
                    txtBanDoi_HoTen.focus();
                    return false;
                }
                //-----------------------------    
                var txtBanDoi_NamSinh = document.getElementById('<%=txtBanDoi_NamSinh.ClientID%>');
                if (Common_CheckEmpty(txtBanDoi_NamSinh.value)) {
                    var namsinh = parseInt(txtBanDoi_NamSinh.value);
                    if (namsinh > CurrentYear) {
                        alert('Năm sinh phải nhỏ hơn hoặc bằng năm hiện tại. Hãy kiểm tra lại!');
                        txtBanDoi_NamSinh.focus();
                        return false;
                    }
                }
            }
            //-----------Con1--------------------
            var txtCon1_HoTen = document.getElementById('<%=txtCon1_HoTen.ClientID%>');
            if (Common_CheckEmpty(txtCon1_HoTen.value)) {
                hoten = txtCon1_HoTen.value;
                if (hoten.length > 250) {
                    alert('Họ tên cần nhập ít hơn 250 ký tự. Hãy kiểm tra lại!');
                    txtCon1_HoTen.focus();
                    return false;
                }
                //-----------------------------    
                var txtCon1_NamSinh = document.getElementById('<%=txtCon1_NamSinh.ClientID%>');
                if (Common_CheckEmpty(txtCon1_NamSinh.value)) {
                    var namsinh = parseInt(txtCon1_NamSinh.value);
                    if (namsinh < namsinh_bican) {
                        alert('Năm sinh của con bị cáo phải lớn hơn năm sinh của bị cáo. Hãy kiểm tra lại!');
                        txtCon1_NamSinh.focus();
                        return false;
                    }
                }
            }
            //---------con 2--------------------
            var txtCon2_HoTen = document.getElementById('<%=txtCon2_HoTen.ClientID%>');
            if (Common_CheckEmpty(txtCon2_HoTen.value)) {
                hoten = txtCon2_HoTen.value;
                if (hoten.length > 250) {
                    alert('Họ tên cần nhập ít hơn 250 ký tự. Hãy kiểm tra lại!');
                    txtCon2_HoTen.focus();
                    return false;
                }
                //-----------------------------    
                var txtCon2_NamSinh = document.getElementById('<%=txtCon2_NamSinh.ClientID%>');
                if (!Common_CheckEmpty(txtCon2_NamSinh.value)) {
                    var namsinh = parseInt(txtCon2_NamSinh.value);
                    if (namsinh < namsinh_bican) {
                        alert('Năm sinh của con bị cáo phải lớn hơn năm sinh của bị cáo. Hãy kiểm tra lại!');
                        txtCon2_NamSinh.focus();
                        return false;
                    }
                }
            }
            //---------------------------
            return true;
        }

        //-----------------------------------------
        function validate_themtoidanh() {
            if (!validate_bican())
                return false;
            if (!validate_bienphapnc())
                return false;
            //-------------------------------------
            var dropBoLuat = document.getElementById('<%=dropBoLuat.ClientID%>');
            value_change = dropBoLuat.options[dropBoLuat.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn bộ luật. Hãy kiểm tra lại!');
                dropBoLuat.focus();
                return false;
            }
            var txtKhoan = document.getElementById('<%=txtKhoan.ClientID%>');
            if (!Common_CheckEmpty(txtKhoan.value)) {
                alert('Bạn chưa nhập mục "Khoản". Hãy kiểm tra lại!');
                txtKhoan.focus();
                return false;
            }
            var txtDieu = document.getElementById('<%=txtDieu.ClientID%>');
            if (!Common_CheckEmpty(txtDieu.value)) {
                alert('Bạn chưa nhập mục "Điều". Hãy kiểm tra lại!');
                txtDieu.focus();
                return false;
            }
            return true;
        }
        function validate_rd_vithanhnien() {

            return true;
        }
    </script>
    <%-- <script>

        function hide_zone_message() {
            var today = new Date();
            var zone = document.getElementById('zone_message');
            if (zone.style.display != "") {
                zone.style.display = "none";
                zone.innerText = "";
            }
            var t = setTimeout(hide_zone_message, 5000);
        }
        hide_zone_message();
    </script>--%>
    <script>
        function ClosePopup() {
            var hddIsReloadParent = document.getElementById('<%=hddIsReloadParent.ClientID%>');
            var value = parseInt(hddIsReloadParent.value);
            if (value == 0)
                window.close();
            else
                ReloadParent();
        }
        function ReloadParent() {
            window.onunload = function (e) {
                opener.LoadDsBiCan();
            };
            window.close();
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function LoadDsToiDanh() {
            $("#<%= cmdLoadDsToiDanh.ClientID %>").click();
        }

    </script>
</body>
</html>
