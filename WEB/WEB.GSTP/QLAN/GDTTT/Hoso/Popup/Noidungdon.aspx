<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Noidungdon.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.Noidungdon" %>

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
        <div style="width:100%;height:480px;text-align:justify;line-height:25px;">
            <asp:TextBox ID="txtNoidung"  CssClass="user" Font-Size="14px" Enabled="false"  runat="server"  TextMode="MultiLine" Width="99.5%" Height="470px"></asp:TextBox>
                       
        </div>                      
    </form>
</body>
</html>
