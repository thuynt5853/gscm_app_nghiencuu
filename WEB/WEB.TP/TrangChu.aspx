<%@ Page Language="C#" MasterPageFile="~/MasterPages/AN_PHI.Master" AutoEventWireup="true" CodeBehind="TrangChu.aspx.cs" Inherits="WEB.TP.TrangChu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content_form" style="margin-bottom: 30px;">
        <div class="leftzone">
            <div class="leftmenu">
                <div class="leftmenu_header arrow">
                    <span>Thống kê</span>
                    <div style="float:right;margin-top:7px;margin-right:15px;">
                        <asp:ImageButton ID="cmd_load" ImageUrl="/UI/img/icons8-refresh-26.png" ToolTip="Tải lại dữ liệu thông kê này" runat="server" OnClick="cmd_load_Click" />
                    </div>
                </div>
                <div class="leftmenu_content">
                    <ul class="thongke">
                        <li>Tổng số thông báo: <b style="font-size: 12pt;">
                            <asp:Label ID="lbl_V_COUNT_ALL" runat="server" Text=""></asp:Label></b></li>
                        <li>Tổng số thông báo đã nộp: <b style="font-size: 12pt; margin-left: 5px;">
                            <asp:Label ID="lbl_V_COUNT_DANOP" runat="server" Text=""></asp:Label></b></li>
                        <li>Tổng số thông báo chưa nộp : <b style="font-size: 12pt; margin-left: 5px;">
                            <asp:Label ID="lbl_V_COUNT_CHUANOP" runat="server" Text=""></asp:Label></b></li>
                        <li>Tổng số vụ việc hoàn trả: <b style="font-size: 12pt; margin-left: 5px;">
                            <asp:Label ID="lbl_V_VUVIEC_HOANTRA" runat="server" Text=""></asp:Label></b></li>
                        <li>Tổng số vụ việc đình chỉ: <b style="font-size: 12pt; margin-left: 5px;">
                            <asp:Label ID="lbl_V_COUNT_DINHCHI" runat="server" Text=""></asp:Label></b></li>
                    </ul>
                </div>
            </div>
            <div class="leftmenu">
                <div class="leftmenu_header arrow" style="height: 1px;"></div>
                <div class="leftmenu_content">
                    <ul class="thongke">
                        <li>Tổng số phải thu:<b style="font-size: 12pt; margin-left: 5px;"><asp:Label ID="lbl_V_TIEN_ALL" runat="server" Text=""></asp:Label>
                        </b></li>
                        <li>Tổng số tiền đã thu:<b style="font-size: 12pt; margin-left: 5px;"><asp:Label ID="lbl_V_TIEN_DANOP" runat="server" Text=""></asp:Label>
                        </b></li>
                        <li>Tổng số tiền chưa nộp:<b style="font-size: 12pt; margin-left: 5px;"><asp:Label ID="lbl_V_TIEN_CHUANOP" runat="server" Text=""></asp:Label>
                        </b></li>
                        <li>Tổng số tiền hoàn trả:<b style="font-size: 12pt; margin-left: 5px;"><asp:Label ID="lbl_V_TIEN_HOANTRA" runat="server" Text=""></asp:Label>
                        </b></li>
                        <li>Tổng số tiền đình chỉ nộp:<b style="font-size: 12pt; margin-left: 5px;"><asp:Label ID="lbl_V_TIEN_DINHCHI" runat="server" Text=""></asp:Label>
                        </b></li>
                    </ul>
                </div>
            </div>
            <%--<asp:Literal ID="Li_thongke" runat="server"></asp:Literal>--%>
            <div class="leftmenu">
                <div class="leftmenu_header arrow" style="">
                    <span style="color: #ffffff;">Điện thoại liên hệ: 02432.444.269</span>
                </div>
            </div>
        </div>
        <style>
            .thongke li {
                font-size: 16px;
                font-family: Arial;
            }
        </style>
        <div class="rightzone">
            <div class="content_body">
            </div>
        </div>
    </div>
</asp:Content>
