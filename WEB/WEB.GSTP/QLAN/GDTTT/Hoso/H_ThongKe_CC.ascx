<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="H_ThongKe_CC.ascx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.H_ThongKe_CC" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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

    .buttoninput_hTK {
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
    <div class="thongkechung">
        <asp:Panel ID="pn_HCTP" runat="server" Visible="false">
            <table class="table2" style="width: 100%;" border="1">
                <tr class="header2">
                    <td colspan="16" style="color: red;">
                        <div style="font-size: 15px; float: right; text-align: left; width: 420px;">
                            <asp:Label ID="lblmsg" runat="server" Style="font-style: italic; color: red; float: left; padding-top: 0px; font-size: 13px;"></asp:Label>
                        </div>
                        <div style="font-size: 15px; float: left; text-align: center; width: 100%;">
                            <asp:Label ID="lstTenThamphan" Font-Size="15px" Text="PHÒNG HÀNH CHÍNH TƯ PHÁP" runat="server"></asp:Label>
                            <div style="float: right;">
                                <asp:Button ID="btnXemBC" runat="server" Width="100px" CssClass="buttoninput_hTK" Text="In Báo cáo" OnClick="btnXemBC_Click" />
                            </div>
                            <div style="float: right; margin-right: 8px;">
                                <asp:Button ID="btnXemBC_View" runat="server" CssClass="buttoninput_hTK" Width="50px" Text="Xem" OnClick="btnXemBC_View_Click" />
                            </div>
                            <div style="float: right; margin-right: 8px;">
                                <asp:TextBox ID="txtNgaynhapDen" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNgaynhapDen" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNgaynhapDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </div>
                            <div style="float: right; margin-right: 8px;">
                                <asp:TextBox ID="txtNgaynhapTu" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtNgaynhapTu" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgaynhapTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </div>
                        </div>
                    </td>
                </tr>
                <asp:Repeater ID="rptHCTP" runat="server" OnItemCommand="rptHCTP_ItemCommand" OnItemDataBound="rptHCTP_ItemDataBound">
                    <HeaderTemplate>
                        <tr class="header2">
                            <td style="width: 80px;" rowspan="2">VĂN THƯ ĐẾN</td>
                            <td style="width: 80px;" rowspan="2">LOẠI ÁN </td>
                            <td style="width: 45px;" rowspan="2">Tổng số đơn đã xử lý HCTP</td>
                            <td style="width: 45px;" rowspan="2">Trả lại đơn</td>
                            <td style="width: 45px;" rowspan="2">Đơn không thuộc thẩm quyền</td>
                            <td style="width: 45px;" rowspan="2">Đơn chưa đủ điều kiện</td>
                            <td colspan="2">Đơn đủ điều kiện chuyển P. GĐKT 1</td>
                            <td colspan="2">Đơn đủ điều kiện chuyển P. GĐKT 2</td>
                            <td colspan="2">Đơn đủ điều kiện chuyển P. GĐKT 3</td>
                            <td style="width: 45px;" rowspan="2">Đơn chuyển TATC</td>
                            <td style="width: 45px;" rowspan="2">Đơn chuyển Tòa án khác</td>
                            <td style="width: 45px;" rowspan="2">Đơn chuyển các đơn vị ngoài Tòa án</td>
                            <td style="width: 45px;" rowspan="2">Xếp đơn</td>
                        </tr>
                        <tr class="header2">
                            <td style="width: 45px;">Đơn trùng</td>
                            <td style="width: 45px;">Đơn thụ lý mới</td>
                            <td style="width: 45px;">Đơn trùng</td>
                            <td style="width: 45px;">Đơn thụ lý mới</td>
                            <td style="width: 45px;">Đơn trùng</td>
                            <td style="width: 45px;">Đơn thụ lý mới</td>
                            <!------------------------------------>
                        </tr>
                        <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                            <td style="font-style: italic;"></td>
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
                            <td style="font-style: italic;">14</td>
                            <td style="font-style: italic;">16</td>
                            <td style="font-style: italic;">17</td>
                            <td style="font-style: italic;">18</td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="row_center">
                            <td class="row_center"><b style="color: #0e7eee;"></b>
                                  <asp:LinkButton ID="LinkButton11" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_25" Text='<%# (Eval("COLUMN_25")+"")=="0"?"":Eval("COLUMN_25")  %>'></asp:LinkButton></td>
                            </td>
                            <td class="row_center"><b style="color: #0e7eee;"><%#Eval("TenLoaiAn") %></b>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton2" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton3" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton4" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_4" Text='<%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton5" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_5" Text='<%#(Eval("COLUMN_5")+"")=="0"?"":Eval("COLUMN_5") %>'></asp:LinkButton>
                                <asp:LinkButton ID="LinkButton19" runat="server" ForeColor="#0E7EEE" Font-Size="12px"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_19" Text='<%# (Eval("COLUMN_19")+"")=="0"?"":"<br /><span style=color:#a2c2a8;font:12px>---------</span><br/>"+"CĐ: "+Eval("COLUMN_19")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton6" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_6" Text='<%# (Eval("COLUMN_6")+"")=="0"?"":Eval("COLUMN_6")%>'></asp:LinkButton>
                                <asp:LinkButton ID="LinkButton20" runat="server" ForeColor="#0E7EEE" Font-Size="12px"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_20" Text='<%# (Eval("COLUMN_20")+"")=="0"?"":"<br /><span style=color:#a2c2a8;font:12px>---------</span><br/>"+"CĐ: "+Eval("COLUMN_20")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton7" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_7" Text='<%# (Eval("COLUMN_7")+"")=="0"?"":Eval("COLUMN_7") %>'></asp:LinkButton>
                                <asp:LinkButton ID="LinkButton21" runat="server" ForeColor="#0E7EEE" Font-Size="12px"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_21" Text='<%# (Eval("COLUMN_21")+"")=="0"?"":"<br /><span style=color:#a2c2a8;font:12px>---------</span><br/>"+"CĐ: "+Eval("COLUMN_21")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton8" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_8" Text='<%# (Eval("COLUMN_8")+"")=="0"?"":Eval("COLUMN_8") %>'></asp:LinkButton>
                                <asp:LinkButton ID="LinkButton22" runat="server" ForeColor="#0E7EEE" Font-Size="12px"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_22" Text='<%# (Eval("COLUMN_22")+"")=="0"?"":"<br /><span style=color:#a2c2a8;font:12px>---------</span><br/>"+"CĐ: "+Eval("COLUMN_22")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton9" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_9" Text='<%# (Eval("COLUMN_9")+"")=="0"?"":Eval("COLUMN_9") %>'></asp:LinkButton>
                                <asp:LinkButton ID="LinkButton23" runat="server" ForeColor="#0E7EEE" Font-Size="12px"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_23" Text='<%# (Eval("COLUMN_23")+"")=="0"?"":"<br /><span style=color:#a2c2a8;font:12px>---------</span><br/>"+"CĐ: "+Eval("COLUMN_23")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton10" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_10" Text='<%# (Eval("COLUMN_10")+"")=="0"?"":Eval("COLUMN_10") %>'></asp:LinkButton>
                                <asp:LinkButton ID="LinkButton24" runat="server" ForeColor="#0E7EEE" Font-Size="12px"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_24" Text='<%# (Eval("COLUMN_24")+"")=="0"?"":"<br /><span style=color:#a2c2a8;font:12px>---------</span><br/>"+"CĐ: "+Eval("COLUMN_24")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton14" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_14" Text='<%# (Eval("COLUMN_14")+"")=="0"?"":Eval("COLUMN_14")  %>'></asp:LinkButton></td>
                             <td class="row_center">
                                <asp:LinkButton ID="LinkButton16" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_16" Text='<%# (Eval("COLUMN_16")+"")=="0"?"":Eval("COLUMN_16")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton17" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_17" Text='<%# (Eval("COLUMN_17")+"")=="0"?"":Eval("COLUMN_17")  %>'></asp:LinkButton></td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton18" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("LoaiAn")  %>'
                                    CommandName="COLUMN_18" Text='<%# (Eval("COLUMN_18")+"")=="0"?"":Eval("COLUMN_18")  %>'></asp:LinkButton></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
        <asp:Panel ID="pn_HCTP_DAY" runat="server" Visible="false">
            <table class="table2" style="width: 60%; margin-top: 20px;" border="1">
                <asp:Repeater ID="rptHCTP_DAY" runat="server" OnItemCommand="rptHCTP_DAY_ItemCommand" OnItemDataBound="rptHCTP_DAY_ItemDataBound">
                    <HeaderTemplate>
                        <tr class="header2">
                            <td style="width: 80px;">Họ tên</td>
                            <td style="width: 45px;">Tổng số đơn xử lý trong ngày hôm nay</td>
                            <td style="width: 45px;">Tổng số đơn xử lý trong tháng hiện tại</td>
                            <td style="width: 45px;">Tổng số đơn xử lý trong kỳ</td>
                            <td style="width: 45px;">Trung bình số đơn xử lý mỗi ngày (làm việc) trong kỳ </td>
                        </tr>
                        <tr style="font-style: italic; color: #a2c2a8; font-size: 9px; text-align: center;">
                            <td style="font-style: italic;"></td>
                            <td style="font-style: italic;">1</td>
                            <td style="font-style: italic;">2</td>
                            <td style="font-style: italic;">3</td>
                            <td style="font-style: italic;">4</td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="row_center">
                            <td runat="server" id="hoten_td" class="row_center" style="text-align: left;"><b style="color: #0e7eee; text-align: left;"><%#Eval("HOTEN_USERNAME") %></b>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("USERNAME")+";"+Eval("USERNAME_LIST")%>'
                                    CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton2" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("USERNAME")+";"+Eval("USERNAME_LIST")%>'
                                    CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"":Eval("COLUMN_2")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <asp:LinkButton ID="LinkButton3" runat="server" ForeColor="#0E7EEE"
                                    Font-Bold="true" CommandArgument='<%# Eval("USERNAME")+";"+Eval("USERNAME_LIST")%>'
                                    CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"":Eval("COLUMN_3")  %>'></asp:LinkButton>
                            </td>
                            <td class="row_center">
                                <a href="#" style="font-weight: bold; color: #0E7EEE"><%# (Eval("COLUMN_4")+"")=="0"?"":Eval("COLUMN_4")  %></a>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></FooterTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
    </div>
</asp:Panel>
<style>
    .ajax__calendar_container TABLE td {
        border: 1px solid #ffffff;
    }

    .ajax__calendar_day {
        font-weight: normal;
        padding: 0px 1px;
    }
</style>
