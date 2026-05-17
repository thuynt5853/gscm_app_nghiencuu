<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Launcher.aspx.cs" Inherits="WEB.GSTP.Launcher" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HỆ THỐNG GIÁM SÁT HOẠT ĐỘNG CHUYÊN MÔN</title>
    <link href="UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="UI/css/chosen.css" rel="stylesheet" />

    <link href="UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="UI/js/jquery-3.3.1.js"></script>
    <script src="UI/js/jquery-ui.min.js"></script>
    <script src="UI/js/chosen.jquery.js"></script>
    <script src="UI/js/init.js"></script>
    <meta name="robots" content="noindex, nofollow" />
</head>
<body>
    <form id="form1" runat="server">
        <style type="text/css">
            body {
                width: 100%;
                min-width: 1150px;
                font-family: arial;
                font-size: 13px;
                background-color: #ffffff;
                padding: 0px;
                margin: 0px;
            }

            #login_frame {
                width: 100%;
                height: 570px;
                background-color: #ca2626;
                float: left;
            }

            #logo {
                width: 100%;
                height: 130px;
                margin-left: auto;
                margin-right: auto;
                background: #fffcdd url(UI/img/lgheader.png) no-repeat;
                background-size: auto;
            }

            #signin_frame {
                width: 840px;
                height: 489px;
                margin-left: auto;
                margin-right: auto;
            }

            #titleds {
                width: 1029px;
                height: 569px;
                margin-left: auto;
                margin-right: auto;
                background: url(UI/img/bglauncher.png);
            }

            .ctitem {
                float: left;
                width: 20%;
                height: 250px;
                padding-top: 35px;
            }

                .ctitem:hover {
                    background: url(UI/img/bg_item.png);
                    background-size: cover;
                }

            .ctitemActive {
                float: left;
                width: 20%;
                height: 250px;
                background: url(UI/img/bg_item.png);
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

            .taikhoan {
                float: right;
                margin-right: 5%;
                /*margin-right: 20px;*/
                height: 46px;
                line-height: 46px;
                color: #333333;
                font-size: 12px;
                font-weight: bold;
            }

            .btnSignout {
                height: 27px;
                line-height: 27px;
                font-weight: bold;
                font-size: 12px;
                color: #333333;
                border: solid 1px #db7171;
                padding-left: 12px;
                padding-right: 40px;
                background: #dbdbdb url("UI/img/icologout.png") no-repeat;
                background-position: right 12px center;
                cursor: pointer;
            }

            .hotro {
                float: left;
                width: 100%;
            }

            .hotrotitle {
                float: left;
                width: 100%;
                height: 45px;
                background: url(UI/img/lgho_tro.png) no-repeat;
                margin-bottom: 20px;
            }

            .hotroinfo {
                margin-left: auto;
                margin-right: auto;
                margin-top: 20px;
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

            .btnGSTP {
                margin-left: 330px;
                cursor: pointer;
            }

            .btnQLA {
                margin-left: 0px;
                cursor: pointer;
            }

            .btnQLCB {
                margin-right: 95px;
                cursor: pointer;
                float: right;
            }

            .btnGDT {
                margin-left: 75px;
                cursor: pointer;
            }

            .btnTDKT {
                margin-left: 140px;
                cursor: pointer;
            }

            .btnQTHT {
                cursor: pointer;
            }



            input[type="image" i] {
                outline: none;
            }

            @media screen and (max-width: 980px) {

                #logo {
                    height: 95px;
                }
            }
        </style>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <div id="logo">

                    <div class="taikhoan" style="text-align: right;">
                        Chào mừng:
                                    <asp:Literal ID="lstUserName" runat="server"></asp:Literal>
                        |
                                    <asp:LinkButton ID="lbtChangePass" runat="server" Text="Đổi mật khẩu" ForeColor="#333333" OnClick="lbtChangePass_Click"></asp:LinkButton>
                        &nbsp; 
                                    <asp:Button ID="cmdThoat" runat="server" Text="Thoát" CssClass="btnSignout" OnClick="cmdThoat_Click" />
                    </div>
                    <div style="float: right; width: 95%; margin-right: 5%; margin-top: 25px;">
                        <div style="float: right; width: 328px;">
                            <asp:DropDownList CssClass="chosen-select" ID="ddlDonVi" runat="server" Width="330px"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div id="login_frame">
                    <div id="titleds">
                        <div id="signin_frame">
                            <div style="float: left; width: 100%; height: 135px; margin-top: 10px;">
                                <asp:ImageButton ID="btnGSTP_dis" runat="server" OnClientClick="alert('Bạn không có quyền truy cập phân hệ này !');" CssClass="btnGSTP" ImageUrl="UI/img/logo_GSTP_dis.png" />
                                <asp:ImageButton ID="btnGSTP" runat="server" Visible="false" CssClass="btnGSTP" ImageUrl="UI/img/logo_GSTP.png" OnClick="btnGSTP_Click" />
                            </div>
                            <div style="float: left; width: 100%; height: 104px; margin-top: 0px;">
                                <div style="float: left; width: 50%;">
                                    <asp:ImageButton ID="btnQLA" runat="server" Visible="false" CssClass="btnQLA" ImageUrl="UI/img/logo_QLA.png" OnClick="btnQLA_Click" />
                                    <asp:ImageButton ID="btnQLA_dis" runat="server" OnClientClick="alert('Bạn không có quyền truy cập phân hệ này !');" CssClass="btnQLA" ImageUrl="UI/img/logo_QLA_dis.png" />
                                </div>
                                <div style="float: right; width: 50%;">
                                    <asp:ImageButton ID="btnBC" runat="server" Visible="false" CssClass="btnQLCB" ImageUrl="UI/img/logo_BC.png" OnClick="btnBC_Click" />
                                    <asp:ImageButton ID="btnBC_dis" runat="server" OnClientClick="alert('Bạn không có quyền truy cập phân hệ này !');" CssClass="btnQLCB" ImageUrl="UI/img/LogoBC_dis.png" />
                                </div>

                            </div>
                            <div style="float: left; width: 100%; margin-top: 70px;">
                                <div style="float: left; width: 50%;">
                                    <asp:ImageButton ID="btnGDT_dis" runat="server" OnClientClick="alert('Bạn không có quyền truy cập phân hệ này !');" CssClass="btnGDT" ImageUrl="UI/img/logo_GDT_dis.png" />
                                    <asp:ImageButton ID="btnGDT" runat="server" Visible="false" CssClass="btnGDT" ImageUrl="UI/img/logo_GDT.png" OnClick="btnGDT_Click" />
                                </div>
                                <div style="float: right; width: 50%;">
                                    <asp:ImageButton ID="btnTDKT" runat="server" Visible="false" CssClass="btnTDKT" ImageUrl="UI/img/logo_CBBA.png" OnClick="btnTDKT_Click" />
                                    <asp:ImageButton ID="btnTDKT_dis" runat="server" OnClientClick="alert('Bạn không có quyền truy cập phân hệ này !');" CssClass="btnTDKT" ImageUrl="UI/img/logo_CBBA_dis.png" />
                                </div>
                            </div>
                            <div style="float: left; width: 100%; margin-top: 10px; height: 135px; text-align: center;">
                                <asp:ImageButton ID="btnQTHT" runat="server" Visible="false" CssClass="btnQTHT" ImageUrl="UI/img/logo_QTHT.png" OnClick="btnQTHT_Click" />
                                <asp:ImageButton ID="btnQTHT_dis" runat="server" OnClientClick="alert('Bạn không có quyền truy cập phân hệ này !');" CssClass="btnQTHT" ImageUrl="UI/img/logo_QTHT_dis.png" />

                            </div>
                        </div>
                    </div>
                </div>
                <div style="float: left; width: 100%;">
                    <div class="hotrotitle" style="margin-bottom: 0px;"></div>
                    <div class="hotroinfo" style="width: 100%; margin-top: 0px; float: left; margin-bottom: 50px;">
                        <asp:Literal ID="lsthotro" runat="server"></asp:Literal>
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

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</body>
</html>
