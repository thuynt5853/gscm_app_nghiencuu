<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Ketquagiaiquyet.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.Ketquagiaiquyet" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Nội dung đơn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: hidden;
            overflow-x: auto;
        }
    </style>
    <form id="form1" runat="server">
        <div style="width: 100%; height: 330px; text-align: justify; line-height: 25px;">
            <table width="100%">

                <tr>
                    <td>
                        <asp:TextBox ID="txtNoidung" CssClass="user" Font-Size="14px" BackColor="White" runat="server" TextMode="MultiLine" Width="99.5%" Height="270px"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td align="center">
                        <asp:Button ID="cmdLuu" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu" OnClick="cmdLuu_Click" />
                    </td>
                </tr>

            </table>


        </div>
        <script>
            function Reload_KQ() {
                window.onunload = function (e) {
                    opener.Loads_KQ();
                };
                window.close();
            }
        </script>
    </form>
</body>
</html>
