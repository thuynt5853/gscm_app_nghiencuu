<%--<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="HDSD.aspx.cs" Inherits="WEB.GSTP.HDSD.HDSD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content_body">
        <iframe id="iframe_pub" runat="server"></iframe>
    </div>
    <style>
        iframe {
            border: 0 none;
            height: 900px;
            width: 98%;
        }
        .content_body {
            margin-bottom: 0px;
        }
        .dxsplPane
        {
            width:98% !important;
        }
        .dxsplS
        {
            display:none;
        }
    </style>
</asp:Content>--%>
<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="HDSD.aspx.cs" Inherits="WEB.GSTP.HDSD.HDSD" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script type="text/javascript" src="../../../UI/js/Common.js"></script>

    <style type="text/css">
        .tleboxchung {
            text-transform: uppercase;
        }

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }

        .QDVACol1 {
            width: 107px;
        }

        .QDVACol2 {
            width: 270px;
        }

        .QDVACol3 {
            width: 116px;
        }
        .auto-style1 {
            height: 36px;
        }
    </style>
    <asp:Panel ID="pnBAST" runat="server">
        <div class="boxchung">
            <h4 class="tleboxchung">HƯỚNG DẪN SỬ DỤNG</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">                 
                    <tr>
                        <asp:Panel ID="pnZonekythuong" runat="server">
                            <td></td>
                            <td colspan="3">
                                Tệp đính kèm
                                <br />
                                <%--<asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                <asp:HiddenField ID="hddSessionID" runat="server" />
                                <asp:HiddenField ID="hddURLKS" runat="server" />--%>
                                <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" 
                                        OnClientUploadStarted="onUploadStartBA"
                                        OnClientUploadComplete="onUploadCompleteBA"
                                        OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    <div id="loadingIndicatorBA" style="display:none; color:red;">Đang tải file...</div>
                                </div>

                                <div style="display: block">
                                    <%--<asp:Button ID="cmdThemFileTL" runat="server"
                                        Text="Them tai lieu" OnClick="cmdThemFileTL_Click" />--%>
                                    <asp:Button ID="cmdThemFileTL" runat="server" CssClass="buttoninput"
                                        Text="Thêm mới" OnClick="cmdThemFileTL_Click"
                                        OnClientClick="return validate();" />
                                </div>
                            </td>
                        </asp:Panel>
                    </tr>
                    <tr>
                        <asp:Panel ID="pnDgFile" runat="server">
                            <td></td>
                            <td colspan="3">
                                <asp:DataGrid ID="dgFile" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgFile_ItemCommand">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên tệp
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("FILE_NAME") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                            <HeaderTemplate>
                                                Tệp đính kèm
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblDownload" runat="server" Text="Xem" CausesValidation="false" CommandName="Download" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa file" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa file này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </asp:Panel>

                    </tr>
                   <%-- <tr>
                        <td colspan="4" align="center" class="auto-style1">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                Text="Thêm mới" OnClick="cmdUpdate_Click"
                                OnClientClick="return validate();" />
                        </td>
                    </tr>--%>
                    <tr>
                        <td colspan="4" align="center">
                            <asp:Label ID="lbthongbao" runat="server" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </asp:Panel>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function validate() {
            <%--var hddFilePath = document.getElementById('<%=hddFilePath.ClientID%>');
            if (!Common_CheckTextBox(txtSobanan, "Số bản án")) {
                return false;
            }
            return true;--%>
        }
        function DownloadFile(link, fileName) {
                fetch(link)
                    .then(res => res.blob())
                    .then(blob => {
                        var link = document.createElement('a');
                        link.href = window.URL.createObjectURL(blob, {
                            type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                        });
                        link.download = fileName;
                        link.click();
                    });
            }
    </script>
    <script type="text/javascript">
        function onUploadStartBA(sender, args) {
            document.getElementById('loadingIndicatorBA').style.display = 'block';
            document.getElementById('<%= cmdThemFileTL.ClientID %>').disabled = true;
        }

        function onUploadCompleteBA(sender, args) {
            document.getElementById('loadingIndicatorBA').style.display = 'none';
            document.getElementById('<%= cmdThemFileTL.ClientID %>').disabled = false;
        }
    </script>
</asp:Content>


