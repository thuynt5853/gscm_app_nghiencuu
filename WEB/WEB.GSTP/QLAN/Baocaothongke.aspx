<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Baocaothongke.aspx.cs" Inherits="WEB.GSTP.QLAN.Baocaothongke" %>

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
                                    <div style="float: left; width: 800px;">
                                        <div style="float: left; width: 100px; text-align: right; padding-top: 3px;">Chọn báo cáo</div>
                                        <div style="float: left; width: 501px; padding-left: 12px;">
                                            <asp:DropDownList ID="ddl_menu_bc" CssClass="chosen-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="myListDropDown_Change"
                                                runat="server" Width="486px">
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div style="float: left; width: 800px; margin-top: 10px;">
                                        <div style="float: left; width: 100px; text-align: right; padding-top: 3px;">Người lập biểu</div>
                                        <div style="float: left; padding-left: 12px;">
                                            <asp:DropDownList ID="drop_cbtk" CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                                        </div>
                                        <div style="float: left; width: 76px; text-align: right; padding-top: 3px;">Lãnh đạo ký</div>
                                        <div style="float: left; padding-left: 12px;">
                                            <asp:DropDownList ID="Drop_ld_phong" CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div style="float: left; width: 800px; margin-top: 17px;">
                                        <div id="lb_tungay" style="float: left; width: 100px; text-align: right; padding-top: 3px;">Từ ngày</div>
                                        <div style="float: left; width: 192px; padding-left: 12px;">
                                            <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="192px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                        <div style="float: left; width: 70px; text-align: right;margin-right: 14px; padding-top: 3px;">Đến ngày</div>
                                        <div style="float: left; width: 192px; padding-left: 12px;">
                                            <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="192px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </div>
                                    </div>

                                    <div runat="server" style="float: left; width: 800px; margin-top: 10px;" id="div1">
                                        <div style="float: left; width: 100px; text-align: right; padding-top: 3px;">Đơn vị</div>
                                        <div style="float: left;  padding-left: 12px;">
                                            <asp:DropDownList ID="ddlPhongban" CssClass="chosen-select"
                                                runat="server" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="ddlPhongban_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; margin-left:9px;margin-right:10px; text-align: right; padding-top: 3px;">Thẩm phán</div>
                                        <div style="float: left;  padding-left: 10px;">
                                            <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select"
                                                runat="server" Width="200px">
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div style="display: none;">
                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                                    </div>

                                    <%--   ------------------------------------------------%>
                                    <div style="float: left; width: 800px; margin-top: 10px;">
                                        <div style="float: left; margin-left: 110px;">
                                            <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 0px; font-size: 15px;"></asp:Label>
                                        </div>
                                    </div>
                                    <div style="float: left; width: 800px; margin-top: 10px;">
                                        <div style="float: left; margin-left: 380px;">
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
            var txtNgay_Tu = document.getElementById('<%=txtThuly_Tu.ClientID%>');
            if (txtNgay_Tu != null && txtNgay_Den != null) {
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtThuly_Tu, 'từ ngày')) {
                    return false;
                }
                var txtNgay_Den = document.getElementById('<%=txtThuly_Den.ClientID%>');
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtThuly_Den, 'đến ngày')) {
                    return false;
                }
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) {
                var $el = $(selector);
                if ($el.length > 0) {
                    $el.chosen(config[selector]);
                    $el.trigger("chosen:updated");
                }
            }
        }
    </script>
</asp:Content>
