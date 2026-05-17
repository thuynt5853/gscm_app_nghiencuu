<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GenerateSecretPass_frm.aspx.cs" Inherits="WEB.GSTP.UserControl.GenerateSecretPass_frm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
         <div style="padding:20px">
            <asp:Label ID="Label1" runat="server" Text="Secret Pass: " Font-Bold="True"></asp:Label><br /><br />
            <asp:TextBox ID="txtSecretPass" runat="server" Width="400px" ReadOnly="true"></asp:TextBox><br /><br />
            <asp:Button ID="btnGenerate" runat="server" Text="Generate Secret Pass" OnClick="btnGenerate_Click" />
        </div>
    </form>
</body>
</html>
