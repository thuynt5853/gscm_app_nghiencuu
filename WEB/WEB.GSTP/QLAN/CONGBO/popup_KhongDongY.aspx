<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popup_KhongDongY.aspx.cs" Inherits="WEB.GSTP.QLAN.popup_KhongDongY" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDSNguoiThamGiaToTung.ascx" TagPrefix="uc1" TagName="uDSNguoiThamGiaToTung" %>--%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Không đồng ý</title>
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <link href="../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../UI/js/jquery-ui.min.js"></script>
    <script src="../../UI/js/Common.js"></script>

    <script src="../../UI/js/chosen.jquery.js"></script>

    <style>
        body {
            width: 100vh;
            height: 100vh;
            margin-left: 1%;
            min-width: 0px;
            padding-top: 5px;
        }

        .box {
            /*height: 450px;*/
            /*overflow: auto;*/
        }

        .form_tt {
            padding-top: 10px;
            margin: 0 auto;
            /*width: 760px;*/
            position: relative;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .t-w-100 {
            width: 100%;
            max-width: 100%;
            min-width: 100%;
            resize: vertical;
        }
    </style>
</head>
<body style="width: auto; height: auto; min-height: 200px; min-width: 500px">
    <form id="form1" runat="server">
        <div class="box" style="padding-bottom: 10px">
            <div class="form_tt">
                <h4 class="tleboxchung">Không đồng ý</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td>Lý do</td>
                            <td class="w-100">
                                <asp:TextBox ID="txtNDD_HoTen" CssClass="user t-w-100" runat="server"
                                    MaxLength="250"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Ghi chú</td>
                            <td>
                                <asp:TextBox ID="txtNDD_ChucVu" CssClass="user t-w-100" runat="server" TextMode="MultiLine"
                                    MaxLength="250"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div>
                <table style="width: 100%; padding-top: 15px;">
                    <tr>
                        <td align="center" style="width: 100%">
                            <asp:Button ID="btnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnLuu_Click" />
                            <asp:Button ID="btnXoa" runat="server" CssClass="buttoninput" Text="Xóa" />
                            <asp:Button ID="btnLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
