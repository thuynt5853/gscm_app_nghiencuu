<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="BienPhapNganChan.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.BienPhapNganChan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
    <asp:HiddenField ID="hddBPNC_TamGiam" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">

                <%--<div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>--%>
                <div class="boxchung">
                    <h4 class="tleboxchung">Biện pháp ngăn chặn</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td class="table_edit_col1">Bị can<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="dropBiCan" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Biện pháp ngăn chặn</td>
                                <td class="table_edit_col2">
                                    <asp:DropDownList ID="dropBienPhapNganChan" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList></td>
                                <td style="width: 120px;">Đơn vị ra quyết định</td>
                                <td>
                                    <asp:DropDownList ID="dropDV" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td>Ngày bắt đầu có hiệu lực<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayBatDau" runat="server"
                                        onkeypress="return isNumber(event)"
                                        CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBatDau"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBatDau"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td style="width: 130px;">Thời gian tạm giam</td>
                                <td>
                                    <asp:TextBox ID="txtSoNgay" runat="server"
                                        onkeypress="return isNumber(event)"
                                        CssClass="user" Width="50px" MaxLength="10"
                                        AutoPostBack="true" OnTextChanged="txtSoNgay_TextChanged"></asp:TextBox>
                                    ngày
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày hết hiệu lực hoặc ngày được tha<span class="batbuoc">(*)</span>
                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNgayKT" runat="server"
                                        onkeypress="return isNumber(event)"
                                        CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayKT"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayKT"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>

                            <tr>
                                <td colspan="4">
                                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                                    </div>
                                    <div style="margin: 5px; text-align: center; width: 95%">
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" OnClick="cmdUpdate_Click"
                                            Text="Lưu" OnClientClick="return validate();" />
                                        <asp:Button ID="cmdThemMoi" runat="server" CssClass="buttoninput"
                                            Text="Thêm mới" OnClick="cmdThemMoi_Click" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>

                </div>
                <asp:Panel runat="server" ID="pndata">
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
                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                        <HeaderTemplate>
                            <table class="table2" style="width: 100%;" border="1">
                                <tr class="header">
                                    <td style="width: 30px; text-align: center;">TT</td>
                                    <td style="text-align: center;">Tên bị can</td>
                                    <td style="text-align: center;">Biện pháp ngăn chặn</td>
                                    <td style="width: 145px; text-align: center;">Ngày bắt đầu có hiệu lực</td>
                                    <td style="width: 220px; text-align: center;">Ngày hết hiệu lực hoặc ngày được tha</td>
                                    <td style="width: 60px; text-align: center;">Thao tác</td>
                                </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td style="text-align: center;"><%# Eval("STT") %></td>
                                <td><%#Eval("HoTen") %></td>
                                <td><%# Eval("TenBienPhapNganChan") %></td>
                                <td style="text-align: center;"><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayBatDau")) %></td>
                                <td style="text-align: center;">
                                    <asp:Literal ID="ltrNgayKetThuc" runat="server"></asp:Literal></td>
                                <td style="text-align: center;">
                                    <div>
                                        <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false"
                                            CommandName="Sua" ForeColor="#0e7eee"
                                            CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                        &nbsp;&nbsp;
                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa"
                                        ForeColor="#0e7eee"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');">
                                    </asp:LinkButton>
                                    </div>
                                </td>
                                <td style="display: none;">
                                    <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></table></FooterTemplate>
                    </asp:Repeater>

                    <div class="phantrang">
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
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function validate() {

            var dropBiCan = document.getElementById('<%=dropBiCan.ClientID%>');
            var value_change = dropBiCan.options[dropBiCan.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn bị can cần xử lý. Hãy kiểm tra lại!');
                dropBiCan.focus();
                return false;
            }
            //------------------------------------
            var txtNgayBatDau = document.getElementById('<%=txtNgayBatDau.ClientID%>');
            if (!Common_CheckEmpty(txtNgayBatDau.value)) {
                alert('Bạn chưa nhập ngày bắt đầu có hiệu lực. Hãy kiểm tra lại!');
                txtNgayBatDau.focus();
                return false;
            }
            if (!Common_IsTrueDate(txtNgayBatDau.value))
                return false;
            //------------------------------------
            <%--var dropBienPhapNganChan = document.getElementById('<%=dropBienPhapNganChan.ClientID%>').value;
            var txtSoNgay = document.getElementById('<%=txtSoNgay.ClientID%>');
            if (dropBienPhapNganChan == "138" || dropBienPhapNganChan == "140") {
                if (!Common_CheckEmpty(txtSoNgay.value)) {
                    alert('Bạn chưa nhập thời gian tạm giam!');
                    txtSoNgay.focus();
                    return false;
                }
            }--%>
            //----------------------
            var dropBienPhapNganChan = document.getElementById('<%=dropBienPhapNganChan.ClientID%>').value;
            var txtNgayKT = document.getElementById('<%=txtNgayKT.ClientID%>');
            if (dropBienPhapNganChan == "138" || dropBienPhapNganChan == "140") {
                if (!Common_CheckEmpty(txtNgayKT.value)) {
                    alert('Bạn chưa nhập ngày hết hiệu lực hoặc ngày được tha');
                    txtNgayKT.focus();
                    return false;
                }
            }
            if (Common_CheckEmpty(txtNgayKT.value)) {
                if (!Common_IsTrueDate(txtNgayKT.value)) {
                    txtNgayKT.focus();
                    return false;
                }
                //------------------------
                if (!SoSanh2Date(txtNgayKT, 'Ngày hết hiệu lực hoặc ngày được tha', txtNgayBatDau.value, 'Ngày bắt đầu có hiệu lực')) {
                    txtNgayKT.focus();
                    return false;
                }
            }
            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

    </script>

</asp:Content>

