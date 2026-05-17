<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Khieunaitocao.aspx.cs" Inherits="WEB.GSTP.GSTP.Thongtinchitietcanbo.KhieuNaiToCao.Khieunaitocao" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <asp:Label ID="lbthongbao" runat="server" CssClass="batbuoc"></asp:Label>
                <rsweb:ReportViewer ID="ReportViewer1" runat="server" PageCountMode="Actual" AsyncRendering="false" Enabled="True" Visible="True"
                    EnableViewState="True"
                    ShowWaitControlCancelLink="False"
                    ShowBackButton="False"
                    ShowCredentialPrompts="False" ShowParameterPrompts="False"
                    ShowDocumentMapButton="false" ShowExportControls="true" ShowFindControls="False"
                    ShowPageNavigationControls="true" ShowPrintButton="true"
                    ShowPromptAreaButton="False" ShowRefreshButton="true" ShowToolBar="true" Width="100%" Height="1400px"
                    ShowZoomControl="False">
                </rsweb:ReportViewer>
            </div>
        </div>
    </div>
</asp:Content>
