<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Capnhatkhangcaoquahan.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Phuctham.Capnhatkhangcaoquahan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:Panel ID="pnDanhsach" runat="server">
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td>
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm vụ việc</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td style="width: 105px;">Mã vụ việc</td>
                                                <td style="width: 127px;">
                                                    <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="100px" MaxLength="50"></asp:TextBox></td>
                                                <td style="width: 62px;">Tên vụ việc</td>
                                                <td>
                                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="360px" MaxLength="250"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Ngày kháng cáo từ</td>
                                                <td>
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Trạng thái</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbTrangthai" runat="server" RepeatDirection="Horizontal">
                                                        <asp:ListItem Value="0" Text="Chưa giải quyết" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã giải quyết"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validateSearch();" />
                                <asp:Button ID="cmdGiaiQuyet" runat="server" CssClass="buttoninput" Text="Giải quyết" OnClick="cmdGiaiQuyet_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                <div class="phantrang" id="ptT" runat="server">
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
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkChon_CheckedChanged" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="MAVUVIEC" HeaderText="Mã vụ việc" HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TenToaAn" HeaderText="Tòa án" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYKHANGCAO" HeaderText="Ngày kháng cáo" HeaderStyle-Width="94px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="KETQUA" HeaderText="Kết quả" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="idKhangCao" HeaderText="ID Kháng Cáo" HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center" Visible="False"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang" id="ptB" runat="server">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:HiddenField ID="hddKhangCaoID" runat="server" />

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
    </asp:Panel>
    <asp:Panel ID="pnCapnhat" runat="server" Visible="false">
        <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Kết quả giải quyết kháng cáo của tòa Phúc thẩm</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td colspan="4">
                                        <span style="font-weight: bold;" id="lblTenVuAn" runat="server"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 101px;">Ngày giải quyết<span class="batbuoc">(*)</span></td>
                                    <td style="width: 105px;">
                                        <asp:TextBox ID="txtNgaygiaiquyet" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgaygiaiquyet" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgaygiaiquyet" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td style="width: 80px;">Thẩm phán<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlGQ_Thamphan" CssClass="chosen-select" runat="server" Width="350px"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Kết quả<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdbChapnhan" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="1" Text="Chấp nhận"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Không chấp nhận"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ghi chú</td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtGQGhichu" runat="server" CssClass="user" Width="545px" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;" colspan="4">
                                        <asp:Button ID="cmdCapnhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhat_Click" OnClientClick="return validateUpdate();" />
                                        <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;" colspan="4">
                                        <asp:Label runat="server" ID="lbthongBaoUpdate" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <script type="text/javascript">
        function validateSearch() {
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            var lengthTuNgay = txtTuNgay.value.trim().length;
            var TuNgay;
            if (lengthTuNgay > 0) {
                var arr = txtTuNgay.value.split('/');
                TuNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (TuNgay.toString() == "NaN" || TuNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập hiệu lực từ ngày theo định dạng (dd/MM/yyyy).');
                    txtTuNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            var lengthDenNgay = txtDenNgay.value.trim().length;
            var DenNgay;
            if (lengthDenNgay > 0) {
                var arr = txtDenNgay.value.split('/');
                DenNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (DenNgay.toString() == "NaN" || DenNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày hiệu lực đến ngày theo định dạng (dd/MM/yyyy).');
                    txtDenNgay.focus();
                    return false;
                }
            }
            if (lengthTuNgay > 0 && lengthDenNgay > 0 && TuNgay > DenNgay) {
                alert('Ngày kháng cáo từ ngày phải nhỏ hơn đến ngày.');
                txtDenNgay.focus();
                return false;
            }
            return true;
        }
        function validateUpdate() {
            var txtNgaygiaiquyet = document.getElementById('<%=txtNgaygiaiquyet.ClientID%>');
            var lengthNgayGQ = txtNgaygiaiquyet.value.trim().length;
            if (lengthNgayGQ == 0) {
                alert('Bạn phải nhập ngày giải quyết theo định dạng (dd/MM/yyyy).');
                txtNgaygiaiquyet.focus();
                return false;
            }
            if (lengthNgayGQ > 0) {
                var arr = txtNgaygiaiquyet.value.split('/');
                var NgayGiaiQuyet = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (NgayGiaiQuyet.toString() == "NaN" || NgayGiaiQuyet.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày giải quyết theo định dạng (dd/MM/yyyy).');
                    txtNgaygiaiquyet.focus();
                    return false;
                }
            }
            var ddlGQ_Thamphan = document.getElementById('<%=ddlGQ_Thamphan.ClientID%>');
            var val = ddlGQ_Thamphan.options[ddlGQ_Thamphan.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn thẩm phán. Hãy chọn lại!');
                ddlGQ_Thamphan.focus();
                return false;
            }
            var rdbChapnhan = document.getElementById('<%=rdbChapnhan.ClientID%>');
            var msg = 'Bạn chưa chọn kết quả. Hãy chọn lại!';
            if (!CheckChangeRadioButtonList(rdbChapnhan, msg))
                return false;
            var txtGQGhichu = document.getElementById('<%=txtGQGhichu.ClientID%>');
            if (txtGQGhichu.value.trim().length > 250) {
                alert('Ghi chú không quá 250 ký tự. Hãy nhập lại!');
                txtGQGhichu.focus();
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
