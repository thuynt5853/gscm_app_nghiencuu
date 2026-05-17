<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WEB.DONKHOIKIEN.Download.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>
    </title>
    <style>
        a {
            color: #ffffff;
        }
    </style>
</head>
<body style="color: #ffffff; margin: 0px; font-size: 22px; font-family: 'Times New Roman'">
    <form id="form1" runat="server">
        <div style="background-color: #ed3237; height: 190px; width: 100%; float: left; background: url(bg_download.png)">
            <div style="margin-top: 50px; margin-left: 200px; width: 700px; float: left;">
                <div style="float: left; width: 350px;">Tải hướng dẫn sử dụng chứng thư số</div>
                <div style="float: left; width: 350px;">
                    <a href="HDSDCTS.pdf" download>HDSDCTS.pdf</a>
                </div>
            </div>
            <div style="margin-top: 10px; margin-left: 200px; width: 800px; float: left;">
                <div style="float: left; width: 350px;">Tải driver chứng thư số đầy đủ</div>
                <div style="float: left; width: 350px;">
                    <a href="VGCAFULL.rar" download>VGCAFULL.rar</a>
                </div>
            </div>
            <div style="margin-top: 10px; margin-left: 200px; width: 800px; float: left;">
                <div style="float: left; width: 350px;">Microsoft .NET Framework 4</div>
                <div style="float: left; width: 350px;">
                    <a href="dotNetFx40_Full_x86_x64.exe" download>dotNetFx40_Full_x86_x64.exe</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
