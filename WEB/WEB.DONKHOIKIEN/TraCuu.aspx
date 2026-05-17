<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="TraCuu.aspx.cs" Inherits="WEB.DONKHOIKIEN.TraCuu" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
       .border_search table tr, td{padding:0;padding-bottom:8px;}
       .dangky_tk_textbox, .button_search{float:left;}
       .msg_thongbao{margin-bottom:5px;}
    </style>

    <div class="border_search bg_vangnhat">
        <table style="width: 100%;">
            <tr>
                <td style="width: 80px;">Mã hồ sơ</td>
                <td style="width: 150px;">
                    <asp:TextBox ID="txtMaVuViec" runat="server" CssClass="dangky_tt_textbox"
                        Width="110px" MaxLength="10"></asp:TextBox></td>
                <td style="width: 120px;">Mã bảo mật hồ sơ</td>
                <td>
                    <asp:TextBox ID="txtMaBaoMatHS" runat="server" CssClass="dangky_tt_textbox"
                        Width="110px" MaxLength="10"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Mã kiểm tra</td>
                <td colspan="3">
                    <asp:TextBox ID="txtMaCapCha" runat="server" CssClass="dangky_tt_textbox"
                        Width="110px" MaxLength="10"></asp:TextBox>
                        <!--<asp:Literal ID="lttRandom" runat="server"></asp:Literal>
                        <asp:HiddenField ID="hddTempCode" runat="server" />-->
                       <asp:Image ID="imgCaptCha" runat="server" CssClass="capcha_code" /><asp:HiddenField ID="hddcapcha" runat="server"
                        Value="" />
                    <asp:ImageButton ID="cmdRefreshCode" runat="server" 
                             Width="30px" Height="30px" CssClass="refresh_capcha"
                            ImageUrl="/UI/img/refresh.png" OnClick="cmdRefreshCode_Click" />
                    <!--<img style="cursor: pointer; width: 30px;float:left;" id='ImgCPDG' src='/UI/img/refresh.png' />-->
                    <asp:Button ID="cmdSearch" runat="server" CssClass="button_search"
                        Text="Tìm kiếm" OnClick="cmdSearch_Click" OnClientClick="return validate()" />
                </td>
            </tr>
        </table>
    </div>
    <asp:Literal ID="lttThongBao" runat="server"></asp:Literal>
    <asp:Panel ID="pnHoSo" runat="server" Visible="false">
        <div class="TableHS">
            <table>
                <tr>
                    <td style="width: 115px;">Vụ việc</td>
                    <td colspan="3">
                        <asp:Literal ID="lttVuViec" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td style="width: 115px;">Tòa án thụ lý</td>
                    <td colspan="3">
                        <asp:Literal ID="lttToaAn" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td style="width: 115px;">Tên người khởi kiện</td>
                    <td style="width: 250px;">
                        <asp:Label ID="lblTennguyendon"
                            runat="server" Width="94%"></asp:Label></td>

                    <td style="width: 80px;">Ngày sinh</td>
                    <td>
                        <asp:Label ID="lblNguyendon_ngaysinh"
                            runat="server" Width="94%"></asp:Label></td>
                </tr>
                <tr>
                    <td>Số CMND/ Thẻ căn cước/ Hộ chiếu</td>
                    <td>
                        <asp:Label ID="lblCMND" runat="server"
                            Width="80%" MaxLength="250"></asp:Label></td>
                    <td>Quốc tịch</td>
                    <td>
                        <asp:Label ID="lblQuocTich" runat="server"
                            Width="80%" MaxLength="250"></asp:Label></td>
                </tr>
                <tr>
                    <td>Điện thoại</td>
                    <td>
                        <asp:Label ID="lblDienThoai" runat="server"
                            Width="80%" MaxLength="250"></asp:Label></td>
                    <td>Fax</td>
                    <td>
                        <asp:Label ID="lblFax" runat="server"
                            Width="80%" MaxLength="250"></asp:Label></td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td colspan="3">
                        <asp:Label ID="lblEmail" runat="server"
                            Width="80%" MaxLength="250"></asp:Label></td>

                </tr>
                <tr>
                    <td style="width: 115px;">Tình trạng</td>
                    <td colspan="3">
                        <asp:Literal ID="lttTrangThai" runat="server"></asp:Literal>
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnVBTongDat" runat="server">
            <div style="float: left; width: 100%; text-transform: uppercase; font-weight: bold;margin-top:10px; margin-bottom: 5px;">Danh sách văn bản, thông báo mới của Tòa án</div>
            <asp:Repeater ID="rptFile" runat="server"
                OnItemCommand="rptFile_ItemCommand"
                OnItemDataBound="rptFile_ItemDataBound">
                <HeaderTemplate>
                    <div class="CSSTableGenerator">
                        <table>
                            
                                <tr id="row_header">
                                    <td style="width: 20px;">TT</td>
                                    <td>Tên văn bản</td>
                                    <td style="width: 70px;">Ngày gửi</td>
                                    <td style="width: 125px;">Tệp đính kèm</td>
                                </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Container.ItemIndex + 1 %></td>
                        <td>
                            <asp:LinkButton ID="lkVB" runat="server" Text='<%#Eval("TenVanBan") %>'
                                CommandArgument='<%#Eval("ID") %>' CommandName="view"></asp:LinkButton>
                        </td>
                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayGui")) %>
                        </td>
                       
                        <td>
                            <asp:ImageButton ID="imgFile" runat="server"
                                CommandArgument='<%#Eval("ID") %>' CommandName="dowload" />
                            <asp:LinkButton ID="lkDowload" runat="server" Text='Tải file'
                                CommandArgument='<%#Eval("ID") %>' CommandName="dowload"></asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
</div>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>
    </asp:Panel>

    <!------------------------------------>
    <script>
        function validate() {
            var txtMaVuViec = document.getElementById('<%=txtMaVuViec.ClientID%>');
            if (!Common_CheckEmpty(txtMaVuViec.value)) {
                alert('Bạn chưa nhập mã hồ sơ. Hãy kiểm tra lại!');
                txtMaVuViec.focus();
                return false;
            }
            
            var txtMaCapCha = document.getElementById('<%=txtMaCapCha.ClientID%>');
            if (!Common_CheckEmpty(txtMaCapCha.value)) {
                alert('Bạn chưa nhập mã kiểm tra. Hãy kiểm tra lại!');
                txtMaCapCha.focus();
                return false;
            }
            return true;
        }

        function getIMG(){
        $.post("/Ajax/GetCaptCha.ashx", { oldcaptcha: $('#<%=hddcapcha.ClientID %>').val() }, function (data) {
                var reVal = data;
                $('#<%=hddcapcha.ClientID %>').val(reVal);
                $('#<%=imgCaptCha.ClientID %>').attr('src', '/Ajax/ImagesCaptcha.ashx?ImageText=' + reVal);
            });
            $('#<%=txtMaCapCha.ClientID %>').val('');
        }

        $(document).ready(function () {
          
            $.post("/Ajax/GetCaptCha.ashx", { oldcaptcha: $('#<%=hddcapcha.ClientID %>').val() }, function (data1) {
          
            var reVal = data1;
            $('#<%=hddcapcha.ClientID %>').val(reVal);
            $('#<%=imgCaptCha.ClientID %>').attr('src', '/Ajax/ImagesCaptcha.ashx?ImageText=' + reVal);
            });
            $('#<%=txtMaCapCha.ClientID %>').val('');
        });
    </script>

</asp:Content>
