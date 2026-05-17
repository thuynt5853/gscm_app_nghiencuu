<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InBC.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.InBC" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="DevExpress.XtraReports.v22.2.Web.WebForms, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../UI/css/style.css" rel="stylesheet" />
    <link href="../UI/css/Table.css" rel="stylesheet" />
    <link href="../UI/css/Paging.css" rel="stylesheet" />
    <link href="../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../UI/css/chosen.css" rel="stylesheet" />

    <link href="../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../UI/js/jquery-3.3.1.js"></script>
    <script src="../UI/js/jquery-ui.min.js"></script>

    <script src="../UI/js/Common.js"></script>

    <script src="../UI/js/chosen.jquery.js"></script>
    <script src="../UI/js/init.js"></script>
    <script src="../UI/js/jquery.enhsplitter.js"></script>
    <title>In đơn khởi kiện</title>
</head>
<body>
    <style type="text/css">
        body {
            width: 100%;
            text-align: left;
            background: #fffbd6;
            min-width: inherit;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <p id="ltlmsg" runat="server"></p>
                <dx:ASPxWebDocumentViewer ID="rptView" runat="server">
                        </dx:ASPxWebDocumentViewer>
                <%--<script>
                    //-------load parent page when close popup---------------
                    window.onunload = refreshParent;
                    function refreshParent() {
                        window.opener.location.reload();
                    }
                </script>--%>
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
    </form>
</body>
</html>
