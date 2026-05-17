<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="WEB.GSTP.Danhmuc.BoLuat.Edit" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddType" Value="1" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .check_list_vertical {
            padding-right: 15px;
            width: 90%;
            height: 250px;
            border: solid 1px #dcdcdc;
            overflow-y: auto;
        }

        .tieude_ds {
            float: left;
            text-transform: uppercase;
            font-weight: bold;
            line-height: 22px;
        }

        .box_nd {
            position: relative;
        }

        a {
            cursor: pointer;
        }
    </style>
    <div class="box" style="float: left; width: 98%; margin-bottom: 10px;">
        <table class="table1">
            <tr>
                <td class="tdWidthTblToaAn" style="width: 90px;"><b>Chọn</b></td>
                <td colspan="3">
                    <asp:RadioButtonList ID="rdLoai" runat="server"
                        AutoPostBack="true"
                        RepeatDirection="Horizontal" OnSelectedIndexChanged="rdLoai_SelectedIndexChanged">

                        <asp:ListItem Value="1" Selected="true">Chương</asp:ListItem>
                        <asp:ListItem Value="2">Điều</asp:ListItem>
                        <asp:ListItem Value="3">Khoản</asp:ListItem>
                        <asp:ListItem Value="4">Điểm</asp:ListItem>

                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td class="tdWidthTblToaAn" style="width: 70px;"><b>Bộ luật</b></td>
                <td colspan="3">
                    <asp:DropDownList ID="dropBoLuat" runat="server"
                        CssClass="chosen-select" Width="250px"
                        AutoPostBack="true" OnSelectedIndexChanged="dropBoLuat_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <div class="box_nd">

            <table class="table1">
                <tr>
                    <td style="width: 90px;"></td>
                    <td style="width: 260px;"></td>
                    <td style="width: 80px;"></td>
                    <td></td>
                </tr>
                <asp:Panel ID="pnChuong" runat="server">
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Chương</b><span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:HiddenField ID="hddMaChuong" runat="server" />
                            <asp:DropDownList ID="dropChuong" runat="server"
                                CssClass="chosen-select" Width="250px"
                                AutoPostBack="true" OnSelectedIndexChanged="dropChuong_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </asp:Panel>
                <tr>
                    <asp:Panel ID="row_drop_dieu" runat="server">
                        <td class="tdWidthTblToaAn"><b>Điều</b><span class="batbuoc">(*)</span></td>
                        <td style="width: 260px;">
                            <asp:HiddenField ID="hddMaDieu" runat="server" />
                            <asp:DropDownList ID="dropDieu" runat="server"
                                CssClass="chosen-select" Width="250px"
                                AutoPostBack="true" OnSelectedIndexChanged="dropDieu_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </asp:Panel>
                    <asp:Panel ID="row_drop_khoan" runat="server">
                        <td class="tdWidthTblToaAn"><b>Khoản</b><span class="batbuoc">(*)</span></td>
                        <td>
                            <asp:HiddenField ID="hddMaKhoan" runat="server" />
                            <asp:DropDownList ID="dropKhoan" runat="server"
                                CssClass="chosen-select" Width="250px"
                                AutoPostBack="true" OnSelectedIndexChanged="dropKhoan_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </asp:Panel>
                </tr>
                <tr>
                    <td style="width: 60px;"><b>
                        <asp:Label ID="lblMa" runat="server"></asp:Label></b></td>
                    <td>
                        <asp:TextBox ID="txtMa" runat="server" CssClass="user" Width="242px"></asp:TextBox>
                    </td>
                    <td>Mức độ nghiêm trọng</td>
                    <td><asp:DropDownList ID="dropLoaiToiPham"
                        CssClass="chosen-select" runat="server" Width="233px"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="tdWidthTblToaAn"><b>Tiêu đề</b> <span class="batbuoc">(*)</span></td>
                    <td colspan="3">
                        <asp:TextBox ID="txtTenToiDanh" runat="server" CssClass="user" Width="582px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="tdWidthTblToaAn"><b>Chi tiết</b></td>
                    <td colspan="3">
                        <asp:TextBox ID="txtChiTietToiDanh" runat="server" CssClass="user" TextMode="MultiLine" Rows="2" Width="582px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="tdWidthTblToaAn"><b>Thứ tự</b></td>
                    <td>
                        <asp:TextBox ID="txtThuTu" runat="server"
                            onkeypress="return isNumber(event)"
                            CssClass="user" Width="242px"></asp:TextBox>
                    </td>
                    <td class="tdWidthTblToaAn"><b>Hiệu lực</b></td>
                    <td>
                        <asp:RadioButtonList ID="rdHieuLuc" runat="server"
                            RepeatDirection="Horizontal">
                            <asp:ListItem Value="1" Selected="True">Có</asp:ListItem>
                            <asp:ListItem Value="0">Không</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
               <%-- <tr>
                        <td class="tdWidthTblToaAn"><b>Thời gian thử thách</b><span class="batbuoc">(*)</span></td>
                        <td colspan="3">
                            <asp:RadioButtonList ID="rdThoiGianThuThach" runat="server" 
                                RepeatDirection="Horizontal">
                                <asp:ListItem Value="1">Có</asp:ListItem>
                                <asp:ListItem Value="0">Không</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>--%>
                <asp:Panel ID="pnIsHinhPhat" runat="server">
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Có khung hình phạt</b></td>
                        <td colspan="3">
                            <asp:RadioButtonList ID="rdIsHinhPhat" runat="server" RepeatDirection="Horizontal"
                                AutoPostBack="true" OnSelectedIndexChanged="rdIsHinhPhat_SelectedIndexChanged">
                                <asp:ListItem Value="1">Có</asp:ListItem>
                                <asp:ListItem Value="0" Selected="True">Không</asp:ListItem>

                            </asp:RadioButtonList>

                        </td>
                    </tr>
                </asp:Panel>
                <asp:Panel ID="pnHinhPhat" runat="server">
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Hình phạt</b></td>
                        <td colspan="3">
                            <div class="check_list_vertical">
                                <asp:TreeView ID="treeHinhPhat" runat="server" ShowCheckBoxes="Leaf" ShowLines="true" ForeColor="#333">
                                </asp:TreeView>
                                <asp:CheckBoxList ID="chkHinhPhat" runat="server" RepeatColumns="3"></asp:CheckBoxList>
                            </div>
                        </td>
                    </tr>
                </asp:Panel>
                <tr>
                    <td></td>
                    <td colspan="3">
                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                            OnClick="btnUpdate_Click" OnClientClick="return Validate()" />
                        <asp:Button ID="cmdQuayLai" runat="server" CssClass="buttoninput"
                            Text="Quay lại" OnClick="cmdQuayLai_Click" />

                    </td>
                </tr>
            </table>

            <div style="float: left; width: 100%; margin-top: 15px;">
                <asp:HiddenField ID="hddToiDanh" runat="server" Value="0" />
                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
            </div>

            <div class="tieude_ds" style="float: left; width: 100%; margin-bottom: 15px; display: none;">
                <asp:Literal ID="lttDanhSach" runat="server" Text="Danh sách"></asp:Literal>
            </div>

        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script>
        function Validate() {
            var value_change = "";
            var rdLoai = document.getElementById('<%=rdLoai.ClientID%>');

            var selected_value = GetStatusRadioButtonList(rdLoai);
            if (selected_value == "2") {
                var dropChuong = document.getElementById('<%=dropChuong.ClientID %>');
                value_change = dropChuong.options[dropChuong.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn "Chương". Hãy kiểm tra lại!');
                    dropChuong.focus();
                    return false;
                }
            }
            else if (selected_value == "3") {
                var dropChuong = document.getElementById('<%=dropChuong.ClientID%>');
                value_change = dropChuong.options[dropChuong.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn "Chương". Hãy kiểm tra lại!');
                    dropChuong.focus();
                    return false;
                }
                //------------------------
                var dropDieu = document.getElementById('<%=dropDieu.ClientID%>');
                value_change = dropDieu.options[dropDieu.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn "Điều". Hãy kiểm tra lại!');
                    dropDieu.focus();
                    return false;
                }
            }
            else if (selected_value == "4") {
                var dropChuong = document.getElementById('<%=dropChuong.ClientID%>');
                value_change = dropChuong.options[dropChuong.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn "Chương". Hãy kiểm tra lại!');
                    dropChuong.focus();
                    return false;
                }
                //------------------------
                var dropDieu = document.getElementById('<%=dropDieu.ClientID%>');
                value_change = dropDieu.options[dropDieu.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn "Điều". Hãy kiểm tra lại!');
                    dropDieu.focus();
                    return false;
                }
                //------------------------
                var dropKhoan = document.getElementById('<%=dropKhoan.ClientID%>');
                value_change = dropKhoan.options[dropKhoan.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn "Khoản". Hãy kiểm tra lại!');
                    dropKhoan.focus();
                    return false;
                }
            }
            //-------------------------------------------------
            var txtTen = document.getElementById('<%=txtTenToiDanh.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tiêu đề. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            //-------------------------------------------------
            var txtThuTu = document.getElementById('<%=txtThuTu.ClientID%>');
            if (!Common_CheckEmpty(txtThuTu.value)) {
                alert('Bạn chưa nhập số sắp xếp thứ tự. Hãy kiểm tra lại!');
                txtThuTu.focus();
                return false;
            }
            return true;
        }

    </script>
</asp:Content>
