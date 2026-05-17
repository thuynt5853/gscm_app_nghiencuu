<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PopupDacXa.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.DacXa.PopupDacXa" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đặc xá</title>

    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>

    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Đặc xá</h4>
                            <div class="boder" style="padding: 10px;">
                                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                            <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                                        </div>
                                        <table class="table1">
                                            <tr>
                                                <td style="width: 120px">Yêu cầu xóa án tích</td>
                                                <td colspan="2">
                                                    <asp:RadioButtonList ID="rdYeuCau_XoaAn" runat="server" RepeatDirection="Horizontal" Enabled="false">
                                                        <%--<asp:ListItem Value="0">Đương nhiên xóa án tích</asp:ListItem>--%>
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
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
            function Setfocus(controlid) {
                var ctrl = document.getElementById(controlid);
                ctrl.focus();
            }
        </script>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
