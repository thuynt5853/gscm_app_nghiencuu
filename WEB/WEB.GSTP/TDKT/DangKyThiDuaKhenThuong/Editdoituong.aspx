<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Editdoituong.aspx.cs" Inherits="WEB.GSTP.TDKT.DangKyThiDuaKhenThuong.Editdoituong" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
    </style>
    <asp:HiddenField ID="hddID" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 153px;"><b>Loại đối tượng<span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:DropDownList ID="DropLoaiDoiTuong" Width="560px" class="check" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropLoaiDoiTuong_SelectedIndexChanged">
                                <asp:ListItem Text="--- Chọn ---" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Tập thể" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Cá nhân" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Đơn vị</b></td>
                        <td>
                            <asp:DropDownList ID="DropDonVi" Width="560px" class="check" runat="server" CssClass="chosen-select" Enabled="false"></asp:DropDownList>
                        </td>
                    </tr>
                    <asp:Panel ID="PnlTapThe" runat="server" Visible="false">
                        <tr>
                            <td><b>Phòng ban thuộc tòa án</b></td>
                            <td>
                                <asp:DropDownList ID="DropPhongBan" Width="560px" class="check" runat="server" CssClass="chosen-select"></asp:DropDownList>
                            </td>
                        </tr>
                    </asp:Panel>
                    <asp:Panel ID="PnlCaNhan" runat="server" Visible="false">
                        <tr>
                            <td><b>Cán bộ<span style="color: red;"> (*)</span></b></td>
                            <td>
                                <asp:DropDownList ID="DropCanBo" Width="560px" class="check" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropCanBo_SelectedIndexChanged"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Chức vụ</b></td>
                            <td>
                                <asp:TextBox ID="TxtChucVu" runat="server" CssClass="user" Width="552px" MaxLength="250"></asp:TextBox></td>
                        </tr>
                    </asp:Panel>
                    <tr>
                        <td><b>Loại đề nghị</b></td>
                        <td>
                            <asp:DropDownList ID="DropLoaiDeNghi" Width="560px" class="check" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropLoaiDeNghi_SelectedIndexChanged"></asp:DropDownList>
                        </td>
                    </tr>
                    <asp:Panel ID="PnlLoaiHinhKT" runat="server" Visible="false">
                        <tr>
                            <td><b>Phương thức khen thưởng</b></td>
                            <td>
                                <asp:DropDownList ID="DropLoaiHinhKT" Width="560px" class="check" runat="server" CssClass="chosen-select"></asp:DropDownList>
                            </td>
                        </tr>
                    </asp:Panel>
                    <tr>
                        <td><b>
                            <asp:Literal ID="LtrTitleHinhThuc" runat="server" Text="Hình thức"></asp:Literal><span style="color: red;"> (*)</span></b></td>
                        <td>
                            <asp:DropDownList ID="DropHinhThuc" Width="560px" class="check" runat="server" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>
                            <asp:Literal ID="LtrTitleNoiDung" runat="server" Text="Mô tả thành tích"></asp:Literal></b></td>
                        <td>
                            <asp:TextBox ID="TxtNoiDung" runat="server" CssClass="user" TextMode="MultiLine" Rows="18" Width="550px"></asp:TextBox>
                        </td>
                    </tr>
                    <%--<tr>
                        <td><b>Tệp đính kèm</b></td>
                        <td>
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
                        <td>
                            <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Style="margin-top: 10px;" Text="Lưu" OnClientClick="return ValidDataInput();" OnClick="BtnLuu_Click" />
                            <asp:Button ID="BtnLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="BtnLamMoi_Click" />
                            <asp:Button ID="BtnQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="BtnQuayLai_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
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
        function ValidDataInput() {
            var DropLoaiDoiTuong = document.getElementById('<%=DropLoaiDoiTuong.ClientID%>');
            var val = DropLoaiDoiTuong.options[DropLoaiDoiTuong.selectedIndex].value;
            if (val == 0) {
                alert('Chưa chọn loại đối tượng. Hãy chọn lại!');
                DropLoaiDoiTuong.focus();
                return false;
            }
            if (val == 2) {
                var DropCanBo = document.getElementById('<%=DropCanBo.ClientID%>');
                var valCanBo = DropCanBo.options[DropCanBo.selectedIndex].value;
                if (valCanBo == 0) {
                    alert('Chưa chọn cán bộ. Hãy chọn lại!');
                    DropCanBo.focus();
                    return false;
                }
                var TxtChucVu = document.getElementById('<%=TxtChucVu.ClientID%>');
                var length = TxtChucVu.value.trim().length;
                if (length > 250) {
                    alert('Chức vụ của cán bộ không quá 250 ký tự. Hãy nhập lại!');
                    TxtChucVu.focus();
                    return false;
                }
            }
            var DropLoaiDeNghi = document.getElementById('<%=DropLoaiDeNghi.ClientID%>');
            var val_LoaiDeNghi = DropLoaiDeNghi.options[DropLoaiDeNghi.selectedIndex].value;
            var DropHinhThuc = document.getElementById('<%=DropHinhThuc.ClientID%>');
            val = DropHinhThuc.options[DropHinhThuc.selectedIndex].value;
            if (val == 0) {
                if (val_LoaiDeNghi == 1) {
                    alert('Chưa danh hiệu thi đua. Hãy chọn lại!');
                } else if (val_LoaiDeNghi == 2) {
                    alert('Chưa chọn hình thức khen thưởng. Hãy chọn lại!');
                } else if (val_LoaiDeNghi == 3) {
                    alert('Chưa chọn hình thức kỷ luật. Hãy chọn lại!');
                }
                DropHinhThuc.focus();
                return false;
            }
        }

    </script>
</asp:Content>
