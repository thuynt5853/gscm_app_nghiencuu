<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pNhanThan.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.Popup.pNhanThan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDsNhanThanBiCao.ascx" TagPrefix="uc1" TagName="uDsNhanThanBiCao" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Nhân thân của bị can</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../..//UI/js/jquery-ui.min.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
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

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">Cập nhật thông tin nhân thân của bị can</h4>
                    <div class="boder">
                        <table class="table1">
                            <tr>
                                <td colspan="4"></td>
                            </tr>
                            <tr>
                                <td style="width:80px">Họ tên<span class="batbuoc">(*)</span></td>
                                <td style="width:160px">
                                    <asp:TextBox ID="txtHoTen" CssClass="user"
                                        runat="server" Width="140px" MaxLength="250"></asp:TextBox></td>
                                <td style="width:80px">Giới tính</td>
                                <td>
                                    <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select" runat="server" Width="150">
                                        <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td>Năm sinh<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNamSinh" runat="server" CssClass="user"
                                        Width="140px" MaxLength="10"></asp:TextBox>
                                </td>
                                <td>Mối quan hệ</td>
                                <td>
                                    <asp:DropDownList ID="dropMoiQuanHe"  CssClass="chosen-select" 
                                        runat="server" Width="150" MaxLength="250">
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td>Địa chỉ</td>
                                <td>
                                    <asp:TextBox ID="txtDiaChi" CssClass="user"
                                        runat="server" Width="140px" MaxLength="250"></asp:TextBox></td>
                                <td>Ghi chú</td>
                                <td>
                                    <asp:TextBox ID="txtGhiChu" CssClass="user"
                                        runat="server" Width="75%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div style="margin: 5px; text-align: left; width: 95%; float: left;">
                                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                            <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                        </div>
                                    <div style="float: left; width: 100%;">
                                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                            <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                                        </div>
                                       
                                    </div>
                                </td>
                            </tr>
                            <tr><td colspan="4">
                                <uc1:uDsNhanThanBiCao runat="server" ID="uDsNhanThanBiCao" />
                                </td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function validate() {
                var txtTen = document.getElementById('<%=txtHoTen.ClientID%>');
                if (!Common_CheckEmpty(txtTen.value)) {
                    alert('Bạn chưa nhập họ tên nhân thân của bị can.Hãy kiểm tra lại!');
                    txtTen.focus();
                    return false;
                }
                //-------------------------------
                var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
                if (!Common_CheckEmpty(txtNamSinh.value)) {
                    alert('Bạn chưa nhập năm sinh nhân thân của bị can.Hãy kiểm tra lại!');
                    txtNamSinh.focus();
                    return false;
                }

                //-----------------------------------------
               <%-- var QuocTichVN = '<%=QuocTichVN%>';
                var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
                value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;

                if (value_change == QuocTichVN) {
                    document.getElementById('zoneTamtru').innerHTML = "<span class='batbuoc'>(*)</span>";

                    //--------check nhap ho khau thuong tru---------
                    var ddlHKTT_Tinh = document.getElementById('<%=ddlHKTT_Tinh.ClientID%>');
                    var ddlHKTT_Huyen = document.getElementById('<%=ddlHKTT_Huyen.ClientID%>');

                    value_change = ddlHKTT_Tinh.options[ddlHKTT_Tinh.selectedIndex].value;
                    if (value_change == "0") {
                        alert('Bạn chưa chọn mục "Tỉnh/TP của nơi Thường trú". Hãy kiểm tra lại!');
                        ddlHKTT_Tinh.focus();
                        return false;
                    }
                    value_change = ddlHKTT_Huyen.options[ddlHKTT_Huyen.selectedIndex].value;
                    if (value_change == "0") {
                        alert('Bạn chưa chọn mục "Quận/Huyện của nơi Thường trú". Hãy kiểm tra lại!');
                        ddlHKTT_Huyen.focus();
                        return false;
                    }

                    //--------check nhap ho khau tam tru---------
                    var ddlTamTru_Tinh = document.getElementById('<%=ddlTamTru_Tinh.ClientID%>');
                    var ddlTamTru_Huyen = document.getElementById('<%=ddlTamTru_Huyen.ClientID%>');
                    value_change = ddlTamTru_Tinh.options[ddlTamTru_Tinh.selectedIndex].value;
                    if (value_change == "0") {
                        alert('Bạn chưa chọn mục "Tỉnh/TP của nơi Tạm trú". Hãy kiểm tra lại!');
                        ddlTamTru_Tinh.focus();
                        return false;
                    }
                    value_change = ddlTamTru_Huyen.options[ddlTamTru_Huyen.selectedIndex].value;
                    if (value_change == "0") {
                        alert('Bạn chưa chọn mục "Quận/Huyện của nơi Tạm trú". Hãy kiểm tra lại!');
                        ddlTamTru_Huyen.focus();
                        return false;
                    }
                }
                else
                    document.getElementById('zoneTamtru').innerHTML = "";--%>
                return true;
            }

        </script>
        <script>
            //-------load parent page when close popup---------------
            window.onunload = refreshParent;
            function refreshParent() {
                window.opener.location.reload();
            }
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
        </script>
    </form>
</body>
</html>
