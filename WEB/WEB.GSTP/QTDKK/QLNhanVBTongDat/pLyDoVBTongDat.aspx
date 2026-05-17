<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pLyDoVBTongDat.aspx.cs" Inherits="WEB.GSTP.QTDKK.QLNhanVBTongDat.pLyDoVBTongDat" %>

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
            min-height:0px;
        }



        .box {
            overflow: auto;
            position: absolute;
            width:100%
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            padding: 10px 1.5%;
        }
        input{
            height:28px !important;
        }
         </style>
</head>
<body>
    
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Lý do đóng</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <div style="float: left; margin-top: 8px;">
                                                    <div style="float: left; width: 115px; text-align: left; margin-right: 25px;">Lý do<span style="color:red">*</span></div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtLyDo" TextMode="MultiLine" CssClass="user" runat="server" Width="597px"></asp:TextBox>
                                                    </div>
                                                    
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr><td style="width: 150px;" align="left"><asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label></td></tr>
                    <tr>
                        
                        <td align="center">
                            <asp:HiddenField ID="hddid" runat="server" Value="0" />
                            <asp:HiddenField ID="hdddkkuser" runat="server" Value="0" />
                            <asp:Button ID="Button1" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="lbLuu_Click" />
                            <asp:Button ID="Button3" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lbQuayLai_Click" />
                        </td>
                    </tr>
                    
                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function ReloadParent() {
            window.onunload = function (e) {
                opener.ReLoadGrid();
            };
            window.close();
        }
    </script>
    </form>
</body>
</html>

