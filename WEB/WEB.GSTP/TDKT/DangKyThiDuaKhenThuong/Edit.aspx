<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WEB.GSTP.TDKT.DangKyThiDuaKhenThuong.Edit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        .msg_error {
            text-align: left !important;
        }

        .box {
            padding-bottom: 0px !important;
        }

        .img_Xoa {
            width: 12px;
            height: 12px;
            margin-left: 5px;
        }

        .KhenThuong_Col1 {
            width: 108px;
        }

        .KhenThuong_Col2 {
            width: 300px;
        }

        .KhenThuong_Col3 {
            width: 75px;
        }
    </style>
    <asp:HiddenField ID="hddID" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td><b>Đơn vị<span style="color: red;"> (*)</span></b></td>
                        <td colspan="3">
                            <asp:DropDownList ID="DropToaAn" Width="535px" class="check" runat="server" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Tên danh sách<span style="color: red;"> (*)</span></b></td>
                        <td colspan="3">
                            <asp:TextBox runat="server" ID="TxtTenDanSach" Width="527px" CssClass="user" MaxLength="500"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="KhenThuong_Col1"><b>Loại đề nghị<span style="color: red;"> (*)</span></b></td>
                        <td class="KhenThuong_Col2">
                            <asp:DropDownList ID="DropLoaiDeNghi" Width="278px" class="check" runat="server" CssClass="chosen-select">
                                <asp:ListItem Text="--- Chọn ---" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Thi đua" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Khen thưởng" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Kỷ luật" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td class="KhenThuong_Col3"><b>Năm<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:TextBox ID="TxtNam" runat="server" CssClass="user align_right" Width="137px" MaxLength="4" onkeypress="return isNumber(event)"></asp:TextBox>

                        </td>
                    </tr>
                    <%--<tr>
                        <td><b>Số QĐ<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtSoQD" Width="90%" CssClass="user" MaxLength="100"></asp:TextBox></td>
                        <td><b>Ngày QĐ<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:TextBox ID="TxtNgayQD" runat="server" CssClass="user" Width="136px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TxtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="TxtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>--%>
                    <tr>
                        <td><b>Người lập</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtNguoiLap" Width="270px" CssClass="user" MaxLength="250"></asp:TextBox>
                        </td>
                        <td><b>Ngày lập</b></td>
                        <td>
                            <asp:TextBox ID="TxtNgayLap" runat="server" CssClass="user" Width="136px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="TxtNgayLap" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="TxtNgayLap" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Người duyệt</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtNguoiDuyet" Width="270px" CssClass="user" MaxLength="250"></asp:TextBox>
                        </td>
                        <td><b>Chức vụ</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtChucVu" Width="136px" CssClass="user" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <%--<tr>
                        <td><b>Tệp đính kèm</b></td>
                        <td colspan="3">
                            <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                            <asp:LinkButton ID="LbtDownload" runat="server" OnClick="LbtDownload_Click" Text=""></asp:LinkButton>
                            <asp:ImageButton ID="ImgXoa" runat="server" ImageUrl="~/UI/img/delete.png" OnClick="ImgXoa_Click" Visible="false" CssClass="img_Xoa" />
                        </td>
                    </tr>--%>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="BtnLuu_Click" />
                            <asp:Button ID="BtnLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="BtnLamMoi_Click" />
                            <asp:Button ID="BtnQuayLai" runat="server" Style="margin-top: 10px;" CssClass="buttoninput" Text="Quay lại" OnClick="BtnQuayLai_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Label runat="server" ID="Lblthongbao" CssClass="msg_error"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function Validate() {
            var DropToaAn = document.getElementById('<%=DropToaAn.ClientID%>');
            var val = DropToaAn.options[DropToaAn.selectedIndex].value;
            if (val == 0) {
                alert('Chưa chọn đơn vị. Hãy chọn lại.');
                DropToaAn.focus();
                return false;
            }
            var TxtTenDanSach = document.getElementById('<%=TxtTenDanSach.ClientID%>');
            var Length = TxtTenDanSach.value.trim().length;
            if (Length == 0) {
                alert('Tên danh sách không được để trống. Hãy nhập lại.');
                TxtTenDanSach.focus();
                return false;
            } else if (Length > 500) {
                alert('Tên danh sách không được quá 500 ký tự. Hãy nhập lại.');
                TxtTenDanSach.focus();
                return false;
            }
            var DropLoaiDeNghi = document.getElementById('<%=DropLoaiDeNghi.ClientID%>');
            val = DropLoaiDeNghi.options[DropLoaiDeNghi.selectedIndex].value;
            if (val == 0) {
                alert('Chưa chọn loại đề nghị. Hãy chọn lại.');
                DropLoaiDeNghi.focus();
                return false;
            }

            var TxtNam = document.getElementById('<%=TxtNam.ClientID%>');
            Length = TxtNam.value.trim().length;
            if (Length == 0) {
                alert('Năm không được trống. Hãy nhập lại.');
                TxtNam.focus();
                return false;
            }
            if ((Length > 0 && Length < 4) || Length > 4) {
                alert('Năm phải là số có 04 chữ số. Hãy nhập lại.');
                TxtNam.focus();
                return false;
            }
            var now = new Date();
            var YearNow = now.getFullYear();
            var YearTemp = TxtNam.value;
            if (YearTemp > YearNow) {
                alert('Năm không được lớn hơn năm hiện tại. Hãy nhập lại.');
                TxtNam.focus();
                return false;
            }

            var TxtNguoiLap = document.getElementById('<%=TxtNguoiLap.ClientID%>');
            Length = TxtNguoiLap.value.trim().length;
            if (Length > 250) {
                alert('Tên người lập không quá 250 ký tự. Hãy nhập lại.');
                TxtNguoiLap.focus();
                return false;
            }
            var TxtNgayLap = document.getElementById('<%=TxtNgayLap.ClientID%>');
            Length = TxtNgayLap.value.trim().length;
            if (Length > 0) {
                if (!Common_IsTrueDate(TxtNgayLap.value)) {
                    TxtNgayLap.focus();
                    return false;
                }
                var now = new Date();
                var temp = TxtNgayLap.value.split('/');
                var DateTemp = new Date(temp[2], temp[1] - 1, temp[0]);
                if (now < DateTemp) {
                    alert('Ngày thành lập phải nhỏ hơn hoặc bằng ngày hiện tại!');
                    TxtNgayLap.focus();
                    return false;
                }
            }
            var TxtNguoiDuyet = document.getElementById('<%=TxtNguoiDuyet.ClientID%>');
            Length = TxtNguoiDuyet.value.trim().length;
            if (Length > 250) {
                alert('Tên người duyệt không quá 250 ký tự. Hãy nhập lại.');
                TxtNguoiDuyet.focus();
                return false;
            }
            var TxtChucVu = document.getElementById('<%=TxtChucVu.ClientID%>');
            Length = TxtChucVu.value.trim().length;
            if (Length > 250) {
                alert('Chức vụ người duyệt không quá 250 ký tự. Hãy nhập lại.');
                TxtChucVu.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
