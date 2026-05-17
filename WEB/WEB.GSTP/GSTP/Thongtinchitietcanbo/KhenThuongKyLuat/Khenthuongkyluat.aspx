<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Khenthuongkyluat.aspx.cs" Inherits="WEB.GSTP.GSTP.Thongtinchitietcanbo.KhenThuongKyLuat.Khenthuongkyluat" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin khen thưởng</h4>
                <div class="boder" style="padding: 10px;">
                    <span style="color: red;">Chưa có thông tin.Đang chờ xử lý</span>
                </div>
            </div>
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin kỷ luật</h4>
                <div class="boder" style="padding: 10px;">
                    <asp:Label ID="lbthongbao" runat="server" CssClass="batbuoc"></asp:Label>
                    <rsweb:ReportViewer ID="rpvKyLuat" runat="server" PageCountMode="Actual" AsyncRendering="false" Enabled="True" Visible="True"
                        EnableViewState="True" Font-Names="Times New Roman" Font-Size="8pt"
                        WaitMessageFont-Names="Times New Roman" WaitMessageFont-Size="12pt" ShowWaitControlCancelLink="False"
                        ShowBackButton="False"
                        ShowCredentialPrompts="False" ShowParameterPrompts="False"
                        ShowDocumentMapButton="false" ShowExportControls="true" ShowFindControls="False"
                        ShowPageNavigationControls="true" ShowPrintButton="true"
                        ShowPromptAreaButton="False" ShowRefreshButton="true" ShowToolBar="true" Width="98%" Height="1400px"
                        ShowZoomControl="False">
                    </rsweb:ReportViewer>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
