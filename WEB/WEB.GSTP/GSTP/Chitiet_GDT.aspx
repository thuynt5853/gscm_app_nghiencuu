<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chitiet_GDT.aspx.cs" Inherits="WEB.GSTP.GSTP.Chitiet_GDT" %>

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

        .MenuLeft {
            background-color: #D40023;
            width: 37px;
            height: 1192px;
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

        .QuyetDinhBoNhiem {
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
                height: 1192px;
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

        .Col_css {
            width: 54px;
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
                                <div class="QuyetDinhBoNhiem">
                                    <div class="lbl_Info">Quyết định bổ nhiệm:</div>
                                    <span class="span_info">
                                        <asp:Literal ID="ltrQuyetDinhBoNhiem" runat="server" Text=""></asp:Literal></span>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top;" id="td_NoiDung" runat="server">
                        <div style="background-color: #f0a400; color: #fff; width: 1216px; height: 28px; margin-left: 5px; border-radius: 5px; text-align: center; margin-bottom: 10px;">
                            <asp:Label ID="lblTitleTrang2" runat="server" CssClass="lblTitleTrang2"></asp:Label>
                        </div>
                        <table class="table2" style="width: 1216px; margin-left: 5px; margin-bottom: 15px;">
                            <tr class="header">
                                <td rowspan="2" style="width: 153px;"></td>
                                <td rowspan="2">Tòa án giải quyết</td>
                                <td colspan="5">Tình hình thụ lý, giải quyết đơn đề nghị GĐT,TTT </td>
                                <td colspan="6">Giải quyết, xét xử GĐT,TT</td>
                                <td rowspan="2">Rút kháng nghị</td>
                                <td colspan="2">Phân tích các vụ án đã giải quyết</td>
                            </tr>
                            <tr class="header">
                                <td>Đơn trùng</td>
                                <td>Đơn mới</td>
                                <td>Đã giải quyết xong</td>
                                <td>Chưa giải quyết xong</td>
                                <td>Thời hiệu KN còn dưới 3 tháng</td>
                                <td>TS vụ án Viện trưởng KN</td>
                                <td>TS vụ án Chánh án KN</td>
                                <td>Đã xét xử</td>
                                <td>Tỷ lệ (%)</td>
                                <td>Còn lại</td>
                                <td>Quá hạn luật định</td>
                                <td>Không chấp nhận kháng nghị của Viện trưởng</td>
                                <td>Huỷ bản án, quyết định</td>
                            </tr>
                            <tr id="tr_Vu1" runat="server" visible="false">
                                <td style="font-weight: bold;">Vụ GĐKT I</td>
                                <td>Hình sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu1_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_Vu2_Row_Empty" runat="server" visible="false">
                                <td colspan="16"></td>
                            </tr>
                            <tr id="tr_Vu2" runat="server" visible="false">
                                <td rowspan="3" style="font-weight: bold;">Vụ GĐKT II</td>
                                <td>Dân sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_DanSu_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_Vu2_KT" runat="server" visible="false">
                                <td>Kinh doanh thương mại</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_KinhTe_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_Vu2_Tong" runat="server" visible="false" style="font-weight: bold; color: #db212d;">
                                <td>Tổng cộng</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu2_Tong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_Vu3_Row_Empty" runat="server" visible="false">
                                <td colspan="16"></td>
                            </tr>
                            <tr id="tr_Vu3" runat="server" visible="false">
                                <td rowspan="4" style="font-weight: bold;">Vụ GĐKT III</td>
                                <td>Hôn nhân và Gia đình</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HNGD_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_Vu3_HC" runat="server" visible="false">
                                <td>Hành chính</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_HanhChinh_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_Vu3_LD" runat="server" visible="false">
                                <td>Lao động</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_LaoDong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_Vu3_Tong" runat="server" visible="false" style="font-weight: bold; color: #db212d;">
                                <td>Tổng cộng</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_Vu3_Tong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HaNoi_Row_Empty" runat="server" visible="false">
                                <td colspan="16"></td>
                            </tr>
                            <tr id="tr_CC_HaNoi" runat="server" visible="false">
                                <td rowspan="7" style="font-weight: bold;">TAND CC tại Hà Nội</td>
                                <td>Hình sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HinhSu_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HaNoi_DS" runat="server" visible="false">
                                <td>Dân sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_DanSu_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HaNoi_KT" runat="server" visible="false">
                                <td>Kinh doanh thương mại</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_KinhTe_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HaNoi_HN" runat="server" visible="false">
                                <td>Hôn nhân và Gia đình</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HNGD_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HaNoi_HC" runat="server" visible="false">
                                <td>Hành chính</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_HanhChinh_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HaNoi_LD" runat="server" visible="false">
                                <td>Lao động</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_LaoDong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HaNoi_Tong" runat="server" visible="false" style="font-weight: bold; color: #db212d;">
                                <td>Tổng cộng</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHaNoi_Tong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_DaNang_Row_Empty" runat="server" visible="false">
                                <td colspan="16"></td>
                            </tr>
                            <tr id="tr_CC_DaNang" runat="server" visible="false">
                                <td rowspan="7" style="font-weight: bold;">TAND CC tại Đà Nẵng</td>
                                <td>Hình sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HinhSu_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_DaNang_DS" runat="server" visible="false">
                                <td>Dân sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_DanSu_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_DaNang_KT" runat="server" visible="false">
                                <td>Kinh doanh thương mại</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_KinhTe_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_DaNang_HN" runat="server" visible="false">
                                <td>Hôn nhân và Gia đình</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HNGD_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_DaNang_HC" runat="server" visible="false">
                                <td>Hành chính</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_HanhChinh_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_DaNang_LD" runat="server" visible="false">
                                <td>Lao động</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_LaoDong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_DaNang_Tong" runat="server" visible="false" style="font-weight: bold; color: #db212d;">
                                <td>Tổng cộng</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCDaNang_Tong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HCM_Row_Empty" runat="server" visible="false">
                                <td colspan="16"></td>
                            </tr>
                            <tr id="tr_CC_HCM" runat="server" visible="false">
                                <td rowspan="7" style="font-weight: bold;">TAND CC tại TP Hồ Chí Minh</td>
                                <td>Hình sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HinhSu_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HCM_DS" runat="server" visible="false">
                                <td>Dân sự</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_DanSu_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HCM_KT" runat="server" visible="false">
                                <td>Kinh doanh thương mại</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_KinhTe_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HCM_HN" runat="server" visible="false">
                                <td>Hôn nhân và Gia đình</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HNGD_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HCM_HC" runat="server" visible="false">
                                <td>Hành chính</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_HanhChinh_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HCM_LD" runat="server" visible="false">
                                <td>Lao động</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_LaoDong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                            <tr id="tr_CC_HCM_Tong" runat="server" visible="false" style="font-weight: bold; color: #db212d;">
                                <td>Tổng cộng</td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_DonTrung" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_DonMoi" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_DaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_ChuaGiaiQuyet" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_AnThoiHieu" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_VienTruongKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_ChanhAnKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_DaXetXuGDT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_TyLe" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_ConLai" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_QuaHanLuatDinh" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_RutKN" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_KoChapNhanKNCuaVT" runat="server" Text="0"></asp:Literal></td>
                                <td class="Col_css">
                                    <asp:Literal ID="ltr_CCHCM_Tong_HuyBanAn" runat="server" Text="0"></asp:Literal></td>
                            </tr>
                        </table>
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
    </form>
</body>
</html>