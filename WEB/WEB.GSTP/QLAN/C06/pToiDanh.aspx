<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pToiDanh.aspx.cs" Inherits="WEB.GSTP.QLAN.C06.pToiDanh" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Điều luật áp dụng cho bị cáo</title>
    <link href="../../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../../UI/js/Common.js"></script>
    <link href="../../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../../UI/js/jquery-ui.min.js"></script>

    <script src="../../../../../UI/js/chosen.jquery.js"></script>
    <style>
        body {
            width: 95%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 750px;
            overflow: auto;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .row_change, .row_change td {
            background: yellow;
        }

        .row_no_change {
            background: white;
        }

        .align_right {
            text-align: right;
        }


        .title_hp {
            font-weight: bold;
            text-transform: uppercase;
            float: left;
            width: 100%;
            margin-bottom: 5px;
            border-top: dashed 1px #dcdcdc;
            padding-top: 10px;
            margin-top: 10px;
        }

        .margin_top {
            margin-top: 5px;
            float: left;
        }

        .span_date {
            margin-right: 5px;
        }

        #tblHP tr, td {
            vertical-align: top;
            padding-bottom: 2px;
        }

            #tblHP tr, td a {
                color: #333;
            }

        /*.buttoninput {
            float: left;
            margin-right: 5px;
        }*/

        .highlightRow {
            background-color: yellow;
        }

        .gridview {
            border-collapse: collapse;
            width: 100%;
        }

            .gridview th {
                background-color: red;
                color: white;
                border: 1px solid black;
                padding: 6px;
                text-align: center;
            }

            .gridview td {
                border: 1px solid black;
                padding: 6px;
            }

            .gridview tr:nth-child(even) {
                background-color: #f9f9f9;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server" enableviewstate="true">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddStatusAnTreo" Value="0" runat="server" />
                <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
                <asp:HiddenField ID="hddID" runat="server" Value="0" />
                <asp:HiddenField ID="hddCurrToiDanhID" runat="server" Value="0" />
                <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <!-------------------------->

                <div class="box">
                    <div class="box_nd">
                        <div>
                            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                            </div>
                            <div class="boxchung" style="left: unset !important">
                                <h4 class="tleboxchung">Điều luật áp dụng cho bị cáo</h4>
                                <div class="boder">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 65px;"><b>Tên bị cáo: </b><strong>
                                                <asp:Label ID="lblTenBiCao" runat="server"></asp:Label></strong></td>

                                        </tr>
                                    </table>
                                </div>


                                <asp:Panel runat="server" ID="pndata" Visible="true">

                                    <asp:Repeater ID="rpt" runat="server"
                                        OnItemCommand="rpt_ItemCommand"
                                        OnItemDataBound="rpt_ItemDataBound">
                                        <HeaderTemplate>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td width="10%">
                                                        <div align="center"><strong>Tên bộ luật</strong></div>
                                                    </td>
                                                    <td width="50px">
                                                        <div align="center"><strong>Điều</strong></div>
                                                    </td>
                                                    <td width="50px">
                                                        <div align="center"><strong>Khoản</strong></div>
                                                    </td>
                                                    <td width="50px">
                                                        <div align="center"><strong>Điểm</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Tội danh</strong></div>
                                                    </td>
                                                </tr>
                                        </HeaderTemplate>

                                        <ItemTemplate>
                                            <asp:Panel ID="pnRow" runat="server">
                                                <tr class="trclass">
                                                    <!-- STT -->
                                                    <td>
                                                        <%# Container.ItemIndex + 1 %>
                                                    </td>

                                                    <td>
                                                        <asp:Label ID="lblTenBoLuat" runat="server"
                                                            Text='<%#Eval("TenBoLuat") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblDieu" runat="server"
                                                            Text='<%#Eval("Dieu") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblKhoan" runat="server"
                                                            Text='<%#Eval("Khoan") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblDiem" runat="server"
                                                            Text='<%#Eval("Diem") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblToiDanh" runat="server"
                                                            Text='<%#Eval("TenToiDanh") %>'></asp:Label>
                                                    </td>
                                                </tr>
                                            </asp:Panel>
                                        </ItemTemplate>

                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>

                                </asp:Panel>
                                <asp:Panel ID="pnHinhPhat" runat="server" Visible="true">


                                    <asp:GridView ID="gvHinhPhat" runat="server"
                                        AutoGenerateColumns="False"
                                        CssClass="gridview"
                                        GridLines="None"
                                        CellPadding="4"
                                        Width="100%"
                                        ShowHeader="true">
                                        <Columns>

                                            <asp:TemplateField HeaderText="STT">
                                                <ItemTemplate>
                                                    <%# Container.DataItemIndex + 1 %>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                                            </asp:TemplateField>


                                            <asp:BoundField DataField="loaiHinhPhat" HeaderText="Loại Hình Phạt" />


                                            <asp:BoundField DataField="maHinhPhat" HeaderText="Mã Hình Phạt" />


                                            <asp:BoundField DataField="tenHinhPhat" HeaderText="Tên Hình Phạt" />


                                            <asp:BoundField DataField="thamSoHinhPhat" HeaderText="Tham Số Hình Phạt" />
                                        </Columns>
                                    </asp:GridView>

                                </asp:Panel>
                            </div>

                        </div>
                    </div>
                </div>

                <script src="../../../../../UI/js/init.js"></script>
                <script>

                    function ValidateThemDL() {

                        return true;
                    }

                </script>
                <script>
                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }
                    function popupChonToiDanh() {
                        var width_popup = 750;
                        var height_popup = 800;
                        var link = "/QLAN/AHS/SoTham/BanAnST/Popup/pChonToiDanh.aspx?aID=<%=BanAnID%>&bID=<%=BiCanID%>";
                        OpenPopup(link, "Chọn tội danh", width_popup, height_popup);
                    }
                    function OpenPopup(pageURL, title, w, h) {
                        var left = (screen.width / 2) - (w / 2);
                        var top = (screen.height / 2) - (h / 2);
                        var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                        return targetWin;
                    }


                    function ReloadParent() {
                        window.opener.parent.Loadds_bicao();
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
