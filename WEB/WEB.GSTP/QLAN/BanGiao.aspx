<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="BanGiao.aspx.cs"
    Inherits="WEB.GSTP.QLAN.BanGiao" %>

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
                            <td>
                                <!-- Form nhập thông tin tìm kiếm vụ án -->
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm vụ án</h4>
                                    <div class="boder" style="padding: 10px">
                                        <table class="table1">
                                            <!-- Loại án -->
                                            <tr>
                                                <td style="width: 105px">Loại án</td>
                                                <td colspan="3">
                                                    <asp:DropDownList
                                                        ID="ddlLoaiAn"
                                                        CssClass="chosen-select"
                                                        runat="server"
                                                        Width="250px"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>

                                            <!-- Mã vụ việc -->
                                            <tr>
                                                <td style="width: 105px">Mã vụ việc</td>
                                                <td style="width: 260px">
                                                    <asp:TextBox
                                                        ID="txtMaVuViec"
                                                        CssClass="user"
                                                        runat="server"
                                                        Width="242px"
                                                        MaxLength="50"></asp:TextBox>
                                                </td>
                                                <td style="width: 90px">Tên vụ án</td>
                                                <td>
                                                    <asp:TextBox
                                                        ID="txtTenVuViec"
                                                        CssClass="user"
                                                        runat="server"
                                                        Width="242px"
                                                        MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>

                                            <!-- Ngày thụ lý -->
                                            <tr>
                                                <td>Thụ lý từ ngày</td>
                                                <td>
                                                    <asp:TextBox
                                                        ID="txtTuNgay"
                                                        runat="server"
                                                        CssClass="user"
                                                        Width="100px"
                                                        MaxLength="10"
                                                        onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender
                                                        ID="txtNgayQuyetDinh_CalendarExtender"
                                                        runat="server"
                                                        TargetControlID="txtTuNgay"
                                                        Format="dd/MM/yyyy"
                                                        Enabled="true" />
                                                    <cc1:MaskedEditExtender
                                                        ID="MaskedEditExtender1"
                                                        runat="server"
                                                        TargetControlID="txtTuNgay"
                                                        Mask="99/99/9999"
                                                        MaskType="Date"
                                                        CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator
                                                        ID="MaskedEditValidator1"
                                                        runat="server"
                                                        ControlExtender="MaskedEditExtender1"
                                                        ControlToValidate="txtTuNgay"
                                                        InvalidValueMessage="dd/MM/yyyy"
                                                        Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox
                                                        ID="txtDenNgay"
                                                        runat="server"
                                                        CssClass="user"
                                                        Width="100px"
                                                        MaxLength="10"
                                                        onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender
                                                        ID="CalendarExtender1"
                                                        runat="server"
                                                        TargetControlID="txtDenNgay"
                                                        Format="dd/MM/yyyy"
                                                        Enabled="true" />
                                                    <cc1:MaskedEditExtender
                                                        ID="MaskedEditExtender2"
                                                        runat="server"
                                                        TargetControlID="txtDenNgay"
                                                        Mask="99/99/9999"
                                                        MaskType="Date"
                                                        CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator
                                                        ID="MaskedEditValidator2"
                                                        runat="server"
                                                        ControlExtender="MaskedEditExtender1"
                                                        ControlToValidate="txtDenNgay"
                                                        InvalidValueMessage="dd/MM/yyyy"
                                                        Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                            </tr>

                                            <!-- Trạng thái -->
                                            <tr>
                                                <!-- Trạng thái thụ lý -->
                                                <td>Tình trạng thụ lý</td>
                                                <td>
                                                    <asp:DropDownList
                                                        ID="ddlTinhTrangThuLy"
                                                        CssClass="chosen-select"
                                                        runat="server"
                                                        Width="250px"
                                                        AutoPostBack="True">
                                                        <asp:ListItem
                                                            Value=""
                                                            Text="-- Tất cả --"></asp:ListItem>
                                                        <asp:ListItem
                                                            Value="1"
                                                            Text="Đã thụ lý"></asp:ListItem>
                                                        <asp:ListItem
                                                            Value="2"
                                                            Text="Chưa thụ lý"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>

                                                <!-- Trạng thái giải quyết -->
                                                <td>Trạng thái giải quyết</td>
                                                <td>
                                                    <asp:DropDownList
                                                        ID="ddlTrangThaiGiaiQuyet"
                                                        CssClass="chosen-select"
                                                        runat="server"
                                                        Width="250px"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="ddlTrangThaiGiaiQuyet_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>

                                            <tr>
                                                <!-- Tên thẩm phán giải quyết -->
                                                <td>Thẩm phán giải quyết</td>
                                                <td>
                                                    <asp:DropDownList
                                                        ID="ddlThamphan"
                                                        CssClass="chosen-select"
                                                        runat="server"
                                                        Width="250px">
                                                    </asp:DropDownList>
                                                    <asp:HiddenField
                                                        ID="hddLoaiTK"
                                                        runat="server"
                                                        Value="" />
                                                </td>

                                                <!-- Cấp xét xử -->
                                                <td>Cấp xét xử</td>
                                                <td>
                                                    <asp:DropDownList
                                                        ID="dropCapxx"
                                                        CssClass="chosen-select"
                                                        runat="server"
                                                        Width="246px"
                                                        AutoPostBack="True"
                                                        OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
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
                                            DataField="id"
                                            Visible="false"></asp:BoundColumn>

                                        <%-- Mã vụ việc --%>
                                        <asp:BoundColumn
                                            DataField="mavuviec"
                                            Visible="false"
                                            HeaderText="Mã vụ việc"></asp:BoundColumn>

                                        <%-- Số thứ tự --%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="20px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <%-- Checkbox --%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="30px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox
                                                    ID="chkChon"
                                                    Visible='<%# !IsDisabledStatus(Eval("trangthai")) %>'
                                                    AutoPostBack="true"
                                                    ToolTip='<%# IsRbTrangthai() ? Eval("MAPPINGID") : Eval("id")%>'
                                                    OnCheckedChanged="chkChon_CheckedChanged"
                                                    runat="server" />

                                                <asp:HiddenField
                                                    ID="hddTHGiaoNhan"
                                                    runat="server"
                                                    Value="" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <%-- Tên vụ việc --%>
                                        <asp:BoundColumn
                                            DataField="tenvuviec"
                                            HeaderText="Tên vụ việc"
                                            HeaderStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="250px"></asp:BoundColumn>

                                        <%-- Ngày thụ lý --%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="80px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ngày thụ lý</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# GetNgayThuLy(Eval("TINHTRANG_GQ")) %>
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
                    <h4 class="tleboxchung">Bàn giao án sáp nhập</h4>
                    <div class="boder" style="padding: 10px">
                        <!-- ToaAnGiaoId -->
                        <asp:HiddenField ID="hddToaAnGiaoId" runat="server" />
                        <!-- NguoiGiaoId -->
                        <asp:HiddenField ID="hddNguoiGiaoId" runat="server" />

                        <table class="table1">
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
                                        Width="250px">
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
                                        Width="240px"
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
                                        Width="250px"
                                        AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <!-- Ghi chú -->
                                <td>Ghi chú</td>
                                <td colspan="3">
                                    <asp:TextBox
                                        ID="tbFGhiChu"
                                        CssClass="user"
                                        runat="server"
                                        Width="100%"
                                        Text='<%# Eval("GhiChu") %>'></asp:TextBox>
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
                        HeaderText="Mã Vụ Việc"
                        HeaderStyle-HorizontalAlign="Center"
                        HeaderStyle-Width="250px"></asp:BoundColumn>
                    <asp:BoundColumn
                        DataField="VuViecTen"
                        HeaderText="Tên Vụ Việc"
                        HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
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
