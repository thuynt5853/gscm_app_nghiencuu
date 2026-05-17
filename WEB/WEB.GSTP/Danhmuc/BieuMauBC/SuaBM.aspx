<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="SuaBM.aspx.cs" Inherits="WEB.GSTP.Danhmuc.BieuMauBC.SuaBC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
   
    <div class="box" style="margin-top: 20px;">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 100px;">Mã biểu mẫu
                            <asp:Label runat="server" ID="Label3" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                        <td style="width: 100px;">
                            <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="40%"></asp:TextBox>
                        </td>
                        
                    </tr>
                    <tr>
                        <td style="width: 100px;">Tên biểu mẫu
                            <asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="80%"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 100px;">Tên quyết định</td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="835px">
                            </asp:DropDownList>
                        </td>
                    </tr>

                    <tr>
                        <td>Đường dẫn
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtDuongdan" CssClass="user" runat="server" Width="80%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                           Thứ tự biểu mẫu
                        </td>
                        <td style="width:100px">
                            <asp:TextBox ID="txtThuTu" runat="server" CssClass="user align_right"
                                Width="40%" MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                        <td style="text-align: left; width:100px">
                           
                        </td>
                        <td>
                            
                        </td>
                    </tr>
                    <tr>
                        <td>
                           Loại án <asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label>
                        </td>
                      <td colspan="4">
                             <asp:CheckBox ID="chkHinhSu" CssClass="check" runat="server" Text="Hình sự" />
                            &nbsp;<asp:CheckBox ID="chkDanSu" class="check " runat="server" Text="Dân sự" />
                            &nbsp;<asp:CheckBox ID="chkHonNhanGD" class="check" runat="server"  Text="Hôn nhân & Gia đình" />
                           &nbsp; <asp:CheckBox ID="chkKDTM" class="check" runat="server"  Text="Kinh doanh thương mại" />
                            <br />    <br />
                            <asp:CheckBox ID="chkLaoDong" class="check" runat="server" Text="Lao động" />
                           &nbsp; <asp:CheckBox ID="chkHanhChinh" class="check" runat="server"  Text="Hành chính" />
                             &nbsp; <asp:CheckBox ID="chkPhasan" class="check" runat="server"  Text="Phá sản" />
                              <asp:CheckBox ID="chkXLHC" class="check" runat="server" Text="BP Xử lý hành chính" />
                            &nbsp;<asp:CheckBox ID="chkTHA" class="check" runat="server" Text="Thi hành án" />
                              <br />    <br />
                            <asp:DropDownList ID="dropLoai" Visible="false" class="check" runat="server" CssClass="chosen-select" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn">Giai đoạn
                        </td>
                        <td colspan="4">
                            <asp:CheckBox ID="chkIsHoso" CssClass="check" runat="server" Text="Hồ sơ" />
                            &nbsp;<asp:CheckBox ID="chkIsSotham" class="check " runat="server" Text="Sơ thẩm" />
                            &nbsp;<asp:CheckBox ID="chkIsPhuctham" class="check" runat="server"  Text="Phúc thẩm" />
                            &nbsp;<asp:CheckBox ID="chkIsGDT" class="check" runat="server"  Text="GĐT, TT" />
                        </td>
                    </tr>
                     <tr>
                        <td class="tdWidthTblToaAn">Đối tượng tống đạt
                        </td>
                        <td colspan="4">
                            <asp:CheckBox ID="chkNguyendon" CssClass="check" runat="server" Text="Người khởi kiện" />
                            &nbsp;<asp:CheckBox ID="chkDuongsu" class="check " runat="server" Text="Đương sự" />
                            &nbsp;<asp:CheckBox ID="chkVKS" class="check" runat="server"  Text="Viện kiểm sát cùng cấp" />
                        </td>
                    </tr>
                     <tr>
                        <td class="tdWidthTblToaAn">In biểu mẫu?</td>
                        <td colspan="3">
                            <asp:CheckBox ID="chkPrint" class="check" runat="server" />
                        </td>
                    </tr>
                      <tr>
                        <td class="tdWidthTblToaAn">Có thể hiển thị không cần có Số QĐ ?</td>
                        <td colspan="3">
                            <asp:CheckBox ID="chkISLUONHIENTHI" class="check" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn">Hiệu lực</td>
                        <td colspan="3">
                            <asp:CheckBox ID="chkActive" class="check" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                                OnClick="btnUpdate_Click" OnClientClick="return Validate()" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            <asp:Button ID="cmdquaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="btnQuaylai_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div>
                                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }

        function Validate() {
            var txtma = document.getElementById('<%=txtMa.ClientID%>')
            if (!Common_CheckEmpty(txtma.value)) {
                alert('Bạn chưa nhập mã. Hãy kiểm tra lại!')
                txtma.focus();
                return false;
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên biểu mẫu. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            var dropLoai = document.getElementById('<%=dropLoai.ClientID%>');
            var value_change = dropLoai.options[dropLoai.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn loại án. Hãy kiểm tra lại!');
                dropLoai.focus();
                return false;
            }
           
            return true;
        }
    </script>
</asp:Content>
