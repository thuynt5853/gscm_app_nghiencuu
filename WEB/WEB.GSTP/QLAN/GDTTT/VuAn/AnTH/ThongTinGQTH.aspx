<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ThongTinGQTH.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.ThongTinGQTH" %>


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

        .row_info {
            float: left;
            width: 100%;
            vertical-align: top;
            margin-bottom: 3px;
        }

        .cell_info {
            float: left;
            vertical-align: top;
        }

        .margin_left {
            margin-left: 5px;
        }
    </style>
    <form id="form1" runat="server">
       <%-- ///--%>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="boxchung" id="thongtingiaiquyetxinangiam">
                    <div style="text-align: center; margin-bottom: 15px; width: 100%; position: relative;">
                        <input type="button" class="buttoninput" onclick="PrintContent()" value="In" />
                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                    </div>
                    <div style="float: left; margin-bottom: 15px; width: 100%; position: relative;" id="zone_vuan_info">
                        <div>
                            <table class="table_info_va">
                                <tr>
                                    <td colspan="4" style="text-transform: uppercase; font-weight: bold; text-align: center;">Thông tin giải quyết đơn xin ân giảm
                                    </td>
                                </tr>
                                <tr>
                                    <%--<td class="col_stt">1</td>--%>
                                    <td class="col1">Vụ án</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttTenVuAn" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <%-- <td class="col_stt">2</td>--%>
                                    <td class="col1">Số, ngày BA/QĐ bị đề nghị</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttBanAnPT" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <%--<td class="col_stt">3</td>--%>
                                    <td class="col1">Tòa xét xử</td>
                                    <td colspan="3">
                                        <asp:Literal ID="lttToaXuPT" runat="server"></asp:Literal></td>
                                </tr>
                                <asp:Panel ID="pnAnST" runat="server">
                                    <tr>
                                        <%--<td class="col_stt">4</td>--%>
                                        <td class="col1">Số ngày bản án ST, tòa xx ST (nếu có)</td>
                                        <td colspan="3">
                                            <asp:Literal ID="lttBanAnST" runat="server"></asp:Literal></td>
                                    </tr>
                                </asp:Panel>
                               
                                <tr>
                                    <%--<td class="col_stt">6</td>--%>
                                    <td class="col1" style="vertical-align: top;">Bị án</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lttBiAn" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <%-- <td class="col_stt">8</td>--%>
                                    <td class="col1">Ngày nhận đơn</td>
                                    <td colspan="3">
                                         <asp:Literal ID="lblNgaynhandon" runat="server"></asp:Literal>
                                         
                                         <asp:Literal ID="lblNgaynhandon_hctp" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <%-- <td class="col_stt">9</td>--%>
                                    <td class="col1">Người gửi đơn</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lblNguoguidon_vu" runat="server"></asp:Literal>
                                        <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                               
                                <tr>
                                    <%--<td class="col_stt">13</td>--%>
                                    <td class="col1">Thẩm phán được phân công GQ</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lttTP" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <%--<td class="col_stt">14</td>--%>
                                    <td class="col1">Thẩm tra viên được phân công GQ</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lttTTV" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <%--<td class="col_stt">15</td>--%>
                                    <td class="col1">Lãnh đạo Vụ phụ trách</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lttLD" runat="server"></asp:Literal>
                                    </td>
                                </tr>

                                <tr>
                                    <%--<td class="col_stt">16</td>--%>
                                    <td class="col1">Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo</td>
                                    <td style="vertical-align: top;" colspan="3">
                                        <asp:Literal ID="lttNgayTTVNhanTHS" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <%-- <td class="col_stt">17</td>--%>
                                    <td class="col1">Ngày mượn hồ sơ</td>
                                    <td colspan="3">
                                        <asp:Repeater ID="rptHoSo" runat="server">
                                            <ItemTemplate>
                                                <div class="row_info">
                                                    <div style="float: left; width: 75px; vertical-align: top;"><%# Eval("LoaiPhieu")%></div>
                                                    <div style="margin-left: 5px; float: left; vertical-align: top;">
                                                        <%# String.IsNullOrEmpty(Eval("SoPhieu")+"")? "":("số " +Eval("SoPhieu")) %>
                                                        <%# String.IsNullOrEmpty(Eval("NgayTao")+"")? "":("<span style='margin-left:3px;'>ngày " +Eval("NgayTao")+"</span>") %>
                                                        <%# String.IsNullOrEmpty(Eval("TenCanBo")+"")? "":("<span style='margin-left:5px;'>Cán bộ " +Eval("TenCanBo")+"</span>") %>
                                                        <%# String.IsNullOrEmpty(Eval("GhiChu")+"")? "":("<span style='margin-left:5px;'>" +Eval("GhiChu")+"</span>") %>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>
                                <!-------------------------------------------------->

                                <asp:Panel ID="pnTTVNhanHS" runat="server">
                                    <tr>
                                        <%--<td class="col_stt">18</td>--%>
                                        <td class="col1">Ngày TTV nhận hồ sơ</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttNgayTTVNhanHS" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnNgayTraHS" runat="server">
                                    <tr>
                                        <%--<td class="col_stt">19</td>--%>
                                        <td class="col1">Ngày trả hồ sơ</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttNgayTraHS" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnNgayChuyenHS" runat="server">
                                    <tr>
                                        <%-- <td class="col_stt">20</td>--%>
                                        <td class="col1">Ngày chuyển hồ sơ</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttNgayChuyenHS" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <!-------------------------------------------------->
                                <tr>
                                    <%-- <td class="col_stt">21</td>--%>
                                    <td class="col1">Thông tin tờ trình</td>
                                    <td colspan="3">
                                        <asp:Repeater ID="rptToTrinh" runat="server">
                                            <ItemTemplate>
                                                <div class="row_info">
                                                    <div style="float: left; width: 150px; vertical-align: top;"><%# Eval("StrNgayTrinh")%></div>
                                                    <div style="margin-left: 5px; float: left; vertical-align: top;"><%# Eval("TENTINHTRANG") %></div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <div style="float: left; width: 100%; margin-top: 5px;">
                                            <asp:Literal ID="lttToTrinh" runat="server"></asp:Literal>
                                        </div>
                                    </td>
                                </tr>
                               
                                <!-------------------------------------------------->
                                <asp:Panel ID="pnChanhAn" runat="server">
                                    <tr>
                                        <%-- <td class="col_stt">22</td>--%>
                                        <td class="col1">Quyết định của Chánh án</td>
                                        <td colspan="3">
                                            <asp:Literal ID="lttLoaiKQCA" runat="server"></asp:Literal>
                                            <br />
                                            <asp:Literal ID="lttTTCA" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <!-------------------------------------------------->
                                <asp:Panel ID="Panel1" runat="server">
                                    <tr>
                                        <%-- <td class="col_stt">23</td>--%>
                                        <td class="col1">Quyết định của Viện kiểm sát</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttKLVKS" runat="server"></asp:Literal>
                                         
                                        </td>
                                    </tr>
                                </asp:Panel>
                                 <!-------------------------------------------------->
                                <asp:Panel ID="Panel2" runat="server">
                                    <tr>
                                        <%-- <td class="col_stt">23</td>--%>
                                        <td class="col1">Quyết định của Chủ Tịch Nước</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttVPCTN" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>                               
                                <!-------------------------------------------------->
                                 <asp:Panel ID="Panel3" runat="server">
                                    <tr>
                                        <%-- <td class="col_stt">23</td>--%>
                                        <td class="col1">Xác minh</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttCVXM" runat="server"></asp:Literal>
                                            <br />
                                            <asp:Literal ID="lttKQXM" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>  
                               
                                <!-------------------------------------------------->
                                 <asp:Panel ID="Panel6" runat="server">
                                    <tr>
                                        <%-- <td class="col_stt">23</td>--%>
                                        <td class="col1">Kết quả Thi hành án</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttKQTHA" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>  
                                <!-------------------------------------------------->
                                 <asp:Panel ID="Panel7" runat="server">
                                    <tr>
                                        <%-- <td class="col_stt">23</td>--%>
                                        <td class="col1">Thông tin lưu hồ sơ</td>
                                        <td style="vertical-align: top;" colspan="3">
                                            <asp:Literal ID="lttLuuHS" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <!-------------------------------------------------->
                                <tr>
                                    <%--  <td class="col_stt">27</td>--%>
                                    <td><b>Ghi chú</b></td>
                                    <td colspan="3" style="vertical-align: top;">
                                        <asp:Literal ID="lttGhiChu" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <!-------------------------------------------------->
                    <div style="text-align: center; margin-bottom: 15px; width: 100%;">
                        <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                        <%-- <div style="display: none;">
                            <asp:Button ID="cmdReLoad" runat="server" CssClass="buttoninput"
                                Text="Tìm kiếm" OnClick="cmdReLoad_Click" />
                        </div>--%>
                    </div>
                </div>
                <script>
                    function OpenPopup(form_name) {
                        //alert(form_name);
                        var VuAnID = '<%=VuAnID%>';
                        var pageURL = "/QLAN/GDTTT/VuAn/Popup/";//QLTotrinh.aspx?vid=";
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
                    <%--//----------------------------
                    function LoadDsDon() {
                        $("#<%= cmdReLoad.ClientID %>").click();
                    }--%>
                    function PrintContent() {
                        var divContents = document.getElementById('zone_vuan_info').innerHTML;
                        this.print();
                        //var a = window.open('', '', 'height=500, width=500');
                        //a.document.write('<html>');
                        //a.document.write("<head><link href='../../../../UI/css/style.css' rel='stylesheet'/></head>");
                        //a.document.write("<body style='width: 98 %; margin-left:1%; '>");
                        //a.document.write(divContents);
                        //a.document.write('</body></html>');
                        //a.document.close();
                        //a.print();
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
