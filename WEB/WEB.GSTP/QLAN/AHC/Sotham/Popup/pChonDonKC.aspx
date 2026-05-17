<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="pChonDonKC.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.Sotham.Popup.pChonDonKC" ValidateRequest="false" %>

<%--MasterPageFile="~/MasterPages/GSTP.Master"--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật quyết định và hình phạt</title>

    <link href="../../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../../UI/js/Common.js"></script>
    <link href="../../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../../UI/js/jquery-ui.min.js"></script>

    <script src="../../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <style type="text/css">
                    body {
                        width: 98%;
                        margin-left: 1%;
                        min-width: 0px;
                        overflow-y: hidden;
                        overflow-x: auto;
                    }

                    .tdWidthTblToaAn {
                        width: 120px;
                    }

                    .check_list_vertical table td {
                        padding-right: 15px;
                    }

                    .boxchung {
                        height: 750px;
                        overflow: auto;
                    }
                </style>
                <div class="boxchung">
                    <h4 class="tleboxchung">Chọn đơn kháng cáo</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td class="KCHNCol1">Tên người kháng cáo</td>
                                <td class="KCHNCol2">
                                    <asp:DropDownList ID="ddlNguoikhangcao" CssClass="chosen-select" Enabled="false" runat="server" Width="250px"></asp:DropDownList>
                                </td>
                            </tr>
                                <td colspan="4">
                                    <asp:Panel runat="server" ID="pndata" Visible="false">
                                        <div class="phantrang">
                                            <div class="sobanghi">
                                            </div>
                                            <div class="sotrang">
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
                                        <asp:HiddenField ID="hddOld" runat="server" Value="" />
                                        <asp:Repeater ID="rpt" runat="server" OnItemDataBound="rpt_ItemDataBound"
                                            OnItemCommand="rpt_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table2" width="100%" border="1">
                                                    <tr class="header">
                                                        <td width="42px">
                                                            <div align="center"><strong>TT</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Loại kháng cáo</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Ngày kháng cáo</strong></div>
                                                        </td>
                                                        <td width="80px">
                                                            <div align="center"><strong>Ngày viết đơn</strong></div>
                                                        </td>
                                                        <td width="200px">
                                                            <div align="center"><strong>Nội dung kháng cáo</strong></div>
                                                        </td>
                                                        <td width="42px">
                                                            <div align="center"><strong>Thao tác</strong></div>
                                                        </td>
                                                    </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td align="center"><%# Eval("STT") %></td>
                                                    <td><%# Eval("LOAIKHANGCAO") %></td>
                                                    <td align="center"><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYKHANGCAO")) %></td>
                                                    <td align="center"><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYVIETDONKC")) %></td>
                                                    <td><%# Eval("NOIDUNGDON") %></td>
                                                    <td align="center">
                                                        <asp:LinkButton ID="lblChon" runat="server" Text="Chọn" ForeColor="#0e7eee"
                                                        CausesValidation="false" CommandName="chon" ToolTip='<%#Eval("ID") %>'
                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                    </td>
                                                    <%-- <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>--%>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate></table></FooterTemplate>
                                        </asp:Repeater>

                                        <div class="phantrang">
                                            <div class="sobanghi">
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
                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                </div>
                <script type="text/javascript">
                    function pageLoad(sender, args) {

                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }
                    function ClosePopup() {
                   <%-- var link = "/QLAN/AHS/SoTham/BanAnST/popup/pToiDanh.aspx?aID=<%=BanAnID%>&bID=<%=BiCaoID%>";
                    window.location.href = link;--%>
                        window.close();
                    }
                </script>
                <script type="text/javascript">
                    function Close() {
                        window.opener.parent.Loadthongtindon();
                        window.close();
                    }
                </script>
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
</body>
</html>
