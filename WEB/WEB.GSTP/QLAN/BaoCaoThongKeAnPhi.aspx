<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="BaoCaoThongKeAnPhi.aspx.cs" Inherits="WEB.GSTP.QLAN.BaoCaoThongKeAnPhi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 80px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }

        .full_width {
            float: left;
            width: 100%;
        }

        .link_view {
            color: #0e7eee;
            font-weight: bold;
            text-decoration: none;
        }

        .searchtop {
            display: none;
        }
    </style>
    <div class="box" style="height: 400px;">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tổng hợp báo cáo
                                </h4>
                                <div class="boder" style="padding: 10px; float: left; width: 98%;">
                                    <%--<div style="float: left; width: 800px; margin-top: 7px;">
                                        <div style="float: left; font-weight: bold; width: 130px;">Ngày thông báo từ ngày</div>
                                        <div style="float: left; margin-left: 10px;">
                                            <span style="float: left">
                                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="textbox"
                                                    placeholder="......./....../....." Width="120px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </span>
                                            <span style="margin-left: 5px; margin-right: 5px; line-height: 22px; float: left;">Đến ngày</span>
                                            <span style="float: left; margin-right: 2px;">
                                                <asp:TextBox ID="txtDenNgay" runat="server" CssClass="textbox"
                                                    placeholder="......./....../....." Width="120px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </span>
                                        </div>
                                    </div>
                                    <div style="float: left; width: 800px; margin-top: 7px;">
                                        <div style="float: left; font-weight: bold; width: 130px;">Phạm vi tìm kiếm</div>
                                        <div style="float: left; margin-left: 10px;">
                                            <asp:DropDownList CssClass="chosen-select" ID="Drop_object" runat="server" Width="320" AutoPostBack="true">
                                                <asp:ListItem Value="TH" Selected="True" Text="Tất cả"></asp:ListItem>
                                                <asp:ListItem Value="T" Text="Cục THADS"></asp:ListItem>
                                                <asp:ListItem Value="H" Text="Chi cục THADS"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div style="float: left; width: 800px; margin-top: 7px;">
                                        <div style="float: left; font-weight: bold; width: 130px;">Hình thức thanh toán</div>
                                        <div style="float: left; margin-left: 10px;">
                                            <asp:DropDownList CssClass="chosen-select" ID="ddl_TRUCTUYEN" runat="server" Width="320px">
                                                <asp:ListItem Value="" Selected="True" Text="Tất cả"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Trực tuyến"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>--%>

                                    <%--   ------------------------------------------------%>

                                    <div style="float: left; width: 100%; margin-top: 17px;">
                                        <div id="lb_tungay" style="float: left; width: 141px; text-align: left; margin-left: 9px; padding-top: 3px;">Ngày thông báo: Từ ngày</div>
                                        <div style="float: left; width: 192px; padding-left: 12px;">
                                            <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="192px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                        <div style="float: left; width: 70px; text-align: right; padding-top: 3px;">Đến ngày</div>
                                        <div style="float: left; width: 192px; padding-left: 12px;">
                                            <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="192px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                    </div>

                                    <div runat="server" style="float: left; width: 100%; margin-top: 10px;" id="div1">
                                        <div style="float: left; width: 100px; text-align: right; padding-top: 3px;">Phạm vi tìm kiếm</div>
                                        <div style="float: left;  padding-left: 62px;">
                                            <asp:DropDownList CssClass="chosen-select" ID="Drop_object" runat="server" Width="320" AutoPostBack="true">
                                                <asp:ListItem Value="TH" Selected="True" Text="Tất cả"></asp:ListItem>
                                                <asp:ListItem Value="T" Text="Cục THADS"></asp:ListItem>
                                                <asp:ListItem Value="H" Text="Chi cục THADS"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div runat="server" style="float: left; width: 100%; margin-top: 10px;" id="div2">
                                        <div style="float: left; margin-left:9px;margin-right:28px; text-align: right; padding-top: 3px;">Hình thức thanh toán</div>
                                        <div style="float: left;  padding-left: 12px;">
                                            <asp:DropDownList CssClass="chosen-select" ID="ddl_TRUCTUYEN" runat="server" Width="320px">
                                                <asp:ListItem Value="" Selected="True" Text="Tất cả"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Trực tuyến"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>     

                                    <%------------------------------------------------%>
                                    <div style="float: left; width: 100%; margin-top: 10px;">
                                        <div style="float: left; margin-left: 110px;">
                                            <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 0px; font-size: 15px;"></asp:Label>
                                        </div>
                                    </div>
                                    <div style="float: left; width: 800px; margin-top: 10px;">
                                        <div style="float: left; margin-left: 161px;">
                                            <div style="float: left;">
                                                <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput" Text="Báo cáo" OnClientClick="return ValidateInput();" OnClick="cmdPrint_Click" />
                                            </div>
                                            <div style="float: left; margin-left: 7px;">
                                                <asp:Button ID="btn_NhapMoi" runat="server" CssClass="buttoninput" Text="Nhập mới" OnClick="btn_NhapMoi_Click" />

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ValidateInput() {
            var txtNgay_Tu = document.getElementById('<%=txtTuNgay.ClientID%>');
            if (txtNgay_Tu != null && txtNgay_Den != null) {
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtTuNgay, 'từ ngày')) {
                    return false;
                }
                var txtNgay_Den = document.getElementById('<%=txtDenNgay.ClientID%>');
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtDenNgay, 'đến ngày')) {
                    return false;
                }
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
</asp:Content>
