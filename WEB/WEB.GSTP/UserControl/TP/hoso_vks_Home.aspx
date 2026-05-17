<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="hoso_vks_Home.aspx.cs" Inherits="WEB.GSTP.UserControl.TP.hoso_vks_Home" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <title></title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            padding-top: 5px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }

        .form_tt {
            padding-top: 10px;
            margin: 0 auto;
            width: 760px;
            position: relative;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="form_tt" style="width: 1000px;">
                        <h4 class="tleboxchung">Tìm kiếm</h4>
                        <div class="boder" style="padding: 10px; width: 950px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 115px;">Loại án<span class="batbuoc">(*)</span></td>
                                    <td style="width: 246px;">
                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="246px"></asp:DropDownList>
                                    </td>
                                    <td style="width: 115px;">Cấp xét xử</td>
                                    <td>
                                        <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 115px;">Tên đương sự<span class="batbuoc">(*)</span></td>
                                    <td style="width: 238px;">
                                        <asp:TextBox ID="txt_TENDUONGSU" runat="server" CssClass="user" Width="238px" MaxLength="500"></asp:TextBox>
                                    </td>
                                    <td style="width: 115px;">Quá thời hạn<span class="batbuoc">(*)</span></td>
                                    <td style="width: 150px;">
                                        <asp:DropDownList ID="ddl_SONGAY_QUAHAN" CssClass="chosen-select" runat="server" Width="150px" AutoPostBack="True">
                                            <asp:ListItem Value="25" Text="25 ngày"></asp:ListItem>
                                            <asp:ListItem Value="30" Text="30 ngày"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 115px;">Ngày chuyển từ ngày</td>
                                    <td>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_TUNGAY" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txt_TUNGAY" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txt_TUNGAY" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_TUNGAY" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </div>
                                        <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txt_DENNGAY" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_DENNGAY" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_DENNGAY" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_DENNGAY" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </div>
                                    </td>
                                    <td style="width: 115px;">Tính đến ngày<span class="batbuoc">(*)</span></td>
                                    <td style="width: 142px;">
                                        <asp:TextBox ID="txt_TINH_DEN_NGAY" runat="server" CssClass="user" Width="142px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_TINH_DEN_NGAY" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_TINH_DEN_NGAY" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                        <asp:Button ID="cmd_In_ds" runat="server" CssClass="buttoninput" Text="In danh sách" OnClick="cmd_In_ds_Click" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div style="clear: both;"></div>
                    <div class="form_tt" style="width: 1000px;">
                        <h4 class="tleboxchung">Danh sách hồ sơ viện kiểm sát đang giữ quá 25 ngày</h4>
                        <div class="boder" style="padding: 10px; width: 950px;">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <span class="msg_error">
                                            <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
                                        <asp:Panel ID="pnPagingTop" runat="server">
                                            <div class="phantrang">
                                                <div class="sobanghi">
                                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
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
                                        </asp:Panel>

                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                <td width="70px">
                                                    <div align="center"><strong>Số, ngày thụ lý</strong></div>
                                                </td>
                                                <td width="70px">
                                                    <div align="center"><strong>Loại án</strong></div>
                                                </td>
                                                <td width="120px">
                                                    <div align="center"><strong>Địa phương</strong></div>
                                                </td>
                                                <td width="70px">
                                                    <div align="center">
                                                        <strong>Số, ngày
                                                <br />
                                                            BA/QĐ ST</strong>
                                                    </div>
                                                </td>
                                                <td width="80px">
                                                    <div align="center">
                                                        <strong>Nguyên đơn
                                                <br />
                                                            /NKK/Bị cáo</strong>
                                                    </div>
                                                </td>
                                                <td width="80px">
                                                    <div align="center">
                                                        <strong>Bị đơn
                                                <br />
                                                            /NBK/tội danh</strong>
                                                    </div>
                                                </td>
                                                <td style="width: 60px">
                                                    <div align="center"><strong>Ngày chuyển</strong></div>
                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <div align="center"><%# Eval("STT") %></div>
                                                        </td>
                                                        <td style="text-align: center;"><%# Eval("THULY") %></td>
                                                        <td><%# Eval("LOAI_AN_TEN") %></td>
                                                        <td><%# Eval("TOAAN_TEN") %></td>
                                                        <td style="text-align: center"><%# Eval("SONGAY_BAQD_ST") %></td>
                                                        <td><%# Eval("NGUYEND_DON") %></td>
                                                        <td><%# Eval("BI_DON") %></td>
                                                        <td style="text-align: center"><%# Eval("NGAY_NC") %></td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </table>
                                        <asp:Panel ID="pnPagingBottom" runat="server">
                                            <div class="phantrang_bottom">
                                                <div class="sobanghi">
                                                    <asp:HiddenField ID="hdicha" runat="server" />
                                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
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
            <script type="text/javascript">
                function pageLoad(sender, args) {
                    var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                    for (var selector in config) { $(selector).chosen(config[selector]); }
                }
                function Setfocus(controlid) {
                    var ctrl = document.getElementById(controlid);
                    ctrl.focus();
                }
            </script>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
