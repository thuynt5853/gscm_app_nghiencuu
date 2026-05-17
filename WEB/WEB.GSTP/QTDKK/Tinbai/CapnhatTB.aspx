<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="CapnhatTB.aspx.cs" Inherits="WEB.GSTP.QTDKK.Tinbai.CapnhatTB" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <script src="../../UI/js/Common.js"></script>

    <style type="text/css">
        .tdWidthTblToaAn {
            width: 120px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Chuyên mục<span class="must_input">(*)</span></b>
                        </td>
                        <td>
                            <asp:DropDownList CssClass="chosen-select" ID="dropChuyenMuc" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Tiêu đề<span class="must_input">(*)</span></b></td>
                        <td>
                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox>
                               
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Trích dẫn</b></td>
                        <td>
                            <asp:TextBox ID="txtTrichDan" runat="server" CssClass="user"
                                TextMode="MultiLine" Rows="3" Width="98%" ></asp:TextBox>
                        </td>
                    </tr>
                      <tr>
                        <td class="tdWidthTblToaAn"><b>Mã trang</b></td>
                        <td>
                            <asp:TextBox ID="txtPageCode" runat="server" CssClass="user"
                                TextMode="MultiLine" Rows="3" Width="98%" ></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Nội dung</b></td>
                        <td>
                            <CKEditor:CKEditorControl ID="txtNoiDung" BasePath="/UI/Tools/ckeditor/" runat="server" Width="98%" Height="250px"></CKEditor:CKEditorControl>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Ngày tin bài</b>
                        </td>
                        <td>
                            <asp:TextBox ID="txtNgayTinBai" runat="server" CssClass="user" Width="20%" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtNgayTinBai_CalendarExtender" runat="server" TargetControlID="txtNgayTinBai" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayTinBai" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayTinBai" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><asp:Label ID="lbthongbao" runat="server" ForeColor="Red"></asp:Label> </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="cmdLuuTam" runat="server" CssClass="buttoninput" Text="Đang lưu" OnClick="btnLuuTam_Click" OnClientClick="return Validate();" />
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" Visible="false" OnClick="btnUpdate_Click" OnClientClick="return Validate();" />
                            <asp:Button ID="cmdXuanBan" runat="server" CssClass="buttoninput" Text="Đăng" OnClick="btnXuatBan_Click" OnClientClick="return Validate();" />
                            <asp:Button ID="cmdHuyXuatBan" runat="server" CssClass="buttoninput" Text="Hạ xuống" Visible="false" OnClick="btnHuyXuatBan_Click" OnClientClick="return Validate();" />
                            <asp:Button ID="cmdQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="btnQuayLai_Click" />

                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script>
        function Validate() {
            var dropChuyenMuc = document.getElementById('<%=dropChuyenMuc.ClientID%>');
            console.log("chuyên mục tin: " + dropChuyenMuc.value);
            if (dropChuyenMuc.value<=0) {
                alert('Bạn chưa chọn chuyên mục. Hãy kiểm tra lại!');
                dropChuyenMuc.focus();
                return false;
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tiêu đề tin. Hãy kiểm tra lại!');
                txtTen.focus();
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
