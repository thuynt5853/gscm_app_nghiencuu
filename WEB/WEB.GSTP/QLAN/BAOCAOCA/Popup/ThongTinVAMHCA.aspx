<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ThongTinVAMHCA.aspx.cs" Inherits="WEB.GSTP.QLAN.BAOCAOCA.Popup.ThongTinVAMHCA" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin vụ án</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
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
                <div class="boxchung" id="thongtinvuan">
                    <div style="text-align: center; margin-bottom: 15px; width: 100%; position: relative;display:none;">
                        <asp:Button ID="cmdPrintContent" runat="server" CssClass="buttoninput" Text="In"/>
                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                    </div>
                    <div style="float: left; margin-bottom: 15px; width: 100%; position: relative;" id="zone_vuan_info" runat="server">
                        <div>
                            <table class="table_info_va">
                                <tr>
                                    <td colspan="4" style="text-transform: uppercase; font-weight: bold; text-align: center;">Thông tin chi tiết vụ án
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">Loại án</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttLoaiAn" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">BA/QĐ bị đề nghị GĐT</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttBanAnDenghi" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">Tòa xét xử</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttToaXuDenghi" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td id="txtNguyenDon" runat="server" class="col1">Nguyên đơn</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="txtBiDon" runat="server" class="col1" style="vertical-align: top;">Bị đơn</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="txtQHPL" runat="server" class='col1'>Quan hệ pháp luật</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lttQHPL" runat="server"></asp:Literal></td>
                                </tr>
                                <tr>
                                    <td class="col1">Số, ngày Thụ lý đơn đề nghị GĐT,TT</td>
                                    <td colspan="3">
                                        <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">Người khiếu nại</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lttVuAn_NguoiKhieuNai" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col1">Kết quả giải quyết đơn</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttGQDThongTin" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <!-------------------------------------------------->
                                <asp:Panel ID="pnNgayNhanHSTuVKS" runat="server">
                                    <tr>
                                        <td class="col1">Ngày nhận hồ sơ từ VKS</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttNgayNhanHS_VKS" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnNgayThuLyXXGDT" runat="server">
                                    <tr>
                                        <td class="col1">Thông tin thụ lý xét xử GĐT, TT</td>
                                        <td colspan="3" style="vertical-align: top;">
                                            <asp:Literal ID="lttThuLyXXGDTTT" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>
                        </div>
                    </div>
                    <!-------------------------------------------------->
                    <div style="text-align: center; margin-bottom: 15px; width: 100%;">
                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                    </div>
                </div>
                <script>
                    function OpenPopup(form_name) {
                        var VuAnID = '<%=VuAnID%>';
                        var pageURL = "/QLAN/GDTTT/VuAn/Popup/";
                        var title = "";
                        if (form_name == "QLTotrinh.aspx")
                            title = "Quản lý tờ trình";
                        else
                            title = "Quản lý hồ sơ";
                        pageURL = pageURL + form_name + "?vid=" + VuAnID;

                        var w = 1000;
                        var h = 700;
                        var left = (screen.width / 2) - (w / 2) - 50;
                        var top = (screen.height / 2) - (h / 2) - 20;
                        var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                        return targetWin;
                    }
                    function PrintContent() {
                        var divContents = document.getElementById('zone_vuan_info').innerHTML;
                        this.print();
                    }
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                        &nbsp;&nbsp;
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
</body>
</html>
