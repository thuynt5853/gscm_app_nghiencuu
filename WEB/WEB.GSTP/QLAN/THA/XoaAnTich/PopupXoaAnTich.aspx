<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PopupXoaAnTich.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.XoaAnTich.PopupXoaAnTich" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Xóa án tích</title>

    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddCurID" runat="server" Value="0" />
        <asp:HiddenField ID="hddInDex" runat="server" Value="1" />
        <asp:HiddenField ID="hddPage" runat="server" Value="1" />
        <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="boxchung">
                            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
                            <h4 class="tleboxchung">Kết quả</h4>
                            <div class="boder" style="padding: 10px;">
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                    <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                                </div>
                                <table class="table1">
                                    <tr>
                                        <td style="width: 120px">Yêu cầu xóa án tích</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdYeuCau_XoaAn" runat="server"
                                                RepeatDirection="Horizontal" Enabled="false">
                                                <asp:ListItem Value="1">Tòa án quyết định</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Kết quả<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdKetQua" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdKetQua_SelectedIndexChanged">
                                                <asp:ListItem Value="0">Cấp giấy chứng nhận</asp:ListItem>
                                                <asp:ListItem Value="1">Không cấp giấy chứng nhận</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnCapCN" runat="server">
                                        <tr>
                                            <td>Số chứng nhận</td>
                                            <td>
                                            <div style="float: left;">
                                                    <asp:TextBox ID="txtSoCN" CssClass="user" runat="server" Width="149px"></asp:TextBox>
                                                </div>
                                                <div style="float: left; line-height: 20px; margin-left: 35px; margin-right: 35px;">Ngày chứng nhận</div>
                                                <asp:TextBox ID="txtNgayCN" runat="server" CssClass="user" Width="149px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                                    TargetControlID="txtNgayCN" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                                    TargetControlID="txtNgayCN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                    ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Người ký<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:HiddenField ID="hddNguoiKyID" runat="server" Value="0" />
                                                <asp:DropDownList ID="ddlNguoiky" CssClass="user" runat="server" Width="478px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <td>Nội dung</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtNoidung" CssClass="user" runat="server" Width="468px" TextMode="MultiLine"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>File đính kèm</td>
                                            <td>
                                                <asp:HiddenField ID="hddFilePath" runat="server" />
                                                <asp:HiddenField ID="hddFileID" runat="server" />
                                                <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                                <asp:LinkButton ID="lbtDownload" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div style="padding-top: 10px; text-align: center; width: 95%">
                        <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                            Text="Lưu" OnClientClick="return Validatefrom();" OnClick="cmdUpdate_Click" />
                        <asp:Button ID="cmdSua" runat="server" CssClass="buttoninput"
                            Text="Sửa" OnClientClick="return Validatefrom();" OnClick="cmdSua_Click" />
                        <asp:Button ID="cmdXoa" runat="server" CssClass="buttoninput"
                            Text="Xóa" OnClientClick="return Validatefrom();" OnClick="cmdXoa_Click" />
                    </div>

                    <div style="padding-top: 10px; text-align: center; width: 95%">
                        <asp:Label ID="lbthongbao" runat="server" Text="" ForeColor="Red"></asp:Label>
                    </div>
                    <script>
                        function Validatefrom() {
                            var msg = '';
                            var rdKetQua = document.getElementById(<%=rdKetQua.ClientID%>);
                            msg = 'Mục "Kết quả" bắt buộc phải chọn. Hãy kiểm tra lại!';
                            if (!CheckChangeRadioButtonList(rdKetQua, msg))
                                return false;

                            return true;
                        }
                    </script>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script>
            function ReloadParent() {
                window.onunload = function (e) {
                    opener.ReLoadGrid();
                };
            }
        </script>
        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
            function Setfocus(controlid) {
                var ctrl = document.getElementById(controlid);
                ctrl.focus();
            }
        </script>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
