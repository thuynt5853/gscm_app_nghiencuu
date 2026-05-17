<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QLTotrinh.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.QLTotrinh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý tờ trình</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
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

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }

        .btn_small {
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
            padding: 3px;
            min-width: 70px;
            height: 25px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="boxchung">
                    <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                            <table class="table_info_va">
                                <tr>
                                    <td style="width: 90px;">Vụ án:</td>
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
                                    <asp:Panel ID="pnNguyendo" runat="server">
                                        <td style="vertical-align: top;">Nguyên đơn/ Người khởi kiện:</td>
                                     </asp:Panel>
                                    <asp:Panel ID="pnBicaoDv" runat="server"  Visible ="false">
                                        <td style="vertical-align: top;">Bị cáo đầu vụ:</td>
                                     </asp:Panel>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                    </td>
                                   
                                     <asp:Panel ID="pnBidon" runat="server">
                                        <td style="vertical-align: top;">Bị đơn/ Người  bị kiện:</td>
                                    </asp:Panel>
                                    <asp:Panel ID="pnBicaoKN" runat="server" Visible ="false">
                                        <td style="vertical-align: top;">Bị cáo khiếu nại:</td>
                                    </asp:Panel>
                                    <td><b>
                                        <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!-------------------------------------------------->
                    <div id="totrinh_thongtin" runat="server" style="float: left; width: 100%; position: relative; margin-top: 15px;">
                        <h4 class="tleboxchung">Thông tin trình</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1" style="width: 100%; margin: 0 auto;">

                                <tr>
                                    <td style="width: 95px;">Tờ trình số<span class="batbuoc">*</span></td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txtSototrinh" runat="server"
                                            CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td style="width: 82px;">Ngày tờ trình</td>
                                    <td>
                                        <asp:TextBox ID="txtNgaylap" runat="server" CssClass="user"
                                            AutoPostBack="true"
                                            Width="242px" MaxLength="10" OnTextChanged="txtNgaylap_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgaylap" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaylap" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <asp:CheckBox ID="chkEdit" runat="server" Text="Sửa"
                                            AutoPostBack="True" OnCheckedChanged="chkEdit_CheckedChanged" />

                                    </td>
                                </tr>
                                <tr>
                                    <td>Đề xuất của TTV</td>
                                    <td colspan="3" style="position: relative;">
                                        <asp:RadioButtonList ID="rdLoaiYKienTTV" RepeatDirection="Horizontal" runat="server">
                                            <asp:ListItem Value="0" Text="Trả lời đơn"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Kháng nghị"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Xếp đơn"></asp:ListItem>
                                            <asp:ListItem Value="10" Text="Nghiên cứu lại, xác minh, bổ sung"></asp:ListItem>
                                        </asp:RadioButtonList>
                                        <div style="position: absolute; left: 545px; top: 4px;">
                                            <asp:Button ID="cmdHuyChonTTV" runat="server"
                                                CssClass="buttoninput btn_small"
                                                Text="Hủy chọn" OnClick="cmdHuyChonTTV_Click" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtDeXuatTTV" runat="server" CssClass="user" Width="602px"></asp:TextBox>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnNoiDungToTrinh" runat="server">
                                    <tr>
                                        <td>Cấp trình<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlLoaitrinh" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaitrinh_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Literal ID="lttLanhDao" runat="server" Text="Phó chánh án"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlLanhdao" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày trình</td>
                                        <td>
                                            <asp:TextBox ID="txtNgaytrinh" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaytrinh" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaytrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày đăng ký BC dự kiến</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayDangKyBC" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayDangKyBC" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayDangKyBC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày LĐ nhận tờ trình</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayLDNhanToTrinh" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayLDNhanToTrinh" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayLDNhanToTrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày trả
                                                <asp:Label ID="lblTitNgaytra" runat="server" Visible="false" ForeColor="Red" Text="*"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNgaytra" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaytra" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaytra" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <asp:CheckBox ID="chkTrinhLai" runat="server" Text="Trình lại" AutoPostBack="True" OnCheckedChanged="chkTrinhLai_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ý kiến
                                        </td>
                                        <td colspan="3" style="position: relative;">
                                            <%--AutoPostBack="true" OnSelectedIndexChanged="rdLoaiYKien_SelectedIndexChanged"--%>
                                            <asp:RadioButtonList ID="rdLoaiYKien" RepeatDirection="Horizontal" runat="server">
                                                <asp:ListItem Value="0" Text="Trả lời đơn"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Kháng nghị"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Xếp đơn"></asp:ListItem>
                                                <asp:ListItem Value="10" Text="Nghiên cứu lại, xác minh, bổ sung"></asp:ListItem>
                                                <%--<asp:ListItem Value="" Text="..."></asp:ListItem>--%>
                                                <%-- <asp:ListItem Value="2" Text="Yêu cầu khác"></asp:ListItem>--%>
                                            </asp:RadioButtonList>
                                            <div style="position: absolute; left: 545px; top: 4px;">
                                                <asp:Button ID="cmdHuyChon" runat="server"
                                                    CssClass="buttoninput btn_small"
                                                    Text="Hủy chọn" OnClick="cmdHuyChon_Click" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td>Yêu cầu khác</td>
                                        <td colspan="3">
                                            <asp:CheckBox ID="chkYeuCauKhac" runat="server" Checked="true"
                                                AutoPostBack="True" OnCheckedChanged="chkYeuCauKhac_CheckedChanged" /></td>
                                    </tr>
                                    <asp:Panel ID="pnTrinhLDTiep" runat="server">
                                        <tr>
                                            <td>Yêu cầu trình tiếp</td>
                                            <td>
                                                <asp:DropDownList ID="dropCapTrinhTiep"
                                                    CssClass="chosen-select" runat="server" Width="250px"
                                                    AutoPostBack="True" OnSelectedIndexChanged="dropCapTrinhTiep_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:Literal ID="lttHoTenLDTiep" runat="server" Text="Lãnh đạo"></asp:Literal>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="dropLDrinhTiep" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Nội dung ý kiến</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtYkien" CssClass="user" runat="server" Width="602px" MaxLength="500"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ghi chú
                                        </td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="602px" MaxLength="500"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <div>
                                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                            OnClientClick="return validate();"
                                            Text="Lưu" OnClick="cmdUpdate_Click" />
                                        <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput"
                                            Text="Làm mới" OnClick="cmdLamMoi_Click" />
                                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="boxchung">
                    <h4 class="tleboxchung">Quá trình giải quyết</h4>
                    <div class="boder" style="padding: 10px;">
                        <%-- <asp:Button ID="cmdThem" runat="server" CssClass="buttoninput" Text="Tạo tờ trình" OnClick="cmdThem_Click" />--%>
                        <asp:Button ID="cmdPrinDS" runat="server" CssClass="buttoninput" Text="In danh sách" OnClientClick="PrintHS('ds')" />
                        <div style="display: none;">
                            <asp:Button ID="cmdPrint2" runat="server" CssClass="buttoninput"
                                Text="Làm mới" OnClick="cmdPrint_Click" />
                        </div>
                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                            <HeaderTemplate>
                                <table class="table2" width="100%" border="1">
                                    <tr class="header">
                                        <td width="60">
                                            <div align="center"><strong>Vòng trình</strong></div>
                                        </td>
                                        <td width="80px">
                                            <div align="center"><strong>Ngày trình</strong></div>
                                        </td>

                                        <td width="100px">
                                            <div align="center"><strong>Cấp trình</strong></div>
                                        </td>

                                        <td width="120px">
                                            <div align="center"><strong>Lãnh đạo</strong></div>
                                        </td>
                                        <td width="70px">
                                            <div align="center"><strong>Ngày đăng ký BC dự kiến</strong></div>
                                        </td>
                                        <td width="70px">
                                            <div align="center"><strong>Ngày trả</strong></div>
                                        </td>

                                        <td width="190px">
                                            <div align="center"><strong>Ý kiến duyệt tờ trình</strong></div>
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
                                    <asp:Literal ID="lttLanTrinh" runat="server"></asp:Literal>
                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYTRINH")) %></td>
                                    <td><%# Eval("TENTINHTRANG") %></td>
                                    <td>  <%# (Eval("chucvuid")+"")=="74" ? "PCA ":"" %> <%# Eval("TENLANHDAO") %></td>
                                    <td><%# Eval("NgayDK") %></td>
                                    <td><%# Eval("NgayTra") %></td>
                                    <td>
                                        <%# Eval("YKienDuyetToTrinh") %>
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
                </div>
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
        function ReloadParent() {
            window.onunload = function (e) {
                opener.LoadDsDon();
            };
        }
    </script>
    <script>
        function validate() {
            var txtSototrinh = document.getElementById('<%=txtSototrinh.ClientID%>');
            if (!Common_CheckEmpty(txtSototrinh.value)) {
                alert('Bạn chưa nhập tờ trình số. Hãy kiểm tra lại!');
                txtSototrinh.focus();
                return false;
            }
            var txtNgaylap = document.getElementById('<%=txtNgaylap.ClientID%>');
            if (!CheckDateTimeControl(txtNgaylap, 'ngày tờ trình'))
                return false;

            //---------------------------------
          <%--  var ddlLoaitrinh = document.getElementById('<%=ddlLoaitrinh.ClientID%>');
            var val = ddlLoaitrinh.options[ddlLoaitrinh.selectedIndex].value;--%>

            //-----------------
              
            <%--
            var txtNgayDangKyBC = document.getElementById('<%=txtNgayDangKyBC.ClientID%>');
            if (!CheckDateTimeControl(txtNgaytrinh, 'ngày trình'))
                return  false;

            //-----------------
            var txtNgayDangKyBC = document.getElementById('<%=txtNgayDangKyBC.ClientID%>');
            if (Common_CheckEmpty(txtNgayDangKyBC.value)) {
                if (!Common_IsTrueDate(txtNgayDangKyBC.value)) {
                    txtNgayDangKyBC.focus();
                    return false;
                }
            }--%>

            //----------------------------------
            var txtNgaytra = document.getElementById('<%=txtNgaytra.ClientID%>');
            if (Common_CheckEmpty(txtNgaytra.value)) {
                if (!CheckDateTimeControl(txtNgaytra, 'ngày trả'))
                    return false;
            }
            //-------------------------
            return true;
        }
        function PrintHS() {
            $("#<%= cmdPrint2.ClientID %>").click();
            var pageURL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=dstotrinh" + "&vID=<%=Request["vID"] %>";
            var title = 'In báo cáo';
            var w = 1000;
            var h = 600;
            var left = (screen.width / 2) - (w / 2) + 50;
            var top = (screen.height / 2) - (h / 2) + 50;
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</body>

<script>

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
