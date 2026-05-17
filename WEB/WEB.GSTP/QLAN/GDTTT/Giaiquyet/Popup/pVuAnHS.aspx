<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pVuAnHS.aspx.cs"
    Inherits="WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup.pVuAnHS" %>

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
        <asp:HiddenField ID="hddIsAnPT" runat="server" Value="PT" />
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
                                <h4 class="tleboxchung">1. Thông tin thụ lý</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="tableva">
                                        <tr>
                                            <td style="width: 120px;">Số thụ lý</td>
                                            <td style="width: 255px;">
                                                <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server"
                                                    Width="242px"></asp:TextBox>
                                            </td>
                                            <td style="width: 95px;">Ngày thụ lý</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayThuLy" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Ngày ghi trên đơn/Ngày gửi đơn</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayTrongDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayTrongDon" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayTrongDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Ngày nhận đơn</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayNhanDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhanDon" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayNhanDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td style="width: 120px;">Loại bản án</td>
                                            <td style="width: 255px;">
                                                <asp:DropDownList ID="ddlLoaiBA" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiBA_SelectedIndexChanged"
                                                    runat="server" Width="250px">
                                                    <asp:ListItem Value="3" Text="Phúc thẩm" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Sơ thẩm"></asp:ListItem>
                                                    <asp:ListItem Value="4" Text="QĐ GĐT"></asp:ListItem>
                                                </asp:DropDownList>

                                            </td>

                                            <td style="width: 95px;">Loại án</td>
                                            <td style="width: 255px;">
                                                <asp:DropDownList ID="dropLoaiAn" runat="server"
                                                    Width="250px" CssClass="chosen-select">
                                                </asp:DropDownList>
                                            </td>

                                        </tr>
                                        <!---------------QĐ GDT----------------------------->
                                        <asp:Panel ID="pnQDGDT" runat="server" Visible="false">
                                            <tr>
                                                <td style="width: 120px;">Số QĐ GĐT
                                    <asp:Literal ID="ltt_SoGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td style="width: 255px;">
                                                    <asp:TextBox ID="txtSoQĐGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>

                                                <td style="width: 95px;">Ngày QĐ GĐT<asp:Literal ID="ltt_NgayGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayGDT" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtNgayGDT" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtNgayGDT"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tòa án ra QĐ GDT<asp:Literal ID="ltt_ToaGDT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal></td>
                                                <td>
                                                    <asp:DropDownList ID="dropToaGDT" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropToaGDT_SelectedIndexChanged"
                                                        runat="server" Width="250px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td colspan="2"></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" style="border-bottom: 1.5px dotted #808080;"></td>
                                            </tr>
                                        </asp:Panel>
                                        <!---------------An PT----------------------------->
                                        <asp:Panel ID="pnPhucTham" runat="server">
                                            <tr>
                                                <td>Số BA/QĐ Phúc thẩm
                                                <asp:Literal ID="lttBB_SoPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtSoBA" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                                <td>Ngày BA/QĐ Phúc thẩm
                                                <asp:Literal ID="lttBB_NgayPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayBA" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayBA"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tòa án xét xử PT
                                                <asp:Literal ID="lttBB_ToaPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged"
                                                        runat="server" Width="250px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                        </asp:Panel>

                                        <!-----------An ST--------------------------------->
                                        <asp:Panel ID="pnAnST" runat="server">

                                            <tr>
                                                <td>Số BA/QĐ Sơ thẩm
                                                    <asp:Literal ID="lttBB_SoST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtSoBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                                <td>Ngày BA/QĐ Sơ thẩm
                                                    <asp:Literal ID="lttBB_NgayST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayBA_ST" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNgayBA_ST" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNgayBA_ST"
                                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tòa án xét xử sơ thẩm
                                                    <asp:Literal ID="lttBB_ToaST" runat="server" Visible="false" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="dropToaAnST" CssClass="chosen-select"
                                                        runat="server" Width="250px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                        </asp:Panel>
                                    </table>
                                </div>

                                <!---------------------------->
                                <div style="float: left; margin-top: 8px; width: 100%;">
                                    <h4 class="tleboxchung">Bị cáo, Người khiếu nại</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <div style="display: none;">
                                            <asp:Button ID="cmd_loadbc" runat="server" CssClass="buttoninput" Text="Load bi cao" OnClick="cmd_loadbc_Click" />
                                        </div>
                                        <table class="table1">
                                            <tr runat="server" id="tr_nguoikn">
                                                <td>
                                                    <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Người khiếu nại</div>
                                                    <div style="float: left; margin-left: 7px;">
                                                        <asp:DropDownList ID="dropNguoiKhieuNai" runat="server" CssClass="chosen-select" Width="250px"
                                                            AutoPostBack="true" OnSelectedIndexChanged="dropNguoiKhieuNai_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Người được khiếu nại</div>
                                                    <div style="float: left; margin-left: 7px;">
                                                        <asp:DropDownList ID="dropBiCao" runat="server" Width="250px" CssClass="chosen-select"
                                                            OnSelectedIndexChanged="dropBiCao_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; margin-left: 7px;">
                                                        <asp:LinkButton ID="lkThem_BC" runat="server" OnClick="lkThemBiCao_Click"
                                                            CssClass="button_empty" ToolTip="Thêm bị bị cáo">Thêm</asp:LinkButton>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr runat="server" id="tr_noidungkn">
                                                <td>
                                                    <div style="float: left; width: 120px; text-align: right; margin-top: 3px;">Nội dung khiếu nại</div>
                                                    <div style="float: left; margin-left: 7px;">
                                                        <asp:TextBox ID="txtNguoiKN_NoiDung" CssClass="user" runat="server" Width="606px"></asp:TextBox>
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
                                            <tr runat="server" id="tr_btn_kn">
                                                <td>
                                                    <div style="float: left; margin-left: 125px; margin-top: 11px;">
                                                        <div style="float: left">
                                                            <asp:Button ID="cmdSaveDSHinhSu" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdSaveDSHinhSu_Click" />
                                                        </div>
                                                        <div style="float: left; margin-left: 7px;">
                                                            <asp:Button ID="cmdRefresh" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                                OnClick="cmdRefresh_Click" />
                                                        </div>
                                                        <div style="display: none;">
                                                            <asp:Button ID="cmd_load_dstd_cc" runat="server" CssClass="buttoninput" Text="Làm mới"
                                                                OnClick="cmd_load_dstd_cc_Click" />
                                                        </div>
                                                    </div>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
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
                                                                                        <asp:LinkButton ID="lkSuaKN" runat="server"
                                                                                            Text="Sửa" ForeColor="#0e7eee"
                                                                                            CommandName="SuaKN" CommandArgument='<%#Eval("ID")+"$"+ Eval("NguoiKhieuNaiID")+"$"+Eval("BiCaoID")+"$"+Eval("NoiDungKhieuNai")%>'></asp:LinkButton>
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
                                                                        <div id="td_sua_div" runat="server" align="center" style="width: 69px;">
                                                                            <div style="float: left; margin-left: 3px;">
                                                                                <asp:Literal ID="lttSua" runat="server"></asp:Literal>
                                                                            </div>
                                                                            <div style="display: none;">
                                                                                <asp:LinkButton ID="lkSua" runat="server"
                                                                                    Text="Sửa" ForeColor="#0e7eee"
                                                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                            </div>
                                                                            &nbsp;&nbsp;
                                                            <div style="float: left; margin-left: 15px;">
                                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                    Text="Xóa" ForeColor="#0e7eee"
                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa Bị cáo này? ');"></asp:LinkButton>
                                                            </div>
                                                                            <br />
                                                                            <div style="margin-top: 3px;">
                                                                                <asp:Literal ID="ltt_them_td" runat="server"></asp:Literal>
                                                                            </div>
                                                                            <div style="display: none;">
                                                                                <asp:LinkButton ID="lbtthem_td" runat="server" CausesValidation="false"
                                                                                    Text="Thêm tội danh" ForeColor="#0e7eee"
                                                                                    CommandName="them_td" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <!---------------------------->
                                <div style="float: left; margin-top: 8px; width: 100%;">
                                    <h4 class="tleboxchung">3. Thẩm tra viên/ Lãnh đạo   
                                <asp:LinkButton ID="lkTTV" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lkTTV_Click"></asp:LinkButton>
                                    </h4>
                                    <div class="boder" style="padding: 10px;">
                                        <asp:Panel ID="pnTTV" runat="server" Visible="false">
                                            <table class="tableva">
                                                <tr>
                                                    <td style="width: 120px;">Ngày phân công</td>
                                                    <td style="width: 255px;">
                                                        <asp:TextBox ID="txtNgayphancong" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td style="width: 95px;">Thẩm tra viên</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropTTV"
                                                            AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_SelectedIndexChanged"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayNhanTieuHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhanTieuHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTieuHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Ngày TTV nhận hồ sơ </td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayNhanHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td></td>
                                                    <td colspan="2"><i>(Lưu ý: hệ thống sẽ tự động tạo phiếu nhận tương ứng nếu mục 'Ngày TTV nhận hồ sơ' được chọn)</i></td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày Vụ GĐ nhận hồ sơ</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayGDNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td colspan="2"></td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày phân công LĐ</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayPhanCong_LDV" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgayPhanCong_LDV" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Lãnh đạo Vụ</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropLanhDao"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Ngày phân công TP</td>
                                                    <td>
                                                        <asp:TextBox ID="txtNgayPhanCong_TP" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNgayPhanCong_TP" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNgayPhanCong_TP" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <td>Thẩm phán</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropThamPhan"
                                                            CssClass="chosen-select" runat="server" Width="250">
                                                        </asp:DropDownList></td>
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
                                <asp:HiddenField ID="hddDonID" runat="server" Value="0" />
                                <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
                                <asp:HiddenField ID="hddThuLyLaiVuAnID" runat="server" Value="0" />
                                <asp:HiddenField ID="hddGUID" runat="server" Value="" />
                                <asp:HiddenField ID="hddNext" runat="server" Value="0" />
                                <asp:HiddenField ID="hddInputAnST" runat="server" Value="0" />
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    function Loadds_td() {
                        $("#<%= cmd_load_dstd_cc.ClientID %>").click();
                    }
                    function popup_them_sua_ds(VuAnID, DUONGSUID) {
                        var link = "";
                        link = "/QLAN/GDTTT/Giaiquyet/Popup/pBiCao_cc.aspx?hsID=" + VuAnID + "&DS_ID=" + DUONGSUID;
                        var width = 900;
                        var height = 800;
                        PopupCenter(link, "Cập nhật thông tin bị can", width, height);
                    }
                    function popup_them_td_cc(DuongSuID) {
                        var link = "/QLAN/GDTTT/Giaiquyet/popup/p_ToiDanh_cc.aspx?duongsuid=" + DuongSuID;
                        var width = 800;
                        var height = 500;
                        PopupCenter(link, "Thêm tội danh", width, height);
                    }
                    function Loadds_bc() {
                        $("#<%= cmd_loadbc.ClientID %>").click();
                    }
                </script>
                <script>
                    function ReloadParent() {
                        window.onunload = function (e) {
                            opener.LoadDsDon();
                        };
                        window.close();
                    }
                    function validate() {
                        //if (!validate_thuly())
                        //    return false;
                        if (!validate_banan_qd())
                            return false;
                        return true;
                    }
                    function validate_thuly() {
                        var txtSoThuLy = document.getElementById('<%=txtSoThuLy.ClientID%>');
                        if (!Common_CheckTextBox(txtSoThuLy, 'Số thụ lý'))
                            return false;
                        //-----------------------------
                        var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
                        if (!CheckDateTimeControl(txtNgayThuLy, "Ngày thụ lý"))
                            return false;
                        //-----------------------------
                        return true;
                    }
                    function validate_banan_qd() {
                        var value_change = "";
                        var txtSoBA = document.getElementById('<%=txtSoBA.ClientID%>');
                        if (!Common_CheckTextBox(txtSoBA, 'Số BA/QĐ'))
                            return false;
                        //-----------------------------
                        var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
                        var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
                        if (!CheckDateTimeControl(txtNgayBA, "Ngày BA/QĐ"))
                            return false;

                        //-----------------------------
                        var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
                        value_change = dropToaAn.options[dropToaAn.selectedIndex].value;
                        if (value_change == "0") {
                            alert("Bạn chưa chọn Tòa án thụ lý vụ việc. Hãy kiểm tra lại!");
                            dropToaAn.focus();
                            return false;
                        }
                        //-----------------------------
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
</body>
</html>
