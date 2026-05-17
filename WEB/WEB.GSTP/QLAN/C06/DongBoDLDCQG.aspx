<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DongBoDLDCQG.aspx.cs" Inherits="WEB.GSTP.QLAN.C06.DongBoDLDCQG" Async="true" %>

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
                                                            <%--<asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>--%>
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
                            <asp:Button ID="btnGuiDLC06" runat="server" CssClass="buttoninput" Text="Đồng bộ dữ liệu" OnClick="btnGuiDLC06_Click" OnClientClick="return confirm('Bạn có chắc muốn đồng bộ dữ liệu không?');"/>

                            <%-- 
                                GTEL-HUNGNQ 01/10/2025 thêm confirm trước khi gửi đồng bộ
                                Cho nút hủy chuyển lên trên tích chọn
                            --%>
                            <asp:Button ID="btnHuyChuyen" runat="server" CssClass="buttoninput" Text="Hủy Chuyển" Visible="false" OnClick="btnHuyChuyenC06_Click" OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" />
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
                            <div>
                                <%--Chua dong bo--%>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <%--<asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>--%>
                                        <asp:BoundColumn DataField="DONID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <%--<HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>--%>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" onclick="OnlySelectOne(this);" ToolTip='<%#Eval("LOAIAN_ID") +","+ Eval("LOAIBAQD")+","+ Eval("BAQD_ID") +","+ Eval("KHANGCAOQH")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án"
                                            HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MavuAn")%>
                                            </ItemTemplate>
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
                                                <b><i style='margin-right: 3px;'>Nguyễn đơn:</i></b><%#Eval("HO_TEN_NGUYEN_DON")%>
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
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
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
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng ly hôn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 1 ? "Ly hôn" :
                                                        Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 3 ? "Không công nhận vợ chồng" :
                                                        ""
                                                    %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng bản ghi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ghi chú
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("ghiChu")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <b><%#Eval("TRANGTHAIGUI")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Tài khoản gửi:</i><%#Eval("TAIKHOANGUI")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Ngày gửi:</i><%#Eval("NGAYGUI")%>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Người tạo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="width: 90px;">
                                                    <%#Eval("NGUOITAO")%>
                                                </div>
                                                <br />
                                                <%# Eval("NgayTao") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>

                                <%-- Đã đồng bộ--%>
                                <asp:DataGrid ID="dgList_DaDB" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_DaDB_ItemCommand" OnItemDataBound="dgList_DaDB_ItemDataBound">
                                    <Columns>
                                        <%--<asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>--%>
                                        <asp:BoundColumn DataField="DONID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <%--<HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>--%>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" onclick="OnlySelectOne(this);" ToolTip='<%#Eval("ID")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án"
                                            HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MavuAn")%>
                                            </ItemTemplate>
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
                                                <b><i style='margin-right: 3px;'>Nguyễn đơn:</i></b><%#Eval("HO_TEN_NGUYEN_DON")%>
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
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
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
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng ly hôn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#
                                                        Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 1 ? "Ly hôn" :
                                                        Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 3 ? "Không công nhận vợ chồng" :
                                                        "" 
                                                        
                                                    %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng bản ghi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ghi chú
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("ghiChu")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <b><%#Eval("TRANGTHAIGUI")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Tài khoản gửi:</i><%#Eval("TAIKHOANGUI")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Ngày gửi:</i><%#Eval("NGAYGUI")%>
                                                <br />
                                                <asp:LinkButton ID="lbtHuyChuyen" runat="server" CausesValidation="false" Text="Hủy chuyển" Font-Bold="true" ForeColor="#0e7eee" CommandName="HuyChuyen"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip="Hủy chuyển" Visible="false" OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');"></asp:LinkButton>
                                                <br />
                                                <asp:LinkButton ID="lbtView" runat="server" CausesValidation="false" Text="Xem lịch sử" Font-Bold="true" ForeColor="#0e7eee" CommandName="View"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip="Xem lịch sử" Visible="false"></asp:LinkButton>

                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Ngày đồng bộ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="width: 90px;">
                                                    <%#Eval("NGAYDONGBO")%>
                                                    </br>
                                                    <%#Eval("maDinhDanhBanAn")%>
                                                </div>

                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>

                                <%--Bị thu hồi--%>
                                <asp:DataGrid ID="dgList_Thuhoi" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ThuHoi_ItemCommand" OnItemDataBound="dgList_ThuHoi_ItemDataBound">
                                    <Columns>
                                        <%--<asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>--%>
                                        <asp:BoundColumn DataField="DONID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <%--<HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>--%>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" onclick="OnlySelectOne(this);" ToolTip='<%#Eval("ID")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án"
                                            HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MavuAn")%>
                                            </ItemTemplate>
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
                                                <b><i style='margin-right: 3px;'>Nguyễn đơn:</i></b><%#Eval("HO_TEN_NGUYEN_DON")%>
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
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
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
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng ly hôn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#
                                                        Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 1 ? "Ly hôn" :
                                                        Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 3 ? "Không công nhận vợ chồng" :
                                                        "" 
                                                        
                                                    %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng bản ghi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ghi chú
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("ghiChu")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>

                                                <asp:LinkButton ID="lbtGuiLai" runat="server" CausesValidation="false" Text="Gửi lại" Font-Bold="true" ForeColor="#0e7eee" CommandName="GuiLai"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip="Gửi lại" OnClientClick="return confirm('Bạn có chắc muốn Gửi lại không?');"></asp:LinkButton>

                                                <br />

                                                <b><%#Eval("TRANGTHAIGUI")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Tài khoản gửi:</i><%#Eval("TAIKHOANGUI")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Ngày gửi:</i><%#Eval("NGAYGUI")%>
                                                <br />
                                                <asp:LinkButton ID="lbtView" runat="server" CausesValidation="false" Text="Xem lịch sử" Font-Bold="true" ForeColor="#0e7eee" CommandName="View"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip="Xem lịch sử" Visible="false"></asp:LinkButton>

                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Ngày đồng bộ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="width: 90px;">
                                                    <%#Eval("NGAYDONGBO")%>
                                                     </br>
                                                    <%#Eval("maDinhDanhBanAn")%>
                                                </div>

                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>

                            <%--GETL-DUCPH: 24-09-2025 them cac dataGrid cho loai an Hinh Su và chỉnh sửa fixbug --%>
                            <%---- ----------Chuyển sang sử dụng gridView chung cho các màn hình ----------------%>
                            <div>
                                <asp:GridView ID="gvDanhSach" runat="server" AutoGenerateColumns="False" Visible="false"
                                    CssClass="gridview" Width="100%"
                                    OnRowDataBound="gvDanhSach_RowDataBound"
                                    OnRowCommand="gvList_RowCommand"
                                    AllowPaging="true" PageSize="20">
                                    <Columns>
                                        <asp:TemplateField HeaderStyle-Width="20px" HeaderText="">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server"
                                                    ToolTip='<%#Eval("BICAOID") +","+ Eval("CAPXX_MA")+","+ Eval("LOAIBAQD") + "," + Eval("C06_AHS_ID")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="STT" HeaderText="STT" ItemStyle-HorizontalAlign="Center" />

                                        <asp:BoundField DataField="LOAI_AN_TEN" HeaderText="Loại án" />

                                        <asp:TemplateField HeaderText="Thông tin vụ án">
                                            <ItemTemplate>
                                                <i>Mã vụ án:</i> <b><%# Eval("MavuAn") %></b><br />
                                                <i>Cấp xét xử:</i> <b><%# Eval("CAPXX") %></b><br />
                                                <i>Thụ lý:</i> <b><%# Eval("THULY") %></b><br />
                                                <i>Thẩm phán:</i> <b><%# Eval("THAMPHAN_TEN") %></b>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Thông tin bị cáo">
                                            <ItemTemplate>
                                                <i>Tên bị cáo:</i> <b><%# Eval("BICAN_TEN") %></b><br />
                                                <i>Ngày sinh:</i> <b><%# Eval("BICAN_NGAYSINH") %></b><br />
                                                <i>Số CCCD:</i> <b><%# Eval("BICAN_SO_CCCD") %></b>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Kết quả giải quyết">
                                            <ItemTemplate>
                                                <i>Số BA/QD:</i> <%# Eval("BANAN_SO_BAN_AN") %><br />
                                                <i>Ngày BA/QD:</i> <%# Eval("BANAN_NGAY_BA") %><br />
                                                <i>Tội danh:</i> <b><%# Eval("TENTOIDANH") %></b><br />
                                                <br />
                                                <i>Hình phạt tổng hợp:</i> <b><%# Eval("TENHINHPHAT") %></b><br />
                                                <i>Ngày hiệu lực:</i> <%# Eval("BICAN_NGAYHIEULUC") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField Visible="false" DataField="MA_TRANGTHAIBANGHI" />

                                        <asp:TemplateField HeaderText="Tình trạng đồng bộ">
                                            <ItemTemplate>
                                                <%--GTEL-HUNGNQ 24-10-2025: Hiển thị Mình trạng thái--%>
                                                 <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                                <%--END GTEL-HUNGNQ 24-10-2025: Hiển thị Mình trạng thái--%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <%--<asp:BoundField DataField="trangThaiBanGhi" HeaderText="Trạng thái đồng bộ" />--%>

                                        <asp:BoundField DataField="GHICHU" HeaderText="Ghi chú" />


                                        <%-- <asp:BoundField DataField="NGAYDONGBO" HeaderText="Ngày đồng bộ" />--%>


                                        <asp:TemplateField HeaderText="Thao tác">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtHistory" runat="server" CausesValidation="false" Text="Xem lịch sử"
                                                    CommandName="History" 
                                                    CommandArgument='<%#Eval("BICAOID") + "," + Eval("VUANID") + "," + Eval("CAPXX_MA") + "," + Eval("C06_AHS_ID") %>'
                                                    Visible='<%# Eval("ma_trangthaibanghi").ToString()=="DDB" || Eval("ma_trangthaibanghi").ToString()=="TH" %>'
                                                    />
                                                <br />
                                                <asp:LinkButton ID="lbtView" runat="server" Text="Xem điều luật"
                                                    CommandName="View"
                                                    CommandArgument='<%#Eval("BICAOID") + "," + Eval("VUANID") + "," + Eval("CAPXX_MA") + "," + Eval("C06_AHS_ID") %>'
                                                    Visible="false" />
                                                <br />
                                                <asp:LinkButton ID="lbtHuyChuyen" runat="server" Text="Hủy chuyển"
                                                    CommandName="HuyChuyen"
                                                    CommandArgument='<%# Eval("C06_AHS_ID") %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');"
                                                    Visible="false" />
                                                <br />
                                                <asp:LinkButton ID="lbtGuiLai" runat="server" Text="Gửi lại"
                                                    CommandName="GuiLai"
                                                    CommandArgument='<%# Eval("C06_AHS_ID") %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn gửi lại không?');"
                                                    Visible="false" />
                                                  <%--GTEL-HUNGNQ 24-10-2025: Hiển thị Người Gửi/Ngày gửi--%>
                                                <br />
                                                <i>Tài khoản gửi:</i> <%#Eval("NGUOIGUI")%><br />
                                                <i>Ngày gửi:</i> <%#Eval("NGAYGUI")%>
                                                <%--END   GTEL-HUNGNQ 24-10-2025: Hiển thị Người Gửi/Ngày gửi--%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <%--END Chuyển sang sử dụng gridView--%>
                            <%-- --------------------------- END dataGrid cho HS --------------------%>

                            <%--GTEL-HUNGNQ: DataGrid cho Loai án Dân Sự--%>
                            <div>
                                <asp:DataGrid ID="adsDgList_All" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="adsDgList_All_ItemCommand" OnItemDataBound="adsDgList_All_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="VUANID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" ToolTip='<%#Eval("DUONGSUID") +","+ Eval("CAPXX_MA")+","+ Eval("LOAIBAQD") + ","+ Eval("SOBANANORQD") + "," + Eval("C06_ID")%>' />
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
                                            <HeaderTemplate>Thông tin vụ án</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tên vụ việc:</i> <b><%#Eval("TENVUAN")%></b><br />
                                                <i>Cấp xét xử:</i> <b><%#Eval("CAPXX")%></b><br />
                                                <i>Thụ lý:</i> <b><%#Eval("THULY")%></b><br />
                                                <i>Thẩm phán:</i> <b><%#Eval("THAMPHAN")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Nguyên đơn / Bị đơn</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tư cách tố tụng:</i> <b><%#Eval("TENTUCACHTOTUNG")%></b><br />
                                                <i>Tên đương sự:</i> <b><%#Eval("HOTENDUONGSU")%></b><br />
                                                <i>Ngày sinh:</i> <b><%#Eval("NGAYSINHDUONGSU")%></b><br />
                                                <i>CCCD:</i> <b><%#Eval("SOGIAYTODUONGSU")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Số BA/QD:</i> <%#Eval("SOBANANORQD")%><br />
                                                <i>Ngày BA/QD:</i> <%#Eval("NGAYRABANAN")%><br />
                                                <b><i>Ngày hiệu lực:</i></b> <%#Eval("NGAYHIEULUCBA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tình trạng đồng bộ</HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ghi chú</HeaderTemplate>
                                            <ItemTemplate><span class="trangthai"><%#Eval("ghiChu")%></span></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <%-- Nếu là DDB thì hiển thị Hủy chuyển + Xem lịch sử --%>
                                                <asp:LinkButton ID="lbtHuyChuyen" runat="server" CausesValidation="false" Text="Hủy chuyển"
                                                    CommandName="HuyChuyen" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" />
                                                <br />
                                                <%-- Nếu là TH thì hiển thị Gửi lại --%>
                                                <asp:LinkButton ID="lbtGuiLai" runat="server" CausesValidation="false" Text="Gửi lại"
                                                    CommandName="GuiLai" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="TH" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn Gửi lại không?');" />
                                                <br />
                                                <asp:LinkButton ID="lbtView" runat="server" CausesValidation="false" Text="Xem lịch sử"
                                                    CommandName="View" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" || Eval("LoaiBang").ToString()=="TH" %>' />
                                                <br />
                                                <i>Tài khoản gửi:</i> <%#Eval("TAIKHOANGUI")%><br />
                                                <i>Ngày gửi:</i> <%#Eval("NGAYGUI")%>
                                            </ItemTemplate>
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
                            <%-- --------------------------- END dataGrid cho Dân sự --------------------%>
                            <%--GTEL-HUNGNQ: DataGrid cho Loai án Hành Chính--%>
                            <div>
                                <asp:DataGrid ID="ahcDgList_All" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="ahcDgList_All_ItemCommand" OnItemDataBound="ahcDgList_All_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="VUANID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" 
                                                    ToolTip='<%#Eval("DUONGSUID") +","+ Eval("CAPXX_MA")+","+ Eval("LOAIBAQD") + ","+ Eval("SOBANANORQD") + "," + Eval("C06_ID")%>' />
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
                                            <HeaderTemplate>Thông tin vụ án</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tên vụ việc:</i> <b><%#Eval("TENVUAN")%></b><br />
                                                <i>Cấp xét xử:</i> <b><%#Eval("CAPXX")%></b><br />
                                                <i>Thụ lý:</i> <b><%#Eval("THULY")%></b><br />
                                                <i>Thẩm phán:</i> <b><%#Eval("THAMPHAN")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Nguyên đơn / Bị đơn</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tư cách tố tụng:</i> <b><%#Eval("TENTUCACHTOTUNG")%></b><br />
                                                <i>Tên đương sự:</i> <b><%#Eval("HOTENDUONGSU")%></b><br />
                                                <i>Ngày sinh:</i> <b><%#Eval("NGAYSINHDUONGSU")%></b><br />
                                                <i>CCCD:</i> <b><%#Eval("SOGIAYTODUONGSU")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Số BA/QD:</i> <%#Eval("SOBANANORQD")%><br />
                                                <i>Ngày BA/QD:</i> <%#Eval("NGAYRABANAN")%><br />
                                                <b><i>Ngày hiệu lực:</i></b> <%#Eval("NGAYHIEULUCBA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tình trạng đồng bộ</HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ghi chú</HeaderTemplate>
                                            <ItemTemplate><span class="trangthai"><%#Eval("ghiChu")%></span></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <%-- Nếu là DDB thì hiển thị Hủy chuyển + Xem lịch sử --%>
                                                <asp:LinkButton ID="lbtHuyChuyen" runat="server" CausesValidation="false" Text="Hủy chuyển"
                                                    CommandName="HuyChuyen" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" />
                                                <br />
                                                <%-- Nếu là TH thì hiển thị Gửi lại --%>
                                                <asp:LinkButton ID="lbtGuiLai" runat="server" CausesValidation="false" Text="Gửi lại"
                                                    CommandName="GuiLai" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="TH" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn Gửi lại không?');" />
                                                <br />
                                                <asp:LinkButton ID="lbtView" runat="server" CausesValidation="false" Text="Xem lịch sử"
                                                    CommandName="View" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" || Eval("LoaiBang").ToString()=="TH" %>' />
                                                <br />
                                                <i>Tài khoản gửi:</i> <%#Eval("TAIKHOANGUI")%><br />
                                                <i>Ngày gửi:</i> <%#Eval("NGAYGUI")%>
                                            </ItemTemplate>
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
                            <%-- --------------------------- END dataGrid cho Hành chính --------------------%>
                            <%--GTEL-HUNGNQ: DataGrid cho Loai án Lao Động--%>
                            <div>
                                <asp:DataGrid ID="aldDgList_All" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="aldDgList_All_ItemCommand" OnItemDataBound="aldDgList_All_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="VUANID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" ToolTip='<%#Eval("DUONGSUID") +","+ Eval("CAPXX_MA")+","+ Eval("LOAIBAQD") + ","+ Eval("SOBANANORQD") + "," + Eval("C06_ID")%>' />
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
                                            <HeaderTemplate>Thông tin vụ án</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tên vụ việc:</i> <b><%#Eval("TENVUAN")%></b><br />
                                                <i>Cấp xét xử:</i> <b><%#Eval("CAPXX")%></b><br />
                                                <i>Thụ lý:</i> <b><%#Eval("THULY")%></b><br />
                                                <i>Thẩm phán:</i> <b><%#Eval("THAMPHAN")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Nguyên đơn / Bị đơn</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tư cách tố tụng:</i> <b><%#Eval("TENTUCACHTOTUNG")%></b><br />
                                                <i>Tên đương sự:</i> <b><%#Eval("HOTENDUONGSU")%></b><br />
                                                <i>Ngày sinh:</i> <b><%#Eval("NGAYSINHDUONGSU")%></b><br />
                                                <i>CCCD:</i> <b><%#Eval("SOGIAYTODUONGSU")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Số BA/QD:</i> <%#Eval("SOBANANORQD")%><br />
                                                <i>Ngày BA/QD:</i> <%#Eval("NGAYRABANAN")%><br />
                                                <b><i>Ngày hiệu lực:</i></b> <%#Eval("NGAYHIEULUCBA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tình trạng đồng bộ</HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ghi chú</HeaderTemplate>
                                            <ItemTemplate><span class="trangthai"><%#Eval("ghiChu")%></span></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <%-- Nếu là DDB thì hiển thị Hủy chuyển + Xem lịch sử --%>
                                                <asp:LinkButton ID="lbtHuyChuyen" runat="server" CausesValidation="false" Text="Hủy chuyển"
                                                    CommandName="HuyChuyen" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" />
                                                <br />
                                                <%-- Nếu là TH thì hiển thị Gửi lại --%>
                                                <asp:LinkButton ID="lbtGuiLai" runat="server" CausesValidation="false" Text="Gửi lại"
                                                    CommandName="GuiLai" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="TH" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn Gửi lại không?');" />
                                                <br />
                                                <asp:LinkButton ID="lbtView" runat="server" CausesValidation="false" Text="Xem lịch sử"
                                                    CommandName="View" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" || Eval("LoaiBang").ToString()=="TH" %>' />
                                                <br />
                                                <i>Tài khoản gửi:</i> <%#Eval("TAIKHOANGUI")%><br />
                                                <i>Ngày gửi:</i> <%#Eval("NGAYGUI")%>
                                            </ItemTemplate>
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
                            <%-- --------------------------- END dataGrid cho Lao Động --------------------%>
                            <%--GTEL-HUNGNQ: DataGrid cho Loai án Kinh tế--%>
                            <div>
                                <asp:DataGrid ID="aktDgList_All" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="aktDgList_All_ItemCommand" OnItemDataBound="aktDgList_All_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="VUANID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" runat="server" ToolTip='<%#Eval("DUONGSUID") +","+ Eval("CAPXX_MA")+","+ Eval("LOAIBAQD") + ","+ Eval("SOBANANORQD") + "," + Eval("C06_ID")%>' />
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
                                            <HeaderTemplate>Thông tin vụ án</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tên vụ việc:</i> <b><%#Eval("TENVUAN")%></b><br />
                                                <i>Cấp xét xử:</i> <b><%#Eval("CAPXX")%></b><br />
                                                <i>Thụ lý:</i> <b><%#Eval("THULY")%></b><br />
                                                <i>Thẩm phán:</i> <b><%#Eval("THAMPHAN")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Nguyên đơn / Bị đơn</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Tư cách tố tụng:</i> <b><%#Eval("TENTUCACHTOTUNG")%></b><br />
                                                <i>Tên đương sự:</i> <b><%#Eval("HOTENDUONGSU")%></b><br />
                                                <i>Ngày sinh:</i> <b><%#Eval("NGAYSINHDUONGSU")%></b><br />
                                                <i>CCCD:</i> <b><%#Eval("SOGIAYTODUONGSU")%></b><br />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                            <ItemTemplate>
                                                <i>Số BA/QD:</i> <%#Eval("SOBANANORQD")%><br />
                                                <i>Ngày BA/QD:</i> <%#Eval("NGAYRABANAN")%><br />
                                                <b><i>Ngày hiệu lực:</i></b> <%#Eval("NGAYHIEULUCBA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tình trạng đồng bộ</HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ghi chú</HeaderTemplate>
                                            <ItemTemplate><span class="trangthai"><%#Eval("ghiChu")%></span></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <%-- Nếu là DDB thì hiển thị Hủy chuyển + Xem lịch sử --%>
                                                <asp:LinkButton ID="lbtHuyChuyen" runat="server" CausesValidation="false" Text="Hủy chuyển"
                                                    CommandName="HuyChuyen" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn hủy chuyển không?');" />
                                                <br />
                                                <%-- Nếu là TH thì hiển thị Gửi lại --%>
                                                <asp:LinkButton ID="lbtGuiLai" runat="server" CausesValidation="false" Text="Gửi lại"
                                                    CommandName="GuiLai" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="TH" %>'
                                                    OnClientClick="return confirm('Bạn có chắc muốn Gửi lại không?');" />
                                                <br />
                                                <asp:LinkButton ID="lbtView" runat="server" CausesValidation="false" Text="Xem lịch sử"
                                                    CommandName="View" CommandArgument='<%#Eval("C06_ID") %>'
                                                    Visible='<%# Eval("LoaiBang").ToString()=="DDB" || Eval("LoaiBang").ToString()=="TH" %>' />
                                                <br />
                                                <i>Tài khoản gửi:</i> <%#Eval("TAIKHOANGUI")%><br />
                                                <i>Ngày gửi:</i> <%#Eval("NGAYGUI")%>
                                            </ItemTemplate>
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
                            <%-- --------------------------- END dataGrid cho Kinh tế --------------------%>

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
    <script type="text/javascript">
        function OnlySelectOne(checkbox) {
            var grid = checkbox.closest('table');
            var inputs = grid.getElementsByTagName('input');
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type === 'checkbox' && inputs[i] !== checkbox && inputs[i].id.includes('chkChon')) {
                    inputs[i].checked = false;
                }
            }
        }
    </script>
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
