<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="NguoiThamgiaTT.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.SoTham.NguoiThamgiaTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style type="text/css">
        .AHS_SoTham_ToTung_Col1 {
            width: 147px;
        }

        .AHS_SoTham_ToTung_Col2 {
            width: 195px;
        }

        .AHS_SoTham_ToTung_Col3 {
            width: 127px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin người tham gia tố tụng</h4>
                <div class="boder" style="padding: 10px;">
                    <div style="width: 90%; padding: 10px;">
                        <asp:RadioButtonList ID="rdbLoai" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="True" OnSelectedIndexChanged="rdbLoai_SelectedIndexChanged">
                            <asp:ListItem Value="0" Text="Nhập thông tin mới" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Chọn từ hồ sơ vụ án"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <asp:Panel ID="pnNew" runat="server">
                        <table class="table1">
                            <tr>
                                <td class="AHS_SoTham_ToTung_Col1">Tên người TGTT<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="99.4%"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="AHS_SoTham_ToTung_Col1">Địa chỉ (mã HC)<span class="batbuoc">(*)</span></td>
                                <td class="AHS_SoTham_ToTung_Col2">
                                    <asp:HiddenField ID="hddDiaChiID" runat="server" />
                                    <asp:TextBox ID="txtDiaChi" CssClass="user" runat="server" Width="94%" MaxLength="250"></asp:TextBox></td>
                                <td class="AHS_SoTham_ToTung_Col3">Địa chỉ chi tiết</td>
                                <td>
                                    <asp:TextBox ID="txtDiaChiChitiet" CssClass="user" runat="server" Width="99%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Giới tính</td>
                                <td>
                                    <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select" runat="server" Width="98%">
                                        <asp:ListItem Value="1" Text="Nam" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Ngày sinh</td>
                                <td>
                                    <asp:TextBox ID="txtNgaysinh" runat="server" CssClass="user" Width="90px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtNgaysinh_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    Tháng sinh
                                    <asp:TextBox ID="txtThangsinh" onkeypress="return isNumber(event)" CssClass="user" runat="server" Width="30px" MaxLength="2"></asp:TextBox>
                                    Năm sinh
                                    <asp:TextBox ID="txtNamsinh" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="60px" MaxLength="4"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Nghề nghiệp</td>
                                <td>
                                    <asp:DropDownList ID="ddlNgheNghiep" CssClass="chosen-select" runat="server" Width="98%"></asp:DropDownList>
                                </td>
                                <td>Chức vụ</td>
                                <td>
                                    <asp:TextBox ID="txtChucvu" CssClass="user" runat="server" Width="99%" MaxLength="20"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Ngày tham gia</td>
                                <td>
                                    <asp:TextBox ID="txtNgaythamgia" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythamgia" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaythamgia" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgaythamgia" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <td>Ngày kết thúc</td>
                                <td>
                                    <asp:TextBox ID="txtNgayketthuc" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayketthuc" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayketthuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txtNgayketthuc" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Tư cách tham gia tố tụng<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:CheckBoxList ID="chkTuCach" runat="server" RepeatDirection="Horizontal" RepeatColumns="2"></asp:CheckBoxList>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnChon" Visible="false" runat="server">
                        <table class="table1">
                            <tr>
                                <td style="width: 125px;"><b>Chọn người TGTT</b></td>
                                <td>
                                    <asp:CheckBoxList ID="chkListTGTT" runat="server" RepeatDirection="Vertical" RepeatColumns="1"></asp:CheckBoxList>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Label runat="server" ID="lblMsgChon" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: center;">
                                    <asp:Button ID="cmdChonTGTT" runat="server" CssClass="buttoninput" Text="Chọn đưa vào thụ lý Sơ thẩm" OnClick="cmdChonTGTT_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <asp:HiddenField ID="hddid" runat="server" Value="0" />
                            <asp:Panel runat="server" ID="pndata" Visible="false">
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
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                       
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="240px">
                                            <HeaderTemplate>
                                                Tư cách TGTT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TenTuCachTGTT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="240px">
                                            <HeaderTemplate>
                                                Họ và tên
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("HOTEN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Địa chỉ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("DIACHI") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYTHAMGIA" HeaderText="Ngày tham gia" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYKETTHUC" HeaderText="Ngày kết thúc" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
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
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ValidInputData() {
            var txtHoten = document.getElementById('<%=txtHoten.ClientID%>');
            var lengthHoten = txtHoten.value.trim().length;
            if (lengthHoten == 0) {
                alert('Bạn chưa nhập tên người tham gia tố tụng!');
                txtHoten.focus();
                return false;
            }
            if (lengthHoten > 250) {
                alert('Tên người tham gia tố tụng không nhập quá 250 ký tự. Hãy nhập lại!');
                txtHoten.focus();
                return false;
            }
            var txtDiaChi = document.getElementById('<%=txtDiaChi.ClientID%>');
            if (txtDiaChi.value.trim().length == 0) {
                alert('Bạn chưa nhập địa chỉ (mã HC)!');
                txtDiaChi.focus();
                return false;
            }
            var txtDiaChiChitiet = document.getElementById('<%=txtDiaChiChitiet.ClientID%>');
            if (txtDiaChiChitiet.value.trim().length > 250) {
                alert('Địa chỉ chi tiết không quá 250 ký tự. Hãy nhập lại!');
                txtDiaChiChitiet.focus();
                return false;
            }

            var txtNgaysinh = document.getElementById('<%=txtNgaysinh.ClientID%>');
            if (txtNgaysinh.value.trim().length > 0) {
                var arr = txtNgaysinh.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).');
                    txtNgaysinh.focus();
                    return false;
                }
            }
            var txtChucvu = document.getElementById('<%=txtChucvu.ClientID%>');
            if (txtChucvu.value.trim().length > 250) {
                alert('Chức vụ người đại diện không quá 250 ký tự. Hãy nhập lại!');
                txtChucvu.focus();
                return false;
            }

            var txtNgaythamgia = document.getElementById('<%=txtNgaythamgia.ClientID%>');
            if (txtNgaythamgia.value.trim().length > 0) {
                var arr = txtNgaythamgia.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày tham gia theo định dạng (dd/MM/yyyy).');
                    txtNgaythamgia.focus();
                    return false;
                }
            }
            var txtNgayketthuc = document.getElementById('<%=txtNgayketthuc.ClientID%>');
            if (txtNgayketthuc.value.trim().length > 0) {
                var arr = txtNgayketthuc.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày kết thúc theo định dạng (dd/MM/yyyy).');
                    txtNgayketthuc.focus();
                    return false;
                }
            }
            var CHK = document.getElementById("<%=chkTuCach.ClientID%>");
            var checkbox = CHK.getElementsByTagName("input");
            var counter = 0;
            for (var i = 0; i < checkbox.length; i++) {
                if (checkbox[i].checked) {
                    counter++;
                    break;
                }
            }
            if (counter == 0) {
                alert('Bạn chưa chọn tư cách tham gia tố tụng. Hãy chọn lại!');
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            $(function () {
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';
                $("[id$=txtDiaChi]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddDiaChiID]").val(i.item.val); }, minLength: 1
                });
            });
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
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
