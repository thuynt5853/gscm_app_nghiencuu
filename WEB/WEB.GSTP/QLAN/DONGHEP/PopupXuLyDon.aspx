<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PopupXuLyDon.aspx.cs" Inherits="WEB.GSTP.QLAN.DONGHEP.PopupXuLyDon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật quyết định và hình phạt</title>


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
            min-width: 0px;
            min-height: 0px;
        }

        .box {
            padding-bottom: 0px !important;
        }

        #chkND_ONuocNgoai, #chkBD_ONuocNgoai {
            height: 22px !important;
            position: absolute;
        }

        #chkISBVQLNK {
            height: 22px !important;
        }

        input {
            height: 28px !important;
        }

        label[for=chkND_ONuocNgoai], label[for=chkBD_ONuocNgoai] {
            margin-left: 25px
        }
    </style>
</head>
<body>
    <style type="text/css">
        .msg_error {
            width: 50% !important;
        }
    </style>

    <form id="form1" runat="server">
        <asp:HiddenField ID="hddID" runat="server" Value="0" />
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin vụ việc</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <asp:Panel ID= "pnAnDSChung"  runat = "server">
                                        <td style="width: 115px;">Quan hệ pháp luật<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtQHPL" CssClass="user" runat="server" Width="250px" TextMode="MultiLine"></asp:TextBox></td>
                                    </asp:Panel>
                                    <asp:Panel ID= "pnAnHS"  runat = "server">
                                        <td style="width: 115px;">Tư cách tố tụng<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtTCTT" CssClass="user" runat="server" Width="250px" ></asp:TextBox></td>
                                    </asp:Panel>
                                    <td>Loại đơn</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaidon" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaidon_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Đơn khởi kiện"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đơn từ Tòa án khác chuyển đến"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Đơn trùng"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Đơn không thuộc thẩm quyền"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Đơn có yêu cầu phản tố"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="Đơn có yêu cầu độc lập"></asp:ListItem>
                                            <asp:ListItem Value="7" Text="Đơn kháng cáo"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="Đơn khác"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:DropDownList ID="ddlLoaidonHN" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack=True OnSelectedIndexChanged="ddlLoaidonHN_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Đơn khởi kiện"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đơn từ Tòa án khác chuyển đến"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Đơn từ Cơ quan quản lý nhà nước về gia đình"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Đơn từ Cơ quan quản lý nhà nước về trẻ em"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Đơn từ Hội liên hiệp phụ nữ"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="Đơn trùng"></asp:ListItem>
                                            <asp:ListItem Value="7" Text="Đơn không thuộc thẩm quyền"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="Đơn có yêu cầu phản tố"></asp:ListItem>
                                            <asp:ListItem Value="9" Text="Đơn có yêu cầu độc lập"></asp:ListItem>
                                            <asp:ListItem Value="10" Text="Đơn kháng cáo"></asp:ListItem>
                                            <asp:ListItem Value="11" Text="Đơn khác"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnNDBD" runat="server">
                                    <tr>
                                        <td style="width: 115px;">Tên nguyên đơn<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;">
                                            <asp:TextBox ID="txtTennguyendon" CssClass="user" runat="server" Width="250px"></asp:TextBox></td>
                                        <td style="width: 125px;">Số CMND/CCCD<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;">
                                            <asp:TextBox ID="txtCMND_ND" CssClass="user" runat="server" Width="250px"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td>Tên bị đơn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtTenbidon" CssClass="user" runat="server" Width="250px"></asp:TextBox></td>
                                        <td style="width: 125px;">Số CMND/CCCD<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtCMND_BD" CssClass="user" runat="server" Width="250px"></asp:TextBox></td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbNguoiyeucau" runat="server">Tên người yêu cầu<span class="batbuoc">(*)</span></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiyeucau" CssClass="user" runat="server" Width="250px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbNguoikhangcao" runat="server">Tên người kháng cáo<span class="batbuoc">(*)</span></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtNguoikhangcao" CssClass="user" runat="server" Width="250px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbNguoidungdon" runat="server">Tên người đứng đơn<span class="batbuoc">(*)</span></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtNguoidungdon" CssClass="user" runat="server" Width="250px"></asp:TextBox></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="boxchung">
                        <h4 class="tleboxchung">Tình trạng giải quyết</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <%--<tr>
                                    <td style="width: 260px;">
                                        <asp:RadioButtonList ID="rdTTGQ" runat="server"
                                            RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdTTGQ_SelectedIndexChanged">
                                            <asp:ListItem Value="1">Thụ lý</asp:ListItem>
                                            <asp:ListItem Value="2">Bổ sung</asp:ListItem>
                                            <asp:ListItem Value="3">Trả lại</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>--%>
                                <tr>
                                    <td style="width: 115px;">Kết quả xử lý<span class="batbuoc">(*)</span>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtYCBS" CssClass="user" runat="server" Width="500px" TextMode="MultiLine"></asp:TextBox></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                    </div>
                    <div style="margin: 5px; text-align: center; width: 95%; margin-bottom: 70px;">
                        <asp:Button ID="cmdUpdateB" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" />
                        <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput" Text="Quay lại"
                            OnClick="cmdQuaylai_Click" />
                    </div>
                </div>
            </div>
        </div>
        <script>
            function ReloadParent() {
                window.onunload = function (e) {
                    opener.ReLoadGrid();
                };
            }
        </script>
    </form>
</body>
<script type="text/javascript">

    function pageLoad(sender, args) {
        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: false }, '.chosen-select-width': { width: '95%' } }
        for (var selector in config) {
            $(selector).chosen(config[selector]);
        }
    }
    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }

    function Setfocus(controlid) {
        var ctrl = document.getElementById(controlid);
        ctrl.focus();
    }
</script>
</html>
