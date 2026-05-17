<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WEB.TP.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>QUẢN LÝ THU, NỘP TIỀN TẠM ỨNG ÁN PHÍ</title>
    <link href="/UI/css/style.css" rel="stylesheet" />
    <link href="UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <style>
        .support {
            width: 29%;
            display: inline;
            float: left;
            margin-right: 50px;
        }

            .support.last {
                margin-right: 0;
            }

        .name {
            text-transform: uppercase;
            font-size: 16px;
            font-weight: bold;
            color: #2aabe1;
            margin-bottom: 20px;
            border-bottom: solid 1px #fff;
            line-height: 30px;
        }

        .support ul {
            margin: 0;
            padding: 0;
        }

            .support ul li {
                list-style: none;
                font-size: 13px;
                color: #fff;
                line-height: 24px;
            }

                .support ul li a {
                }


        input[type=checkbox] {
            position: relative;
            cursor: pointer;
            margin-right: 9px;
        }

            input[type=checkbox]:before {
                content: "";
                display: block;
                position: absolute;
                width: 14px;
                height: 14px;
                top: 0;
                left: 0;
                border: 2px solid #555555;
                border-radius: 3px;
                background-color: white;
            }

            input[type=checkbox]:checked:after {
                content: "";
                display: block;
                width: 5px;
                height: 8px;
                border: solid black;
                border-width: 0 2px 2px 0;
                -webkit-transform: rotate(45deg);
                -ms-transform: rotate(45deg);
                transform: rotate(45deg);
                position: absolute;
                top: 2px;
                left: 6px;
            }

        input[type="image" i] {
            outline: none;
        }
        
       .csscaptcha
       {
           position:absolute;
           margin-left: 8px;
       }
       .cssrefresh
       {
           position: absolute;
            right: 10px;
            top: 15px;
            width: 20px;
       }
    </style>
</head>
<body style="background-color: #b20c0c">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                 <div class="header header_login">
                    <div class="headertop">
                        <a href="http://www.toaan.gov.vn" target="_blank">
                            <div class="logo_toaan"></div>
                        </a>
                        <a href="http://www.moj.gov.vn" target="_blank">
                            <div class="logo_botuphap"></div>
                        </a>
                        <div class="logo_text logo_text_home" style="text-align: center; margin-left: 7%">
                            QUẢN LÝ THU, NỘP TIỀN TẠM ỨNG ÁN PHÍ
                        </div>
                    </div>
                </div>

                <div id="login_frame">
                    <div id="signin_frame">
                        <div class="khungnhap">
                            <div class="box">
                                <div class="matruycap"></div>
                                <asp:TextBox ID="txtUserName" runat="server" OnTextChanged="txtUserName_TextChanged" placeholder="Mã truy cập" CssClass="textfield"></asp:TextBox>
                            </div>
                            <div class="box">
                                <div class="matkhau"></div>
                                <asp:TextBox ID="txtPass" runat="server" placeholder="Mật khẩu" TextMode="Password" CssClass="textfield"></asp:TextBox>
                            </div>
                          <%--  <div class="box" id="MAXACTHUC1" runat="server">
                                <div style="position:relative">
                                    <div class="maxacthuc">
                                        <asp:TextBox ID="txtCaptcha" runat="server"
                                        placeholder="Mã xác thực" CssClass="textfield" Width="100%"/>
                                    </div>
                                    <asp:Image ID="imCaptcha" ImageUrl="" CssClass="csscaptcha" runat="server"/>
                                    <asp:ImageButton ID="cmdRefresh" CssClass="cssrefresh" OnClick="cmdRefresh_Click" ImageUrl="~/UI/img/ico2.png" runat="server"/>
                                </div>
                            </div>--%>
                            <div style="float: left; width: 100%; text-align: center;">
                                <div class="button_login">
                                    <asp:ImageButton ID="cmdLogIn" ImageUrl="UI/img/lgdangnhap_button.png"
                                        runat="server" OnClick="cmdLogIn_Click" OnClientClick="return validate();" />
                                </div>
                            </div>
                            <div class="clearfix">
                                <div class="remember" style="display: none;">
                                    <asp:CheckBox ID="chkIsDomain" runat="server" Text="Sử dụng tài khoản thư điện tử" />
                                </div>
                                <div style="float: left; margin-left: 13px; color: #da0421; font-weight: bold; margin-top: 4px;">
                                    <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                                </div>
                            </div>

                        </div>
                    <%--    <script type="text/javascript">
                            document.getElementById("form1").addEventListener("keypress", function (event) {
                                // Kiểm tra nếu phím được nhấn là Enter (phím số 13)
                                if (event.key === "Enter") {
                                    // Ngăn chặn hành vi mặc định của phím Enter
                                    event.preventDefault();
                                    // Gọi hàm đăng nhập
                                    if (validate()) {
                                        document.getElementById("cmdLogIn").click();
                                    }
                                }
                            });
                        </script>--%>
                        <script>
                            function Common_CheckEmpty(string_root) {
                                retval = true;
                                _pattern = /\s/g;
                                if (string_root.replace(_pattern, "") == "") {
                                    return false;
                                }
                                else {
                                    return true;
                                }
                            }
                            function validate() {
                                var txtUserName = document.getElementById('<%=txtUserName.ClientID%>');
                                if (!Common_CheckEmpty(txtUserName.value)) {
                                    alert('Bạn chưa nhập mã truy cập. Hãy kiểm tra lại!');
                                    txtUserName.focus();
                                    return false;
                                }

                                var txtPass = document.getElementById('<%=txtPass.ClientID%>');
                                if (!Common_CheckEmpty(txtPass.value)) {
                                    alert('Bạn chưa nhập mật khẩu. Hãy kiểm tra lại!');
                                    txtPass.focus();
                                    return false;
                                }

                               <%-- var txtCaptcha = document.getElementById('<%= txtCaptcha.ClientID%>');
                                if (!Common_CheckEmpty(txtCaptcha.value)) {
                                    alert('Bạn chưa nhập mã xác thực! Hãy kiểm tra lại!');
                                    txtCaptcha.focus();
                                    return false;
                                }--%>
                                return true;
                            }
                        </script>

                    </div>
                </div>
                <div class="footer" style="background-color: #b20c0c; padding: 17px 0px;">
                    <div class="content_center">
                        <div style="float: left; margin-left: 2%; margin-right: 2%;">
                            <div style="font-size: 15px; text-transform: uppercase; margin-bottom: 7px;">
                                TÒA ÁN NHÂN DÂN TỐI CAO
                            </div>
                            <div style="color: white; font-size: 14px; line-height: 20px;">
                                Địa chỉ : 48 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội.
                                <br />
                                Điện thoại: 024.3939.3335<br />
                                Bản quyền thuộc Tòa án nhân dân tối cao
                                <br />
                            </div>
                        </div>
                        <div style="float: left; margin-left:3px; margin-right: 2%;">
                            <div style="font-size: 15px; text-transform: uppercase; margin-bottom: 7px;">
                                TỔNG CỤC THI HÀNH ÁN DÂN SỰ - BỘ TƯ PHÁP
                            </div>
                            <div style="color: white; font-size: 14px; line-height: 20px;">
                                Địa chỉ :  60 Trần Phú, Ba Đình, Hà Nội. 
                                <br />
                                Điện thoại: 02432 444 269 - Fax: 02432 444 214.<br />
                            </div>
                        </div>
                        <div style="float: right; text-align: right; margin-top: 7px; margin-right: 10px;">
                            <a href="http://www.toaan.gov.vn" target="_blank" style="float: left; margin-right: 40px;">
                                <img src="/UI/img/logo_TAND.png" style="border: none; height: 60px;" /></a> <a href="http://congbobanan.toaan.gov.vn/" target="_blank" style="float: left; margin-right: 40px;">
                                    <img src="/UI/img/logo_Congbobanan.png" style="border: none; height: 60px;" /></a> <a href="https://capsaobanan.toaan.gov.vn/" target="_blank" style="float: right;">
                                        <img src="/UI/img/logo_DK_cap_sao.png" style="border: none; height: 60px;" /></a>
                        </div>
                    </div>
                </div>
                <style>
                    .footer {
                        float: left;
                        width: 100%;
                        overflow: hidden;
                        background-color: rgb(255, 255, 255);
                        position: relative;
                        bottom: 0px;
                        font-size: 16px;
                        color: white;
                        font-family: Roboto Condensed;
                        border-top: solid 1px #b12323;
                    }
                </style>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
</body>
</html>
