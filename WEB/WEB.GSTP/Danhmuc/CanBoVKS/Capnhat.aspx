<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Capnhat.aspx.cs" Inherits="WEB.GSTP.Danhmuc.CanBoVKS.Capnhat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style type="text/css">
        .lblEditDMCanBoCol1 {
            width: 115px;
        }

        .lblEditDMCanBoCol2 {
            width: 315px;
        }

        .lblEditDMCanBoCol3 {
            width: 65px;
        }

        .lblEditDMCanBoCol4 {
            width: 145px;
        }

        .lblEditDMCanBoCol5 {
            width: 115px;
        }
    </style>
    <script src="../../UI/js/Common.js"></script>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <asp:HiddenField ID="hddCbID" runat="server" Value="0" />
                <table class="table1">
                    <tr>
                        <td style="width:100px; height: 25px;"><b>Tên đơn vị</b></td>
                        <td><b><asp:Label runat="server" ID="lbTendonvi_VKS"></asp:Label></b></td>
                    </tr>
                    <tr>
                        <td style="width:100px;"><b>Chức danh</b><span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            
                            <asp:DropDownList CssClass="chosen-select" ID="DropChucVu" Enabled="false"
                                runat="server" Width="250px"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td><b>Tên cán bộ</b><span class="batbuoc">(*)</span></td>
                        <td style="width:265px;">
                            <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                        </td>
                        <td style="width:65px;"><b>Giới tính</b></td>
                        <td >
                            <asp:DropDownList CssClass="chosen-select" ID="ddlGioiTinh" runat="server" Width="118px">
                                <asp:ListItem Text="Nam" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Nữ" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>  <td ><b>Số CMND</b></td>
                        <td >
                            <asp:TextBox ID="txtCMND" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                       <td ><b>Ngày sinh</b></td>
                        <td>
                            <asp:TextBox ID="txtNgaySinh" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                TargetControlID="txtNgaySinh" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                TargetControlID="txtNgaySinh" Mask="99/99/9999" MaskType="Date"
                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                         
                        <td ><b>Số điện thoại</b></td>
                        <td>
                            <asp:TextBox ID="txtDienThoai" CssClass="user"
                                runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                   
                          <td><b>Địa chỉ</b></td>
                        <td>
                            <asp:TextBox ID="txtDiaChi" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                        </td>

                    </tr>
                    <tr>
                        <td><b>Ngày nhận công tác</b></td>
                        <td>
                            <asp:TextBox ID="txtNgayNhanCT" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtNgayNhanCT_CalendarExtender" runat="server"
                                TargetControlID="txtNgayNhanCT" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                TargetControlID="txtNgayNhanCT" Mask="99/99/9999" MaskType="Date"
                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td><b>Hiệu lực</b></td>
                        <td >
                            <asp:CheckBox ID="chkHieuluc" runat="server" Checked="true"/></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return kiemtra()" />
                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lblquaylai_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function kiemtra() {
            var DropChucVu = document.getElementById('<%=DropChucVu.ClientID%>');
            var value_change = DropChucVu.options[DropChucVu.selectedIndex].value;
            if (value_change == 0) {
                alert('Bạn chưa chọn chức danh. Hãy chọn lại!');
                DropChucVu.focus();
                return false;
            }

            var txtHoten = document.getElementById('<%=txtHoten.ClientID %>');
            if (!Common_CheckTextBox(txtHoten, "tên cán bộ")) 
                return false;

            var string_temp = txtHoten.value.trim();
            if (string_temp.length > 250)
            {
                alert('Tên cán bộ không được quá 250 ký tự. Hãy nhập lại!');
                txtHoten.focus();
                return false;
            }
            //--------------------
            var txtDiaChi = document.getElementById('<%=txtDiaChi.ClientID %>');
            if (Common_CheckEmpty(txtDiaChi.value)) {
                if (txtDiaChi.value.trim().length > 250) {
                    alert('Địa chỉ không được quá 250 ký tự. Hãy nhập lại!');
                    txtDiaChi.focus();
                    return false;
                }
            }
            
            var txtCMND = document.getElementById('<%=txtCMND.ClientID %>');
            if (Common_CheckEmpty(txtCMND.value)) {
                if (txtCMND.value.trim().length > 50) {
                    alert('Số CMND không được quá 50 ký tự. Hãy nhập lại!');
                    txtCMND.focus();
                    return false;
                }
            }
            var txtNgaySinh = document.getElementById('<%=txtNgaySinh.ClientID%>');
            if (Common_CheckEmpty(txtNgaySinh.value)) {
                if (!CheckDateTimeControl(txtNgaySinh, 'Ngày sinh'))
                    return false;
            }

            var txtDienThoai = document.getElementById('<%=txtDienThoai.ClientID %>');
            if (Common_CheckEmpty(txtDienThoai.value)) {
                if (txtDienThoai.value.trim().length > 50) {
                    alert('Số điện thoại không được quá 50 ký tự. Hãy nhập lại!');
                    txtDienThoai.focus();
                    return false;
                }
            }
            var txtNgayNhanCT = document.getElementById('<%=txtNgayNhanCT.ClientID%>');
            if (Common_CheckEmpty(txtNgayNhanCT.value)) {
                if (!CheckDateTimeControl(txtNgayNhanCT, 'Ngày nhận công tác'))
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
