<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="PhieuMuon.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.PhieuMuon" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Tạo phiếu</title>
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

    <style>
        body {
            width: 96%;
            margin-left: 2%;
            min-width: 0px;
            padding-top: 5px;
        }

        .tleboxchung {
            padding: 5px 5px;
            top: 5px;
            border: solid 0px #a2c2a8;
        }
    </style>
</head>
<body>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddGroupID" runat="server" Value="" />
                <asp:HiddenField ID="hddTuCachTT_BiHai_ID" runat="server" Value="0" />
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
                <asp:HiddenField ID="hddListVuAn" runat="server" Value="0" />

                <div class="box">
                    <div class="form_tt">
                        <h4 class="tleboxchung">Quản lý hồ sơ</h4>
                        <div class="boder" style="padding: 2%; width: 96%;">
                            <table class="table1">

                                <tr>
                                    <td style="width: 120px;">Loại phiếu<span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px;"><%--AutoPostBack="true" OnSelectedIndexChanged="dropLoai_SelectedIndexChanged"--%>
                                        <asp:DropDownList ID="dropLoai"
                                            CssClass="chosen-select" runat="server" Width="250">
                                            <asp:ListItem Value="0" Text="Phiếu mượn"></asp:ListItem>

                                        </asp:DropDownList>
                                    </td>
                                </tr>
                              
                                <tr>
                                    <td>Đơn vị giữ hồ sơ ?</td>
                                    <td>
                                        <asp:RadioButtonList ID="rdLoaiDV" runat="server" Font-Bold="true"
                                            RepeatDirection="Horizontal"
                                            AutoPostBack="True" OnSelectedIndexChanged="rdLoaiDV_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Selected="True" Text="Tòa án nhân dân"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Viện kiểm sát"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td>
                                        <asp:Label ID="lblDonVi" runat="server" Text="Tòa án"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="dropToaAn_VKS"
                                            CssClass="chosen-select" runat="server" Width="250">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Cán bộ</td>
                                    <td>
                                        <asp:DropDownList ID="dropCanBo"
                                            CssClass="chosen-select" runat="server" Width="250"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropCanBo_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblHoTen" runat="server">Họ tên</asp:Label><asp:Literal ID="lttValidHoTen" runat="server" Text="<span class='batbuoc'>(*)</span>"></asp:Literal></td>
                                    <td>
                                        <asp:TextBox ID="txtCanBo" CssClass="user"
                                            runat="server" MaxLength="250" Width="242px"></asp:TextBox>
                                        <asp:CheckBox ID="chkInputCB" runat="server" Text="Nhập trực tiếp" Visible="false"
                                            AutoPostBack="true" OnCheckedChanged="chkInputCB_CheckedChanged" />
                                    </td>
                                </tr>
                                  <tr>
                                    <td>Số phiếu <span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoPhieu" runat="server"
                                            onkeypress="return isNumber(event)"
                                            CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    </td>
                                    <td style="width: 105px">
                                        <asp:Label ID="lblNgayTH" runat="server" Text="Ngày lập phiếu"></asp:Label>
                                        <span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayTao" runat="server" CssClass="user"
                                            AutoPostBack="true" OnTextChanged="txtNgayTao_TextChanged"
                                            Width="242px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayTao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayTao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayTao" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>Trạng thái</td>
                                    <td>
                                        <asp:DropDownList ID="dropTrangThai"
                                            CssClass="chosen-select" runat="server" Width="250px">
                                            <asp:ListItem Value="0" Text="Chưa hoàn thành"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Hoàn thành"></asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td></td>
                                    <td></td>

                                </tr>

                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Button ID="cmdUpdateAndNext" runat="server" CssClass="buttoninput"
                                            Text="Lưu"
                                            OnClientClick="return validate();" OnClick="cmdUpdateAndNext_Click" />
                                        <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                            Text="Lưu và In phiếu mượn" OnClientClick="return validate();" OnClick="cmdPrint_Click" />
                                        <div style="display: none;">
                                            <asp:Button ID="cmdPrint2" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                OnClientClick="return validate();" OnClick="cmdPrint_Click" />
                                        </div>

                                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="3">
                                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="30">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                <td width="80px">
                                                    <div align="center"><strong>Số & Ngày thụ lý</strong></div>
                                                </td>

                                                <td width="80px">
                                                    <div align="center"><strong>Thông tin bản án</strong></div>
                                                </td>
                                                <td width="120px">
                                                    <div align="center"><strong>Tòa xét xử</strong></div>
                                                </td>
                                                <td width="120px">
                                                    <div align="center"><strong>Nguyên đơn</strong></div>
                                                </td>

                                                <td width="120px">
                                                    <div align="center"><strong>Bị đơn</strong></div>
                                                </td>
                                                <td>Quan hệ pháp luật</td>
                                                <%-- <td width="40px">
                                            <div align="center"><strong></strong></div>
                                        </td>--%>
                                            </tr>
                                            <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <div align="center"><%# Eval("SOTOTRINH")%></div>
                                                        </td>
                                                        <td><%#Eval("SOTHULYDON")%>
                                                            <br />
                                                            <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYTHULYDON")) %></td>
                                                        <td><b><%#Eval("SOANPHUCTHAM")%></b>
                                                            <br />
                                                            <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYXUPHUCTHAM")) %></td>
                                                        <td><%#Eval("GhiChu")%></td>
                                                        <td><%#Eval("NguyenDon")%></td>
                                                        <td><%#Eval("BiDon")%></td>
                                                        <td><%#Eval("GQD_GHICHU")%></td>
                                                        <%-- <td>
                                                    <div align="center">                                                       
                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                        Text="Xóa" ForeColor="#0e7eee"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                    </div>
                                                </td>--%>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
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
        <%--function PrintHS() {
            $("#<%= cmdPrint2.ClientID %>").click();

            var pageURL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=mhoso";
            //alert('url=' + pageURL);

            var title = 'In báo cáo';
            var w = 1000;
            var h = 600;
            var left = (screen.width / 2) - (w / 2) + 50;
            var top = (screen.height / 2) - (h / 2) + 50;
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }--%>
        function validate() {

            var dropLoai = document.getElementById('<%=dropLoai.ClientID%>');
            var loai = dropLoai.options[dropLoai.selectedIndex].value;
            var loai_ngay = "Ngày lập phiếu";
            if (loai == 0)
                loai_ngay += " mượn";
            else if (loai == 1)
                loai_ngay += " trả";
            else if (loai == 2)
                loai_ngay += " chuyển";
            else if (loai == 3)
                loai_ngay += " nhận";

            var txtNgayTao = document.getElementById('<%=txtNgayTao.ClientID%>');
            if (!CheckDateTimeControl(txtNgayTao, loai_ngay))
                return false;
            //-------------------------
            var dropCanBo = document.getElementById('<%=dropCanBo.ClientID%>');
            var val = dropCanBo.options[dropCanBo.selectedIndex].value;
            if (val == 0) {
                var txtCanBo = document.getElementById('<%=txtCanBo.ClientID%>');
                if (!Common_CheckEmpty(txtCanBo.value)) {
                    alert('Bạn chưa nhập tên cán bộ. Hãy kiểm tra lại!');
                    txtCanBo.focus();
                    return false;
                }
            }
            var dropCanBo = document.getElementById('<%=dropCanBo.ClientID%>');
            var val = dropCanBo.options[dropCanBo.selectedIndex].value;
            if (val == 0) {
                var txtCanBo = document.getElementById('<%=txtCanBo.ClientID%>');
                if (!Common_CheckEmpty(txtCanBo.value)) {
                    alert('Bạn chưa nhập tên cán bộ. Hãy kiểm tra lại!');
                    txtCanBo.focus();
                    return false;
                }
            }
            //-------------------------
            return true;
        }

    </script>
    <script>

        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
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
</body>
</html>
