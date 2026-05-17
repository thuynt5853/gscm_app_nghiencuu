<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="NguoiThamgiaTT.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Hoso.NguoiThamgiaTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .ADS_ToTung_Col1 {
            width: 173px;
        }

        .ADS_ToTung_Col2 {
            width: 324px;
        }

        .ADS_ToTung_Col3 {
            width: 80px;
        }

        .lblTitleTT {
            margin: 6px 5px 0px 10px;
            width: 55px;
            float: left;
        }

        .floatF {
            float: left;
        }

        .Text_AlignR {
            text-align: right;
        }

        .namsinh {
            float: left;
            margin: 6px 5px 0px 10px;
            width: 84px;
        }
    </style>
       
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanDon" Value="" runat="server" />
    <asp:HiddenField ID="HiddenField2" Value="" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <asp:TextBox ID="txtTenNguyenDon" CssClass="user" runat="server" Style="display:none;" ClientIDMode="Static" ></asp:TextBox>
        <asp:TextBox ID="txtTenBiCan" CssClass="user" runat="server" Style="display:none;" ClientIDMode="Static" ></asp:TextBox>
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin người tham gia tố tụng</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td>Tư cách tham gia tố tụng<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlTucachTGTT" CssClass="chosen-select" runat="server" Width="318px" ClientIDMode="Static" onchange="handleDropdownChange()">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="ADS_ToTung_Col1">Họ tên người TGTT<span class="batbuoc">(*)</span></td>
                            <td class="ADS_ToTung_Col2">
                                <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="310px" ></asp:TextBox>
                            </td>
                            <td class="ADS_ToTung_Col3">Ngày tham gia</td>
                            <td>
                                <asp:TextBox ID="txtNgaythamgia" runat="server" CssClass="user" Width="80px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythamgia" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaythamgia" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Nơi sinh sống</td>
                            <td>
                                <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server" Width="310px" MaxLength="250"></asp:TextBox></td>

                            <td>Nơi ĐKHKTT</td>
                            <td>
                                <asp:TextBox ID="txtND_HKTT_Chitiet" CssClass="user" runat="server" Width="310px" MaxLength="250"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Giới tính</td>
                            <td>
                                <div class="floatF">
                                    <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select" runat="server" Width="124px">
                                        <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <span class="lblTitleTT">Ngày sinh</span>
                                <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user floatF" Width="116px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td>Năm sinh</td>
                            <td>
                                <asp:TextBox ID="txtND_Namsinh" CssClass="user floatF Text_AlignR" onkeypress="return isNumber(event)" runat="server" Width="80px" MaxLength="4"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Điện thoại</td>
                            <td>
                                <asp:TextBox ID="txtDienThoai" CssClass="user floatF Text_AlignR" onkeypress="return isNumber(event)" runat="server" Width="116px"></asp:TextBox>
                                <span class="lblTitleTT">Fax</span>
                                <asp:TextBox ID="txtFax" CssClass="user floatF Text_AlignR" onkeypress="return isNumber(event)" runat="server" Width="116px"></asp:TextBox>
                            </td>
                            <td>Email</td>
                            <td>
                                <asp:TextBox ID="txtEmail" CssClass="user floatF" runat="server" Width="310px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Đại diện cho</td>
                            <td>
                                <asp:TextBox ID="txtNDD_Hoten" CssClass="user" runat="server" Width="310px" MaxLength="250"></asp:TextBox></td>
                            <td colspan="2"></td>
                        </tr>
                        <tr>
                        </tr>
                    </table>
                </div>
            </div>
            
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" OnClientClick="return ValidDataInput();" Text="Lưu" OnClick="btnUpdate_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
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
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="HOTEN" HeaderText="Họ và tên" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENTC" HeaderText="Tư cách TGTT" HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="Tamtru" HeaderText="Địa chỉ nơi sinh sống" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTHAMGIA" HeaderText="Ngày tham gia" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
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
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
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
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ValidDataInput() {
            var ddlTucachTGTT = document.getElementById('<%=ddlTucachTGTT.ClientID%>');
            var val = ddlTucachTGTT.options[ddlTucachTGTT.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn tư cách tham gia tố tụng. Hãy chọn lại!');
                ddlTucachTGTT.focus();
                return false;
            }
            var txtHoten = document.getElementById('<%=txtHoten.ClientID%>');
            var lengthHoten = txtHoten.value.trim().length;
            if (lengthHoten == 0) {
                alert('Bạn chưa nhập họ tên người tham gia tố tụng!');
                txtHoten.focus();
                return false;
            }
            if (lengthHoten > 250) {
                alert('Họ tên người tham gia tố tụng không nhập quá 250 ký tự. Hãy nhập lại!');
                txtHoten.focus();
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
                var hddNgayNhanDon = document.getElementById('<%=hddNgayNhanDon.ClientID%>');
                var NgayNhanDon;
                if (hddNgayNhanDon.value != "") {
                    var arr = hddNgayNhanDon.value.split('/');
                    NgayNhanDon = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                }
                if (D < NgayNhanDon) {
                    alert('Bạn phải nhập ngày tham gia lớn hơn ngày nhận đơn ' + hddNgayNhanDon.value + '!');
                    txtNgaythamgia.focus();
                    return false;
                }
                var DateNow = Date.now();
                if (D > DateNow) {
                    alert('Bạn phải nhập ngày tham gia nhỏ hơn ngày hiện tại!');
                    txtNgaythamgia.focus();
                    return false;
                }
            }
            var txtND_TTChitiet = document.getElementById('<%=txtND_TTChitiet.ClientID%>');
            if (txtND_TTChitiet.value.trim().length > 250) {
                alert('Nơi sinh sống chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                txtND_TTChitiet.focus();
                return false;
            }
            var txtND_HKTT_Chitiet = document.getElementById('<%=txtND_HKTT_Chitiet.ClientID%>');
            if (txtND_HKTT_Chitiet.value.trim().length > 250) {
                alert('Nơi ĐKHKTT chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                txtND_HKTT_Chitiet.focus();
                return false;
            }
            var txtND_Ngaysinh = document.getElementById('<%=txtND_Ngaysinh.ClientID%>');
            if (txtND_Ngaysinh.value.trim().length > 0) {
                var arr = txtND_Ngaysinh.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).');
                    txtND_Ngaysinh.focus();
                    return false;
                }
                if (D > DateNow) {
                    alert('Bạn phải nhập ngày sinh nhỏ hơn ngày hiện tại!');
                    txtND_Ngaysinh.focus();
                    return false;
                }
            }
         
            var txtDienThoai = document.getElementById('<%=txtDienThoai.ClientID%>');
            if (txtDienThoai.value.trim().length > 250) {
                alert('Điện thoại không nhập quá 250 ký tự. Hãy nhập lại!');
                txtDienThoai.focus();
                return false;
            }
            var txtFax = document.getElementById('<%=txtFax.ClientID%>');
            if (txtFax.value.trim().length > 250) {
                alert('Fax không nhập quá 250 ký tự. Hãy nhập lại!');
                txtFax.focus();
                return false;
            }
            var txtEmail = document.getElementById('<%=txtEmail.ClientID%>');
            var lengthEmail = txtEmail.value.trim().length;
            if (lengthEmail > 0) {
                var email = txtEmail.value;
                var atpos = email.indexOf("@");
                var dotpos = email.lastIndexOf(".");
                if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= txtEmail.value.length) {
                    alert("Địa chỉ email chưa đúng.");
                    txtEmail.focus();
                    return false;
                }
                if (lengthEmail > 250) {
                    alert('Email không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtEmail.focus();
                    return false;
                }
            }
            var txtNDD_Hoten = document.getElementById('<%=txtNDD_Hoten.ClientID%>');
            if (txtNDD_Hoten.value.trim().length > 250) {
                alert('Đại diện cho không nhập quá 250 ký tự. Hãy nhập lại!');
                txtNDD_Hoten.focus();
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
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
        function handleDropdownChange() {
            var ddl = document.getElementById("ddlTucachTGTT");
            var txtBox = document.getElementById('<%=txtHoten.ClientID%>');
            var txtNguyenDon = document.getElementById("txtTenNguyenDon")
            var txtBiCao = document.getElementById("txtTenBiCan");
            var selectedValue = ddl.value;
            if (selectedValue == "TGTTBPXLHC-01") {
                txtBox.value = txtNguyenDon.value;
                txtBox.disabled = true; // Không cho sửa
            } else if (selectedValue == "TGTTBPXLHC-02") {
                txtBox.value = txtBiCao.value;
                txtBox.disabled = true; // Không cho sửa
            }
            else {
                txtBox.value = "";
                txtBox.disabled = false; // Cho phép sửa lại nếu cần
            }
        }
    </script>
</asp:Content>
