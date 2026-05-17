<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongtinXetXu.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.ThongtinXetXu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <link rel="stylesheet" type="text/css" href="../../../UI/js/src_duallistbox/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="../../../UI/js/src_duallistbox/prettify.min.css">
    <link rel="stylesheet" type="text/css" href="../../../UI/js/src_duallistbox/bootstrap-duallistbox.css" />
    <script src="../../../UI/js/src_duallistbox/jquery-3.2.1.slim.min.js"></script>
    <script src="../../../UI/js/src_duallistbox/popper.min.js"></script>
    <script src="../../../UI/js/src_duallistbox/bootstrap.min.js"></script>
    <script src="../../../UI/js/src_duallistbox/run_prettify.js"></script>
    <script src="../../../UI/js/src_duallistbox/jquery.bootstrap-duallistbox.js"></script>

    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddXetXuID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowHoSoVKS" runat="server" Value="0" />
    <asp:HiddenField ID="hddGUID" runat="server" Value="" />
    <asp:HiddenField ID="hddLoaiAn" runat="server" Value="0" />
    <asp:HiddenField ID="hddNext" runat="server" Value="0" />
    <asp:HiddenField ID="hdd_thamphan" runat="server" Value="" />
    <asp:HiddenField ID="hdd_thamphan_name" runat="server" Value="" />
    <asp:HiddenField ID="hdd_quahanluatdinh" runat="server" Value="-1" />
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .col1 {
            width: 142px;
            font-weight: bold;
        }

        .col2 {
            width: 250px;
        }

        .col3 {
            width: 115px;
            font-weight: bold;
        }
        /*#thongtinvuan .table2 tr td:nth-child(2),#thongtinvuan .table2 tr td:nth-child(4)
        {
            font-weight:bold;
        }*/
        /*#thongtinvuan .table_info_va tr td:nth-child(1), #thongtinvuan .table_info_va tr td:nth-child(3) {
            font-weight: bold;
        }*/

        .title_form {
            float: left;
            margin-bottom: 15px;
            width: 100%;
            position: relative;
            text-transform: uppercase;
            font-weight: bold;
            text-align: center;
        }

        .button_themtt {
            min-width: 80px;
            height: 30px;
            font-weight: bold;
            color: #631313;
            background: url("../img/bg_danhsach.png");
            padding-left: 15px;
            padding-right: 15px;
            cursor: pointer;
            border: solid 1px #9e9e9e;
            border-radius: 3px 3px 3px 3px;
            float: left;
            z-index: 1000;
        }

        .table_tt {
            border: none;
            border-collapse: collapse;
            margin: 5px 0;
            width: 100%;
        }

            .table_tt td {
                padding: 5px;
                border: none;
                line-height: 17px;
                text-align: left;
                vertical-align: middle;
            }

        .list_tt {
            margin-left: 16px;
        }

        .bootstrap-duallistbox-container label {
            display: block;
            font-size: 13px;
            font-weight: bold;
        }

        .menubutton {
            color: #ffffff !important;
        }

            .menubutton:hover {
                color: #780707 !important;
                text-decoration: none !important;
            }

        a:hover {
            color: #9e2702;
            text-decoration: none;
        }

        h4, h4 {
            font-size: unset;
        }

        .h1, .h2, .h3, .h4, .h5, .h6, h1, h2, h3, h4, h5, h6 {
            font-weight: bold;
        }

        input.user {
            height: 25px;
        }

        .btn-outline-secondary:hover {
            background-color: #f0baba;
            border-color: #d28c8c;
        }

        .dxsplPane, .dxsplPaneCollapsed {
            box-sizing: unset;
        }

        .row {
            box-sizing: border-box;
        }
       .table2 .tooltip {
            color: #006080;
            display: inline-block;
            position: relative;
            opacity:unset;
        }
       .buttonprintdisable {
        height: 30px;
        font-weight: bold;
        font-size: 11.7px;
        min-width: 80px;
        padding-left: 15px;
        padding-right: 15px;
        cursor: pointer;
        border: solid 1px  #9e9e9e;
        border-radius: 3px 3px 3px 3px;
    }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <!-------------------------------------------------->
                    <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                            <table class="table_info_va">
                                <tr>
                                    <td style="width: 110px;">Vụ án:</td>
                                    <td colspan="5" style="vertical-align: top;"><b>
                                        <asp:Literal ID="lttVuAn" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số thụ lý:</td>
                                    <td style="width: 250px;"><b>
                                        <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                    <td style="width: 110px">Ngày thụ lý:</td>
                                    <td colspan="3"><b>
                                        <asp:Literal ID="txtVuAn_NgayThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số BA/QĐ:</td>
                                    <td><b>
                                        <asp:Literal ID="txtVuAn_SoBanAn" runat="server"></asp:Literal></b>
                                    </td>
                                    <td>Ngày BA/QĐ:</td>
                                    <td colspan="3"><b>
                                        <asp:Literal ID="txtVuAn_NgayBanAn" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <asp:Panel ID="pnNguyendo" runat="server">
                                        <td>Nguyên đơn/ Người khởi kiện:</td>
                                     </asp:Panel>
                                    <asp:Panel ID="pnBicaoDv" runat="server"  Visible ="false">
                                        <td>Bị cáo đầu vụ:</td>
                                     </asp:Panel>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                    </td>
                                    <asp:Panel ID="pnBidon" runat="server">
                                        <td>Bị đơn/ Người  bị kiện:</td>
                                    </asp:Panel>
                                    <asp:Panel ID="pnBicaoKN" runat="server" Visible ="false">
                                        <td>Bị cáo khiếu nại:</td>
                                    </asp:Panel>
                                    <td style="vertical-align: top;" colspan="3"><b>
                                        <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                               

                                <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                            </table>
                        </div>
                    </div>
                    <!-------------------------------------------------->
                    <asp:Panel ID="pnHoSoVKS" runat="server">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Hồ sơ kháng nghị của VKS</h4>
                            <div class="boder" style="padding: 2%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Số<span class="batbuoc">*</span></td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtVKS_So" CssClass="user" runat="server"
                                                Width="242px"></asp:TextBox>

                                        </td>
                                        <td style="width: 110px;">Ngày<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtVKS_Ngay" CssClass="user" runat="server"
                                                Width="110px" AutoPostBack="true" OnTextChanged="txtVKS_Ngay_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtVKS_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtVKS_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Đơn vị chuyển HS<span class="batbuoc">*</span></td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="dropVKS_NguoiKy" CssClass="chosen-select"
                                                runat="server" Width="480px">
                                            </asp:DropDownList>
                                    </tr>
                                   
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateVKS" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateVKS_Click" OnClientClick="return validate_vks();" />
                                            <asp:Button ID="cmdXoa_VKS" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdXoa_VKS_Click"
                                                OnClientClick="return confirm('Bạn muốn xóa thông tin này?');"   Visible="false" />
                                        </td>

                                    </tr>

                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="lttMsgHSKN_VKS" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <!-------------------------------------------------->
                    <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông tin thụ lý xét xử GĐT,TT</h4>
                        <div class="boder" style="padding: 2%; width: 96%;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 110px;">Ngày VKS trả/chuyển HS</td>
                                    <td style="width: 255px;">
                                        <asp:TextBox ID="txtNgayVKSTraHS" CssClass="user" runat="server"
                                            onkeypress="return isNumber(event)"
                                            Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayVKSTraHS" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayVKSTraHS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                    <td style="width: 110px;">Số bút lục VKS trả/chuyển HS</td>
                                    <td>
                                        <asp:TextBox ID="txtSobutlucVKSTraHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số thụ lý GĐT</td>
                                    <td>
                                        <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server"
                                            Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Ngày thụ lý GĐT<span class="batbuoc">*</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayThuLy" CssClass="user" runat="server"
                                            Width="242px" AutoPostBack="true" OnTextChanged="txtNgayThuLy_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                </tr>
                                <tr>
                                        <td style="width: 110px;">Ngày phân công</td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtNgayphancong_GDT" AutoPostBack="true" OnTextChanged="txtNgayPhanCongTTV_TextChanged" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong_GDT" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong_GDT" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 110px;">Cán bộ giải quyết đơn</td>
                                        <td>
                                            <asp:DropDownList ID="dropTTV_GDT"
                                                AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_GDT_SelectedIndexChanged"
                                                CssClass="chosen-select" runat="server" Width="250px">
                                            </asp:DropDownList></td>
                                        
                                    </tr>
                                     <tr>
                                        <td style="width: 110px;">Ngày phân công LĐ</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayPhanCong_LDV" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                       <td>Lãnh đạo Vụ</td>
                                        <td>
                                            <asp:DropDownList ID="dropLanhDao"
                                                CssClass="chosen-select" runat="server" Width="250px">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td style="width: 110px;">Quá hạn luật định?</td>
                                        <td>
                                            <asp:DropDownList ID="dropQuahan"  AutoPostBack=" true" 
                                                OnSelectedIndexChanged="dropQuahan_SelectedIndexChanged"
                                                CssClass="chosen-select" runat="server" Width="165px">
                                                <asp:ListItem Value="-1" Text="---Chọn---" Selected ="True"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                       <asp:Panel ID="pnNDquahan"  runat="server"  Visible="false">
                                        <td>Nguyên nhân <span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlChuQuan" CssClass="chosen-select" 
                                                AutoPostBack="true" runat="server" Width="115px"
                                                 OnSelectedIndexChanged="ddlChuQuan_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="---Chọn---" Selected ="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Chủ quan"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Khách quan" ></asp:ListItem>
                                             </asp:DropDownList>
                                        </td>
                                        </asp:Panel>
                                    </tr> 
                                <asp:Panel ID="pnlKN" runat ="server">
                                <tr>
                                <td>Số bút lục hồ sơ KN</td>
                                <td>
                                    <asp:TextBox ID="txtSoButLucKN" CssClass="user" runat="server"
                                        Width="242px"></asp:TextBox>
                                </td>
                                </tr>
                                <tr>
                                    <td>Nội dung KN</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNoidungKN" CssClass="user" runat="server"
                                            Width="620px" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                                </asp:Panel>
                                <tr>
                                    <td>Ghi chú</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtGhiChuKN" CssClass="user" runat="server"
                                            Width="620px" Rows="2" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Button ID="cmdUpdateTLXX" runat="server" CssClass="buttoninput"
                                            Text="Lưu" OnClick="cmdUpdateTLXX_Click" OnClientClick="return validate_ttxx();" />
                                        <asp:Button ID="cmdXoaTLXX" runat="server" CssClass="buttoninput"
                                            Text="Xóa" OnClick="cmdXoa_TLXX_Click"
                                            OnClientClick="return confirm('Bạn muốn xóa thông tin này?');" />
                                    </td>
                                </tr>
                            </table>
                            <div style="margin: 5px; width: 95%; color: red;">
                                <asp:Label ID="lttMsgTLXX" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>
                    <!-------------------------------------------------->
                    <div style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                        <h4 class="tleboxchung">Thông tin xét xử GĐT</h4>
                        <div class="boder" style="padding: 2%; width: 96%;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 110px;">Ngày lên lịch mở phiên tòa<span class="batbuoc">*</span></td>
                                    <td style="width: 255px;">
                                        <asp:TextBox ID="txtNgayLichGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayLichGDT" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayLichGDT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td>Chủ tọa</td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="dropChuToa" CssClass="chosen-select"
                                            runat="server" Width="498px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Chọn Hội đồng</td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdChonHD" runat="server" Font-Bold="true"
                                            AutoPostBack="True" OnSelectedIndexChanged="rdChonHD_SelectedIndexChanged"
                                            RepeatDirection="Vertical" RepeatColumns="2">
                                            <%--<asp:ListItem Value="1" Selected="True" Text="Hội đồng TT"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Hội đồng 5"></asp:ListItem>--%>
                                        </asp:RadioButtonList></td>
                                </tr>
                                <tr>
                                    <td>Thẩm phán</td>
                                    <td colspan="3">
                                        <div class="row" style="margin-top: 0px;">
                                            <div class="col-md-8">
                                                <asp:Literal ID="li_Report_summ" runat="server"></asp:Literal>
                                            </div>
                                        </div>
                                </tr>
                                <tr>
                                    <td>Đại diện vụ GĐKT tham dự: </td>
                                    <td colspan="3">
                                        <asp:ListBox ID="lstVuGDKT"
                                            runat="server"
                                            CssClass="chosen-select"
                                            SelectionMode="Multiple"
                                            Width="498px"
                                            Rows="5">
                                        </asp:ListBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <div style="margin-top:7px;">
                                            <asp:Button ID="cmdUpdateLichXX" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateLichXX_Click" OnClientClick="return validate_lichxx();" />
                                            <asp:Button ID="cmdXoa_LichXX" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdXoa_LichXX_Click"
                                                OnClientClick="return confirm('Bạn muốn xóa thông tin này?');" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <div style="margin: 5px; width: 95%; color: red;">
                                <asp:Label ID="lttMsgLichXX" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <!-------------------------------------------------->
                    <div style="float: left; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Kết quả xét xử</h4>
                        <div class="boder" style="padding: 2%; width: 96%;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 110px;">Hoãn phiên tòa ?</td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdHoan" runat="server" Font-Bold="true"
                                            RepeatDirection="Horizontal"
                                            AutoPostBack="True" OnSelectedIndexChanged="rdHoan_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Selected="True" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ngày mở phiên tòa</td>
                                    <td>
                                        <asp:TextBox ID="txtHoan_NgayMoPT" CssClass="user" runat="server"
                                            Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtHoan_NgayMoPT" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtHoan_NgayMoPT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                  <asp:Panel ID="pnNgayPH" runat="server">
                                    <td>Ngày phát hành</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayPhatHanh" CssClass="user" runat="server"
                                            Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayPhatHanh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayPhatHanh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                    </asp:Panel>
                                </tr>
                                
                                <asp:Panel ID="pnKQ" runat="server">
                                    <tr>
                                        <td style="width: 110px;">Ngày quyết định<asp:Literal ID="lttBatBuoc" runat="server"><span class="batbuoc" style="margin-left:3px;">*</span></asp:Literal></td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtNgayQD" CssClass="user" runat="server"
                                                Width="242px" style="margin-right: 20px;" AutoPostBack="true" OnTextChanged="txtNgayQD_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 110px;">Số quyết định<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoQD" CssClass="user" runat="server"
                                                Width="242px"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Kết quả <span class="batbuoc">*</span></td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="ddlKetquaXX" CssClass="chosen-select"
                                                runat="server" Width="498px">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 110px;">Áp dụng án lệ?</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdAD_AnLe" runat="server" Font-Bold="true"
                                                RepeatDirection="Horizontal"
                                                AutoPostBack="True" OnSelectedIndexChanged="rdAD_AnLe_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Selected="True" Text="Không"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                       <asp:Panel ID="pnAnLe"  runat="server"  Visible="false">
                                        <td>Án lệ áp dụng <span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:DropDownList ID="dropAnLe" CssClass="chosen-select" 
                                                AutoPostBack="true" runat="server" Width="135px" OnSelectedIndexChanged="dropAnLe_SelectedIndexChanged">                                            
                                        </asp:DropDownList>
                                        </td>
                                    </asp:Panel>
                                    </tr> 
                                </asp:Panel>
                                <asp:Panel ID="pnHoan" runat="server">
                                    <tr>
                                        <td><asp:Literal ID="lttLydo" runat="server">Ghi chú</asp:Literal></td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtLyDoHoan" CssClass="user" runat="server"
                                                Width="500px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Button ID="cmdUpdateKQ" runat="server" CssClass="buttoninput"
                                            Text="Lưu" OnClick="cmdUpdateKQ_Click" ToolTip="Mỗi vụ án chỉ có một kết quả, nếu đã tồn tại kết quả rồi thì sẽ không nhập được nữa." OnClientClick="return validate_kq();" />
                                        <span style="margin-left: 10px;">
                                            <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput"
                                                Text="Làm mới" OnClick="cmdLamMoi_Click" />
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div class="boxchung" style="margin-bottom: 3px;">

                                            <div style="float: right; display: none;">
                                                <asp:Button ID="cmdPrinDS" runat="server" CssClass="buttoninput"
                                                    Text="In danh sách" OnClientClick="PrinDS()" />
                                            </div>

                                            <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                                                <HeaderTemplate>
                                                    <table class="table2" width="100%" border="1">
                                                        <tr class="header">
                                                            <td width="40">
                                                                <div align="center"><strong>TT</strong></div>
                                                            </td>
                                                            <td width="80px">
                                                                <div align="center"><strong>Ngày mở PT</strong></div>
                                                            </td>
                                                            <td width="150px">
                                                                <div align="center"><strong>Hoãn PT?</strong></div>
                                                            </td>
                                                            <td>
                                                                <div align="center"><strong>Lý do/ Kết quả</strong></div>
                                                            </td>

                                                            <td width="40px">
                                                                <div align="center"><strong>Sửa</strong></div>
                                                            </td>
                                                            <td width="40px">
                                                                <div align="center"><strong>Xóa</strong></div>
                                                            </td>
                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <div align="center"><%# Eval("STT") %></div>
                                                        </td>
                                                        <td><%# Eval("NgayMoPT") %></td>
                                                        <td><%# Eval("HoanPT") %></td>
                                                        <td>
                                                           
                                                            <b><%# Convert.ToInt16(Eval("IsHoan")+"") ==0 ? ("Số: "+Eval("SoQDXX")+" - Ngày: "+Eval("NgayQDXX") + (String.IsNullOrEmpty(Eval("NgayPH")+"") ? "": " - Ngày phát hành: " + Eval("NgayPH")) +"<br />"):"" %>
                                                            </b>
                                                            <%# String.IsNullOrEmpty(Eval("KetQua")+"") ? "":"KQ: "+Eval("KetQua") %>
                                                            <%# String.IsNullOrEmpty(Eval("inforAnLe")+"") ? "":Eval("inforAnLe") %> 
                                                            <br />
                                                            <%# String.IsNullOrEmpty(Eval("LyDoHoan")+"") ? "":Eval("LyDoHoan") %> 
                                                            
                                                        </td>
                                                        <td>
                                                            <div align="center">
                                                                <div class="tooltip">
                                                                    <asp:ImageButton ID="cmdEdit" runat="server" ToolTip="Sửa" CssClass="grid_button"
                                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'
                                                                        ImageUrl="~/UI/img/edit_doc.png" Width="18px" />
                                                                    <span class="tooltiptext  tooltip-bottom">Sửa</span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div align="center">
                                                                <div class="tooltip">
                                                                    <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        ImageUrl="~/UI/img/delete.png" Width="17px"
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                                                    <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <div style="margin: 5px; width: 95%; color: red;">
                                <asp:Label ID="lttMsg" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>

            </div>
        </div>
    </div>

    <script type="text/javascript">
        //function to add months to a date
        function addMonthsToDate(_date, _noOfMonths) {
            return new Date(_date.setMonth(_date.getMonth() + _noOfMonths));
        }
       
        function hidePanel() {
            document.getElementById('<%= pnNDquahan.ClientID %>').style.display = "none";
            return false;
        }
        function showPanel() {
            document.getElementById('<%= pnNDquahan.ClientID %>').style.display = "block";
           }

        function validate_ttxx() {
            var txtNgayVKSTraHS = document.getElementById('<%=txtNgayVKSTraHS.ClientID%>');
            if (Common_CheckEmpty(txtNgayVKSTraHS.value)) {
                if (!CheckDateTimeControl(txtNgayVKSTraHS, "Ngày VKS trả hồ sơ"))
                    return false;
            }
            //-----------------------------
            var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
            if (!CheckDateTimeControl(txtNgayThuLy, "Ngày thụ lý GĐT"))
                return false;
            //Thong tin ket qua
            var NgayHoan_MoPT = document.getElementById('<%=txtHoan_NgayMoPT.ClientID%>');
            var NgayKQ = NgayHoan_MoPT.value;
            var KQXX = document.getElementById('<%=hddXetXuID.ClientID%>').value; 
           
            
            //--check canh bao qua han luat dinh-----------------------
            var txtSoThuly = document.getElementById('<%=txtSoThuLy.ClientID%>');
            var dropQuahan = document.getElementById('<%=dropQuahan.ClientID%>');
            var selected_Quahan = dropQuahan.options[dropQuahan.selectedIndex].value;
            var NgayTL = txtNgayThuLy.value;

            var dateParts = NgayTL.split("/");
            // month is 0-based, that's why we need dataParts[1] - 1
            var my_date = new Date(+dateParts[2], dateParts[1] - 1, +dateParts[0]); 
            // Add 4 months to today's date
            new Date(my_date.setMonth(my_date.getMonth() + 4));
            var time_now = new Date();
            //chua co ket qua thi băt
            if (KQXX == "0") {
                if (my_date <= time_now && selected_Quahan == "-1") {
                    alert('Vu án đã qua hạn giải quyết, bạn cần xác nhận có quá hạn luật định hay không?');
                    txtSoThuly.focus();
                    return false;
                }

                if (selected_Quahan == "1") {
                    var ddlChuQuan = document.getElementById('<%=ddlChuQuan.ClientID%>');
                    var val = ddlChuQuan.options[ddlChuQuan.selectedIndex].value;
                    if (val == "0") {
                        alert('Bạn chưa chọn nguyên nhân quá hạn luật định');
                        ddlChuQuan.focus();
                        return false;
                    }
                }
            }
           <%--if (NgayKQ == "") {
                if (my_date <= time_now && selected_Quahan == "-1") {
                    alert('Vu án đã qua hạn giải quyết, bạn cần xác nhận có quá hạn luật định hay không?');
                    dropQuahan.focus();
                    return false;
                }

                if (selected_Quahan == "1") {
                    var ddlChuQuan = document.getElementById('<%=ddlChuQuan.ClientID%>');
                    var val = ddlChuQuan.options[ddlChuQuan.selectedIndex].value;
                    if (val == "0") {
                        alert('Bạn chưa chọn nguyên nhân quá hạn luật định');
                        ddlChuQuan.focus();
                        return false;
                    }
                }
            } else {
                var p_hddQuahanLuatdinh = document.getElementById('<%=hdd_quahanluatdinh.ClientID%>').value;
                
                var p_NgayKQ = NgayKQ.split("/");
                var Check_NgayKQ = new Date(+p_NgayKQ[2], p_NgayKQ[1] - 1, +p_NgayKQ[0]); 
                if (my_date <= Check_NgayKQ && p_hddQuahanLuatdinh != "1" ) {
                    alert('Vu án đã qua hạn giải quyết, bạn cần chọn lý do quá hạn luật định?');
                    //dropQuahan.options[dropQuahan.selectedIndex].value = "1";   
                    txtSoThuly.focus();
                    alert(selected_Quahan);
                    return false;
                }

                if (p_hddQuahanLuatdinh == "1") {
                    var ddlChuQuan = document.getElementById('<%=ddlChuQuan.ClientID%>');
                    var val = ddlChuQuan.options[ddlChuQuan.selectedIndex].value;
                    if (val == "0") {
                        alert('Bạn chưa chọn nguyên nhân quá hạn luật định');
                        ddlChuQuan.focus();
                        return false;
                    }
                }
                
            }--%>


            return true;
        }
        function validate_lichxx() {
            var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
            if (!CheckDateTimeControl(txtNgayThuLy, "Ngày thụ lý GĐT"))
                return false;
            //-----------------------------
            var txtNgayLichGDT = document.getElementById('<%=txtNgayLichGDT.ClientID%>');
            if (!CheckDateTimeControl(txtNgayLichGDT, "Ngày lên lịch mở phiên tòa"))
                return false;
            selectList_thamphan();
            return true;
        }
        function validate_kq() {
            var hddShowHoSoVKS = document.getElementById('<%=hddShowHoSoVKS.ClientID%>');
            var IsshowHS = hddShowHoSoVKS.value;
            if (IsshowHS == 1) {
                if (!validate_vks())
                    return false;
            }
            //------------------------
            
            if (!validate_ttxx())
                return false;
            //------------------------
            var rdHoan = document.getElementById('<%=rdHoan.ClientID%>');
            var selected_value = GetStatusRadioButtonList(rdHoan);
            if (selected_value == "1") {
                var txtHoan_NgayMoPT = document.getElementById('<%=txtHoan_NgayMoPT.ClientID%>');
                if (!CheckDateTimeControl(txtHoan_NgayMoPT, 'Ngày mở phiên tòa'))
                    return false;
               
                //-------------------
                var txtLyDoHoan = document.getElementById("<%=txtLyDoHoan.ClientID%>")
                if (!Common_CheckEmpty(txtLyDoHoan.value)) {
                    alert('Bạn chưa nhập Lý do hoãn phiên tòa. Hãy kiểm tra lại!');
                    txtLyDoHoan.focus();
                    return false;
                }
            }
            else {
                <%--var txtHoan_NgayMoPT = document.getElementById('<%=txtHoan_NgayMoPT.ClientID%>');
                if (!CheckDateTimeControl(txtHoan_NgayMoPT, 'Ngày mở phiên tòa'))
                    return false;--%>

                //-----------------------------
                var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
                if (!CheckDateTimeControl(txtNgayQD, 'Ngày quyết định'))
                    return false;
                //-----------------------------
                var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
                if (!Common_CheckTextBox(txtSoQD, 'Số quyết định'))
                    return false;

                var ddlKetquaXX = document.getElementById('<%=ddlKetquaXX.ClientID%>');
                var ckKetqua = ddlKetquaXX.options[ddlKetquaXX.selectedIndex].value;
                if (ckKetqua == "0") {
                    alert('Bạn chưa chọn Kết quả');                    
                    return false;
                }
                
                //---Bat buoc nhap ket qua-----------
                //---Ap dụng án lệ--------------------------
                var rdAD_AnLe = document.getElementById('<%=rdAD_AnLe.ClientID%>');
                var selected_AnLe = GetStatusRadioButtonList(rdAD_AnLe);
                if (selected_AnLe == "1") {
                    var dropAnLe = document.getElementById('<%=dropAnLe.ClientID%>');
                    var val = dropAnLe.options[dropAnLe.selectedIndex].value;
                    if (val == "0") {
                        alert('Bạn chưa chọn Số Án lệ');
                        dropAnLe.focus();
                        return false;
                    }
                }  
                //-----------------------------

            }
            return true;
        }

        function validate_vks() {
            var txtVKS_So = document.getElementById('<%=txtVKS_So.ClientID%>');
            if (!Common_CheckTextBox(txtVKS_So, 'Số'))
                return false;
            var txtVKS_Ngay = document.getElementById('<%=txtVKS_Ngay.ClientID%>');
            if (!CheckDateTimeControl(txtVKS_Ngay, 'Ngày'))
                return false;

            var dropVKS_NguoiKy = document.getElementById('<%=dropVKS_NguoiKy.ClientID%>');
            var val = dropVKS_NguoiKy.options[dropVKS_NguoiKy.selectedIndex].value;
            if (val == "0") {
                alert('Bạn chưa chọn đơn vị chuyển hồ sơ');
                dropVKS_NguoiKy.focus();
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }

        function PrinDS() {
            var pageURL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=xx_gdt" + "&vID=<%=Request["ID"] %>";
            var title = 'In báo cáo';
            var w = 1000;
            var h = 600;
            var left = (screen.width / 2) - (w / 2) + 50;
            var top = (screen.height / 2) - (h / 2) + 50;
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function selectList_thamphan() {
            newDestList = new Array($('#selectList option:selected').length);
            var len = 0;
            var add_str = ""; var add_str_name = "";
            for (len = 0; len < $('#selectList option:selected').length; len++) {
                if ($('#selectList option:selected')[len] != null) {
                    newDestList[len] = new Option($('#selectList option:selected')[len].text, $('#selectList option:selected')[len].value, $('#selectList option:selected')[len].defaultSelected, $('#selectList option:selected')[len].selected);
                    add_str = add_str + newDestList[len].value + ',';
                    add_str_name = add_str_name + newDestList[len].text + ',';
                }
            }
            document.getElementById('<%=hdd_thamphan.ClientID%>').value = add_str.substring(0, add_str.length - 1);
            document.getElementById('<%=hdd_thamphan_name.ClientID%>').value = add_str_name.substring(0, add_str_name.length - 1);
            //alert(document.getElementById('<%=hdd_thamphan.ClientID%>').value);
        }
    </script>
</asp:Content>
