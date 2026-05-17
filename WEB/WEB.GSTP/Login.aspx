<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WEB.GSTP.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HỆ THỐNG GIÁM SÁT HOẠT ĐỘNG CHUYÊN MÔN</title>
    <link href="UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <meta name="robots" content="noindex, nofollow" />
</head>
<body>
    <form id="form1" runat="server">

        <style type="text/css">
            body {
                margin: 0 auto;
                padding: 0;
                font-family: arial;
                font-size: 13px;
                background-color: #ffffff;
            }

            #logo {
                width: 100%;
                height: 119px;
                background: url(UI/img/Login/login_top_bg.png) #d63027 no-repeat;
                /*background-position: 0px 0px;*/
                background-size: cover;
                background-color: #d63027;
                font-family: 'Roboto Condensed', sans-serif
            }

            #login_frame {
                width: 100%;
                /*height: 669px;*/
                height: 738px;
                background: url(UI/img/Login/login_body.png) no-repeat;
                background-color: #de7a43;
                /*background-position: 0px -119px;*/
                background-size: cover;
                float: left;
            }

            .hotrotitle {
                float: left;
                width: 100%;
                height: 40px;
                background: url(UI/img/Login/login_bottom.png) no-repeat;
                /*background-position: 0px -756px;*/
                /*background-size: cover;*/
            }

            #signin_frame {
                width: 416px;
                height: 335px;
                margin-top: 110px;
                background: url(UI/img/lgbg_login.png);
                margin-left: auto;
                margin-right: auto;
            }

            .signin_title {
                width: 680px;
                height: 53px;
                background: url(UI/img/lgdang_nhap.png);
                font-size: 18px;
                font-weight: bold;
                color: #ffffff;
                text-align: center;
                line-height: 52px;
            }

            .khungnhap {
                float: left;
                /*width: 100%;*/
                width: 96%;
                margin-left: 2%;
                margin-top: 90px;
                font-size: 13px;
            }

                .khungnhap .box {
                    display: block;
                    float: left;
                    /*margin-left: 35px;
                    width: 345px;*/
                    width: 86%;
                    margin-left: 7%;
                    border: solid 1px #aeaeae;
                    margin-bottom: 20px;
                    border-radius: 4px 4px 4px 4px;
                    background: #fffac7;
                }

            .matruycap {
                float: left;
                width: 42px;
                height: 44px;
                background: #fffac7 url(UI/img/bgmatruycap.png);
                border-right: solid 1px #aeaeae;
            }

            .matkhau {
                float: left;
                width: 42px;
                height: 44px;
                background: #fffac7 url(UI/img/bgmatkhau.png);
                border-right: solid 1px #aeaeae;
            }

            .khungnhap .textfield {
                display: block;
                height: 42px;
                width: 80%;
                /*width: 300px;*/
                margin: 0px 0;
                text-indent: 15px;
                border: 0px;
                background-color: #fffac7;
            }

            .clearfix {
                width: 100%;
                float: left;
                margin-left: 10px;
                margin-top: 5px;
            }

            .remember {
                float: left;
            }

            .button {
                margin-top: 10px;
            }

            .hotro {
                float: left;
                width: 100%;
            }



            .hotroinfo {
                margin-left: auto;
                margin-right: auto;
                color: #555555;
                font-size: 16px;
                width: 1000px;
            }

                .hotroinfo .phone {
                    float: left;
                    width: 500px;
                    height: 95px;
                    line-height: 95px;
                    background: url(UI/img/lgcontact.png) no-repeat;
                    margin-right: 10px;
                    text-indent: 105px;
                }

                .hotroinfo .email {
                    float: left;
                    width: 300px;
                    height: 95px;
                    line-height: 95px;
                    background: url(UI/img/lgemail.png) no-repeat;
                    margin-right: 10px;
                    text-indent: 105px;
                }

                .hotroinfo .skype {
                    float: left;
                    width: 300px;
                    height: 95px;
                    line-height: 95px;
                    background: url(UI/img/lgskype.png) no-repeat;
                    margin-right: 10px;
                    text-indent: 105px;
                }

            .link a {
                color: #204165;
                line-height: 24px;
            }

            .link {
                text-align: right;
            }

            #TTHT {
                width: 90%;
                border-radius: 3px;
                background: #3c3c3c;
                padding: 20px 50px;
                float: left;
                margin-top: 40px;
            }

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

            .processmodal {
                position: fixed;
                z-index: 999;
                height: 100%;
                width: 100%;
                top: 0;
                filter: alpha(opacity=60);
                opacity: 0.6;
                -moz-opacity: 0.8;
            }

            .processcenter {
                z-index: 1000;
                margin: 300px 300px;
                padding: 10px;
                width: 180px;
                border-radius: 10px;
                filter: alpha(opacity=100);
                opacity: 1;
                -moz-opacity: 1;
            }

                .processcenter img {
                    height: 178px;
                    width: 178px;
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

            .logo_tatc img {
                width: 102px;
                height: 100px;
            }
            .logo_right img {
                /*background: url(UI/img/login/Login_top_right.png) #d63027;*/
                /*width: 100%;*/
                height: 119px;
                background-color: #d63027;
            }
        </style>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="float: left; position: relative; width: 100%; top: 0px;">
                    <div id="logo" style="float: left; position: absolute;">
                        <div class="logo_tatc" style="float: left; width: 100px; height: 100px; position: absolute; top: 10px; left: 30px; z-index: 1000;">
                            <img src="UI/img/login/logo_tatc.png" />
                        </div>
                        <div style="float: left; color: #fef270; font-weight: bold; position: absolute; left: 150px; top: 25px; z-index: 10000;">
                            <div style="font-size: 21px;">TÒA ÁN NHÂN DÂN TỐI CAO</div>
                            <div style="font-size: 26px; margin-top: 7px;">HỆ THỐNG GIÁM SÁT HOẠT ĐỘNG TÒA ÁN</div>
                        </div>
                    </div>
                    <div class="logo_right" style="position: absolute; right: 0px; top: 0px;">
                        <img src="UI/img/login/Login_top_right.png" />
                    </div>
                    <div id="login_frame" style="float: left; position: absolute; top: 119px;"></div>                    
                    <div style="width: 100%;float: left; position: absolute; top: 119px;">
                        <div id="signin_frame">
                            <div class="khungnhap">
                                <div class="box">
                                    <div class="matruycap"></div>
                                    <asp:TextBox ID="txtUserName" runat="server" placeholder="Tài khoản" CssClass="textfield"></asp:TextBox>
                                </div>
                                <div class="box">
                                    <div class="matkhau"></div>
                                    <asp:TextBox ID="txtPass" runat="server" placeholder="Mật khẩu" TextMode="Password" CssClass="textfield"></asp:TextBox>
                                </div>
                                <div style="float: left; width: 100%; text-align: center;">
                                    <div class="button">
                                        <asp:ImageButton ID="cmdLogIn" ImageUrl="UI/img/lgdangnhap_button.png"
                                            runat="server" Width="86%" OnClick="cmdLogIn_Click" />
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
                            </script>
                        </div>
                    </div>
                    <div style="float: left; width: 100%; position: absolute; top: 856px; background-color: #ffffff">
                        <div style="float: left; width: 100%; position: relative;">
                            <div class="hotrotitle" style="margin-bottom: 0px;"></div>
                            <div class="hotroinfo" style="position: absolute; left: 500px; top: 0px; width: 220px; margin-top: 0px; float: left; margin-bottom: 0px;">
                                <div style="float: left; margin-left: 13px; color: #555555; font-size: 16px; margin-top: 5px;">
                                    <b>Email hỗ trợ:</b><br />
                                    tatc.phanmem@toaan.gov.vn
                                </div>
                            </div>
                        </div>
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
