<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pNhapQuyetDinh.aspx.cs" Inherits="WEB.GSTP.QLAN.ADS.Hoso.Popup.pNhapQuyetDinh" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Nhập quyết định</title>

    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>

    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Nhập quyết định</h4>
                            <div class="boder" style="padding: 10px;">
                                <asp:HiddenField ID="hdfNgayNhanDon" runat="server" Value="" />
                                <table class="table1">
                                    <asp:Panel ID="pnNDCanhan" runat="server">
                                        <tr>
                                            <td style="width: 123px;">Ngày quyết định<span class="batbuoc">(*)</span></td>
                                              <td>
                                                 <asp:TextBox ID="txtNgayquyetdinh" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                             <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayquyetdinh" Format="dd/MM/yyyy" BehaviorID="_content_CalendarExtender1" />
                                             <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayquyetdinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" BehaviorID="_content_MaskedEditExtender1" Century="2000" CultureAMPMPlaceholder="SA;CH" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                              </td>
                                              <td class="QDVACol3"> Số Quyết định<span class="batbuoc">(*)</span></td>
                                                  <td>
        
                                                      <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="100px" MaxLength="20"></asp:TextBox>
                                                  </td>
                                            <td>Người ký</td>
                                            <td>
                                                <asp:TextBox ID="txtNguoiKy" CssClass="user"  runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                  
                                    </asp:Panel>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <div>
                                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" align="center">
                                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />

                                            <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
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
        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '60%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
            function Setfocus(controlid) {
                var ctrl = document.getElementById(controlid);
                ctrl.focus();
            }
            function ReloadParent() {
                window.onunload = function (e) {
                    opener.LoadDs();
                };
                window.close();
            }
        </script>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
