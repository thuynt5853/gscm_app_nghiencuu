<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="ChiTietDKNhanVB.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.ChiTietDKNhanVB" %>


<%--<%@ Register Src="~/Personnal/UC/Help.ascx" TagPrefix="uc1" TagName="Help" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .table1 tr, td {
            padding-bottom: 10px;
            padding-left: 0px;
        }
    </style>
    <div class="thongtin_lienhe" style="margin-top: 0px;">
        <div class="right_full_width_head">
            <a style="color: white;" class="dowload_head">Chi tiết Đăng ký</a>
            <div class="dangky_head_right">
                <div class="tooltip">
                    <a href="/Personnal/DsDangKyNhanVBTongDat.aspx">
                        <img src="../UI/img/top_back.png" style="width: 28px; float: right;" />
                    </a>
                    <span class="tooltiptext  tooltip-bottom">Quay lại</span>
                </div>
                <%--<uc1:Help runat="server" id="Help" />--%>
            </div>
        </div>

        <div class="dangky_content">
            <div id="dangkynhanvb_tongdat">
                <div class="msg_warning" style="float: left; font-style: italic; margin-top: 0px">
                    <asp:Literal ID="lttGhichu" runat="server"></asp:Literal>
                </div>
                <!------------------------------------------->
                <div class="right_full_width head_title_center">
                    <span>Cộng hòa xã hội chủ nghĩa Việt nam</span>
                </div>
                <div class="right_full_width head_title_center" style="margin-bottom: 15px;">
                    <span style="text-transform: none;">Độc lập - Tự do - Hạnh phúc</span>
                    <span style="border-bottom:solid 1px gray;width:24%;float:left;margin-left:38%;margin-top:5px;"></span>
                </div>
                <!------------------------------>
                <div class="right_full_width head_title_center">
                    <span style="font-size: 15pt;">Đăng ký nhận văn bản, thông báo của Tòa án</span>
                </div>
                <!------------------------------>
                <div class="dk_fullwidth">
                    <table class="table1">
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <b style="font-size: 13pt; margin-bottom: 10px;">Kính gửi:<asp:Literal ID="lttToaAn" runat="server"></asp:Literal>
                                </b>

                            </td>
                        </tr>
                        <tr>
                            <td>Tên tôi là:
                                   <b>
                                       <asp:Literal ID="lttDuongSu" runat="server"></asp:Literal></b></td>
                            <td>Số CMND/ Thẻ căn cước/ Hộ chiếu:
                                   <b>
                                       <asp:Literal ID="lttCMND" runat="server"></asp:Literal></b></td>
                        </tr>
                        <tr>
                            <td>Ngày đăng ký:
                                    <b>
                                        <asp:Literal ID="lttNgayDK" runat="server"></asp:Literal>
                                    </b>
                            </td>
                            <td>Mã đăng ký:
                                    <b>
                                        <asp:Literal ID="lttMaDangKy" runat="server"></asp:Literal>
                                    </b>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2"><b>Yêu cầu Tòa án gửi văn bản, thông báo mới của các vụ việc sau cho tôi:</b></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="CSSTableGenerator">
                                    <table>
                                        <tr id="row_header">
                                            <td style="width: 40px;">STT</td>
                                            <td style="width: 80px;">Mã vụ việc</td>
                                            <td>Tên vụ việc</td>
                                            <td style="width: 100px;">Loại vụ việc</td>
                                            <td style="width: 100px;">Tư cách tố tụng</td>

                                            <td style="width: 100px;">Trạng thái</td>
                                        </tr>
                                        <asp:Repeater ID="rpt" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <div style="text-align: center;"><%#Eval("STT") %></div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: justify; float: left;"><%#Eval("MaVuViec") %></div>
                                                    </td>
                                                    <td><%#Eval("TenVuViec") %></td>
                                                    <td><%#Eval("LoaiVuAn") %></td>
                                                    <td><%#Eval("TenTuCachToTung") %></td>
                                                    <td><%#Eval("TrangThaiDuyet") %></td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <!------------------------------>


                <div class="fullwidth" style="text-align: center;">
                    <asp:Literal runat="server" ID="lbthongbao"></asp:Literal><br />
                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput print"
                        Text="In đơn" OnClientClick="show_popup_in_dk()" />
                    <a href="/Personnal/DsDangKyNhanVBTongDat.aspx" class="buttoninput quaylai">Quay lại</a>
                </div>
            </div>
        </div>
    </div>
    <script>
        function show_popup_in_dk() {
            var dangkyID = '<%=GroupDKyID%>';
            //alert(dangkyID)
            var para = "";
            if (dangkyID != '')
                para += "?groupid=" + dangkyID;
            var pageURL = "/Personnal/InBC.aspx" + para;

            //alert(pageURL);
            var page_width = 880;
            var page_height = 550;
            var left = (screen.width / 2) - (page_width / 2);
            var top = (screen.height / 2) - (page_height / 2);
            var targetWin = window.open(pageURL, 'In đơn đăng ký nhận văn bản, thông báo từ Tòa án'
                , 'toolbar=no,scrollbars=yes,resizable=no'
                + ', width = ' + page_width
                + ', height=' + page_height + ', top=' + top + ', left=' + left);
            return targetWin;
        }
    </script>
</asp:Content>
