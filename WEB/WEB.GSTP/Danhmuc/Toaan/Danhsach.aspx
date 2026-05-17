<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs"
    Inherits="WEB.GSTP.Danhmuc.Toaan.Danhsach" %>

<%@ Register
    Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content
    ID="Content2"
    ContentPlaceHolderID="ContentPlaceHolder1"
    runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="80" runat="server" />
    <style type="text/css">
        .btnTimKiemCss {
            margin-left: 5px;
        }

        /* CSS tùy chỉnh cho form */

        /* CSS cho dropdown items bị disable */
        select option[data-disabled="true"] {
            color: #999999 !important;
            font-style: italic !important;
            cursor: not-allowed !important;
            background-color: #f5f5f5 !important;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td
                            style="width: 30%; vertical-align: top; border-right: 1px solid #ccc;">
                            <div>
                                <%-- Filter hiệu lực--%>
                                <asp:RadioButtonList ID="rbFilterHieuLuc" runat="server" Width="100%" RepeatDirection="Horizontal" CellPadding="5" OnSelectedIndexChanged="rbFilterHieuLuc_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Text="Tất cả" Value="-1"></asp:ListItem>
                                    <asp:ListItem Text="Có hiệu lực" Selected="True" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Hết hiệu lực" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>

                                <%-- Tree Menu --%>
                                <asp:TreeView
                                    ID="treemenu"
                                    runat="server"
                                    NodeWrap="True"
                                    ShowLines="True"
                                    OnSelectedNodeChanged="treemenu_SelectedNodeChanged"
                                    EnableClientScript="true">
                                    <NodeStyle
                                        ImageUrl="../../UI/img/folder.gif"
                                        HorizontalPadding="3"
                                        Width="100%"
                                        CssClass="tree_menu"
                                        VerticalPadding="3px" />
                                    <ParentNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <RootNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <SelectedNodeStyle Font-Bold="True" />
                                </asp:TreeView>
                            </div>
                        </td>
                        <td style="width: 70%; vertical-align: top; text-align: left">
                            <table style="width: 100%; padding: 3px; border-spacing: 3px">
                                <tr>
                                    <!-- Button Thêm mới -->
                                    <td colspan="2" style="text-align: left">
                                        <asp:Button
                                            ID="btnNew"
                                            runat="server"
                                            CssClass="buttoninput"
                                            Text="Thêm mới"
                                            OnClick="btnNew_Click" />
                                    </td>
                                    <!-- / Button Thêm mới -->
                                </tr>
                                <tr>
                                    <!-- Mã toà án -->
                                    <td style="width: 120px">
                                        <b>Mã tòa án</b><asp:Label
                                            runat="server"
                                            ID="nhap"
                                            Text="(*)"
                                            ForeColor="Red"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox
                                            ID="txtMa"
                                            CssClass="user"
                                            runat="server"
                                            Width="200px"
                                            MaxLength="50"></asp:TextBox>
                                    </td>
                                    <!-- / Mã toà án -->
                                </tr>
                                <tr>
                                    <!-- Tên toà án -->
                                    <td>
                                        <b>Tên tòa án</b><asp:Label
                                            runat="server"
                                            ID="Label2"
                                            Text="(*)"
                                            ForeColor="Red"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox
                                            ID="txtTen"
                                            CssClass="user"
                                            runat="server"
                                            Width="100%"
                                            MaxLength="250"></asp:TextBox>
                                    </td>
                                    <!-- / Tên toà án -->
                                </tr>
                                <tr>
                                    <!-- Select box toà án cấp trên -->
                                    <td><b>Tòa án cấp trên</b></td>
                                    <td>
                                        <asp:DropDownList
                                            CssClass="chosen-select"
                                            ID="dropParent"
                                            runat="server"
                                            Width="300px"
                                            OnSelectedIndexChanged="dropParent_SelectedIndexChanged"
                                            AutoPostBack="true">
                                        </asp:DropDownList>
                                    </td>
                                    <!-- / Select box toà án cấp trên -->
                                </tr>
                                <tr>
                                    <!-- Select box loại toà án -->
                                    <td><b>Loại tòa án</b></td>
                                    <td>
                                        <asp:DropDownList
                                            CssClass="chosen-select"
                                            ID="dropLoaiToaAn"
                                            runat="server"
                                            Width="300px">
                                        </asp:DropDownList>
                                    </td>
                                    <!-- / Select box loại toà án -->
                                </tr>
                                <tr>
                                    <!-- Đơn vị hành chính -->
                                    <td>
                                        <b>Đơn vị hành chính</b><asp:Label
                                            runat="server"
                                            ID="Label1"
                                            Text="(*)"
                                            ForeColor="Red"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="hddDonViHanhChinh" runat="server" />
                                        <a alt="Nhập tên hành chính để chọn" class="tooltipleft">
                                            <asp:TextBox
                                                ID="txtDonViHanhChinh"
                                                CssClass="user"
                                                runat="server"
                                                Width="100%"
                                                MaxLength="250"></asp:TextBox>
                                        </a>
                                    </td>
                                    <!-- / Đơn vị hành chính -->
                                </tr>
                                <tr>
                                    <!-- Địa chỉ chi tiết -->
                                    <td><b>Địa chỉ chi tiết</b></td>
                                    <td>
                                        <asp:TextBox
                                            ID="txtDiaChi"
                                            CssClass="user"
                                            runat="server"
                                            Width="100%"></asp:TextBox>
                                    </td>
                                    <!-- / Địa chỉ chi tiết -->
                                </tr>
                                <tr>
                                    <!-- Điện thoại, Fax, Email -->
                                    <td><b>Điện thoại</b></td>
                                    <td>
                                        <asp:TextBox
                                            ID="txtDienThoai"
                                            CssClass="user"
                                            runat="server"
                                            Width="120px"></asp:TextBox>
                                        <span style="font-weight: bold; margin: 0px 5px 0px 10px">Fax</span>
                                        <asp:TextBox
                                            ID="txtFax"
                                            CssClass="user"
                                            runat="server"
                                            Width="120px"></asp:TextBox>
                                        <span style="font-weight: bold; margin: 0px 5px 0px 10px">Email</span>
                                        <asp:TextBox
                                            ID="txtEmail"
                                            CssClass="user"
                                            runat="server"
                                            Width="180px"></asp:TextBox>
                                    </td>
                                    <!-- / Điện thoại, Fax, Email -->
                                </tr>
                                <tr>
                                    <!-- Thứ tự -->
                                    <td>
                                        <b>Thứ tự</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList
                                            CssClass="user"
                                            ID="dropThuTu"
                                            runat="server"
                                            Width="71px">
                                        </asp:DropDownList>
                                    </td>
                                    <!-- / Thứ tự -->
                                </tr>
                                <tr>
                                    <!-- Hiệu lực -->
                                    <td>
                                        <b>Hiệu lực</b>
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" class="check" runat="server" />
                                    </td>
                                    <!-- / Hiệu lực -->
                                </tr>
                                <tr>
                                    <!-- Tên cơ quan thi hành án tương ứng -->
                                    <td>Tên cơ quan thi hành án tương ứng</td>
                                    <td>
                                        <asp:TextBox
                                            ID="txtTenCQTHA"
                                            CssClass="user"
                                            runat="server"
                                            Width="100%"
                                            MaxLength="250"></asp:TextBox>
                                    </td>
                                    <!-- / Tên cơ quan thi hành án tương ứng -->
                                </tr>
                                <tr>
                                    <!-- Địa chỉ -->
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:TextBox
                                            ID="txtDiachiCQTHA"
                                            CssClass="user"
                                            runat="server"
                                            Width="100%"
                                            MaxLength="250"></asp:TextBox>
                                    </td>
                                    <!-- / Địa chỉ -->
                                </tr>
                                <tr>
                                    <!-- Checkbox Nhận đơn khởi kiện trực tuyến -->
                                    <td>Nhận đơn khởi kiện trực tuyến</td>
                                    <td>
                                        <asp:RadioButtonList
                                            ID="rdNhanDKKOnline"
                                            runat="server"
                                            RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0" Selected="True">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                    <!-- / Checkbox Nhận đơn khởi kiện trực tuyến -->
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <!-- Button Save, Delete, Refresh -->
                                        <asp:Button
                                            ID="cmdUpdate"
                                            runat="server"
                                            CssClass="buttoninput"
                                            Text="Lưu"
                                            OnClick="btnUpdate_Click"
                                            OnClientClick="return ValidateDataInput();" />
                                        <asp:Button
                                            ID="cmdDel"
                                            runat="server"
                                            CssClass="buttoninput"
                                            Text="Xóa"
                                            OnClick="btnDel_Click"
                                            OnClientClick="return confirm('Bạn chắc chắn muốn xóa ?');" />
                                        <asp:Button
                                            ID="cmdLammoi"
                                            runat="server"
                                            CssClass="buttoninput"
                                            Text="Làm mới"
                                            OnClick="btnLammoi_Click" />
                                        <!-- / Button Save, Delete, Refresh -->
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <asp:HiddenField
                                                ID="hddToaAnID"
                                                runat="server"
                                                Value="0" />
                                            <asp:Label
                                                runat="server"
                                                ID="lbthongbao"
                                                ForeColor="Red"></asp:Label>
                                        </div>
                                        <!-- Search Toà án -->
                                        <table
                                            style="width: 300px; margin-top: 10px; border-spacing: 5px;">
                                            <tr>
                                                <td style="width: 150px">
                                                    <asp:TextBox
                                                        runat="server"
                                                        ID="txttimkiem"
                                                        Width="100%"
                                                        CssClass="user"
                                                        placeholder="Mã, tên tòa án"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Button
                                                        ID="Btntimkiem"
                                                        runat="server"
                                                        CssClass="buttoninput btnTimKiemCss"
                                                        Text="Tìm kiếm"
                                                        OnClick="Btntimkiem_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- / Search Toà án -->
                                        <asp:Panel runat="server" ID="pndata">
                                            <!-- Phân trang -->
                                            <div class="phantrang">
                                                <div class="sobanghi">
                                                    <asp:Literal
                                                        ID="lstSobanghiT"
                                                        runat="server"></asp:Literal>
                                                </div>
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
                                            <!-- / Phân trang -->

                                            <!-- Datagrid -->
                                            <asp:DataGrid
                                                ID="dgList"
                                                runat="server"
                                                AutoGenerateColumns="False"
                                                CellPadding="4"
                                                AllowPaging="True"
                                                GridLines="None"
                                                PagerStyle-Mode="NumericPages"
                                                CssClass="table2"
                                                HeaderStyle-CssClass="header"
                                                AlternatingItemStyle-CssClass="le"
                                                ItemStyle-CssClass="chan"
                                                Width="100%"
                                                OnItemCommand="dgList_ItemCommand"
                                                OnItemDataBound="dgList_ItemDataBound">
                                                <Columns>
                                                    <%-- ID --%>
                                                    <asp:BoundColumn
                                                        DataField="Id"
                                                        Visible="false"></asp:BoundColumn>

                                                    <%-- Thứ tự --%>
                                                    <asp:TemplateColumn
                                                        HeaderStyle-Width="40px"
                                                        ItemStyle-Width="40px"
                                                        HeaderStyle-HorizontalAlign="Center"
                                                        ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>Thứ tự </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList
                                                                CssClass="user"
                                                                ID="DropThuTuChildren"
                                                                runat="server"
                                                                Width="98%">
                                                            </asp:DropDownList>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>

                                                    <%-- Mã --%>
                                                    <asp:TemplateColumn
                                                        HeaderStyle-Width="150px"
                                                        ItemStyle-Width="150px"
                                                        HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>Mã </HeaderTemplate>
                                                        <ItemTemplate><%#Eval("MA")%> </ItemTemplate>
                                                    </asp:TemplateColumn>

                                                    <%-- Tên toà án --%>
                                                    <asp:TemplateColumn
                                                        HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>Tên tòa án </HeaderTemplate>
                                                        <ItemTemplate><%#Eval("TEN") %> </ItemTemplate>
                                                    </asp:TemplateColumn>

                                                    <%-- Thao tác --%>
                                                    <asp:TemplateColumn
                                                        HeaderStyle-Width="80px"
                                                        ItemStyle-Width="80px"
                                                        HeaderStyle-HorizontalAlign="Center"
                                                        ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>Thao tác </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:LinkButton
                                                                ID="lbtSua"
                                                                runat="server"
                                                                Text="Sửa"
                                                                CausesValidation="false"
                                                                CommandName="Sua"
                                                                ForeColor="#0e7eee"
                                                                CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                            &nbsp;&nbsp;<asp:LinkButton
                                                                ID="lbtXoa"
                                                                runat="server"
                                                                CausesValidation="false"
                                                                Text="Xóa"
                                                                ForeColor="#0e7eee"
                                                                CommandName="Xoa"
                                                                CommandArgument='<%#Eval("ID") %>'
                                                                ToolTip="Xóa"
                                                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <HeaderStyle CssClass="header"></HeaderStyle>
                                                <ItemStyle CssClass="chan"></ItemStyle>
                                                <PagerStyle Visible="false"></PagerStyle>
                                            </asp:DataGrid>
                                            <!-- / Datagrid -->

                                            <!-- Phân trang -->
                                            <div class="phantrang">
                                                <div class="sobanghi">
                                                    <asp:HiddenField ID="hdicha" runat="server" />
                                                    <asp:Literal
                                                        ID="lstSobanghiB"
                                                        runat="server"></asp:Literal>
                                                </div>
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
                                            <!-- / Phân trang -->

                                            <!-- Lưu thứ tự -->
                                            <div
                                                style="float: left; margin-top: 6px"
                                                runat="server"
                                                id="div_Order">
                                                <asp:Button
                                                    ID="cmdThutu"
                                                    runat="server"
                                                    CssClass="buttoninput"
                                                    Text="Lưu thứ tự"
                                                    OnClick="cmdThutu_Click" />
                                            </div>
                                            <!-- / Lưu thứ tự -->
                                        </asp:Panel>
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <!-- Quản lý sáp nhập tòa án - Chỉ hiển thị khi chọn tòa án -->
                                        <div
                                            id="divSapNhapToaAn"
                                            runat="server"
                                            visible="false"
                                            style="clear: both; margin-top: 2rem; padding: 15px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9;">
                                            <h3 style="margin-top: 0; color: #c41e3a">Quản lý sáp nhập tòa án
                                            </h3>
                                            <table style="width: 100%; border-spacing: 5px">
                                                <tr>
                                                    <!-- Loại sáp nhập -->
                                                    <td style="width: 300px">
                                                        <b>Loại sáp nhập</b>
                                                        <span style="color: red">(*)</span>
                                                    </td>
                                                    <td style="width: 300px">
                                                        <asp:DropDownList
                                                            ID="dropLoaiSapNhap"
                                                            runat="server"
                                                            CssClass="chosen-select"
                                                            Width="280px"
                                                            AutoPostBack="true"
                                                            OnSelectedIndexChanged="dropLoaiSapNhap_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <!-- / Loại sáp nhập -->

                                                    <!-- Ngày bắt đầu hiệu lực -->
                                                    <td>
                                                        <b>Ngày bắt đầu hiệu lực</b>
                                                        <span style="color: red">(*)</span>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox
                                                            ID="txtNgayBatDauHieuLuc"
                                                            runat="server"
                                                            CssClass="user"
                                                            Width="100%"
                                                            MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender
                                                            ID="CalendarExtender_NgayBatDau"
                                                            runat="server"
                                                            TargetControlID="txtNgayBatDauHieuLuc"
                                                            Format="dd/MM/yyyy"
                                                            Enabled="true" />
                                                        <cc1:MaskedEditExtender
                                                            ID="MaskedEditExtender_NgayBatDau"
                                                            runat="server"
                                                            TargetControlID="txtNgayBatDauHieuLuc"
                                                            Mask="99/99/9999"
                                                            MaskType="Date"
                                                            CultureName="vi-VN"
                                                            ErrorTooltipEnabled="true" />
                                                    </td>
                                                    <!-- / Ngày bắt đầu hiệu lực -->
                                                </tr>

                                                <tr>
                                                    <!-- Đơn vị mục tiêu -->
                                                    <td>
                                                        <asp:Label ID="lblDonViMucTieu" runat="server" Font-Bold="true">
                                                            <span style="color: red">(*)</span>
                                                        </asp:Label>
                                                        <span style="color: red">(*)</span>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList
                                                            ID="dropDonViMucTieu"
                                                            runat="server"
                                                            CssClass="chosen-select"
                                                            Width="280px">
                                                            <asp:ListItem
                                                                Value="0"
                                                                Text="-- Chọn toà án --"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <!-- / Đơn vị mục tiêu -->

                                                    <!-- Ghi chú -->
                                                    <td>
                                                        <b>Ghi chú</b>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox
                                                            ID="tbGhiChu"
                                                            CssClass="user"
                                                            runat="server"
                                                            Width="100%"></asp:TextBox>
                                                    </td>
                                                    <!-- / Ghi chú -->
                                                </tr>

                                                <tr>
                                                    <td></td>
                                                    <td colspan="3">
                                                        <asp:HiddenField
                                                            ID="hddSapNhapID"
                                                            runat="server"
                                                            Value="0" />
                                                        <asp:Button
                                                            ID="btnLuuSapNhap"
                                                            runat="server"
                                                            CssClass="buttoninput"
                                                            Text="Lưu"
                                                            OnClick="btnLuuSapNhap_Click"
                                                            OnClientClick="return ValidateSapNhapInput();" />
                                                        <asp:Button
                                                            ID="btnLamMoiSapNhap"
                                                            runat="server"
                                                            CssClass="buttoninput"
                                                            Text="Làm mới"
                                                            OnClick="btnLamMoiSapNhap_Click" />
                                                        <asp:Label
                                                            ID="lblThongBaoSapNhap"
                                                            runat="server"
                                                            ForeColor="Red"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>

                                            <!-- Bảng danh sách sáp nhập -->
                                            <div style="margin-top: 15px">
                                                <asp:DataGrid
                                                    ID="dgSapNhap"
                                                    runat="server"
                                                    AutoGenerateColumns="False"
                                                    CellPadding="4"
                                                    GridLines="None"
                                                    CssClass="table2"
                                                    HeaderStyle-CssClass="header"
                                                    AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan"
                                                    Width="100%"
                                                    OnItemCommand="dgSapNhap_ItemCommand"
                                                    OnItemDataBound="dgSapNhap_ItemDataBound">
                                                    <Columns>
                                                        <asp:BoundColumn
                                                            DataField="ID"
                                                            Visible="false"></asp:BoundColumn>
                                                         <asp:BoundColumn
                                                            DataField="TOAANID"
                                                            Visible="false"></asp:BoundColumn>
                                                        <asp:BoundColumn
                                                            DataField="TOTOAANID"
                                                            Visible="false"></asp:BoundColumn>
                                                        <asp:BoundColumn
                                                            DataField="LOAI"
                                                            Visible="false"></asp:BoundColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-Width="150px"
                                                            ItemStyle-Width="150px"
                                                            HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Ngày bắt đầu hiệu lực
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("NGAYHIEULUC") != DBNull.Value && Eval("NGAYHIEULUC") != null ? Convert.ToDateTime(Eval("NGAYHIEULUC")).ToString("dd/MM/yyyy"):"" %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Loại </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("LOAITEN") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Nội dung</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Eval("LOAI").ToString() == "NHAP" 
                                                                        ? (Eval("TOAANID").ToString() == hddToaAnID.Value.ToString() 
                                                                            ? "Nhập vào " + Eval("TOTOAANTEN")
                                                                            : "Nhập từ " + Eval("TOAANTEN"))
                                                                        : (Eval("LOAI").ToString() == "TACH" 
                                                                            ?(Eval("TOAANID").ToString() == hddToaAnID.Value.ToString() 
                                                                                ? "Tách ra " + Eval("TOTOAANTEN")
                                                                                : "Tách từ " + Eval("TOAANTEN"))
                                                                            : ""
                                                                        )
                                                                %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn
                                                            HeaderStyle-Width="80px"
                                                            ItemStyle-Width="80px"
                                                            HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Thao tác </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton
                                                                    ID="lbtSuaSapNhap"
                                                                    runat="server"
                                                                    Text="Sửa"
                                                                    CausesValidation="false"
                                                                    CommandName="SuaSapNhap"
                                                                    ForeColor="#0e7eee"
                                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                &nbsp;&nbsp;
                                <asp:LinkButton
                                    ID="lbtXoaSapNhap"
                                    runat="server"
                                    CausesValidation="false"
                                    Text="Xóa"
                                    ForeColor="#0e7eee"
                                    CommandName="XoaSapNhap"
                                    CommandArgument='<%#Eval("ID") %>'
                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này?');"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                </asp:DataGrid>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        // Validate cho dữ liệu
        function ValidateDataInput() {
            // Kiểm tra mã toà án (bắt buộc)
            var txtMaControl = document.getElementById("<%=txtMa.ClientID %>");
            if (
                txtMaControl.value.trim() == "" ||
                txtMaControl.value.trim() == null
            ) {
                alert("Bạn hãy nhập mã tòa án!");
                txtMaControl.focus();
                return false;
            } else if (txtMaControl.value.trim().length > 50) {
                alert("Mã tòa án không được quá 50 ký tự. Hãy nhập lại!");
                txtMaControl.focus();
                return false;
            }

            // Kiểm tra tên toà án (bắt buộc)
            var txtTenControl = document.getElementById("<%=txtTen.ClientID %>");
            if (
                txtTenControl.value.trim() == "" ||
                txtTenControl.value.trim() == null
            ) {
                alert("Bạn hãy nhập tên tòa án!");
                txtTenControl.focus();
                return false;
            } else if (txtTenControl.value.trim().length > 250) {
                alert("Tên tòa án không được quá 250 ký tự. Hãy nhập lại!");
                txtTenControl.focus();
                return false;
            }

            // Kiểm tra địa chỉ
            var txtDiaChi = document.getElementById("<%=txtDiaChi.ClientID %>");
            if (txtDiaChi.value.trim().length > 250) {
                alert("Địa chỉ không được quá 250 ký tự. Hãy nhập lại!");
                txtDiaChi.focus();
                return false;
            }

            // Kiểm tra số điện thoại
            var txtDienThoai = document.getElementById("<%=txtDienThoai.ClientID %>");
            if (txtDienThoai.value.trim().length > 250) {
                alert("Điện thoại không được quá 250 ký tự. Hãy nhập lại!");
                txtDienThoai.focus();
                return false;
            }

            // Kiểm tra fax
            var txtFax = document.getElementById("<%=txtFax.ClientID %>");
            if (txtFax.value.trim().length > 150) {
                alert("Fax không được quá 150 ký tự. Hãy nhập lại!");
                txtFax.focus();
                return false;
            }

            // Kiểm tra email
            var txtEmail = document.getElementById("<%=txtEmail.ClientID %>");
            if (txtEmail.value.trim().length > 150) {
                alert("Email không được quá 150 ký tự. Hãy nhập lại!");
                txtEmail.focus();
                return false;
            }
            return true;
        }

        // Validation cho form Quản lý sáp nhập tòa án
        function ValidateSapNhapInput() {

            // Kiểm tra Loại sáp nhập (bắt buộc)
            var dropLoaiSapNhap = document.getElementById("<%=dropLoaiSapNhap.ClientID %>");
            if (
                dropLoaiSapNhap.value == "" ||
                dropLoaiSapNhap.value == null
            ) {
                alert("Bạn hãy chọn loại sáp nhập!");
                dropLoaiSapNhap.focus();
                return false;
            }

            // Kiểm tra Đơn vị mục tiêu (bắt buộc)
            var dropDonViMucTieu = document.getElementById("<%=dropDonViMucTieu.ClientID %>");
            var lblDonViMucTieu = document.getElementById("<%=lblDonViMucTieu.ClientID %>");
            if (
                dropDonViMucTieu.value == "0" ||
                dropDonViMucTieu.value == "" ||
                dropDonViMucTieu.value == null
            ) {
                alert("Bạn hãy chọn " + lblDonViMucTieu.innerText + " !");
                dropDonViMucTieu.focus();
                return false;
            }

            // Kiểm tra xem có chọn item bị disable không (item không hiệu lực)
            var selectedOption =
                dropDonViMucTieu.options[dropDonViMucTieu.selectedIndex];
            if (
                selectedOption &&
                (selectedOption.getAttribute("data-disabled") === "true" ||
                    selectedOption.disabled)
            ) {
                alert("Bạn không thể chọn tòa án không hiệu lực!");
                dropDonViMucTieu.focus();
                return false;
            }

            // Kiểm tra Ngày bắt đầu hiệu lực (bắt buộc)
            var txtNgayBatDau = document.getElementById("<%=txtNgayBatDauHieuLuc.ClientID %>");
            if (
                txtNgayBatDau.value.trim() == "" ||
                txtNgayBatDau.value.trim() == null
            ) {
                alert("Bạn hãy chọn ngày bắt đầu hiệu lực!");
                txtNgayBatDau.focus();
                return false;
            }

            // Kiểm tra định dạng ngày bắt đầu (dd/mm/yyyy)
            var ngayBatDauPattern = /^\d{2}\/\d{2}\/\d{4}$/;
            if (!ngayBatDauPattern.test(txtNgayBatDau.value.trim())) {
                alert("Ngày bắt đầu hiệu lực không đúng định dạng (dd/mm/yyyy)!");
                txtNgayBatDau.focus();
                return false;
            }
        }

        function pageLoad(sender, args) {
            // Ngăn chọn item disabled trong dropdown
            $(document).on("change", "#<%=dropDonViMucTieu.ClientID %>", function () {
                var selectedOption = this.options[this.selectedIndex];
                if (
                    selectedOption &&
                    selectedOption.getAttribute("data-disabled") === "true"
                ) {
                    alert("Bạn không thể chọn tòa án không hiệu lực!");
                    this.selectedIndex = 0; // Reset về option đầu tiên
                }
            });

            $(function () {
                var urldmHanhchinh =
          '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';
                $("[id$=txtDonViHanhChinh]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh,
                            data: "{ 'q': '" + request.term + "'}",
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (data) {
                                response(
                                    $.map(data.d, function (item) {
                                        return {
                                            label: item.split("_")[1],
                                            val: item.split("_")[0],
                                        };
                                    })
                                );
                            },
                            error: function (response) { },
                            failure: function (response) { },
                        });
                    },
                    select: function (e, i) {
                        $("[id$=hddDonViHanhChinh]").val(i.item.val);
                    },
                    minLength: 1,
                });

                // Đã chuyển sang sử dụng AjaxControlToolkit CalendarExtender
                // thay vì jQuery UI Datepicker để đồng nhất với các trang khác
            });

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
