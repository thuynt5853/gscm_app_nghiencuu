<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CapNhatThamPhan.aspx.cs" Inherits="WEB.GSTP.PCA.CapNhatThamPhan" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
    <title>Cập nhật thẩm phán</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:700px; height:400px;">
             <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
             <div style="text-align:center;margin-top:15px;">
                <asp:Button ID="lbsua" runat="server" onclick="lbsua_Click" CssClass="buttoninput" Text="Lưu" />
                <input type="button" class="buttoninput" onclick="ClosePopup()" value="Đóng" />
             </div>
             <div>                           
                <table class="table1" style="margin-left: 30px; margin-right:30px;">
                                         <tr>
                                            <td colspan="2"><asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label></td>                                                                           
                                        </tr>
                                        <tr>
                                            <td style="width: 100px;">Tên vụ án</td>
                                            <td>
                                                <asp:TextBox ID="txtTenVuViec" Enabled="false" CssClass="user"
                                                        runat="server" Width="400px"></asp:TextBox>
                                            </td>                                       
                                        </tr>
                                        <tr>
                                            <td style="width: 100px;">Thẩm phán chủ tọa<span class="batbuoc">(*)</span></td>
                                             <td style="width: 400px;">
                                                <asp:DropDownList ID="ddlThamphan"                                                        
                                                            CssClass="chosen-select" runat="server" Width="406px">
                                                </asp:DropDownList>
                                             </td>                            
                                        </tr>
                                        <tr>
                                            <td style="width: 100px;">Lý do<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:TextBox ID="txtLyDo" CssClass="user"
                                                    runat="server" Width="400px"></asp:TextBox>
                                            </td>
                                        
                                        </tr>                                   
                                    </table>
             </div>
        </div>
                  
    </form>
</body>
   
<script src="/UI/js/init.js"></script>
</html>
 <script>
        function ClosePopup() {
            var hddIsReloadParent = document.getElementById('<%=hddIsReloadParent.ClientID%>');
            var value = parseInt(hddIsReloadParent.value);
            if (value == 0)
                window.close();
            else
                ReloadParent();
        }
        function ReloadParent() {
            window.onunload = function (e) {
                opener.Loadphancong();
            };
            window.close();
        }       
     </script>