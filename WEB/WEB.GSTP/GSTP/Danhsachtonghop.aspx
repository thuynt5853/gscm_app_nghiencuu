<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Danhsachtonghop.aspx.cs" Inherits="WEB.GSTP.GSTP.Danhsachtonghop" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <title>HỆ THỐNG GIÁM SÁT THẨM PHÁN</title>
    <link href="../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../UI/css/style.css" rel="stylesheet" />
    <link href="../UI/css/chosen.css" rel="stylesheet" />
    <script type='text/javascript' src='GSTP_jquery.min.js'></script>
    <script type='text/javascript' src='chosen/chosen.jquery.min.js'></script>
    <asp:Literal ID="ltrMapjs" runat="server"></asp:Literal>
    <script src="GSTP_usmap.js"></script>
    <script src="GSTP_select.js"></script>
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

        .Title_Group_Box {
            float: left;
            color: #E34856;
            text-transform: uppercase;
            font-size: 18px;
            font-weight: bold;
            margin-left: 5px;
        }

        .Title_Group_Box_GiaiDoan_Wap {
            float: left;
            width: 100%;
            text-align: center;
            margin-top: 10px;
            color: #065381;
            text-transform: uppercase;
        }

        .Title_Group_Box_GiaiDoan {
            font-size: 18px;
            font-weight: bold;
        }

        .Title_Group_Box_ThamPhan {
            float: left;
            color: #E34856;
            text-transform: uppercase;
            font-size: 18px;
            font-weight: bold;
            margin-left: 37px;
            margin-top: 10px;
            margin-bottom: 10px;
            margin-left: 10px;
            width: 90%;
        }

        .Icon_Title_Group_Box {
            float: left;
            width: 21px;
            height: 20px;
            margin-left: 5px;
        }

        .Icon_Title_Group_Box_ThamPhan {
            float: left;
            width: 21px;
            height: 20px;
            margin-top: 10px;
            margin-left: 5px;
        }

        .Icon_CongBoBanAn {
            float: left;
            width: 21px;
            height: 20px;
            margin: 10px 0px 10px 5px;
        }

        .Title_CongBoBanAn {
            float: left;
            color: #E34856;
            text-transform: uppercase;
            font-size: 20px;
            font-weight: bold;
            margin-left: 10px;
            margin-top: 10px;
        }

        .table_Congbobanan_hight {
            height: 78px;
        }

        .div_thongke_wap {
            height: 95px;
            width: 114px;
            float: left;
            border: 1px solid #BEBEBD;
            margin-left: 5px;
            margin-bottom: 3px;
            border-radius: 5px;
            margin-top: 5px;
            box-shadow: 1px 1px 1px #BEBEBD;
            -moz-box-shadow: 1px 1px 1px #BEBEBD;
            -webkit-box-shadow: 1px 1px 1px #BEBEBD;
            box-shadow: -1px -1px -1px #CACACA;
            -moz-box-shadow: -1px -1px -1px #CACACA;
            -webkit-box-shadow: -1px -1px -1px #CACACA;
        }

        .div_thongke_wap_loaian {
            height: 85px;
            width: 114px;
            float: left;
            border: 1px solid #BEBEBD;
            margin-left: 5px;
            margin-bottom: 3px;
            border-radius: 5px;
            margin-top: 5px;
            box-shadow: 1px 1px 1px #BEBEBD;
            -moz-box-shadow: 1px 1px 1px #BEBEBD;
            -webkit-box-shadow: 1px 1px 1px #BEBEBD;
            box-shadow: -1px -1px -1px #CACACA;
            -moz-box-shadow: -1px -1px -1px #CACACA;
            -webkit-box-shadow: -1px -1px -1px #CACACA;
        }

        .div_thongke_wap_3line {
            height: 115px;
            width: 114px;
            float: left;
            border: 1px solid #BEBEBD;
            margin-left: 5px;
            margin-bottom: 3px;
            border-radius: 5px;
            margin-top: 5px;
            box-shadow: 1px 1px 1px #BEBEBD;
            -moz-box-shadow: 1px 1px 1px #BEBEBD;
            -webkit-box-shadow: 1px 1px 1px #BEBEBD;
            box-shadow: -1px -1px -1px #CACACA;
            -moz-box-shadow: -1px -1px -1px #CACACA;
            -webkit-box-shadow: -1px -1px -1px #CACACA;
        }

        .head_div_thongke {
            height: 40px;
            background-color: #F4DAAC;
            color: #E34856;
            width: 100%;
            float: left;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            box-shadow: 2px 2px 2px #BEBEBD;
            -moz-box-shadow: 2px 2px 2px #BEBEBD;
            -webkit-box-shadow: 2px 2px 2px #BEBEBD;
            display: table;
            text-align: center;
        }

            .head_div_thongke:hover {
                background-color: #E34856;
                color: #FFFFFF;
                cursor: pointer;
            }

        .head_div_thongke_loaian {
            height: 28px;
            background-color: #F4DAAC;
            color: #E34856;
            width: 100%;
            float: left;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            box-shadow: 2px 2px 2px #BEBEBD;
            -moz-box-shadow: 2px 2px 2px #BEBEBD;
            -webkit-box-shadow: 2px 2px 2px #BEBEBD;
            display: table;
            text-align: center;
        }

            .head_div_thongke_loaian:hover {
                background-color: #E34856;
                color: #FFFFFF;
                cursor: pointer;
            }

        .head_div_thongke_3line {
            height: 60px;
            background-color: #F4DAAC;
            color: #E34856;
            width: 100%;
            float: left;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            box-shadow: 2px 2px 2px #BEBEBD;
            -moz-box-shadow: 2px 2px 2px #BEBEBD;
            -webkit-box-shadow: 2px 2px 2px #BEBEBD;
            display: table;
            text-align: center;
        }

            .head_div_thongke_3line:hover {
                background-color: #E34856;
                color: #FFFFFF;
                cursor: pointer;
            }

        .TenThongKe {
            vertical-align: middle;
            height: 40px;
            display: table-cell;
            padding-left: 3px;
            padding-right: 3px;
        }

        .TenThongKe_loaian {
            vertical-align: middle;
            height: 28px;
            display: table-cell;
            padding-left: 3px;
            padding-right: 3px;
        }

        .inner {
            font-size: 17px;
        }

        .content_div_thongke_td {
            padding-top: 3px !important;
            padding-bottom: 3px !important;
            vertical-align: bottom !important;
        }

        .content_div_thongke_td_Col1 {
            width: 19px;
            text-align: center;
        }

        .content_div_thongke_td_Col3 {
            width: 65px;
        }

        .arrow_nam_truoc {
            height: 15px;
            width: 15px;
            margin-left: 5px;
        }

        .arrow_nam_hientai {
            height: 15px;
            width: 15px;
            margin-left: 5px;
            margin-top: 3px;
        }

        .int_nam_truoc {
            font-size: 14px;
            color: #C62127;
            font-weight: bold;
            float: left;
            margin-left: 5px;
            margin-top: 2px;
        }

        .int_only_nam_truoc {
            font-size: 14px;
            color: #C62127;
            font-weight: bold;
            float: right;
            margin-right: 15px;
            margin-top: 2px;
        }

        .percent_nam_truoc {
            font-size: 14px;
            color: #C62127;
            float: right;
            padding-right: 2px;
            font-weight: bold;
        }

        .int_nam_hientai {
            font-size: 15px;
            color: #094E77;
            font-weight: bold;
            float: left;
            margin-left: 5px;
        }

        .int_only_nam_hientai {
            font-size: 15px;
            color: #094E77;
            font-weight: bold;
            float: right;
            margin-right: 15px;
        }

        .percent_nam_hientai {
            font-size: 15px;
            color: #094E77;
            float: right;
            font-weight: bold;
            padding-right: 2px;
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

        .NoiDung_Head {
            height: 86px;
            background-color: #E6E6E6;
            margin: 5px;
        }

        .NoiDung_VuAn {
            background-color: #E6E6E6;
            margin: 0px 5px 0px 5px;
            float: left;
            min-height: 1040px;
        }

        .NoiDung_BanDo {
            background-color: #F2F2F2;
            margin-right: 5px;
            height: 1258px;
            width: 480px
        }

        .div_map_pie {
            /*z-index: 3;*/
        }

        .div_img_pie {
            width: 265px;
            height: 223px;
            background-image: url('../UI/img/GSTP_pie.png');
            background-repeat: no-repeat;
            margin: auto;
        }

        .div_wap_map {
            overflow: hidden;
            position: relative;
            z-index: 0;
            float: left;
        }

        .div_map {
            left: -139px;
            position: relative;
            width: 600px;
        }

        .NoiDung_CongBoBanAn {
            background-color: #E6E6E6;
            float: left;
            margin: 5px;
            padding-bottom: 10px;
        }

        .NoiDung_Footer {
            background-color: #F4DAAC;
            width: 100%;
            text-align: center;
            color: #666666;
            height: 40px;
            display: table;
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
            width: 262px;
        }

        .TenThamPhan {
            width: 305px;
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
            width: 312px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-top: 10px;
        }

        .QuyetDinhBoNhiem {
            width: 888px;
            height: 25px;
            border: solid 1px #cccccc;
            border-radius: 4px;
            float: left;
            background-color: #FFFFFF;
            margin-left: 10px;
        }

        .CongBoBanAn_NoiDung {
            float: left;
            width: 233px;
            height: 75px;
            background-color: #FFFFFF;
            margin-right: 5px;
            margin-left: 5px;
            border-radius: 5px;
            box-shadow: 2px 2px 2px #BEBEBD;
            -moz-box-shadow: 2px 2px 2px #BEBEBD;
            -webkit-box-shadow: 2px 2px 2px #BEBEBD;
        }

        .CongBoBanAn_NoiDung_Left {
            float: left;
            width: 90px;
            height: 75px;
            background-color: #E34856;
            border-top-left-radius: 5px;
            border-bottom-left-radius: 5px;
            box-shadow: 2px 2px 2px #BEBEBD;
            -moz-box-shadow: 2px 2px 2px #BEBEBD;
            -webkit-box-shadow: 2px 2px 2px #BEBEBD;
            display: table;
            text-align: center;
            cursor: pointer;
        }

        .CongBoBanAn_NoiDung_Left_Icon {
            text-align: center;
            width: 100%;
            padding-top: 13px;
            padding-bottom: 10px;
        }

        .CongBoBanAn_NoiDung_Left_Title {
            width: 100%;
            color: #FFFFFF;
            font-size: 14px;
            display: table-cell;
            vertical-align: middle;
        }

        .CongBoBanAn_NoiDung_Right {
            float: left;
            width: 138px;
        }

        .CongBoBanAn_NoiDung_Right_Col1 {
            width: 30px;
        }

        .CongBoBanAn_NoiDung_Right_Col3 {
            width: 65px;
        }

        .CongBoBanAn_NoiDung_Right_Col4 {
            width: 80px;
        }

        .int_nam_truoc_CongBoBA {
            font-size: 14px;
            color: #C62127;
            font-weight: bold;
            float: left;
            margin-left: 5px;
        }

        .int_only_nam_truoc_CongBoBA {
            font-size: 14px;
            color: #C62127;
            font-weight: bold;
            float: right;
            margin-right: 5px;
        }

        .percent_nam_truoc_CongBoBA {
            font-size: 14px;
            color: #C62127;
            float: right;
            font-weight: bold;
        }

        .int_nam_hientai_CongBoBA {
            font-size: 14px;
            color: #094E77;
            font-weight: bold;
            float: left;
            margin-left: 5px;
        }

        .int_only_nam_hientai_CongBoBA {
            font-size: 14px;
            color: #094E77;
            font-weight: bold;
            float: right;
            margin-right: 5px;
        }

        .percent_nam_hientai_CongBoBA {
            font-size: 14px;
            color: #094E77;
            float: right;
        }

        .CongBoBanAn_NoiDung_Calendar {
            padding-left: 10px;
        }

        .CongBoBanAn_NoiDung_Icon_TK {
            padding-right: 10px;
        }

        .pie_1_title {
            transform: rotate(-67deg);
            color: #FFF;
            font-size: 9px;
            margin-top: 13px;
            float: left;
            margin-left: -2px;
            font-weight: bold;
        }

        .pie_2_title {
            transform: rotate(-27deg);
            color: #FFF;
            font-size: 9px;
            margin-top: 22px;
            float: left;
            margin-left: 60px;
            font-weight: bold;
        }

        .pie_3_title {
            transform: rotate(23deg);
            color: #FFF;
            font-size: 9px;
            margin-top: 21px;
            float: left;
            margin-left: 25px;
            font-weight: bold;
        }

        .pie_4_title {
            transform: rotate(65deg);
            color: #FFF;
            font-size: 10px;
            margin-top: 13px;
            float: left;
            margin-left: 74px;
            font-weight: bold;
            width: 60px;
        }

        .pie_1_No1 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 18px;
            margin-left: -12px;
            color: #FFF;
            transform: rotate(-70deg);
        }

        .pie_1_No2 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 16px;
            margin-left: -20px;
            color: #FFF;
            transform: rotate(-70deg);
        }

        .pie_1_No3 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 18px;
            margin-left: -23px;
            color: #FFF;
            transform: rotate(-70deg);
        }

        .pie_1_No4 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 17px;
            margin-left: -27px;
            color: #FFF;
            transform: rotate(-70deg);
        }

        .pie_1_No5 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 16px;
            margin-left: -33px;
            color: #FFF;
            transform: rotate(-70deg);
        }

        .pie_1_No6 {
            font-size: 16px;
            font-weight: bold;
            float: left;
            margin-top: 17px;
            margin-left: -35px;
            color: #FFF;
            transform: rotate(-70deg);
        }

        .pie_2_No1 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 3px;
            margin-left: 89px;
            color: #FFF;
            transform: rotate(-27deg);
        }

        .pie_2_No2 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 2px;
            margin-left: 85px;
            color: #FFF;
            transform: rotate(-27deg);
        }

        .pie_2_No3 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 3px;
            margin-left: 80px;
            color: #FFF;
            transform: rotate(-27deg);
        }

        .pie_2_No4 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 3px;
            margin-left: 75px;
            color: #FFF;
            transform: rotate(-27deg);
        }

        .pie_2_No5 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 3px;
            margin-left: 70px;
            color: #FFF;
            transform: rotate(-24deg);
        }

        .pie_2_No6 {
            font-size: 16px;
            font-weight: bold;
            float: left;
            margin-top: 4px;
            margin-left: 68px;
            color: #FFF;
            transform: rotate(-24deg);
        }

        .pie_3_No1 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 34px;
            margin-left: -31px;
            color: #FFF;
            transform: rotate(21deg);
        }

        .pie_3_No2 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 34px;
            margin-left: -36px;
            color: #FFF;
            transform: rotate(21deg);
        }

        .pie_3_No3 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 34px;
            margin-left: -41px;
            color: #FFF;
            transform: rotate(21deg);
        }

        .pie_3_No4 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 35px;
            margin-left: -46px;
            color: #FFF;
            transform: rotate(23deg);
        }

        .pie_3_No5 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: 35px;
            margin-left: -51px;
            color: #FFF;
            transform: rotate(25deg);
        }

        .pie_3_No6 {
            font-size: 16px;
            font-weight: bold;
            float: left;
            margin-top: 35px;
            margin-left: -52px;
            color: #FFF;
            transform: rotate(25deg);
        }

        .pie_4_No1 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: -9px;
            margin-left: 81px;
            color: #FFF;
            transform: rotate(66deg);
        }

        .pie_4_No2 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: -10px;
            margin-left: 76px;
            color: #FFF;
            transform: rotate(66deg);
        }

        .pie_4_No3 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: -9px;
            margin-left: 71px;
            color: #FFF;
            transform: rotate(66deg);
        }

        .pie_4_No4 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: -9px;
            margin-left: 65px;
            color: #FFF;
            transform: rotate(66deg);
        }

        .pie_4_No5 {
            font-size: 18px;
            font-weight: bold;
            float: left;
            margin-top: -7px;
            margin-left: 61px;
            color: #FFF;
            transform: rotate(69deg);
        }

        .pie_4_No6 {
            font-size: 16px;
            font-weight: bold;
            float: left;
            margin-top: -7px;
            margin-left: 61px;
            color: #FFF;
            transform: rotate(69deg);
        }

        .pie_Total_No1 {
            float: left;
            color: #D40023;
            margin-left: 127px;
            font-size: 18px;
            font-weight: bold;
        }

        .pie_Total_No2 {
            float: left;
            color: #D40023;
            margin-left: 123px;
            font-size: 18px;
            font-weight: bold;
        }

        .pie_Total_No3 {
            float: left;
            color: #D40023;
            margin-left: 118px;
            font-size: 18px;
            font-weight: bold;
        }

        .pie_Total_No4 {
            float: left;
            color: #D40023;
            margin-left: 112px;
            font-size: 18px;
            font-weight: bold;
        }

        .pie_Total_No5 {
            float: left;
            color: #D40023;
            margin-left: 106px;
            font-size: 18px;
            font-weight: bold;
        }

        .pie_Total_No6 {
            float: left;
            color: #D40023;
            margin-left: 101px;
            font-size: 18px;
            font-weight: bold;
        }

        .Title_Pie {
            text-transform: uppercase;
            color: #065381;
            font-size: 12px;
            font-weight: 900;
            position: relative;
            top: 40px;
            /*z-index: 1;*/
            text-align: center;
        }

        .css_HoangSa {
            position: relative;
            float: right;
            margin-top: -458px;
        }

        .css_TruongSa {
            position: relative;
            float: right;
            margin-top: -150px;
        }

        .Title_Map {
            text-transform: uppercase;
            color: #666;
            font-size: 16px;
            font-weight: bold;
            float: left;
            margin-left: 86px;
        }

        .GiaiDoanXetXu {
            border-top: 1px dashed #B3B3B3;
            float: left;
            margin-bottom: 5px;
            margin-top: 10px;
        }

        .clear_float {
            clear: both;
        }

        .ThongkeThamPhan {
            background-color: #E6E6E6;
            float: left;
            padding-bottom: 5px;
            border-top: 1px dashed #B3B3B3;
            margin-top: 10px;
        }

        .MenuLeft {
            background-color: #D40023;
            width: 37px;
            height: 1490px;
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
                height: 1490px;
                position: absolute;
                z-index: 1000;
            }

            .MenuLeft_wap:hover .MenuLeft_ex {
                visibility: visible;
            }

        .MenuLeft_ex_Home_Active {
            background-image: url('../UI/img/GSTP_MenuLeft_Home_Hover.png');
            background-repeat: no-repeat;
            width: 200px;
            height: 34px;
            background-color: #F7D08C;
            color: #D40627;
            float: left;
        }

            .MenuLeft_ex_Home_Active .bottom_ex {
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

        .div_tracuu {
            background-color: #B3B4B4;
            height: 26px;
            width: 269px;
            cursor: pointer;
            float: left;
            margin: 10px 0px 0px 15px;
            border-radius: 4px;
            color: #E6393D;
            position: relative;
        }

            .div_tracuu:hover {
                background-color: #E6393D;
                color: #FFFFFF;
            }

                .div_tracuu:hover .div_img_tracuu {
                    background-image: url('../UI/img/GSTP_tracuu_Hover.png');
                    background-repeat: no-repeat;
                    width: 16px;
                    height: 18px;
                }

        .div_img_tracuu {
            background-image: url('../UI/img/GSTP_tracuu.png');
            background-repeat: no-repeat;
            width: 16px;
            height: 18px;
            float: left;
            margin-right: 10px;
        }

            .div_img_tracuu:hover {
                background-image: url('../UI/img/GSTP_tracuu_Hover.png');
                background-repeat: no-repeat;
                width: 16px;
                height: 18px;
            }

        .div_wap_Tracuu {
            margin: 0;
            position: absolute;
            top: 50%;
            left: 50%;
            -ms-transform: translate(-50%, -50%);
            transform: translate(-50%, -50%);
        }
    </style>
</head>
<body>
    <form id="Form1" runat="server">
        <div class="header" style="background: url('../UI/img/GSTP_bggscm.png'); height: 66px;">
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
        <div id="NoiDung">
            <table class="Table_Full_Width_No_Border_Spacing">
                <tr>
                    <td rowspan="3" style="vertical-align: top; width: 38px;">
                        <div class="MenuLeft_wap">
                            <div class="MenuLeft" id="MenuLeft" runat="server">
                                <asp:LinkButton ID="cmd_MenuLeft_Home" CssClass="cmd_MenuLeft_Home_active" runat="server"></asp:LinkButton>
                                <asp:LinkButton ID="cmd_MenuLeft_DanhGiaThamPhan" runat="server" CssClass="cmd_MenuLeft_DanhGiaThamPhan" OnClick="cmd_MenuLeft_DanhGiaThamPhan_Click"></asp:LinkButton>
                                <asp:LinkButton ID="cmd_MenuLeft_ThongKe" runat="server" CssClass="cmd_MenuLeft_ThongKe" OnClick="cmd_MenuLeft_ThongKe_Click" ToolTip="Báo cáo thống kê"></asp:LinkButton>
                                <%--<asp:LinkButton ID="cmd_MenuLeft_HDSD" runat="server" CssClass="cmd_MenuLeft_HDSD" OnClick="cmd_MenuLeft_HDSD_Click" ToolTip="Hướng dẫn sử dụng"></asp:LinkButton>--%>
                            </div>
                            <div class="MenuLeft_ex" id="MenuLeft_ex" runat="server">
                                <asp:LinkButton ID="LinkButton1" CssClass="MenuLeft_ex_Home_Active" runat="server">
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
                    <td colspan="3">
                        <div class="NoiDung_Head">
                            <div id="div_Search" style="border-right: 2px solid #DFDFDF; height: 86px; width: 300px; float: left;">
                                <asp:TextBox ID="txtSearch" runat="server" placeholder="Tên thẩm phán" CssClass="user txtSearch" onkeypress="return KeypressUp_Enter(event);"></asp:TextBox>
                                <div id="div_tracuu_ID" class="div_tracuu" onclick="Redirect_To_DanhSachThamPhan()">
                                    <div class="div_wap_Tracuu">
                                        <div class="div_img_tracuu"></div>
                                        <span style="font-size: 14px; font-weight: bold; float: left;">Tra cứu</span>
                                    </div>
                                </div>
                            </div>
                            <div id="div_Info" style="height: 86px; width: 910px; float: left;">
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
                    <td style="vertical-align: top; width: 742px;">
                        <div class="NoiDung_VuAn">
                            <div style="float: left; width: 100%; margin: 10px 5px 15px 5px;">
                                <div style="width: 60px; float: left; margin-top: 6px; font-weight: bold;">
                                    Đơn vị
                                </div>
                                <asp:DropDownList ID="ddlDonVi" runat="server" OnSelectedIndexChanged="ddlDonVi_SelectedIndexChanged" AutoPostBack="true" Style="width: 659px;"></asp:DropDownList>
                            </div>
                            <div style="float: left; width: 100%; margin-bottom: 10px;">
                                <img class="Icon_Title_Group_Box" alt="" src="../UI/img/GSTP_thongke.png" />
                                <span class="Title_Group_Box">Thống kê tình hình thụ lý, giải quyết các loại vụ án</span>
                            </div>
                            <span style="float: right; margin-right: 10px;">Tổng giải quyết</span>
                            <img style="height: 17px; width: 17px; float: right; margin-right: 5px;" alt="" src="../UI/img/GSTP_Arrow_Left.png" />
                            <span style="float: right; margin-right: 10px;">Tổng thụ lý</span>
                            <img style="height: 17px; width: 17px; float: right; margin-right: 5px;" alt="" src="../UI/img/GSTP_Arrow_Right.png" />
                            <span style="float: right; margin-right: 10px;">Năm trước</span>
                            <img style="height: 17px; width: 17px; float: right; margin-right: 5px;" alt="" src="../UI/img/GSTP_Arrow_Up.png" />
                            <span style="float: right; margin-right: 10px;">Năm hiện tại</span>
                            <img style="height: 17px; width: 17px; float: right; margin-right: 5px;" alt="" src="../UI/img/GSTP_Arrow_Down.png" />
                            <div id="GiaiDoanXetXu_SoTham" runat="server" class="GiaiDoanXetXu">
                                <div class="Title_Group_Box_GiaiDoan_Wap">
                                    <span class="Title_Group_Box_GiaiDoan">Sơ thẩm</span>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Tổng số thụ lý</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_TongThuLy_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm hiện trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_TongThuLy_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Đã giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_GiaiQuyet_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_GiaiQuyet_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_GiaiQuyet_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_GiaiQuyet_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Tổng số án bị hủy, sửa</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" AlternateText="" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_AnHuy_Sua_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_AnHuy_Sua_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" AlternateText="" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_AnHuy_Sua_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_AnHuy_Sua_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Chưa giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_Chua_GQ_Nam_Hientai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_Chua_GQ_Nam_Hientai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_Chua_GQ_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_Chua_GQ_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSVA quá hạn luật định</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_QuaHan_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_QuaHan_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSVA tổ chức PTRKN</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_RutKN_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_RutKN_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HÌNH SỰ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_HinhSu_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_HinhSu_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">DÂN SỰ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_DanSu_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_DanSu_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HNGĐ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_HNGD_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_HNGD_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">KDTM</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_KDTM_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_KDTM_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HÀNH CHÍNH</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_HanhChinh_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_HanhChinh_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">LAO ĐỘNG</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_LaoDong_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_LaoDong_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                                 <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Tổng số đơn đã nhận</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_Don_DaNhan_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm hiện trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_Don_DaNhan_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Đã thụ lý</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_DonThuly_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm hiện trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_DonThuly__Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Giải quyết khác</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_DonXLK_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm hiện trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_DonXLK_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Chưa giải quyết</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_Don_ChuaGiaiQuyet_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm hiện trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_Don_ChuaGiaiQuyet_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_SoTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSD quá luật định</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_ST_Don_QuaHan_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm hiện trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_ST_Don_QuaHan_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                 
                            </div>
                            <div id="GiaiDoanXetXu_PhucTham" runat="server" class="GiaiDoanXetXu">
                                <div class="Title_Group_Box_GiaiDoan_Wap">
                                    <span class="Title_Group_Box_GiaiDoan">Phúc thẩm</span>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Tổng số thụ lý</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_TongThuLy_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_TongThuLy_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Đã giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_GiaiQuyet_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_GiaiQuyet_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_GiaiQuyet_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_GiaiQuyet_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Tổng số án bị hủy, sửa</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" AlternateText="" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_AnHuy_Sua_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_AnHuy_Sua_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" AlternateText="" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_AnHuy_Sua_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_AnHuy_Sua_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">Chưa giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_Chua_GQ_Nam_Hientai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_Chua_GQ_Nam_Hientai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_Chua_GQ_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_Chua_GQ_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSVA quá hạn luật định</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_QuaHan_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_QuaHan_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSVA tổ chức PTRKN</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_RutKN_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_PT_RutKN_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HÌNH SỰ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_HinhSu_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_HinhSu_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">DÂN SỰ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_DanSu_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_DanSu_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HNGĐ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_HNGD_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_HNGD_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">KDTM</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_KDTM_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_KDTM_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HÀNH CHÍNH</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_HanhChinh_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_HanhChinh_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_PhucTham()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">LAO ĐỘNG</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_LaoDong_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_PT_LaoDong_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div id="GiaiDoanXetXu_DonGDT" runat="server" class="GiaiDoanXetXu">
                                <div class="Title_Group_Box_GiaiDoan_Wap">
                                    <span class="Title_Group_Box_GiaiDoan">Đơn đề nghị GĐT,TT</span>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSVA có đơn GĐT,TT</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_VuAn_DonDeNghi_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_VuAn_DonDeNghi_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSVA thuộc 8.1</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_VuAn_8_1_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_VuAn_8_1_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSVA sắp hết thời hiệu KN</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" AlternateText="" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_VuAn_ThoiHieu_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" AlternateText="" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_VuAn_ThoiHieu_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">Đã giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_VuAn_GiaiQuyetXong_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_VuAn_GiaiQuyetXong_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_VuAn_GiaiQuyetXong_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_VuAn_GiaiQuyetXong_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">Chưa giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_VuAn_ChuaXong_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_VuAn_ChuaXong_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_VuAn_ChuaXong_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_VuAn_ChuaXong_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="clear_float"></div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">Tổng số đơn GĐT,TT</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_Tong_DonDeNghi_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_Tong_DonDeNghi_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSĐ thuộc Vụ GĐKT I</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Vu1_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Vu1_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSĐ thuộc Vụ GĐKT II</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Vu2_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Vu2_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">TSĐ thuộc Vụ GĐKT III</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Vu3_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Vu3_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">Đơn thuộc ĐV khác</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Khac_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_Don_Chuyen_Khac_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div id="GiaiDoanXetXu_GDT" runat="server" class="GiaiDoanXetXu">
                                <div class="Title_Group_Box_GiaiDoan_Wap">
                                    <span class="Title_Group_Box_GiaiDoan">Xét xử GĐT,TT</span>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">Tổng số thụ lý</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_TongThuLy_Nam_Hientai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_XetXu_TongThuLy_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">Đã giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_GiaiQuyetXong_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_GiaiQuyetXong_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_XetXu_GiaiQuyetXong_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_XetXu_GiaiQuyetXong_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">Chưa giải quyết xong</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" AlternateText="" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_ChuaXong_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_ChuaXong_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" AlternateText="" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_XetXu_ChuaXong_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_XetXu_ChuaXong_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe">
                                            <div class="inner">TS vụ, việc QHLĐ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_QuaHan_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_QuaHan_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_XetXu_QuaHan_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_XetXu_QuaHan_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="clear_float"></div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HÌNH SỰ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_HinhSu_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_HinhSu_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">DÂN SỰ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_DanSu_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_DanSu_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HNGĐ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_HNGD_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_HNGD_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">KDTM</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_KDTM_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_KDTM_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">HÀNH CHÍNH</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_HanhChinh_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_HanhChinh_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap_loaian">
                                    <div class="head_div_thongke_loaian" onclick="Redirect_To_Page2_GDT()">
                                        <div class="TenThongKe_loaian">
                                            <div class="inner">LAO ĐỘNG</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Tổng thụ lý">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Right.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_LaoDong_TongThuLy" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Tổng giải quyết">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Left.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_XetXu_LaoDong_TongGiaiQuyet" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div id="ThongkeThamPhan" runat="server" class="ThongkeThamPhan">
                                <div style="float: left; width: 100%;">
                                    <img class="Icon_Title_Group_Box_ThamPhan" alt="" src="../UI/img/GSTP_thongke.png" />
                                    <span class="Title_Group_Box_ThamPhan">Thống kê thẩm phán TAND</span>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke">
                                        <div class="TenThongKe">
                                            <div class="inner">Đang công tác</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_DangCongTac_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_DangCongTac_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke">
                                        <div class="TenThongKe">
                                            <div class="inner">Sắp hết nhiệm kỳ</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_NhiemKy_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td colspan="2" class="content_div_thongke_td">
                                                <span class="int_only_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_NhiemKy_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke">
                                        <div class="TenThongKe">
                                            <div class="inner">Bị dừng xét xử/ XLKL</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" AlternateText="" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_DungXetXu_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_DungXetXu_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" AlternateText="" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_DungXetXu_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_DungXetXu_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke">
                                        <div class="TenThongKe">
                                            <div class="inner">Có đơn KN/TC</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_KhieuNai_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_KhieuNai_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_KhieuNai_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_KhieuNai_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke">
                                        <div class="TenThongKe">
                                            <div class="inner">Có án bị hủy, sửa</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_AnHuy_Sua_Nam_HienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td content_div_thongke_td_Col3">
                                                <span class="percent_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_AnHuy_Sua_Nam_HienTai_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td class="content_div_thongke_td">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Up.png" runat="server" CssClass="arrow_nam_truoc" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_AnHuy_Sua_Nam_Truoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="percent_nam_truoc">
                                                    <asp:Literal ID="ltr_TP_AnHuy_Sua_Nam_Truoc_Percent" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="div_thongke_wap">
                                    <div class="head_div_thongke">
                                        <div class="TenThongKe">
                                            <div class="inner">Có AH,S hơn %(QĐ120)</div>
                                        </div>
                                    </div>
                                    <table class="Table_Full_Width_No_Border_Spacing">
                                        <tr title="Năm hiện tại">
                                            <td class="content_div_thongke_td content_div_thongke_td_Col1">
                                                <asp:Image ImageUrl="~/UI/img/GSTP_Arrow_Down.png" runat="server" CssClass="arrow_nam_hientai" />
                                            </td>
                                            <td class="content_div_thongke_td">
                                                <span class="int_only_nam_hientai">
                                                    <asp:Literal ID="ltr_TP_AnHuy_Sua_QD120" runat="server"></asp:Literal></span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </td>
                    <td style="vertical-align: top; width: 480px;">
                        <div class="NoiDung_BanDo" id="NoiDung_BanDo" runat="server">
                            <div runat="server" style="padding-top: 10px; padding-left: 15px;">
                                <div style="width: 77px; float: left; margin-top: 6px;">Phạm vi</div>
                                <asp:DropDownList ID="ddlPhamvi" CssClass="chosen-select" runat="server" Width="375px" AutoPostBack="true" OnSelectedIndexChanged="ddlPhamvi_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                            <div id="Div_DonVi" style="margin-top: 5px; padding-left: 15px; margin-bottom: 10px;">
                                <div style="width: 77px; float: left; margin-top: 6px;">Đơn vị</div>
                                <select id="state_list" style="width: 375px;" tabindex="1" runat="server"></select>
                            </div>
                            <div id="map_pie" class="div_map_pie">
                                <div class="div_img_pie">
                                    <div style="width: 49%; height: 31%; float: left;">
                                        <div class="pie_2_title">GIẢI QUYẾT</div>
                                        <div id="pie_2"></div>
                                    </div>
                                    <div style="width: 49%; height: 31%; float: left;">
                                        <div class="pie_3_title">CÒN LẠI</div>
                                        <div id="pie_3"></div>
                                    </div>
                                    <div style="width: 49%; height: 25%; float: left;">
                                        <div class="pie_1_title">THỤ LÝ MỚI</div>
                                        <div id="pie_1"></div>
                                    </div>
                                    <div style="width: 49%; height: 25%; float: left;">
                                        <div class="pie_4_title">THẨM PHÁN</div>
                                        <div id="pie_4"></div>
                                    </div>
                                    <div style="width: 100%; float: left;">
                                        <div id="pie_Total"></div>
                                    </div>
                                    <div class="Title_Pie">
                                        <asp:Literal ID="ltrPie_Phamvi" runat="server" Text=""></asp:Literal><br />
                                        <span id="ltrPie_Title"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="div_wap_map">
                                <div id="map" class="div_map"></div>
                                <div style="position: relative; background-color: #f2f2f2; height: 40px; width: 200px; top: -40px; left: 260px; z-index: 1"></div>
                            </div>
                            <div class="css_HoangSa">
                                <img alt="Quần đảo Hoàng Sa Việt Nam" src="../UI/img/GSTP_HoangSa.png" />
                            </div>
                            <div class="css_TruongSa">
                                <img alt="Quần đảo Trường Sa Việt Nam" src="../UI/img/GSTP_TruongSa.png" />
                            </div>
                            <div class="Title_Map">
                                Bản đồ địa danh hành chính việt nam
                            </div>
                        </div>
                    </td>
                    <td>
                        <asp:Button ID="lbtCallDanhSachThamPhan" runat="server" OnClick="lbtCallDanhSachThamPhan_Click" Style="display: none;" />
                        <asp:Button ID="lbtCallPage2_SoTham" runat="server" OnClick="lbtCallPage2_SoTham_Click" Style="display: none;" />
                        <asp:Button ID="lbtCallPage2_PhucTham" runat="server" OnClick="lbtCallPage2_PhucTham_Click" Style="display: none;" />
                        <asp:Button ID="lbtCallPage2_GDT" runat="server" OnClick="lbtCallPage2_GDT_Click" Style="display: none;" />
                        <asp:Button ID="lbtCallPage2_BAQD" runat="server" OnClick="lbtCallPage2_BAQD_Click" Style="display: none;" />
                        <asp:Button ID="lbtCallPage2_BAQD_Public" runat="server" OnClick="lbtCallPage2_BAQD_Public_Click" Style="display: none;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="3" style="vertical-align: top;">
                        <div class="NoiDung_CongBoBanAn">
                            <div style="width: 100%; float: left;">
                                <asp:Image runat="server" AlternateText="" CssClass="Icon_CongBoBanAn" ImageUrl="~/UI/img/GSTP_thongke.png" />
                                <span class="Title_CongBoBanAn">Công bố bản án/ Quyết định</span>
                            </div>
                            <div class="CongBoBanAn_NoiDung">
                                <div class="CongBoBanAn_NoiDung_Left" onclick="Redirect_To_Page2_BAQD()">
                                    <div class="CongBoBanAn_NoiDung_Left_Title">Tổng số BA/QĐ đã xét xử</div>
                                </div>
                                <div class="CongBoBanAn_NoiDung_Right">
                                    <table class="Table_Full_Width_No_Border_Spacing table_Congbobanan_hight">
                                        <tr title="Năm hiện tại">
                                            <td class="CongBoBanAn_NoiDung_Right_Col1">
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Blue.png" />
                                            </td>
                                            <td>
                                                <span class="int_only_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="ltrBA_DaXetXu_NamHienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <%--<td class="CongBoBanAn_NoiDung_Right_Col3">
                                                <span class="percent_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="ltrBA_DaXetXu_NamHienTai_TyLe" runat="server"></asp:Literal></span>
                                            </td>--%>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td>
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Red.png" />
                                            </td>
                                            <td>
                                                <span class="int_only_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="ltrBA_DaXetXu_NamTruoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <%--<td>
                                                <span class="percent_nam_truoc_CongBoBA"><asp:Literal ID="ltrBA_DaXetXu_NamTruoc_TyLe" runat="server"></asp:Literal></span>
                                            </td>--%>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="CongBoBanAn_NoiDung" onclick="Redirect_To_Page2_BAQD()">
                                <div class="CongBoBanAn_NoiDung_Left">
                                    <div class="CongBoBanAn_NoiDung_Left_Title">Tổng số BA/QĐ có KCKN</div>
                                </div>
                                <div class="CongBoBanAn_NoiDung_Right">
                                    <table class="Table_Full_Width_No_Border_Spacing table_Congbobanan_hight">
                                        <tr title="Năm hiện tại">
                                            <td class="CongBoBanAn_NoiDung_Right_Col1">
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Blue.png" />
                                            </td>
                                            <td>
                                                <span class="int_only_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="ltrBA_KCKN_NamHienTai" runat="server"></asp:Literal></span>
                                            </td>
                                            <%--<td class="CongBoBanAn_NoiDung_Right_Col3">
                                                <span class="percent_nam_hientai_CongBoBA"><asp:Literal ID="ltrBA_KCKN_NamHienTai_TyLe" runat="server"></asp:Literal></span>
                                            </td>--%>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td>
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Red.png" />
                                            </td>
                                            <td>
                                                <span class="int_only_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="ltrBA_KCKN_NamTruoc" runat="server"></asp:Literal></span>
                                            </td>
                                            <%--<td>
                                                <span class="percent_nam_truoc_CongBoBA"><asp:Literal ID="ltrBA_KCKN_NamTruoc_TyLe" runat="server"></asp:Literal></span>
                                            </td>--%>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="CongBoBanAn_NoiDung" onclick="Redirect_To_Page2_BAQD_Puplic()">
                                <div class="CongBoBanAn_NoiDung_Left">
                                    <div class="CongBoBanAn_NoiDung_Left_Title">Tổng số BA/QĐ đã công bố</div>
                                </div>
                                <div class="CongBoBanAn_NoiDung_Right">
                                    <table class="Table_Full_Width_No_Border_Spacing table_Congbobanan_hight">
                                        <tr title="Năm hiện tại">
                                            <td class="CongBoBanAn_NoiDung_Right_Col1">
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Blue.png" />
                                            </td>
                                            <td>
                                                <span class="int_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_1" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="CongBoBanAn_NoiDung_Right_Col3">
                                                <span class="percent_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_2" runat="server"></asp:Literal>%</span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td>
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Red.png" />
                                            </td>
                                            <td>
                                                <span class="int_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_7" runat="server"></asp:Literal></span>
                                            </td>
                                            <td>
                                                <span class="percent_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_8" runat="server"></asp:Literal>%</span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="CongBoBanAn_NoiDung" onclick="Redirect_To_Page2_BAQD_Puplic()">
                                <div class="CongBoBanAn_NoiDung_Left">
                                    <div class="CongBoBanAn_NoiDung_Left_Title">TS BA/QĐ công bố chậm</div>
                                </div>
                                <div class="CongBoBanAn_NoiDung_Right">
                                    <table class="Table_Full_Width_No_Border_Spacing table_Congbobanan_hight">
                                        <tr title="Năm hiện tại">
                                            <td class="CongBoBanAn_NoiDung_Right_Col1">
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Blue.png" />
                                            </td>
                                            <td>
                                                <span class="int_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_3" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="CongBoBanAn_NoiDung_Right_Col3">
                                                <span class="percent_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_4" runat="server"></asp:Literal>%</span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td>
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Red.png" />
                                            </td>
                                            <td>
                                                <span class="int_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_9" runat="server"></asp:Literal></span>
                                            </td>
                                            <td>
                                                <span class="percent_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_10" runat="server"></asp:Literal>%</span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="CongBoBanAn_NoiDung" onclick="Redirect_To_Page2_BAQD_Puplic()">
                                <div class="CongBoBanAn_NoiDung_Left">
                                    <div class="CongBoBanAn_NoiDung_Left_Title">Tổng số BA/QĐ có đính chính</div>
                                </div>
                                <div class="CongBoBanAn_NoiDung_Right">
                                    <table class="Table_Full_Width_No_Border_Spacing table_Congbobanan_hight">
                                        <tr title="Năm hiện tại">
                                            <td class="CongBoBanAn_NoiDung_Right_Col1">
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Blue.png" />
                                            </td>
                                            <td>
                                                <span class="int_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_5" runat="server"></asp:Literal></span>
                                            </td>
                                            <td class="CongBoBanAn_NoiDung_Right_Col3">
                                                <span class="percent_nam_hientai_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_6" runat="server"></asp:Literal>%</span>
                                            </td>
                                        </tr>
                                        <tr title="Năm trước">
                                            <td>
                                                <img class="CongBoBanAn_NoiDung_Calendar" alt="" src="../UI/img/GSTP_Calendar_Red.png" />
                                            </td>
                                            <td>
                                                <span class="int_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_11" runat="server"></asp:Literal></span>
                                            </td>
                                            <td>
                                                <span class="percent_nam_truoc_CongBoBA">
                                                    <asp:Literal ID="lbl_COLUMN_12" runat="server"></asp:Literal>%</span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="vertical-align: top;">
                        <div class="NoiDung_Footer">
                            <div style="display: table-cell; vertical-align: middle; font-size: 15px;">
                                &copy; Bản quyền thuộc về Tòa án nhân dân tối cao.
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript">
            function KeypressUp_Enter(event) {
                if (event.which === 13 || event.keyCode === 13 || event.key === "Enter") {
                    document.getElementById('<%=lbtCallDanhSachThamPhan.ClientID %>').click();
                }
            }
            function Redirect_To_DanhSachThamPhan() {
                document.getElementById('<%=lbtCallDanhSachThamPhan.ClientID %>').click();
            }
            function Redirect_To_Page2_SoTham() {
                document.getElementById('<%=lbtCallPage2_SoTham.ClientID %>').click();
            }
            function Redirect_To_Page2_PhucTham() {
                document.getElementById('<%=lbtCallPage2_PhucTham.ClientID %>').click();
            }
            function Redirect_To_Page2_GDT() {
                document.getElementById('<%=lbtCallPage2_GDT.ClientID %>').click();
            }
            function Redirect_To_Page2_BAQD() {
                document.getElementById('<%=lbtCallPage2_BAQD.ClientID %>').click();
            }
            function Redirect_To_Page2_BAQD_Puplic() {
                document.getElementById('<%=lbtCallPage2_BAQD_Public.ClientID %>').click();
            }
        </script>
    </form>
</body>
</html>
