<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Sauxetxu.aspx.cs" Inherits="WEB.GSTP.QLAN.AKT.Sauxetxu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:Panel ID="pnDanhsach" runat="server">
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
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
                                                <td style="width: 260px;">
                                                    <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                                <td style="width: 78px;">Tên vụ việc</td>
                                                <td>
                                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Số QĐ/BA</td>
                                                <td><asp:TextBox ID="txtSoQDBA" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                                <td>Tên đương sự</td>
                                                <td><asp:TextBox ID="txtTenDuongSu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Ngày QĐ/BA từ</td>
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
                                                        <asp:ListItem Value="0" Text="Chưa cập nhật" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã cập nhật"></asp:ListItem>
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
                                <asp:Button ID="cmdTTSauXetXu" runat="server" CssClass="buttoninput" Text="Rút kinh nghiệm sau xét xử" OnClick="cmdTTSauXetXu_Click" />
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
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="MAVUVIEC" HeaderText="Mã vụ việc" HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="GiaiDoan" HeaderText="Giai đoạn" HeaderStyle-Width="135px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px"
                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID")+"#"+Eval("GiaiDoan")%>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID")+"#"+Eval("GiaiDoan")%>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang" id="ptB" runat="server">
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
    </asp:Panel>
    <asp:Panel ID="pnCapnhat" runat="server" Visible="false">
        <asp:HiddenField ID="hddTotalPageSelected" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndexSelected" Value="1" runat="server" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Nội dung rút kinh nghiệm sau xét xử</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td colspan="4">
                                        <b>DANH SÁCH CÁC VỤ VIỆC ĐÃ CHỌN</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div class="phantrang">
                                            <div class="sobanghi">
                                                <asp:Literal ID="lstSobanghiTSelected" runat="server"></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbTBackSelected" runat="server" CausesValidation="false" CssClass="back"
                                                    OnClick="lbTBackSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTFirstSelected" runat="server" CausesValidation="false" CssClass="active"
                                                    Text="1" OnClick="lbTFirstSelected_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep1Selected" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbTStep2Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="2" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep3Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="3" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep4Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="4" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep5Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="5" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep6Selected" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbTLastSelected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="100" OnClick="lbTLastSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTNextSelected" runat="server" CausesValidation="false" CssClass="next"
                                                    OnClick="lbTNextSelected_Click"></asp:LinkButton>
                                            </div>
                                        </div>
                                        <asp:DataGrid ID="dgListSelected" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" Width="100%">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>TT</HeaderTemplate>
                                                    <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="MAVUVIEC" HeaderText="Mã vụ việc" HeaderStyle-Width="130px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="TENVUVIEC" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            </Columns>
                                            <HeaderStyle CssClass="header"></HeaderStyle>
                                            <ItemStyle CssClass="chan"></ItemStyle>
                                            <PagerStyle Visible="false"></PagerStyle>
                                        </asp:DataGrid>
                                        <div class="phantrang">
                                            <div class="sobanghi">
                                                <asp:Literal ID="lstSobanghiBSelected" runat="server"></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbBBackSelected" runat="server" CausesValidation="false" CssClass="back"
                                                    OnClick="lbTBackSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBFirstSelected" runat="server" CausesValidation="false" CssClass="active"
                                                    Text="1" OnClick="lbTFirstSelected_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep1Selected" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbBStep2Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="2" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep3Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="3" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep4Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="4" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep5Selected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="5" OnClick="lbTStepSelected_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep6Selected" runat="server" Text="..."></asp:Label>
                                                <asp:LinkButton ID="lbBLastSelected" runat="server" CausesValidation="false" CssClass="so"
                                                    Text="100" OnClick="lbTLastSelected_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBNextSelected" runat="server" CausesValidation="false" CssClass="next"
                                                    OnClick="lbTNextSelected_Click"></asp:LinkButton>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 132px;">Ngày rút kinh nghiệm<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNgayRutKN" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayRutKN" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayRutKN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nội dung<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNoiDung" runat="server" CssClass="user" Width="99%" MaxLength="500"></asp:TextBox>
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
                    alert('Bạn phải nhập ngày QĐ/BA từ ngày theo định dạng (dd/MM/yyyy).');
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
                    alert('Bạn phải nhập ngày QĐ/BA đến ngày theo định dạng (dd/MM/yyyy).');
                    txtDenNgay.focus();
                    return false;
                }
            }
            if (lengthTuNgay > 0 && lengthDenNgay > 0 && TuNgay > DenNgay) {
                alert('Ngày QĐ/BA từ ngày phải nhỏ hơn đến ngày.');
                txtHieuLucDenNgay.focus();
                return false;
            }
            return true;
        }
        function validateUpdate() {
            var txtNgayRutKN = document.getElementById('<%=txtNgayRutKN.ClientID%>');
            var lengthNgayRutKN = txtNgayRutKN.value.trim().length;
            if (lengthNgayRutKN == 0) {
                alert('Bạn phải nhập ngày rút kinh nghiệm theo định dạng (dd/MM/yyyy).');
                txtNgayRutKN.focus();
                return false;
            }
            if (lengthNgayRutKN > 0) {
                var arr = txtNgayRutKN.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày rút kinh nghiệm theo định dạng (dd/MM/yyyy).');
                    txtNgayRutKN.focus();
                    return false;
                }
            }
            var txtNoiDung = document.getElementById('<%=txtNoiDung.ClientID%>');
            var lengthNoiDung = txtNoiDung.value.trim().length;
            if (lengthNoiDung == 0) {
                alert('Bạn chưa nhập nội dung.');
                txtNoiDung.focus();
                return false;
            }
            if (lengthNoiDung > 500) {
                alert('Nội dung không nhập quá 500 ký tự.');
                txtNoiDung.focus();
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
