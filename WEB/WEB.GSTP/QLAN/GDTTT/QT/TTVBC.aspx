<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="TTVBC.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.QT.TTVBC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <style type="text/css">
        .labelTimKiem_css {
            width: 85px;
        }

        .grid_button {
            margin-right: 10px;
            float: left;
        }
    </style>
    <div class="box">
        <div class="box_nd">

            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung">Tìm kiếm</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                        <td style="width: 60px;">Lãnh đạo</td>
                        <td style="width: 260px;">
                            <asp:DropDownList ID="dropLD" CssClass="chosen-select"
                                runat="server" Width="250px">
                            </asp:DropDownList>

                        </td>
                        <td style="width: 80px;">Thẩm tra viên</td>
                        <td>
                            <asp:DropDownList ID="dropTTV" CssClass="chosen-select"
                                runat="server" Width="250px">
                            </asp:DropDownList>  <asp:Button ID="cmdTimkiem" runat="server" Height="26px"
                                CssClass="buttoninput" Text="Tìm kiếm" OnClick="btnTimKiem_Click" />
                              <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput" Height="26px"
                                                        Text="In biểu mẫu" OnClick="cmdPrint_Click" />
                        </td>
                    </tr>
                        </table>
                    </div>
                </div>
                <table class="table1">
                    <tr>
                        <td colspan="4">
                            <asp:Label runat="server" ID="lblThongBao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div class="phantrang" style="margin-bottom: 8px;">
                                <div class="sobanghi">
                                      <asp:Button ID="cmdUpdate" runat="server" Height="26px"
                                CssClass="buttoninput" Text="Lưu cấu hình" OnClick="cmdUpdate_Click" />
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
                            <table class="table2" width="100%" border="1">
                                <tr class="header">
                                    <td width="20">
                                        <div align="center"><strong>STT</strong></div>
                                    </td>
                                    <td>
                                        <div align="center"><strong>Thẩm tra viên</strong></div>
                                    </td>
                                    <td>
                                        <div align="center"><strong>Chức danh</strong></div>
                                    </td>
                                    <td width="38%">
                                        <div align="center"><strong>Lãnh đạo</strong></div>
                                    </td>
                                </tr>
                                <asp:Repeater ID="rpt" runat="server" OnItemDataBound="rpt_ItemDataBound">
                                    <HeaderTemplate>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td align="center"><%# Eval("TT") %>
                                                <asp:HiddenField ID="hddCanBoID" runat="server" Value='<%# Eval("CanBoID") %>' />
                                                <asp:HiddenField ID="hddLanhDaoID" runat="server" Value='<%# Eval("LanhDaoID") %>' />
                                            </td>
                                            <td><%#Eval("HoTen") %></td>
                                              <td><%#Eval("ChucDanh") %></td>
                                            <td>
                                                <div>
                                                    <asp:DropDownList ID="dropLanhDao" CssClass="chosen-select"
                                                        runat="server" Width="500px">
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></FooterTemplate>
                                </asp:Repeater>
                            </table>
                            <div class="phantrang">
                                <div class="sobanghi">
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
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        //function Popup(pageURL, title, w, h) {
        //    //alert(pageURL);
        //    var left = (screen.width / 2) - (w / 2);
        //    var top = (screen.height / 2) - (h / 2);
        //    var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        //    return targetWin;
        //}

    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
