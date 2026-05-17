<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Capnhat.aspx.cs" Inherits="WEB.GSTP.QTDKK.DSTaikhoanND.Capnhat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .tdWidthTblToaAn {
            width: 100px;
            padding-left: 20px !important;
        }

        .tdWidthTblToaAn1 {
            width: 80px;
        }

        .tdWidthTblToaAn2 {
            /*width: 230px;*/
            width: 200px;
        }

        .borderfieldset {
            border: 1px solid #ccc;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            border-radius: 10px;
            padding: 10px 1% 10px 1%;
            margin: 10px 1%;
        }
    </style>

    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                <table class="table1">
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Loại tài khoản</b></td>
                        <td colspan="5">
                            <asp:RadioButtonList ID="radUSERTYPE" runat="server" OnSelectedIndexChanged="radUSERTYPE_SelectedIndexChanged" RepeatDirection="Horizontal" AutoPostBack="True">
                                <asp:ListItem Value="1" Selected="True">Cá nhân</asp:ListItem>
                                <asp:ListItem Value="2">Doanh nghiệp</asp:ListItem>
                                <asp:ListItem Value="3">Tổ chức</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Mục đích sử dụng</b></td>
                        <td colspan="5">
                            <asp:RadioButtonList ID="rdMucDichSD" CssClass="dangky_rd_mucdichsd"
                                runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True"><b>Nộp đơn khởi kiện và nhận văn bản tống đạt</b></asp:ListItem>
                                <asp:ListItem Value="2"><b>Chỉ nhận văn bản tống đạt</b></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                </table>
                <fieldset class="borderfieldset" style="width: 96%; float: left">
                    <legend style="padding:0px 5px;">
                        <asp:Label ID="lblThongTin" Text="Thông tin cá nhân" runat="server" Font-Bold="true"></asp:Label>
                    </legend>
                    <table class="table1">

                        <tr>
                            <td class="tdWidthTblToaAn1">Họ tên<span class="must_input">(*)</span></td>
                            <td colspan="3">
                                <asp:TextBox ID="txtNDD_HOTEN" CssClass="user" runat="server" Width="94%" MaxLength="250"></asp:TextBox></td>
                            <td style="width: 70px">Giới tính<span class="must_input">(*)</span></td>
                            <td>
                                <asp:DropDownList CssClass="user" ID="dropNDD_GIOITINH" runat="server"
                                    Width="240px" AutoPostBack="true">
                                    <asp:ListItem Value="1">Nam</asp:ListItem>
                                    <asp:ListItem Value="2">Nữ</asp:ListItem>
                                    <asp:ListItem Value="3">Khác</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdWidthTblToaAn1">Ngày sinh</td>
                            <td class="tdWidthTblToaAn2">
                                <asp:TextBox ID="txtNDD_NGAYSINH" runat="server" CssClass="user" 
                                    Width="170px" MaxLength="10" 
                                    AutoPostBack="true" OnTextChanged="txtNDD_NGAYSINH_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNDD_NGAYSINH_CalendarExtender" runat="server" TargetControlID="txtNDD_NGAYSINH" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNDD_NGAYSINH" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNDD_NGAYSINH" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px"></cc1:MaskedEditValidator>

                            </td>

                             
                            <td class="tdWidthTblToaAn1">Năm sinh<span class="must_input">(*)</span></td>
                            <td class="tdWidthTblToaAn2">
                                <asp:TextBox ID="txtNamSinh" CssClass="user" runat="server"
                                    onkeypress="return isNumber(event)" 
                                    Width="170" MaxLength="250"></asp:TextBox></td>
                            <td>Quốc tịch</td>
                            <td>
                                <asp:DropDownList ID="dropQuocTich" runat="server" Width="240px"
                                    CssClass="user" placeholder="Quốc tịch">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr><td colspan="6" style="border-bottom:dotted 1px #dcdcdc;"></td></tr>
                        <tr>
                            <td class="tdWidthTblToaAn1">Số CMND<span class="must_input">(*)</span></td>
                            <td class="tdWidthTblToaAn2">
                                <asp:TextBox ID="txtNDD_CMND" CssClass="user" runat="server" 
                                    onkeypress="return isNumber(event)" 
                                    Width="170px" MaxLength="250"></asp:TextBox></td>

                            <td class="tdWidthTblToaAn1">Ngày cấp</td>
                            <td>
                                <asp:TextBox ID="txtNDD_NGAYCAP" runat="server" CssClass="user" 
                                    onkeypress="return isNumber(event)" 
                                    Width="170px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNDD_NGAYCAP" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNDD_NGAYCAP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNDD_NGAYCAP" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px"></cc1:MaskedEditValidator>

                            </td>
                            <td>Nơi cấp</td>
                            <td>
                                <asp:TextBox ID="txtNDD_NOICAP" CssClass="user" runat="server" Width="230px" MaxLength="250"></asp:TextBox></td>

                        </tr>
                        <tr>
                            <td colspan="4"><i>(Số CMND/ Thẻ căn cước/ Hộ chiếu)</i></td>
                            <td colspan="2"><i>(Nơi cấp Số CMND/ Thẻ căn cước/ Hộ chiếu)</i></td>
                        </tr>
                        <tr><td colspan="6" style="border-bottom:dotted 1px #dcdcdc;"></td></tr>
                        <tr>
                            <td class="tdWidthTblToaAn1">Tỉnh/ TP<span class="must_input">(*)</span></td>
                            <td class="tdWidthTblToaAn2">
                                <asp:DropDownList ID="dropTinh" runat="server" placeholder="Tỉnh"
                                    CssClass="user" AutoPostBack="True" Width="180px"
                                    OnSelectedIndexChanged="dropTinh_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td class="tdWidthTblToaAn1">Quận/ Huyện</td>
                            <td>
                                <asp:DropDownList ID="dropQuan" runat="server" placeholder="Quận"
                                    CssClass="user" Width="180px">
                                </asp:DropDownList>
                            </td>
                            <td>Chi tiết</td>
                            <td><asp:TextBox ID="txtDIACHI_CHITIET" CssClass="user" runat="server" Width="230px" MaxLength="250"></asp:TextBox></td>
                        </tr>
                       <tr><td colspan="6" style="border-bottom:dotted 1px #dcdcdc;"></td></tr>
                        <tr>
                            <td class="tdWidthTblToaAn1">Số di động<span class="must_input">(*)</span></td>
                            <td class="tdWidthTblToaAn2">
                                <asp:TextBox ID="txtMOBILE" CssClass="user" runat="server" 
                                    onkeypress="return isNumber(event)" 
                                    Width="170px" MaxLength="250"></asp:TextBox></td>

                            <td class="tdWidthTblToaAn1">Số cố định</td>
                            <td class="tdWidthTblToaAn2">
                                <asp:TextBox ID="txtTELEPHONE" CssClass="user" runat="server"
                                    onkeypress="return isNumber(event)" 
                                    Width="170px" MaxLength="250"></asp:TextBox></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </fieldset>
                <asp:Panel ID="plDoanhNghiep" runat="server" Visible="False">
                    <fieldset class="borderfieldset" style="width: 96%; float: left;">
                        <legend style="padding:0px 5px;">
                            <asp:Label ID="lblthongtinDN" Text="Thông tin doanh nghiệp" runat="server" Font-Bold="true"></asp:Label></legend>
                        <table class="table1">
                            <asp:Panel ID="pnlttDN" runat="server" Visible="true">
                                <tr>
                                    <td class="tdWidthTblToaAn1">Mã số thuế<span class="must_input">(*)</span></td>
                                    <td class="tdWidthTblToaAn2">
                                        <asp:TextBox ID="txtDN_MASOTHUE" CssClass="user"
                                            onkeypress="return isNumber(event)" 
                                            runat="server" Width="170px" MaxLength="250"></asp:TextBox></td>
                                    <td class="tdWidthTblToaAn1">Giấy phép kinh doanh<span class="must_input">(*)</span></td>
                                    <td class="tdWidthTblToaAn2">
                                        <asp:TextBox ID="txtDN_GPDKKD" CssClass="user" runat="server" Width="170px" MaxLength="250"></asp:TextBox></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td class="tdWidthTblToaAn1">Tên tiếng Việt<span class="must_input">(*)</span></td>
                                <td colspan="5">
                                    <asp:TextBox ID="txtDN_TENVN" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="tdWidthTblToaAn1">Tên tiếng Anh</td>
                                <td colspan="5">
                                    <asp:TextBox ID="txtDN_TENEN" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                        </table>
                    </fieldset>
                </asp:Panel>
                <fieldset class="borderfieldset" style="width: 96%; float: left;">
                    <legend><b>Thông tin tài khoản</b></legend>
                    <table class="table1">
                        <tr>
                            <td class="tdWidthTblToaAn1">Email<span class="must_input">(*)</span></td>
                            <td colspan="5">
                                <asp:TextBox ID="txtEMAIL" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td colspan="6">(<i>Sử dụng làm tài khoản đăng nhập hệ thống</i>)</td>
                        </tr>
                        <tr id="td_mk" runat="server">
                            <td class="tdWidthTblToaAn1">Mật khẩu<span class="must_input">(*)</span><asp:HiddenField ID="hddmatkhau" Value="0" runat="server" />
                            </td>
                            <td class="tdWidthTblToaAn2">
                                <asp:TextBox ID="txtPASSWORD" CssClass="user" runat="server" Width="170px" MaxLength="250" TextMode="Password"></asp:TextBox></td>
                            <td class="tdWidthTblToaAn1">Xác nhận mật khẩu<span class="must_input">(*)</span></td>
                            <td class="tdWidthTblToaAn2">
                                <asp:TextBox ID="txtREPASSWORD" CssClass="user" runat="server" Width="170px" MaxLength="250" TextMode="Password"></asp:TextBox></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <%--<tr>
                            <td class="tdWidthTblToaAn1">Câu hỏi xác thực</td>
                            <td colspan="5">
                                <asp:DropDownList CssClass="user" ID="dropREMINDERQUERYQUESTION" runat="server" Width="99%" AutoPostBack="true">
                                    <asp:ListItem Value="1">Con vật bạn nuôi tên là gì?</asp:ListItem>
                                    <asp:ListItem Value="2">Một cộng một bằng?</asp:ListItem>
                                    <asp:ListItem Value="3">Tên bạn là gì?</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdWidthTblToaAn1">Câu trả lời</td>
                            <td colspan="5">
                                <asp:TextBox ID="txtREMINDERQUERYANSWER" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                        </tr>--%>
                    </table>
                </fieldset>
                <table class="table1">
                    <tr>
                        <td></td>
                        <td>
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Cập nhật" OnClick="btnUpdate_Click" OnClientClick="return kiemtra()" />
                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lblquaylai_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function kiemtra() {
            //Người đại diện
            var txtHoTen = document.getElementById('<%=txtNDD_HOTEN.ClientID%>');
            if (!Common_CheckEmpty(txtHoTen.value)) {
                alert('Bạn chưa nhập "Họ và tên". Hãy kiểm tra lại!');
                txtHoTen.focus();
                return false;
            }

            //--------------------            
            var txtNDD_NGAYSINH = document.getElementById('<%=txtNDD_NGAYSINH.ClientID%>');
            if (Common_CheckEmpty(txtNDD_NGAYSINH.value, 'Ngày sinh')) {
                if (!CheckDateTimeControl(txtNDD_NGAYSINH, 'Ngày sinh'))
                    return false;
            }

            var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
            if (!Common_CheckEmpty(txtNamSinh.value)) {
                alert('Bạn chưa nhập "Năm sinh". Hãy kiểm tra lại!');
                txtNamSinh.focus();
                return false;
            }

            var CurrentYear = '<%=CurrYear%>';
            if (txtNamSinh.value > CurrentYear) {
                alert('Năm sinh không được lớn hơn năm hiện tại. Hãy kiểm tra lại!');
                txtNamSinh.focus();
                return false;
            }
            
            //--------------------
            var txtSoCMND = document.getElementById('<%=txtNDD_CMND.ClientID%>');
            if (!Common_CheckEmpty(txtSoCMND.value)) {
                alert('Bạn chưa nhập "Số CMND/ Thẻ căn cước/ Hộ chiếu". Hãy kiểm tra lại!');
                txtSoCMND.focus();
                return false;
            }
            //--------------------------
            var txtNDD_NGAYCAP = document.getElementById('<%=txtNDD_NGAYCAP.ClientID%>');
            if (Common_CheckEmpty(txtNDD_NGAYCAP.value, 'Ngày cấp CMND/Thẻ căn cước/Hộ chiếu')) {
                if (!CheckDateTimeControl(txtNDD_NGAYCAP, 'Ngày cấp CMND/Thẻ căn cước/Hộ chiếu'))
                    return false;
                //-------------------------
                var NamSinh = parseInt(txtNamSinh.value);
                var temp = txtNDD_NGAYCAP.value.split('/');
                var Nam_CapCMND = parseInt(temp[2]);
                sonam = Nam_CapCMND - NamSinh;
                if (sonam < 14) {
                    alert('Tài khoản đang cập nhật thông tin chưa đủ 14 tuổi. Hãy kiểm tra lại!');
                    txtNDD_NGAYCAP.focus();
                    return false;
                }
            }

            //-----------------------------------            
            var dropTinh = document.getElementById('<%=dropTinh.ClientID%>');
            value_change = dropTinh.options[dropTinh.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn Tỉnh/TP nơi cư trú. Hãy kiểm tra lại!');
                dropTinh.focus();
                return false;
            }

            //--------------------
            var txtDienThoai = document.getElementById('<%=txtMOBILE.ClientID%>');
            if (!Common_CheckEmpty(txtDienThoai.value)) {
                alert('Bạn chưa nhập "Số điện thoại". Hãy kiểm tra lại!');
                txtDienThoai.focus();
                return false;
            }

            //Thông tin tài khoản
            //--------------------
            var txtEmail = document.getElementById('<%=txtEMAIL.ClientID%>');
            if (!Common_CheckEmpty(txtEmail.value)) {
                alert('Bạn chưa nhập "Địa chỉ email". Hãy kiểm tra lại!');
                txtEmail.focus();
                return false;
            }
            else {
                if (!Common_ValidateEmail(txtEmail.value)) {
                    txtEmail.focus();
                    return false;
                }
            }

            //--------------------
            var hddmatkhau = document.getElementById('<%=hddmatkhau.ClientID%>');
            if (hddmatkhau.value = "0") {
                var txtPass = document.getElementById('<%=txtPASSWORD.ClientID%>');
                if (!Common_CheckEmpty(txtPass.value)) {
                    alert('Bạn chưa nhập "Mật khẩu". Hãy kiểm tra lại!');
                    txtPass.focus();
                    return false;
                }

                var txtRePass = document.getElementById('<%=txtREPASSWORD.ClientID%>');
                if (!Common_CheckEmpty(txtRePass.value)) {
                    alert('Bạn chưa nhập "Xác nhận mật khẩu". Hãy kiểm tra lại!');
                    txtRePass.focus();
                    return false;
                }

                if (txtPass.value != txtRePass.value) {
                    alert('Bạn nhập "Xác nhận mật khẩu" chưa khớp với "Mật khẩu". Hãy kiểm tra lại!');
                    txtRePass.focus();
                    return false;
                }
            }

            //Thông tin doanh nghiệp
            var selected = GetLoaiTaiKhoan();
            if (selected == 2) {
                if (!Validate_ThongTinDN())
                    return false;
            }
            return true;
        }

        function Validate_ThongTinDN() {
            var txtDN_MASOTHUE = document.getElementById('<%= txtDN_MASOTHUE.ClientID%>');
            if (!Common_CheckEmpty(txtDN_MASOTHUE.value)) {
                alert('Bạn chưa nhập "Mã số thuế". Hãy kiểm tra lại!');
                txtDN_MASOTHUE.focus();
                return false;
            }
            var txtDN_GPDKKD = document.getElementById('<%= txtDN_GPDKKD.ClientID%>');
            if (!Common_CheckEmpty(txtDN_GPDKKD.value)) {
                alert('Bạn chưa nhập "Số giấy phép kinh doanh". Hãy kiểm tra lại!');
                txtDN_GPDKKD.focus();
                return false;
            }
            var txtDN_TENVN = document.getElementById('<%= txtDN_TENVN.ClientID%>');
            if (!Common_CheckEmpty(txtDN_TENVN.value)) {
                alert('Bạn chưa nhập "Tên doanh nghiệp bằng tiếng Việt". Hãy kiểm tra lại!');
                txtDN_TENVN.focus();
                return false;
            }
            return true;
        }


        function GetLoaiTaiKhoan() {
            var rb = document.getElementById("<%=radUSERTYPE.ClientID%>");
            var inputs = rb.getElementsByTagName('input');
            var flag = false;
            var selected;
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].checked) {
                    selected = inputs[i];
                    flag = true;
                    break;
                }
            }
            if (flag)
                return selected.value;
        }
        
    </script>
</asp:Content>


