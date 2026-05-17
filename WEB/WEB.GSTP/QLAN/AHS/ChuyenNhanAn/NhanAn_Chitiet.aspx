<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NhanAn_Chitiet.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.ChuyenNhanAn.NhanAn_Chitiet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        * {
            font-size: 14px !important;
            font-family: Tahoma;
            line-height: 20px;
        }

        .box {
            height: 550px;
            overflow: auto;
            position: absolute;
            top: 65px;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .align_right {
            text-align: right;
        }

        .link_save {
            margin-left: 0px;
            margin-right: 5px;
        }

        tr td {
            padding: 5px;
            text-align: justify !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <asp:Literal ID="lttChitiet" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
