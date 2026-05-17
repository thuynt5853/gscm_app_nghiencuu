<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach_TP.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Giaiquyet.Danhsach_TP" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
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
                                        <tr style="display: none;">
                                            <td>Đơn vị giải quyết</td>
                                            <td colspan="5">
                                                <%--<asp:DropDownList ID="ddlPhongban" CssClass="chosen-select" runat="server" Width="500px">
                                                </asp:DropDownList>--%>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="DonGDTCol1">Người gửi đơn</td>
                                            <td class="DonGDTCol2">
                                                <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
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
                                            <td>Tòa ra BA/QĐ</td>
                                            <td>
                                                <asp:DropDownList ID="ddlToaXetXu"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlToaXetXu_SelectedIndexChanged"
                                                    CssClass="chosen-select" runat="server" Width="230px">
                                                </asp:DropDownList></td>
                                            <td>Nhận đơn từ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayNhanTu" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayNhanTu" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Đến ngày</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayNhanDen" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayNhanDen" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayNhanDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <tr>
                                                <td>Địa chỉ gửi</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTinh" CssClass="chosen-select" runat="server" Width="113px" AutoPostBack="true" OnSelectedIndexChanged="ddlTinh_SelectedIndexChanged"></asp:DropDownList>
                                                    <asp:DropDownList ID="ddlHuyen" CssClass="chosen-select" runat="server" Width="113px"></asp:DropDownList>
                                                </td>
                                                <td>Chi tiết</td>
                                                <td>
                                                    <asp:TextBox ID="txtDiachi" CssClass="user" runat="server" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <%--<td>Trả lời đơn</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTraloi"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlTraloi_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có trả lời"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Không trả lời"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>--%>
                                            </tr>

                                            <tr>
                                                <td>Phân loại đơn</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhanloaiDdon"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlPhanloaiDdon_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đơn mới"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Đơn khiếu nại sau khi đã giải quyết"></asp:ListItem>
                                                        <%--  <asp:ListItem Value="3" Text="Đơn trùng"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Số CMND</td>
                                                <td>
                                                    <asp:TextBox ID="txtSoCMND" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td>Mã đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtSohieudon" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>Ngày chuyển từ</td>
                                                <td>
                                                    <asp:TextBox ID="txtNgaychuyenTu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaychuyenTu" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaychuyenTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtNgaychuyenDen" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgaychuyenDen" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaychuyenDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Hình thức đơn
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlHinhthucdon" Width="160px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlHinhthucdon_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server">
                                                        <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <%-- <asp:ListItem Value="1" Text="Đơn"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Công văn"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Đơn + Công văn"></asp:ListItem>--%>
                                                        <asp:ListItem Value="11" Text="1. Đơn"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text=" -- Đơn đề nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="8" Text=" -- Đơn khiếu nại tư pháp"></asp:ListItem>
                                                        <asp:ListItem Value="31" Text="2. Đơn + Công văn"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text=" -- Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
                                                        <asp:ListItem Value="10" Text=" -- Đơn khiếu nại tư pháp kèm CV chuyển đơn"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="3. Công văn"></asp:ListItem>
                                                        <asp:ListItem Value="6" Text=" -- CV kiến nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="9" Text=" -- CV kiến nghị GĐT,TT kèm Hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="12" Text=" -- CV khác"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="4. Văn bản hành chính,Tài liệu chung"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="5. Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="7" Text="6. Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
                                                    </asp:DropDownList>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Ngày thụ lý từ</td>
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


                                        </asp:Panel>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblThuLy" runat="server" Text="Thụ lý đơn"></asp:Label></td>
                                            <td>
                                                <asp:DropDownList ID="ddlThuLy" CssClass="chosen-select" runat="server"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlThuLy_SelectedIndexChanged"
                                                    Width="230px">
                                                    <asp:ListItem Value="-1" Text="--Tất cả--"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Thụ lý mới"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Đã thụ lý"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>

                                            <td>Số CV chuyển</td>
                                            <td>
                                                <asp:TextBox ID="txtCV_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Ngày CV chuyển</td>
                                            <td>
                                                <asp:TextBox ID="txtCV_Ngay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtCV_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtCV_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nơi nhận
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlPhongban" Visible="true" CssClass="chosen-select"
                                                    runat="server" Width="230px" AutoPostBack="True" OnSelectedIndexChanged="ddlPhongban_SelectedIndexChanged">
                                                    <%--<asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlThamtravien_SelectedIndexChanged"
                                                    runat="server" Width="230px">--%>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Loại án</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                            <td></td>
                                            <td></td>
                                        </tr>

                                        <tr>
                                            <td>Trạng thái</td>
                                            <td colspan="5">
                                                <asp:RadioButtonList ID="rdbTrangThai" runat="server"
                                                    RepeatDirection="Horizontal"
                                                    AutoPostBack="True" OnSelectedIndexChanged="rdbTrangThai_SelectedIndexChanged">
                                                    <asp:ListItem Value="1" Text="Chưa nhận" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Đã nhận"></asp:ListItem>
                                                    <asp:ListItem Value="4" Text="Đã chuyển"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Trả lại"></asp:ListItem>
                                                    <asp:ListItem Value="5" Text="Vụ án TP bậc 3 đề xuất KN"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <asp:Panel ID="pnGhepVuAn" runat="server" Visible="false">
                                            <tr>
                                                <td>Ghép vụ án</td>
                                                <td colspan="5">
                                                    <asp:RadioButtonList ID="rdGhepVuAn" runat="server"
                                                        RepeatDirection="Horizontal">
                                                        <asp:ListItem Value="2" Text="Tất cả" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa ghép"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã ghép"></asp:ListItem>

                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                        <tr>
                                            <td colspan="6" align="center">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label runat="server" ID="lbtthongbao" Font-Size="18pt" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <div class="boxchung" style="display: none;">
                                <h4 class="tleboxchung">Chuyển đơn & In báo cáo
                                    <asp:LinkButton ID="lbtTTBC" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lbtTTBC_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Panel ID="pnTTBC" runat="server" Visible="true">
                                    </asp:Panel>
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

                                                <td style="width: 100px;">
                                                    <asp:DropDownList ID="ddlLoaiso" runat="server" Width="170px" Height="28px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="Drop_LoaiSo_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                                <td style="width: 110px;">
                                                    <asp:TextBox ID="txtBC_SoCV" runat="server" CssClass="user" onkeypress="return isNumber(event)" Width="102px" MaxLength="5"></asp:TextBox>
                                                </td>
                                                <td style="width: 120px;">Ngày dự kiến chuyển</td>
                                                <td style="width: 120px;">
                                                    <asp:TextBox ID="txtBC_Ngaydk" runat="server"
                                                        AutoPostBack="true" OnTextChanged="txtBC_Ngaydk_TextChanged"
                                                        CssClass="user" Width="112px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtBC_Ngaydk" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtBC_Ngaydk" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td style="width: 60px;">Người ký</td>
                                                <td style="" colspan="3">
                                                    <asp:TextBox ID="txtBC_Nguoiky" runat="server" CssClass="user" Width="142px" MaxLength="250"></asp:TextBox>
                                                    <div style="float: right">
                                                        <asp:Button ID="btnLuuVB" Enabled="false" runat="server" CssClass="buttoninput" Text="Lưu Công Văn" OnClick="btnLuuVB_Click" Width="119px" />
                                                        <asp:Button ID="btnQuanlyVB" runat="server" CssClass="buttoninput" Text="Quản lý Công văn" OnClick="btnQuanlyVB_Click" Width="119px" />
                                                    </div>

                                                </td>

                                            </tr>
                                            <tr>
                                                <td colspan="1" class="DonGDTCol1">Tiêu đề báo cáo</td>
                                                <td colspan="5">
                                                    <asp:TextBox ID="txtTieuDeBC" runat="server"
                                                        CssClass="user" Width="486px" MaxLength="250" Text="Danh sách đơn chuyển"></asp:TextBox>
                                                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                                        Text="In DS" OnClick="cmdPrint_Click" />
                                                    <asp:Button ID="cmdInDonChuyen" runat="server" CssClass="buttoninput"
                                                        Text="In DS đơn chuyển Vụ GDKT" OnClick="cmdInDonChuyen_Click" />

                                                    <span style="margin-left: 10px; display: none;">
                                                        <asp:Button ID="cmdInDonDaNhan" runat="server" CssClass="buttoninput"
                                                            Text="In DS đơn đã nhận từ HCTP" OnClick="cmdInDonDaNhan_Click" Visible="false" />
                                                    </span>


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
                                <div class="sobanghi" style="width: 55%;">
                                    <table class="table1">
                                        <tr>

                                            <td style="width: 30px;">Ngày</td>
                                            <td style="width: 80px;">
                                                <asp:TextBox ID="txtBC_Ngay" runat="server" CssClass="user" Width="72px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtBC_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtBC_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td style="width: 30px;">Lý do</td>
                                            <td style="width: 120px;">
                                                <asp:TextBox ID="txtBC_Ghichu" runat="server" CssClass="user" Width="112px" MaxLength="250"></asp:TextBox>

                                            </td>
                                            <td align="left">
                                                <div style="float: left;">
                                                    <asp:DropDownList ID="ddlTralai_truonghop" Height="28px"
                                                        runat="server" Width="200px" CssClass="truonghop_tralai">
                                                        <asp:ListItem Value="0" Text="--- Chọn trường hợp trả lại ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Trả lại"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Trả lại để sửa"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;
                                                    <style>
                                                        .truonghop_tralai {
                                                            padding: 5px;
                                                        }
                                                    </style>
                                                </div>
                                                <div style="float: left;">
                                                    <asp:Button ID="cmdTralai" runat="server" 
                                                        Enabled="false"
                                                        CssClass="buttoninput" Text="Trả lại" OnClick="cmdTralai_Click" />
                                                    &nbsp;
                                                </div>
                                                <div style="float: left">
                                                    <asp:Button ID="cmdNhandon" runat="server" CssClass="buttoninput" OnClientClick="return confirm('Bạn chắc chắn muốn thực hiện thao tác?');" Text="Nhận đơn" OnClick="cmdNhandon_Click" />
                                                </div>
                                            </td>


                        </td>
                    </tr>
                </table>

            </div>
            <div class="sotrang" style="width: 42%;">
                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                &nbsp;&nbsp;
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
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
                <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                    <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="20" Text="20"></asp:ListItem>
                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                    <asp:ListItem Value="200" Text="200"></asp:ListItem>
                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
            PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
            ItemStyle-CssClass="chan" OnItemCommand="dgList_ItemCommand"
            OnItemDataBound="dgList_ItemDataBound">
            <Columns>
                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <HeaderTemplate>
                        <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:HiddenField ID="hddCurrDonID" runat="server" Value='<%#Eval("ID")%>' />
                        <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ARRDONTRUNG")%>' runat="server" />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <HeaderTemplate>TT</HeaderTemplate>
                    <ItemTemplate><%#Eval("STT") %></ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-Width="65px"
                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <HeaderTemplate>
                        Số & Ngày<br />
                        Tờ trình
                    </HeaderTemplate>
                    <ItemTemplate>
                        <%# Eval("TOTRINH_SONGAYS") %>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-Width="65px"
                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <HeaderTemplate>
                        Số & Ngày<br />
                        thụ lý
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Literal ID="lttThuLy" runat="server"></asp:Literal>
                        <span style="float: left; width: 100%;"><%#Eval("arrTTTL") %></span>

                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"
                    ItemStyle-VerticalAlign="Top" HeaderStyle-Width="140px">
                    <HeaderTemplate>Người đề nghị, kiến nghị, thông báo</HeaderTemplate>
                    <ItemTemplate>
                        <b><%#Eval("DONGKHIEUNAI") %></b>
                        <%# (Eval("arrCongvan")+"")=="" ? "":"(" + Eval("arrCongvan") + ")" %>
                        <br />
                        <span style='font-size: 12px;'>Ngày VP xử lý: <%#Eval("NgayTaoStr") %></span>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                    <ItemStyle HorizontalAlign="Justify"></ItemStyle>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                    <HeaderTemplate>Địa chỉ</HeaderTemplate>
                    <ItemTemplate>
                        <%#Eval("Diachigui") %>
                        <%-- <br />                                          
                                            <i><%# Convert.ToInt32(Eval("LOAIDON"))==2 ? "Ngày công văn":"Ngày trên đơn" %>  
                                            </i>: <%# GetDate(Eval("NGAYGHITRENDON")) %>--%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="250px" ItemStyle-VerticalAlign="Top">
                    <HeaderTemplate>Thông tin đơn</HeaderTemplate>
                    <ItemTemplate>
                        <i>Hình thức: </i><b><%#Eval("HINHTHUCDON") %></b><br />
                        <i>Số </i><b><%#Eval("BAQD_SO") %></b> <i>Ngày: <b><%# GetDate(Eval("BAQD_NGAYBA")) %></b></i>
                        &nbsp;<b><%#Eval("TOAXX_VietTat") %></b><br />
                        <i><%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("BAQD_SO_PT")+"")? "": "<hr  style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_PT")+"<br/>") +
                                                        "<hr style='border-bottom: 0.5px dotted #808080;'>" +        
                                                        (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i>
                        <i><%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": "<hr style='border-bottom: 0.5px dotted #808080;'>" + Eval("Infor_ST") + "<br/>"):""%></i>
                        <%#Eval("TRANGTHAICHUYEN_TP") %>
                        <%#Eval("NGAYCHUYENS") %>
                        <%#Eval("NGAYNHANS") %>
                        <%#Eval("NGAYTRA") %>
                        <%#Eval("THAMPHAN_SONGAY") %>
                        <%#Eval("THAMPHANTC_SONGAY") %>
                        <i><b style="color: #0e7eee;"><%#Eval("TRANGTHAICHUYEN") %>:</b></i>  <b><%#Eval("NOICHUYEN") %></b>
                        <%#Eval("GHICHU_HIS_TRALAI") %>
                        <br />

                        <div style='color: #0e7eee; font-weight: bold; display: <%#Eval("IsShowNB")%>'>
                            <%# String.IsNullOrEmpty(Eval("KQGQNoiBo")+"")?"":"KQ GQ: "+Eval("KQGQNoiBo") %>
                        </div>
                        <div style='display: <%#Eval("IsShowTK")%>'>
                            <asp:LinkButton ID="cmdKQGQ" runat="server"
                                Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>'
                                CommandName="KQGQ" Text="Nhập kết quả giải quyết"></asp:LinkButton>
                        </div>

                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                    <ItemStyle HorizontalAlign="Left"></ItemStyle>
                </asp:TemplateColumn>
                <%-- <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                        <HeaderTemplate>Số đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hddArrDonTrung" runat="server" Value='<%#Eval("ARRDONTRUNG") %>' />
                                            <asp:HiddenField ID="hddDCID" runat="server" Value='<%#Eval("DCID") %>' />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%#Eval("SODON") %>'
                                                CommandName="SoDonTrung" CommandArgument='<%#Eval("ARRDONTRUNG") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>--%>
                <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                    <HeaderTemplate>Số đơn</HeaderTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%#Eval("ARR_DON_IDS") %>' CommandName="don_chuadu_dk" Text='<%#Eval("TONG_SODON") %>'></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                    <HeaderTemplate>Ghi chú</HeaderTemplate>
                    <ItemTemplate>
                        <%#Eval("GHICHU") %>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-Width="205px" HeaderStyle-HorizontalAlign="Center"
                    ItemStyle-HorizontalAlign="Left" Visible="false">
                    <HeaderTemplate>Thông tin vụ án</HeaderTemplate>
                    <ItemTemplate>
                        <asp:HiddenField ID="hddIsMapVuAn" runat="server" Value='<%#Eval("IsMapVuAn") %>' />
                        <asp:HiddenField ID="hddIsThuLy" runat="server" Value='<%#Eval("IsThuLy") %>' />
                        <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("VuAnID") %>' />

                        <asp:Panel ID="pnVuAnInfo" runat="server"
                            Visible='<%#(Convert.ToInt32(Eval("IsMapVuAn")+"")>0) ? true:false%>'>
                            <span style="float: left; width: 100%;">Số <%#Eval("VA_BAQD_SO") %> - Ngày <%#GetDate(Eval("VA_BAQD_NGAYBA")) %>                                             
                            </span>
                            <b><%#Eval("NGUYENDON")+" - "+ Eval("BIDON")+" - "+ Eval("TenQHPL")  %></b>
                            <br />
                            <hr style="border-color: #dcdcdc;" />
                            <asp:Panel ID="pnTTV" runat="server">
                                <b>TTV</b>: <%#Eval("TENTHAMTRAVIEN") %> 
                                                , <b>LĐV</b>: <%#Eval("TENLANHDAOVU") %>
                            </asp:Panel>
                            , <b>TP</b>: <%#Eval("TENTHAMPHAN") %>
                        </asp:Panel>
                        <asp:Literal ID="lttNewVuAn" runat="server"></asp:Literal>
                        <asp:Literal ID="lttTTV" runat="server"></asp:Literal>
                        <asp:Literal ID="lttTP" runat="server"></asp:Literal>
                        <span style="float: left; width: 100%; text-align: center; display: none;">
                            <asp:LinkButton ID="lkThemVA" runat="server" Font-Bold="true" ForeColor="#0e7eee"
                                CommandName="NewVA" CommandArgument='<%#Eval("ID")+";"+ Eval("IsMapVuAn").ToString()+";"+ Eval("IsThuLy").ToString()+";"+ Eval("ARRDONTRUNG").ToString()%>'>Thêm vụ án</asp:LinkButton>
                            <asp:LinkButton ID="lkGhepVuAn" runat="server" Font-Bold="true" ForeColor="#0e7eee"
                                Visible="false"
                                CommandName="GHEPVA" CommandArgument='<%#Eval("ID")%>'>Ghép vụ án</asp:LinkButton>
                        </span>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify" Visible="false">
                    <HeaderTemplate>Trạng Thái</HeaderTemplate>
                    <ItemTemplate>
                        <asp:Literal ID="lttTLTrangthai" runat="server"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateColumn>

            </Columns>
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
        </asp:DataGrid>
        <div class="phantrang">
            <div class="sobanghi">
            </div>
            <div class="sotrang">
                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                &nbsp;&nbsp;
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
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
                <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                    <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="20" Text="20"></asp:ListItem>
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
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
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
</asp:content>
