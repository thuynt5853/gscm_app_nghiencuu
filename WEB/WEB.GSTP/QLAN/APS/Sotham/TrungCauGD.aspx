<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="TrungCauGD.aspx.cs" Inherits="WEB.GSTP.QLAN.APS.SoTham.TrungCauGD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddMaGiaiDoan" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddIndex" runat="server" Value="1" />
    <asp:HiddenField ID="hddPage" runat="server" Value="1" />
    <div style="margin: 5px; text-align: center; width: 95%; padding-top: 25px;">
    </div>
    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
    </div>
    <div class="box">
        <div class="box_nd">
            <div>
                <div class="boxchung">
                    <h4 class="tleboxchung">1. Tòa án đã giải quyết có trưng cầu,yêu cầu giám định</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 350px">Tòa án tự trưng cầu giám định<asp:Label ID="Label1" runat="server" Text="(*)" ForeColor="Red"></asp:Label></td>
                                <td>

                                    <asp:RadioButtonList ID="rdtoaan_giamdinh" runat="server" AutoPostBack="true"
                                        RepeatDirection="Horizontal" OnSelectedIndexChanged="rdtoaan_giamdinh_SelectedIndexChanged">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList>

                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td style="width: 350px">Tòa án trưng cầu giám định theo yêu cầu của đương sự<asp:Label ID="Label15" runat="server" Text="(*)" ForeColor="Red"></asp:Label></td>
                                <td>
                                    <asp:RadioButtonList ID="rdduongsu_yeucau" runat="server" AutoPostBack="true"
                                        RepeatDirection="Horizontal" OnSelectedIndexChanged="rdduongsu_yeucau_SelectedIndexChanged">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table>
                    </div>
                </div>


                <asp:Panel ID="loadPanelso2" runat="server">
                    <div class="boxchung">
                        <h4 class="tleboxchung">2. Đánh giá chất lượng giám định</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 350px">Số trưng cầu giám định đáp ứng về mặt thời hạn giám định
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtthoigiangiamdinh" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox>
                                       
                                    </td>
                                </tr>

                                <tr>
                                    <td>Số kết luận giám định phải giám định bổ sung
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtgiamdinhbosung" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox>
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 240px">Số kết luận giám định phải giám định lại
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtgiamdinhlai" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox>&nbsp; &nbsp; &nbsp; &nbsp;
                                        

                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="loadPanelso3" runat="server">
                    <div class="boxchung">
                        <h4 class="tleboxchung">3. Thống kê số lượng trưng cầu, yêu cầu giám định trong các lĩnh vực </h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 70px">Pháp y
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtphapy" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                    <td style="width: 110px">Pháp y tâm thần
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtphapy_tamthan" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                    <td style="width: 110px">Kĩ thuật hình sự
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtKithuathinhsu" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Tài chính
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txttaichinh" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                    <td>Ngân hàng
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtnganhang" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>

                                    <td>Thông tin và truyền thông
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txttruyenthong" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Ma túy
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtmatuy" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                    <td>Xây dựng
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtxaydung" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                    <td>Các lĩnh vực khác
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtlinhvuckhac" runat="server" Width="50px" CssClass="user" onkeypress="return isNumber(event)"></asp:TextBox></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
            </div>
             <div style="margin: 5px; text-align: center; width: 95%">
        <asp:Button ID="cmdUpdateBottom" runat="server" CssClass="buttoninput"
            Text="Lưu" OnClick="cmdUpdateBottom_Click" OnClientClick="return Validate();" />
        
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
    </script>

    <script>

        function Validate() {
            var msg = "";

            var rdtoaangiamdinh = document.getElementById('<%=rdtoaan_giamdinh.ClientID%>');
            msg = 'Bạn chưa chọn trưng cầu giám định. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdtoaangiamdinh, msg)) {
                return false;
            }

            var rdduongsu_yeucau = document.getElementById('<%=rdduongsu_yeucau.ClientID%>');
                msg = 'Bạn chưa chọn vụ việc tòa án trưng cầu giám định theo yêu cầu của đương sự. hãy kiểm tra lại !'
                if (!CheckChangeRadioButtonList(rdduongsu_yeucau, msg)) {
                    return false;
                }
                return true;
        }
    </script>
</asp:Content>
