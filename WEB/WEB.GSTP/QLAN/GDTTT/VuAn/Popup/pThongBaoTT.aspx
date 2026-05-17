<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pThongBaoTT.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pThongBaoTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông báo tình thế</title>
    <%--<link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>--%>
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

        .col1 {
            width: 110px;
        }

        .col2 {
            width: 206px;
        }

        .col3 {
            width: 105px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="boxchung">
                    <asp:HiddenField ID="hddThongBaoID" runat="server" Value="0" />
                    <asp:HiddenField ID="hddReloadParent" runat="server" Value="0" />
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
                                    <td><asp:Label ID="lblTitleBCDV" runat="server" Text="Nguyên đơn/ Người khởi kiện"></asp:Label>
                                        :</td>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                    </td>
                                    <td><asp:Label ID="lblTitleBC" runat="server" Text="Bị đơn/ Người  bị kiện"></asp:Label>
                                        :</td>
                                    <td style="vertical-align: top;"><b>
                                        <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <!-------------------------------------------------->

                    <div style="float: left; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông báo tình thế</h4>
                        <div class="boder" style="padding: 10px;">
                            <asp:Repeater ID="rptTB" runat="server"  OnItemCommand="rptTB_ItemCommand">
                                <HeaderTemplate>
                                    <table class="table2" width="100%" border="1">
                                        <tr class="header">
                                            <td width="40px">
                                                <div align="center"><strong>TT</strong></div>
                                            </td>
                                            <td width="150px">
                                                <div align="center"><strong>Cơ quan/Đơn vị</strong></div>
                                            </td>

                                            <td width="80px">
                                                <div align="center"><strong>Số</strong></div>
                                            </td>
                                            <td width="80px">
                                                <div align="center"><strong>Ngày</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Ghi chú</strong></div>
                                            </td>
                                            <td width="40px"></td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%# Container.ItemIndex + 1 %>
                                        </td>
                                        <td>
                                            <asp:HiddenField ID="hddDonID" runat="server" Value='<%#Eval("DonID") %>' />
                                            <asp:HiddenField ID="hddThongBaoID" runat="server" Value='<%#Eval("ThongBaoID") %>' />

                                            <asp:Literal ID="lttCQChuyenDon" runat="server" Text='<%#Eval("TenCQChuyenDon") %>'></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSo" onkeypress="return isNumber(event)" Text='<%#Eval("So") %>'
                                                runat="server" CssClass="user" Width="70px" MaxLength="50"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNgay" runat="server"
                                                onkeypress="return isNumber(event)" Text='<%#Eval("NGay") %>'
                                                CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtGhiChu" Text='<%#Eval("GhiChu") %>'
                                                runat="server" CssClass="user" Width="90%"></asp:TextBox>
                                        </td>
                                        <td>
                                            <div align="center">
                                                <div class="tooltip">
                                                    <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ThongBaoID") %>'
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

                            <!--------------------------------->
                            <div style="width: 100%;">
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <span style="float: left; width: 100%;">
                                    <asp:Label runat="server" Font-Bold="true" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                </span>
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                    Text="Lưu" OnClick="cmdUpdate_Click" />

                                <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                            </div>
                        </div>
                    </div>
                </div>
                <%--  <asp:Repeater ID="rpt" runat="server"
                    OnItemCommand="rpt_ItemCommand">
                    <HeaderTemplate>
                        <table class="table2" width="100%" border="1">
                            <tr class="header">
                                <td width="40px">
                                    <div align="center"><strong>STT</strong></div>
                                </td>
                                <td width="80px">
                                    <div align="center"><strong>Số</strong></div>
                                </td>
                                <td width="80px">
                                    <div align="center"><strong>Ngày</strong></div>
                                </td>

                                <td>
                                    <div align="center"><strong>Ghi chú</strong></div>
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
                            <td><%# Container.ItemIndex + 1 %></td>

                            <td><%# Eval("So") %></td>
                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGay")) %></td>

                            <td><%# String.IsNullOrEmpty(Eval("NGuoiNhan")+"")? "": ((Eval("NGuoiNhan")+"" )
                                                                                                                 + (String.IsNullOrEmpty(Eval("NGuoiNhan")+"")?"":"<br/>")
                                                                                                                ) %>
                                <%# Eval("GhiChu") %></td>
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
                </asp:Repeater>--%>
                <script>

                    function ReloadParent() {
                        window.onunload = function (e) {
                            opener.LoadDsDon();
                        };
                    }
                </script>
                <script>
                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }</script>
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

<script>

                    Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
                    function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
