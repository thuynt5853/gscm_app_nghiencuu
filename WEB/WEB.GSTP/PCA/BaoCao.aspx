<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BaoCao.aspx.cs" Inherits="WEB.GSTP.PCA.BaoCao" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
    <link href="/UI/css/style.css" rel="stylesheet" />
    <link href="/UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="/UI/css/chosen.css" rel="stylesheet" />

    <link href="/UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="/UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="/UI/js/jquery-3.3.1.js"></script>
    <script src="/UI/js/jquery-ui.min.js"></script>

    <title>Báo cáo</title>
</head>
<body>
    <form id="form1" runat="server">
         <div style="text-align:center;margin-top:15px;">
            <asp:Button ID="Button1" runat="server" CssClass="buttoninput" Text="In báo cáo" OnClientClick="return Inbaocao()" />
            <asp:Button ID="Button2" runat="server" CssClass="buttoninput" Text="Xuất file word" OnClick="lbxuatfile_Click" />
        </div>
        <div id="printSectionId" style="font-family:'Times New Roman'; margin-top:15px;">
            <asp:PlaceHolder ID="placeholder" runat="server" />             
        </div>
       
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
 <script>       
        function Inbaocao() {
            // validate('e-tiepnhan'); 
            var innerContents = document.getElementById('printSectionId').innerHTML;
            var popupWinindow = window.open('', '_blank', 'width=600,height=700,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no');
            popupWinindow.document.open();
            popupWinindow.document.write('<html><head><link rel="stylesheet" type="text/css" href="style.css" /></head><body onload="window.print()">' + innerContents + '</html>');
            //popupWinindow.document.title = "BaoCao";
            popupWinindow.document.close();
            console.log("in");
            // apiservices.post()
        }
    </script>
