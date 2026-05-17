<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongTinLienHe.aspx.cs" Inherits="WEB.GSTP.QTDKK.LienHe.ThongTinLienHe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <div class="box">
        <div class="box_nd">
           <%-- <h4 class="tleboxchung">Thông tin liên hệ
            </h4>--%>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td style="width: 90px;"><b>Mã tòa án</b><asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label></td>
                       <td style="width:320px;">
                            <asp:TextBox ID="txtMa" CssClass="user" runat="server" Enabled="false"
                                Width="120px" MaxLength="50"></asp:TextBox></td>
                  
                        <td  style="width: 80px;"><b>Tên tòa án</b><asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td >
                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Enabled="false"
                                Width="100%" MaxLength="250"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Tòa án cấp trên</b></td>
                        <td>
                            <asp:TextBox ID="txtToaAnCapTren" CssClass="user" runat="server" Enabled="false"
                                Width="90%" MaxLength="250"></asp:TextBox></td>
                    
                        <td><b>Loại tòa án</b></td>
                        <td>
                            <asp:TextBox ID="txtLoaiToaAn" CssClass="user" runat="server" Enabled="false"
                                Width="100%" MaxLength="250"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Đơn vị hành chính</b></td>
                         <td>
                            <asp:HiddenField ID="hddDonViHanhChinh" runat="server" />
                            <asp:TextBox ID="txtDonViHanhChinh" CssClass="user"
                                runat="server" Width="90%" MaxLength="250" Enabled="false"></asp:TextBox>
                        </td>
                        <td><b>Địa chỉ</b></td>
                        <td>
                            <asp:TextBox ID="txtDiaChi" CssClass="user" runat="server" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Điện thoại</b></td>
                         <td >
                            <asp:TextBox ID="txtDienThoai" CssClass="user align_right" runat="server" Width="120px"></asp:TextBox>
                            <span style="font-weight: bold; margin: 0px 5px 0px 10px;">Fax</span>
                            <asp:TextBox ID="txtFax" CssClass="user align_right" runat="server" Width="120px"></asp:TextBox>
                      </td>
                        <td><b>Email</b> </td>
                        <td>
                            <asp:TextBox ID="txtEmail" CssClass="user" runat="server" Width="100%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr><td colspan="4"><b><asp:Literal ID="lttNhanDonOnline" runat="server"></asp:Literal></b></td></tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return ValidateDataInput();" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            $(function () {
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';
                $("[id$=txtDonViHanhChinh]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddDonViHanhChinh]").val(i.item.val); }, minLength: 1
                });
            });

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script>
        function ValidateDataInput() {
            var txtMaControl = document.getElementById('<%=txtMa.ClientID %>');
               if (txtMaControl.value.trim() == "" || txtMaControl.value.trim() == null) {
                   alert('Bạn hãy nhập mã tòa án!');
                   txtMaControl.focus();
                   return false;
               } else if (txtMaControl.value.trim().length > 50) {
                   alert('Mã tòa án không được quá 50 ký tự. Hãy nhập lại!');
                   txtMaControl.focus();
                   return false;
               }

               var txtTenControl = document.getElementById('<%=txtTen.ClientID %>');
            if (txtTenControl.value.trim() == "" || txtTenControl.value.trim() == null) {
                alert('Bạn hãy nhập tên tòa án!');
                txtTenControl.focus();
                return false;
            } else if (txtTenControl.value.trim().length > 250) {
                alert('Tên tòa án không được quá 250 ký tự. Hãy nhập lại!');
                txtTenControl.focus();
                return false;
            }
            var txtDiaChi = document.getElementById('<%=txtDiaChi.ClientID %>');
            if (txtDiaChi.value.trim().length > 250) {
                alert('Địa chỉ không được quá 250 ký tự. Hãy nhập lại!');
                txtDiaChi.focus();
                return false;
            }
            var txtDienThoai = document.getElementById('<%=txtDienThoai.ClientID %>');
            if (txtDienThoai.value.trim().length > 250) {
                alert('Điện thoại không được quá 250 ký tự. Hãy nhập lại!');
                txtDienThoai.focus();
                return false;
            }
            var txtFax = document.getElementById('<%=txtFax.ClientID %>');
            if (txtFax.value.trim().length > 150) {
                alert('Fax không được quá 150 ký tự. Hãy nhập lại!');
                txtFax.focus();
                return false;
            }
            var txtEmail = document.getElementById('<%=txtEmail.ClientID %>');
            if (txtEmail.value.trim().length > 150) {
                alert('Email không được quá 150 ký tự. Hãy nhập lại!');
                txtEmail.focus();
                return false;
            }
            return true;
           }
    </script>
</asp:Content>
