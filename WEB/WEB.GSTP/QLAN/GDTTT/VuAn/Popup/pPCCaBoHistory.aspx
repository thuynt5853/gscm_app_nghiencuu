<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="pPCCaBoHistory.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pPCCaBoHistory" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quá trình luân chuyển hồ sơ</title>
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
                <asp:HiddenField ID="hddVuAn_ToaAnID" runat="server" Value="0" />
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
                <div class="box">
                    <div class="form_tt">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin vụ án</h4>
                            <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                                <table class="table_info_va">
                                    <tr>
                                        <td style="width: 110px;">Vụ án:</td>
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
                                        <td>Nguyên đơn/ Người khởi kiện:</td>
                                        <td style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                        </td>
                                        <td>Bị đơn/ Người  bị kiện:</td>
                                        <td style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <!-------------------------------------------------->
                        <div style="float: left; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Danh sách</h4>
                            <div class="boder" style="padding: 2%; width: 96%; position: relative;">
                                <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />

                                <table class="table2" width="100%" border="1">
                                    <tr class="header">
                                        <td width="42">
                                            <div align="center"><strong>TT</strong></div>
                                        </td>
                                        <td width="110px">
                                            <div align="center"><strong>Ngày phân công</strong></div>
                                        </td>
                                       
                                        <td>
                                            <div align="center"><strong>TTV/LĐ/TP</strong></div>
                                        </td>
                                        <td width="70px">
                                            <div align="center"><strong>Thao tác</strong></div>
                                        </td>
                                    </tr>
                                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                                        <ItemTemplate>
                                            <tr>
                                                <td><div align="center"> <%# Eval("STT") %></div></td>
                                                <td><%#Eval("TuNgay") %></td>
                                               
                                                <td><%# Eval("TenCanBo") %></td>
                                                <td>
                                                    <div align="center">
                                                     
                                                         <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa"
                                                             ForeColor="#0e7eee" CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                             OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
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
        <%--function PrintList() {
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

        function Print(hosoID, type) {
            //alert(hosoID);
            var pageURL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=hoso";
            if (type == 1)
                pageURL += "&loai=mHS" + "&vID=<%=Request["vID"] %>&gID=" + hosoID;
            else 
                pageURL += "&loai=bm" + "&vID=<%=Request["vID"] %>&hsID=" + hosoID;
            var title = 'In báo cáo';
            var w = 1000;
            var h = 600;
            var left = (screen.width / 2) - (w / 2) + 50;
            var top = (screen.height / 2) - (h / 2) + 50;
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        }--%>



</script>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

    <script>

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

    </script>
</body>
</html>
