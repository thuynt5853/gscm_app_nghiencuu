<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pBiCao_cc.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.pBiCao" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin bị can</title>
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
            <h4 class="tleboxchung">Thêm bị cáo</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td>
                            <div style="float: left; width: 819px;">
                                <div style="float: left; margin-left: 107px;">
                                    <asp:CheckBox ID="chkBiCao" Checked="true" runat="server" Text="Là Bị cáo"
                                        OnCheckedChanged="chkBiCao_CheckedChanged" />
                                </div>
                            </div>
                            <div style="float: left; width: 819px; margin-top: 10px;">
                                <div style="float: left; width: 100px; text-align: right; margin-top: 4px;">Họ tên</div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:TextBox ID="txtBC_HoTen" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:CheckBox ID="chkBCDauVu" runat="server" Text="Đầu vụ"
                                        AutoPostBack="true" OnCheckedChanged="chkBiCao_CheckedChanged" />
                                </div>
                            </div>
                            <div style="float: left; width: 819px; margin-top: 10px;">
                                <div style="float: left; width: 100px; text-align: right; margin-top: 4px;">Mức án</div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:TextBox ID="txtBC_MucAn" CssClass="user" runat="server"
                                        Width="242px"></asp:TextBox>
                                </div>
                                <div style="float: left; width: 65px; text-align: right; margin-top: 4px;">Địa chỉ</div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:TextBox ID="txtNguoiKN_DiaChi" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </div>
                            </div>
                            <div style="float: left; width: 819px; margin-top: 10px;">
                                <div style="float: left; width: 100px; text-align: right; margin-top: 4px;">Năm sinh</div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:DropDownList ID="ddlNamsinh" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div style="float: left; width: 819px; margin-top: 10px; display: none;">
                                <div style="float: left; width: 100px; text-align: right; margin-top: 4px;">Tội danh</div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:DropDownList ID="dropBiCao_ToiDanh" runat="server"
                                        CssClass="chosen-select" Width="510px">
                                    </asp:DropDownList>
                                </div>
                                <div style="float: left; margin-left: 7px; display: none;">
                                    <asp:LinkButton ID="lkBiCao_SaveToiDanh" runat="server"
                                        OnClick="lkBiCao_SaveToiDanh_Click"
                                        CssClass="button_empty" ToolTip="Thêm tội danh">Thêm tội danh</asp:LinkButton>
                                </div>
                            </div>
                            <div style="float: left; width: 400px; margin-top: 10px; margin-left: 106px;">
                                <div style="color: red; font-size: 15px; text-align: center;">
                                    <asp:Literal ID="lttMsgBC" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div style="float: left; width: 400px; margin-top: 10px; margin-left: 106px;">
                                <asp:Button ID="cmdSaveDSHinhSu" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdSaveDSHinhSu_Click" />
                                <asp:Button ID="cmdRefresh" runat="server" CssClass="buttoninput" Text="Làm mới"
                                    OnClick="cmdRefresh_Click" />
                                <div style="display: none;">
                                    <asp:Button ID="cmd_load_dstd" runat="server" CssClass="buttoninput" Text="Làm mới"
                                        OnClick="cmd_load_dstd_Click" />
                                </div>
                            </div>
                            <div style="float: left; width: 819px; margin-top: 10px;">
                                <table class="table2" width="100%" border="1">
                                    <tr class="header">
                                        <td width="42">
                                            <div align="center"><strong>TT</strong></div>
                                        </td>
                                        <td width="150px">
                                            <div align="center"><strong>Họ tên</strong></div>
                                        </td>
                                        <td>
                                            <div align="center"><strong>Thông tin Bị cáo, Tội danh, mức án</strong></div>
                                        </td>
                                        <td width="70px">
                                            <div align="center"><strong>Thao tác</strong></div>
                                        </td>
                                    </tr>
                                    <asp:Repeater ID="rptBiCao" runat="server"
                                        OnItemDataBound="rptBiCao_ItemDataBound"
                                        OnItemCommand="rptBiCao_ItemCommand">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div align="center"><%# Container.ItemIndex + 1 %></div>
                                                </td>
                                                <td>
                                                    <asp:Literal ID="lttTenDS" runat="server"></asp:Literal>

                                                </td>
                                                <td runat="server">
                                                    <asp:Literal ID="lttBiCao" runat="server"></asp:Literal>
                                                    <asp:Repeater ID="rptBCKN" runat="server">
                                                        <HeaderTemplate>
                                                            <div class="listbc">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <div class="listbc_item" style="position: relative;">
                                                                <div style="float: left; width: 30%; font-weight: bold;">
                                                                    <%# Container.ItemIndex + 1 %><%# ". "
                                                                              + Eval("BiCao_TuCachTT")
                                                                              + " "+ (String.IsNullOrEmpty(Eval("BiCaoName")+"")?"Khác":Eval("BiCaoName")+"") %>
                                                                </div>
                                                                <div style="float: left; margin-left: 1%; width: 58%;">
                                                                    <%#String.IsNullOrEmpty(Eval("Hs_MucAn") +"")?"":("Mức án:"+Eval("Hs_MucAn")+"") %>

                                                                    <div style="float: left; width: 100%;">
                                                                        <%#String.IsNullOrEmpty(Eval("ListToiDanhBC") +"")?"":("Tội danh:"+Eval("ListToiDanhBC")+"") %>
                                                                    </div>
                                                                    <div style="float: left; width: 100%;">
                                                                        <%#String.IsNullOrEmpty(Eval("NoiDungKhieuNai") +"")?"":("Khiếu nại: "+Eval("NoiDungKhieuNai")) %>
                                                                    </div>
                                                                </div>
                                                                <div style="position: absolute; right: -76px; width: 69px; text-align: center; margin-top: 10px;">
                                                                    <asp:LinkButton ID="lkSuaKN" runat="server"
                                                                        Text="Sửa" ForeColor="#0e7eee"
                                                                        CommandName="SuaKN" CommandArgument='<%#Eval("ID")+"$"+ Eval("NguoiKhieuNaiID")+"$"+Eval("BiCaoID")%>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;
                                                                             <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                                                 Text="Xóa" ForeColor="#0e7eee"
                                                                                 CommandName="XoaKN" CommandArgument='<%#Eval("ID") %>'
                                                                                 OnClientClick="return confirm('Bạn thực sự muốn xóa khiếu nại cho bị cáo này? ');"></asp:LinkButton>
                                                                </div>
                                                            </div>

                                                        </ItemTemplate>
                                                        <FooterTemplate></div></FooterTemplate>
                                                    </asp:Repeater>
                                                </td>
                                                <td>
                                                    <div id="td_sua_div" runat="server" align="center"  style="width:120px;">
                                                        <asp:LinkButton ID="lkSua" runat="server"
                                                            Text="Sửa" ForeColor="#0e7eee"
                                                            CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                        &nbsp;&nbsp;
                                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                        Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa Bị cáo này? ');"></asp:LinkButton>
                                                        <br />
                                                        <asp:LinkButton ID="lbtthem_td" runat="server" CausesValidation="false"
                                                            Text="Thêm tội danh" ForeColor="#0e7eee"
                                                            CommandName="them_td" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <script>
            function Loadds_td() {
                $("#<%= cmd_load_dstd.ClientID %>").click();
            }
            function popup_them_td(DuongSuID) {
                var link = "/QLAN/GDTTT/Hoso/popup/pp_ToiDanh_cc.aspx?duongsuid=" + DuongSuID;
                var width = 800;
                var height = 500;
                PopupCenter(link, "Thêm tội danh", width, height);
            }
        </script>
        <script>
            $(document).ready(function () {
                ReloadParent();
                // ReloadParent_Check();
            });
            function ReloadParent() {
                window.onunload = function (e) {
                    opener.Loadds_bc();
                };
                // window.close();
            }
            //function ReloadParent_Check() {
            //    window.onunload = function (e) {
            //        opener.Loadds_bc_check();
            //    };
            //}
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

