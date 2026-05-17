<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pVuAnCV.aspx.cs"
    Inherits="WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup.pVuAnCV" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật thông tin vụ án</title>
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
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddDonID" runat="server" Value="0" />
        <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
        <asp:HiddenField ID="hddThuLyLaiVuAnID" runat="server" Value="0" />
        <asp:HiddenField ID="hddGUID" runat="server" Value="" />
        <asp:HiddenField ID="hddNext" runat="server" Value="0" />
        <asp:HiddenField ID="hddInputAnST" runat="server" Value="0" />
        <style>
            body {
                width: 100%;
                min-height: 500px;
                min-width: 500px;
                overflow-y: auto;
                overflow-x: auto;
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

            .tableva {
                /*border: solid 1px #dcdcdc;width: 100%;*/
                border-collapse: collapse;
                margin: 5px 0;
            }

                .tableva td {
                    padding: 2px;
                    padding-left: 2px;
                    padding-left: 5px;
                    vertical-align: middle;
                }
            /*-------------------------------------*/
            .table_list {
                border: solid 1px #dcdcdc;
                border-collapse: collapse;
                margin: 5px 0;
                width: 100%;
            }


                .table_list .header {
                    background: #db212d;
                    border: solid 1px #dcdcdc;
                    padding: 2px;
                    font-weight: bold;
                    height: 30px;
                    color: #ffffff;
                }

                .table_list header td {
                    background: #db212d;
                    border: solid 1px #dcdcdc;
                    padding: 2px;
                }

                .table_list td {
                    border: solid 1px #dcdcdc;
                    padding: 5px;
                    line-height: 17px;
                }
        </style>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="truong">
                            <div style="margin: 5px; text-align: center; width: 95%">
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                            </div>
                            <div style="margin: 5px; width: 95%; color: red;">
                                <asp:Label ID="lttMsgT" runat="server"></asp:Label>
                            </div>
                            <div class="boxchung">
                              
                                <div style="float: left; margin-top: 8px; width: 100%;">
                                    <h4 class="tleboxchung">Thông tin</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="tableva">
                                            <tr>
                                                <td>Tòa án giải quyết<span class="batbuoc">(*)</span></td>
                                                <td>
                                                    <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"                                                       
                                                        runat="server" Width="250px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Loại án</td>
                                                <td>
                                                    <asp:DropDownList ID="dropLoaiAn" runat="server"
                                                        AutoPostBack="true" Width="250px"
                                                        CssClass="chosen-select" OnSelectedIndexChanged="dropLoaiAn_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                           
                                            <tr>
                                                <td>Quan hệ pháp luật</td>
                                                <td>
                                                    <asp:DropDownList ID="dropQHPL"
                                                        CssClass="chosen-select" runat="server" Width="250">
                                                    </asp:DropDownList></td>
                                                <td style="display: none;">Quan hệ PL tranh chấp</td>
                                                <td style="display: none;">
                                                    <asp:DropDownList ID="dropQHPLThongKe"
                                                        CssClass="chosen-select" runat="server" Width="250px">
                                                        <asp:ListItem Value="0" Text="Chọn"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" style="height: 10px;"></td>
                                            </tr>
                                            <!----------------------------->
                                            <asp:Panel ID="pnNguyenDon" runat="server">
                                                <tr>
                                                    <td colspan="4" style="height: 5px;"></td>
                                                </tr>
                                                
                                                <tr>
                                                    <td colspan="4"><b style="margin-right: 10px;">Nguyên đơn/ Người khởi kiện </b>
                                                        <asp:DropDownList ID="dropSoND" runat="server" Width="140px" CssClass="chosen-select"
                                                            AutoPostBack="true" OnSelectedIndexChanged="dropSoND_SelectedIndexChanged" Visible="false">
                                                        </asp:DropDownList>
                                                        <asp:LinkButton ID="lkThemND" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Nguyên đơn/ Người khởi kiện"
                                                            OnClientClick="return validate();" OnClick="lkThemND_Click">&nbsp;</asp:LinkButton>
                                                        <asp:CheckBox ID="chkND" runat="server" Text="Có địa chỉ"
                                                            AutoPostBack="true" OnCheckedChanged="chkND_CheckedChanged" />
                                                    </td>
                                                </tr> <tr>
                                                    <td colspan="4"><i><b>Lưu ý: </b>Thông tin nguyên đơn bắt buộc nhập</i></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="vertical-align: top;">
                                                        <asp:Repeater ID="rptNguyenDon" runat="server" OnItemCommand="rptNguyenDon_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
                                                            <HeaderTemplate>
                                                                <table class="table_list" width="100%" border="1">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td width="15px" style="text-align: center;">
                                                                        <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                                        <%# Container.ItemIndex + 1 %></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                            placeholder="Họ tên(*)"
                                                                            runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>

                                                                    <asp:Panel ID="pn" runat="server">
                                                                        <td width="250px">
                                                                            <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                            <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                        </td>
                                                                        <td width="190px">
                                                                            <asp:TextBox ID="txtDiachi" Width="96%"
                                                                                placeholder="Địa chỉ chi tiết"
                                                                                CssClass="user" runat="server"
                                                                                Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                                    </asp:Panel>
                                                                    <td width="30px">
                                                                        <div align="center">
                                                                            <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                                CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                                ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate></table></FooterTemplate>
                                                        </asp:Repeater>

                                                    </td>
                                                </tr>
                                            </asp:Panel>

                                            <!----------------------------->
                                            <asp:Panel ID="pnBiDon" runat="server">
                                                <tr>
                                                    <td colspan="4" style="height: 5px;"></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4"><b style="margin-right: 10px;">Bị đơn/ Người  bị kiện</b>
                                                        <asp:DropDownList ID="dropSoBD" runat="server" Width="140px" CssClass="chosen-select"
                                                            AutoPostBack="true" OnSelectedIndexChanged="dropSoBD_SelectedIndexChanged" Visible="false">
                                                        </asp:DropDownList>
                                                        <asp:LinkButton ID="lkThemBD" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm bị đơn/ Người bị kiện"
                                                            OnClientClick="return validate();" OnClick="lkThemBD_Click">&nbsp;</asp:LinkButton>
                                                        <asp:CheckBox ID="chkBD" runat="server" Text="Có địa chỉ"
                                                            AutoPostBack="true" OnCheckedChanged="chkBD_CheckedChanged" />
                                                    </td>
                                                </tr>
                                                 <tr>
                                                    <td colspan="4" ><i><b>Lưu ý: </b>Thông tin bị đơn bắt buộc nhập</i></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="vertical-align: top;">

                                                        <asp:Repeater ID="rptBiDon" runat="server"
                                                            OnItemCommand="rptBiDon_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
                                                            <HeaderTemplate>
                                                                <table class="table_list" width="100%" border="1">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td width="15px" style="text-align: center;">
                                                                        <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                                        <%# Container.ItemIndex + 1 %></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                            placeholder="Họ tên bị đơn (*)"
                                                                            runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>
                                                                    <asp:Panel ID="pn" runat="server">
                                                                        <td width="250px">
                                                                            <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                            <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                        </td>
                                                                        <td width="190px">
                                                                            <asp:TextBox ID="txtDiachi" Width="96%"
                                                                                placeholder="Địa chỉ chi tiết" CssClass="user" runat="server" Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                                    </asp:Panel>
                                                                    <td width="30px">
                                                                        <div align="center">
                                                                            <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                                CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                                ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate></table></FooterTemplate>
                                                        </asp:Repeater>

                                                    </td>
                                                </tr>
                                            </asp:Panel>

                                            <!----------------------------->
                                            <asp:Panel ID="pnDsKhac" runat="server">
                                                <tr>
                                                    <td colspan="4" style="height: 5px;"></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4"><b style="margin-right: 10px;">Người có QL&NVLQ</b>
                                                        <asp:DropDownList ID="dropSoDSKhac" runat="server" Width="140px" CssClass="chosen-select"
                                                            AutoPostBack="true" OnSelectedIndexChanged="dropSoDSKhac_SelectedIndexChanged" Visible="false">
                                                        </asp:DropDownList>
                                                        <asp:LinkButton ID="lkThemDSKhac" runat="server" CssClass="buttonpopup them_user clear_bottom" ToolTip="Thêm Người có QL&NVLQ"
                                                            OnClientClick="return validate();" OnClick="lkThemDSKhac_Click">&nbsp;</asp:LinkButton>
                                                        <asp:CheckBox ID="chkDSKhac" runat="server" Text="Có địa chỉ"
                                                            AutoPostBack="true" OnCheckedChanged="chkDSKhac_CheckedChanged" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4">
                                                        <asp:Repeater ID="rptDsKhac" runat="server"
                                                            OnItemCommand="rptDsKhac_ItemCommand" OnItemDataBound="rptDuongSu_ItemDataBound">
                                                            <HeaderTemplate>
                                                                <table class="table_list" width="100%" border="1">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td style="text-align: center; width: 15px;">
                                                                        <asp:HiddenField ID="hddDuongSuID" runat="server" Value='<%#Eval("ID") %>' />
                                                                        <%# Container.ItemIndex + 1 %></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtTen" Width="96%" CssClass="user"
                                                                            placeholder="Họ tên"
                                                                            runat="server" Text='<%#Eval("TenDuongSu") %>'></asp:TextBox></td>
                                                                    <asp:Panel ID="pn" runat="server">
                                                                        <td width="250px">
                                                                            <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("HUYENID") %>' />
                                                                            <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                                        </td>
                                                                        <td style="width: 190px">
                                                                            <asp:TextBox ID="txtDiachi"
                                                                                placeholder="Địa chỉ chi tiết" Width="96%" CssClass="user" runat="server" Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                                                    </asp:Panel>
                                                                    <td width="30px">
                                                                        <div align="center">
                                                                            <asp:LinkButton ID="lkXoa" Visible='<%#(Convert.ToInt16(Eval("IsDelete")+"")==0)? false:true %>' runat="server"
                                                                                CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate></table></FooterTemplate>
                                                        </asp:Repeater>
                                                    </td>
                                                </tr>
                                            </asp:Panel>
                                        </table>
                                    </div>
                                </div>
                                <!---------------------------->
                                <div style="float: left; margin-top: 8px; width: 100%;">
                                    <h4 class="tleboxchung">Thẩm tra viên/ Lãnh đạo   
                                <asp:LinkButton ID="lkTTV" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lkTTV_Click"></asp:LinkButton>
                                    </h4>
                                    <div class="boder" style="padding: 10px;">
                                        <asp:Panel ID="pnTTV" runat="server" Visible="false">
                                            <table class="tableva">
                                                <tr>
                                                    <td>Ngày phân công</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayphancong" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 120px;">Thẩm tra viên</td>
                                                    <td style="width: 255px;">
                                                        <asp:DropDownList ID="dropTTV"
                                                            AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_SelectedIndexChanged"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList></td>
                                                    <td style="width: 95px;">Lãnh đạo Vụ</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropLanhDao"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayNhanTieuHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhanTieuHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTieuHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Ngày Vụ GĐ nhận hồ sơ</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayGDNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Thẩm phán</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropThamPhan"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList></td>
                                                    <td colspan="2"></td>
                                                </tr>
                                                <tr>
                                                    <td>Ghi chú</td>
                                                    <td colspan="3">
                                                        <asp:TextBox ID="txtGhiChu" CssClass="user"
                                                            runat="server" Width="605px"></asp:TextBox>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </div>
                                </div>
                                <!---------------------------->
                            </div>
                            <div style="margin: 5px; text-align: center; width: 95%">
                                <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                            </div>
                            <div style="margin: 5px; width: 95%; color: red;">
                                <asp:Label ID="lttMsg" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    function ReloadParent() {
                        window.onunload = function (e) {
                            opener.LoadDsDon();
                        };
                        window.close();
                    }

                    function validate() {
                        if (!validate_banan_qd())
                            return false;
                        return true;
                    }
                    function validate_banan_qd() {
                        var value_change = "";
                        var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
                        value_change = dropToaAn.options[dropToaAn.selectedIndex].value;
                        if (value_change == "0") {
                            alert("Bạn chưa chọn Tòa án thụ lý vụ việc. Hãy kiểm tra lại!");
                            dropToaAn.focus();
                            return false;
                        }
                        return true;
                    }
                </script>
                <script type="text/javascript">

                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
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
<script>

                    Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
                    function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
</body>
</html>
