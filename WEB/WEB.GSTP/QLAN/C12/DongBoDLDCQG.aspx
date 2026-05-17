<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DongBoDLDCQG.aspx.cs" Inherits="WEB.GSTP.QLAN.C12.DongBoDLDCQG" Async="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../UI/js/src_duallistbox/bootstrap.min.js"></script>
    <%--<link href="../../UI/js/src_duallistbox/bootstrap.min.css" rel="stylesheet" />--%>
    <link href="modal.css" rel="stylesheet" />
    <style>
        .form_tt {
            margin: 0 auto;
            position: relative;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .t-w-100 {
            width: 100% !important;
            max-width: 100%;
            min-width: 100%;
            resize: vertical;
        }

        .d-modal-title {
            float: left;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 12px;
            color: #ffffff;
            border-left: 0px;
            border-right: solid 1px #ea3f42;
            padding-left: 12px;
            padding-right: 12px;
            border-bottom: 0px;
            border-top: 0px;
            background: #db212d;
            font-weight: bold;
            cursor: pointer;
        }

        .overlay {
            position: fixed;
            width: 100%;
            height: 100%;
            z-index: 1100;
            background: rgba(239, 239, 240, 0.3);
            top: 0;
            left: 0px;
            opacity: 0.5;
        }

        .mb-1 {
            margin-bottom: 5px;
        }

        .d-toast {
            position: fixed;
            z-index: 100000;
        }

        .d-toast-body {
            margin-bottom: 0px;
        }

        .d-none {
            display: none;
        }

        .d-width {
            max-width: 300px;
        }

            .d-width .chosen-container-single {
                width: 100% !important;
            }

        .gridview {
            border-collapse: collapse;
            width: 100%;
        }

            .gridview th {
                background-color: red;
                color: white;
                border: 1px solid black;
                padding: 12px;
                text-align: center;
            }

            .gridview td {
                border: 1px solid black;
                padding: 6px;
            }

            .gridview tr:nth-child(even) {
                background-color: #f9f9f9;
            }

        .btn-break {
            display: block;
            margin-bottom: 8px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 1050px">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại án</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="248px">
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số BA/QĐ </div>
                                                    <div style="float: left; margin-right: 15px;">
                                                        <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 15px;">Từ ngày </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                    </div>
                                                    <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="65px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tội danh/ QHPL</div>
                                                    <div style="float: left; margin-right: 15px">
                                                        <asp:TextBox ID="txt_toidanh" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Bị can /Bị cáo/ Đương sự</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtBiCan" CssClass="user" runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Cấp xét xử</div>
                                                    <div style="float: left; margin-right: 15px">
                                                        <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="250px"
                                                            AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tòa xx</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; padding-top: 10px">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số CCCD</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtCCCD_SO" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                    <div style="float: left; margin-right: 15px;">
                                                        <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                    </div>
                                                </div>

                                                <div style="float: left; width: 1050px; margin-top: 4px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái đồng bộ</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlTrangthaiDongBo" CssClass="chosen-select" runat="server" Width="248px" AutoPostBack="True" OnSelectedIndexChanged="ddlTrangthaiDongBo_SelectedIndexChanged">
                                                            <asp:ListItem Value="1" Text="Chưa đồng bộ" Selected="True"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Đã đồng bộ"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Bị thu hồi"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYGUI_TU" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_NGAYGUI_TU" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_NGAYGUI_TU" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYGUI_DEN" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAYGUI_DEN" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_NGAYGUI_DEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td align="center">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                            <asp:Button ID="btnGuiDLC06" runat="server" CssClass="buttoninput" Text="Đồng bộ dữ liệu" OnClick="btnGuiDLDB_Click" OnClientClick="return confirm('Bạn có chắc chẳn muốn đồng bộ dữ liệu không? Bạn phải chịu trách nhiệm về hành động này');" />
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2" align="left">
                            <asp:Panel ID="pn_thuhoi" runat="server" Visible="false">
                                <div>
                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px; padding-top: 8px; font-weight: bold;">Lý do thu hồi</div>
                                    <div style="float: left; margin-right: 10px; padding-top: 3px">
                                        <asp:TextBox ID="txtLyDoThuHoi" CssClass="user" runat="server" Width="240px" placeholder="Nhập lý do thu hồi..."></asp:TextBox>
                                    </div>
                                    <div style="float: left; padding-bottom: 5px;">
                                        <asp:Button ID="btnThuHoi" runat="server" CssClass="buttoninput" Text="Thu hồi" OnClick="btnThuHoi_Click" OnClientClick="return validateThuHoi();" />
                                    </div>
                                </div>
                            </asp:Panel>

                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click">
                                    </asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>


                            <%--14-11-2025 dataGrid cho loai an HS--%>
                            <div>
                                <asp:DataGrid ID="gvDanhSach" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemDataBound="gvDanhSach_RowDataBound"
                                    OnItemCommand="gvList_RowCommand">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderText="">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" AutoPostBack="true"
                     OnCheckedChanged="chkChon_CheckedChanged"
                                                    ToolTip='<%#Eval("LOAIAN_ID") +","+Eval("LOAIBAQD")+","+Eval("BAQD_ID") +","+ Eval("CAPXX_MA")+","+ Eval("KHOBAQDID") +","+Eval("toaanId")+","+Eval("TRANGTHAIBAQD")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn DataField="STT" HeaderText="STT" ItemStyle-HorizontalAlign="Center" />

                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án" HeaderStyle-HorizontalAlign="Center" />

                                        <asp:TemplateColumn HeaderText="Thông tin vụ án" HeaderStyle-HorizontalAlign="Center" >
                                            <ItemTemplate>
                                                <i>Mã vụ án:</i> <b><%# Eval("MavuAn") %></b><br />
                                                <i>Cấp xét xử:</i> <b><%# Eval("CAPXX") %></b><br />
                                                <i>Thụ lý:</i> <b><%# Eval("THULY") %></b><br />
                                                <i>Thẩm phán:</i> <b><%# Eval("THAMPHAN_TEN") %></b>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn HeaderStyle-Width="200px" HeaderText="Thông tin bị cáo đầu vụ" HeaderStyle-HorizontalAlign="Center" >
                                            <ItemTemplate>
                                                <i>Tên bị cáo:</i> <b><%# Eval("BICAODAUVU_HOTEN") %></b><br />
                                                <i>Ngày sinh:</i> <b><%# Eval("BICAODAUVU_NGAYSINH") %></b><br />
                                                <i>Số CCCD:</i> <b><%# Eval("BICAODAUVU_SO_CCCD") %></b>
                                                <br />
                                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="false" Text='<%# "Xem bị can, bị cáo: " + Eval("SO_DUONGSU") %>' Font-Bold="true" ForeColor="#0e7eee" CommandName="ViewDuongSu"
                                                    CommandArgument='<%#Eval("KHOBAQDID") +","+ Eval("LOAIAN_ID")+","+ Eval("DONID")+","+Eval("capxx_ma")+","+Eval("loaibaqd")+","+Eval("SO_BAN_AN")+","+Eval("banan_ngay_ba")+","+Eval("BICAN_NGAYHIEULUC")%>' ToolTip="Xem bị can bị cáo"></asp:LinkButton>
                                                <br />
                                                <asp:LinkButton ID="LinkButtonDuongSuDongBo" runat="server" CausesValidation="false" Text='<%# "Số bị can, bị cáo đồng bộ: " + Eval("SO_DUONGSU_DONGBO") %>' Font-Bold="true" ForeColor="#0e7eee" CommandName="ViewDuongSuDongBo"
                                                    CommandArgument='<%#Eval("KHOBAQDID") +","+ Eval("LOAIAN_ID")+","+ Eval("DONID")+","+Eval("capxx_ma")+","+Eval("loaibaqd")%>' ToolTip="Số bị can, bị cáo đồng bộ"></asp:LinkButton>
                                                <br />
                                                <asp:LinkButton ID="LinkButtonDuongSuChuaDongBo" runat="server" CausesValidation="false" Text='<%# "Số bị can, bị cáo chưa đồng bộ: " + Eval("SO_DUONGSU_CHUADONGBO") %>' Font-Bold="true" ForeColor="#0e7eee" CommandName="ViewDuongSuChuaDongBo"
                                                    CommandArgument='<%#Eval("KHOBAQDID") +","+ Eval("LOAIAN_ID")+","+ Eval("DONID")+","+Eval("capxx_ma")+","+Eval("loaibaqd")%>' ToolTip="Số bị can, bị cáo chưa đồng bộ"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn HeaderText="Kết quả giải quyết" HeaderStyle-HorizontalAlign="Center" >
                                            <ItemTemplate>
                                                <i>Số BA/QD:</i> <%# Eval("SO_BAN_AN") %><br />
                                                <i>Ngày BA/QD:</i> <%# Eval("banan_ngay_ba") %><br />
                                                <i>Tội danh:</i> <b><%# Eval("TENTOIDANH") %></b><br />
                                                <br />
                                                <i>Hình phạt tổng hợp:</i> <b><%# Eval("TENHINHPHAT") %></b><br />
                                                <i>Ngày hiệu lực:</i> <%# Eval("BICAN_NGAYHIEULUC") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderText="Tình trạng đồng bộ" HeaderStyle-HorizontalAlign="Center" >
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <b><%#Eval("TRANGTHAIBAQDNAME")%></b>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn DataField="GHICHU" HeaderText="Ghi chú" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" />

                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderText="Thao tác" HeaderStyle-HorizontalAlign="Center" >
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButtonXemLichSu" runat="server" CausesValidation="false" Text="Xem lịch sử" Font-Bold="true" ForeColor="#0e7eee" CommandName="View"
                                                    CommandArgument='<%#Eval("KHOBAQDID") %>' ToolTip="Xem lịch sử" CssClass="btn-break"></asp:LinkButton>

                                                <asp:LinkButton ID="LinkButtonXemGuiLai" runat="server" CausesValidation="false" Text="Gửi lại" Font-Bold="true" ForeColor="#0e7eee" CommandName="GuiLai" CommandArgument='<%#Eval("KHOBAQDID") %>'
                                                    ToolTip="Gửi lại" OnClientClick="return confirm('Bạn có chắc gửi lại không? Bạn phải chịu trách nhiệm về hành động này?');" CssClass="btn-break"></asp:LinkButton>

                                                <asp:LinkButton ID="LinkButtonHuyChuyen" runat="server" Text="Hủy chuyển"
                                                    CommandName="HuyChuyen"
                                                    CommandArgument='<%#Eval("KHOBAQDID")%>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" CssClass="btn-break" />

                                                <i>Tài khoản gửi:</i> <%#Eval("NGUOIGUI")%><br />
                                                <i>Ngày gửi:</i> <%#Eval("NGAYGUI")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </div>
                            <%--End dataGrid cho loai an HS--%>


                            <%-- --------------------------- START dataGrid cho 5 loại án --------------------%>
                            <div>
                                <asp:DataGrid ID="DgList_All" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="DgList_All_ItemCommand" OnItemDataBound="DgList_All_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="DONID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center">

                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" AutoPostBack="true"
    OnCheckedChanged="chkChon_CheckedChanged" ToolTip='<%#Eval("LOAIAN_ID") +","+ Eval("LOAIBAQD")+","+ Eval("BAQD_ID") +"," + Eval("CAPXX")+","+ Eval("KHOBAQDID")+"," + Eval("DON_VI_RA_BAN_AN_ID")+","+Eval("TRANGTHAIBAQD")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án" HeaderStyle-Width="70px"
                                            ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Mã vụ án</HeaderTemplate>
                                            <ItemTemplate><%#Eval("MAVUAN")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Thông tin vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <i style='margin-right: 3px;'>Tên vụ việc:</i>  <b><%#Eval("TenVuAn")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("CAPXX")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Thụ lý:</i>  <b><%#Eval("THULY")%></b>
                                                <br />
                                                <b><i style='margin-right: 3px;'>Nguyên đơn:</i></b><%#Eval("HO_TEN_NGUYEN_DON")%>
                                                <i style='margin-right: 3px;'>- Ngày sinh:</i><%#Eval("NGAY_SINH_NGUYEN_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Số CCCD:</i><%#Eval("SO_GIAY_TO_NGUYEN_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Địa chỉ:</i><%#Eval("DIACHI_NGUYEN_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Quốc tịch:</i><%#Eval("QUOC_TICH_NGUYEN_DON")%>
                                                <br />
                                                <b><i style='margin-right: 3px;'>Bị đơn:</i></b><%#Eval("HO_TEN_BI_DON")%>
                                                <i style='margin-right: 3px;'>- Ngày sinh:</i><%#Eval("NGAY_SINH_BI_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Số CCCD:</i><%#Eval("SO_GIAY_TO_BI_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Địa chỉ:</i><%#Eval("DIACHI_BI_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Quốc tịch:</i><%#Eval("QUOC_TICH_BI_DON")%>

                                                <br />
                                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="false" Text='<%# "Xem đương sự: " + Eval("SO_DUONGSU") %>' Font-Bold="true" ForeColor="#0e7eee" CommandName="ViewDuongSu"
                                                    CommandArgument='<%#Eval("KHOBAQDID") +","+ Eval("LOAIAN_ID")+","+ Eval("DONID")+","+Eval("SO_BAN_AN")+","+Eval("NGAY_RA_BAN_AN")+","+Eval("NGAY_HIEU_LUC_BA")%>' ToolTip="Xem đương sự"></asp:LinkButton>
                                                <br />
                                                <asp:LinkButton ID="LinkButtonDuongSuDongBo" runat="server" CausesValidation="false" Text='<%# "Số đương sự đồng bộ: " + Eval("SO_DUONGSU_DONGBO") %>' Font-Bold="true" ForeColor="#0e7eee" CommandName="ViewDuongSuDongBo"
                                                    CommandArgument='<%#Eval("KHOBAQDID") +","+ Eval("LOAIAN_ID")+","+ Eval("DONID")%>' ToolTip="Đương sự đồng bộ" Visible='<%# Eval("SO_DUONGSU_DONGBO").ToString() == "0" %>'></asp:LinkButton>
                                                <br />
                                                <asp:LinkButton ID="LinkButtonDuongSuChuaDongBo" runat="server" CausesValidation="false" Text='<%# "Số đương sự chưa đồng bộ: " + Eval("SO_DUONGSU_CHUADONGBO") %>' Font-Bold="true" ForeColor="#0e7eee" CommandName="ViewDuongSuChuaDongBo"
                                                    CommandArgument='<%#Eval("KHOBAQDID") +","+ Eval("LOAIAN_ID")+","+ Eval("DONID")%>' ToolTip="Đương sự chưa đồng bộ" Visible='<%# Eval("SO_DUONGSU_CHUADONGBO").ToString() == "0" %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Kết quả giải quyết
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <i style='margin-right: 3px;'>Số BA/QD:</i><%#Eval("SO_BAN_AN")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Ngày BA/QD:</i><%#Eval("NGAY_RA_BAN_AN")%>
                                                <br />
                                                <b><i style='margin-right: 3px;'>Ngày hiệu lực:</i></b><%#Eval("NGAY_HIEU_LUC_BA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tình trạng đồng bộ</HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <b><%#Eval("TRANGTHAIBAQDNAME")%></b>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ghi chú</HeaderTemplate>
                                            <ItemTemplate><span class="trangthai"><%#Eval("ghiChu")%></span></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButtonXemLichSu" runat="server" CausesValidation="false" Text="Xem lịch sử" Font-Bold="true" ForeColor="#0e7eee" CommandName="View"
                                                    CommandArgument='<%#Eval("KHOBAQDID") %>' ToolTip="Xem lịch sử" CssClass="btn-break"></asp:LinkButton>
                                                <asp:LinkButton ID="LinkButtonXemGuiLai" runat="server" CausesValidation="false" Text="Gửi lại" Font-Bold="true" ForeColor="#0e7eee" CommandName="GuiLai" CommandArgument='<%#Eval("KHOBAQDID") %>'
                                                    ToolTip="Gửi lại" OnClientClick="return confirm('Bạn có chắc muốn Gửi lại không?');" CssClass="btn-break"></asp:LinkButton>

                                                <asp:LinkButton ID="LinkButtonHuyChuyen" runat="server" Text="Hủy chuyển"
                                                    CommandName="HuyChuyen"
                                                    CommandArgument='<%#Eval("KHOBAQDID")%>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" CssClass="btn-break" />

                                                <i style='margin-right: 3px;'>Tài khoản gửi:</i><%#Eval("TAIKHOANTAO")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Ngày gửi:</i><%#Eval("NGAYGUI")%>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                            <HeaderTemplate>Người tạo</HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="width: 90px;"><%#Eval("NGUOITAO")%></div>
                                                <br />
                                                <%# Eval("NgayTao") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>
                            <%-- --------------------------- END dataGrid cho 5 loại án --------------------%>

                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                        CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click">
                                    </asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>
    <script>


        function validateThuHoi() {
            var txtLyDoThuHoi = document.getElementById('<%=txtLyDoThuHoi.ClientID%>');
            if (txtLyDoThuHoi.value == '') {
                alert('Chưa nhập Lý do thu hồi. Hãy nhập lại!');
                txtLyDoThuHoi.focus();
                return false;
            }

            return confirm('Bạn có chắc muốn thu hồi dữ liệu không?');;

        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
