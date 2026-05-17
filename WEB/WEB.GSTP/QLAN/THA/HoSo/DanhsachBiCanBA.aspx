<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DanhsachBiCanBA.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.HoSo.DanhsachBiCanBA" %>

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

    <script src="../../../../UI/js/chosen.jquery.js"></script>
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <div class="box">
                    <div class="box_nd">
                        <div class="truong">
                            <table class="table1">
                                <tr>
                                    <td colspan="2">
                                        <div class="boxchung">
                                            <h4 class="tleboxchung">Bản án đã tồn tại trên hệ thống</h4>
                                            <div class="boder" style="padding: 10px;">
                                                <table class="table1">
                                                    <tr>
                                                        <td style="width: 75px;">Lựa chọn</td>
                                                        <td style="width: 200px;">
                                                            <asp:DropDownList ID="dropLoaiLuaChon" CssClass="chosen-select"
                                                                Width="180px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="dropLoaiLuaChon_SelectedIndexChanged">
                                                            </asp:DropDownList></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <asp:Panel runat="server" ID="pnVA" Visible="false">
                                                        <tr>
                                                            <td>Tên vụ án<span class="batbuoc">(*)</span></td>
                                                            <td colspan="3">

                                                                <asp:TextBox ID="txtTenVuAn" CssClass="user" placeholder="Tên bị can đầu vụ - tội danh"
                                                                    TextMode="MultiLine" Rows="2"
                                                                    runat="server" Width="465px"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lbNgayBanAn" runat="server">Ngày bản án sơ thẩm</asp:Label><span class="batbuoc">(*)</span></td>
                                                            <td>
                                                                <asp:TextBox ID="txtNgayBanAn" runat="server" CssClass="user"
                                                                    Width="172px" MaxLength="10"></asp:TextBox>
                                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                                                    TargetControlID="txtNgayBanAn" Format="dd/MM/yyyy" Enabled="true" />
                                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                                                    TargetControlID="txtNgayBanAn" Mask="99/99/9999"
                                                                    MaskType="Date" CultureName="vi-VN"
                                                                    ErrorTooltipEnabled="true" />
                                                            </td>
                                                            <td style="width: 170px;">
                                                                <asp:Label ID="lbSoBanAn" runat="server">Số bản án sơ thẩm</asp:Label><span class="batbuoc">(*)</span></td>
                                                            <td>
                                                                <asp:TextBox ID="txtSoBanAn" CssClass="user align_right"
                                                                    onkeypress="return isNumber(event)" runat="server"
                                                                    Width="80px" MaxLength="50"></asp:TextBox>

                                                            </td>
                                                        </tr>
                                                         <tr>
                                                            <td>
                                                                <asp:Label ID="lbToaAn" runat="server">Tòa án ra bản án sơ thẩm</asp:Label><span class="batbuoc">(*)</span></td>
                                                            <td>
                                                                <asp:TextBox ID="txtToaAn" CssClass="user"
                                                                        runat="server" Width="172px" MaxLength="250"></asp:TextBox>
                                                            </td>

                                                        </tr>
                                                    </asp:Panel>                                                   
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="left">
                                        <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="left">
                                        <div class="phantrang">
                                            <div class="sobanghi">
                                                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNext_Click"></asp:LinkButton>
                                            </div>
                                        </div>
                                        <!--------------------------------------->
                                        <asp:HiddenField ID="hddBiAnID" runat="server" />
                                        <table class="table2" style="width: 100%;" border="1">
                                            <tr class="header">
                                                <td style="width: 15px; text-align: center">STT</td>
                                                <td style="width: 85px; text-align: center">Chọn bị án</td>
                                                <td style="width: 70px; text-align: center">Mã bị án</td>
                                                <td style="text-align: center">Bị án</td>
                                                <td style="width: 70px; text-align: center">Mã vụ án</td>
                                                <td style="text-align: center">Tên vụ án</td>
                                                <td style="width: 85px; text-align: center">Số bản án</td>
                                                <td style="width: 85px; text-align: center">Ngày bản án</td>
                                            </tr>
                                            <asp:Repeater ID="rpt" runat="server" 
                                                OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td><%# Eval("STT") %></td>
                                                        <td><asp:Button ID="cmdChitiet" runat="server" Text="Chọn bị án"
                                                                CssClass="buttonchitiet" CausesValidation="false"
                                                                CommandArgument='<%# Eval("BiAnID") +"$"+ Eval("IDVuAnHeThong")%>'
                                                                CommandName="ThuLyAn"/>
                                                        </td>
                                                        <td><%# Eval("MaBiAn") %></td>
                                                        <td><%# Eval("TenBiAn") %></td>
                                                        <td><%# Eval("MaVuAn") %></td>
                                                        <td><%# Eval("TenVuAn") %></td>
                                                        <td><%# Eval("SoBanAn") %></td>
                                                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYBANAN")) %></td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </table>
                                        <!--------------------------------------->
                                        <div class="phantrang">
                                            <div class="sobanghi">
                                                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNext_Click"></asp:LinkButton>
                                            </div>
                                        </div>
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
    </form>
    <script>
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function ReloadParent() {
            window.onunload = function (e) {
                opener.LoadSessionBian();
            };
            window.close();
        }
    </script>
    <script type = "text/javascript">
        function OnClose() {

            if (window.opener != null && !window.opener.closed) {

                window.opener.HideModalDiv();

            }

        }

        window.onunload = OnClose;

    </script>
</body>
</html>
