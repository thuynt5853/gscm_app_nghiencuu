<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="WEB.TP.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style type="text/css">
            .container_card {
                float: left;
                font-family: times New Roman;
                font-size: 12pt;
                width: 1010px;
                margin: 0px;
            }

            .container_card {
                margin-left: 15px;
                margin-top: 56px;
            }

            .contai_one {
                width: 452px;
                height: 286px;
                float: left;
                text-align: center;
                margin-top: 17px;
                margin-left: 19px;
            }

            .data_item {
                width: 470px;
                float: left;
                text-align: center;
            }

                .data_item p {
                    float: left;
                    width: 310px;
                    font-weight: bold;
                    margin: 0px;
                    margin-left: 155px;
                    height: 18px;
                }

            .date_contai_card {
                width: 149px !important;
                left: 143px !important;
                font-size: 9pt;
                top: 8px;
                position: relative;
                font-style: italic;
            }

            .day_card {
                left: 16px;
                position: absolute;
            }

            .month_card {
                left: 60px;
                position: absolute;
            }

            .year_card {
                left: 118px;
                position: absolute;
            }

            .date_contai_card_1 {
                width: 160px !important;
                left: 144px;
                font-size: 9pt;
                top: 2px;
                position: relative;
                font-style: italic;
            }

            .day_card_1 {
                left: 16px;
                position: absolute;
            }

            .month_card_1 {
                left: 61px;
                position: absolute;
            }

            .year_card_1 {
                left: 119px;
                position: absolute;
            }

            .date_contai_card_2 {
                width: 205px !important;
                left: 150px;
                font-size: 9pt;
                top: 3px;
                position: relative;
                font-style: italic;
            }

            .day_card_2 {
                left: 15px;
                position: absolute;
            }

            .month_card_2 {
                left: 61px;
                position: absolute;
            }

            .year_card_2 {
                left: 120px;
                position: absolute;
            }
        </style>
        <body>
            <div class="container_card">
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.01.001</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Nguyễn Hữu Chính</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">07/11/1963</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán cao cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Chánh án</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.01.002</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Đào Sỹ Hùng</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">07/05/1965</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán cao cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh án</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.01.003</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Nguyễn Tuấn Vũ</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">10/03/1965</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh án</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.01.004</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Lưu Tuấn Dũng</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">29/01/1971</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh án</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.01.005</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Đào Bá Sơn</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">01/10/1962</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh án</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.02.005</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Trần Thị Thu Nam</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">14/10/1973</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh Văn phòng</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.03.001</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Trương Việt Toàn</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">21/02/1961</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh tòa</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.03.002</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Nguyễn Từ Bắc</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">26/09/1961</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh tòa</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div style="page-break-inside: avoid"></div>
                <div style="float: left; margin-top: 108px; width: 1010px;"></div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.03.003</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Ngô Thị Ánh</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">21/11/1974</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Phó Chánh tòa</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
                <div class="contai_one">
                    <div class="data_item" style="">
                        <p style="margin-top: 57px;"><span style="padding-left: 21px;">TA.54.03.004</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="margin-top: 4px;">Tạ Phú Cường</p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">21/05/1960</p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""><span style="padding-left: 10px;">Thẩm phán trung cấp</span></p>
                    </div>
                    <div class="data_item" style="">
                        <p style=""></p>
                    </div>
                    <div class="data_item" style="">
                        <p style="">Thành phố Hà Nội</p>
                    </div>
                    <div class="data_item" style="">
                        <p class="date_contai_card" style=""><span class="day_card" style=""></span><span class="month_card" style=""></span><span class="year_card" style=""></span></p>
                    </div>
                </div>
            </div>
        </body>
    </form>
</body>
</html>
