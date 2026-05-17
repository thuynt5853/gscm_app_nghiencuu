<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="p_ToiDanh_cc.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.p_ToiDanh_cc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thêm sửa tội danh</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 550px;
            overflow: auto;
            position: absolute;
            top: 65px;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .align_right {
            text-align: right;
        }

        .link_save {
            margin-left: 0px;
            margin-right: 5px;
        }

        .button_empty {
            border: 1px solid red;
            border-radius: 4px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            color: #044271;
            background: white;
            float: left;
            font-size: 12px;
            font-weight: bold;
            line-height: 23px;
            padding: 0px 5px;
            margin-left: 3px;
            margin-bottom: 8px;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
        <asp:HiddenField ID="hddGUID" runat="server" Value="" />
        <asp:HiddenField ID="hddNext" runat="server" Value="0" />
        <asp:HiddenField ID="hddIsAnPT" runat="server" Value="PT" />
        <asp:HiddenField ID="hddInputAnST" runat="server" Value="0" />
        <asp:HiddenField ID="hddBiCaoID" runat="server" />
        <asp:HiddenField ID="hddBiCaoDuocKN" runat="server" />
        <asp:HiddenField ID="hddBiCaoDuocKN_New" runat="server" />
        <div class="boxchung">
            <h4 class="tleboxchung">Bị cáo: <label id="lblTenBicao" runat="server"></label> </h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td>
                            <div style="float: left; width: 819px; margin-top: 10px;">
                                <div style="float: left; width: 100px; text-align: right; margin-top: 4px;">Tội danh</div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:DropDownList ID="dropBiCao_ToiDanh" runat="server"
                                        CssClass="chosen-select" Width="510px">
                                    </asp:DropDownList>
                                </div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:LinkButton ID="lkBiCao_SaveToiDanh" runat="server"
                                        OnClick="lkBiCao_SaveToiDanh_Click"
                                        CssClass="button_empty" ToolTip="Thêm tội danh">Thêm tội danh</asp:LinkButton>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div style="color: red; font-size: 15px; text-align: center;">
                                <asp:Literal ID="lttMsgBC" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:726px;float:left;">
                            <asp:Repeater ID="rptToiDanh" runat="server" Visible="false" OnItemCommand="rptToiDanh_ItemCommand">
                                <HeaderTemplate>
                                    <div class="title_ds">Danh sách tội danh</div>
                                    <table class="table2" style="width: 100%;" border="1">
                                </HeaderTemplate>
                               
                                <ItemTemplate>
                                    <tr>
                                        <td style="width: 30px; text-align: center;"><%# Container.ItemIndex + 1 %></td>
                                        <td>
                                            <asp:HiddenField runat="server" ID="hddDSToiDanhID" Value='<%#Eval("ID") %>' />
                                            <%#Eval("TenToiDanh") %></td>
                                        <td style="width: 150px">
                                              <asp:CheckBox 
                                                    ID="chkChon"
                                                    runat="server"
                                                    AutoPostBack="true"
                                                    OnCheckedChanged="chkChon_CheckedChanged"
                                                    Checked='<%# Convert.ToInt32(Eval("ISMAIN")) == 1 %>' />
                                                Là tội danh chính
                                        </td>
                                        <td style="width: 20px">
                                            <asp:ImageButton ImageUrl="/UI/img/delete.png" runat="server" Width="16px"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                OnClientClick="return confirm('Bạn thực sự muốn xóa tội danh này của bị cáo? ');" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
         <script>
            $(document).ready(function () {
                ReloadParent_td();
            });
            function ReloadParent_td() {
                window.onunload = function (e) {
                    opener.Loadds_td();
                    //opener.Loadds_bc();
                };
                // window.close();
             }
           
        </script>
    </form>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
    <script src="../../../../UI/js/init.js"></script>
    <script type="text/javascript">
        function OpenPopupCenter(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</body>
</html>
