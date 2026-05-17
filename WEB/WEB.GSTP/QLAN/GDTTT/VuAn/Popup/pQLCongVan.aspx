<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="pQLCongVan.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pQLCongVan" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý công văn</title>
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

        .col1 {
            width: 110px;
        }

        .col2 {
            width: 250px;
        }

        .col3 {
            width: 105px;
        }
    </style>
</head>
<body>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                <asp:HiddenField ID="hddTuCachTT_BiHai_ID" runat="server" Value="0" />
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />

                <div class="box">
                    <div class="form_tt">
                       
                        <!-------------------------------------------------->
                        <div style="float: left; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Quản lý công văn</h4>
                            <div class="boder" style="padding: 2%; width: 96%; position: relative;">
                                <table class="table1">

                                    <tr>
                                        <td class="col1">Số thụ lý</td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtSoThuLy" runat="server"
                                                onkeypress="return isNumber(event)"
                                                CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                        </td>
                                        <td class="col3">Ngày thụ lý
                                        </td>
                                       <td> <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user"
                                            Width="230px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayThuLy" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td class="col1">Số CV<span class="batbuoc">(*)</span></td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtSoCV" runat="server"
                                                onkeypress="return isNumber(event)"
                                                CssClass="user" Width="242px" ></asp:TextBox>
                                        </td>
                                        <td class="col3">
                                            <asp:Label ID="lblNgayTH" runat="server" Text="Ngày CV"></asp:Label>
                                            <span class="batbuoc">(*)</span></td>
                                        <td><asp:TextBox ID="txtNgayCV" runat="server" CssClass="user"
                                            Width="230px" MaxLength="10" OnTextChanged="txtNgayCV_TextChanged"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayCV" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayCV" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <asp:Label ID="Label1" runat="server" Text="Ngày nhận"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNgaynhan" runat="server" CssClass="user"
                                                Width="242px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaynhan" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaynhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgaynhan" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </td>
                                       
                                        <td></td>   <td></td>
                                    </tr>
                                     <tr>
                                         <td>Tòa án chuyển <span class="batbuoc">(*)</span></td>
                                        <td><asp:DropDownList ID="dropToaAn"
                                                CssClass="chosen-select" runat="server" Width="250"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblTenDV" runat="server">Đơn vị chuyển CV</asp:Label><asp:Literal ID="lttValidTenDV" runat="server" Text="<span class='batbuoc'>(*)</span>"></asp:Literal></td>
                                        <td>
                                            <asp:TextBox ID="txtDonViChuyenCV" CssClass="user"
                                                runat="server" MaxLength="250" Width="230px"></asp:TextBox>
                                        </td>
                                    </tr>

                                  <tr>
                                        <td>TTV được phân công</td>
                                        <td>
                                            <asp:DropDownList ID="dropTTV"
                                                CssClass="chosen-select" runat="server" Width="250"></asp:DropDownList>
                                        </td>
                                        <td>Ngày phân công TTV<span class='batbuoc'>(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayPhanCongTTV" CssClass="user"
                                                runat="server" MaxLength="250" Width="230px"></asp:TextBox>
                                             <cc1:CalendarExtender ID="CalendarExtender4" runat="server" 
                                                 TargetControlID="txtNgayPhanCongTTV" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" 
                                                TargetControlID="txtNgayPhanCongTTV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" 
                                                ControlToValidate="txtNgayPhanCongTTV" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNoiDung" runat="server" CssClass="user"
                                                Width="602" ></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtGhiChu" runat="server" CssClass="user"
                                                Width="602px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3"><%--OnClick="cmdLamMoi_Click"--%>
                                            <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput"
                                                OnClientClick="return validate();"  Text="Lưu" OnClick="cmdSave_Click" />

                                            <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput"
                                                Text="Làm mới" />

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
                                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />

                                            <div class="phantrang">
                                                <div class="sobanghi" style="width: 40%; font-weight: bold; text-transform: uppercase;">
                                                    Danh sách tờ trình
                                                </div>
                                                <div style="float: right;">
                                                     <asp:Button ID="cmdThemToTrinh" runat="server"
                                                            CssClass="buttoninput"
                                                            Text="Thêm tờ trình" />
                                                       
                                                    <div style="display: none;">
                                                        <asp:Button ID="cmdPrinDS" runat="server"
                                                            CssClass="buttoninput"
                                                            Text="In danh sách" OnClientClick="PrintHS()" />
                                                        <div style="display: none;">
                                                            <asp:Button ID="cmdPrint2" runat="server" CssClass="buttoninput"
                                                                Text="Làm mới" OnClick="cmdPrint_Click" />
                                                        </div>
                                                    </div>
                                                    <asp:Panel ID="pnPagingTop" runat="server">
                                                        <div class="sotrang" style="width: 55%; display: none;">
                                                            <asp:TextBox ID="txtTextSearch" CssClass="user"
                                                                placeholder="Nhập tên cán bộ muốn tìm kiếm"
                                                                runat="server" MaxLength="250" Width="242px" Height="24px"></asp:TextBox>
                                                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput"
                                                                Text="Tìm kiếm" OnClick="Btntimkiem_Click" />

                                                            <div style="display: none;">
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
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td width="80px">
                                                        <div align="center"><strong>Thông tin CV</strong></div>
                                                    </td> 
                                                    <td>
                                                        <div align="center"><strong>Ngày nhận</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Tòa án</strong></div>
                                                    </td>
                                                    <td >
                                                        <div align="center"><strong>TTV được phân công</strong></div>
                                                    </td>
                                                  
                                                    <td width="70px">
                                                        <div align="center"><strong>Thao tác</strong></div>
                                                    </td>
                                                </tr>
                                                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><%# Eval("STT") %></div>
                                                            </td>
                                                            <td><%# Eval("SoCV") %> - <%# Eval("NgayCV") %></td>
                                                            <td><%# Eval("NGayNhan") %></td>
                                                            <td><%# Eval("ToaXX") %></td>
                                                            <td><%# Eval("TTV_HoTen") %></td>
                                                         
                                                            <td>
                                                                <div align="center">
                                                                    <asp:LinkButton ID="lkSua" runat="server"
                                                                        Text="Sửa" ForeColor="#0e7eee"
                                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;
                                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                        Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </table>
                                            <asp:Panel ID="pnPagingBottom" runat="server" Visible="false">
                                                <div class="phantrang_bottom">
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
                                        </td>
                                    </tr>
                                </table>
                            </div>
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
        function PrintHS() {
            var loaibm = 'ds';
            $("#<%= cmdPrint2.ClientID %>").click();
            var pageURL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=hoso&loai=" + loaibm
                + "&vID=<%=Request["vID"] %>";
            var title = 'In báo cáo';
            var w = 1000;
            var h = 600;
            var left = (screen.width / 2) - (w / 2) + 50;
            var top = (screen.height / 2) - (h / 2) + 50;
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function validate() {
            //--------------------------------
            var txtSoCV = document.getElementById('<%=txtSoCV.ClientID%>');
            if (!Common_CheckEmpty(txtSoCV.value)) {
                alert('Bạn chưa nhập số công văn. Hãy kiểm tra lại!');
                txtSoCV.focus();
                return false;
            }
            var txtNgayCV = document.getElementById('<%=txtNgayCV.ClientID%>');
            if (!CheckDateTimeControl(txtNgayCV, 'Ngày công văn'))
                return false;
            //----------------------------
            var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
            var val = dropToaAn.options[dropToaAn.selectedIndex].value;
            if (val == 0) {
                var txtDonViChuyenCV = document.getElementById('<%=txtDonViChuyenCV.ClientID%>');
                if (!Common_CheckEmpty(txtDonViChuyenCV.value)) {
                    alert('Bạn chưa nhập tên đơn vị gửi công văn. Hãy kiểm tra lại!');
                    txtDonViChuyenCV.focus();
                    return false;
                }
            }
         <%--   //-------------------------
            var dropTTV = document.getElementById('<%=dropTTV.ClientID%>');
            val = dropTTV.options[dropTTV.selectedIndex].value;
            if (val == 0) {
                var txtNgayPhanCongTTV = document.getElementById('<%=txtNgayPhanCongTTV.ClientID%>');
                if (!Common_CheckEmpty(txtTenTTV.value)) {
                    alert('Bạn chưa nhập tên thẩm tra viên. Hãy kiểm tra lại!');
                    txtTenTTV.focus();
                    return false;
                }
            }--%>
          //  alert(1);

            var txtNgayPhanCongTTV = document.getElementById('<%=txtNgayPhanCongTTV.ClientID%>');
            if (!CheckDateTimeControl(txtNgayPhanCongTTV, 'Ngày phân công TTV'))
                return false;
            //----------------------------
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
    
<script>

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
</body>
</html>
