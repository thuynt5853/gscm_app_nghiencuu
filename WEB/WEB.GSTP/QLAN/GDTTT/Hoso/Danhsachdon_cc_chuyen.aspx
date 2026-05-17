<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsachdon_cc_chuyen.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Danhsachdon_cc_chuyen" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddCountCV" Value="0" runat="server" />
    <asp:HiddenField ID="lstDataUS" Value="" runat="server" />
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
    <div id="divBackground" style="position: absolute; top: 0px; left: 0px; background-color: black; z-index: 100; opacity: 0.8; filter: alpha(opacity=60); -moz-opacity: 0.8; overflow: hidden; display: none">
    </div>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton>
                                </h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td class="DonGDTCol1">Người gửi</td>
                                            <td class="DonGDTCol2">
                                                <asp:TextBox ID="txtNguoigui" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol3">Số BA/QĐ</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tòa ra BA/QĐ</td>
                                            <td>
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select" runat="server" Width="230px"></asp:DropDownList>
                                            </td>
                                            <td><b>Ngày nhập từ</b></td>
                                            <td>
                                                <asp:TextBox ID="txtNgaynhapTu" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtNgaynhapTu" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtNgaynhapTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Đến ngày</td>
                                            <td>
                                                <asp:TextBox ID="txtNgaynhapDen" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNgaynhapDen" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNgaynhapDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>Địa chỉ gửi đơn</td>
                                            <td>
                                                <%--<asp:DropDownList ID="ddlTinh" CssClass="chosen-select" runat="server" Width="113px" AutoPostBack="true" OnSelectedIndexChanged="ddlTinh_SelectedIndexChanged"></asp:DropDownList>--%>
                                                <asp:DropDownList ID="ddlHuyen" CssClass="chosen-select" runat="server" Width="230px"></asp:DropDownList>
                                            </td>
                                            <td>Địa chỉ chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtDiachi" CssClass="user" runat="server" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Trả lời đơn</td>
                                            <td>
                                                <asp:DropDownList ID="ddlTraloi" CssClass="chosen-select" runat="server" Width="108px">
                                                    <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Có trả lời"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Không trả lời"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol1">Đơn từ toà án CC</td>
                                            <td>
                                                <asp:DropDownList ID="ddlToaAnCc" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <tr>
                                                <td>Hình thức đơn</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlHinhthucdon" Width="230px" CssClass="chosen-select" runat="server">
                                                        <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Văn bản hành chính,Tài liệu chung"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="6" Text="CV kiến nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="9" Text="CV kiến nghị GĐT,TT kèm Hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="7" Text="Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
                                                        <asp:ListItem Value="8" Text="Đơn khiếu nại tư pháp"></asp:ListItem>
                                                        <asp:ListItem Value="10" Text="Đơn khiếu nại tư pháp kèm CV chuyển đơn"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Số CMND</td>
                                                <td>
                                                    <asp:TextBox ID="txtSoCMND" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td>Mã đơn/ Số hiệu đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtSohieudon" runat="server" CssClass="user" Width="100px" MaxLength="50"></asp:TextBox>
                                                </td>
                                            </tr>



                                            <tr>
                                                <td><b>Ngày thụ lý từ</b></td>
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
                                                    <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="100px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Phạm vi tìm kiếm</b></td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhanloaiDdon" CssClass="chosen-select" runat="server" Width="230px" Enabled="false" AutoPostBack="True" OnSelectedIndexChanged="ddlTrangthaichuyen_SelectedIndexChanged">
                                                        <%--<asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>--%>
                                                        <asp:ListItem Value="1" Text="Đơn gốc"></asp:ListItem>

                                                        <asp:ListItem Value="2" Text="Tất cả" Selected="True"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Nhận đơn từ</td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayNhanTu" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayNhanTu" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayNhanDen" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayNhanDen" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayNhanDen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tên cơ quan chuyển đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtCVPC_TenCQ" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td>Số CV/PC đến</td>
                                                <td>
                                                    <asp:TextBox ID="txtCVPC_So" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                                </td>
                                                <td>Ngày CV/PC</td>
                                                <td>
                                                    <asp:TextBox ID="txtCVPC_Ngay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtCVPC_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtCVPC_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Loại công văn</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLoaiCV" CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>

                                                <td>
                                                    <%-- <asp:DropDownList ID="ddlLOAICVPC" runat="server" Width="80px">
                                                        <asp:ListItem Value="0" Text="CV/PC Số"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="TTr Số"></asp:ListItem>
                                                    </asp:DropDownList>--%>
                                                    <asp:DropDownList ID="ddlLOAICVPC" runat="server" Width="80px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="Drop_LOAICVPC_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                                <%--Số CV chuyển (HCTP)--%>
                                                <td>
                                                    <asp:TextBox ID="txtCV_So" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td id="txtNgayCV" runat="server">Ngày CV</td>
                                                <td>
                                                    <asp:TextBox ID="txtCV_Ngay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtCV_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtCV_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>

                                            </tr>
                                            <tr>
                                                <td>Thẩm phán
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="230px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Lãnh đạo chỉ đạo?</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlChidao" CssClass="chosen-select" runat="server" Width="160px">
                                                        <asp:ListItem Value="-1" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Trại giam?</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTraigiam" CssClass="chosen-select" runat="server" Width="110px">
                                                        <asp:ListItem Value="-1" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Nơi chuyển</b></td>
                                                <td>
                                                    <asp:DropDownList ID="ddlNoichuyenden" CssClass="chosen-select" runat="server" Width="230px" AutoPostBack="True" OnSelectedIndexChanged="ddlNoichuyenden_SelectedIndexChanged">
                                                        <asp:ListItem Value="-1" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Nội bộ"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Tòa khác"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Ngoài tòa án"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Trả lại đơn"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Xếp đơn"></asp:ListItem>
                                                        <asp:ListItem Value="-2" Text="Tòa khác + Ngoài tòa án"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td><b>Chuyển đến</b></td>
                                                <td colspan="3">
                                                    <asp:DropDownList ID="ddlPhongban" Visible="false" CssClass="chosen-select" runat="server" Width="160px" AutoPostBack="True" OnSelectedIndexChanged="ddlPhongban_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                    <asp:Panel ID="pnToakhac" runat="server" Visible="false">
                                                        <asp:DropDownList ID="ddlToaKhac" CssClass="chosen-select" runat="server" Width="357px" AutoPostBack="True" OnSelectedIndexChanged="ddlToaKhac_SelectedIndexChanged"></asp:DropDownList>

                                                    </asp:Panel>
                                                    <asp:TextBox ID="txtNgoaitoaan" Visible="false" CssClass="user" runat="server" Width="152px"></asp:TextBox>



                                                    <asp:DropDownList ID="ddlTrangthaidon" Visible="false" CssClass="chosen-select" runat="server" Width="192px" AutoPostBack="True" OnSelectedIndexChanged="ddlTrangthaidon_SelectedIndexChanged">
                                                        <asp:ListItem Value="-1" Text="--Trạng thái đơn--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Đơn đủ điều kiện"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đơn chưa đủ điều kiện"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="  - Chưa thụ lý"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="  - Đã thụ lý"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="  - Quá 1 tháng chưa bổ sung"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td>Chuyển tới CA/TA?</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlChuyentoi" CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="-1" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Tòa án"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Chánh án"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Loại án</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblThuLy" Font-Bold="true" runat="server" Text="Thụ lý đơn"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThuLy" CssClass="chosen-select" runat="server" Width="108px" AutoPostBack="True" OnSelectedIndexChanged="ddlThuLy_SelectedIndexChanged">
                                                        <asp:ListItem Value="-1" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Thụ lý mới"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="--TLM trùng"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="--TLM đã phân công"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="--TLM chưa phân công"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Đã thụ lý"></asp:ListItem>
                                                        <%-- <asp:ListItem Value="3" Text="Thụ lý lại"></asp:ListItem>--%>
                                                        <%-- <asp:ListItem Value="4" Text="Thụ lý lần đầu + Thụ lý lại"></asp:ListItem>--%>
                                                    </asp:DropDownList>
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
                                                <td>Thủ tục giải quyết</td>
                                                <td>
                                                    <asp:DropDownList ID="ddl_LOAI_GDTTT" Width="108px" CssClass="chosen-select" runat="server">
                                                        <asp:ListItem Value="0" Text="--Tất cả--" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Giám đốc thẩm"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Tái thẩm"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Chưa xác định"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>


                                            <tr>
                                                <td>Án tử hình</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlAnTuHinh" CssClass="chosen-select" runat="server" Width="230px">
                                                        <asp:ListItem Value="0" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Không có án tử hình"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Có án tử hình"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Có án tử hình - Xin ân giảm"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Có án tử hình - Kêu oan"></asp:ListItem>

                                                    </asp:DropDownList>
                                                </td>
                                                <td>Người nhập</td>
                                                <td colspan="3" rowspan="1" style="vertical-align: top;">
                                                    <%--<div style="width: 100%; max-height: 110px; overflow-y: auto;">
                                                        <asp:CheckBoxList ID="chkNguoinhap" runat="server" RepeatColumns="3" Width="98%" RepeatDirection="Horizontal">
                                                        </asp:CheckBoxList>
                                                    </div>

                                                    <asp:TextBox ID="txtNguoiNhap" Visible="false" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>--%>

                                                    <asp:DropDownList ID="ddl_USER_ID" multiple data-placeholder="...chọn..." class="chosen-select" Style="width: 355px;" runat="server"></asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Trạng thái chuyển</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTrangthaichuyen" CssClass="chosen-select" runat="server" Width="230px" AutoPostBack="True" OnSelectedIndexChanged="ddlTrangthaichuyen_SelectedIndexChanged">
                                                        <asp:ListItem Value="-1" Text="--- Tất cả ---" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa chuyển"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã chuyển"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Đã chuyển và đã nhận"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Bị trả lại"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td colspan="2">
                                                    <asp:DropDownList ID="Drop_NDBD" CssClass="chosen-select" runat="server" Width="247px">
                                                        <asp:ListItem Value="0" Text="Nguyên đơn/ Người khởi kiện"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Bị đơn/ Người bị kiện"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Bị cáo"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txt_NDBD" runat="server" CssClass="user" Width="177px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                    </table>
                                </div>
                            </div>
                            <asp:Panel ID="pn_vanthu" runat="server" Visible="false">
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Văn thư - Đơn đến
                                    <asp:LinkButton ID="lbt_vt_vbd" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lbt_vt_vbd_Click"></asp:LinkButton>
                                    </h4>
                                    <div class="boder" style="padding: 10px; float: left; width: 98%;">
                                        <asp:Panel ID="pn_VT_VBD" runat="server" Visible="false">
                                            <div style="float: left; width: 900px">
                                                <div style="float: left; width: 100px; text-align: right; margin-top: 5px;">Đơn vị tiếp nhận</div>
                                                <div style="float: left; width: 178px; margin-left: 7px;">
                                                    <asp:DropDownList ID="Drop_NOI_NHAN_SEARCH" CssClass="chosen-select" runat="server" Width="178px">
                                                    </asp:DropDownList>
                                                </div>
                                                <div style="float: left; width: 100px; text-align: right;">Trạng thái</div>
                                                <div style="float: left; width: 178px; margin-left: 5px;">
                                                    <asp:DropDownList ID="Drop_TRANGTHAICHUYEN" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="Drop_TRANGTHAICHUYEN_SelectedIndexChanged" runat="server" Width="178px">
                                                        <asp:ListItem Value="" Selected="True" Text="---Tất cả---"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Chưa xử lý"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Đã xử lý"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                                <div style="float: left; width: 100px; text-align: right">Loại văn bản</div>
                                                <div style="float: left; width: 170px; margin-left: 6px;">
                                                    <asp:DropDownList ID="Drop_LOAI_VB_Search" CssClass="chosen-select" runat="server" Width="170px">
                                                        <asp:ListItem Value="" Selected="True" Text="---Tất cả---"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Văn bản hành chính,Tài liệu chung"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đơn đề nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="6" Text="CV kiến nghị GĐT,TT"></asp:ListItem>
                                                        <asp:ListItem Value="9" Text="CV kiến nghị GĐT,TT kèm Hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="7" Text="Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
                                                        <asp:ListItem Value="8" Text="Đơn khiếu nại tư pháp"></asp:ListItem>
                                                        <asp:ListItem Value="10" Text="Đơn khiếu nại tư pháp kèm CV chuyển đơn"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div style="float: left; width: 900px; margin-top: 5px;">
                                                <div style="float: left; width: 100px; text-align: right;">Số đến từ</div>
                                                <div style="float: left; width: 170px; margin-left: 7px;">
                                                    <asp:TextBox ID="txt_SODEN_SEARCH" runat="server"
                                                        CssClass="user" Width="170px" MaxLength="250" Text="">
                                                    </asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 100px; text-align: right; margin-left: 5px;">Đến</div>
                                                <div style="float: left; width: 170px; margin-left: 7px;">
                                                    <asp:TextBox ID="txt_SODEN_SEARCH_DEN" runat="server"
                                                        CssClass="user" Width="170px" MaxLength="250" Text="">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div style="float: left; width: 900px; margin-top: 5px;">
                                                <div style="float: left; width: 100px; text-align: right;">Ngày đến từ</div>
                                                <div style="float: left; width: 170px; margin-left: 7px;">
                                                    <asp:TextBox ID="txt_NGAY_FROM" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender13" runat="server" TargetControlID="txt_NGAY_FROM" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender13" runat="server" TargetControlID="txt_NGAY_FROM" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                                <div style="float: left; width: 100px; text-align: right; margin-left: 5px;">Đến ngày</div>
                                                <div style="float: left; width: 170px; margin-left: 7px;">
                                                    <asp:TextBox ID="txt_NGAY_TO" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender14" runat="server" TargetControlID="txt_NGAY_TO" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender14" runat="server" TargetControlID="txt_NGAY_TO" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </div>
                                            </div>
                                            <div style="float: left; width: 900px; margin-top: 5px;">
                                                <div style="float: left; width: 100px; text-align: right;">Người gửi/Đơn vị gửi</div>
                                                <div style="float: left; width: 730px; margin-left: 7px;">
                                                    <asp:TextBox ID="txt_NGUOI_GUI_BT_SEARCH" runat="server"
                                                        CssClass="user" Width="730px" Text="">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </asp:Panel>
                            <%--------------------------btn search------------------------------------------%>
                            <div style="float: left; width: 900px; margin-top: 15px;">
                                <div style="float: left; width: 400px; margin-left: 50px; min-height: 10px;">
                                    <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                </div>
                                <div style="float: left;">
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                </div>
                                <div style="float: left; margin-left: 5px;">
                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                </div>

                            </div>
                            <%--------------------------------------------------------------------%>
                           
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">
                                </div>
                                <div class="sotrang">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    &nbsp;&nbsp;
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
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
                                    <asp:DropDownList ID="ddlPageCount" Visible="false" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30" Selected="True"></asp:ListItem>
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
                                ItemStyle-CssClass="chan"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("arrDonID")%>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>TT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top" HeaderStyle-Width="30%">
                                        <HeaderTemplate>Thông tin người gửi/đơn vị gửi</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Panel ID="pn_TTNGDVG" runat="server" Visible="false">
                                                <%#Eval("DONVITIEPNHAN") %>
                                                <%#Eval("DONGKHIEUNAI_CC") %><b style="color: #db212d"><%#Eval("THOIHIEU") %></b>
                                                <%# Convert.ToInt32(Eval("LOAIDON"))==2 ? ("(Số "+Eval("CV_SO")+ ")"):"" %><br />
                                                <i>Địa chỉ</i>:<b> <%#Eval("Diachigui") %></b><br />
                                                <i>Số điện thoại</i>:<b> <%#Eval("NGUOIGUI_DIENTHOAI") %></b><br />
                                                <i><%# Eval("LBL_HINHTHUC_CC") %>
                                                </i>: <%# GetDate(Eval("NGAYGHITRENDON_CC")) %>&nbsp;
                                                <i>Ngày nhận</i>: <%# Eval("NGAYNHANDON") %><br />
                                                <%#Eval("MADON_CC") %> &nbsp;Số hiệu: <%#Eval("SOHIEUDON") %>  &nbsp;<br />
                                                <i>Nguồn đến</i>: <b><%#Eval("NGUON_DEN") %></b><br />
                                                <i>Hình thức</i>: <b><%#Eval("HinhThuc") %></b><br />
                                                <%# (Eval("arrCongvan")+"")=="" ? "":"(" + CatXau(Eval("arrCongvan")+"",250) + ")" %><br />
                                                <i>Thủ tục giải quyết</i>:<b> <%#Eval("TRANGTHAILOAI_GDTTTT") %></b><br />
                                            </asp:Panel>
                                            <%------------------------------------------------%>
                                            <asp:Panel ID="pn_TTNGDVG_VT" runat="server" Visible="false">
                                                <%#Eval("DONVITIEPNHAN") %>
                                                <%#Eval("NGUOI_GUI_BT") %></b><br />
                                                <i>Địa chỉ</i>:<b> <%#Eval("DIACHI_GUI_BT") %></b><br />
                                                <i>Số điện thoại</i>:<b> <%#Eval("NGUOIGUI_DIENTHOAI") %></b><br />
                                                <i>Ngày đến</i>: <b><%#Eval("NGAY_DEN") %></b>
                                                <i>Ngày trên bì thư</i>:<b> <%#Eval("NGAY_BT") %></b><br />
                                                <i>Số đến</i>: <b><%#Eval("SODEN") %></b><br />
                                                <i>Nguồn đến</i>: <b><%#Eval("NGUON_DEN") %></b><br />
                                                <i>Hình thức</i>: <b><%#Eval("HinhThuc") %></b><br />
                                                <i>Thủ tục giải quyết</i>:<b> <%#Eval("TRANGTHAILOAI_GDTTTT") %></b>
                                            </asp:Panel>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Panel ID="pn_TTD_HCTP" runat="server" Visible="true">
                                                <%#Eval("BAQD_CC") %> <%# Eval("BAQD_NGAYBA_CC") %>
                                                &nbsp;<b><%#Eval("TOAXX") %></b><br />
                                                <%# (String.IsNullOrEmpty(Eval("LOAI_GDTTTT") + "")) ? "": (String.IsNullOrEmpty(Eval("TRANGTHAILOAI_GDTTTT") + "") ? "" : 
                                                                                                    "<i>Thủ tục giải quyết:</i><b> " + Eval("TRANGTHAILOAI_GDTTTT") + "</b><br/>") %><i><%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==4 ? ((String.IsNullOrEmpty(Eval("Infor_PT")+"")? "": Eval("Infor_PT")+"<br/>") +
                                                                (String.IsNullOrEmpty(Eval("BAQD_SO_ST")+"")? "": Eval("Infor_ST") + "<br/>")):"" %></i><i><%# Convert.ToInt32(Eval("BAQD_CAPXETXU"))==3 ? (String.IsNullOrEmpty(Eval("Infor_ST")+"")? "": Eval("Infor_ST") + "<br/>"):""%></i>
                                            </asp:Panel>
                                            <asp:Panel ID="pn_TTD" runat="server" Visible="false">
                                                <i><b style="color: #0e7eee;"><%#Eval("TRANGTHAICHUYEN") %>:</b></i>  <b><%#Eval("NOICHUYEN") %></b> <i>(Số <%#Eval("SVB_SOCV") %> - <%# GetDate(Eval("SVB_NGAYCV")) %>)</i>

                                                <br />

                                                <i>Ghi chú: </i><%#Eval("GHICHU") %>
                                                <asp:LinkButton ID="cmdXemthem" runat="server" ForeColor="#0e7eee" Visible="false" Text="[Xem thêm]"></asp:LinkButton>
                                                <br />
                                                <div style='color: #0e7eee; font-weight: bold; display: <%#Eval("IsShowNB")%>'>
                                                    <%# String.IsNullOrEmpty(Eval("KQGQNoiBo")+"")?"":"KQ GQ: "+Eval("KQGQNoiBo") %>
                                                </div>
                                                <div style='display: <%#Eval("IsShowTK")%>'>
                                                    <asp:LinkButton ID="cmdKQGQ" runat="server"
                                                        Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>'
                                                        CommandName="KQGQ" Text="">
                                                    </asp:LinkButton>
                                                </div>
                                                <%--<div style='width: 100%; display: <%# Eval("IsShowCDDK") %>'>
                                                    <i><%#Eval("YCBS") %></i>
                                                    <br />
                                                    <asp:LinkButton ID="cmdYCBS" runat="server" Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>' CommandName="YCBS" Text="Thêm yêu cầu bổ sung"></asp:LinkButton>
                                                </div>--%>
                                                <asp:Panel ID="pnDSYCBS" runat="server" Visible="false">
                                                    <div style='display: <%# Eval("IsShowDDK") %>'>
                                                        <i><%#Eval("YCBS") %></i>
                                                        <asp:ImageButton ID="cmdDsYCBS" runat="server" ToolTip="DS yêu cầu bổ sung" CssClass="grid_button"
                                                            CommandName="DSYCBS" CommandArgument='<%#Eval("ID") %>'
                                                            ImageUrl="~/UI/img/list_18.png" Width="12px" Style="margin-left: 5px; margin-bottom: -3px;" />
                                                    </div>
                                                </asp:Panel>
                                            </asp:Panel>
                                            <asp:Panel ID="pn_TTD_VT" runat="server" Visible="false">
                                                <div style='width: 100%;'>
                                                    <%#Eval("THONGTIN_VBD") %>
                                                </div>
                                            </asp:Panel>
                                            <%-- &nbsp;&nbsp;<asp:LinkButton ID="cmdKinhtrinh"   Visible='<%# GetBool(Eval("CHIDAO_COKHONG")) %>' runat="server" Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>' CommandName="KINHTRINH" Text="Báo cáo lãnh đạo"></asp:LinkButton>--%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số đơn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Label runat="server" ForeColor="#0e7eee" Font-Bold="true" Text='<%#Eval("SODON") %>'></asp:Label>
                                            <div style="display: none;">
                                                <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true" CommandArgument='<%#Eval("arrDonID") %>' CommandName="SoDonTrung" Text='<%#Eval("SODON") %>'></asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="110px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thông tin giải quyết</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Panel ID="pn_TTGQ" runat="server" Visible="false">
                                                <div style='width: 100%; display: <%#Eval("IsShowNB") %>'>
                                                    <div style='width: 100%; display: <%#Eval("IsShowDDK") %>'>
                                                        <div style='width: 100%; display: <%#Eval("IsShowTLMOI") %>'>
                                                            <b><%#Eval("lb_thuly") %></b><br />
                                                            <i>Số: </i><%#Eval("TL_SO") %> - <%# GetDate(Eval("TL_NGAY")) %>
                                                            <%-- <br />
                                                            <i>Thẩm phán</i><br />
                                                            <b><%#Eval("TENTHAMPHAN") %></b> (<%#Eval("TOTRINH_SONGAY") %>/TTr-TANDTC-VP)--%>
                                                        </div>
                                                        <div style='width: 100%; display: <%#Eval("IsShowDATL") %>'>
                                                            <b>Đã thụ lý</b>
                                                            <br />
                                                            <%#Eval("arrTTTL") %>
                                                        </div>
                                                    </div>
                                                    <div style='width: 100%;'>
                                                        <%#Eval("HOAN_THA") %>
                                                    </div>
                                                    <div style='width: 100%; display: <%#Eval("IsThulyXX") %>'>
                                                        <b>Thụ lý xét xử GDT</b><br />
                                                        <i>Số: </i><%#Eval("SOTHULYXXGDT") %> - <%# GetDate(Eval("NGAYTHULYXXGDT")) %>
                                                    </div>
                                                    <div style='width: 100%; display: <%#Eval("IsShowCDDK") %>'>
                                                        <b>Đơn chưa đủ điều kiện</b>
                                                        <br />
                                                        <br />
                                                        <%--<asp:LinkButton ID="cmdBSTaiLieu" runat="server" Font-Bold="true" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID") %>' CommandName="BOSUNGTL" Text="Bổ sung tài liệu"></asp:LinkButton>--%>

                                                    </div>
                                                </div>
                                                <div style='width: 100%; display: <%#Eval("IsShowTK") %>'>
                                                    <b><%#Eval("GIAIQUYET") %></b>
                                                </div>
                                                <div style='width: 100%; display: <%#Eval("IsGXN") %>'>
                                                    <i>GXN Số: </i><%#Eval("GXNSO") %> - <%# GetDate(Eval("GXNNGAY")) %>
                                                </div>
                                            </asp:Panel>
                                            <asp:Panel ID="pn_TTGQ_VT" runat="server" Visible="false">
                                                <div style='width: 100%;'>
                                                    <b>Chưa xử lý</b>
                                                </div>
                                            </asp:Panel>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Người nhập/sửa</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NguoiNhap") %><br />
                                            <%# Convert.ToDateTime(Eval("NgayNhap")).ToString("dd/MM/yyyy HH:mm") %>
                                            <hr style="width: 100%; border: solid 1px #dcdcdc;" />
                                            <%#Eval("NGUOISUA") %>
                                            <br />
                                            <%# (Eval("NGAYSUA")+"")==""?"":Convert.ToDateTime(Eval("NGAYSUA")).ToString("dd/MM/yyyy HH:mm") %>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Panel ID="pn_THAOTAC" runat="server" Visible="false">
                                               <%--  <a style="color: #0e7eee" href="/QLAN/GDTTT/Hoso/Thongtindon.aspx?type=new&cc_id=<%#Eval("ID")%>">Xử lý</a>--%>
                                                <asp:LinkButton ID="cmdXuLy" runat="server" ForeColor="#0e7eee" CommandArgument='<%#Eval("ID")%>' CommandName="XuLy" Text="Xử lý"></asp:LinkButton>
                                              
                                            </asp:Panel>
                                           <%--  <asp:Panel ID="pn_THAOTAC_VT" runat="server" Visible="false">
                                                <div class="tooltip">
                                                    <asp:ImageButton ID="cmd_xuly_vt_vbd" runat="server" CausesValidation="false" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ID")+";"+ Eval("VANBANDEN_ID") %>'
                                                        ToolTip="" ImageUrl="../../../UI/img/xl_don.png" Width="26px"
                                                        OnClick="cmd_xuly_vt_vbd_Click" />
                                                    <span class="tooltiptext  tooltip-bottom">Xử lý đơn (<%#Eval("VANBANDEN_ID") %>)</span>
                                                </div>
                                            </asp:Panel>--%>
                                        </itemtemplate>
                                        <headerstyle horizontalalign="Center"></headerstyle>
                                        <itemstyle horizontalalign="Center"></itemstyle>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="CV_TRALOI_NOIDUNG" Visible="false"></asp:BoundColumn>
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
                                        OnClick="lbTBack_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
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
                                    <asp:DropDownList ID="ddlPageCount2" Visible="false" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30" Selected="True"></asp:ListItem>
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
        function ddlMultiSelect_fu() {
            $('#<%=ddl_USER_ID.ClientID %>').chosen().change(function (e, params) {
                var values = $('#<%=ddl_USER_ID.ClientID %>').chosen().val();
                console.log(values);
                document.getElementById('<%=lstDataUS.ClientID%>').value = values;
                //tamnc 17/03/2022//
            });
        }
        function ddlMultiSelect_fu_setvalue() {
            var my_val = document.getElementById('<%=lstDataUS.ClientID%>').value;
            var str_array = my_val.split(',');
            $('#<%=ddl_USER_ID.ClientID %>').val(str_array).trigger("chosen:updated");
            console.log(str_array);
        }
        //function Check_xuly_vt_vbd() {
        //    if (window.confirm('Bạn muốn xử lý đơn này ?')) {
        //        return true;
        //    }
        //    else {
        //        return false;
        //    }
        //}
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function Confirm_in() {
            var HddCount = document.getElementById('<%= hddCountCV.ClientID %>');
            if (HddCount.value == "1") {
                alert("Đơn đã có số Công văn bạn không được chèn số Công văn mới vào Phiếu chuyển thụ lý mới!\n" +
                    "Bạn phải sửa số Công văn của đơn để in Phiếu chuyển\n" +
                    "Hệ thống sẽ lấy số Công văn đã được gắn với đơn để hiển thị trên Phiếu chuyển");
                return true;
            } else {
                return true;
            }

        }

        function Confirm() {

            var id = "confirm_value",
                confirm_value = document.getElementById("confirm_value");
            if (!confirm_value) {
                confirm_value = document.createElement("input");
                confirm_value.type = "hidden";
                confirm_value.name = id;
                confirm_value.id = id;
                document.forms[0].appendChild(confirm_value);
            }
            var HddCount = document.getElementById('<%= hddCountCV.ClientID %>');
            <%--var txtBC_SoCV = document.getElementById('<%=txtBC_SoCV.ClientID%>');
            if (txtBC_SoCV.value != "" & HddCount.value == "1") {
                confirm_value.value = confirm("Một số đơn đã có số Công văn nên không được ghi đè!\n" +
                    "Các đơn chưa có số Công văn bạn có muốn chèn số Công văn cho các đơn này không? ") ? "yes" : "no";

                return true;
            } else {
                confirm_value.value = 'yes';
                return true;
            }--%>

        }
        function Loads_KQ() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }

    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            ddlMultiSelect_fu();
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
</asp:Content>
