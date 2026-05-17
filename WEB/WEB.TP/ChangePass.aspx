<%@ Page Title="" Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPages/AN_PHI.Master" CodeBehind="ChangePass.aspx.cs" Inherits="WEB.TP.ChangePass" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/UI/css/style.css" rel="stylesheet" />
    <link href="/UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="/UI/css/chosen.css" rel="stylesheet" />


    <link href="/UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="/UI/js/jquery-3.3.1.js"></script>
    <script src="/UI/js/jquery-ui.min.js"></script>


    <style type="text/css">
        body {
            margin: 0 auto;
            padding: 0;
            font-family: arial;
            font-size: 13px;
            background-color: #ffffff;
        }

        #login_frame {
            margin: 0px;
            width: 100%;
            height: 520px;
            background: url(/UI/img/bglauncher.png);
            background-size: 100% 100%;
            float: left;
            border-top: 1px solid #a91d1f;
        }

        #logo {
            width: 100%;
            height: 130px;
            margin-left: auto;
            margin-right: auto;
            background: url(UI/img/lgheader.png) no-repeat center;
        }

        #signin_frame {
            width: 685px;
            height: 420px;
            margin-top: 57px;
            background: none;
            background-color: #ffffff;
            margin-left: auto;
            margin-right: auto;
        }

        #titleds {
            float: left;
            width: 100%;
            text-align: center;
            margin-top: 0px;
            height: 36px;
            margin-bottom: 3px;
            line-height: 36px;
            color: #ffffff;
            font-size: 16px;
            font-weight: bold;
            background-color: #be1e1e;
        }

        .ctitem {
            float: left;
            width: 20%;
            height: 250px;
            padding-top: 35px;
        }

            .ctitem:hover {
                background: url(UI/img/bg_item.png);
            }

        .ctitemActive {
            float: left;
            width: 20%;
            height: 250px;
            background: url(UI/img/bg_item.png);
        }

        .khungnhap {
            width: 60%;
            margin-top: 13px;
            margin-left: 20%;
        }

            .khungnhap .box {
                display: block;
                float: left;
                margin-left: 12px;
                width: 90%;
                margin-bottom: 1px;
                border: none;
            }

            .khungnhap .textfield {
                display: block;
                height: 30px;
                width: 90%;
                margin: 8px 0;
                text-indent: 15px;
                border: solid 1px #8c0a0c;
                border-radius: 4px 4px 4px 4px;
            }

        .button {
            margin-top: 8px;
            background: none;
        }

        .menu {
            margin-bottom: 0px;
        }
    </style>
    <script> $(document).ready(function () {
            document.getElementById('<%=txtPass_new.ClientID%>').value = '';
        });</script>
   <%-- <asp:UpdatePanel ID="Ajax_Manager_Updata" runat="server">
        <ContentTemplate>--%>
            <div id="login_frame">
                <div id="signin_frame">
                    <div id="titleds">ĐỔI MẬT KHẨU</div>
                    <div class="khungnhap" style="margin-top:0px;">
                        <table style="width: 90%;">
                            <tr>
                                <td style="width: 100px;">Tên đăng nhập</td>
                                <td>
                                    <asp:TextBox ID="txtUserName" runat="server" ReadOnly="true" Enabled="false" paceholder="Mã truy cập" CssClass="textfield"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Mật khẩu mới</td>
                                <td>
                                    <asp:TextBox ID="txtPass_new" runat="server" paceholder="Mật khẩu mới" autocomplete="off" TextMode="Password" CssClass="textfield"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Nhập lại mật khẩu mới</td>
                                <td>
                                    <asp:TextBox ID="txtRePass" runat="server" paceholder="Nhập lại mật khẩu" TextMode="Password" CssClass="textfield"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:ImageButton ID="cmdLogIn" ImageUrl="/UI/img/btnChangePass.png" runat="server" OnClick="cmdLogIn_Click" />
                                </td>
                            </tr>
                        </table>
                        <div style="float: left; margin-left: 13px; color: #da0421; font-weight: bold; margin-top: 4px;">
                            <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                        </div>
                        <div style="float: left; margin-left: 13px; color: black; margin-top: 4px;">
                            <asp:Literal ID="txtLuuY" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
            </div>
<%--        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="Ajax_Manager_Updata">
        <ProgressTemplate>
            <div class="processmodal">
                <div class="processcenter">
                    <img src="UI/img/process.gif" />
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>
</asp:Content>
