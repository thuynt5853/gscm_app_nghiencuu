<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThuLyDon.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.XoaAnTich.ThuLyDon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddcurID" runat="server" Value="0" />
    <asp:HiddenField ID="hddIndex" runat="server" Value="1" />
    <asp:Panel ID="pn" runat="server">
        <div class="box_nd">
            <div class="boxchung">
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
                <h4 class="tleboxchung">Thụ lý đơn đề nghị xóa án tích</h4>
                <div class="boder" style="padding: 10px;">
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                    </div>
                    <table class="table1">
                        <tr>
                            <td style="width: 90px;">Tên tòa án</td>
                            <td style="width: 300px">
                                <asp:TextBox ID="txtTentoa" runat="server" Width="280px" CssClass="user" disabled="disabled"></asp:TextBox>
                            </td>
                            <td style="width: 90px">Ngày làm đơn</td>
                            <td>
                                <asp:TextBox ID="txtNgay_lamdon" runat="server" Width="80px" CssClass="user" placeholder="dd/MM/yyyy"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgay_lamdon" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgay_lamdon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgay_lamdon" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Số thụ lý<span class="batbuoc">(*)</span></td>
                            <td>
                                <div style="float: left;">
                                    <asp:TextBox ID="txtSothuly" runat="server" Width="100px" CssClass="user"></asp:TextBox>
                                </div>
                            </td>

                            <td>Người đề nghị<span class="batbuoc">(*)</span></td>
                            <td>
                                <div style="float: left;">
                                    <asp:TextBox ID="txtNguoiDeNghi" runat="server" Width="100px" CssClass="user"></asp:TextBox>
                                </div>
                            </td>

                            <%--<td>Yêu cầu xóa án tích<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:RadioButtonList ID="rdYeucau_XoaAnTich" runat="server" RepeatDirection="Horizontal" Enabled="false">
                                    <asp:ListItem Value="1"> Tòa án ra quyết định</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>--%>

                        </tr>
                        <tr>
                            <td>Ngày thụ lý<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgay_thuly" runat="server" Width="80px" CssClass="user" placeholder="dd/MM/yyyy"></asp:TextBox>
                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtNgay_thuly" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgay_thuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgay_thuly" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Tội danh</td>
                            <td>
                                <asp:TextBox ID="txtToidanh" runat="server" CssClass="user" Width="280px" Height="30px" disabled="disabled"></asp:TextBox>
                            </td>
                            <td>Nhận xét của xã , phường</td>
                            <td>
                                <asp:TextBox ID="txtNhanxetXa_Phuong" runat="server" CssClass="user" Width="80%" Height="30px"></asp:TextBox>
                            </td>
                        </tr>

                    </table>
                </div>
            </div>
        </div>

        <div style="padding-top: 10px; text-align: center; width: 95%">
            <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                Text="Lưu" OnClientClick="return validate();" OnClick="cmdUpdateVuAn_Click" />
            <asp:Button ID="cmdXoaTLAnTich" runat="server" CssClass="buttoninput" 
                            Text="Xóa" OnClick="cmdXoaTLAnTich_Click"/>
        </div>

        <div style="padding-top: 10px; text-align: center; width: 95%">
            <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
        </div>
    </asp:Panel>

    <div style="width: 100%; float: left;">

        <asp:Label runat="server" ID="lbthongbao_top" ForeColor="Red"></asp:Label>
    </div>
    <div style="margin-bottom: 200px">
    </div>
    <script>
        function validate() {
            var msg = '';
            var txtSothuly = document.getElementById('<%=txtSothuly.ClientID%>');
            if (!Common_CheckEmpty(txtSothuly.value)) {
                alert('Bạn chưa nhập số thụ lý. Hãy kiểm tra lại!');
                txtSothuly.focus();
                return false;
            }
            var txtNgay_thuly = document.getElementById('<%=txtNgay_thuly.ClientID%>');
            if (!Common_CheckEmpty(txtNgay_thuly.value)) {
                alert('Bạn chưa chọn ngày thụ lý. Hãy kiểm tra lại!');
                return false;
            }
            var txtNguoiDeNghi = document.getElementById('<%=txtNguoiDeNghi.ClientID%>');
            if (!Common_CheckEmpty(txtNguoiDeNghi.value)) {
                alert('Bạn chưa nhập người đề nghị!');
                txtNguoiDeNghi.focus();
                return false;
            }
   <%--         var rdYeucau_XoaAnTich = document.getElementById('<%=rdYeucau_XoaAnTich.ClientID%>');
            msg = 'Mục "Yêu cầu xóa án tích" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdYeucau_XoaAnTich, msg))
                return false;--%>
            return true;
        }

    </script>

</asp:Content>
