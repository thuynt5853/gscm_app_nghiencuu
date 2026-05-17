<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pToTrinhCV.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pToTrinhCV" %>

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
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddReloadParent" runat="server" Value="0" />
                <div class="boxchung">
                    <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông tin công văn</h4>
                        <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                            <table class="table_info_va">
                                <tr>
                                    <td>Số công văn:</td>
                                    <td><b>
                                        <asp:Literal ID="txtCV_SoCV" runat="server"></asp:Literal></b>
                                    </td>
                                    <td>Ngày công văn:</td>
                                    <td><b>
                                        <asp:Literal ID="txtCV_NgayCV" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số thụ lý:</td>
                                    <td style="width: 250px;"><b>
                                        <asp:Literal ID="txtCV_SoThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                    <td style="width: 105px">Ngày thụ lý:</td>
                                    <td><b>
                                        <asp:Literal ID="txtCV_NgayThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Literal ID="label_DonViGuiCV" runat="server" Text="Tòa án chuyển CV"></asp:Literal></td>
                                    <td style="width: 250px;"><b>
                                        <asp:Literal ID="lttDonviGuiCV" runat="server"></asp:Literal></b>
                                    </td>
                                    <td style="width: 105px">Thẩm tra viên:</td>
                                    <td><b>
                                        <asp:Literal ID="lttTTV" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 90px;">Nội dung công văn:</td>
                                    <td colspan="3" style="vertical-align: top;"><b>
                                        <asp:Literal ID="lttNoiDungCV" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!-------------------------------------------------->
                    <div style="float: left; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông tin trình</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1" style="width: 90%; margin: 0 auto;">

                                <tr>
                                    <td style="width: 95px;">Tờ trình số<span class="batbuoc">*</span></td>
                                    <td style="width: 260px;">
                                        <asp:TextBox ID="txt_SoToTrinh" runat="server"
                                            onkeypress="return isNumber(event)"
                                            CssClass="user" Width="242px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td style="width: 82px;">Ngày tờ trình<span class="batbuoc">*</span></td>
                                    <td>
                                        <asp:TextBox ID="txt_NgayToTrinh" runat="server" CssClass="user"
                                            Width="242px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NgayToTrinh" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txt_NgayToTrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />


                                    </td>
                                </tr>

                                <asp:Panel ID="pnNoiDungToTrinh" runat="server">
                                    <tr>
                                        <td>Cấp trình<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlLoaitrinh" CssClass="chosen-select"
                                                runat="server" Width="250px"
                                                AutoPostBack="True" OnSelectedIndexChanged="ddlLoaitrinh_SelectedIndexChanged">
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
                                        <td>Ngày trình<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgaytrinh" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaytrinh" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaytrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày trả
                                            <asp:Label ID="lblTitNgaytra" runat="server" Visible="false" ForeColor="Red" Text="*"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNgaytra" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaytra" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaytra" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <asp:CheckBox ID="chkTrinhLai" runat="server" Text="Trình lại" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày LĐ nhận tờ trình</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayLDNhanToTrinh" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayLDNhanToTrinh" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayLDNhanToTrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                   <%-- <tr>
                                        <td>Ý kiến
                                        </td>
                                        <td colspan="3">
                                            <asp:RadioButtonList ID="rdLoaiYKien"
                                                AutoPostBack="true"
                                                RepeatDirection="Horizontal" runat="server" OnSelectedIndexChanged="rdLoaiYKien_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Trả lời đơn" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Kháng nghị"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Trình lãnh đạo cấp trên"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Xếp đơn"></asp:ListItem>

                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>--%>
                                    <asp:Panel ID="pnTrinhLDTiep" runat="server" Visible="false">
                                        <tr>
                                            <td>Cấp trình</td>
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
                                        <td>Chi tiết ý kiến<asp:Label ID="lblTitYkien" runat="server" Visible="false" ForeColor="Red" Text="*"></asp:Label></td>
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
                                    <td colspan="4" align="center">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                            OnClientClick="return validate();"
                                            Text="Lưu" OnClick="cmdUpdate_Click" />
                                        <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput"
                                            Text="Làm mới" OnClick="cmdLamMoi_Click" />
                                        <input type="button" class="buttoninput" onclick="ReloadParent(); window.close();" value="Đóng" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="boxchung">
                    <h4 class="tleboxchung">Quá trình giải quyết</h4>
                    <div class="boder" style="padding: 10px;">
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
                                            <div align="center"><strong>Ngày</strong></div>
                                        </td>

                                        <td width="150px">
                                            <div align="center"><strong>Cấp trình</strong></div>
                                        </td>

                                        <td width="150px">
                                            <div align="center"><strong>Lãnh đạo</strong></div>
                                        </td>
                                        <td width="80px">
                                            <div align="center"><strong>Ngày trả</strong></div>
                                        </td>

                                        <td>
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
                                    <td><%# Eval("TENLANHDAO") %></td>

                                    <td><%# Eval("NgayTra") %></td>
                                    <td><%# String.IsNullOrEmpty(Eval("CapTrinhTiep")+"") ? Eval("YKien_Text") :("Yêu cầu: <b>"+Eval("CapTrinhTiep") +"</b><br/>") %>
                                        <%# String.IsNullOrEmpty(Eval("YKIEN")+"") ? "":(Eval("YKIEN") +"") %>
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
                opener.LoadDSToTrinh();
            };
        }
        function ClosePopup() {
           // var hddReloadParent = document.getElementById('<%=hddReloadParent.ClientID%>');
            // if (hddReloadParent.value =="1")
            ReloadParent();
            window.close();
        }
    </script>
    <script>
        function validate() {
            var txt_SoToTrinh = document.getElementById('<%=txt_SoToTrinh.ClientID%>');
            if (!Common_CheckEmpty(txt_SoToTrinh.value)) {
                alert('Bạn chưa nhập tờ trình số. Hãy kiểm tra lại!');
                txt_SoToTrinh.focus();
                return false;
            }
            var txt_NgayToTrinh = document.getElementById('<%=txt_NgayToTrinh.ClientID%>');
            if (!CheckDateTimeControl(txt_NgayToTrinh, 'ngày tờ trình'))
                return false;

            //---------------------------------
            var ddlLoaitrinh = document.getElementById('<%=ddlLoaitrinh.ClientID%>');
            var val = ddlLoaitrinh.options[ddlLoaitrinh.selectedIndex].value;

            var txtNgaytrinh = document.getElementById('<%=txtNgaytrinh.ClientID%>');
            if (!CheckDateTimeControl(txtNgaytrinh, 'ngày trình'))
                return false;

            //----------------------------------
            var txtNgaytra = document.getElementById('<%=txtNgaytra.ClientID%>');
            if (Common_CheckEmpty(txtNgaytra.value)) {
                if (!CheckDateTimeControl(txtNgaytra, 'ngày trả'))
                    return false;
                if (!SoSanh2Date(txtNgaytra, "Ngày trả", txtNgaylap.value, "Ngày lập"))
                    return false;

                if (!SoSanh2Date(txtNgaytra, "Ngày trình", txtNgaytrinh.value, "Ngày trình"))
                    return false;
            }
            //------------------------
            var txtYkien = document.getElementById('<%=txtYkien.ClientID%>');
            if (Common_CheckEmpty(txtYkien.value)) {
                if (!CheckDateTimeControl(txtNgaytra, 'ngày trả'))
                    return false;
            }
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
