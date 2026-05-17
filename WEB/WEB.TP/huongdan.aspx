<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AN_PHI.Master" AutoEventWireup="true" CodeBehind="huongdan.aspx.cs" Inherits="WEB.TP.huongdan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content_form" style="margin-bottom: 30px;">
        <div class="leftzone">
            <div class="leftmenu">
                <div class="leftmenu_header arrow">
                    <span>Hướng dẫn sử dụng</span>
                </div>
                <div class="leftmenu_content">
                    <ul class="thongke" style="padding-left:20px;">
                        <a href="HDSD/HDSD_TP.pdf" download="HDSD_TP.pdf" style="float: left; text-decoration: none; font-size: 17px; color: #000000;">
                            <span style="margin-left: 5px;float:left;padding-right:10px;">Tải hướng dẫn</span>
                            <img  src="/UI/img/dowload.png"  style="float: left;"/>
                        </a>
                    </ul>
                </div>
            </div>
        </div>
        <div class="rightzone">
            <div class="content_body">
               <iframe id="iframe_pub" src="/UI/pdfjs/web/viewer.html?file=%2FHDSD/HDSD_TP.pdf" runat="server"></iframe>
            </div>
        </div>
    </div>

    <style>
        iframe {
            border: 0 none;
            height: 900px;
            width: 100%;
        }
        .content_body
        {
            margin-bottom:0px;
        }
    </style>
</asp:Content>
