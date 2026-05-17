<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Danhsach" %>

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
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton></h4>
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
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
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
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
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
                                                        runat="server" Width="160px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlPhoVuTruong_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                                <td>Thẩm phán</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
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
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiCV_SelectedIndexChanged"
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
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlMuonHoso_SelectedIndexChanged"
                                                        Width="160px" CssClass="chosen-select">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có hồ sơ"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Tờ trình lãnh đạo</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTotrinh"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTotrinh_SelectedIndexChanged"
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
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTrangthaithuly_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Literal ID="lttYKienKetLuan" runat="server">Ý kiến tờ trình</asp:Literal></td>
                                                <td>
                                                    <asp:DropDownList ID="dropIsYKienKetLuatTrinhLD"
                                                        CssClass="chosen-select" runat="server" Width="160px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropIsYKienKetLuatTrinhLD_SelectedIndexChanged">
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
                                                <td>Án thời hiệu</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB_TH" runat="server"
                                                        Width="160px" CssClass="chosen-select">
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
                                                <td>Kết quả thụ lý</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaThuLy" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaThuLy_SelectedIndexChanged"
                                                        runat="server" Width="230px">
                                                    </asp:DropDownList></td>
                                                <td>Kết quả xét xử</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaXX" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaXX_SelectedIndexChanged"
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
                                                <td>Thuộc án</td>
                                                <td>
                                                    <asp:DropDownList ID="dropAnDB"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropAnDB_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="0" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Án 8.1"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Án 9.3"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Án Chỉ đạo"></asp:ListItem>
                                                        <%--   <asp:ListItem Value="4" Text="Án trao đổi CV"></asp:ListItem>--%>
                                                        <%--  <asp:ListItem Value="3" Text="Án thời hiệu"></asp:ListItem>--%>
                                                    </asp:DropDownList></td>
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
                                                <td><asp:Label ID="tblQHPL" runat="server" Text="Quan hệ PL"></asp:Label></td>
                                                <td>
                                                    <asp:TextBox ID="txtQHPL_TD" runat="server" CssClass="user" Width="152px" MaxLength="300"></asp:TextBox></td>
                                            </tr>
                                             <asp:Panel ID="pnSearchCC" runat="server" Visible="false">
                                                <tr>
                                                    
                                                    <td>
                                                        <asp:DropDownList runat="server" ID="dropLoaiNgaySer"
                                                            Width="120px" CssClass="chosen-select">
                                                            <asp:ListItem Value="1" Selected="True" Text="Ngày Bản án"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Ngày có Hồ sơ"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Ngày phân TTV"></asp:ListItem>
                                                        </asp:DropDownList></td>
                                                    <td> Từ
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
                                        </asp:Panel>
                                        
                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>
                                            <td align="right" colspan="2">

                                                <asp:Button ID="btnThemmoi" runat="server" CssClass="buttoninput"
                                                    Text="Thêm mới" OnClick="btnThemmoi_Click" />
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
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">In báo cáo
                                    <asp:LinkButton ID="lkInBC_OpenForm" runat="server" Text="[ Mở ]"
                                        ForeColor="#0E7EEE" OnClick="lkInBC_OpenForm_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Panel ID="pnInBC" runat="server" Visible="false">
                                        <table class="table1">
                                            <tr>
                                                <td class="DonGDTCol1">Tiêu đề báo cáo</td>
                                                <td>
                                                    <asp:TextBox ID="txtTieuDeBC" runat="server"
                                                        CssClass="user" Width="486px" MaxLength="250" Text="Danh sách các vụ án"></asp:TextBox>
                                                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                                        Text="In biểu mẫu" OnClick="cmdPrint_Click" /></td>
                                            </tr>
                                            <tr style="display: none;">
                                                <td>Mẫu báo cáo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropMauBC" CssClass="chosen-select" runat="server" Width="494px">
                                                        <asp:ListItem Value="1" Text="Mẫu 1: Thống kê vụ án chưa có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Mẫu 2: Thống kê vụ án đã có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Mẫu 3: Thống kê vụ án chưa/có tờ trình lãnh đạo"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Mẫu 4: Thống kê vụ án đang trong giai đoạn giải quyết tờ trình"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Mẫu 5: Danh sách án Quốc Hội"></asp:ListItem>
                                                    </asp:DropDownList>

                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                            </div>
                        </td>
                    </tr>
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
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>

                                    <asp:BoundColumn DataField="STT" HeaderText="TT"
                                        HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
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
                                            <%-- <%#Eval("SOTHULYDON")%>
                                            <br />
                                            <%#Eval("NGAYTHULYDON")%>--%>
                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>

                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrDONID") %>' CommandName="SoDonTrung"
                                                Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"  %>'></asp:LinkButton>
                                            <br />
                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCV81ID") %>' CommandName="CongVan81" Text='<%# "Án Quốc hội"  %>'
                                                Visible='<%# (Eval("SoCV81")+"")=="0"?false:true  %>'></asp:LinkButton>
                                            <br />
                                            <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("IsAnChiDao")+"")=="0"?false:true  %>' Text='<%# "Án chỉ đạo"  %>'></asp:LinkButton>

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
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="10%"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="12%"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="12%"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="12%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Người đề nghị
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("NGUOIKHIEUNAI")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án quốc hội, có ý kiến lãnh đạo đảng nhà nước
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("CV93")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="130px" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo<br />
                                            Thẩm phán
                                               <div style="padding-top: 2px;">
                                                   <asp:ImageButton ID="cmd_TENTHAMTRAVIEN_ORDER" runat="server" CausesValidation="false" CommandArgument='TENTHAMTRAVIEN'
                                                       CommandName="TENTHAMTRAVIEN_ORDER" ToolTip="Xắp xếp theo tên thẩm tra viên" ImageUrl="/UI/img/orders.png" Width="16" Height="16"
                                                       OnClick="cmd_ORDER_Click" />
                                               </div>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%--   <asp:Literal ID="lttTTV" runat="server"></asp:Literal>--%>
                                            <%# Eval("PHANCONGTTV")%><br />
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":( Eval("MaChucVuLD") + ":<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttLanTT" runat="server"></asp:Literal>
                                            <br />

                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGUOITAO") %><br />
                                            <i><%#Eval("NGAYTAO") %></i>
                                            <br />
                                            <a href="javascript:;" class="link_view" onclick='ViewVuAn(<%#Eval("ID") %>, <%#Eval("LoaiAn") %>)'>Thông tin vụ án</a>
                                            <br />
                                            <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                CommandName="Sua" CommandArgument='<%#Eval("ID") +"#"+ Convert.ToInt16( Eval("LOAIAN")+"") %>'></asp:LinkButton>
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" Font-Bold="true" CausesValidation="false"
                                                Text="Xóa" CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa vụ việc này? ');"></asp:LinkButton>
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
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="STT" HeaderText="TT"
                                        HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
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

                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrDONID") %>' CommandName="SoDonTrung"
                                                Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"  %>'></asp:LinkButton>
                                            <br />

                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCV81ID") %>' CommandName="CongVan81" Text='<%# "Án Quốc hội"  %>'
                                                Visible='<%# (Eval("SoCV81")+"")=="0"?false:true  %>'></asp:LinkButton>
                                            <br />
                                            <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("IsAnChiDao")+"")=="0"?false:true  %>' Text='<%# "Án chỉ đạo"  %>'></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
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
                                    <asp:BoundColumn DataField="QHPNDN_Report" HeaderText="Tội danh" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="10%"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="12%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
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
                                    <asp:TemplateColumn HeaderStyle-Width="12%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Người đề nghị 
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("NGUOIKHIEUNAI")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Án quốc hội, có ý kiến lãnh đạo đảng nhà nước
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("CV93")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Justify" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Thẩm tra viên<br />
                                            Lãnh đạo<br />
                                            Thẩm phán
                                               <div style="padding-top: 2px;">
                                                   <asp:ImageButton ID="cmd_TENTHAMTRAVIEN_ORDER" runat="server" CausesValidation="false" CommandArgument='TENTHAMTRAVIEN'
                                                       CommandName="TENTHAMTRAVIEN_ORDER" ToolTip="Xắp xếp theo tên thẩm tra viên" ImageUrl="/UI/img/orders.png" Width="16" Height="16"
                                                       OnClick="cmd_ORDER_Click" />
                                               </div>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%-- <asp:Literal ID="lttTTV" runat="server"></asp:Literal><br />--%>
                                            <%# Eval("PHANCONGTTV")%><br />
                                            <%# String.IsNullOrEmpty(Eval("TENLANHDAO")+"")? "":("LĐV:<b style='margin-left:3px;'>"+Eval("TENLANHDAO")+"</b><br />")%>
                                            <%# String.IsNullOrEmpty(Eval("TENTHAMPHAN")+"")? "":("TP:<b style='margin-left:3px;'>"+Eval("TENTHAMPHAN")+"</b>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttLanTT" runat="server"></asp:Literal>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                            <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGUOITAO") %><br />
                                            <i><%#Eval("NGAYTAO") %></i>
                                            <br />
                                            <a href="javascript:;" class="link_view" onclick='ViewVuAn(<%#Eval("ID") %>, <%#Eval("LoaiAn") %>)'>Thông tin vụ án</a>
                                            <br />
                                            <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" Font-Bold="true" ForeColor="#0e7eee" CausesValidation="false"
                                                CommandName="Sua" CommandArgument='<%#Eval("ID") +"#"+ Convert.ToInt16( Eval("LOAIAN")+"") %>'></asp:LinkButton>
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" Font-Bold="true" CausesValidation="false"
                                                Text="Xóa" CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa vụ việc này? ');"></asp:LinkButton>
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
        function PopupReport(pageURL, title, w, h) {
            //alert(pageURL);
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function ViewVuAn(vuan_id, loaian) {
            //  alert(vuan_id);
            var pageURL = '';
            if (loaian != 1)
                pageURL = '/QLAN/GDTTT/VuAn/Popup/ThongTinVA.aspx?vid=' + vuan_id;
            else
                pageURL = '/QLAN/GDTTT/VuAn/Popup/ThongTinVAHS.aspx?vid=' + vuan_id;
            var title = 'Thông tin vụ án';
            var w = 1000;
            var h = 600;
            PopupReport(pageURL, title, w, h);
        }
        function LoadDsDon() {
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
