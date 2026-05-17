<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChiTietTP.aspx.cs" Inherits="WEB.GSTP.UserControl.TP.ChiTietTP" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <link href="../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../UI/css/jquery-ui.css" rel="stylesheet" />

    <script src="../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../UI/js/jquery-ui.min.js"></script>

    <script src="../../UI/js/chosen.jquery.js"></script>
    <script src="../../UI/js/init.js"></script>
    <script src="../../UI/js/jquery.enhsplitter.js"></script>
    <script src="../../UI/js/Common.js"></script>
    <title>Chi tiết hoạt động xét xử</title>
    <style>
        body {
            width: 100%;
            min-width: 0px;
        }

        .content_popup {
            width: 97%;
            margin: 15px 1.5%;
            float: left;
            position: relative;
            height: 720px;
            overflow-y: auto;
        }

        .title_group {
            margin-bottom: 10px;
            text-transform: uppercase;
            font-size: 18px;
            font-weight: bold;
            float: left;
            width: 60%;
        }
        /*---------------------------------------*/
        .content_form_head {
            background: linear-gradient(to right,#980305, #b5100c,#ffaaaa,#fff);
            float: left;
            width: 100%;
            height: 40px;
            border-radius: 4px 4px 0px 0px;
        }

        .content_form_head_title {
            color: white;
            float: left;
            font-size: 13pt;
            font-weight: bold;
            line-height: 40px;
            margin-left: 20px;
            text-transform: uppercase;
        }

        .content_form_head_right {
            float: right;
        }

        .content_body {
            float: left;
            margin-bottom: 19px;
            background: white;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }

        .content_form_body {
            float: left;
            margin: 20px 2%;
            width: 96%;
        }

        .LbtBack_css {
            background: url("close.png");
            width: 32px;
            height: 32px;
            margin-right: 15px;
            margin-top: 5px;
        }

        .table2 .header {
            text-align: center;
        }

        .buttoninput_CA_Home_css {
            min-width: 80px;
            height: 30px;
            font-weight: bold;
            color: #631313;
            background:url("/UI/img/bg_danhsach.png");
            padding-left: 15px;
            padding-right: 15px;
            cursor: pointer;
            border: solid 1px #9e9e9e;
            border-radius: 3px 3px 3px 3px;
        }

            .buttoninput_CA_Home_css a {
                height: 30px;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddVuAnID" runat="server" />
                <asp:HiddenField ID="hddLoaiAn" runat="server" />
                <asp:HiddenField ID="hddLoaiQuanHe" runat="server" />
                <asp:HiddenField ID="hddGSTP_MaVuViec" runat="server" />
                <div id="div_Content" runat="server" class="content_popup content_body" style="height: 95vh;">
                    <div class="content_form_head">
                        <div class="content_form_head_title">Chi tiết hoạt động xét xử</div>
                        <div class="content_form_head_right">
                            <asp:LinkButton ID="LbtBack" runat="server" OnClick="LbtBack_Click"><div class="LbtBack_css" title="Quay lại"></div></asp:LinkButton>
                        </div>
                    </div>
                    <div class="content_form_body">
                        <div class="title_group">
                            <asp:Literal ID="LtrTenThamPhan" runat="server"></asp:Literal>
                        </div>
                        <div style="float: right;">
                            <asp:Button ID="cmdInBaoCao" runat="server" CssClass="buttoninput_CA_Home_css" Style="float: right;" Text="In báo cáo" OnClick="cmdInBaoCao_Click" />
                            <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Style="float: right; margin-right: 20px; width: 100px; text-align: center; height: 24px;"></asp:TextBox>
                            <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Style="float: right; margin-right: 20px; width: 100px; text-align: center; height: 24px;"></asp:TextBox>
                            <span style="float: right; margin-right: 20px; font-weight: bold; margin-top: 8px;">Số liệu từ ngày:</span>
                        </div>
                        <div style="margin-bottom: 10px; margin-top: 10px; font-weight: bold; color: red; float: left; width: 100%;">
                            <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal>
                        </div>
                        <table class="table2">
                            <tr class="header">
                                <td rowspan="2" style="width: 100px;">Cấp xét xử</td>
                                <td rowspan="2">Loại án</td>
                                <td rowspan="2" style="width: 80px;">Nhập vụ án</td>
                                <td rowspan="2" style="width: 80px;">Chuyển vụ án</td>
                                <td rowspan="2" style="width: 80px;">Đã được phân công</td>
                                <td rowspan="2" style="width: 80px;">Đã giải quyết xong</td>
                                <td rowspan="2" style="width: 80px;">Còn lại</td>
                                <td rowspan="2" style="width: 80px;">Đã lên lịch xét xử</td>
                                <td rowspan="2" style="width: 80px;">Đang hoãn</td>
                                <td rowspan="2" style="width: 80px;">Tạm đình chỉ</td>
                                <td rowspan="2" style="width: 80px;">Án bị hủy</td>
                                <td rowspan="2" style="width: 80px;">Án bị Sửa</td>
                                <td colspan="2">Án quá hạn</td>
                            </tr>
                            <tr class="header">
                                <td style="width: 80px;">Đang giải quyết</td>
                                <td style="width: 80px;">Đã giải quyết</td>
                            </tr>
                            <asp:Literal ID="ltrContent" runat="server" Text=""></asp:Literal>
                        </table>
                    </div>
                </div>
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
    <script type="text/javascript">
        function popup_home_inbaocao_chitiet_tp() {
            var link = "/UserControl/TP/Inbaocao_chitiet_tp.aspx";
            var width = screen.width - 200;
            var height = 800;
            PopupCenter(link, "In báo cáo tổng hợp chi tiết của thẩm phán", width, height);
        }
    </script>
</body>
</html>
