<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KetQua.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.DacXa.KetQua" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pn" runat="server">
        <div class="box_nd">
            <div class="boxchung">
                <div style="margin: 5px; text-align: center; width: 95%; color: red;" > <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
                <h4 class="tleboxchung">Kết quả</h4>
                <div class="boder" style="padding: 10px;">
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                    </div>
                    <table class="table1">
                        <tr>
                            <td style="width: 120px">Yêu cầu xóa án tích</td>
                            <td colspan="2">
                                <asp:RadioButtonList ID="rdYeuCau_XoaAn" runat="server" RepeatDirection="Horizontal" Enabled="false">
                                    <asp:ListItem Value="0">Đương nhiên xóa án tích</asp:ListItem>
                                    <asp:ListItem Value="1">Tòa án quyết định</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>

                        <tr>
                            <td>Kết quả<span class="batbuoc">(*)</span></td>
                            <td colspan="2">
                                <asp:RadioButtonList ID="rdKetQua" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="0">Cấp giấy chứng nhận</asp:ListItem>
                                    <asp:ListItem Value="1">Không cấp giấy chứng nhận</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

          <div style="padding-top: 10px; text-align: center; width: 95%">
            <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                Text="Lưu" OnClientClick="return Validatefrom();" OnClick="cmdUpdate_Click" />          
        </div>

        <div style="padding-top: 10px; text-align: center; width: 95%">
            <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
        </div>
    </asp:Panel>

    <div style="width: 100%; float: left;">

        <asp:Label runat="server" ID="lbthongbao_top" ForeColor="Red"></asp:Label>
    </div>
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
