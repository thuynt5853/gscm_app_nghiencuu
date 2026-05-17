<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewReport.aspx.cs" Inherits="WEB.GSTP.BaoCao.PCTP.ViewReport" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <title>Báo cáo</title>
</head>
<body>
    <form id="form1" runat="server">

<asp:scriptmanager runat="server"></asp:scriptmanager>

<rsweb:ReportViewer ID="ReportViewer1" runat="server"  PageCountMode="Actual" AsyncRendering="false" Enabled="True" Visible="True"
            EnableViewState="True" Font-Names="Times New Roman" Font-Size="8pt"
            WaitMessageFont-Names="Times New Roman" WaitMessageFont-Size="12pt" ShowWaitControlCancelLink="False"
            ShowBackButton="False"
            ShowCredentialPrompts="False" ShowParameterPrompts="False"
            ShowDocumentMapButton="false" ShowExportControls="true" ShowFindControls="False"
            ShowPageNavigationControls="true" ShowPrintButton="true"
            ShowPromptAreaButton="False" ShowRefreshButton="true" ShowToolBar="true" Width="98%" Height="1400px"
            ShowZoomControl="False">
                <LocalReport ReportPath="Report.rdlc">
                </LocalReport>
 </rsweb:ReportViewer>
            </form>
</body>
</html>