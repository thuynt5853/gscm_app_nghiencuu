<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uThongKe_Chanhan.ascx.cs" Inherits="WEB.GSTP.QLAN.BAOCAOCA.uThongKe_Chanhan" %>

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
<style>
    /* Container của tab */
    .tab-container {
        display: flex;
        justify-content: center;
        margin-bottom: 15px;
    }

    /* Các tab */
    .tab {
        padding: 8px 16px;
        margin: 0 8px;
        background-color: #f1f1f1;
        color: #333;
        font-size: 15px;
        font-weight: bold;
        border-radius: 20px;
        cursor: pointer;
        transition: all 0.3s ease-in-out;
        text-align: center;
        box-shadow: 0 3px 5px rgba(0, 0, 0, 0.1);
        border: 2px solid transparent;
    }

        /* Tab đang được hover */
        .tab:hover {
            background-color: #0E7EEE;
            color: white;
            border-color: #0E7EEE;
            transform: scale(1.05);
        }

        /* Tab đang được chọn */
        .tab.selected {
            background-color: #0E7EEE;
            color: white;
            border-color: #0E7EEE;
        }

    /* Tab container khi có các hiệu ứng */
    .tab-container .tab:active {
        transform: scale(0.95);
    }

    /* Tạo hiệu ứng shadow cho tab khi hover */
    .tab:hover {
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .view-content {
        padding: 20px;
        border: 1px solid #ddd;
        margin-top: 20px;
    }

    #pnLichsuXoaThuly {
        width: 80%;
        height: 500px;
        overflow-y: scroll;
        margin: 0 auto; /* Căn giữa theo chiều ngang */
    }
</style>

<asp:Panel ID="pn_TANDTC" runat="server">

    <div class="thongkechung" style="height: auto; min-height: 100vh;">

        <!-- Các Tab -->
        <div>
            <asp:LinkButton class="tab tab.selected" ID="tabtatc" runat="server" OnClick="TabClick" data-view="ViewTATC" TabIndex="0">Tòa án nhân dân tối cao</asp:LinkButton>
            <asp:LinkButton class="tab" ID="tabtpca" runat="server" OnClick="TabClick" data-view="ViewPCA" TabIndex="3">Phó Chánh án TANDTC</asp:LinkButton>
            <asp:LinkButton class="tab" ID="tabtptatc" runat="server" OnClick="TabClick" data-view="ViewTPTATC" TabIndex="1">Thẩm phán TANDTC</asp:LinkButton>
            <asp:LinkButton class="tab" ID="tabgdkt" runat="server" OnClick="TabClick" data-view="ViewVUGDKT" TabIndex="4" Visible="false">Các Vụ Giám đốc kiểm tra</asp:LinkButton>
            <asp:LinkButton class="tab" ID="tabstpt" runat="server" OnClick="TabClick" data-view="ViewTAND" TabIndex="2">Các Tòa án nhân dân</asp:LinkButton>
        </div>
        <asp:MultiView ID="mv1" runat="server">
            <asp:View ID="ViewTATC" runat="server">
                <div class="view-content">

                    <table class="table2" style="width: 100%;">
                        <tr class="header2">
                            <td colspan="26" style="color: red;">
                                <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                                    <asp:Label ID="lstTenThamphan" Font-Size="15px" runat="server" Text="TÌNH HÌNH GIẢI QUYẾT ĐƠN, XÉT XỬ GDT,TT TÒA ÁN NHÂN DÂN TỐI CAO"></asp:Label>
                                    <div style="float: right;">
                                        <asp:Button ID="btnXemBC_TP" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_TP_Click" Visible="false"/>
                                    </div>
                                    <div style="float: right; margin-right: 8px;">
                                        <asp:DropDownList ID="ddl_Load_Thoigian" AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_Thoigian_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="130px">
                                            <asp:ListItem Value="week" Text="Tuần"></asp:ListItem>
                                            <asp:ListItem Value="month" Text="Tháng" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="year" Text="Năm"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: right; margin-right: 8px; text-align: left;">
                                        <asp:DropDownList ID="ddlThamphan" AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="220px">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </td>
                        </tr>

                        <asp:Repeater ID="rptThamPhan" runat="server" OnItemCommand="rptThamPhan_ItemCommand" OnItemDataBound="rptThamPhan_ItemDataBound">
                            <HeaderTemplate>
                                <tr class="header2">
                                    <td style="width: 80px;" rowspan="3">LOẠI ÁN </td>
                                    <td style="border-right: solid 2px #a2c2a8;" colspan="7">GIẢI QUYẾT ĐƠN</td>
                                    <td colspan="5">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                                </tr>
                                <tr class="header2">
                                    <td style="width: 45px;" colspan="2">Tổng số đơn</td>
                                    <td style="width: 45px;" colspan="4">Đã giải quyết xong</td>
                                    <td style="width: 45px; border-right: solid 2px #a2c2a8;" rowspan="2">Chưa giải quyết xong</td>
                                    <td style="width: 45px;" colspan="3">Số vụ án xét xử GĐT, TT</td>
                                    <td style="width: 45px;" rowspan="2">Đã xét xử</td>
                                    <td style="width: 45px;" rowspan="2">Chưa xét xử</td>
                                </tr>
                                <tr class="header2">
                                    <td style="width: 45px;">Cũ chuyển sang</td>
                                    <td style="width: 45px;">Mới thụ lý</td>
                                    <td style="width: 45px;">Tổng số</td>
                                    <td style="width: 45px;">Trả lời đơn</td>
                                    <td style="width: 45px;">Kháng nghị</td>
                                    <td style="width: 45px;">Xếp đơn</td>
                                    <td style="width: 45px;">Tổng số</td>
                                    <td style="width: 45px;">Chánh án Kháng nghị</td>
                                    <td style="width: 45px;">Viện trưởng Kháng nghị</td>
                                </tr>
                            </HeaderTemplate>
                            <ItemTemplate>


                                <tr class="row_center">
                                    <td class="row_center">
                                        <asp:Label ID="Label1" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Font-Size="14px" Text='<%# Eval("TENLOAIAN") %>'>
                                        </asp:Label>
                                    </td>

                                    <!-- COLUMN_1 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_1">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_2 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton2" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_2">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_3 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton3" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_3">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_4 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton4" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_4">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_5 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton5" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_5">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_6 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton6" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_6">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_7 -->
                                    <td class="row_center" style="border-right: solid 2px #a2c2a8;">

                                        <asp:LinkButton ID="LinkButton7" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_7">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_8 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton8" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_8">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_9 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton9" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_9">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_10 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton10" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_10">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_11 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton11" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_11">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_12 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton12" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_12">
                                        </asp:LinkButton>
                                    </td>
                                </tr>


                            </ItemTemplate>
                            <FooterTemplate></FooterTemplate>
                        </asp:Repeater>
                    </table>

                    <table class="table2" style="width: 100%;">
                        <tr class="header2">
                            <td colspan="26" style="color: red;">
                                <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                                    <asp:Label ID="lstTenThamphan_ANQH" Font-Size="15px" runat="server" Text="SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT THUỘC TRƯỜNG HỢP CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI"></asp:Label>
                                </div>
                            </td>
                        </tr>

                        <asp:Repeater ID="rptThamPhan_ANQH" runat="server" OnItemCommand="rptThamPhan_ItemCommand_ANQH" OnItemDataBound="rptThamPhan_ItemDataBound_ANQH">
                            <HeaderTemplate>
                                <tr class="header2">
                                    <td style="width: 80px;" rowspan="3">LOẠI ÁN</td>
                                    <td style="border-right: solid 2px #a2c2a8;" colspan="7">SỐ VỤ PHẢI GIẢI QUYẾT TRONG GIAI ĐOẠN GIẢI QUYẾT ĐƠN</td>
                                    <td colspan="5">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                                </tr>
                                <tr class="header2">
                                    <td style="width: 45px;" colspan="2">Tổng số vụ án phải giải quyết</td>
                                    <td style="width: 45px;" colspan="4">Đã giải quyết xong</td>
                                    <td style="width: 45px; border-right: solid 2px #a2c2a8;" rowspan="2">Chưa giải quyết xong</td>
                                    <td style="width: 45px;" colspan="3">Số vụ án xét xử GĐT, TT</td>
                                    <td style="width: 45px;" rowspan="2">Đã xét xử</td>
                                    <td style="width: 45px;" rowspan="2">Chưa xét xử</td>
                                </tr>
                                <tr class="header2">
                                    <td style="width: 45px;">Cũ chuyển sang</td>
                                    <td style="width: 45px;">Mới thụ lý</td>
                                    <td style="width: 45px;">Tổng số</td>
                                    <td style="width: 45px;">Số vụ Trả lời đơn</td>
                                    <td style="width: 45px;">Số vụ Kháng nghị</td>
                                    <td style="width: 45px;">Số vụ Xếp đơn</td>
                                    <td style="width: 45px;">Tổng số</td>
                                    <td style="width: 45px;">Chánh án Kháng nghị</td>
                                    <td style="width: 45px;">Viện trưởng Kháng nghị</td>
                                </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="row_center">
                                    <td class="row_center">
                                        <asp:Label ID="Label1_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Font-Size="14px"
                                            Text='<%# Eval("TENLOAIAN") %>'></asp:Label>
                                    </td>

                                    <!-- COLUMN_1 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton1_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_1">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_2 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton2_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_2">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_3 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton3_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_3">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_4 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton4_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_4">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_5 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton5_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_5">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_6 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton6_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_6">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_7 -->
                                    <td class="row_center" style="border-right: solid 2px #a2c2a8;">
                                        <asp:LinkButton ID="LinkButton7_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_7">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_8 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton8_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_8">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_9 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton9_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_9">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_10 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton10_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_10">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_11 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton11_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_11">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_12 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton12_ANQH" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_12">
                                        </asp:LinkButton>
                                    </td>
                                </tr>

                            </ItemTemplate>
                            <FooterTemplate></FooterTemplate>
                        </asp:Repeater>
                    </table>

                    <table class="table2" style="width: 100%;">
                        <tr class="header2">
                            <td colspan="26" style="color: red;">
                                <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                                    <asp:Label ID="lstTenThamphan_THOIHIEU" Font-Size="15px" runat="server" Text="SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG"></asp:Label>
                                </div>
                            </td>
                        </tr>

                        <asp:Repeater ID="rptThamPhan_THOIHIEU" runat="server" OnItemCommand="rptThamPhan_ItemCommand_THOIHIEU" OnItemDataBound="rptThamPhan_ItemDataBound_THOIHIEU">
                            <HeaderTemplate>
                                <tr class="header2">
                                    <td style="width: 80px;" rowspan="3">LOẠI ÁN </td>
                                    <td style="border-right: solid 2px #a2c2a8;" colspan="7">SỐ VỤ PHẢI GIẢI QUYẾT TRONG GIAI ĐOẠN GIẢI QUYẾT ĐƠN</td>
                                    <td colspan="5">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                                </tr>
                                <tr class="header2">
                                    <td style="width: 45px;" colspan="2">Tổng số vụ án phải giải quyết</td>
                                    <td style="width: 45px;" colspan="4">Đã giải quyết xong</td>
                                    <td style="width: 45px; border-right: solid 2px #a2c2a8;" rowspan="2">Chưa giải quyết xong</td>
                                    <td style="width: 45px;" colspan="3">Số vụ án xét xử GĐT, TT</td>
                                    <td style="width: 45px;" rowspan="2">Đã xét xử</td>
                                    <td style="width: 45px;" rowspan="2">Chưa xét xử</td>
                                </tr>
                                <tr class="header2">
                                    <td style="width: 45px;">Cũ chuyển sang</td>
                                    <td style="width: 45px;">Mới thụ lý</td>
                                    <td style="width: 45px;">Tổng số</td>
                                    <td style="width: 45px;">Số vụ Trả lời đơn</td>
                                    <td style="width: 45px;">Số vụ Kháng nghị</td>
                                    <td style="width: 45px;">Số vụ Xếp đơn</td>
                                    <td style="width: 45px;">Tổng số</td>
                                    <td style="width: 45px;">Chánh án Kháng nghị</td>
                                    <td style="width: 45px;">Viện trưởng Kháng nghị</td>
                                </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="row_center">
                                    <td class="row_center">
                                        <asp:Label ID="Label1_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Font-Size="14px"
                                            Text='<%# Eval("TENLOAIAN") %>'></asp:Label>
                                    </td>

                                    <!-- COLUMN_1 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton1_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_1">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_2 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton2_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_2">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_3 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton3_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_3">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_4 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton4_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_4">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_5 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton5_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_5">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_6 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton6_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_6">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_7 -->
                                    <td class="row_center" style="border-right: solid 2px #a2c2a8;">
                                        <asp:LinkButton ID="LinkButton7_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_7">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_8 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton8_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_8">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_9 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton9_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_9">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_10 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton10_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_10">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_11 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton11_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_11">
                                        </asp:LinkButton>
                                    </td>

                                    <!-- COLUMN_12 -->
                                    <td class="row_center">
                                        <asp:LinkButton ID="LinkButton12_THOIHIEU" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                            CommandArgument='<%# Eval("TENLOAIAN") %>' CommandName="COLUMN_12">
                                        </asp:LinkButton>
                                    </td>
                                </tr>

                            </ItemTemplate>
                            <FooterTemplate></FooterTemplate>
                        </asp:Repeater>
                    </table>

                </div>
            </asp:View>

            <asp:View ID="ViewPCA" runat="server">
                <div class="view-content">

                    <asp:Panel ID="ViewPCAM1" runat="server">
                        <table class="table2" style="width: 100%;" border="1">
                            <tr class="header2">
                                <td colspan="26" style="color: red;">
                                    <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                                        <asp:Label ID="lblTieude_PCAM1" Font-Size="15px" runat="server">CÔNG TÁC LÃNH ĐẠO, CHỈ ĐẠO GIẢI QUYẾT ĐƠN GIÁM ĐỐC THẨM, TÁI THẨM THEO LĨNH VỰC PHỤ TRÁCH</asp:Label>
                                        <div style="float: right; margin-right: 8px;">
                                            <asp:DropDownList ID="ddl_Load_Thoigian_PCAM1" AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_Thoigian_PCAM1_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="130px">
                                                <asp:ListItem Value="week" Text="Tuần"></asp:ListItem>
                                                <asp:ListItem Value="month" Text="Tháng" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="year" Text="Năm"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:Button ID="btnXemBC_PCAM1" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_PCAM1_Click" Visible="false"/>
                                        </div>
                                    </div>
                                </td>
                                <asp:Repeater ID="rptPCAM1" runat="server" OnItemCommand="rptPCAM1_ItemCommand">
                                    <HeaderTemplate>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="3">STT</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="3">PHÓ CHÁNH ÁN TANDTC</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="5" rowspan="1">ĐƠN ĐỀ NGHỊ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="5" rowspan="1">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                                        </tr>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="3">Đã giải quyết</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="2">Đang giải quyết</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="2">Án phải giải quyết</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="2">Đã giải quyết</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Chưa giải quyết</td>
                                        </tr>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Kháng nghị</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Trả lời đơn</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Xử lý khác (xếp đơn, lưu đơn ...)</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Xin ý kiến Tổ Thẩm phán/Hội đồng toàn thể</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Chưa có ý kiến</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Tồn kỳ trước</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Thụ lý mới</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Đã xét xử</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Đình chỉ xét xử GĐT</td>
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr class="row_center">
                                            <td style="text-align: center;">
                                                <asp:Label ID="lbl_PCAM1" runat="server" Font-Bold="true" Font-Size="15px" Text='<%# Container.ItemIndex + 1 %>'></asp:Label></td>
                                            <td>
                                                <asp:Label ID="Label0_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Font-Size="14px"
                                                    Text='<%# Eval("THAMPHAN_HOTEN") %>'></asp:Label>
                                            <td>
                                                <asp:LinkButton ID="LinkButton1_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_1"
                                                    Text='<%# Eval("COLUMN_1") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton2_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_2"
                                                    Text='<%# Eval("COLUMN_2") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton3_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_3"
                                                    Text='<%# Eval("COLUMN_3") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton4_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_4"
                                                    Text='<%# Eval("COLUMN_4") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton5_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_5"
                                                    Text='<%# Eval("COLUMN_5") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton6_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_6"
                                                    Text='<%# Eval("COLUMN_6") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton7_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_7"
                                                    Text='<%# Eval("COLUMN_7") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton8_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_8"
                                                    Text='<%# Eval("COLUMN_8") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton9_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_9"
                                                    Text='<%# Eval("COLUMN_9") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton10_PCAM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_10"
                                                    Text='<%# Eval("COLUMN_10") %>'></asp:LinkButton></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </tr>
                        </table>
                    </asp:Panel>

                </div>

            </asp:View>

            <asp:View ID="ViewTPTATC" runat="server">
                <div class="view-content">

                    <asp:Panel ID="ViewTPTATCM1" runat="server">
                        <table class="table2" style="width: 100%;" border="1">
                            <tr class="header2">
                                <td colspan="26" style="color: red;">
                                    <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                                        <asp:Label ID="lblTieude_TPTATCM1" Font-Size="15px" runat="server">TỔNG HỢP SỐ LIỆU THEO THẨM PHÁN TANDTC</asp:Label>
                                        <div style="float: right; margin-right: 8px;">
                                            <asp:DropDownList ID="ddl_Load_Thoigian_TPTATCM1" AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_Thoigian_TPTATCM1_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="130px">
                                                <asp:ListItem Value="week" Text="Tuần"></asp:ListItem>
                                                <asp:ListItem Value="month" Text="Tháng" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="year" Text="Năm"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:Button ID="btnXemBC_TPTATCM1" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_TPTATCM1_Click" Visible="false"/>
                                        </div>
                                    </div>
                                </td>
                                <asp:Repeater ID="rptTPTATCM1" runat="server" OnItemCommand="rptTPTATCM1_ItemCommand" OnItemDataBound="rptTPTATCM1_ItemDataBound">
                                    <HeaderTemplate>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="3">STT</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="3">THẨM PHÁN TANDTC</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="5" rowspan="1">GIẢI QUYẾT ĐƠN</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="4" rowspan="1">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                                        </tr>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="2">Tổng số đơn</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Đã giải quyết xong</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Chưa giải quyết xong</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Tỷ lệ giải quyết</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Tổng số vụ án</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Đã xét xử</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Chưa xét xử</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Tỷ lệ giải quyết</td>
                                        </tr>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Cũ chuyển sang</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Thụ lý mới</td>
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr class="row_center">
                                            <td style="text-align: center;">
                                                <asp:Label ID="lbl_TPTATCM1" runat="server" Font-Bold="true" Font-Size="15px" Text='<%# Container.ItemIndex + 1 %>'></asp:Label></td>
                                            <td>
                                                <asp:Label ID="Label0_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Font-Size="14px"
                                                    Text='<%# Eval("THAMPHAN_HOTEN") %>'></asp:Label>
                                            <td>
                                                <asp:LinkButton ID="LinkButton1_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_1"
                                                    Text='<%# Eval("COLUMN_1") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton2_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_2"
                                                    Text='<%# Eval("COLUMN_2") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton3_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_3"
                                                    Text='<%# Eval("COLUMN_3") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton4_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_4"
                                                    Text='<%# Eval("COLUMN_4") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkTyleGQD_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton5_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_5"
                                                    Text='<%# Eval("COLUMN_5") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton6_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_6"
                                                    Text='<%# Eval("COLUMN_6") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton7_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("THAMPHANID") %>' CommandName="COLUMN_7"
                                                    Text='<%# Eval("COLUMN_7") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkTyleXXGQT_TPTATCM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"></asp:LinkButton></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </tr>
                        </table>
                    </asp:Panel>

                </div>

            </asp:View>

            <asp:View ID="ViewVUGDKT" runat="server">
                <div class="view-content">

                    <asp:Panel ID="ViewVUGDKTM1" runat="server">
                        <table class="table2" style="width: 100%;" border="1">
                            <tr class="header2">
                                <td colspan="26" style="color: red;">
                                    <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                                        <asp:Label ID="lblTieude_VUGDKTM1" Font-Size="15px" runat="server">TỔNG QUAN TÌNH HÌNH XỬ LÝ CÁC VỤ GIÁM ĐỐC KIỂM TRA</asp:Label>
                                        <div style="float: right; margin-right: 8px;">
                                            <asp:DropDownList ID="ddl_Load_Thoigian_VUGDKTM1" AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_Thoigian_VUGDKTM1_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="130px">
                                                <asp:ListItem Value="week" Text="Tuần"></asp:ListItem>
                                                <asp:ListItem Value="month" Text="Tháng" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="year" Text="Năm"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:Button ID="btnXemBC_VUGDKTM1" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_VUGDKTM1_Click" Visible="false"/>
                                        </div>
                                    </div>
                                </td>
                                <asp:Repeater ID="rptVUGDKTM1" runat="server" OnItemCommand="rptVUGDKTM1_ItemCommand" OnItemDataBound="rptVUGDKTM1_ItemDataBound">
                                    <HeaderTemplate>
                                        <tr class="header2">
                                            <td style="width: 250px; font-size: 15px;" colspan="1" rowspan="4">STT</td>
                                            <td style="width: 250px; font-size: 15px;" colspan="1" rowspan="4">ĐƠN VỊ</td>
                                            <td style="width: 200px; font-size: 15px;" colspan="8" rowspan="1">CHO Ý KIẾN ĐỐI VỚI TỜ TRÌNH GIẢI QUYẾT ĐƠN</td>
                                            <td style="width: 200px; font-size: 15px;" colspan="5" rowspan="1">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                                        </tr>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="3">Cũ còn lại</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="6" rowspan="1">Đã cho ý kiến</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="3">Chưa có ý kiến</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="2" rowspan="2">Án phải giải quyết</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="2" rowspan="2">Đã giải quyết</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="3">Chưa giải quyết</td>
                                        </tr>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Số Tờ trình nhận được</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Trả lời đơn</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Kháng nghị</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Xử lý khác (xếp đơn, lưu đơn...)</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="2" rowspan="1">Yêu cầu trình tiếp</td>
                                        </tr>
                                        <tr class="header2">
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Báo cáo Tổ Thẩm phán/Báo cáo Hội đồng Thẩm phán</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Trình Chánh án</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Tồn kỳ trước</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Thụ lý mới</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Đã xét xử</td>
                                            <td style="width: 80px; font-size: 15px;" colspan="1">Đình chỉ xét xử GĐT</td>
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr class="row_center">
                                            <td style="text-align: center;">
                                                <asp:Label runat="server" Font-Bold="true" Text='<%# Container.ItemIndex + 1 %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="Label0_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Font-Size="14px"
                                                    Text='<%# Eval("TENPHONGBAN") %>'></asp:Label>
                                            <td>
                                                <asp:LinkButton ID="LinkButton1_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_1"
                                                    Text='<%# Eval("COLUMN_1") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton2_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_2"
                                                    Text='<%# Eval("COLUMN_2") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton3_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_3"
                                                    Text='<%# Eval("COLUMN_3") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton4_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_4"
                                                    Text='<%# Eval("COLUMN_4") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton5_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_5"
                                                    Text='<%# Eval("COLUMN_5") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton6_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_6"
                                                    Text='<%# Eval("COLUMN_6") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton7_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_7"
                                                    Text='<%# Eval("COLUMN_7") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton8_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_8"
                                                    Text='<%# Eval("COLUMN_8") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton9_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_9"
                                                    Text='<%# Eval("COLUMN_9") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton10_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_10"
                                                    Text='<%# Eval("COLUMN_10") %>'></asp:LinkButton></td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton11_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_11"
                                                    Text='<%# Eval("COLUMN_11") %>'></asp:LinkButton>
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton12_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_12"
                                                    Text='<%# Eval("COLUMN_12") %>'></asp:LinkButton>
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton13_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_13"
                                                    Text='<%# Eval("COLUMN_13") %>'></asp:LinkButton>
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="LinkButton14_VUGDKTM1" runat="server" ForeColor="#0E7EEE" Font-Bold="true"
                                                    CommandArgument='<%# Eval("PHONGBANID") %>' CommandName="COLUMN_14"
                                                    Text='<%# Eval("COLUMN_14") %>'></asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </tr>
                        </table>
                    </asp:Panel>

                </div>

            </asp:View>

            <asp:View ID="ViewTAND" runat="server">
                <div class="view-content">

                    <asp:Panel ID="ViewTAND_M1" runat="server">
                        <table class="table2" style="width: 100%;" border="1">
                            <tr class="header2">
                                <td colspan="6" style="color: red;">
                                    <div style="font-size: 15px; float: left; text-align: center; width: 100%">
                                        <asp:Label ID="lblTieude_STPT" Font-Size="15px" runat="server"></asp:Label>
                                        <div style="float: right; margin-right: 8px;">
                                            <asp:DropDownList ID="ddl_Load_Thoigian_STPT" AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_Thoigian_STPT_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="130px">
                                                <asp:ListItem Value="week" Text="Tuần"></asp:ListItem>
                                                <asp:ListItem Value="month" Text="Tháng" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="year" Text="Năm"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <asp:Repeater ID="rptToaan_STPT" runat="server" OnItemCommand="rptToaan_STPT_ItemCommand" OnItemDataBound="rptToaan_STPT_ItemDataBound">
                                <HeaderTemplate>
                                    <tr class="header2">
                                        <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Tổng số vụ án thụ lý</td>
                                        <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Tổng số giải quyết</td>
                                        <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Tổng số Toà án có tỷ lệ giải quyết >50%</td>
                                        <td style="width: 80px; font-size: 15px;" colspan="1" rowspan="2">Tổng số Toà án có tỷ lệ giải quyết <50%</td>
                                        <td style="width: 80px; font-size: 15px;" colspan="2" rowspan="1">Tỷ lệ giải quyết</td>
                                    </tr>
                                    <tr class="header2">
                                        <td style="width: 80px; font-size: 15px;" colspan="1">Kỳ hiện tại</td>
                                        <td style="width: 80px; font-size: 15px;" colspan="1">So với cùng kỳ</td>
                                    </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr class="row_center">
                                        <td>
                                            <asp:LinkButton ID="LinkButton1_Toaan_STPT" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandName="COLUMN_1" Text='<%# (Eval("COLUMN_1")+"")=="0"?"":Eval("COLUMN_1")  %>'></asp:LinkButton></td>
                                        <td>
                                            <asp:LinkButton ID="LinkButton2_Toaan_STPT" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandName="COLUMN_2" Text='<%# (Eval("COLUMN_2")+"")=="0"?"0":Eval("COLUMN_2")  %>'></asp:LinkButton></td>
                                        <td>
                                            <asp:LinkButton ID="LinkButton3_Toaan_STPT" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandName="COLUMN_3" Text='<%# (Eval("COLUMN_3")+"")=="0"?"0":Eval("COLUMN_3")  %>'></asp:LinkButton></td>
                                        <td>
                                            <asp:LinkButton ID="LinkButton4_Toaan_STPT" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandName="COLUMN_4" Text='<%# (Eval("COLUMN_4")+"")=="0"?"0":Eval("COLUMN_4")  %>'></asp:LinkButton></td>
                                        <td>
                                            <asp:LinkButton ID="LinkButton5_Toaan_STPT" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandName="COLUMN_5" Text='<%# Eval("COLUMN_5") %>'></asp:LinkButton></td>
                                        <td>
                                            <asp:LinkButton ID="LinkButton6_Toaan_STPT" runat="server" ForeColor="#0E7EEE" Font-Bold="true" CommandName="COLUMN_6"></asp:LinkButton></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                </FooterTemplate>
                            </asp:Repeater>
                        </table>
                    </asp:Panel>

                    <asp:Panel ID="ViewTAND_M2" runat="server" Visible="false" Style="width: 1200px; border: none; align-items: center;">
                        <table class="table2" style="width: 1200px; border: none; align-items: center;">
                            <tr class="header2">
                                <td colspan="26" style="color: black; border: none; align-items: center;">
                                    <div style="font-size: 15px; display: flex; justify-content: space-between; align-items: center; width: 100%;">
                                        <div style="display: flex; align-items: center; margin-left: 40px;">
                                            <div style="margin-right: 10px; width: 90px">Chọn tiêu chí</div>
                                            <asp:DropDownList ID="ddlLoaiTimkiem" CssClass="chosen-select" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiTimkiem_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Tổng số vụ án thụ lý"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Tổng số giải quyết"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổng số Toà án có tỷ lệ giải quyết trên 50%"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Tổng số Toà án có tỷ lệ giải quyết dưới 50%"></asp:ListItem>
                                            </asp:DropDownList>
                                            <div style="margin-right: 10px; margin-left: 10px; width: 90px">Tòa xét xử</div>
                                            <div style="float: left; text-align: left;">
                                                <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                                            </div>
                                            <div style="margin-right: 10px; margin-left: 10px;">
                                                <asp:DropDownList ID="ddl_Load_Thoigian_STPT_M2" AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_Thoigian_STPT_M2_SelectedIndexChanged"
                                                    CssClass="chosen-select" runat="server" Width="170px">
                                                    <asp:ListItem Value="week" Text="Tuần"></asp:ListItem>
                                                    <asp:ListItem Value="month" Text="Tháng" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="year" Text="Năm"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div style="margin-right: 10px; margin-left: 10px;">
                                                <asp:Button ID="btnXemBC_STPT_M2" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_STPT_M2_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="26" style="color: red; text-align: center; vertical-align: middle; margin-top: 5px; border: none;">
                                    <div style="display: flex; justify-content: center; align-items: center; height: 100%;">
                                        <asp:Label ID="lstTenBangtimkiem" Font-Size="20px" runat="server" Font-Bold="true" Height="30px"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <asp:Panel ID="pnLichsuXoaThuly" runat="server" align="center" Style="max-height: 500px; width: 1200px; overflow-y: auto;">
                                            <table class="table2" style="width: 900px;" border="1">
                                                <tr style="display: none;">
                                                    <td colspan="26" style="color: black; height: 0px;">
                                                        <asp:Repeater ID="rptToaan_STPT_M2" runat="server" OnItemDataBound="rptToaan_STPT_M2_ItemDataBound">
                                                            <HeaderTemplate>
                                                                <tr class="header2" style="position: sticky; top: 0; background-color: #f1f1f1; z-index: 10; margin-top: 0px; padding-top: 0px;">
                                                                    <th style="width: 20px; text-align: center;">STT</th>
                                                                    <th style="min-width: 450px; text-align: center;">Tên đơn vị</th>
                                                                    <th style="width: 150px; text-align: center;">Tổng số vụ án thụ lý</th>
                                                                    <th style="width: 150px; text-align: center;">Tổng số giải quyết</th>
                                                                    <th style="width: 150px; text-align: center;">Tỷ lệ giải quyết</th>
                                                                    <th style="width: 200px; text-align: center;">Tỷ lệ giải quyết so với cùng kỳ</th>
                                                                </tr>
                                                            </HeaderTemplate>

                                                            <ItemTemplate>
                                                                <tr class="header2">
                                                                    <td style="text-align: center;">
                                                                        <asp:Label runat="server" Font-Bold="true" Text='<%# Container.ItemIndex + 1 %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="lblCOLUMN_1" runat="server" ForeColor="#0E7EEE" Text='<%# Eval("TEN") %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_2" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Text='<%# Eval("COLUMN_1").ToString() %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_3" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Text='<%# Eval("COLUMN_2").ToString() %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_4" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Text='<%# Eval("COLUMN_3").ToString() %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_5" runat="server" ForeColor="#0E7EEE" Font-Bold="true"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>

                                                        </asp:Repeater>
                                                    </td>
                                                </tr>
                                            </table>

                                        </asp:Panel>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>

                </div>
            </asp:View>
        </asp:MultiView>


        <%-- <asp:View ID="ViewTAND" runat="server">
                <div class="view-content">

                    <asp:Panel ID="ViewTAND_M2" runat="server" Visible="false" Style="width: 1200px; border: none; align-items: center;">
                        <table class="table2" style="width: 1200px; border: none; align-items: center;">
                            <tr class="header2">
                                <td colspan="26" style="color: black; border: none; align-items: center;">
                                    <div style="font-size: 15px; display: flex; justify-content: space-between; align-items: center; width: 100%;">
                                        <div style="display: flex; align-items: center; margin-left: 40px;">
                                            <div style="margin-right: 10px; width: 90px">Chọn tiêu chí</div>
                                            <asp:DropDownList ID="ddlLoaiTimkiem" CssClass="chosen-select" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiTimkiem_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Tổng số vụ án thụ lý"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Tổng số giải quyết"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổng số Toà án có tỷ lệ giải quyết trên 50%"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Tổng số Toà án có tỷ lệ giải quyết dưới 50%"></asp:ListItem>
                                            </asp:DropDownList>
                                            <div style="margin-right: 10px; margin-left: 10px; width: 90px">Tòa xét xử</div>
                                            <div style="float: left; text-align: left;">
                                                <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                                            </div>
                                            <div style="margin-right: 10px; margin-left: 10px;">
                                                <asp:DropDownList ID="ddl_Load_Thoigian_STPT_M2" AutoPostBack="true" OnSelectedIndexChanged="ddl_Load_Thoigian_STPT_M2_SelectedIndexChanged"
                                                    CssClass="chosen-select" runat="server" Width="170px">
                                                    <asp:ListItem Value="week" Text="Tuần"></asp:ListItem>
                                                    <asp:ListItem Value="month" Text="Tháng" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="year" Text="Năm"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div style="margin-right: 10px; margin-left: 10px;">
                                                <asp:Button ID="btnXemBC_STPT_M2" runat="server" CssClass="buttoninput_uTK" Text="In báo cáo" OnClick="btnXemBC_STPT_M2_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="26" style="color: red; text-align: center; vertical-align: middle; margin-top: 5px; border: none;">
                                    <div style="display: flex; justify-content: center; align-items: center; height: 100%;">
                                        <asp:Label ID="lstTenBangtimkiem" Font-Size="20px" runat="server" Font-Bold="true" Height="30px"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <asp:Panel ID="pnLichsuXoaThuly" runat="server" align="center" Style="max-height: 500px; width: 1200px; overflow-y: auto;">
                                            <table class="table2" style="width: 900px;" border="1">
                                                <tr style="display: none;">
                                                    <td colspan="26" style="color: black; height: 0px;">
                                                        <asp:Repeater ID="rptToaan_STPT_M2" runat="server" OnItemDataBound="rptToaan_STPT_M2_ItemDataBound">
                                                            <HeaderTemplate>
                                                                <tr class="header2" style="position: sticky; top: 0; background-color: #f1f1f1; z-index: 10; margin-top: 0px; padding-top: 0px;">
                                                                    <th style="width: 20px; text-align: center;">STT</th>
                                                                    <th style="min-width: 450px; text-align: center;">Tên đơn vị</th>
                                                                    <th style="width: 150px; text-align: center;">Tổng số vụ án thụ lý</th>
                                                                    <th style="width: 150px; text-align: center;">Tổng số giải quyết</th>
                                                                    <th style="width: 150px; text-align: center;">Tỷ lệ giải quyết</th>
                                                                    <th style="width: 200px; text-align: center;">Tỷ lệ giải quyết so với cùng kỳ</th>
                                                                </tr>
                                                            </HeaderTemplate>

                                                            <ItemTemplate>
                                                                <tr class="header2">
                                                                    <td style="text-align: center;">
                                                                        <asp:Label runat="server" Font-Bold="true" Text='<%# Container.ItemIndex + 1 %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="lblCOLUMN_1" runat="server" ForeColor="#0E7EEE" Text='<%# Eval("TEN") %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_2" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Text='<%# Eval("COLUMN_1").ToString() %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_3" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Text='<%# Eval("COLUMN_2").ToString() %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_4" runat="server" ForeColor="#0E7EEE" Font-Bold="true" Text='<%# Eval("COLUMN_3").ToString() %>'></asp:Label>
                                                                    </td>
                                                                    <td style="text-align: center;">
                                                                        <asp:Label ID="lblCOLUMN_5" runat="server" ForeColor="#0E7EEE" Font-Bold="true"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>

                                                        </asp:Repeater>
                                                    </td>
                                                </tr>
                                            </table>

                                        </asp:Panel>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>

                </div>
            </asp:View>
        </asp:MultiView>--%>
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


