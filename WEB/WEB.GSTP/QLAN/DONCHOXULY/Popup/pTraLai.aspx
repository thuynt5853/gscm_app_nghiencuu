<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pTraLai.aspx.cs" Inherits="WEB.GSTP.QLAN.DONCHOXULY.Popup.pTraLai" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Trả lại đơn</title>
    
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                    <style type="text/css">
                        body {
                            width: 98%;
                            margin-left: 1%;
                            min-width: 0px;
                            overflow: hidden;
                        }
                        .check_list_vertical table td {
                            padding-right: 15px;
                        }
                        .boxchung {
                            padding-top: 10px;
                        }
                    </style>

                    <div class="boxchung">
                        <table class="table1">
                            <tr>
                                <td>Lý do trả<span  class="batbuoc">*</span></td>
                                <td>
                                    <asp:TextBox ID="txtLyDoTra" runat="server" CssClass="user" MaxLength="1000"
                                        Width="450px" TextMode="multiline" Rows="6"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div style="margin-top:10px;margin-left:10px">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                    </div>

                    <div style="padding:10px 0 25px 0; text-align: center">
                        <asp:Button ID="cmdTraLai" runat="server" CssClass="buttoninput" Text="Trả lại" OnClick="cmdTraLai_Click" />
                        <input type="button" class="buttoninput" onclick="ReloadParent();" value="Huỷ" />
                    </div>

                </div>
                <script>
                    function ReloadParent() {
                        window.close();
                    }
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>

