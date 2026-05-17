<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ThongKe.ascx.cs" Inherits="WEB.GSTP.UserControl.TP.ThongKe" %>
<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
<asp:HiddenField ID="hddPageSize" Value="6" runat="server" />
<script src="../../UI/js/Common.js"></script>
<style type="text/css">
    .TitleGroup {
        text-transform: uppercase;
        float: left;
        font-weight: bold;
        font-size: 18px;
        color: red;
    }

    .table2 .header {
        text-align: center;
    }

    .buttoninput_CA_Home_css {
        min-width: 80px;
        height: 30px;
        font-weight: bold;
        color: #631313;
        background: url("/UI/img/bg_danhsach.png");
        padding-left: 15px;
        padding-right: 15px;
        cursor: pointer;
        border: solid 1px #9e9e9e;
        border-radius: 3px 3px 3px 3px;
    }

        .buttoninput_CA_Home_css a {
            height: 30px;
        }
</style>
<asp:Panel ID="Pn_Show_To_Container" runat="server" Visible="true">
   
    <div style="float: left; width: 98%; margin: 0px 1%;" runat="server" id="Show_To_phanquyen_tk">
        <div id="tk_nopdonkhoikien" runat="server" class="tk_boxchung" style="width: 49%; margin-right: 2%;">
            <div class="tk_boder_content" style="padding-top: 10px; background: rgba(0, 0, 0, 0) linear-gradient(to left, #ffffff 0%, #fff478 130%) repeat scroll 0 0;">
                <div style="float: left;">
                    <div style="font-size: 14px; font-weight: bold;">
                        <a class="link_nopap" href="javascript:;" style="padding: 6px; color: #000000; text-decoration: dotted; font-size: 13px; float: left; width: 100%;" onclick="OpenPopupCenter()"><span style="float: left;">+ Số lượng đơn khởi kiện trực tuyến gửi đến Tòa chưa xử lý (sơ thẩm):</span>
                            <span style="color: #0E7EEE; font-size: 15px; float: left; margin-top: -1px; margin-left: 3px;">
                                <asp:Literal ID="li_soluong_dkk" runat="server" Text=""></asp:Literal>
                            </span>
                        </a>
                        <br />
                        <a class="link_nopap" href="javascript:;" style="padding: 6px; color: #000000; text-decoration: dotted; font-size: 13px; float: left; width: 100%;" onclick="OpenPopupCenter()"><span style="float: left;">+  Số lượng đơn khởi kiện từ toà án khác chuyển đến chưa xử lý (sơ thẩm):</span>
                            <span style="color: #0E7EEE; font-size: 15px; float: left; margin-top: -1px; margin-left: 3px;">
                                <asp:Literal ID="li_soluong_dkk_toakhac" runat="server" Text=""></asp:Literal>
                            </span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="tk_tamgiam" runat="server" class="tk_boxchung" style="width: 49%;">
            <div class="tk_boder_content" style="padding-top: 10px; background: rgba(0, 0, 0, 0) linear-gradient(to left, #ffffff 0%, #fff478 130%) repeat scroll 0 0;">
                <div style="float: left;">
                    <div style="font-size: 14px; font-weight: bold;">
                        <a class="link_nopap" href="javascript:;" style="padding: 6px; color: #000000; text-decoration: dotted; font-size: 13px; float: left; width: 100%;" onclick="OpenPopupCenter()"><span style="float: left;">+ Số lượng bị can, bị cáo còn thời hạn tạm giam dưới 5 ngày : </span>
                            <span style="color: #0E7EEE; font-size: 15px; float: left; margin-top: -1px; margin-left: 3px;">
                                <asp:Literal ID="lit_view_tongbc" runat="server" Text=""></asp:Literal>
                            </span>
                        </a>
                        <br />
                        <a class="link_nopap" href="javascript:;" style="padding: 6px; color: #000000; text-decoration: dotted; font-size: 13px; float: left; width: 100%;"  onclick="OpenPopupCenter_vks()"><span style="float: left;">+ Số hồ sơ viện kiểm sát đang giữ quá 25 ngày: </span>
                            <span style="color: #0E7EEE; font-size: 15px; float: left; margin-top: -1px; margin-left: 3px;">
                                <asp:Literal ID="lit_sohoso" runat="server" Text=""></asp:Literal>
                            </span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="tk_thongtin_tlgq_danhchochanhan" runat="server" class="tk_boxchung">
            <div class="tk_boder_content">
                <div style="font-size: 16px; color: red; text-align: center; font-family: Arial; font-weight: bold;">THÔNG TIN TÌNH HÌNH THỤ LÝ VÀ GIẢI QUYẾT ÁN DÀNH CHO CHÁNH ÁN</div>
                <div style="float: right;">
                    <div style="float: left; padding-top: 3px;">Cấp xét xử</div>
                    <div style="float: left; margin-left: 4px;">
                        <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="200px"
                            AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>
                <div style="margin-top: 30px;">
                    <asp:Panel ID="pn_canhbao" runat="server" Visible="true">
                        <table style="width: 100%;" class="table2">
                            <asp:Repeater ID="rpt_canhbao" runat="server" OnItemCommand="rpt_canhbao_ItemCommand"
                                OnItemCreated="rpt_canhbao_ItemCreated" OnItemDataBound="rpt_canhbao_ItemDataBound">
                                <HeaderTemplate>
                                    <tr class="header">
                                        <td style="width: 150px;">
                                            <asp:Label ID="lbl_donvi" runat="server" Text=""></asp:Label></a></td>
                                        <td style="width: 60px;">Tổng số</td>
                                        <td style="width: 60px;">Hình sự</td>
                                        <td style="width: 60px;">Dân sự</td>
                                        <td style="width: 60px;">Hôn nhân gia đinh</td>
                                        <td style="width: 60px;">Kinh doanh, thương mại</td>
                                        <td style="width: 60px;">Lao động</td>
                                        <td style="width: 60px;">Hành chính</td>
                                        <td style="width: 60px;">Phá sản</td>
                                        <td style="width: 60px;">Án chưa thành niên</td>
                                        <td style="width: 60px;">Các biện pháp xử lý hành chính</td>
                                    </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr class="row_center">
                                        <td runat="server" id="TEN_BC">
                                            <div align="left" style="color: #000000; font: 14px; font-weight: bold;"><%# Eval("TEN_BC") %></div>
                                        </td>
                                        <td class="row_center" runat="server" id="TONG_CONG">
                                            <b style="font-size: 14px; color: red;"><%# Eval("TONG_CONG")  %></b>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_1">
                                            <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_1" Text='<%# Eval("COLUMN_1")  %>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_2">
                                            <asp:LinkButton ID="LinkButton2" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_2" Text='<%# Eval("COLUMN_2")%>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_3">
                                            <asp:LinkButton ID="LinkButton3" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_3" Text='<%# Eval("COLUMN_3")%>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_4">
                                            <asp:LinkButton ID="LinkButton4" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_4" Text='<%# Eval("COLUMN_4")%>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_5">
                                            <asp:LinkButton ID="LinkButton5" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_5" Text='<%# Eval("COLUMN_5")%>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_6">
                                            <asp:LinkButton ID="LinkButton6" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_6" Text='<%# Eval("COLUMN_6")%>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_7">
                                            <asp:LinkButton ID="LinkButton7" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_7" Text='<%# Eval("COLUMN_7")%>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_8">
                                            <asp:LinkButton ID="LinkButton8" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_8" Text='<%# Eval("COLUMN_8")%>'></asp:LinkButton>
                                        </td>
                                        <td class="row_center" runat="server" id="COLUMN_9">
                                            <asp:LinkButton ID="LinkButton9" runat="server" ForeColor="#0E7EEE"
                                                Font-Bold="true" CommandArgument='<%# Eval("LOAI_BC")  %>'
                                                CommandName="COLUMN_9" Text='<%# Eval("COLUMN_9")%>'></asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></FooterTemplate>
                            </asp:Repeater>
                        </table>
                    </asp:Panel>
                </div>
                <div style="height: 20px; font-size: 14px; font-weight: bold; margin-top: 10px;">
                    <a class="link_nopap" href="javascript:;" style="padding: 6px; color: red; text-decoration: dotted; font-size: 13px; float: left;" onclick="Open_TKChiTiet()">Xem thêm các tiêu chí thống kê >>                                                                                                                                   </span>
                    </a>
                </div>
            </div>
        </div>
        <div class="tk_boxchung" style="display: none;">
            <div class="tk_boder_content" runat="server" id="tk_boder_contents" style="display: none">
                <asp:Panel ID="pnChanhAn" runat="server" Visible="false">
                    <table style="width: 100%;">
                        <tr>
                            <td>
                                <div class="TitleGroup">
                                    <asp:Literal ID="LtrTenCA_PCA" runat="server" Text=""></asp:Literal>
                                </div>
                            </td>
                            <td>
                                <asp:Button ID="cmdInBaoCao" runat="server" CssClass="buttoninput_CA_Home_css" Style="float: right;" Text="In báo cáo" OnClick="cmdInBaoCao_Click" />
                                <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Style="float: right; margin-right: 20px; width: 100px; text-align: center; height: 24px;"></asp:TextBox>
                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Style="float: right; margin-right: 20px; width: 100px; text-align: center; height: 24px;"></asp:TextBox>
                                <span style="float: right; margin-right: 20px; font-weight: bold; margin-top: 8px;">Số liệu từ ngày:</span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Label runat="server" ID="LblthongBao" ForeColor="Red"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div style="float: left; margin-left: 50px;">
                                    <div style="float: left; margin-top: 17px; width: 1000px;">
                                        <div style="font-size: 13px; font-weight: bold; width: 300px; float: left;">
                                            TS vụ từ kỳ trước chuyển sang: ...;
                                        </div>
                                        <div style="font-size: 13px; font-weight: bold; width: 300px; float: left;">
                                            TS vụ mới thụ lý: ...;
                                        </div>
                                        <div style="font-size: 13px; font-weight: bold; width: 300px; float: left;">
                                            TS vụ đã giải quyết: ...;
                                        </div>
                                    </div>
                                    <div style="float: left; margin-top: 7px; width: 1000px;">
                                        <div style="font-size: 13px; font-weight: bold; width: 300px; float: left;">
                                            TS vụ chưa giải quyết xong: ...;
                                        </div>
                                        <div style="font-size: 13px; font-weight: bold; width: 300px; float: left;">
                                            Tỷ lệ giải quyết: ...;
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <%--------------chanh an st pt---------------------------------------%>
                    <table class="table2" style="">
                        <tr style="text-align: center; background-color: #db212d; color: #ffffff; line-height: 17px; font-size: 12px; font-family: Arial; font-weight: bold;">
                            <td rowspan="2">Cấp xét xử</td>
                            <td rowspan="2">Loại án </td>
                            <td rowspan="2">Nhập vụ án</td>
                            <td rowspan="2">Chuyển vụ án</td>
                            <td rowspan="2">Án tồn chuyển sang </td>
                            <td rowspan="2">Án chờ thụ lý </td>
                            <td colspan="2">Đã thụ lý</td>
                            <td rowspan="2">Đã lên lịch xét xử</td>
                            <td rowspan="2">Đã giải quyết</td>
                            <td rowspan="2">Còn lại(Chưa GQ xong)</td>
                            <td rowspan="2">Án TĐC</td>
                            <td rowspan="2">Án bị sửa/hủy</td>
                            <td colspan="2">Án quá hạn</td>
                        </tr>
                        <tr style="text-align: center; background-color: #db212d; color: #ffffff; line-height: 17px; font-size: 12px; font-family: Arial; font-weight: bold;">
                            <td>Chưa aphân công TP</td>
                            <td>Đã phân công TP</td>
                            <td>Đang giải quyết</td>
                            <td>Đã giải quyết</td>
                        </tr>
                        <asp:Literal ID="Li_sotham" runat="server" Text=""></asp:Literal>
                        <asp:Repeater ID="rptThongke_st" runat="server">
                            <HeaderTemplate></HeaderTemplate>
                            <ItemTemplate>
                                <tr class="row_center" style="text-align: left;">
                                    <td class="row_center" style="text-align: left;">
                                        <b style="color: #0e7eee;"><%#Eval("LOAI_AN_TEN") %></b>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate></FooterTemplate>
                        </asp:Repeater>
                        <asp:Literal ID="li_phuctham" runat="server" Text=""></asp:Literal>
                        <asp:Repeater ID="rptThongke_pt" runat="server">
                            <HeaderTemplate></HeaderTemplate>
                            <ItemTemplate>
                                <tr class="row_center" style="text-align: left;">
                                    <td class="row_center" style="text-align: left;">
                                        <b style="color: #0e7eee;"><%#Eval("LOAI_AN_TEN") %></b>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate></FooterTemplate>
                        </asp:Repeater>
                    </table>
                    <%-----------------------------------------------------%>
                    <table class="table2" style="margin-top: 15px;">
                        <tr class="header">
                            <td rowspan="2" style="width: 100px;">Cấp xét xử</td>
                            <td rowspan="2">Loại án</td>
                            <td rowspan="2" style="width: 80px;">Nhập vụ án</td>
                            <td rowspan="2" style="width: 80px;">Chuyển vụ án</td>
                            <td rowspan="2" style="width: 80px;">Án tồn<br />
                                chuyển sang</td>
                            <td rowspan="2" style="width: 80px;">Án chờ thụ lý</td>
                            <td colspan="2">Đã thụ lý</td>
                            <td rowspan="2" style="width: 80px;">Đã lên lịch xét xử</td>
                            <td rowspan="2" style="width: 80px;">Đã giải quyết</td>
                            <td rowspan="2" style="width: 80px;">Còn lại<br />
                                (Chưa GQ xong)</td>
                            <td rowspan="2" style="width: 80px;">Án TĐC</td>
                            <td rowspan="2" style="width: 80px;">Án bị sửa/hủy</td>
                            <td colspan="2">Án quá hạn</td>
                        </tr>
                        <tr class="header">
                            <td style="width: 80px;">Chưa<br />
                                phân công TP</td>
                            <td style="width: 80px;">Đã<br />
                                phân công TP</td>
                            <td style="width: 80px;">Đang giải quyết</td>
                            <td style="width: 80px;">Đã giải quyết</td>
                        </tr>
                        <asp:Literal ID="ltrContent" runat="server" Text=""></asp:Literal>
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnThamPhan" runat="server" Visible="false">
                    <div style="margin-bottom: 5px; margin-top: 15px; float: left;">
                        <span class="TitleGroup">
                            <asp:Literal ID="LtrSoLuongTP" runat="server" Text=""></asp:Literal></span>
                    </div>
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
                    <asp:DataGrid ID="dgTKThamphan" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgTKThamphan_ItemCommand">
                        <Columns>
                            <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>TT</HeaderTemplate>
                                <ItemTemplate><%#Convert.ToInt32(Eval("V_STT"))>0? Eval("V_STT"):"" %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Thẩm phán</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtTenThamPhan" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Eval("v_TENTHAMPHAN"):"<b>"+Eval("v_TENTHAMPHAN")+"</b>" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Nhập vụ án</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtNhapVuAn" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                        <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_NHAPVUAN")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_NHAPVUAN")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Chuyển vụ án</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtChuyenVuAn" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_CHUYENVUAN")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_CHUYENVUAN")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>TS án được phân công</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtAnDuocPC" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_AN_DUOC_PC")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_AN_DUOC_PC")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Đã giải quyết xong</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtDaGQ" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_AN_DA_GQ")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_AN_DA_GQ")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Còn lại</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtConLai" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_CON_LAI")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_CON_LAI")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Đã lên lịch xét xử</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtLenLichXetXu" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_DA_LEN_LICH_XET_XU")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_DA_LEN_LICH_XET_XU")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Đang hoãn</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtDangHoan" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_DANG_HOAN")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_DANG_HOAN")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Tạm đình chỉ</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtTDC" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_AN_TDC")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_AN_TDC")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Án hủy</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtAnHuy" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_AN_HUY")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_AN_HUY")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Án sửa</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtAnSua" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_AN_SUA")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_AN_SUA")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Án quá hạn đang GQ</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtAnQH_DangGQ" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_AN_QH_DANG_GQ")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_AN_QH_DANG_GQ")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="80px">
                                <HeaderTemplate>Án quá hạn đã GQ xong</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtAnQH_DaGQ" runat="server" CommandArgument='<%#Eval("v_THAMPHANID") %>' CommandName="ChiTiet">
                                    <%#Convert.ToInt32(Eval("V_STT"))>0? Convert.ToDecimal(Eval("v_AN_QH_DA_GQ")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN")):"<b>"+Convert.ToDecimal(Eval("v_AN_QH_DA_GQ")).ToString("#,0.###",new System.Globalization.CultureInfo("vi-VN"))+"</b" %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                    <div class="phantrang">
                        <div class="sobanghi">
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
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Panel>
<script type="text/javascript">
    function popup_inbaocao_home() {
        var link = "/UserControl/TP/Inbaocao_Home.aspx";
        var width = screen.width - 200;
        var height = 800;
        PopupCenter(link, "In báo cáo tổng hợp án của đơn vị.", width, height);
    }
    function OpenPopupCenter() {
        var pageURL = "/UserControl/TP/Lenhtamgiam_Home.aspx";
        var w = 1000;
        var h = 550;
        var title = "";
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        return targetWin;
    }
        function OpenPopupCenter_vks() {
        var pageURL = "/UserControl/TP/hoso_vks_Home.aspx";
        var w = 1100;
        var h = 550;
        var title = "";
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        return targetWin;
    }
    function Open_TKChiTiet() {
        var pageURL = "/UserControl/TP/ThongKe_ChiTiet.aspx";
        var w = 1000;
        var h = 550;
        var title = "";
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        return targetWin;
    }
</script>
<script type="text/javascript">
    function pageLoad(sender, args) {
        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
        for (var selector in config) { $(selector).chosen(config[selector]); }
    }
</script>

