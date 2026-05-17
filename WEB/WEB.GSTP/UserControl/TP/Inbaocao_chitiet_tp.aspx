<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inbaocao_chitiet_tp.aspx.cs" Inherits="WEB.GSTP.UserControl.TP.Inbaocao_chitiet_tp" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
        <p id="ltlmsg" runat="server" style="color: red;"></p>
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" CssClass="report_tbl"
            PageCountMode="Actual" AsyncRendering="false" Enabled="True" Visible="True"
            EnableViewState="True" Font-Names="Times New Roman" Font-Size="8pt"
            WaitMessageFont-Names="Times New Roman" WaitMessageFont-Size="12pt" ShowWaitControlCancelLink="False"
            ShowBackButton="False"
            ShowCredentialPrompts="False" ShowParameterPrompts="False"
            ShowDocumentMapButton="false" ShowExportControls="true" ShowFindControls="False"
            ShowPageNavigationControls="true" ShowPrintButton="true"
            ShowPromptAreaButton="False" ShowRefreshButton="true" ShowToolBar="true" Width="100%" Height="1000px"
            ShowZoomControl="False">
        </rsweb:ReportViewer>
    </form>
</body>
</html>
