<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pNguoiKN.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pNguoiKN" %>

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
                                <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Người khiếu nại</div>
                                <div style="float: left; margin-left: 7px;">
                                            <asp:DropDownList ID="dropNguoiKhieuNai" runat="server" CssClass="chosen-select" Width="250px"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropNguoiKhieuNai_SelectedIndexChanged">
                                            </asp:DropDownList>
                                </div>
                            </div>
                            <!---------------Nguoi khieu nai khong phai bi cao---------------------------->
                          <asp:Panel ID="pnNguoiKN" runat="server" Visible="false">
                            <div style="float: left; width: 819px; margin-top: 10px;">
                                <div style="float: left; width: 120px; text-align: right; margin-top: 4px;">Đối tượng</div>
                                <div style="float: left; margin-left: 7px;">
                                     <asp:DropDownList ID="dropDoiTuongPhamToi"
                                                CssClass="chosen-select" runat="server" Width="250"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropDoiTuongPhamToi_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Pháp nhân thương mại"></asp:ListItem>
                                                <asp:ListItem Value="5" Text="Pháp nhân phi thương mại"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Cơ quan"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                </div>
                            </div>
                            <div style="float: left; width: 819px; margin-top: 10px;">
                                <div style="float: left; width: 120px; text-align: right; margin-top: 4px;">
                                    <asp:Literal ID="lttHoTen" runat="server" Text="Họ tên <span class='batbuoc'>*</span>"></asp:Literal>
                                </div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:TextBox ID="txtNguoiKN_HoTen" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </div>
                                <div style="float: left; width: 65px; text-align: right; margin-top: 4px;">Địa chỉ</div>
                                <div style="float: left; margin-left: 7px;">
                                    <asp:TextBox ID="txtNguoiKN_DiaChi" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </div>
                            </div>
                           </asp:Panel>
                             <div style="float: left; width: 819px; margin-top: 10px;">
                                        <div style="float: left; width: 120px; text-align: right; margin-top: 3px;"><span class="batbuoc">*</span>Người được khiếu nại</div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:DropDownList ID="dropBiCao" runat="server" Width="250px" CssClass="chosen-select">
                                            </asp:DropDownList>
                                        </div>
                                </div>

                             <div style="float: left; width: 819px; margin-top: 10px;">
                                <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Nội dung khiếu nại<span class="batbuoc">*</span></div>
                                        <div style="float: left; margin-left: 7px;">
                                            <asp:TextBox ID="txtNguoiKN_NoiDung" CssClass="user" runat="server" Width="606px"></asp:TextBox>
                                        </div>
                            </div>

                            <div style="float: left; width: 400px; margin-top: 10px; margin-left: 106px;">
                                <div style="color: red; font-size: 15px; text-align: center;">
                                    <asp:Literal ID="lttMsgBC" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div style="float: left; width: 400px; margin-top: 10px; margin-left: 106px;">
                                <asp:Button ID="cmdSaveNguoiKN" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdSaveNguoiKN_Click" OnClientClick="return validate();"/>
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
                                     <asp:Repeater ID="rptNguoiKN" runat="server"
                                                OnItemDataBound="rptNguoiKN_ItemDataBound"  OnItemCommand="rptNguoiKN_ItemCommand">
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
                                                            <asp:Repeater ID="rptBCKN" runat="server" OnItemCommand="RptBCKN_ItemCommand">
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
                                                            <div id="td_sua_div" runat="server" align="center" style="width: 69px;">
                                                                <asp:LinkButton ID="lbtXoaKN" runat="server" CausesValidation="false"
                                                                    Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa Thông tin khiếu nại này? ');"></asp:LinkButton>
                                                               
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
            function validate() {
                if (!validate_infor())
                    return false;
                return true;
            }
            function validate_infor() {
                var value_change = "";
                var dropNguoiKhieuNai = document.getElementById('<%=dropNguoiKhieuNai.ClientID%>');
                value_change = dropNguoiKhieuNai.options[dropNguoiKhieuNai.selectedIndex].value;

                var txtNguoiKN_HoTen = document.getElementById('<%=txtNguoiKN_HoTen.ClientID%>');
                if (value_change == "-1") {
                    if (!Common_CheckTextBox(txtNguoiKN_HoTen, 'Họ tên người kháng cáo'))
                        return false;
                }
                //----------------
                
                var value_dropBiCao= "";
                var dropBiCao = document.getElementById('<%=dropBiCao.ClientID%>');
                value_dropBiCao = dropBiCao.options[dropBiCao.selectedIndex].value;

                if (value_dropBiCao == "0") {
                    alert("Bạn chưa chọn Bị cáo được khiếu nại");
                    dropBiCao.focus();
                    return false;
                }
            //-----------------------------
                var txtNguoiKN_NoiDung = document.getElementById('<%=txtNguoiKN_NoiDung.ClientID%>');
                if (!Common_CheckTextBox(txtNguoiKN_NoiDung, " Nội dung khiếu nại"))
                    return false;
            //-----------------------------
                return true;
            }

            function Loadds_td() {
                $("#<%= cmd_load_dstd.ClientID %>").click();
            }
            function popup_them_td(DuongSuID) {
                var link = "/QLAN/GDTTT/VuAn/popup/p_ToiDanh_cc.aspx?duongsuid=" + DuongSuID;
                var width = 800;
                var height = 500;
                PopupCenter(link, "Thêm tội danh", width, height);
            }
           
        </script>
        <script>
            $(document).ready(function () {
                ReloadParent();
            });
            function ReloadParent() {
                window.onunload = function (e) {
                    //opener.Loadds_bc();
                    opener.Loadds_nguoikn();
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
