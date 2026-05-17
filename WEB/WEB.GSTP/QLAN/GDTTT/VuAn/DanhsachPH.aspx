<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="DanhsachPH.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.DanhsachPH" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hdd_INBC" Value="0" runat="server" />
    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 80px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }

        .full_width {
            float: left;
            width: 100%;
        }

        .link_view {
            color: #0e7eee;
            font-weight: bold;
            text-decoration: none;
        }
    </style>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div   id = "divBackground" style=" position:absolute; top:0px; left:0px;background-color:black; z-index:100;opacity: 0.8;filter:alpha(opacity=60); -moz-opacity: 0.8; overflow:hidden; display:none">
    </div>
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
                                            <td class="DonGDTCol1">Tòa ra BA/QĐ</td>
                                            <td class="DonGDTCol2">
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol3">Số BA/QĐ</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="182px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblTitleBC" runat="server" Text="Nguyên đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtNguyendon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            <td>
                                                <asp:Label ID="lblTitleBD" runat="server" Text="Bị đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtBidon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Loại án</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="190px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="tblQHPL" runat="server" Text="Quan hệ PL"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtQHPL_TD" runat="server" CssClass="user" Width="222px" MaxLength="300"></asp:TextBox></td>
                                            <td>Thuộc án</td>
                                            <td>
                                                <asp:DropDownList ID="dropAnDB"
                                                    CssClass="chosen-select" runat="server" Width="160px">
                                                    <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Án 8.1"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Án 9.3"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Án Chỉ đạo"></asp:ListItem>
                                                    <%--   <asp:ListItem Value="4" Text="Án trao đổi CV"></asp:ListItem>--%>
                                                    <%--  <asp:ListItem Value="3" Text="Án thời hiệu"></asp:ListItem>--%>
                                                </asp:DropDownList></td>
                                            <td>Án thời hiệu</td>
                                            <td>
                                                <asp:DropDownList ID="dropAnDB_TH" runat="server"
                                                    Width="190px" CssClass="chosen-select">
                                                    <asp:ListItem Value="" Text="--Tất cả--"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Đã hết thời hiệu"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Còn thời hiệu dưới một tháng"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Còn thời hiệu dưới hai tháng"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Còn thời hiệu dưới ba tháng"></asp:ListItem>
                                                    <asp:ListItem Value="6" Text="Còn thời hiệu dưới sáu tháng"></asp:ListItem>
                                                    <asp:ListItem Value="55" Text="Còn thời hiệu dưới 5 năm"></asp:ListItem>
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td>Số văn bản</td>
                                            <td>
                                                <asp:TextBox ID="txtSoVanBan" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            <td>Ngày văn bản</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayVB" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayVB" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayVB" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Kết quả thụ lý</td>
                                            <td>
                                                <asp:DropDownList ID="ddlKetquaThuLy" CssClass="chosen-select"
                                                    runat="server" Width="190px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Văn bản phát hành</td>
                                            <td>
                                                <asp:DropDownList ID="ddlVBPH"
                                                    CssClass="chosen-select" runat="server" Width="230px" AutoPostBack="true" OnSelectedIndexChanged="ddlVBPH_SelectedIndexChanged">
                                                    <asp:ListItem Value="" Text="--Tất cả--"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Phiếu mượn"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Phiếu trả"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Phiếu chuyển"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Công văn XM, BS"></asp:ListItem>
                                                    <asp:ListItem Value="4" Text="Công văn khác"></asp:ListItem>
                                                    <asp:ListItem Value="5" Text="Trả lời đơn"></asp:ListItem>
                                                    <asp:ListItem Value="6" Text="Kháng nghị"></asp:ListItem>
                                                    <asp:ListItem Value="7" Text="VKS đang giải quyết"></asp:ListItem>
                                                    <asp:ListItem Value="8" Text="Thông báo thụ lý XX GĐT"></asp:ListItem>
                                                    <asp:ListItem Value="9" Text="Kết quả XX GĐT"></asp:ListItem>
                                                    <asp:ListItem Value="10" Text="Thông báo tình thế"></asp:ListItem>
                                                    <asp:ListItem Value="11" Text="Trả lời tình thế"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Trạng thái
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlTrangThai" CssClass="chosen-select" runat="server" Width="160px" AutoPostBack="true" OnSelectedIndexChanged="ddlTrangThai_SelectedIndexChanged">
                                                    <asp:ListItem Value="" Text="--Tất cả--"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Văn bản chưa gửi" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="- Đã thu hồi nhưng chưa gửi"></asp:ListItem>
                                                    <asp:ListItem Value="6" Text="Văn bản đã gửi"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="- Văn bản chưa phát hành"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="- Văn bản đã phát hành"></asp:ListItem>
                                                    <asp:ListItem Value="4" Text="-- Phát hành thành công"></asp:ListItem>
                                                    <asp:ListItem Value="5" Text="-- Phát hành không thành công"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <asp:Panel ID="pnHiden" runat="server" Visible="false">
                                            <tr>
                                                <td>Ngày tạo từ ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Số thụ lý</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Cán bộ giải quyết đơn
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>LĐ phụ trách</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhoVuTruong" CssClass="chosen-select"
                                                        runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                                <td>Thẩm phán</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Thông báo KQGQ</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTraloi" CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="2" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                        <%--  <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Loại công văn</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLoaiCV"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Literal ID="lblLoaidon" runat="server" Text="Loại đơn" Visible="false"></asp:Literal></td>
                                                <td style="display: none">
                                                    <asp:DropDownList ID="ddlloaidon" CssClass="chosen-select" Visible="false"
                                                        runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="Giám đốc thẩm"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Xin ân giảm"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="GĐT +  Xin ân giảm"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Người gửi đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtNguoiguidon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                                <%-- <td>Cơ quan chuyển đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtCoquanchuyendon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr>--%>
                                                <td>Trạng thái hồ sơ</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlMuonHoso" runat="server"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có hồ sơ"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Tờ trình lãnh đạo</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTotrinh"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có tờ trình"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có tờ trình"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <%--<td></td>
                                                <td></td>--%>
                                            </tr>
                                            <tr>
                                                <td>Trạng thái thụ lý</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTrangthaithuly"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Literal ID="lttYKienKetLuan" runat="server">Ý kiến tờ trình</asp:Literal></td>
                                                <td>
                                                    <asp:DropDownList ID="dropIsYKienKetLuatTrinhLD"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có ý kiến"></asp:ListItem>
                                                        <asp:ListItem Value="10" Text="... Trả lời đơn"></asp:ListItem>
                                                        <asp:ListItem Value="11" Text="... Kháng nghị"></asp:ListItem>
                                                        <asp:ListItem Value="12" Text="... Xếp đơn"></asp:ListItem>
                                                        <asp:ListItem Value="13" Text="... Xác minh, BS"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="... Yêu cầu trình tiếp"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td>
                                                    <asp:Literal ID="lttBuocTT" runat="server">Bước giải quyết</asp:Literal></td>

                                                <td>
                                                    <asp:DropDownList ID="dropBuocTT"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropBuocTT_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Chưa có bước giải quyết kế tiếp"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Có bước giải quyết kế tiếp"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Yêu cầu trình tiếp</td>
                                                <td>
                                                    <asp:DropDownList ID="dropCapTrinhTiepTheo"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Đăng ký ngày báo cáo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropDangKyBC"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Kết quả xét xử</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaXX" CssClass="chosen-select"
                                                        runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                                <td>
                                                    <asp:Literal ID="lttTypeHDTP" runat="server" Text="Là" Visible="false"></asp:Literal></td>
                                                <td>
                                                    <asp:DropDownList ID="dropTypeHDTP" CssClass="chosen-select" Visible="false"
                                                        runat="server" Width="160px">
                                                        <asp:ListItem Value="3" Text="Chủ tọa"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="HĐTT"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="HĐ5"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Hoãn THA ?</td>
                                                <td>
                                                    <asp:DropDownList ID="dropHoanTHA" runat="server"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td>Thông báo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropTypeTB" Enabled="false"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Chưa có Thông báo TT"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Có Thông báo TT"></asp:ListItem>

                                                        <asp:ListItem Value="3" Text="Chưa có Thông báo KQ"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Có Thông báo KQ"></asp:ListItem>

                                                        <asp:ListItem Value="5" Text="Chưa có Thông báo TT & Thông báo KQ"></asp:ListItem>
                                                        <asp:ListItem Value="6" Text="Có Thông báo TT & Thông báo KQ"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:CheckBox ID="chk_conlai" runat="server" Text="Tính cả số cũ còn lại" />
                                                    <style>
                                                        #dvSpliter_ContentPlaceHolder1_chk_conlai {
                                                            margin-left: 10px;
                                                            margin-right: 4px;
                                                        }
                                                    </style>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Số đơn TLM</td>
                                                <td>
                                                    <asp:DropDownList ID="dropSoDonTLM"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="0 đơn Thụ lý mới"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="1 đơn Thụ lý mới"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="2 đơn Thụ lý mới trở lên"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td>Loại BA GĐT</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLoaiGDT" CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="4" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="...Đơn đề nghị GĐT"></asp:ListItem>
                                                        <asp:ListItem Value="6" Text="...Đơn đề nghị TT"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Rút Hồ sơ đoàn kiểm tra"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Chủ động GĐT qua Bản án"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Kháng nghị của VKS"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>

                                                <td>
                                                    <asp:DropDownList runat="server" ID="dropLoaiNgaySer"
                                                        Width="120px" CssClass="chosen-select">
                                                        <asp:ListItem Value="1" Selected="True" Text="Ngày Bản án"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Ngày có Hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Ngày phân TTV"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td>Từ
                                                        <asp:TextBox ID="txtNgayBA_Tu" runat="server" CssClass="user" Width="205px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBA_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBA_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayBA_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayBA_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBA_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                        </asp:Panel>

                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="5"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <asp:Panel  ID="pnPhatHanh" runat="server" Visible="false">
                        <tr>
                            <td>
                                <div>
                                    <div style="float: left; width: 67px; text-align: left; margin-right: 10px; margin-top:5px;">Ngày gửi<span class="must_input">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNgaygui" runat="server" CssClass="user" Width="120px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgaygui" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaygui" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                    <div style="float: left; width: 102px; text-align: left; margin-left: 20px; margin-top:5px;">Hình thức gửi<span class="must_input">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:DropDownList ID="dropHinhThucGui" CssClass="user chosen-select" runat="server" Width="130">
                                        </asp:DropDownList> 
                                    </div>
                                    <div style="float: left; width: 95px; text-align: left; margin-left: 20px;">
                                        <asp:Button ID="cmdPhatHanh" runat="server" CssClass="buttoninput" Text="Phát hành" OnClick="cmdPhatHanh_Click"/>
                                    </div>
                                    <div style="float: left;">
                                        <asp:Label runat="server" ID="lbThongbao" ForeColor="Red" Font-Size="13px"></asp:Label>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>                    
                    <tr>
                        <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
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
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="6px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkPhatHanh" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' runat="server" />
                                            <asp:HiddenField ID="hddID" runat="server" Value='<%# Eval("ID") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>

                                    <asp:BoundColumn DataField="STT" HeaderText="TT"
                                        HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Số & Ngày thụ lý
                                            <div style="padding-top: 2px;">
                                                <asp:ImageButton ID="cmd_NGAYTHULYDON_ORDER" runat="server" CausesValidation="false"
                                                    CommandArgument='NGAYTHULYDON' CommandName="NGAYTHULYDON_ORDER"
                                                    ToolTip="Xắp xếp theo ngày thụ lý đơn" ImageUrl="/UI/img/orders.png"
                                                    Width="16" Height="16" OnClick="cmd_ORDER_Click" />

                                            </div>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <%#Eval("TOAXX_VietTat")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="15%"  HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="12%"  HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="12%"  HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="250px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Văn bản</HeaderTemplate>
                                        <ItemTemplate>
                                            <%--<%#Eval("VANBAN")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lblPhatHanh" runat="server" Text="Phát hành" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                CommandName="PhatHanh" CommandArgument='<%#Eval("ID") +"#"+ Convert.ToInt16( Eval("LOAIAN")+"") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>

                            <asp:DataGrid ID="dgListHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="6px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkPhatHanh" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="STT" HeaderText="TT"
                                        HeaderStyle-Width="25px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="60px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Số & Ngày thụ lý
                                            <div style="padding-top: 2px;">
                                                <asp:ImageButton ID="cmd_NGAYTHULYDON_ORDER" runat="server" CausesValidation="false"
                                                    CommandArgument='NGAYTHULYDON' CommandName="NGAYTHULYDON_ORDER"
                                                    ToolTip="Xắp xếp theo ngày thụ lý đơn" ImageUrl="/UI/img/orders.png"
                                                    Width="16" Height="16" OnClick="cmd_ORDER_Click" />
                                            </div>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%-- <b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <%#Eval("TOAXX_VietTat")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPNDN_Report" HeaderText="Tội danh" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="15%"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="12%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                            Bị cáo đầu vụ
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("NGUYENDON")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="12%" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Bị cáo khiếu nại
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("BIDON")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="250px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Văn bản</HeaderTemplate>
                                        <ItemTemplate>
                                            <%--<%#Eval("VANBAN")%>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lblPhatHanh" runat="server" Text="Phát hành" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                CommandName="PhatHanh" CommandArgument='<%#Eval("ID") +"#"+ Convert.ToInt16( Eval("LOAIAN")+"") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
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
        function Loads_KQ() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        function LoadModalDiv() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "block";
            if (bcgDiv != null) {

                if (document.body.clientHeight > document.body.scrollHeight) {

                    bcgDiv.style.height = document.body.clientHeight + "px";
                }
                else {

                    bcgDiv.style.height = document.body.scrollHeight + "px";
                }
                bcgDiv.style.width = "100%";
            }
        }

        function HideModalDiv() {            
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
