<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pRutKN.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pRutKN" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Rút kháng nghị</title>
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
                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
               
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />

                <div class="box">
                    <div class="form_tt">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin vụ án</h4>
                             <div class="boder" style="padding: 2%; width: 96%;background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%);box-shadow:0 3px 7px rgba(0, 0, 0, 0.2);">
                            <table class="table_info_va">
                                    <tr>
                                        <td style="width: 110px;">Vụ án:</td>
                                        <td colspan="3" style="vertical-align:top;"><b>
                                            <asp:Literal ID="txtTenVuan" runat="server" ></asp:Literal></b>
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
                                            <td>Nguyên đơn/ Người khởi kiện:</td>
                                         </asp:Panel>
                                         <asp:Panel ID="pnBicaoDv" runat="server" Visible="false">
                                            <td>Bị cáo đầu vụ:</td>
                                         </asp:Panel>
                                        
                                        <td style="vertical-align:top;"><b>
                                            <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                        </td>
                                        <asp:Panel ID="pnBidon" runat="server">
                                        <td>Bị đơn/ Người  bị kiện:</td>
                                        </asp:Panel>
                                        <asp:Panel ID="pnBicaoKN" runat="server" Visible ="false">
                                            <td>Bị cáo khiếu nại:</td>
                                        </asp:Panel>
                                        <td style="vertical-align:top;"><b>
                                            <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <!-------------------------------------------------->
                        <div style="float: left; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Rút kháng nghị vụ án</h4>
                            <div class="boder" style="padding: 2%; width: 96%; position: relative;">
                                <table class="table1">

                                    <tr>
                                        <td style="width: 110px;">Rút kháng nghị?<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:RadioButtonList ID="rdRutKN" runat="server"
                                                Font-Bold="true" RepeatDirection="Horizontal"
                                                AutoPostBack="true" OnSelectedIndexChanged="rdRutKN_SelectedIndexChanged" >
                                            <asp:ListItem Value="0" Selected="True" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        </asp:RadioButtonList>
                                         
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <asp:Panel ID="pnRutKN" runat="server">
                                    <tr>
                                        <td>Số<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoPhieu" runat="server" 
                                                CssClass="user" Width="230px" MaxLength="100"></asp:TextBox>
                                        </td>
                                        <td style="width: 105px">
                                            <asp:Label ID="lblNgayTH" runat="server" Text="Ngày"></asp:Label>
                                            <span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayTaoPhieu" runat="server" CssClass="user"                                                 
                                                AutoPostBack ="true" OnTextChanged ="txtNgayTaoPhieu_TextChanged"
                                                Width="230px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayTaoPhieu" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayTaoPhieu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayTaoPhieu" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                       <%-- <td>Người rút</td>
                                        <td>
                                            <asp:DropDownList ID="dropCanBo"
                                                CssClass="chosen-select" runat="server" Width="250"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropCanBo_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>--%>
                                        <td>
                                            <asp:Label ID="lblHoTen" runat="server">Người rút KN</asp:Label>
                                            <asp:Literal ID="lttValidHoTen" runat="server" Text="<span class='batbuoc'>(*)</span>"></asp:Literal></td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtCanBo" CssClass="user"
                                                runat="server" MaxLength="250" Width="230px"></asp:TextBox>
                                        </td>
                                    </tr>
                                        </asp:Panel>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateAndNext" runat="server" CssClass="buttoninput"
                                                Text="Lưu"
                                                OnClientClick="return validate();" OnClick="cmdUpdateAndNext_Click" />
                                          
                                            <asp:Button ID="cmdXoaRutKN" runat="server" 
                                                CssClass="buttoninput" Text="Xóa rút kháng nghị"
                                                OnClick="cmdXoaRutKN_Click" Visible="false"/>

                                            <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                        </td>
                                    </tr>

                                   
                                    <tr>
                                        <td colspan="4">
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
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
        function ReloadParent() {
            window.onunload = function (e) {
                opener.LoadDsDon();
            };
        }
    </script>
    <script>
        function validate()
        {
            var rdRutKN = document.getElementById('<%=rdRutKN.ClientID%>');
            selected_value = GetStatusRadioButtonList(rdRutKN);
           
            if (selected_value != 0) {

                var txtSoPhieu = document.getElementById('<%=txtSoPhieu.ClientID%>');
                if (!Common_CheckEmpty(txtSoPhieu.value)) {
                    alert('Bạn chưa nhập số phiếu. Hãy kiểm tra lại!');
                    txtSoPhieu.focus();
                    return false;
                }
                var txtNgayTaoPhieu = document.getElementById('<%=txtNgayTaoPhieu.ClientID%>');
                if (!CheckDateTimeControl(txtNgayTaoPhieu, 'Ngày rút'))
                        return false;
                //-------------------------
                    var txtCanBo = document.getElementById('<%=txtCanBo.ClientID%>');
                    if (!Common_CheckEmpty(txtCanBo.value)) {
                        alert('Bạn chưa nhập tên người rút KN. Hãy kiểm tra lại!');
                        txtCanBo.focus();
                        return false;
                    }
            }
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
