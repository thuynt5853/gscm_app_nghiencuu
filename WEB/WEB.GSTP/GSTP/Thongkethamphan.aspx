<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Thongkethamphan.aspx.cs" Inherits="WEB.GSTP.GSTP.Thongkethamphan" %>

<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraCharts.v22.2.Web, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts.Web.Designer" TagPrefix="dxchartdesigner" %>
<%@ Register Assembly="DevExpress.XtraCharts.v22.2.Web, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraReports.v22.2.Web.WebForms, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraCharts.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts" TagPrefix="dx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <title>HỆ THỐNG GIÁM SÁT THẨM PHÁN</title>
    <link href="../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../UI/css/style.css" rel="stylesheet" />
    <style type="text/css">
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
            height: 1108px;
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

        .NoiDung_Head {
            height: 86px;
            background-color: #E6E6E6;
            margin: 15px 15px 10px 15px;
        }

        .NoiDung_Footer {
            background-color: #F4DAAC;
            width: 100%;
            text-align: center;
            color: #666666;
            height: 52px;
            display: table;
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
            width: 243px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-top: 10px;
            margin-right: 10px;
        }

        .TenToaAn {
            width: 247px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-top: 10px;
        }

        .QuyDinhBoNhiem {
            width: 761px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-left: 10px;
        }

        .NoiDung_Chinh {
            background-color: #E6E6E6;
            /*height: 985px;*/
            margin-left: 15px;
            margin-right: 15px;
            margin-bottom: 10px;
        }

        .Icon_Title_Group_Box {
            float: left;
            width: 21px;
            height: 20px;
            margin-left: 20px;
            margin-top: 13px;
            margin-right: 15px;
        }

        .div_Slide_Chart_TP {
            float: left;
            width: 97%;
            height: 200px;
            margin: 15px;
            background-color: #FFFFFF;
            border-radius: 20px;
            box-shadow: 3px 3px 3px #BEBEBD;
            -moz-box-shadow: 3px 3px 3px #BEBEBD;
            -webkit-box-shadow: 3px 3px 3px #BEBEBD;
        }

        .div_wap_chart_bar_thamphan {
            width: 98%;
            height: 573px;
            background-color: #FFFFFF;
            border-radius: 20px;
            margin: 0px 15px 15px 15px;
            box-shadow: 3px 3px 3px #BEBEBD;
            -moz-box-shadow: 3px 3px 3px #BEBEBD;
            -webkit-box-shadow: 3px 3px 3px #BEBEBD;
        }

        .div_part_tyle {
            width: 385px;
            height: 128px;
            background-color: #FFFFFF;
            float: right;
            margin-right: 20px;
            margin-bottom: 20px;
            border-radius: 20px;
            box-shadow: 3px 3px 3px #BEBEBD;
            -moz-box-shadow: 3px 3px 3px #BEBEBD;
            -webkit-box-shadow: 3px 3px 3px #BEBEBD;
        }

        .div_part_tyle_left {
            background-color: #FC5465;
            width: 57%;
            height: 100%;
            float: left;
            border-top-left-radius: 20px;
            border-bottom-left-radius: 20px;
            box-shadow: 2px 2px 2px #BEBEBD;
            -moz-box-shadow: 2px 2px 2px #BEBEBD;
            -webkit-box-shadow: 2px 2px 2px #BEBEBD;
        }

            .div_part_tyle_left:hover {
                background-color: #E4393C;
            }

            .div_part_tyle_left img {
                margin: 30px 0px 0px 75px;
                float: left;
            }

        .div_part_tyle_left_text {
            color: #FFFFFF;
            text-transform: uppercase;
            width: 100%;
            float: left;
            margin: 15px 0px 0px 20px;
            font-weight: bold;
            font-size: 15px;
        }

        .tangcaonhat_name {
            color: #C8202F;
            font-size: 22px;
            float: left;
            margin-left: 25px;
            margin-top: 22px;
            margin-bottom: 8px;
            width: 35%;
        }

            .tangcaonhat_name::first-letter {
                text-transform: uppercase;
            }

        .tangcaonhat_per {
            color: #333333;
            float: left;
            font-size: 20px;
            width: 35%;
            margin-left: 25px;
        }

        .div_TP_ToanNganh {
            width: 550px;
            height: 440px;
            background-color: #FFFFFF;
            margin: 0px 15px 15px 15px;
            border-radius: 20px;
            box-shadow: 3px 3px 3px #BEBEBD;
            -moz-box-shadow: 3px 3px 3px #BEBEBD;
            -webkit-box-shadow: 3px 3px 3px #BEBEBD;
        }

        .div_DS_TP {
            width: 597px;
            height: 440px;
            background-color: #FFFFFF;
            border-radius: 20px;
            box-shadow: 3px 3px 3px #BEBEBD;
            -moz-box-shadow: 3px 3px 3px #BEBEBD;
            -webkit-box-shadow: 3px 3px 3px #BEBEBD;
        }

        .dgList_ThamPhan_DonVi {
            float: left;
            margin-top: 27px;
            margin-left: 10px;
        }
        .table2 td{
            line-height: 23px !important;
        }
        /*---------*/

        .showSlide {
            display: none;
            float: left;
        }

        .slidercontainer {
            width: 1109px;
            position: relative;
            margin: auto;
        }

        .Legend_Num1 {
            font-size: 20px;
            font-weight: bold;
            position: relative;
            top: -107px;
            z-index: 1000;
            left: 83px;
        }

        .Legend_Per1 {
            color: #333;
            font-size: 13px;
            position: relative;
            top: -108px;
            z-index: 1000;
            left: 80px;
        }

        .Legend_Num2 {
            font-size: 20px;
            font-weight: bold;
            position: relative;
            top: -107px;
            z-index: 1000;
            left: 78px;
        }

        .Legend_Per2 {
            color: #333;
            font-size: 13px;
            position: relative;
            top: -108px;
            z-index: 1000;
            left: 80px;
        }

        .Legend_Num3 {
            font-size: 20px;
            font-weight: bold;
            position: relative;
            top: -107px;
            z-index: 1000;
            left: 73px;
        }

        .Legend_Per3 {
            color: #333;
            font-size: 13px;
            position: relative;
            top: -108px;
            z-index: 1000;
            left: 72px;
        }

        .Legend_Num4 {
            font-size: 20px;
            font-weight: bold;
            position: relative;
            top: -107px;
            z-index: 1000;
            left: 67px;
        }

        .Legend_Per4 {
            color: #333;
            font-size: 13px;
            position: relative;
            top: -108px;
            z-index: 1000;
            left: 68px;
        }

        .Legend_Num5 {
            font-size: 20px;
            font-weight: bold;
            position: relative;
            top: -107px;
            z-index: 1000;
            left: 61px;
        }

        .Legend_Per5 {
            color: #333;
            font-size: 13px;
            position: relative;
            top: -108px;
            z-index: 1000;
            left: 65px;
        }

        .Legend_Num6 {
            font-size: 17px;
            font-weight: bold;
            position: relative;
            top: -107px;
            z-index: 1000;
            left: 60px;
        }

        .Legend_Per6 {
            color: #333;
            font-size: 13px;
            position: relative;
            top: -108px;
            z-index: 1000;
            left: 67px;
        }

        .showSlide_part_title {
            position: relative;
            top: -38px;
            text-align: center;
            z-index: 1000;
            font-weight: bold;
        }

        .WebChart_ThamPhan {
            margin: 0px auto;
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header" style="background: url('../UI/img/GSTP_bggscm.png'); height: 66px; top: 0px; left: 0px;">
            <div class="headertop">
                <div class="logo">
                    <div class="logo_text">
                        <asp:Literal ID="lstHethong" runat="server"></asp:Literal>
                    </div>
                </div>
                <div class="taikhoan">
                    <asp:LinkButton ID="lbtChonPhanHe" runat="server" ToolTip="Chọn phân hệ" CssClass="btnLogout" OnClick="lbtChonPhanHe_Click" />
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
        <div id="NoiDung">
            <table class="Table_Full_Width_No_Border_Spacing">
                <tr>
                    <td rowspan="2" style="vertical-align: top;">
                        <div class="MenuLeft">
                            <asp:LinkButton ID="cmd_MenuLeft_Home" CssClass="cmd_MenuLeft_Home" runat="server" OnClick="cmd_MenuLeft_Home_Click" ToolTip="Trang chủ"></asp:LinkButton>
                            <asp:LinkButton ID="cmd_MenuLeft_DanhGiaThamPhan" runat="server" CssClass="cmd_MenuLeft_DanhGiaThamPhan" OnClick="cmd_MenuLeft_DanhGiaThamPhan_Click" ToolTip="Đánh giá thẩm phán"></asp:LinkButton>
                            <asp:LinkButton ID="cmd_MenuLeft_ThongKe" runat="server" CssClass="cmd_MenuLeft_ThongKe" OnClick="cmd_MenuLeft_ThongKe_Click" ToolTip="Báo cáo thống kê"></asp:LinkButton>
                            <asp:LinkButton ID="cmd_MenuLeft_HDSD" runat="server" CssClass="cmd_MenuLeft_HDSD" OnClick="cmd_MenuLeft_HDSD_Click" ToolTip="Hướng dẫn sử dụng"></asp:LinkButton>
                        </div>
                    </td>
                    <td colspan="2" style="vertical-align: top;">
                        <div class="NoiDung_Head">
                            <div id="div_Search" style="border-right: 2px solid #DFDFDF; height: 86px; width: 402px; float: left;">
                                <asp:TextBox ID="txtSearch" runat="server" placeholder="Tên thẩm phán" CssClass="user txtSearch"></asp:TextBox>
                                <asp:LinkButton ID="cmd_TraCuu" runat="server" CssClass="cmd_TraCuu" OnClick="cmd_TraCuu_Click"></asp:LinkButton>
                                <asp:LinkButton ID="cmd_DanhSach" runat="server" CssClass="cmd_DanhSach" OnClick="cmd_DanhSach_Click"></asp:LinkButton>
                            </div>
                            <div id="div_Info" style="height: 86px; width: 776px; float: left;">
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
                    <td colspan="2">
                        <div class="NoiDung_Chinh" style="background-color: #F2F2F2;">
                            <table class="Table_Full_Width_No_Border_Spacing">
                                <tr>
                                    <td colspan="4">
                                        <div style="float: left; width: 100%">
                                            <div style="float: left;">
                                                <img class="Icon_Title_Group_Box" alt="" src="../UI/img/GSTP_thongke.png" />
                                            </div>
                                            <span style="float: left; color: #666666; text-transform: uppercase; font-size: 20px; font-weight: bold; margin-top: 13px;">thống kê thẩm phán</span>
                                            <div style="float: right; color: #666666; font-size: 18px; margin-right: 70px; margin-top: 13px;">
                                                Số liệu:&nbsp;<span style="color: #E4393C; font-weight: bold; font-size: 18px;"><asp:Literal ID="ltrSoLieu" runat="server" Text=""></asp:Literal></span>
                                            </div>
                                        </div>
                                        <div class="div_Slide_Chart_TP">
                                            <div class="slidercontainer">
                                                <img style="float: left; margin-top: 75px;" src="../UI/img/GSTP_Slide_prev.png" onclick="nextSlide(-1)" />
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_DangCongTac" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_dangct_num" runat="server" style="color: #FE4F33;"></div>
                                                    <div id="div_tp_dangct_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #FE4F33; font-size: 14px;">ĐANG CÔNG TÁC</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_BoNhiemMoi" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_bonhiemmoi_num" runat="server" style="color: #54F2FC;"></div>
                                                    <div id="div_tp_bonhiemmoi_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #54F2FC; font-size: 14px;">BỔ NHIỆM MỚI</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_SapHetNhiemKy" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_saphetnhiemky_num" runat="server" style="color: #F5AE28;"></div>
                                                    <div id="div_tp_saphetnhiemky_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #F5AE28; font-size: 14px;">SẮP HẾT NHIỆM KỲ</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_DungXetXu" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_Dungxetxu_num" runat="server" style="color: #40488B;"></div>
                                                    <div id="div_tp_Dungxetxu_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #40488B; font-size: 14px;">BỊ DỪNG XÉT XỬ</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_KhieuNaiToCao" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_khieunaitocao_num" runat="server" style="color: #7537AC;"></div>
                                                    <div id="div_tp_khieunaitocao_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #7537AC; font-size: 14px;">KHIẾU NẠI, TỐ CÁO</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_BPTT" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_bptt_num" runat="server" style="color: #CCCC66;"></div>
                                                    <div id="div_tp_bptt_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #CCCC66; font-size: 14px;">CÓ ÁP DỤNG BPTT</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_Huy" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_huy_num" runat="server" style="color: #7C6650;"></div>
                                                    <div id="div_tp_huy_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #7C6650; font-size: 14px;">CÓ ÁN HỦY</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_Sua" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_sua_num" runat="server" style="color: #FC5465;"></div>
                                                    <div id="div_tp_sua_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #FC5465; font-size: 14px;">CÓ ÁN SỬA</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_QuaHan" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_quahan_num" runat="server" style="color: #027B76;"></div>
                                                    <div id="div_tp_quahan_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #027B76; font-size: 14px;">CÓ ÁN QUÁ HẠN</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_Treo" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="False" ShowValueLabels="False" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_treo_num" runat="server" style="color: #FA8526;"></div>
                                                    <div id="div_tp_treo_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #FA8526; font-size: 14px;">CÓ ÁN TREO</span></div>
                                                </div>
                                                <div class="showSlide">
                                                    <dx:WebChartControl ID="webchart_TP_TDC" runat="server" Height="175px" Width="175px" AutoLayout="True" ViewStateMode="Enabled" CrosshairEnabled="True" ToolTipEnabled="False">
                                                        <BorderOptions Visibility="False" />
                                                        <SeriesSerializable>
                                                            <dx:Series CrosshairLabelVisibility="False" LabelsVisibility="False" Name="Series 1">
                                                                <ViewSerializable>
                                                                    <dx:DoughnutSeriesView>
                                                                    </dx:DoughnutSeriesView>
                                                                </ViewSerializable>
                                                                <LabelSerializable>
                                                                    <dx:DoughnutSeriesLabel LineVisibility="True" Position="Inside">
                                                                    </dx:DoughnutSeriesLabel>
                                                                </LabelSerializable>
                                                            </dx:Series>
                                                        </SeriesSerializable>
                                                        <CrosshairOptions ShowArgumentLabels="True" ShowValueLabels="True" ShowValueLine="True">
                                                        </CrosshairOptions>
                                                    </dx:WebChartControl>
                                                    <div id="div_tp_tdc_num" runat="server" style="color: #996666;"></div>
                                                    <div id="div_tp_tdc_per" runat="server"></div>
                                                    <div class="showSlide_part_title"><span style="color: #996666; font-size: 14px;">CÓ ÁN TẠM ĐÌNH CHỈ</span></div>
                                                </div>
                                                <img style="float: left; margin-top: 75px;" src="../UI/img/GSTP_Slide_next.png" onclick="nextSlide(1)" />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" rowspan="4" style="vertical-align: top;">
                                        <div class="div_wap_chart_bar_thamphan">
                                            <dx:WebChartControl ID="WebChart_ThamPhan" runat="server" Width="700px" Height="530px" CssClass="WebChart_ThamPhan" CrosshairEnabled="True" PaletteName="ThongkeTP_3Nam_3TieuChi">
                                                <BorderOptions Visibility="False" />
                                                <DiagramSerializable>
                                                    <dx:XYDiagram>
                                                        <AxisX VisibleInPanesSerializable="-1"></AxisX>

                                                        <AxisY VisibleInPanesSerializable="-1"></AxisY>
                                                    </dx:XYDiagram>
                                                </DiagramSerializable>

                                                <Legend Name="Default Legend" AlignmentHorizontal="Center" AlignmentVertical="BottomOutside" Direction="LeftToRight" Visibility="True" BackColor="White" TextColor="Black">
                                                    <Border Visibility="False" />
                                                </Legend>
                                                <SeriesSerializable>
                                                    <dx:Series ArgumentScaleType="Qualitative" LabelsVisibility="True" Name="Đang công tác" LegendName="Default Legend">
                                                        <Points></Points>
                                                        <ViewSerializable>
                                                            <dx:SideBySideBarSeriesView Color="228, 57, 60">
                                                            </dx:SideBySideBarSeriesView>
                                                        </ViewSerializable>
                                                        <LabelSerializable>
                                                            <dx:SideBySideBarSeriesLabel Position="Top" Font="Arial, 12pt, style=Bold" LineVisibility="False">
                                                                <Border Visibility="False" />
                                                            </dx:SideBySideBarSeriesLabel>
                                                        </LabelSerializable>
                                                    </dx:Series>
                                                    <dx:Series ArgumentScaleType="Qualitative" LabelsVisibility="True" Name="Sắp hết nhiệm kỳ" LegendName="Default Legend">
                                                        <Points></Points>
                                                        <ViewSerializable>
                                                            <dx:SideBySideBarSeriesView Color="16, 129, 156">
                                                            </dx:SideBySideBarSeriesView>
                                                        </ViewSerializable>
                                                        <LabelSerializable>
                                                            <dx:SideBySideBarSeriesLabel Position="Top" Font="Arial, 12pt, style=Bold" LineVisibility="False">
                                                                <Border Visibility="False" />
                                                            </dx:SideBySideBarSeriesLabel>
                                                        </LabelSerializable>
                                                    </dx:Series>
                                                    <dx:Series ArgumentScaleType="Qualitative" LabelsVisibility="True" Name="Bổ nhiệm mới" LegendName="Default Legend">
                                                        <Points></Points>
                                                        <ViewSerializable>
                                                            <dx:SideBySideBarSeriesView Color="64, 72, 139">
                                                            </dx:SideBySideBarSeriesView>
                                                        </ViewSerializable>
                                                        <LabelSerializable>
                                                            <dx:SideBySideBarSeriesLabel Position="Top" Font="Arial, 12pt, style=Bold" LineVisibility="False">
                                                                <Border Visibility="False" />
                                                            </dx:SideBySideBarSeriesLabel>
                                                        </LabelSerializable>
                                                    </dx:Series>
                                                </SeriesSerializable>
                                                <PaletteWrappers>
                                                    <dx:PaletteWrapper Name="ThongkeTP_3Nam_3TieuChi" ScaleMode="Repeat">
                                                        <Palette>
                                                            <dx:PaletteEntry Color="228, 57, 60" Color2="228, 57, 60" />
                                                            <dx:PaletteEntry Color="16, 129, 156" Color2="16, 129, 156" />
                                                            <dx:PaletteEntry Color="64, 72, 139" Color2="64, 72, 139" />
                                                        </Palette>
                                                    </dx:PaletteWrapper>
                                                </PaletteWrappers>
                                            </dx:WebChartControl>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <div class="div_part_tyle">
                                            <div class="div_part_tyle_left">
                                                <img alt="" src="../UI/img/GSTP_TKTP_icon.png" />
                                                <span class="div_part_tyle_left_text">ĐANG CÔNG TÁC</span>
                                            </div>
                                            <div style="color: #C8202F; float: left; font-weight: bold; font-size: 30px; margin-left: 25px; margin-top: 47px;">
                                                <asp:Literal ID="ltrDangcongtac" runat="server" Text=""></asp:Literal>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="div_part_tyle">
                                            <div class="div_part_tyle_left">
                                                <img alt="" src="../UI/img/GSTP_TKTP_icon.png" />
                                                <span class="div_part_tyle_left_text">TỶ LỆ BIẾN ĐỘNG</span>
                                            </div>
                                            <div style="color: #14A0C1; font-size: 22px; float: left; margin-top: 36px; margin-left: 25px; margin-bottom: 8px; width: 35%;">
                                                <asp:Literal ID="ltrTangGiam" runat="server" Text=""></asp:Literal>
                                                &nbsp;<span style="font-weight: bold; font-size: 25px;"><asp:Literal ID="ltrBienDong" runat="server" Text=""></asp:Literal></span>
                                            </div>
                                            <div style="float: left; font-size: 20px; margin-left: 25px; width: 35%;">
                                                <asp:Literal ID="ltrPerTyLeBienDong" runat="server" Text=""></asp:Literal>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="div_part_tyle">
                                            <div class="div_part_tyle_left">
                                                <img alt="" src="../UI/img/GSTP_TKTP_icon.png" />
                                                <span class="div_part_tyle_left_text">TỶ LỆ TĂNG CAO NHẤT</span>
                                            </div>
                                            <div class="tangcaonhat_name">
                                                quận<br />
                                                Tây Hồ
                                            </div>
                                            <div class="tangcaonhat_per">25%</div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="div_part_tyle">
                                            <div class="div_part_tyle_left">
                                                <img alt="" src="../UI/img/GSTP_TKTP_icon.png" />
                                                <span class="div_part_tyle_left_text">TỶ LỆ GIẢM NHIỀU NHẤT</span>
                                            </div>
                                            <div class="tangcaonhat_name">
                                                quận<br />
                                                Hoàng Mai
                                            </div>
                                            <div class="tangcaonhat_per">20%</div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        <div class="div_TP_ToanNganh">
                                            <dx:WebChartControl ID="WebChartToanNganh" runat="server" Width="540px" Height="400px" CssClass="WebChart_ThamPhan" CrosshairEnabled="True">
                                                <BorderOptions Visibility="False" />
                                                <DiagramSerializable>
                                                    <dx:XYDiagram>
                                                        <AxisX Visibility="False" VisibleInPanesSerializable="-1">
                                                        </AxisX>
                                                        <AxisY Visibility="False" VisibleInPanesSerializable="-1">
                                                        </AxisY>
                                                    </dx:XYDiagram>
                                                </DiagramSerializable>
                                                <Legend Name="Default Legend" Visibility="False"></Legend>
                                                <SeriesSerializable>
                                                    <dx:Series ArgumentScaleType="Qualitative" Name="Series 1">
                                                        <Points>
                                                            <dx:SeriesPoint ArgumentSerializable="HN" ColorSerializable="#B3B3B3" Values="2500;2500">
                                                            </dx:SeriesPoint>
                                                            <dx:SeriesPoint ArgumentSerializable="HCM" ColorSerializable="#B3B3B3" Values="2000;2000">
                                                            </dx:SeriesPoint>
                                                            <dx:SeriesPoint ArgumentSerializable="LS" ColorSerializable="#B3B3B3" Values="800;800">
                                                            </dx:SeriesPoint>
                                                            <dx:SeriesPoint ArgumentSerializable="QN" ColorSerializable="#B3B3B3" Values="1000;1000">
                                                            </dx:SeriesPoint>
                                                            <dx:SeriesPoint ArgumentSerializable="HNA" ColorSerializable="#B3B3B3" Values="600;600">
                                                            </dx:SeriesPoint>
                                                            <dx:SeriesPoint ArgumentSerializable="TB" ColorSerializable="#B3B3B3" Values="350;250">
                                                            </dx:SeriesPoint>
                                                            <dx:SeriesPoint ArgumentSerializable="CB" ColorSerializable="#B3B3B3" Values="200;200">
                                                            </dx:SeriesPoint>
                                                            <dx:SeriesPoint ArgumentSerializable="HP" ColorSerializable="#B3B3B3" Values="750;750">
                                                            </dx:SeriesPoint>
                                                        </Points>
                                                        <ViewSerializable>
                                                            <dx:BubbleSeriesView Color="179, 179, 179" MaxSize="2">
                                                            </dx:BubbleSeriesView>
                                                        </ViewSerializable>
                                                    </dx:Series>
                                                </SeriesSerializable>
                                            </dx:WebChartControl>
                                        </div>
                                    </td>
                                    <td colspan="3" style="vertical-align: top;">
                                        <div class="div_DS_TP">
                                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            <div class="phantrang" style="display: none;">
                                                <div class="sobanghi">
                                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                                </div>
                                                <div class="sotrang">
                                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                                </div>
                                            </div>
                                            <asp:DataGrid ID="dgList_ThamPhan_DonVi" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                CssClass="table2 dgList_ThamPhan_DonVi" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                ItemStyle-CssClass="chan" Width="573" OnItemCommand="dgList_ThamPhan_DonVi_ItemCommand">
                                                <Columns>
                                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            STT
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("STT") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Họ và tên
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtTenThamPhan" runat="server" CausesValidation="false" Text='<%#Eval("TENTP") %>' CommandName="ChiTiet" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Đơn vị 
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#(Eval("TENDONVI").ToString()).Replace("Tòa án nhân dân","TAND") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="NGAYSINH" HeaderText="Ngày sinh" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Chức danh
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("CHUCDANH") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <HeaderStyle CssClass="header"></HeaderStyle>
                                                <ItemStyle CssClass="chan"></ItemStyle>
                                                <PagerStyle Visible="false"></PagerStyle>
                                            </asp:DataGrid>
                                            <div class="phantrang">
                                                <div class="sobanghi" style="display: none;">
                                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                                </div>
                                                <div class="sotrang">
                                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                    <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 580px;"></td>
                                    <td style="width: 189px;"></td>
                                    <td style="width: 385px;"></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" style="vertical-align: top;">
                        <div class="NoiDung_Footer">
                            <div style="display: table-cell; vertical-align: middle; font-size: 15px;">
                                &copy; Bản quyền thuộc về Tòa án nhân dân tối cao.<br />
                                Đề nghị ghi rõ nguồn (Cổng TTĐT Tòa án nhân dân tối cao) khi đăng tải lại các thông tin, nội dung từ www.toaan.gov.vn.
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="width: 38px;"></td>
                    <td style="width: 1145px;"></td>
                    <td></td>
                </tr>
            </table>
        </div>
        <script type="text/javascript">
            var min_index = 0;
            var max_index = 10;
            var end_index = 5;
            var slide_index = 0;
            var number_Show = 5;
            displaySlides(slide_index);

            function nextSlide(n) {
                slide_index = slide_index + n;
                displaySlides(slide_index);
            }

            function displaySlides(n) {
                var i;
                end_index = number_Show + n;
                if (end_index > max_index) {
                    end_index = max_index;
                    slide_index = end_index - number_Show;
                }
                if (slide_index < min_index) {
                    end_index = min_index + number_Show;
                    slide_index = 0;
                }
                var slides = document.getElementsByClassName("showSlide");
                if (end_index <= max_index || slide_index >= min_index) {
                    for (i = 0; i < slides.length; i++) {
                        if (i >= slide_index && i <= end_index) {
                            slides[i].style.display = "block";
                        } else {
                            slides[i].style.display = "none";
                        }
                    }
                }
            }
        </script>
    </form>
</body>
</html>
