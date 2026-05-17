<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" Culture="vi-VN" UICulture="vi"
    AutoEventWireup="true" CodeBehind="BanGiao.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.BanGiao" %>

<%@ Register Assembly="AjaxControlToolkit"
    Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content
    ID="Content2"
    ContentPlaceHolderID="ContentPlaceHolder1"
    runat="server">
    <asp:Panel ID="pnDanhsach" runat="server">
        <script src="../../../UI/js/Common.js"></script>
        <style type="text/css">
            input[type="checkbox"] {
                margin-right: 0px !important;
            }

            .duyetkcqqh {
                color: red;
            }
        </style>

        <!-- Tổng số trang -->
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <!-- Trang hiện tại -->
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
                                                <td style="width: 75px;">Lựa chọn</td>
                                                <td style="width: 200px;">
                                                    <asp:DropDownList ID="dropLoaiLuaChon" CssClass="chosen-select"
                                                        Width="180px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="dropLoaiLuaChon_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>Mã vụ án</td>
                                                <td>
                                                    <asp:TextBox ID="txtMaVuAn" CssClass="user"
                                                        runat="server" Width="170px" MaxLength="50"></asp:TextBox></td>
                                                <td style="width: 80px;">Tên vụ án</td>
                                                <td>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenVuAn" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; margin-left: 10px;">
                                                        <span style="float: left; line-height: 25px; margin-right: 5px;">Trạng thái GQ</span>
                                                        <asp:DropDownList
                                                            ID="ddlTrangThaiGiaiQuyet"
                                                            CssClass="chosen-select"
                                                            runat="server"
                                                            Width="175px"
                                                            AutoPostBack="True">
                                                            <asp:ListItem
                                                                Value="0"
                                                                Text="Chưa có QĐ thi hành án" Selected="True"></asp:ListItem>
                                                            <asp:ListItem
                                                                Value="1"
                                                                Text="Đã có QĐ thi hành án"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Mã bị án</td>
                                                <td>
                                                    <asp:TextBox ID="txtMaBiAn" CssClass="user"
                                                        runat="server" Width="170px" MaxLength="50"></asp:TextBox></td>
                                                <td>Tên bị án</td>
                                                <td>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenBiAn" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; margin-left: 10px;">
                                                        <span style="float: left; line-height: 25px; margin-right: 26px;">Số CMND</span>
                                                        <asp:TextBox ID="txtCMND" CssClass="user"
                                                            runat="server" Width="170px" MaxLength="50"></asp:TextBox>
                                                    </div>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Số bản án</td>
                                                <td>
                                                    <asp:TextBox ID="txtSoBanAn" CssClass="user" runat="server"
                                                        Width="170px" MaxLength="50"></asp:TextBox></td>
                                                <td>Ngày bản án</td>
                                                <td>
                                                    <asp:TextBox ID="txtNgayBanAn" runat="server" CssClass="user" Width="170px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                                        TargetControlID="txtNgayBanAn" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                                        TargetControlID="txtNgayBanAn" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                    <%--<div style="float: left; margin-left: 10px;">
                                                        <span style="float: left; line-height: 25px; margin-right: 5px;">Trạng thái thụ lý</span>
                                                        <asp:DropDownList ID="dropTrangThaiThuLyTHA" CssClass="chosen-select"
                                                            Width="180px" runat="server">
                                                            <asp:ListItem Text="Tất cả" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="Chưa thụ lý" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="Đã thụ lý" Value="1"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tình trạng GQ</td>
                                                <td>
                                                    <asp:DropDownList ID="dropTinhTrangGQ" CssClass="chosen-select"
                                                        Width="180px" runat="server" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Từ ngày</td>
                                                <td>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" MaxLength="10" Width="170px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                            TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                                            TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                            ErrorTooltipEnabled="true" />
                                                    </div>
                                                    <div style="float: left; margin-left: 10px;">
                                                        <span style="float: left; line-height: 25px; margin-right: 28px;">Đến ngày </span>
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" MaxLength="10" Width="170px"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server"
                                                            TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                                            TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                            ErrorTooltipEnabled="true" />
                                                    </div>
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <!-- Trạng thái chuyển -->
                                            <tr>
                                                <td>Trạng thái</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList
                                                        ID="rdbTrangthai"
                                                        runat="server"
                                                        RepeatDirection="Horizontal"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="rdbTrangthai_SelectedIndexChanged">
                                                        <asp:ListItem
                                                            Value="0"
                                                            Text="Chưa chuyển"
                                                            Selected="True"></asp:ListItem>
                                                        <asp:ListItem
                                                            Value="1"
                                                            Text="Đã chuyển"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" align="center"></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>

                        <!-- Button -->
                        <tr>
                            <td align="center">
                                <asp:Button
                                    ID="cmdTimkiem"
                                    runat="server"
                                    CssClass="buttoninput"
                                    Text="Tìm kiếm"
                                    OnClick="cmdTimkiem_Click" />
                                <asp:Button
                                    ID="cmdNhanan"
                                    runat="server"
                                    CssClass="buttoninput"
                                    Text="Bàn giao án"
                                    OnClick="cmdNhanan_Click" />
                                <asp:Button
                                    ID="cmdHuyChuyen"
                                    runat="server"
                                    CssClass="buttoninput"
                                    Text="Hủy bàn giao án"
                                    OnClientClick="return confirm('Bạn thực sự muốn hủy chuyển án này? ');"
                                    OnClick="cmdHuyChuyen_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label
                                    runat="server"
                                    ID="lbthongbao"
                                    ForeColor="Red"></asp:Label>

                                <div class="phantrang">
                                    <!-- Số bản ghi -->
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>

                                    <!-- Số trang hiện có -->
                                    <div class="sotrang">
                                        <asp:LinkButton
                                            ID="lbTBack"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbTFirst"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="active"
                                            Text="1"
                                            OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label
                                            ID="lbTStep1"
                                            runat="server"
                                            Text="..."></asp:Label>
                                        <asp:LinkButton
                                            ID="lbTStep2"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="2"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbTStep3"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="3"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbTStep4"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="4"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbTStep5"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="5"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label
                                            ID="lbTStep6"
                                            runat="server"
                                            Text="..."></asp:Label>
                                        <asp:LinkButton
                                            ID="lbTLast"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="100"
                                            OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbTNext"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>

                                <!-- Bảng danh sách án -->
                                <asp:DataGrid
                                    ID="dgList"
                                    runat="server"
                                    AutoGenerateColumns="False"
                                    CellPadding="4"
                                    PageSize="10"
                                    AllowPaging="True"
                                    GridLines="None"
                                    PagerStyle-Mode="NumericPages"
                                    CssClass="table2"
                                    HeaderStyle-CssClass="header"
                                    AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan"
                                    Width="100%"
                                    OnItemDataBound="dgList_ItemDataBound"
                                    OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:BoundColumn
                                            DataField="VUANID"
                                            Visible="false"></asp:BoundColumn>
                                        <%-- Mã vụ án --%>
                                        <asp:BoundColumn
                                            DataField="MaVuAn"
                                            Visible="false"
                                            HeaderText="Mã vụ án"></asp:BoundColumn>
                                        <%-- Tên vụ án --%>
                                        <asp:BoundColumn
                                            DataField="TenVuAn"
                                            HeaderText="Tên vụ án"
                                            Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("TT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                                            <HeaderTemplate>Chọn vụ án</HeaderTemplate>
                                            <%--<ItemTemplate>
                                                <asp:Button ID="cmdChitiet" runat="server" Text="Chọn bị án"
                                                    CssClass="buttonchitiet" CausesValidation="false"
                                                    CommandArgument='<%# Eval("BiAnID") +"$"+ Eval("IDVuAnHeThong")%>'
                                                    CommandName="ThuLyAn" />
                                            </ItemTemplate>--%>
                                            <ItemTemplate>
                                                <asp:CheckBox
                                                    ID="chkChon"
                                                    Visible='<%# !IsDisabledStatus(Eval("trangthai")) %>'
                                                    AutoPostBack="true"
                                                    ToolTip='<%# IsRbTrangthai() ? Eval("MAPPINGID") : Eval("VUANID")%>'
                                                    OnCheckedChanged="chkChon_CheckedChanged"
                                                    runat="server" />

                                                <asp:HiddenField
                                                    ID="hddTHGiaoNhan"
                                                    runat="server"
                                                    Value="" />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Mã bị án</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Eval("MaBiAn") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Bị án</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Eval("TenBian") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Mã vụ án</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Eval("MaVuAn") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tên vụ án</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Eval("TenVuAn") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Số bản án</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Eval("SoBanAn") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%-- Ngày bản án --%>
                                        <asp:BoundColumn
                                            DataField="NGAYBANAN"
                                            HeaderText="Ngày bản án"
                                            HeaderStyle-Width="100px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center"
                                            DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Tình trạng GQ</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Eval("TINHTRANGGQ") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%-- Toà nhận vụ việc --%>
                                        <asp:BoundColumn
                                            DataField="toanhan"
                                            HeaderText="Tòa nhận"
                                            HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="150px"></asp:BoundColumn>

                                        <%-- Nội dung --%>
                                        <asp:BoundColumn
                                            DataField="lydoTen"
                                            HeaderText="Nội dung"
                                            HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="150px"></asp:BoundColumn>
                                        <%-- Ngày bàn giao án --%>
                                        <asp:BoundColumn
                                            DataField="thoigianbangiao"
                                            HeaderText="Ngày bàn giao"
                                            HeaderStyle-Width="60px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <%-- Trạng thái --%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="60px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Trạng thái</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# GetStatusStr(Eval("trangthai")) %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%-- Button huỷ bàn giao án --%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="85px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton
                                                    ID="lbtHuyChuyen"
                                                    runat="server"
                                                    ForeColor="#0e7eee"
                                                    CausesValidation="false"
                                                    Text="Hủy bàn giao án"
                                                    CommandName="HuyChuyen"
                                                    CommandArgument='<%#Eval("MAPPINGID") %>'
                                                    Style='<%# IsDisabledStatus(Eval("trangthai")) ? "display: none;": "" %>'
                                                    OnClientClick="return confirm('Bạn thực sự muốn hủy bàn giao án này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <!-- Số bản ghi -->
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>

                                    <!-- Số trang hiện có -->
                                    <div class="sotrang">
                                        <asp:LinkButton
                                            ID="lbBBack"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbBFirst"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="active"
                                            Text="1"
                                            OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label
                                            ID="lbBStep1"
                                            runat="server"
                                            Text="..."></asp:Label>
                                        <asp:LinkButton
                                            ID="lbBStep2"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="2"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbBStep3"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="3"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbBStep4"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="4"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbBStep5"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="5"
                                            OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label
                                            ID="lbBStep6"
                                            runat="server"
                                            Text="..."></asp:Label>
                                        <asp:LinkButton
                                            ID="lbBLast"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="so"
                                            Text="100"
                                            OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton
                                            ID="lbBNext"
                                            runat="server"
                                            CausesValidation="false"
                                            CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnCapnhat" runat="server" Visible="false">
        <!-- Thông tin bàn giao -->
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung">Chuyển án sáp nhập</h4>
                    <div class="boder" style="padding: 10px">
                        <!-- ToaAnGiaoId -->
                        <asp:HiddenField ID="hddToaAnGiaoId" runat="server" />
                        <!-- NguoiGiaoId -->
                        <asp:HiddenField ID="hddNguoiGiaoId" runat="server" />

                        <table class="table1">
                            <tr>
                                <!-- Toà chuyển -->
                                <td>Tòa chuyển
                                </td>
                                <td>
                                    <asp:HiddenField
                                        ID="HiddenField1"
                                        Value='<%# Eval("TOAANGIAOID") %>'
                                        runat="server" />

                                    <asp:TextBox ID="txtTOAANGIAO" CssClass="user"
                                        runat="server" Enabled="false" Width="250px"></asp:TextBox>
                                </td>
                                <!-- Người chuyển -->
                                <td style="width: 110px">Người chuyển
                                </td>
                                <td>
                                    <asp:HiddenField
                                        ID="HiddenField2"
                                        Value='<%# Eval("NGUOIGIAOID") %>'
                                        runat="server" />

                                    <asp:TextBox ID="txtNGUOIGIAO" CssClass="user"
                                        runat="server" Enabled="false" Width="250px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <!-- Ngày chuyển -->
                                <td style="width: 110px">Ngày chuyển<span class="must_input">(*)</span>
                                </td>
                                <td style="width: 140px">
                                    <asp:TextBox
                                        ID="tbFNgayGiao"
                                        runat="server"
                                        CssClass="user"
                                        Width="250px"
                                        MaxLength="10"
                                        Text='<%# Eval("NgayGiao") %>'></asp:TextBox>
                                    <cc1:CalendarExtender
                                        ID="CalendarExtender_NgayGiao"
                                        runat="server"
                                        TargetControlID="tbFNgayGiao"
                                        Format="dd/MM/yyyy"
                                        Enabled="true" />
                                    <cc1:MaskedEditExtender
                                        ID="MaskedEditExtender_NgayGiao"
                                        runat="server"
                                        TargetControlID="tbFNgayGiao"
                                        Mask="99/99/9999"
                                        MaskType="Date"
                                        CultureName="vi-VN"
                                        ErrorTooltipEnabled="true" />
                                </td>

                                <!-- Toà án nhận -->
                                <td style="width: 110px">Tòa án nhận<span class="must_input">(*)</span>
                                </td>
                                <td>
                                    <asp:HiddenField
                                        ID="hddToaAnNhanId"
                                        Value='<%# Eval("ToaAnNhanId") %>'
                                        runat="server" />

                                    <asp:DropDownList
                                        ID="dropToaAnNhan"
                                        CssClass="chosen-select"
                                        runat="server"
                                        Width="258px">
                                        <asp:ListItem Value="0" Selected="True">Tất cả</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <!-- Quyết định chuyển -->
                                <td>Quyết định chuyển</td>
                                <td>
                                    <asp:CheckBox
                                        ID="cbFQuyetDinhChuyen"
                                        runat="server"
                                        Font-Bold="true"
                                        AutoPostBack="true"
                                        OnCheckedChanged="cbFQuyetDinhChuyen_CheckedChanged" />
                                </td>

                                <!-- Số quyết định -->
                                <td>Số quyết định</td>
                                <td>
                                    <asp:TextBox
                                        ID="tbFSoQuyetDinh"
                                        CssClass="user"
                                        runat="server"
                                        Width="250px"
                                        Value='<%# Eval("SoQuyetDinh") %>'></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <!-- Ngày quyết định -->
                                <td>Ngày quyết định</td>
                                <td>
                                    <asp:TextBox
                                        ID="tbFNgayQuyetDinh"
                                        runat="server"
                                        CssClass="user"
                                        Width="250px"
                                        MaxLength="10"
                                        Text='<%# Eval("NgayQuyetDinh") %>'></asp:TextBox>
                                    <cc1:CalendarExtender
                                        ID="CalendarExtender2"
                                        runat="server"
                                        TargetControlID="tbFNgayQuyetDinh"
                                        Format="dd/MM/yyyy"
                                        Enabled="true" />
                                    <cc1:MaskedEditExtender
                                        ID="MaskedEditExtender3"
                                        runat="server"
                                        TargetControlID="tbFNgayQuyetDinh"
                                        Mask="99/99/9999"
                                        MaskType="Date"
                                        CultureName="vi-VN"
                                        ErrorTooltipEnabled="true" />
                                </td>
                                <!-- Người ký -->
                                <td>Người ký</td>
                                <td>
                                    <asp:HiddenField
                                        ID="HiddenField3"
                                        Value='<%# Eval("NGUOIKY") %>'
                                        runat="server" />
                                    <asp:TextBox ID="txtNGUOIKY" CssClass="user"
                                        runat="server" Width="250px" MaxLength="50"></asp:TextBox>
                                </td>

                            </tr>

                            <tr>
                                <!-- Lý do chuyển -->
                                <td>Lý do chuyển<span class="must_input">(*)</span></td>
                                <td>
                                    <asp:HiddenField
                                        ID="hddLyDoMa"
                                        Value='<%# Eval("LyDoMa") %>'
                                        runat="server" />
                                    <asp:DropDownList
                                        ID="dropLyDo"
                                        runat="server"
                                        CssClass="chosen-select"
                                        Width="258px"
                                        AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="row_center">
            <table class="table1">
                <tr>
                    <td colspan="4">
                        <asp:Label
                            runat="server"
                            ID="lbthongbaoNA"
                            ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="4">
                        <asp:Button
                            ID="cmdCapnhat"
                            runat="server"
                            CssClass="buttoninput"
                            OnClientClick="return validate();"
                            Text="Chuyển án"
                            OnClick="cmdLuu_Click" />
                        <asp:Button
                            ID="cmdQuaylai"
                            runat="server"
                            CssClass="buttoninput"
                            Text="Quay lại"
                            OnClick="cmdQuaylai_Click" />
                    </td>
                </tr>
            </table>
        </div>

        <!-- Bảng danh sách bàn giao -->
        <div style="margin-top: 15px">
            <asp:DataGrid
                ID="dgItems"
                runat="server"
                AutoGenerateColumns="False"
                CellPadding="4"
                GridLines="None"
                CssClass="table2"
                HeaderStyle-CssClass="header"
                AlternatingItemStyle-CssClass="le"
                ItemStyle-CssClass="chan"
                Width="100%"
                OnItemDataBound="dgItems_ItemDataBound">
                <Columns>
                    <asp:BoundColumn
                        DataField="VuViecId"
                        Visible="false"></asp:BoundColumn>
                    <asp:BoundColumn
                        DataField="VuViecLoai"
                        Visible="false"></asp:BoundColumn>
                    <asp:BoundColumn
                        DataField="VuViecMa"
                        HeaderText="Mã vụ án"
                        HeaderStyle-HorizontalAlign="Center"
                        HeaderStyle-Width="250px"></asp:BoundColumn>
                    <asp:BoundColumn
                        DataField="VuViecTen"
                        HeaderText="Tên vụ án"
                        HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                    <%--
          <asp:TemplateColumn
            HeaderStyle-Width="80px"
            ItemStyle-Width="80px"
            HeaderStyle-HorizontalAlign="Center"
            ItemStyle-HorizontalAlign="Center"
          >
            <HeaderTemplate>Thao tác </HeaderTemplate>
            <ItemTemplate>
              <asp:LinkButton
                ID="lbtXoaItem"
                runat="server"
                CausesValidation="false"
                Text="Xóa"
                ForeColor="#0e7eee"
                CommandName="XoaSapNhap"
                CommandArgument='<%#Eval("ID") %>'
                OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này?');"
              ></asp:LinkButton>
            </ItemTemplate> </asp:TemplateColumn
          >--%>
                </Columns>
                <HeaderStyle CssClass="header"></HeaderStyle>
                <ItemStyle CssClass="chan"></ItemStyle>
            </asp:DataGrid>
        </div>
    </asp:Panel>
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript">
        function isNumber(evt) {
            evt = evt ? evt : window.event;
            var charCode = evt.which ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function validate() {
            // Kiểm tra Ngày chuyển (bắt buộc)
            var txtNgayGiao = document.getElementById("<%=tbFNgayGiao.ClientID %>");
            if (txtNgayGiao.value.trim() == "" || txtNgayGiao.value.trim() == null) {
                alert("Bạn hãy nhập ngày chuyển!");
                txtNgayGiao.focus();
                return false;
            }

            // Kiểm tra định dạng ngày chuyển (dd/mm/yyyy)
            var ngayGiaoPattern = /^\d{2}\/\d{2}\/\d{4}$/;
            if (!ngayGiaoPattern.test(txtNgayGiao.value.trim())) {
                alert("Ngày chuyển không đúng định dạng (dd/mm/yyyy)!");
                txtNgayGiao.focus();
                return false;
            }

            // Kiểm tra ngày chuyển không được trong quá khứ
            var ngayGiaoParts = txtNgayGiao.value.trim().split("/");
            var ngayGiaoDate = new Date(
                ngayGiaoParts[2],
                ngayGiaoParts[1] - 1,
                ngayGiaoParts[0]
            );
            var today = new Date();
            today.setHours(0, 0, 0, 0); // Đặt giờ về 0 để so sánh chỉ ngày

            if (ngayGiaoDate < today) {
                alert("Ngày chuyển không được trong quá khứ!");
                txtNgayGiao.focus();
                return false;
            }

            // Kiểm tra Tòa án nhận (bắt buộc)
            var dropToaAnNhan = document.getElementById(
        "<%=dropToaAnNhan.ClientID %>"
            );
            if (
                dropToaAnNhan.value == "0" ||
                dropToaAnNhan.value == "" ||
                dropToaAnNhan.value == null
            ) {
                alert("Bạn hãy chọn tòa án nhận!");
                dropToaAnNhan.focus();
                return false;
            }

            // Kiểm tra Lý do chuyển (bắt buộc)
            var dropLyDo = document.getElementById("<%=dropLyDo.ClientID %>");
            if (dropLyDo.value == "" || dropLyDo.value == null) {
                alert("Bạn hãy chọn lý do chuyển!");
                dropLyDo.focus();
                return false;
            }

            // Kiểm tra Quyết định chuyển
            var cbQuyetDinhChuyen = document.getElementById(
        "<%=cbFQuyetDinhChuyen.ClientID %>"
            );
            if (cbQuyetDinhChuyen.checked) {
                // Nếu có quyết định chuyển thì phải nhập số quyết định và ngày quyết định
                var txtSoQuyetDinh = document.getElementById(
          "<%=tbFSoQuyetDinh.ClientID %>"
                );
                if (
                    txtSoQuyetDinh.value.trim() == "" ||
                    txtSoQuyetDinh.value.trim() == null
                ) {
                    alert("Bạn hãy nhập số quyết định!");
                    txtSoQuyetDinh.focus();
                    return false;
                }

                var txtNgayQuyetDinh = document.getElementById(
          "<%=tbFNgayQuyetDinh.ClientID %>"
            );
                if (
                    txtNgayQuyetDinh.value.trim() == "" ||
                    txtNgayQuyetDinh.value.trim() == null
                ) {
                    alert("Bạn hãy nhập ngày quyết định!");
                    txtNgayQuyetDinh.focus();
                    return false;
                }

                // Kiểm tra định dạng ngày quyết định (dd/mm/yyyy)
                var ngayQuyetDinhPattern = /^\d{2}\/\d{2}\/\d{4}$/;
                if (!ngayQuyetDinhPattern.test(txtNgayQuyetDinh.value.trim())) {
                    alert("Ngày quyết định không đúng định dạng (dd/mm/yyyy)!");
                    txtNgayQuyetDinh.focus();
                    return false;
                }

                // Kiểm tra ngày quyết định không được trong quá khứ
                var ngayQuyetDinhParts = txtNgayQuyetDinh.value.trim().split("/");
                var ngayQuyetDinhDate = new Date(
                    ngayQuyetDinhParts[2],
                    ngayQuyetDinhParts[1] - 1,
                    ngayQuyetDinhParts[0]
                );

                if (ngayQuyetDinhDate < today) {
                    alert("Ngày quyết định không được trong quá khứ!");
                    txtNgayQuyetDinh.focus();
                    return false;
                }
            }

            return true;
        }
    </script>
    <style>
        #dvSpliter_1_CC {
            overflow: unset;
        }
    </style>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () { });
            var config = {
                ".chosen-select": {},
                ".chosen-select-deselect": { allow_single_deselect: true },
                ".chosen-select-no-single": { disable_search_threshold: 10 },
                ".chosen-select-no-results": {
                    no_results_text: "Oops, nothing found!",
                },
                ".chosen-select-rtl": { rtl: true },
                ".chosen-select-width": { width: "95%" },
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        }
    </script>
</asp:Content>

