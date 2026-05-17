<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KetQua.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.XoaAnTich.KetQua" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddCurID" runat="server" Value="0" />
    <asp:HiddenField ID="hddInDex" runat="server" Value="1" />
    <asp:HiddenField ID="hddPage" runat="server" Value="1" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:Panel ID="pn" runat="server" Height="500px">
        <div class="box_nd">
            <div class="boxchung">
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
                <h4 class="tleboxchung">Kết quả</h4>
                <div class="boder" style="padding: 10px;">
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                    </div>
                    <table class="table1">
<%--                        <tr>
                            <td style="width: 120px">Yêu cầu xóa án tích</td>
                            <td>
                                <asp:RadioButtonList ID="rdYeuCau_XoaAn" runat="server"
                                    RepeatDirection="Horizontal" Enabled="false">
                                    <asp:ListItem Value="1">Tòa án quyết định</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>

                        </tr>--%>
                        <tr>
                            <td>Kết quả<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:RadioButtonList ID="rdKetQua" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdKetQua_SelectedIndexChanged">
                                    <asp:ListItem Value="0">Chấp nhận yêu cầu</asp:ListItem>
                                    <asp:ListItem Value="1">Không chấp nhận yêu cầu</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <%--vnpt - Lưu Quang Huy - thêm số và ngày khi không chấp nhận - 17-09-2025 14:47 --%>
                        <asp:Panel ID="pnKhongCN" runat="server" Visible="false">
                            <tr>
                                <td>Số</td>
                                <td>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtSoKCN" CssClass="user" runat="server" Width="149px"></asp:TextBox>
                                    </div>
                                    <div style="float: left; line-height: 20px; margin-left: 35px; margin-right: 35px;">Ngày</div>
                                    <div>
                                        <asp:TextBox ID="txtNgayKCN" runat="server" CssClass="user" Width="149px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                            TargetControlID="txtNgayKCN" Format="dd/MM/yyyy" Enabled="true"/>
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                            TargetControlID="txtNgayKCN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                    </div>    
                                    
                                </td>
                            </tr>
                        </asp:Panel>
                        <%--vnpt - Lưu Quang Huy - thêm số và ngày khi không chấp nhận - 17-09-2025 14:47 --%>
                        <asp:Panel ID="pnCapCN" runat="server">
                            <tr>
                                <td>Số chứng nhận</td>
                                <td>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtSoCN" CssClass="user" runat="server" Width="149px"></asp:TextBox>
                                    </div>
                                    <div style="float: left; line-height: 20px; margin-left: 35px; margin-right: 35px;">Ngày chứng nhận</div>
                                    <asp:TextBox ID="txtNgayCN" runat="server" CssClass="user" Width="149px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                        TargetControlID="txtNgayCN" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                        TargetControlID="txtNgayCN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                        ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Người ký<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:HiddenField ID="hddNguoiKyID" runat="server" Value="0" />
                                    <asp:DropDownList ID="ddlNguoiky" CssClass="user" runat="server" Width="478px"></asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <td>Nội dung</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidung" CssClass="user" runat="server" Width="468px" TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath" runat="server" />
                                    <asp:HiddenField ID="hddFileID" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <asp:LinkButton ID="lbtDownload" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                </td>
                            </tr>
                        </asp:Panel>
                    </table>
                </div>
            </div>
        </div>
        <div style="text-align: center;">
            <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
        </div>
        <div style="padding-top: 10px; text-align: center; width: 95%">
            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                Text="Lưu" OnClientClick="return Validatefrom();" OnClick="cmdUpdate_Click" />
            <asp:Button ID="cmdSua" runat="server" CssClass="buttoninput"
                Text="Sửa" OnClientClick="return Validatefrom();" OnClick="cmdSua_Click" />
            <asp:Button ID="cmdXoa" runat="server" CssClass="buttoninput"
                Text="Xóa" OnClientClick="return Validatefrom();" OnClick="cmdXoa_Click" />
        </div>
    </asp:Panel>

    <div style="width: 100%; float: left;">

        <asp:Label runat="server" ID="lbthongbao_top" ForeColor="Red"></asp:Label>
    </div>
    <script>
        function ReloadParent() {
            window.onunload = function (e) {
                opener.ReLoadGrid();
            };
        }
    </script>
    <script>
        function Validatefrom() {
            var msg = '';
            var rdKetQua = document.getElementById(<%=rdKetQua.ClientID%>);
            msg = 'Mục "Kết quả" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdKetQua, msg))
                return false;

            return true;
        }
    </script>
</asp:Content>
