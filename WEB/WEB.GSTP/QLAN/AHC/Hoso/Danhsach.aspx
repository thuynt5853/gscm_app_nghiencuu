<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.Hoso.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

    <div id="divBackground" style="position: absolute; top: 0px; left: 0px; background-color: black; z-index: 100; opacity: 0.8; filter: alpha(opacity=60); -moz-opacity: 0.8; overflow: hidden; display: none"></div>
    <asp:Button UseSubmitBehavior="false" ID="cmdLoadNhapAn" runat="server" Style="display: none;" disable="false" OnClick="cmdLoadNhapAn_Click" />
<%--    <asp:Button ID="cmdLoadTachAn" runat="server" Style="display: none;" disable="false" OnClick="cmdLoadTachAn_Click" />--%>

    <div class="box">

        <div class="box_nd">
            <h4 style="float: right; text-align: right; margin-right: 10px;">
                <asp:LinkButton ID="LinkButtonAnPhi" runat="server" Text="[ Danh sách biên lai tạm ứng án phí trực tuyến từ DVC / THADS ]" ForeColor="#0E7EEE" OnClick="lbtDanhSachAnPhi_Click"></asp:LinkButton>
                <asp:LinkButton ID="LinkButtonQuaHan" runat="server" Text="[ Danh sách thống kê quá hạn ]" ForeColor="#0E7EEE" OnClick="lbtDanhSachQuaHan_Click"></asp:LinkButton> <%--Link đến màn danh sách thống kê quá hạn--%>
            </h4>
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
                                            <td>
                                                <div style="float: left; width: auto">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Quan hệ pháp luật</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_QHPL" CssClass="user" runat="server" Width="238px"></asp:TextBox>
                                                    </div>
                                                    <%--<div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Mã vụ án</div>--%>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">
                                                        <asp:DropDownList ID="DropMA_THONG_BAO" Width="60px" runat="server">
                                                            <asp:ListItem Value="1" Text="Mã vụ án" Selected="True"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Mã TB án phí"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                </div>


                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Đương sự</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTENDUONGSU" CssClass="user" runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Cấp xét xử</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="246px" AutoPostBack="true"
                                                            OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tòa xx sơ thẩm</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropToaAn" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="DropToaAn_SelectedIndexChanged"></asp:DropDownList>
                                                    </div>
                                                </div>
                                                <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                                    <div style="float: left; width: 1050px; margin-top: 4px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng thụ lý</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="DropTINHTRANG_THULY" CssClass="chosen-select" runat="server" Width="248px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Đã thụ lý"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txt_NGAYTHULY_TU" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_NGAYTHULY_TU" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_NGAYTHULY_TU" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_TU" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txt_NGAYTHULY_DEN" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_DEN" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">

                                                            <asp:DropDownList ID="ddlSoTL_TB" Width="60px" runat="server">
                                                                <asp:ListItem Value="1" Text="Số TL" Selected="True"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Số TB"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtSOTHULY_THONGBAO" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 2px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng GQ</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="DropTINHTRANG_GIAIQUYET" CssClass="chosen-select" runat="server" Width="248px" AutoPostBack="True" OnSelectedIndexChanged="DropTINHTRANG_GIAIQUYET_SelectedIndexChanged">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="+ Chưa giải quyết xong" Selected="True"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text=".....Chưa phân công Thẩm phán"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text=".....Đã phân công Thẩm phán"></asp:ListItem>
                                                                <asp:ListItem Value="4" Text=".....Đã lên lịch xét xử"></asp:ListItem>
                                                                <asp:ListItem Value="5" Text=".....Đang hoãn"></asp:ListItem>
                                                                <asp:ListItem Value="6" Text=".....Đang tạm đình chỉ"></asp:ListItem>
                                                                <asp:ListItem Value="7" Text="+ Đã giải quyết xong"></asp:ListItem>
                                                                <asp:ListItem Value="8" Text=".....Đã xét xử"></asp:ListItem>
                                                                <asp:ListItem Value="9" Text=".....Đình chỉ"></asp:ListItem>
                                                                <asp:ListItem Value="10" Text=".....Công nhận thỏa thuận của đương sự"></asp:ListItem>
                                                                <asp:ListItem Value="11" Text=".....Chuyển vụ án"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                                            <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 6px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Kết quả xx PT</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="Drop_KETQUA" CssClass="chosen-select" runat="server" Width="248px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="...Giữ nguyên quyết định/bản án sơ thẩm"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="...Hủy quyết định/bản án sơ thẩm để xx lại"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text="...Sửa 1 phần bản án/QĐ sơ thẩm"></asp:ListItem>
                                                                <asp:ListItem Value="4" Text="...Sửa toàn bộ bản án/QĐ sơ thẩm"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Số BA/QĐ </div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ngày BA/QĐ</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txt_NgayQD" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txt_NgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txt_NgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </div>
                                                        <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Vai trò của Thẩm phán</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlVaiTroThamPhan" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true" OnSelectedIndexChanged="ddlVaiTroThamPhan_SelectedIndexChanged"></asp:DropDownList>
                                                        </div>
                                                        <%--<div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        </div>--%>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thời hạn GQ</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="DropTHOIHAN_GQ" CssClass="chosen-select" runat="server" Width="248px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="...Đã hết thời hạn"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="...Còn thời hạn dưới 10 ngày"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text="...Còn thời hạn dưới 20 ngày"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">PT rút kinh nghiệm</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="Drop_PT_RKINHNGHIEM" CssClass="chosen-select" runat="server" Width="246px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="...Có"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="...Không"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        </div>
                                                        <%--<div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái vụ án</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlTrangThaiVuAn" CssClass="chosen-select" runat="server" Width="248px">
                                                                <asp:ListItem Value="0" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Đã nhập"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Đã tách"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>--%>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại đơn</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="Drop_Loaidon" CssClass="chosen-select" runat="server" Width="250px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Đơn mới"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Đơn từ Tòa án khác chuyển đến"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text="Đơn trùng"></asp:ListItem>
                                                                <asp:ListItem Value="4" Text="Đơn không thuộc thẩm quyền"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">GQ đơn</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="drop_BIENPHAPGQ" CssClass="chosen-select" runat="server" Width="250px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="5" Text="...Thụ lý"></asp:ListItem>
                                                                <asp:ListItem Value="4" Text="...Yêu cầu bổ sung đơn"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="...Chuyển đơn cho Tòa án khác"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text="...Trả lại đơn"></asp:ListItem>
                                                                <asp:ListItem Value="6" Text="...Đơn chưa giải quyết"></asp:ListItem>
                                                                <asp:ListItem Value="7" Text="...Đơn quá hạn chưa giải quyết"></asp:ListItem>
                                                                <asp:ListItem Value="8" Text="...Đơn chưa phân công TP giải quyết"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ủy thác tư pháp</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="dropUTTP" CssClass="chosen-select" runat="server" Width="250px">
                                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="0" Text="...Không có ủy thác đi"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="...Có ủy thác đi"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div style="float: left; width: 1050px; margin-top: 8px;">
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái nhập/tách</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlTrangThaiVuAn" CssClass="chosen-select" runat="server" Width="248px">
                                                                <asp:ListItem Value="0" Text="-- Tất cả --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Đã nhập"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Đã tách"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">QHPL dùng cho thống kê</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlQHPLTK" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" ></asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">Thao tác nhập tách</div>
                                                        <div style="float: left;">
                                                            <asp:CheckBox ID="chkNhapTach" runat="server" AutoPostBack="true" OnCheckedChanged="chkNhapTach_CheckedChanged" />

                                                        </div>
                                                        <div style="float: left; width: 1050px; margin-top: 8px;">
                                                            <asp:Panel ID="pnlHG" runat="server">
                                                                <div style="float: left; width: 120px; text-align: right; margin-right: 10px;">GQ đơn hoà giải</div>
                                                                <div style="float: left; width: 210px;">
                                                                    <asp:CheckBox ID="checkHG" runat="server" AutoPostBack="true" OnCheckedChanged="checkHG_CheckedChanged" />
                                                                </div>
                                                                <div style="float: left; width: 500px; text-align: right; margin-right: 10px;">GQ KC/KN QĐ tạm đình chỉ và QĐ khác</div>
                                                                <div style="float: left;">
                                                                    <asp:CheckBox ID="ck_GQTDC_QDK" runat="server" AutoPostBack="true" OnCheckedChanged="ck_GQTDC_QDK_CheckedChanged" />
                                                                </div>
                                                                <asp:Panel ID="pnlIsCheckHoaGiai" runat="server" Visible="false">
                                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Kết quả hoà giải</div>
                                                                    <div style="float: left;">
                                                                        <asp:DropDownList ID="ddlHoaGiaiKQ" CssClass="chosen-select" runat="server" Width="248px">
                                                                            <asp:ListItem Value="0" Text="-- Tất cả --"></asp:ListItem>
                                                                            <asp:ListItem Value="1" Text="Chưa tiến hành hoà giải"></asp:ListItem>
                                                                            <asp:ListItem Value="2" Text="Hoà giải thành"></asp:ListItem>
                                                                            <asp:ListItem Value="3" Text="Hoà giải không thành"></asp:ListItem>
                                                                            <asp:ListItem Value="4" Text="Đương sự rút đơn"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </div>

                                                                    <div style="float: left; width: 85px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                                    <div style="float: left;">
                                                                        <asp:TextBox ID="txtHoaGiaiTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtHoaGiaiTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtHoaGiaiTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator6" runat="server" ControlExtender="MaskedEditExtender6" ControlToValidate="txtHoaGiaiTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                                    </div>
                                                                    <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                                                    <div style="float: left;">
                                                                        <asp:TextBox ID="txtHoaGiaiDenNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                                        <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtHoaGiaiDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtHoaGiaiDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator7" runat="server" ControlExtender="MaskedEditExtender7" ControlToValidate="txtHoaGiaiDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                                    </div>
                                                                </asp:Panel>

                                                            </asp:Panel>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>

                                                <div style="float: right; width: 1050px; margin-top: 8px;">
                                                    <div style="float: right; margin-left: -25px; width: 50px; text-align: right; margin-right: 200px;">
                                                        <asp:CheckBox ID="ck_ANKETTHUC" runat="server" AutoPostBack="true" OnCheckedChanged="ck_ANKETTHUC_CheckedChanged" />
                                                    </div>

                                                    <div style="float: right; text-align: right; margin-right: 10px; margin-top: 2px;">Vụ án đã giải quyết xong từ toà cũ</div>

                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                            <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />
                            <asp:Button ID="cmdNhapan" runat="server" CssClass="buttoninput" Text="Nhập án" OnClick="cmdNhapan_Click" />
                            <asp:Button ID="cmdTachan" runat="server" CssClass="buttoninput" Text="Tách án" OnClick="cmdTachan_Click" />

                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">

                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
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
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand"
                                    OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' runat="server" />
                                                <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="85px">
                                            <HeaderTemplate>
                                                Chọn vụ việc
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                &nbsp;
                                                   <asp:Button ID="cmdChitiet" runat="server" Text="Chọn vụ việc"
                                                       CssClass="buttonchitiet" CausesValidation="false"
                                                       CommandName="Select" CommandArgument='<%#Eval("ID") %>' />
                                                <div>&nbsp;</div>
                                                <asp:Button ID="cmdxxlaiPT" runat="server" Text="Thụ lý lại xét xử PT"
                                                    OnClientClick="return confirm('Bạn muốn tạo hồ sơ vụ việc do Giám đốc thẩm hủy để xét xử lại phúc thẩm?');"
                                                    CssClass="buttonchitiet" CausesValidation="false"
                                                    CommandName="xxlaiPT" CommandArgument='<%#Eval("ID") %>' />
                                                <asp:Button ID="cmdxxlaiST" runat="server" Text="Thụ lý lại xét xử ST"
                                                    OnClientClick="return confirm('Bạn muốn tạo hồ sơ vụ án do Giám đốc thẩm hủy để xét xử lại sơ thẩm?');"
                                                    CssClass="buttonchitiet" CausesValidation="false"
                                                    CommandName="xxlaiST" CommandArgument='<%#Eval("ID") %>' />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>
                                                Thông tin vụ việc
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                                <%#Eval("TruongHopGiaoNhan")%>
                                                <%# Eval("TENTOASOTHAM")%>
                                                <%#Eval("BANAN_QD_ST")%>
                                                <%#Eval("HoTenBiCan")%>
                                                <%#Eval("KHANGNGHI_ST")%>
                                                <%#Eval("KHANGCAO_ST")%>


                                                <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng GQ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TINHTRANG_GQ")%>
                                                <%#Eval("QD_PT")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="65px">
                                            <HeaderTemplate>
                                                Người tạo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("NGUOITAO")%>
                                                <br />
                                                <%#Eval("NGAYTAO")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã vụ việc
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MAVUVIEC")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="Sua"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                <br></br>
                                                <br></br>
                                                <asp:LinkButton ID="lbtXoa" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Xóa"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa vụ việc này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
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
                            </div>
                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
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
        }
        function HideModalDivNhapAn() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdLoadNhapAn.ClientID %>").click();
        }
<%--        function HideModalDivTachAn() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdLoadTachAn.ClientID %>").click();
        }--%>
    </script>
</asp:Content>
