<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="ChangePass.aspx.cs" Inherits="WEB.GSTP.ChangePass" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HỆ THỐNG GIÁM SÁT HOẠT ĐỘNG CHUYÊN MÔN</title>
    <link href="UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
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

            #login_frame {
                width: 100%;
                height: 414px;
                background: url(UI/img/lgbglauncher.png);
                background-size: 100% 100%;
                float: left;
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
                height: 352px;
                margin-top: 57px;
                background-color: #ffffff;
                margin-left: auto;
                margin-right: auto;
                box-shadow: 0 7px 7px rgba(0, 0, 0, 0.2); 
                border-radius :4px;
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
                background-color: #be1e1e;border-radius :4px 4px 0px 0px;
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
                margin-right: 20px;
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

            .btnBack {
                height: 27px;
                line-height: 27px;
                font-weight: bold;
                font-size: 12px;
                color: #333333;
                border: solid 1px #db7171;
                padding-left: 12px;
                padding-right: 40px;
                background: #dbdbdb url("UI/img/icoback.png") no-repeat;
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

            .khungnhap {
                float: left;
                width: 60%;
                margin-top: 3px;
                font-size: 13px;
                margin-left: 20%;
            }

                .khungnhap .box {
                    display: block;
                    float: left;
                    margin-left: 12px;
                    width: 90%;
                    margin-bottom: 1px;
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

            .clearfix {
                width: 100%;
                float: left;
                margin-left: 10px;
                margin-top: 5px;
            }

            .cmdTBTC {
                border: 1px solid black;
                border-radius: 10px;
                font-size: x-large;
                background-color: red;
                color: white;
            }

            #tieude {
                width: 100%;
                text-align: center;
                margin-top: 0px;
                height: 36px;
                margin-bottom: 3px;
                line-height: 36px;
                color: red;
                font-size: 20px;
                font-weight: bold;
                border-radius :4px 4px 0px 0px;
            }
            #lblthongbao {
                width: 100%;
                text-align: center;
                margin-top: 0px;
                margin-bottom: 3px;
                line-height: 36px;
                color: black;
                font-size: 18px;
                font-weight: bold;
                border-radius :4px 4px 0px 0px;
            }
        </style>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div id="logo">
                    <div class="taikhoan">
                        &nbsp;
             <asp:Button ID="cmbBack" runat="server" Text="Chọn Phân hệ khác" CssClass="btnBack" OnClick="lblBack_Click" UseSubmitBehavior="false"/>
                        &nbsp;  &nbsp;
                                    <asp:Button ID="cmdThoat" runat="server" Text="Thoát" CssClass="btnSignout" OnClick="cmdThoat_Click" UseSubmitBehavior="false"/>
                    </div>

                </div>
                <div id="login_frame">

                    <div id="signin_frame">
                        <div id="titleds">ĐỔI MẬT KHẨU</div>
                        <div class="khungnhap" style="margin-top:0px;">
                            <table style="width: 90%;">
                                <tr>
                                    <td style="width: 100px;">Tài khoản</td>
                                    <td>
                                        <asp:TextBox ID="txtUserName" runat="server" ReadOnly="true" Enabled="false" paceholder="Tài khoản" CssClass="textfield"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Mật khẩu mới</td>
                                    <td>
                                        <asp:TextBox ID="txtPass" runat="server" paceholder="Mật khẩu mới" TextMode="Password" CssClass="textfield"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Nhập lại mật khẩu mới</td>
                                    <td>
                                        <asp:TextBox ID="txtRePass" runat="server" paceholder="Nhập lại mật khẩu" TextMode="Password" CssClass="textfield"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:ImageButton ID="cmdLogIn" ImageUrl="UI/img/btnChangePass.png" runat="server" OnClick="cmdLogIn_Click" /></td>
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
                <div class="hotro">
                    <div class="hotrotitle"></div>
                    <div class="hotroinfo">
                        <asp:Literal ID="lsthotro" runat="server"></asp:Literal>
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

        <div runat="server" id="mymodalTB" style="display: none; visibility: hidden; position: absolute!important; "></div>
        <cc1:ModalPopupExtender ID="modalTB" BehaviorID="modal_ThongBao"
            runat="server" PopupControlID="pnThanhCong"
            TargetControlID="mymodalTB"            
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:Panel ID="pnThanhCong" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 100%; width: 900px; top: 20px;">
            <div class="box_nd" style="width: 660px;padding-top:210px;">
                    <div class="boder" style="padding: 10px;background-color: white;border: 1px solid black;border-radius: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="text-align: center;" id="Td1" runat="server">
                                    <h1 id="tieude" runat="server">THÔNG BÁO
                                    </h1>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center;" id="txtthongbao" runat="server">
                                    <h4 id="lblthongbao" runat="server" style="font-size: 20px;color:black;">Thiết lập mật khẩu thành công. Bạn có thể đăng nhập bằng mật khẩu vừa thiết lập.
                                    </h4>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center;" >
                                    <asp:Button ID="cmdTBTC" runat="server" CssClass="buttoninput cmdTBTC" OnClick="Login_Click" Text="Đóng" />
                                </td>
                            </tr>
                        </table>
                    </div>
            </div>
        </asp:Panel>
    </form>
</body>
</html>
