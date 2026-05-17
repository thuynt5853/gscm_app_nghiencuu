<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KQGiaiQuyet.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.CongVanTHA.KQGiaiQuyet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style>
        .boxchung {
            float: left;
            width: 99%;
            margin-left: 0;
        }

        .title_ds {
            float: left;
            width: 100%;
            background: #fff none repeat scroll 0 0;
            white-space: nowrap;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .cell_zone_right {
            float: left;
            margin-left: 10px;
            line-height: 25px;
        }

            .cell_zone_right span {
                margin-right: 3px;
            }
            .dxsplLCC 
            {
                height:500px !important;
            }
    </style>
    <div class="box">
        <div class="box_nd">
            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                <asp:Literal ID="lstMsgTop" runat="server"></asp:Literal>
            </div>
            <div class="content_form">

                <!---------------------------------------->
                <div class="boxchung">
                    <h4 class="tleboxchung bg_title_group bg_green">
                        <asp:Literal ID="lttGroup" runat="server" Text="Kết quả giải quyết công văn/ đơn"></asp:Literal></h4>
                    <div class="boder" style="padding: 20px 10px;">
                        <table class="table1">

                            <tr>
                                <td style="width: 80px;">Yêu cầu</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtYeuCau" CssClass="user" Enabled="false"
                                        runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Chủ tọa<span class="batbuoc">(*)</span></td>
                                <td style="width: 250px;">
                                    <asp:DropDownList ID="dropChuToa" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                    </asp:DropDownList></td>
                                <td style="width: 100px;">Ngày mở phiên họp<span class="batbuoc">(*)</span></td>
                                <td>
                                    <span style="float: left; width: 200px;">
                                        <asp:TextBox ID="txtNgayMoPhienHop" AutoPostBack="true" OnTextChanged="txtNgayMoPhienHop_TextChanged" runat="server" CssClass="user"
                                            Width="110px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                            TargetControlID="txtNgayMoPhienHop" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                            TargetControlID="txtNgayMoPhienHop" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </span>
                                    <span class="cell_zone_right">
                                        <span style="float: left; width: 80px; line-height: 15px;">Ngày kết thúc phiên họp<span class="batbuoc">(*)</span></span>
                                        <asp:TextBox ID="txtNgayKT" runat="server" CssClass="user"
                                            Width="90px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server"
                                            TargetControlID="txtNgayKT" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server"
                                            TargetControlID="txtNgayKT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </span>
                                </td>
                            </tr>

                            <tr>
                                <td>Kiểm sát viên<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropKSV" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                    </asp:DropDownList>
                                    <%-- <asp:TextBox ID="txtKiemSoatVien" CssClass="user"
                                        runat="server" Width="242px"></asp:TextBox>--%>
                                </td>
                                <td>Ý kiến của VKS<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdYKienVKS" runat="server"
                                        RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="0">Không đồng ý</asp:ListItem>
                                        <asp:ListItem Value="1">Đồng ý</asp:ListItem>
                                    </asp:RadioButtonList></td>
                            </tr>
                            <tr>
                                <td>Số văn bản<span class="batbuoc">(*)</span></td>
                                <td>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtSoVB" CssClass="user"
                                            runat="server" Width="90px"></asp:TextBox>
                                    </div>
                                    <div class="cell_zone_right">
                                        <span style='float: left; width: 65px; line-height: 25px;'>Ngày ký<span class="batbuoc">(*)</span></span>
                                        <asp:TextBox ID="txtNgayKyVB" runat="server" CssClass="user"
                                            Width="65px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                            TargetControlID="txtNgayKyVB" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                            TargetControlID="txtNgayKyVB" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </div>
                                </td>
                                <td>Người ký<span class="batbuoc">(*)</span></td>
                                <td>
                                    <div style="float: left;">
                                        <asp:DropDownList ID="dropNguoiKy" CssClass="chosen-select"
                                            runat="server" Width="200px" AutoPostBack="true"
                                            OnSelectedIndexChanged="dropNguoiKy_SelectedIndexChanged">
                                        </asp:DropDownList>

                                        <%-- <asp:TextBox ID="txtNguoiKy" CssClass="user"
                                            runat="server" Width="110px"></asp:TextBox>--%>
                                    </div>
                                    <div class="cell_zone_right">
                                        <span style="float: left; width: 80px; line-height: 15px;">Chức vụ<span class="batbuoc">(*)</span>
                                        </span>
                                        <asp:TextBox ID="txtChucVu" CssClass="user" Enabled="false"
                                            runat="server" Width="90px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="4" style="height: 10px;"></td>
                            </tr>
                            <tr>
                                <td>Kết quả<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdKetQua" runat="server"
                                        RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="0">Không chấp nhận</asp:ListItem>
                                        <asp:ListItem Value="1">Chấp nhận</asp:ListItem>
                                        <asp:ListItem Value="2">Chấp nhận một phần</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>

                            <tr>
                                <td>Ghi chú</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGhiChu" CssClass="user"
                                        runat="server" Width="640px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div style="margin: 5px; text-align: center; width: 95%">
                                        <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput" Text="Lưu"
                                            OnClientClick="return validate();" OnClick="cmdSave_Click" />
                                        <asp:Button ID="cmdBack" runat="server" CssClass="buttoninput"
                                            Text="Quay lại" OnClick="cmdBack_Click" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div style="color: red; font-weight: bold;">
                                        <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <script>

        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function validate() {
            var dropChuToa = document.getElementById('<%=dropChuToa.ClientID%>');
            value_change = dropChuToa.options[dropChuToa.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn chủ tọa phiên tòa. Hãy kiểm tra lại!');
                dropChuToa.focus();
                return false;
            }
            //------------------------
            var txtNgayMoPhienHop = document.getElementById('<%=txtNgayMoPhienHop.ClientID%>');
            if (!CheckDateTimeControl(txtNgayMoPhienHop, 'Ngày mở phiên họp'))
                return false;
            var txtNgayKT = document.getElementById('<%=txtNgayKT.ClientID%>');
            if (!CheckDateTimeControl(txtNgayKT, 'Ngày kết thúc phiên họp'))
                return false;

            var NgaySoSanh = txtNgayMoPhienHop.value;
            if (!SoSanh2Date(txtNgayKT, 'Ngày kết thúc phiên họp', NgaySoSanh, 'Ngày mở phiên họp')) {
                txtNgayKT.focus();
                return false;
            }

            //------------------------
            var dropKSV = document.getElementById('<%=dropKSV.ClientID%>');
            value_change = dropKSV.options[dropKSV.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn kiểm sát viên. Hãy kiểm tra lại!');
                dropKSV.focus();
                return false;
            }
            //------------------------
            var txtSoVB = document.getElementById('<%=txtSoVB.ClientID%>');
            if (!Common_CheckTextBox(txtSoVB, "số văn bản"))
                return false;

            var txtNgayKyVB = document.getElementById('<%=txtNgayKyVB.ClientID%>');
            if (!CheckDateTimeControl(txtNgayKyVB, 'Ngày ký'))
                return false;
            //------------------------
            var dropNguoiKy = document.getElementById('<%=dropNguoiKy.ClientID%>');
            value_change = dropNguoiKy.options[dropNguoiKy.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn người ký. Hãy kiểm tra lại!');
                dropNguoiKy.focus();
                return false;
            }
            var txtGhiChu = document.getElementById('<%=txtGhiChu.ClientID%>');
            return true;
        }
    </script>
</asp:Content>
