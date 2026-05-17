<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uThongKe.ascx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.uThongKe" %>

<style>
    .title_group {
        text-transform: uppercase;
        font-weight: bold;
        float: left;
        width: 100%;
    }

    .table2 .header2 {
        text-align: center;
        vertical-align: middle;
        font-weight: bold;
    }

        .table2 td, .table2 .header2 td {
            font-style: normal;
        }

    .tong_cong_tp, .tong_cong_tp b, .tong_cong_tp a {
        text-align: center;
        font-weight: bold;
        vertical-align: middle;
        color: red !important;
    }

    .buttoninput_uTK {
        background: url("../UI/img/bg_btns.png");
        color: #444;
        height: 25px;
        width: 120px;
        border: 1px solid #9d9999;
        min-width: 80px;
        font-weight: bold;
        padding-left: 15px;
        padding-right: 15px;
        cursor: pointer;
        border-radius: 3px 3px 3px 3px;
    }
</style>
<asp:Panel ID="pn" runat="server" Visible="false">
    <asp:HiddenField ID="hi_LanhdaoVuID" Value="0" runat="server" />
    <asp:HiddenField ID="hi_ThamtravienID" Value="0" runat="server" />
    <asp:HiddenField ID="hi_ThamPhan_ID" Value="" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div class="thongkechung">
        <asp:Panel ID="pnVuGDKT" runat="server">
            <div style="width: 100%; font-weight: bold;">
                SỐ VỤ ÁN ĐANG GIẢI QUYẾT
                <asp:LinkButton ID="lbtTongSo" Enabled="false" runat="server" ForeColor="#0e7eee" Font-Size="18px" Font-Bold="true" Text="0"></asp:LinkButton>
            </div>
            <!------------------------------------->
            <asp:Panel ID="pnThongKechung" runat="server">
                <table class="table2" style="width: 100%" border="1">
                    <tr class="header2">
                        <td colspan="<%=ColSpan %>" style="color: red; font-size: 15px;">
                            <div style="font-size: 15px; float: left; text-align: center; width: 100%;">
                                <span style="font-size: 15px;">THỐNG KÊ VỤ ÁN ĐANG GIẢI QUYẾT</span>
                                <div style="float: right;">
                                    <asp:Button ID="btnXemBC_Vu" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_Vu_Click" />
                                </div>
                            </div>
                        </td>

                    </tr>
                    <tr class="header2">
                        <td rowspan="3">LOẠI ÁN </td>
                        <td style="width: 45px;" rowspan="3" runat="server" id="cellChung_NoPCTTV">Chưa phân công TTV</td>
                        <td style="width: 45px;" rowspan="3">
                            <asp:Literal ID="lttTKChung_PCTTV" runat="server" Text="Đã phân công TTV"></asp:Literal></td>
                        <td colspan="2">Hồ sơ</td>
                        <td colspan="10">Quá trình giải quyết</td>
                        <td colspan="2">Dự thảo</td>
                        <td style="width: 45px;" rowspan="3">Hoãn thi hành án</td>
                    </tr>
                    <tr class="header2">
                        <td style="width: 45px;" rowspan="2">Đã có</td>
                        <td style="width: 45px;" rowspan="2">Chưa có</td>
                        <td style="width: 45px;" rowspan="2">Chưa có tờ trình
                            <br />
                            <i style="font-weight: 100; text-align: left;">(Đã có hồ sơ)</i></td>
                        <td style="width: 45px;" rowspan="2">Phó Vụ trưởng</td>
                        <td style="width: 45px;" rowspan="2">Vụ trưởng</td>
                        <td style="width: 45px;" colspan="2">Thẩm phán</td>
                        <td style="width: 45px;" rowspan="2">Xác minh, Bổ sung</td>
                        <td style="width: 45px;" rowspan="2">Phó CA</td>
                        <td style="width: 45px;" rowspan="2">Tổ TP</td>
                        <td style="width: 45px;" rowspan="2">Chánh án</td>
                        <td style="width: 45px;" rowspan="2">HĐ Thẩm Phán</td>
                        <td style="width: 45px;" rowspan="2">Trả lời đơn</td>
                        <td style="width: 45px;" rowspan="2">Kháng nghị</td>
                    </tr>
                    <tr class="header2">
                        <td style="width: 50px;">Chưa có ý kiến</td>
                        <td style="width: 45px;">Đã có ý kiến</td>
                    </tr>
                    <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                        <td style="font-style: italic;"></td>
                        <td style="font-style: italic;" runat="server" id="cellChung_NoPCTTV_Column">1</td>
                        <td style="font-style: italic;">2</td>
                        <td style="font-style: italic;">3</td>
                        <td style="font-style: italic;">4</td>
                        <td style="font-style: italic;">5</td>
                        <td style="font-style: italic;">6</td>
                        <td style="font-style: italic;">7</td>
                        <td style="font-style: italic;">8</td>
                        <td style="font-style: italic;">9</td>
                        <td style="font-style: italic;">10</td>
                        <td style="font-style: italic;">11</td>
                        <td style="font-style: italic;">12</td>
                        <td style="font-style: italic;">13</td>
                        <td style="font-style: italic;">14</td>
                        <td style="font-style: italic;">15</td>
                        <td style="font-style: italic;">16</td>
                        <td style="font-style: italic;">17</td>
                    </tr>
                    <asp:Repeater ID="rptThongke" runat="server" OnItemCommand="rptThongke_ItemCommand">
                        <HeaderTemplate></HeaderTemplate>
                        <ItemTemplate>
                            <tr class="row_center">
                                <td class="row_center">
                                    <b style="color: #0e7eee;"><%#Eval("TENLOAIAN") %></b></td>
                                <td class="row_center" style='<%=(ShowCell==1)? "display:''": "display:none;"%>'>
                                    <asp:LinkButton ID="LinkButton0" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton2" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton13" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_4" Text='<%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton29" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_5" Text='<%# (Eval("COLUMN_5")+"")=="0"?"":Eval("COLUMN_5")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton3" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_6" Text='<%# (Eval("COLUMN_6")+"")=="0"?"":Eval("COLUMN_6")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton4" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_7" Text='<%# (Eval("COLUMN_7")+"")=="0"?"":Eval("COLUMN_7")  %>'></asp:LinkButton></td>

                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton5" runat="server"
                                        ForeColor="#0e7eee" Font-Bold="true"
                                        CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_8" Text='<%# (Eval("COLUMN_8")+"")=="0"?"":Eval("COLUMN_8")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton30" runat="server" ForeColor="#0e7eee"
                                        Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>'
                                        CommandName="COLUMN_9" Text='<%# (Eval("COLUMN_9")+"")=="0"?"":Eval("COLUMN_9")  %>'></asp:LinkButton></td>

                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton10" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_10" Text='<%# (Eval("COLUMN_10")+"")=="0"?"":Eval("COLUMN_10")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton6" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_11" Text='<%# (Eval("COLUMN_11")+"")=="0"?"":Eval("COLUMN_11")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton8" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_12" Text='<%# (Eval("COLUMN_12")+"")=="0"?"":Eval("COLUMN_12")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton7" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_13" Text='<%# (Eval("COLUMN_13")+"")=="0"?"":Eval("COLUMN_13")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton9" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_14" Text='<%# (Eval("COLUMN_14")+"")=="0"?"":Eval("COLUMN_14")  %>'></asp:LinkButton></td>

                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton11" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_15" Text='<%# (Eval("COLUMN_15")+"")=="0"?"":Eval("COLUMN_15")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton12" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_16" Text='<%# (Eval("COLUMN_16")+"")=="0"?"":Eval("COLUMN_16")  %>'></asp:LinkButton></td>
                                <td class="row_center">
                                    <asp:LinkButton ID="LinkButton14" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_17" Text='<%# (Eval("COLUMN_17")+"")=="0"?"":Eval("COLUMN_17")  %>'></asp:LinkButton></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></FooterTemplate>
                    </asp:Repeater>
                </table>
            </asp:Panel>
        </asp:Panel>
        <asp:Panel ID="pnQuocHoi_ThoiHieu" runat="server">
            <!------------------------------------->
            <table class="table2" style="width: 100%; margin-top: 15px;" border="1">
                <tr class="header2">
                    <td colspan="<%=ColSpan%>" style="color: red; font-size: 15px;">THỐNG KÊ VỤ ÁN QUỐC HỘI ĐANG GIẢI QUYẾT</td>
                </tr>
                <tr class="header2">
                    <td rowspan="3">LOẠI ÁN </td>
                    <td style="width: 45px;" rowspan="3" runat="server" id="cellQH_NoPCTTV">Chưa phân công TTV</td>
                    <td style="width: 45px;" rowspan="3">
                        <asp:Literal ID="lttTKQH_PCTTV" runat="server" Text="Đã phân công TTV"></asp:Literal></td>
                    <td colspan="2">Hồ sơ</td>
                    <td colspan="10">Quá trình giải quyết</td>
                    <td colspan="2">Dự thảo</td>
                    <td style="width: 45px;" rowspan="3">Hoãn thi hành án</td>
                </tr>
                <tr class="header2">
                    <td style="width: 45px;" rowspan="2">Đã có</td>
                    <td style="width: 45px;" rowspan="2">Chưa có</td>
                    <td style="width: 45px;" rowspan="2">Chưa có tờ trình<br />
                        <i style="font-weight: 100; text-align: left;">(Đã có hồ sơ)</i></td>
                    <td style="width: 45px;" rowspan="2">Phó Vụ trưởng</td>
                    <td style="width: 45px;" rowspan="2">Vụ trưởng</td>
                    <td style="width: 45px;" colspan="2">Thẩm phán</td>
                    <td style="width: 45px;" rowspan="2">Xác minh, Bổ sung</td>
                    <td style="width: 45px;" rowspan="2">Phó CA</td>
                    <td style="width: 45px;" rowspan="2">Tổ TP</td>
                    <td style="width: 45px;" rowspan="2">Chánh án</td>
                    <td style="width: 45px;" rowspan="2">HĐ Thẩm Phán</td>
                    <td style="width: 45px;" rowspan="2">Trả lời đơn</td>
                    <td style="width: 45px;" rowspan="2">Kháng nghị</td>
                </tr>
                <tr class="header2">
                    <td style="width: 50px;">Chưa có ý kiến</td>
                    <td style="width: 45px;">Đã có ý kiến</td>
                </tr>
                <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                    <td style="font-style: italic;"></td>
                    <td style="font-style: italic;" runat="server" id="cellChung_NoPCTTV_Column_QH">1</td>
                    <td style="font-style: italic;">2</td>
                    <td style="font-style: italic;">3</td>
                    <td style="font-style: italic;">4</td>
                    <td style="font-style: italic;">5</td>
                    <td style="font-style: italic;">6</td>
                    <td style="font-style: italic;">7</td>
                    <td style="font-style: italic;">8</td>
                    <td style="font-style: italic;">9</td>
                    <td style="font-style: italic;">10</td>
                    <td style="font-style: italic;">11</td>
                    <td style="font-style: italic;">12</td>
                    <td style="font-style: italic;">13</td>
                    <td style="font-style: italic;">14</td>
                    <td style="font-style: italic;">15</td>
                    <td style="font-style: italic;">16</td>
                    <td style="font-style: italic;">17</td>
                </tr>
                <asp:Repeater ID="rptAnQuocHoi" runat="server" OnItemCommand="rptAnQuocHoi_ItemCommand">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="row_center">
                            <td class="row_center">
                                <b style="color: #0e7eee;"><%#Eval("TENLOAIAN") %></b></td>
                            <td class="row_center" style='<%=(ShowCell==1)? "display:''": "display:none;"%>'>
                                <asp:LinkButton ID="LinkButton0" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton2" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton13" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_4" Text='<%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton29" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_5" Text='<%# (Eval("COLUMN_5")+"")=="0"?"":Eval("COLUMN_5")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton3" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_6" Text='<%# (Eval("COLUMN_6")+"")=="0"?"":Eval("COLUMN_6")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton4" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_7" Text='<%# (Eval("COLUMN_7")+"")=="0"?"":Eval("COLUMN_7")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton5" runat="server"
                                    ForeColor="#0e7eee" Font-Bold="true"
                                    CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_8" Text='<%# (Eval("COLUMN_8")+"")=="0"?"":Eval("COLUMN_8")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton30" runat="server" ForeColor="#0e7eee"
                                    Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>'
                                    CommandName="COLUMN_9" Text='<%# (Eval("COLUMN_9")+"")=="0"?"":Eval("COLUMN_9")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton10" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_10" Text='<%# (Eval("COLUMN_10")+"")=="0"?"":Eval("COLUMN_10")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton6" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_11" Text='<%# (Eval("COLUMN_11")+"")=="0"?"":Eval("COLUMN_11")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton8" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_12" Text='<%# (Eval("COLUMN_12")+"")=="0"?"":Eval("COLUMN_12")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton7" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_13" Text='<%# (Eval("COLUMN_13")+"")=="0"?"":Eval("COLUMN_13")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton9" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_14" Text='<%# (Eval("COLUMN_14")+"")=="0"?"":Eval("COLUMN_14")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton11" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_15" Text='<%# (Eval("COLUMN_15")+"")=="0"?"":Eval("COLUMN_15")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton12" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_16" Text='<%# (Eval("COLUMN_16")+"")=="0"?"":Eval("COLUMN_16")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton14" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_17" Text='<%# (Eval("COLUMN_17")+"")=="0"?"":Eval("COLUMN_17")  %>'></asp:LinkButton></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
            <!------------------------------------->
            <table class="table2" style="width: 100%; margin-top: 15px;" border="1">
                <tr class="header2">
                    <td colspan="<%=ColSpan%>" style="color: red; font-size: 15px;">THỐNG KÊ VỤ ÁN CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG</td>
                </tr>
                <tr class="header2">
                    <td rowspan="3">LOẠI ÁN </td>
                    <td style="width: 45px;" rowspan="3" runat="server" id="cellTH_NoPCTTV">Chưa phân công TTV</td>
                    <td style="width: 45px;" rowspan="3">
                        <asp:Literal ID="lttTKTH_PCTTV" runat="server" Text="Đã phân công TTV"></asp:Literal></td>
                    <td colspan="2">Hồ sơ</td>
                    <td colspan="10">Quá trình giải quyết</td>
                    <td colspan="2">Dự thảo</td>
                    <td style="width: 45px;" rowspan="3">Hoãn thi hành án</td>
                </tr>
                <tr class="header2">
                    <td style="width: 45px;" rowspan="2">Đã có</td>
                    <td style="width: 45px;" rowspan="2">Chưa có</td>
                    <td style="width: 45px;" rowspan="2">Chưa có tờ trình<br />
                        <i style="font-weight: 100; text-align: left;">(Đã có hồ sơ)</i></td>
                    <td style="width: 45px;" rowspan="2">Phó Vụ trưởng</td>
                    <td style="width: 45px;" rowspan="2">Vụ trưởng</td>
                    <td style="width: 45px;" colspan="2">Thẩm phán</td>
                    <td style="width: 45px;" rowspan="2">Xác minh, Bổ sung</td>
                    <td style="width: 45px;" rowspan="2">Phó CA</td>
                    <td style="width: 45px;" rowspan="2">Tổ TP</td>
                    <td style="width: 45px;" rowspan="2">Chánh án</td>
                    <td style="width: 45px;" rowspan="2">HĐ Thẩm Phán</td>
                    <td style="width: 45px;" rowspan="2">Trả lời đơn</td>
                    <td style="width: 45px;" rowspan="2">Kháng nghị</td>
                </tr>
                <tr class="header2">
                    <td style="width: 50px;">Chưa có ý kiến</td>
                    <td style="width: 45px;">Đã có ý kiến</td>
                </tr>
                <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                    <td style="font-style: italic;"></td>
                    <td style="font-style: italic;" runat="server" id="cellChung_NoPCTTV_Column_TH">1</td>
                    <td style="font-style: italic;">2</td>
                    <td style="font-style: italic;">3</td>
                    <td style="font-style: italic;">4</td>
                    <td style="font-style: italic;">5</td>
                    <td style="font-style: italic;">6</td>
                    <td style="font-style: italic;">7</td>
                    <td style="font-style: italic;">8</td>
                    <td style="font-style: italic;">9</td>
                    <td style="font-style: italic;">10</td>
                    <td style="font-style: italic;">11</td>
                    <td style="font-style: italic;">12</td>
                    <td style="font-style: italic;">13</td>
                    <td style="font-style: italic;">14</td>
                    <td style="font-style: italic;">15</td>
                    <td style="font-style: italic;">16</td>
                    <td style="font-style: italic;">17</td>
                </tr>
                <asp:Repeater ID="rptAnThoiHieu" runat="server" OnItemCommand="rptAnThoiHieu_ItemCommand">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="row_center">
                            <td class="row_center">
                                <b style="color: #0e7eee;"><%#Eval("TENLOAIAN") %></b></td>
                            <td class="row_center" style='<%=(ShowCell==1)? "display:''": "display:none;"%>'>
                                <asp:LinkButton ID="LinkButton0" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton2" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton13" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_4" Text='<%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton29" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_5" Text='<%# (Eval("COLUMN_5")+"")=="0"?"":Eval("COLUMN_5")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton3" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_6" Text='<%# (Eval("COLUMN_6")+"")=="0"?"":Eval("COLUMN_6")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton4" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_7" Text='<%# (Eval("COLUMN_7")+"")=="0"?"":Eval("COLUMN_7")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton5" runat="server"
                                    ForeColor="#0e7eee" Font-Bold="true"
                                    CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_8" Text='<%# (Eval("COLUMN_8")+"")=="0"?"":Eval("COLUMN_8")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton30" runat="server" ForeColor="#0e7eee"
                                    Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>'
                                    CommandName="COLUMN_9" Text='<%# (Eval("COLUMN_9")+"")=="0"?"":Eval("COLUMN_9")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton10" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_10" Text='<%# (Eval("COLUMN_10")+"")=="0"?"":Eval("COLUMN_10")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton6" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_11" Text='<%# (Eval("COLUMN_11")+"")=="0"?"":Eval("COLUMN_11")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton8" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_12" Text='<%# (Eval("COLUMN_12")+"")=="0"?"":Eval("COLUMN_12")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton7" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_13" Text='<%# (Eval("COLUMN_13")+"")=="0"?"":Eval("COLUMN_13")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton9" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_14" Text='<%# (Eval("COLUMN_14")+"")=="0"?"":Eval("COLUMN_14")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton11" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_15" Text='<%# (Eval("COLUMN_15")+"")=="0"?"":Eval("COLUMN_15")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton12" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_16" Text='<%# (Eval("COLUMN_16")+"")=="0"?"":Eval("COLUMN_16")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton14" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%# Eval("LOAIAN")  %>' CommandName="COLUMN_17" Text='<%# (Eval("COLUMN_17")+"")=="0"?"":Eval("COLUMN_17")  %>'></asp:LinkButton></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnThamphan" runat="server" Visible="false">
            <table class="table2" style="width: 100%;" border="1">
                <tr class="header2">
                    <td colspan="26" style="color: red;">
                        <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                            <asp:Label ID="lstTenThamphan" Font-Size="15px" runat="server"></asp:Label>
                            <div style="float: right;">
                                <asp:Button ID="btnXemBC_TP" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_TP_Click" />
                            </div>
                            <div style="float: right; margin-right: 8px;">
                                <asp:DropDownList ID="ddl_Load_year"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_year_SelectedIndexChanged"
                                    CssClass="chosen-select" runat="server" Width="130px">
                                </asp:DropDownList>
                            </div>
                            <div style="float: right; margin-right: 8px; text-align: left;">
                                <asp:DropDownList ID="ddlThamphan"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
                                    CssClass="chosen-select" runat="server" Width="180px">
                                </asp:DropDownList>
                            </div>
                        </div>
                    </td>
                </tr>
                <asp:Repeater ID="rptThamPhan" runat="server" OnItemCommand="rptThamPhan_ItemCommand" OnItemDataBound="rptThamPhan_ItemDataBound">
                    <HeaderTemplate>
                        <tr class="header2">
                            <td style="width: 80px;" rowspan="2">LOẠI ÁN </td>
                            <td style="width: 45px;" rowspan="2">Cũ còn lại của năm trước</td>
                            <td style="width: 45px;" rowspan="2">Tổng số vụ việc phải giải quyết trong năm<i style="font-weight: 100"> (đã bao gồm số liệu của cột 1)</i></td>
                            <td colspan="2">Phân công Thẩm tra viên</td>
                            <td colspan="2">Trạng thái hồ sơ</td>
                            <td style="width: 45px;" rowspan="2">Chưa có tờ trình<br />
                                <i style="font-weight: 100; text-align: left;">(Đã có hồ sơ)</i></td>
                            <td colspan="4">Giải quyết tờ trình</td>
                            <td style="width: 45px;" rowspan="2">Đã giải quyết xong</td>
                            <td style="width: 45px;" rowspan="2">Còn lại chưa giải quyết xong
                                <br />
                                <i style="font-weight: 100;">(bao gồm dự thảo TLĐ và dự thảo KN)</i></td>
                            <td colspan="5">Kết quả giải quyết đơn</td>
                            <td colspan="7">Xét xử Giám đốc thẩm</td>
                        </tr>
                        <tr class="header2">
                            <td style="width: 45px;">Đã phân công</td>
                            <td style="width: 45px;">Chưa phân công</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Có hồ sơ</td>
                            <td style="width: 45px;">Chưa có hồ sơ</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Chưa có ý kiến</td>
                            <td style="width: 45px;">Đã có ý kiến</td>
                            <td style="width: 45px;">Đã đăng ký lịch báo cáo Thẩm phán</td>
                            <td style="width: 45px;">Báo cáo Phó Chánh án, Tổ Thẩm phán, Chánh án, Hội đồng Thẩm phán</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Trả lời đơn</td>
                            <td style="width: 45px;">Kháng nghị</td>
                            <td style="width: 45px;">Xếp đơn</td>
                            <td style="width: 45px;">Đang dự thảo trả lời đơn</td>
                            <td style="width: 45px;">Đang dự thảo kháng nghị</td>

                            <!------------------------------------>
                            <td style="width: 45px;">Tổng số kháng nghị của Chánh án và Viện kiểm sát</td>
                            <td style="width: 45px;">Đã thụ lý xét xử GĐT</td>
                            <td style="width: 45px;">Chưa xét xử</td>
                            <td style="width: 45px;">Đã xét xử</td>
                            <td style="width: 45px;">Chủ tọa</td>
                            <td style="width: 45px;">Hội đồng toàn thể</td>
                            <td style="width: 45px;">Hội đồng 5</td>
                        </tr>
                        <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                            <td style="font-style: italic;"></td>
                            <td style="font-style: italic;">1</td>
                            <td style="font-style: italic;">2</td>
                            <td style="font-style: italic;">3</td>
                            <td style="font-style: italic;">4</td>
                            <td style="font-style: italic;">5</td>
                            <td style="font-style: italic;">6</td>
                            <td style="font-style: italic;">7</td>
                            <td style="font-style: italic;">8</td>
                            <td style="font-style: italic;">9</td>
                            <td style="font-style: italic;">10</td>
                            <td style="font-style: italic;">11</td>
                            <td style="font-style: italic;">12</td>
                            <td style="font-style: italic;">13</td>
                            <td style="font-style: italic;">14</td>
                            <td style="font-style: italic;">15</td>
                            <td style="font-style: italic;">16</td>
                            <td style="font-style: italic;">17</td>
                            <td style="font-style: italic;">18</td>
                            <td style="font-style: italic;">19</td>
                            <td style="font-style: italic;">20</td>
                            <td style="font-style: italic;">21</td>
                            <td style="font-style: italic;">22</td>
                            <td style="font-style: italic;">23</td>
                            <td style="font-style: italic;">24</td>
                            <td style="font-style: italic;">25</td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="row_center">
                            <td class="row_center">
                                <b style="color: #0e7eee;"><%#Eval("TenLoaiAn") %></b></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton31" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>

                            <!--------------TTV---------------------->
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton15" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton32" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton></td>

                            <!--------------Ho so---------------------->
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton16" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_4"
                                    Text='<%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton17" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_5"
                                    Text='<%# (Eval("COLUMN_5")+"")=="0"?"":Eval("COLUMN_5")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton18" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_6"
                                    Text='<%# (Eval("COLUMN_6")+"")=="0"?"":Eval("COLUMN_6")  %>'></asp:LinkButton></td>

                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton19" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_7" Text='<%# (Eval("COLUMN_7")+"")=="0"?"":Eval("COLUMN_7")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton38" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_8"
                                    Text='<%# (Eval("COLUMN_8")+"")=="0"?"":Eval("COLUMN_8")  %>'></asp:LinkButton></td>


                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton33" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_9"
                                    Text='<%# (Eval("COLUMN_9")+"")=="0"?"":Eval("COLUMN_9")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton20" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_10" Text='<%# (Eval("COLUMN_10")+"")=="0"?"":Eval("COLUMN_10")  %>'></asp:LinkButton></td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton21" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_11"
                                    Text='<%# (Eval("COLUMN_11")+"")=="0"?"":Eval("COLUMN_11")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton22" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_12"
                                    Text='<%# (Eval("COLUMN_12")+"")=="0"?"":Eval("COLUMN_12")  %>'></asp:LinkButton></td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton23" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_13"
                                    Text='<%# (Eval("COLUMN_13")+"")=="0"?"":Eval("COLUMN_13")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton41" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_14"
                                    Text='<%# (Eval("COLUMN_14")+"")=="0"?"":Eval("COLUMN_14")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton25" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_15"
                                    Text='<%# (Eval("COLUMN_15")+"")=="0"?"":Eval("COLUMN_15")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton26" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_16"
                                    Text='<%# (Eval("COLUMN_16")+"")=="0"?"":Eval("COLUMN_16")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton34" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_17"
                                    Text='<%# (Eval("COLUMN_17")+"")=="0"?"":Eval("COLUMN_17")  %>'></asp:LinkButton>
                            </td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton27" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_18"
                                    Text='<%# (Eval("COLUMN_18")+"")=="0"?"":Eval("COLUMN_18")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton28" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_19"
                                    Text='<%# (Eval("COLUMN_19")+"")=="0"?"":Eval("COLUMN_19")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton35" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_20"
                                    Text='<%# (Eval("COLUMN_20")+"")=="0"?"":Eval("COLUMN_20")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton36" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_21"
                                    Text='<%# (Eval("COLUMN_21")+"")=="0"?"":Eval("COLUMN_21")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton37" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_22"
                                    Text='<%# (Eval("COLUMN_22")+"")=="0"?"":Eval("COLUMN_22")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton39" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_23"
                                    Text='<%# (Eval("COLUMN_23")+"")=="0"?"":Eval("COLUMN_23")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton40" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_24"
                                    Text='<%# (Eval("COLUMN_24")+"")=="0"?"":Eval("COLUMN_24")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton42" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_25"
                                    Text='<%# (Eval("COLUMN_25")+"")=="0"?"":Eval("COLUMN_25")  %>'></asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnQuocHoi_ThoiHieu_TP" runat="server" Visible="false">
            <!------------------------------------->
            <table class="table2" style="width: 100%; margin-top: 15px;" border="1">
                <tr class="header2">
                    <td colspan="26" style="color: red;">
                        <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                            THỐNG KÊ CÁC VỤ ÁN CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI
                        </div>
                    </td>
                </tr>
                <asp:Repeater ID="rptAnQuocHoi_tp" runat="server" OnItemCommand="rptAnQuocHoi_tp_ItemCommand" OnItemDataBound="rptAnQuocHoi_tp_ItemDataBound">
                    <HeaderTemplate>
                        <tr class="header2">
                            <td style="width: 80px;" rowspan="2">LOẠI ÁN </td>
                            <td style="width: 45px;" rowspan="2">Cũ còn lại của năm trước</td>
                            <td style="width: 45px;" rowspan="2">Tổng số vụ việc được phân công trong năm</td>
                            <td colspan="2">Phân công Thẩm tra viên</td>
                            <td colspan="2">Trạng thái hồ sơ</td>
                            <td style="width: 45px;" rowspan="2">Chưa có tờ trình<br />
                                <i style="font-weight: 100; text-align: left;">(Đã có hồ sơ)</i></td>
                            <td colspan="4">Giải quyết tờ trình</td>
                            <td style="width: 45px;" rowspan="2">Đã giải quyết xong</td>
                            <td style="width: 45px;" rowspan="2">Còn lại chưa giải quyết xong<br />
                                <i style="font-weight: 100;">(bao gồm dự thảo TLĐ và dự thảo KN)</i></td>
                            <td colspan="5">Kết quả giải quyết đơn</td>
                            <td colspan="7">Xét xử Giám đốc thẩm</td>
                        </tr>
                        <tr class="header2">
                            <td style="width: 45px;">Đã phân công</td>
                            <td style="width: 45px;">Chưa phân công</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Có hồ sơ</td>
                            <td style="width: 45px;">Chưa có hồ sơ</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Chưa có ý kiến</td>
                            <td style="width: 45px;">Đã có ý kiến</td>
                            <td style="width: 45px;">Đã đăng ký lịch báo cáo Thẩm phán</td>
                            <td style="width: 45px;">Báo cáo Phó Chánh án, Tổ Thẩm phán, Chánh án, Hội đồng Thẩm phán</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Trả lời đơn</td>
                            <td style="width: 45px;">Kháng nghị</td>
                            <td style="width: 45px;">Xếp đơn</td>
                            <td style="width: 45px;">Đang dự thảo trả lời đơn</td>
                            <td style="width: 45px;">Đang dự thảo kháng nghị</td>

                            <!------------------------------------>
                            <td style="width: 45px;">Tổng số kháng nghị của Chánh án và Viện kiểm sát</td>
                            <td style="width: 45px;">Đã thụ lý xét xử GĐT</td>
                            <td style="width: 45px;">Chưa xét xử</td>
                            <td style="width: 45px;">Đã xét xử</td>
                            <td style="width: 45px;">Chủ tọa</td>
                            <td style="width: 45px;">Hội đồng toàn thể</td>
                            <td style="width: 45px;">Hội đồng 5</td>
                        </tr>
                        <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                            <td style="font-style: italic;"></td>
                            <td style="font-style: italic;">1</td>
                            <td style="font-style: italic;">2</td>
                            <td style="font-style: italic;">3</td>
                            <td style="font-style: italic;">4</td>
                            <td style="font-style: italic;">5</td>
                            <td style="font-style: italic;">6</td>
                            <td style="font-style: italic;">7</td>
                            <td style="font-style: italic;">8</td>
                            <td style="font-style: italic;">9</td>
                            <td style="font-style: italic;">10</td>
                            <td style="font-style: italic;">11</td>
                            <td style="font-style: italic;">12</td>
                            <td style="font-style: italic;">13</td>
                            <td style="font-style: italic;">14</td>
                            <td style="font-style: italic;">15</td>
                            <td style="font-style: italic;">16</td>
                            <td style="font-style: italic;">17</td>
                            <td style="font-style: italic;">18</td>
                            <td style="font-style: italic;">19</td>
                            <td style="font-style: italic;">20</td>
                            <td style="font-style: italic;">21</td>
                            <td style="font-style: italic;">22</td>
                            <td style="font-style: italic;">23</td>
                            <td style="font-style: italic;">24</td>
                            <td style="font-style: italic;">25</td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="row_center">
                            <td class="row_center">
                                <b style="color: #0e7eee;"><%#Eval("TenLoaiAn") %></b></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton31" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>

                            <!--------------TTV---------------------->
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton15" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton32" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton></td>

                            <!--------------Ho so---------------------->
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton16" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_4"
                                    Text='<%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton17" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_5"
                                    Text='<%# (Eval("COLUMN_5")+"")=="0"?"":Eval("COLUMN_5")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton18" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_6"
                                    Text='<%# (Eval("COLUMN_6")+"")=="0"?"":Eval("COLUMN_6")  %>'></asp:LinkButton></td>

                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton19" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_7" Text='<%# (Eval("COLUMN_7")+"")=="0"?"":Eval("COLUMN_7")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton38" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_8"
                                    Text='<%# (Eval("COLUMN_8")+"")=="0"?"":Eval("COLUMN_8")  %>'></asp:LinkButton></td>


                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton33" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_9"
                                    Text='<%# (Eval("COLUMN_9")+"")=="0"?"":Eval("COLUMN_9")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton20" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_10" Text='<%# (Eval("COLUMN_10")+"")=="0"?"":Eval("COLUMN_10")  %>'></asp:LinkButton></td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton21" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_11"
                                    Text='<%# (Eval("COLUMN_11")+"")=="0"?"":Eval("COLUMN_11")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton22" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_12"
                                    Text='<%# (Eval("COLUMN_12")+"")=="0"?"":Eval("COLUMN_12")  %>'></asp:LinkButton></td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton23" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_13"
                                    Text='<%# (Eval("COLUMN_13")+"")=="0"?"":Eval("COLUMN_13")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton41" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_14"
                                    Text='<%# (Eval("COLUMN_14")+"")=="0"?"":Eval("COLUMN_14")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton25" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_15"
                                    Text='<%# (Eval("COLUMN_15")+"")=="0"?"":Eval("COLUMN_15")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton26" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_16"
                                    Text='<%# (Eval("COLUMN_16")+"")=="0"?"":Eval("COLUMN_16")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton34" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_17"
                                    Text='<%# (Eval("COLUMN_17")+"")=="0"?"":Eval("COLUMN_17")  %>'></asp:LinkButton>
                            </td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton27" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_18"
                                    Text='<%# (Eval("COLUMN_18")+"")=="0"?"":Eval("COLUMN_18")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton28" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_19"
                                    Text='<%# (Eval("COLUMN_19")+"")=="0"?"":Eval("COLUMN_19")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton35" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_20"
                                    Text='<%# (Eval("COLUMN_20")+"")=="0"?"":Eval("COLUMN_20")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton36" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_21"
                                    Text='<%# (Eval("COLUMN_21")+"")=="0"?"":Eval("COLUMN_21")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton37" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_22"
                                    Text='<%# (Eval("COLUMN_22")+"")=="0"?"":Eval("COLUMN_22")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton39" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_23"
                                    Text='<%# (Eval("COLUMN_23")+"")=="0"?"":Eval("COLUMN_23")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton40" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_24"
                                    Text='<%# (Eval("COLUMN_24")+"")=="0"?"":Eval("COLUMN_24")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton42" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_25"
                                    Text='<%# (Eval("COLUMN_25")+"")=="0"?"":Eval("COLUMN_25")  %>'></asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
            <!------------------------------------->
            <table class="table2" style="width: 100%; margin-top: 15px;" border="1">
                <tr class="header2">
                    <td colspan="26" style="color: red;">
                        <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                            THỐNG KÊ VỤ ÁN CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG
                        </div>
                    </td>
                </tr>
                <asp:Repeater ID="rptAnThoiHieu_tp" runat="server" OnItemCommand="rptAnThoiHieu_tp_ItemCommand" OnItemDataBound="rptAnThoiHieu_tp_ItemDataBound">
                    <HeaderTemplate>
                        <tr class="header2">
                            <td style="width: 80px;" rowspan="2">LOẠI ÁN </td>
                            <td style="width: 45px;" rowspan="2">Cũ còn lại của năm trước</td>
                            <td style="width: 45px;" rowspan="2">Tổng số vụ việc được phân công trong năm</td>
                            <td colspan="2">Phân công Thẩm tra viên</td>
                            <td colspan="2">Trạng thái hồ sơ</td>
                            <td style="width: 45px;" rowspan="2">Chưa có tờ trình
                                <br />
                                <i style="font-weight: 100; text-align: left;">(Đã có hồ sơ)</i></td>
                            <td colspan="4">Giải quyết tờ trình</td>
                            <td style="width: 45px;" rowspan="2">Đã giải quyết xong </td>
                            <td style="width: 45px;" rowspan="2">Còn lại chưa giải quyết xong<br />
                                <i style="font-weight: 100;">(bao gồm dự thảo TLĐ và dự thảo KN)</i></td>
                            <td colspan="5">Kết quả giải quyết đơn</td>
                            <td colspan="7">Xét xử Giám đốc thẩm</td>
                        </tr>
                        <tr class="header2">
                            <td style="width: 45px;">Đã phân công</td>
                            <td style="width: 45px;">Chưa phân công</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Có hồ sơ</td>
                            <td style="width: 45px;">Chưa có hồ sơ</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Chưa có ý kiến</td>
                            <td style="width: 45px;">Đã có ý kiến</td>
                            <td style="width: 45px;">Đã đăng ký lịch báo cáo Thẩm phán</td>
                            <td style="width: 45px;">Báo cáo Phó Chánh án, Tổ Thẩm phán, Chánh án, Hội đồng Thẩm phán</td>
                            <!------------------------------------>
                            <td style="width: 45px;">Trả lời đơn</td>
                            <td style="width: 45px;">Kháng nghị</td>
                            <td style="width: 45px;">Xếp đơn</td>
                            <td style="width: 45px;">Đang dự thảo trả lời đơn</td>
                            <td style="width: 45px;">Đang dự thảo kháng nghị</td>

                            <!------------------------------------>
                            <td style="width: 45px;">Tổng số kháng nghị của Chánh án và Viện kiểm sát</td>
                            <td style="width: 45px;">Đã thụ lý xét xử GĐT</td>
                            <td style="width: 45px;">Chưa xét xử</td>
                            <td style="width: 45px;">Đã xét xử</td>
                            <td style="width: 45px;">Chủ tọa</td>
                            <td style="width: 45px;">Hội đồng toàn thể</td>
                            <td style="width: 45px;">Hội đồng 5</td>
                        </tr>
                        <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                            <td style="font-style: italic;"></td>
                            <td style="font-style: italic;">1</td>
                            <td style="font-style: italic;">2</td>
                            <td style="font-style: italic;">3</td>
                            <td style="font-style: italic;">4</td>
                            <td style="font-style: italic;">5</td>
                            <td style="font-style: italic;">6</td>
                            <td style="font-style: italic;">7</td>
                            <td style="font-style: italic;">8</td>
                            <td style="font-style: italic;">9</td>
                            <td style="font-style: italic;">10</td>
                            <td style="font-style: italic;">11</td>
                            <td style="font-style: italic;">12</td>
                            <td style="font-style: italic;">13</td>
                            <td style="font-style: italic;">14</td>
                            <td style="font-style: italic;">15</td>
                            <td style="font-style: italic;">16</td>
                            <td style="font-style: italic;">17</td>
                            <td style="font-style: italic;">18</td>
                            <td style="font-style: italic;">19</td>
                            <td style="font-style: italic;">20</td>
                            <td style="font-style: italic;">21</td>
                            <td style="font-style: italic;">22</td>
                            <td style="font-style: italic;">23</td>
                            <td style="font-style: italic;">24</td>
                            <td style="font-style: italic;">25</td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="row_center">
                            <td class="row_center">
                                <b style="color: #0e7eee;"><%#Eval("TenLoaiAn") %></b></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton31" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>

                            <!--------------TTV---------------------->
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton15" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton32" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton></td>

                            <!--------------Ho so---------------------->
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton16" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_4"
                                    Text='<%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton17" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_5"
                                    Text='<%# (Eval("COLUMN_5")+"")=="0"?"":Eval("COLUMN_5")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton18" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_6"
                                    Text='<%# (Eval("COLUMN_6")+"")=="0"?"":Eval("COLUMN_6")  %>'></asp:LinkButton></td>

                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton19" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_7" Text='<%# (Eval("COLUMN_7")+"")=="0"?"":Eval("COLUMN_7")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton38" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_8"
                                    Text='<%# (Eval("COLUMN_8")+"")=="0"?"":Eval("COLUMN_8")  %>'></asp:LinkButton></td>


                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton33" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_9"
                                    Text='<%# (Eval("COLUMN_9")+"")=="0"?"":Eval("COLUMN_9")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton20" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_10" Text='<%# (Eval("COLUMN_10")+"")=="0"?"":Eval("COLUMN_10")  %>'></asp:LinkButton></td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton21" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_11"
                                    Text='<%# (Eval("COLUMN_11")+"")=="0"?"":Eval("COLUMN_11")  %>'></asp:LinkButton></td>

                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton22" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_12"
                                    Text='<%# (Eval("COLUMN_12")+"")=="0"?"":Eval("COLUMN_12")  %>'></asp:LinkButton></td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton23" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_13"
                                    Text='<%# (Eval("COLUMN_13")+"")=="0"?"":Eval("COLUMN_13")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton41" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_14"
                                    Text='<%# (Eval("COLUMN_14")+"")=="0"?"":Eval("COLUMN_14")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton25" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_15"
                                    Text='<%# (Eval("COLUMN_15")+"")=="0"?"":Eval("COLUMN_15")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton26" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_16"
                                    Text='<%# (Eval("COLUMN_16")+"")=="0"?"":Eval("COLUMN_16")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton34" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_17"
                                    Text='<%# (Eval("COLUMN_17")+"")=="0"?"":Eval("COLUMN_17")  %>'></asp:LinkButton>
                            </td>
                            <!------------------------------------>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton27" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_18"
                                    Text='<%# (Eval("COLUMN_18")+"")=="0"?"":Eval("COLUMN_18")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton28" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_19"
                                    Text='<%# (Eval("COLUMN_19")+"")=="0"?"":Eval("COLUMN_19")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton35" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_20"
                                    Text='<%# (Eval("COLUMN_20")+"")=="0"?"":Eval("COLUMN_20")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton36" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_21"
                                    Text='<%# (Eval("COLUMN_21")+"")=="0"?"":Eval("COLUMN_21")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton37" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_22"
                                    Text='<%# (Eval("COLUMN_22")+"")=="0"?"":Eval("COLUMN_22")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton39" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_23"
                                    Text='<%# (Eval("COLUMN_23")+"")=="0"?"":Eval("COLUMN_23")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton40" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_24"
                                    Text='<%# (Eval("COLUMN_24")+"")=="0"?"":Eval("COLUMN_24")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton42" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                    CommandArgument='<%# Eval("LoaiAn")  %>' CommandName="COLUMN_25"
                                    Text='<%# (Eval("COLUMN_25")+"")=="0"?"":Eval("COLUMN_25")  %>'></asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
    </div>
</asp:Panel>
<script>
    $(".tong_cong_tp").parent().parent().parent().removeClass('row_center');
    $(".tong_cong_tp").parent().parent().parent().addClass("tong_cong_tp");
</script>
<script type="text/javascript">
    function pageLoad(sender, args) {
        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
        for (var selector in config) { $(selector).chosen(config[selector]); }
    }
</script>
