<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowHelp.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.ShowHelp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../UI/css/jquery-ui.css" rel="stylesheet" />
    <link href="../../UI/css/style.css" rel="stylesheet" />

    <title>Hướng dẫn</title>
    <style>
        #go_top::before {
            -moz-border-bottom-colors: none;
            -moz-border-left-colors: none;
            -moz-border-right-colors: none;
            -moz-border-top-colors: none;
            border-color: transparent transparent white;
            border-image: none;
            border-style: solid;
            border-width: 11px;
            content: "";
            height: 0;
            left:4px;
            position: absolute;
            top: -8px;
            width: 0;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        #go_top::after {
            background-color: white;
            content: "";
            height: 12px;
            left: 10px;
            position: absolute;
            top: 14px;
            width: 10px;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        #go_top {
            background-color: #d02629;
            border: 1px solid #0031bc;
            border-radius: 4px;
            bottom: 15px;
            box-shadow: 0 0 3px rgba(0, 0, 0, 0.2);
            display: block;
            height: 31px;
            position: fixed;
            right: 15px;
            width: 31px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="thongtin_lienhe" style="margin-top: 10px; margin-bottom: 10px; margin-left: 2%; width: 96%;">

            <div class="right_full_width_head2" style="width:100%;">
                <div class="dangky_head_title" style="margin-left: 0px;">
                    <asp:Literal ID="lstTieuDe" runat="server"></asp:Literal>
                </div>
                <div class="dangky_head_right">
                    <div class="tooltip">
                        <a href="javascript:;" onclick="window.close();">
                            <img src="../../UI/img/close.png" alt="Đóng" />
                        </a>
                        <span class="tooltiptext  tooltip-bottom">Đóng</span>
                    </div>
                </div>
            </div>
            <div style="border-top: solid 1px #c5c5c5; padding: 10px;">
                <div class="sapo_tin">
                    <asp:Literal ID="lstTrichDan" runat="server"></asp:Literal>
                </div>
                <div class="detail_content_news">
                    <asp:Literal ID="lstNoiDung" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
        <a href="#" id="go_top"></a>
        <script language="JavaScript" type="text/javascript">
            (funcion(){
                // Cuộn trang lên với scrollTop
                $('#go_top').click(function () {
                    $('body,html').animate({ scrollTop: 0 }, 400);
                    return false;
                })
            })(jQuery)

            // Ẩn hiện icon go-top
            $(window).scroll(function () {
                if ($(window).scrollTop() == 0) {
                    $('#go_top').stop(false, true).fadeOut(600);
                } else {
                    $('#go_top').stop(false, true).fadeIn(600);
                }
            });
</script>
    </form>
</body>
</html>
