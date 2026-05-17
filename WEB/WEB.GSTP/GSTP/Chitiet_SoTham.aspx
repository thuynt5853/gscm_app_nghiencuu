<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chitiet_SoTham.aspx.cs" Inherits="WEB.GSTP.GSTP.Chitiet_SoTham" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <title>HỆ THỐNG GIÁM SÁT THẨM PHÁN</title>
    <link href="../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../UI/css/style.css" rel="stylesheet" />
    <style type="text/css">
        body {
            overflow-x: hidden !important;
        }

        .Table_Full_Width_No_Border_Spacing {
            width: 100%;
            border-spacing: 0px !important;
        }

        .lineHead {
            float: left;
            width: 100%;
            height: 5px;
            position: relative;
            background-color: #D40023;
        }

        .Title_Group_Box_GiaiDoan {
            float: left;
            color: #666666;
            text-transform: uppercase;
            font-size: 18px;
            font-weight: bold;
            margin-left: 5px;
            margin-bottom: 5px;
            width: 100%;
        }

        .MenuLeft {
            background-color: #D40023;
            width: 37px;
            height: 1786px;
        }

        .cmd_MenuLeft_Home {
            background-image: url('../UI/img/GSTP_MenuLeft_Home.png');
            background-repeat: no-repeat;
            display: block;
            width: 37px;
            height: 34px;
        }

            .cmd_MenuLeft_Home:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_Home_Hover.png');
                background-repeat: no-repeat;
                display: block;
                width: 37px;
                height: 34px;
            }

                .cmd_MenuLeft_Home:hover .bottom_ex {
                    background-image: url('../UI/img/GSTP_Bottom_ex_Hover.png');
                    background-repeat: no-repeat;
                    width: 22px;
                    height: 33px;
                }

        .cmd_MenuLeft_Home_active {
            background-image: url('../UI/img/GSTP_MenuLeft_Home_Hover.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

        .cmd_MenuLeft_Search {
            background-image: url('../UI/img/GSTP_MenuLeft_Search.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

            .cmd_MenuLeft_Search:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_Search_Hover.png');
                background-repeat: no-repeat;
                width: 37px;
                height: 34px;
                display: block;
            }

        .cmd_MenuLeft_Search_active {
            background-image: url('../UI/img/GSTP_MenuLeft_Search_Hover.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

        .cmd_MenuLeft_DanhGiaThamPhan {
            background-image: url('../UI/img/GSTP_MenuLeft_DanhGiaTP.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

            .cmd_MenuLeft_DanhGiaThamPhan:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_DanhGiaTP_Hover.png');
                background-repeat: no-repeat;
                width: 37px;
                height: 34px;
                display: block;
            }

        .cmd_MenuLeft_DanhGiaThamPhan_active {
            background-image: url('../UI/img/GSTP_MenuLeft_DanhGiaTP_Hover.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

        .cmd_MenuLeft_ThongKe {
            background-image: url('../UI/img/GSTP_MenuLeft_ThongKe.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

            .cmd_MenuLeft_ThongKe:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_ThongKe_Hover.png');
                background-repeat: no-repeat;
                width: 37px;
                height: 34px;
                display: block;
            }

        .cmd_MenuLeft_ThongKe_active {
            background-image: url('../UI/img/GSTP_MenuLeft_ThongKe_Hover.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

        .cmd_MenuLeft_HDSD {
            background-image: url('../UI/img/GSTP_MenuLeft_HuongDanSD.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

            .cmd_MenuLeft_HDSD:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_HuongDanSD_Hover.png');
                background-repeat: no-repeat;
                width: 37px;
                height: 34px;
                display: block;
            }

        .cmd_MenuLeft_HDSD_active {
            background-image: url('../UI/img/GSTP_MenuLeft_HuongDanSD_Hover.png');
            background-repeat: no-repeat;
            width: 37px;
            height: 34px;
            display: block;
        }

        .NoiDung_Head {
            height: 86px;
            background-color: #E6E6E6;
            margin: 5px;
        }

        .NoiDung_Footer {
            background-color: #F4DAAC;
            width: 100%;
            text-align: center;
            color: #666666;
            height: 40px;
            display: table;
        }

        .cmd_TraCuu {
            background-image: url('../UI/img/GSTP_tracuu.png');
            background-repeat: no-repeat;
            width: 180px;
            height: 26px;
            display: block;
            float: left;
            margin: 10px 13px 0px 15px;
        }

            .cmd_TraCuu:hover {
                background-image: url('../UI/img/GSTP_tracuu_Hover.png');
                background-repeat: no-repeat;
                width: 180px;
                height: 26px;
                display: block;
                float: left;
                margin: 10px 13px 0px 15px;
            }

        .cmd_DanhSach {
            background-image: url('../UI/img/GSTP_danhsach.png');
            background-repeat: no-repeat;
            width: 184px;
            height: 26px;
            display: block;
            float: left;
            margin-top: 10px;
        }

            .cmd_DanhSach:hover {
                background-image: url('../UI/img/GSTP_danhsach_Hover.png');
                background-repeat: no-repeat;
                width: 184px;
                height: 26px;
                display: block;
                float: left;
                margin-top: 10px;
            }

        .txtSearch {
            float: left;
            margin: 10px 0px 0px 15px;
            width: 370px;
        }

        .TenThamPhan {
            width: 247px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin: 10px 10px 8px 10px;
        }

        .lbl_Info {
            float: left;
            margin: 5px 3px 0px 5px;
        }

        .span_info {
            color: #cb6215;
            font-weight: bold;
            float: left;
            margin-top: 5px;
        }

        .TenChucDanh {
            width: 247px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-top: 10px;
            margin-right: 10px;
        }

        .TenToaAn {
            width: 268px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-top: 10px;
        }

        .QuyDinhBoNhiem {
            width: 787px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-left: 10px;
        }

        .MenuLeft_wap {
            /*position: relative;
            display: inline-block;*/
        }

            .MenuLeft_wap .MenuLeft_ex {
                top: 67px;
                left: 0px;
                visibility: hidden;
                width: 200px;
                background-color: #D40023;
                height: 1786px;
                /* Position the tooltip */
                position: absolute;
                z-index: 1000;
            }

            .MenuLeft_wap:hover .MenuLeft_ex {
                visibility: visible;
            }

        .MenuLeft_ex_Home {
            background-image: url('../UI/img/GSTP_MenuLeft_Home.png');
            background-repeat: no-repeat;
            width: 200px;
            height: 34px;
            background-color: #D40627;
            color: #FFFFFF;
            float: left;
        }

            .MenuLeft_ex_Home:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_Home_Hover.png');
                background-repeat: no-repeat;
                width: 200px;
                height: 34px;
                background-color: #F7D08C;
                color: #D40627;
                float: left;
            }

                .MenuLeft_ex_Home:hover .bottom_ex {
                    background-image: url('../UI/img/GSTP_Bottom_ex_Hover.png');
                    background-repeat: no-repeat;
                    width: 22px;
                    height: 33px;
                }

        .MenuLeft_ex_DGTP {
            background-image: url('../UI/img/GSTP_MenuLeft_DanhGiaTP.png');
            background-repeat: no-repeat;
            width: 200px;
            height: 34px;
            background-color: #D40627;
            color: #FFFFFF;
            float: left;
        }

            .MenuLeft_ex_DGTP:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_DanhGiaTP_Hover.png');
                background-repeat: no-repeat;
                width: 200px;
                height: 34px;
                background-color: #F7D08C;
                color: #D40627;
                float: left;
            }

                .MenuLeft_ex_DGTP:hover .bottom_ex {
                    background-image: url('../UI/img/GSTP_Bottom_ex_Hover.png');
                    background-repeat: no-repeat;
                    width: 22px;
                    height: 33px;
                }

        .MenuLeft_ex_TK {
            background-image: url('../UI/img/GSTP_MenuLeft_ThongKe.png');
            background-repeat: no-repeat;
            width: 200px;
            height: 34px;
            background-color: #D40627;
            color: #FFFFFF;
            float: left;
        }

            .MenuLeft_ex_TK:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_ThongKe_Hover.png');
                background-repeat: no-repeat;
                width: 200px;
                height: 34px;
                background-color: #F7D08C;
                color: #D40627;
                float: left;
            }

                .MenuLeft_ex_TK:hover .bottom_ex {
                    background-image: url('../UI/img/GSTP_Bottom_ex_Hover.png');
                    background-repeat: no-repeat;
                    width: 22px;
                    height: 33px;
                }
                .MenuLeft_ex_HDSD_menu {
           background-image: url(../UI/img/choice.png);
    background-repeat: no-repeat;
    width: 17px;
    height: 22px;
    /* background-color: #D40627; */
    color: #FFFFFF;
    float: left;
    margin-top: 15px;
        }

        .MenuLeft_ex_HDSD {
            background-image: url('../UI/img/GSTP_MenuLeft_HuongDanSD.png');
            background-repeat: no-repeat;
            width: 200px;
            height: 34px;
            background-color: #D40627;
            color: #FFFFFF;
            float: left;
        }

            .MenuLeft_ex_HDSD:hover {
                background-image: url('../UI/img/GSTP_MenuLeft_HuongDanSD_Hover.png');
                background-repeat: no-repeat;
                width: 200px;
                height: 34px;
                background-color: #F7D08C;
                color: #D40627;
                float: left;
            }

                .MenuLeft_ex_HDSD:hover .bottom_ex {
                    background-image: url('../UI/img/GSTP_Bottom_ex_Hover.png');
                    background-repeat: no-repeat;
                    width: 22px;
                    height: 33px;
                }

        .MenuLeft_ex_Default {
            width: 200px;
            background-color: #D40627;
            color: #F7D08C;
            float: left;
        }

            .MenuLeft_ex_Default:hover {
                width: 200px;
                background-color: #F7D08C;
                color: #D40627;
                float: left;
            }

        .bottom_ex {
            float: right;
            margin-right: 10px;
            background-image: url('../UI/img/GSTP_Bottom_ex.png');
            background-repeat: no-repeat;
            width: 22px;
            height: 33px;
        }

            .bottom_ex:hover {
                background-image: url('../UI/img/GSTP_Bottom_ex_Hover.png');
                background-repeat: no-repeat;
                width: 22px;
                height: 33px;
            }

        .Col_css_HS {
            width: 46px;
            text-align: right;
        }

        .Col_css_DS {
            width: 90px;
            text-align: right;
        }

        .header td {
            text-align: center;
        }

        .lblTitleTrang2 {
            font-size: 18px;
            font-weight: bold;
            margin-left: 10px;
            padding-top: 4px;
            float: left;
            text-transform: uppercase;
        }
    </style>
</head>
<body>
    <form id="Form1" runat="server">
        <div class="header_page" style="background: url('../UI/img/GSTP_bggscm.png'); height: 66px;">
            <div class="headertop">
                <div class="logo">
                    <div class="logo_text">
                        <asp:Literal ID="lstHethong" runat="server"></asp:Literal>
                    </div>
                </div>
                <div class="taikhoan">
                    <asp:LinkButton ID="LinkButton5" runat="server" ToolTip="Hướng dẫn sử dụng" CssClass="MenuLeft_ex_HDSD_menu" OnClick="cmd_MenuLeft_HDSD_Click" />
                    <asp:LinkButton ID="lbtBack" runat="server" ToolTip="Chọn phân hệ" CssClass="btnLogout" OnClick="lbtBack_Click" />
                    <div class="moduleinfo">
                        <div class="dropdown">
                            <a href="javascript:;">
                                <img src="/UI/img/iconPhanhe.png" /></a>
                            <div class="menu_child2">
                                <div class="arrow_up_border"></div>
                                <div class="arrow_up"></div>
                                <ul>
                                    <li runat="server" id="liGSTP">
                                        <asp:LinkButton ID="btnGSTP" runat="server" CssClass="btnMNGSTP" OnClick="btnGSTP_Click" />

                                    </li>
                                    <li runat="server" id="liQLA">
                                        <asp:LinkButton ID="btnQLA" runat="server" CssClass="btnMNQLA" OnClick="btnQLA_Click" />

                                    </li>
                                    <li runat="server" id="liGDT">
                                        <asp:LinkButton ID="btnGDT" runat="server" CssClass="btnMNGDT" OnClick="btnGDT_Click" />

                                    </li>
                                    <li runat="server" id="liTCCB">
                                        <asp:LinkButton ID="btnTDKT" runat="server" CssClass="btnMNTDKT" OnClick="btnTDKT_Click" />

                                    </li>
                                    <li runat="server" id="liTDKT">
                                        <asp:LinkButton ID="btnTCCB" runat="server" CssClass="btnMNTCCB" OnClick="btnTCCB_Click" />

                                    </li>
                                    <li runat="server" id="liQTHT">
                                        <asp:LinkButton ID="btnQTHT" runat="server" CssClass="btnMNQTHT" OnClick="btnQTHT_Click" />
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="userinfo">
                        <div class="dropdown">
                            <a href="javascript:;" class="dropbtn userinfo_ico">
                                <asp:Literal ID="lstUserName" runat="server"></asp:Literal></a>
                            <div class="menu_child">
                                <div class="arrow_up_border"></div>
                                <div class="arrow_up"></div>
                                <ul>
                                    <li>
                                        <asp:Literal ID="lstHoten" runat="server"></asp:Literal></li>
                                    <li class="singout">
                                        <asp:LinkButton ID="lkSignout" runat="server" OnClick="lkSignout_Click" Text="Đăng xuất"></asp:LinkButton>
                                    </li>
                                    <li class="changepass"><a href="/ChangePass.aspx">Đổi mật khẩu</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="lineHead"></div>
        </div>
        <div class="NoiDung">
            <table class="Table_Full_Width_No_Border_Spacing">
                <tr>
                    <td rowspan="2" style="vertical-align: top; width: 38px;">
                        <div class="MenuLeft_wap">
                            <div class="MenuLeft" id="MenuLeft" runat="server">
                                <asp:LinkButton ID="cmd_MenuLeft_Home" CssClass="cmd_MenuLeft_Home" runat="server" OnClick="cmd_MenuLeft_Home_Click"></asp:LinkButton>
                                <asp:LinkButton ID="cmd_MenuLeft_DanhGiaThamPhan" runat="server" CssClass="cmd_MenuLeft_DanhGiaThamPhan" OnClick="cmd_MenuLeft_DanhGiaThamPhan_Click"></asp:LinkButton>
                                <asp:LinkButton ID="cmd_MenuLeft_ThongKe" runat="server" CssClass="cmd_MenuLeft_ThongKe" OnClick="cmd_MenuLeft_ThongKe_Click" ToolTip="Báo cáo thống kê"></asp:LinkButton>
                                <%--<asp:LinkButton ID="cmd_MenuLeft_HDSD" runat="server" CssClass="cmd_MenuLeft_HDSD" OnClick="cmd_MenuLeft_HDSD_Click" ToolTip="Hướng dẫn sử dụng"></asp:LinkButton>--%>
                            </div>
                            <div class="MenuLeft_ex" id="MenuLeft_ex" runat="server">
                                <asp:LinkButton ID="LinkButton1" CssClass="MenuLeft_ex_Home" runat="server" OnClick="cmd_MenuLeft_Home_Click">
                                        <span style="float: left; margin-left: 50px; margin-top:10px">Trang chủ</span>
                                    <div class="bottom_ex"></div>
                                </asp:LinkButton>
                                <asp:LinkButton ID="LinkButton2" runat="server" CssClass="MenuLeft_ex_DGTP" OnClick="cmd_MenuLeft_DanhGiaThamPhan_Click">
                                        <span style="float: left; margin-left: 50px; margin-top: 10px;">Đánh giá thẩm phán</span>
                                    <div class="bottom_ex"></div>
                                </asp:LinkButton>
                                <asp:LinkButton ID="LinkButton3" runat="server" CssClass="MenuLeft_ex_TK" OnClick="cmd_MenuLeft_ThongKe_Click">
                                        <span style="float: left; margin-left: 50px; margin-top: 10px;">Báo cáo thống kê</span>
                                    <div class="bottom_ex"></div>
                                </asp:LinkButton>
                                <%--<asp:LinkButton ID="LinkButton4" runat="server" CssClass="MenuLeft_ex_HDSD" OnClick="cmd_MenuLeft_HDSD_Click">
                                        <span style="float: left; margin-left: 50px; margin-top: 10px;">Hướng dẫn sử dụng</span>
                                    <div class="bottom_ex"></div>
                                </asp:LinkButton>--%>
                            </div>
                        </div>
                    </td>
                    <td style="vertical-align: top;">
                        <div class="NoiDung_Head">
                            <div id="div_Search" style="border-right: 2px solid #DFDFDF; height: 86px; width: 402px; float: left;">
                                <asp:TextBox ID="txtSearch" runat="server" placeholder="Tên thẩm phán" CssClass="user txtSearch"></asp:TextBox>
                                <asp:LinkButton ID="cmd_TraCuu" runat="server" CssClass="cmd_TraCuu" OnClick="cmd_TraCuu_Click"></asp:LinkButton>
                                <asp:LinkButton ID="cmd_DanhSach" runat="server" CssClass="cmd_DanhSach" OnClick="cmd_DanhSach_Click"></asp:LinkButton>
                            </div>
                            <div id="div_Info" style="height: 86px; width: 811px; float: left;">
                                <div class="TenThamPhan">
                                    <div class="lbl_Info">Tên thẩm phán:</div>
                                    <span class="span_info">
                                        <asp:Literal ID="ltrTenTP" runat="server" Text=""></asp:Literal></span>
                                </div>
                                <div class="TenChucDanh">
                                    <div class="lbl_Info">Chức danh:</div>
                                    <span class="span_info">
                                        <asp:Literal ID="ltrChucDanh" runat="server" Text=""></asp:Literal></span>
                                </div>
                                <div class="TenToaAn">
                                    <div class="lbl_Info">Tòa án:</div>
                                    <span class="span_info">
                                        <asp:Literal ID="ltrToaAn" runat="server" Text=""></asp:Literal></span>
                                </div>
                                <div class="QuyDinhBoNhiem">
                                    <div class="lbl_Info">Quyết định bổ nhiệm:</div>
                                    <span class="span_info">
                                        <asp:Literal ID="ltrQuyetDinhBoNhiem" runat="server" Text=""></asp:Literal></span>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td id="td_NoiDung" runat="server" style="vertical-align: top;">
                        <div style="background-color: #f0a400; color: #fff; width: 1216px; height: 28px; margin-left: 5px; border-radius: 5px; text-align: center; margin-bottom: 10px;">
                            <asp:Label ID="lblTitleTrang2" runat="server" CssClass="lblTitleTrang2"></asp:Label>
                        </div>
                        <asp:Panel ID="panHS" runat="server">
                            <span class="Title_Group_Box_GiaiDoan">Hình sự sơ thẩm</span>
                            <table class="table2" style="width: 1216px; margin-left: 5px; margin-bottom: 15px;">
                                <tr class="header">
                                    <td rowspan="3">Cấp Tòa án</td>
                                    <td colspan="2" rowspan="2">TỔNG THỤ LÝ</td>
                                    <td colspan="12">GIẢI QUYẾT ÁN</td>
                                    <td colspan="2">ÁN HỦY, SỬA</td>
                                    <td colspan="2" rowspan="2">CÒN LẠI</td>
                                    <td colspan="2" rowspan="2">ÁN QUÁ HẠN LUẬT ĐỊNH CHƯA GIẢI QUYẾT</td>
                                </tr>
                                <tr class="header">
                                    <td colspan="2">Chuyển hồ sơ vụ án</td>
                                    <td colspan="2">Đình chỉ</td>
                                    <td colspan="2">Trả hồ sơ VKS</td>
                                    <td colspan="2">Xét xử</td>
                                    <td colspan="2">TỔNG SỐ GQ</td>
                                    <td colspan="2">TỶ LỆ GQ</td>
                                    <td>ÁN BỊ HỦY</td>
                                    <td>ÁN BỊ SỬA</td>
                                </tr>
                                <tr class="header">
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Vụ</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                    <td>Vụ</td>
                                    <td>Bị cáo</td>
                                </tr>
                                <asp:Repeater ID="rpt_HinhSu" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Eval("V_CAPTOA") %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_TONGTHULY_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_TONGTHULY_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CHUYENHOSO_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CHUYENHOSO_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_DINHCHI_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_DINHCHI_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TRAHOSOVKS_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TRAHOSOVKS_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_XETXU_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_XETXU_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TONGGQ_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TONGGQ_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TYLEGQ_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TYLEGQ_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_CONLAI_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_CONLAI_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_VU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_VU_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_HS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_BICAO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_BICAO_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panDS" runat="server">
                            <span class="Title_Group_Box_GiaiDoan">Dân sự sơ thẩm</span>
                            <table class="table2" style="width: 1216px; margin-left: 5px; margin-bottom: 15px;">
                                <tr class="header">
                                    <td rowspan="2">Cấp Tòa án</td>
                                    <td rowspan="2">TỔNG THỤ LÝ</td>
                                    <td colspan="6">GIẢI QUYẾT ÁN</td>
                                    <td colspan="2">ÁN HỦY, SỬA</td>
                                    <td rowspan="2">TỔNG SỐ VỤ ÁN CÒN LẠI</td>
                                    <td rowspan="2">ÁN QUÁ HẠN LUẬT ĐỊNH CHƯA GIẢI QUYẾT</td>
                                </tr>
                                <tr class="header">
                                    <td>Chuyển hồ sơ vụ án</td>
                                    <td>Đình chỉ</td>
                                    <td>Công nhận thỏa thuận</td>
                                    <td>Xét xử</td>
                                    <td>TỔNG SỐ GQ</td>
                                    <td>TỶ LỆ GQ</td>
                                    <td>ÁN BỊ HỦY</td>
                                    <td>ÁN BỊ SỬA</td>
                                </tr>
                                <asp:Repeater ID="rpt_DanSu" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Eval("V_CAPTOA") %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_TONGTHULY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CHUYENHOSO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_DINHCHI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CONGNHANTHOATHUAN")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_XETXU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TONGGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TYLEGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_CONLAI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panHN" runat="server">
                            <span class="Title_Group_Box_GiaiDoan">Hôn nhân gia đình sơ thẩm</span>
                            <table class="table2" style="width: 1216px; margin-left: 5px; margin-bottom: 15px;">
                                <tr class="header">
                                    <td rowspan="2">Cấp Tòa án</td>
                                    <td rowspan="2">TỔNG THỤ LÝ</td>
                                    <td colspan="6">GIẢI QUYẾT ÁN</td>
                                    <td colspan="2">ÁN HỦY, SỬA</td>
                                    <td rowspan="2">TỔNG SỐ VỤ ÁN CÒN LẠI</td>
                                    <td rowspan="2">ÁN QUÁ HẠN LUẬT ĐỊNH CHƯA GIẢI QUYẾT</td>
                                </tr>
                                <tr class="header">
                                    <td>Chuyển hồ sơ vụ án</td>
                                    <td>Đình chỉ</td>
                                    <td>Công nhận thỏa thuận</td>
                                    <td>Xét xử</td>
                                    <td>TỔNG SỐ GQ</td>
                                    <td>TỶ LỆ GQ</td>
                                    <td>ÁN BỊ HỦY</td>
                                    <td>ÁN BỊ SỬA</td>
                                </tr>
                                <asp:Repeater ID="rpt_HNGD" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Eval("V_CAPTOA") %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_TONGTHULY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CHUYENHOSO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_DINHCHI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CONGNHANTHOATHUAN")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_XETXU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TONGGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TYLEGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_CONLAI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panKT" runat="server">
                            <span class="Title_Group_Box_GiaiDoan">Kinh doanh thương mại sơ thẩm</span>
                            <table class="table2" style="width: 1216px; margin-left: 5px; margin-bottom: 15px;">
                                <tr class="header">
                                    <td rowspan="2">Cấp Tòa án</td>
                                    <td rowspan="2">TỔNG THỤ LÝ</td>
                                    <td colspan="6">GIẢI QUYẾT ÁN</td>
                                    <td colspan="2">ÁN HỦY, SỬA</td>
                                    <td rowspan="2">TỔNG SỐ VỤ ÁN CÒN LẠI</td>
                                    <td rowspan="2">ÁN QUÁ HẠN LUẬT ĐỊNH CHƯA GIẢI QUYẾT</td>
                                </tr>
                                <tr class="header">
                                    <td>Chuyển hồ sơ vụ án</td>
                                    <td>Đình chỉ</td>
                                    <td>Công nhận thỏa thuận</td>
                                    <td>Xét xử</td>
                                    <td>TỔNG SỐ GQ</td>
                                    <td>TỶ LỆ GQ</td>
                                    <td>ÁN BỊ HỦY</td>
                                    <td>ÁN BỊ SỬA</td>
                                </tr>
                                <asp:Repeater ID="rpt_KinhTe" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Eval("V_CAPTOA") %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_TONGTHULY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CHUYENHOSO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_DINHCHI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CONGNHANTHOATHUAN")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_XETXU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TONGGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TYLEGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_CONLAI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panHC" runat="server">
                            <span class="Title_Group_Box_GiaiDoan">Hành chính sơ thẩm</span>
                            <table class="table2" style="width: 1216px; margin-left: 5px; margin-bottom: 15px;">
                                <tr class="header">
                                    <td rowspan="2">Cấp Tòa án</td>
                                    <td rowspan="2">TỔNG THỤ LÝ</td>
                                    <td colspan="6">GIẢI QUYẾT ÁN</td>
                                    <td colspan="2">ÁN HỦY, SỬA</td>
                                    <td rowspan="2">TỔNG SỐ VỤ ÁN CÒN LẠI</td>
                                    <td rowspan="2">ÁN QUÁ HẠN LUẬT ĐỊNH CHƯA GIẢI QUYẾT</td>
                                </tr>
                                <tr class="header">
                                    <td>Chuyển hồ sơ vụ án</td>
                                    <td>Đình chỉ</td>
                                    <td>Công nhận thỏa thuận</td>
                                    <td>Xét xử</td>
                                    <td>TỔNG SỐ GQ</td>
                                    <td>TỶ LỆ GQ</td>
                                    <td>ÁN BỊ HỦY</td>
                                    <td>ÁN BỊ SỬA</td>
                                </tr>
                                <asp:Repeater ID="rpt_HanhChinh" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Eval("V_CAPTOA") %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_TONGTHULY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CHUYENHOSO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_DINHCHI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CONGNHANTHOATHUAN")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_XETXU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TONGGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TYLEGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_CONLAI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="panLD" runat="server">
                            <span class="Title_Group_Box_GiaiDoan">Lao động sơ thẩm</span>
                            <table class="table2" style="width: 1216px; margin-left: 5px; margin-bottom: 15px;">
                                <tr class="header">
                                    <td rowspan="2">Cấp Tòa án</td>
                                    <td rowspan="2">TỔNG THỤ LÝ</td>
                                    <td colspan="6">GIẢI QUYẾT ÁN</td>
                                    <td colspan="2">ÁN HỦY, SỬA</td>
                                    <td rowspan="2">TỔNG SỐ VỤ ÁN CÒN LẠI</td>
                                    <td rowspan="2">ÁN QUÁ HẠN LUẬT ĐỊNH CHƯA GIẢI QUYẾT</td>
                                </tr>
                                <tr class="header">
                                    <td>Chuyển hồ sơ vụ án</td>
                                    <td>Đình chỉ</td>
                                    <td>Công nhận thỏa thuận</td>
                                    <td>Xét xử</td>
                                    <td>TỔNG SỐ GQ</td>
                                    <td>TỶ LỆ GQ</td>
                                    <td>ÁN BỊ HỦY</td>
                                    <td>ÁN BỊ SỬA</td>
                                </tr>
                                <asp:Repeater ID="rpt_LaoDong" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Eval("V_CAPTOA") %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_TONGTHULY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CHUYENHOSO")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_DINHCHI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_CONGNHANTHOATHUAN")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_XETXU")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TONGGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_GQ_TYLEGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANHUY_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_ANSUA_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_CONLAI")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span>
                                            </td>
                                            <td class="Col_css_DS">
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) %></span><br />
                                                <span style='<%#Eval("V_CAPTOA")+""=="Cộng"? "font-weight: bold; color: #db212d;": "" %>'><%#Convert.ToDecimal(Eval("V_QUAHAN_CHUAGQ_TYLE")).ToString("#,0.##", new System.Globalization.CultureInfo("vi-VN")) + "%" %></span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="vertical-align: top;">
                        <div class="NoiDung_Footer">
                            <div style="display: table-cell; vertical-align: middle; font-size: 15px;">
                                &copy; Bản quyền thuộc về Tòa án nhân dân tối cao.
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>