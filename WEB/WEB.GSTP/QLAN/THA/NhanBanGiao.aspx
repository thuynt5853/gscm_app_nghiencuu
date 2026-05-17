<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master"
    AutoEventWireup="true" CodeBehind="NhanBanGiao.aspx.cs"
    Inherits="WEB.GSTP.QLAN.THA.NhanBanGiao" %>

<%@ Register
    Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content
    ID="Content2"
    ContentPlaceHolderID="ContentPlaceHolder1"
    runat="server">
    <asp:Panel ID="pnDanhsach" runat="server">
        <script src="../../../../UI/js/Common.js"></script>
        <style type="text/css">
            input[type="checkbox"] {
                margin-right: 0px !important;
            }

            .duyetkcqqh {
                color: red;
            }
        </style>
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td>
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm vụ án</h4>
                                    <div class="boder" style="padding: 10px">
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
                                                <td style="width: 105px">Mã vụ án</td>
                                                <td style="width: 260px">
                                                    <asp:TextBox
                                                        ID="txtMaVuViec"
                                                        CssClass="user"
                                                        runat="server"
                                                        Width="242px"
                                                        MaxLength="50"></asp:TextBox>
                                                </td>
                                                <td style="width: 90px">Tên vụ án</td>
                                                <td style="width: 260px">
                                                    <asp:TextBox
                                                        ID="txtTenVuViec"
                                                        CssClass="user"
                                                        runat="server"
                                                        Width="242px"
                                                        MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td style="width: 90px">Trạng thái GQ</td>
                                                <td>
                                                    <asp:DropDownList
                                                            ID="ddlTrangThaiGiaiQuyet"
                                                            CssClass="chosen-select"
                                                            runat="server"
                                                            Width="250px"
                                                            AutoPostBack="True">
                                                            <asp:ListItem
                                                                Value="0"
                                                                Text="Chưa có QĐ thi hành án" Selected="True"></asp:ListItem>
                                                            <asp:ListItem
                                                                Value="1"
                                                                Text="Đã có QĐ thi hành án"></asp:ListItem>
                                                        </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 105px">Mã bị án</td>
                                                <td style="width: 260px">
                                                    <asp:TextBox
                                                        ID="txtMaBiAn"
                                                        CssClass="user"
                                                        runat="server"
                                                        Width="242px"
                                                        MaxLength="50"></asp:TextBox>
                                                </td>
                                                <td style="width: 90px">Tên bị án</td>
                                                <td style="width: 260px">
                                                    <asp:TextBox
                                                        ID="txtTenBiAn"
                                                        CssClass="user"
                                                        runat="server"
                                                        Width="242px"
                                                        MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td style="width: 90px">Số CMND</td>
                                                <td>
                                                    <asp:TextBox
                                                         ID="txtSoCMND"
                                                         CssClass="user"
                                                         runat="server"
                                                         Width="242px"
                                                         MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Số bản án</td>
                                                <td>
                                                    <asp:TextBox
                                                         ID="txtSoBanAn"
                                                         CssClass="user"
                                                         runat="server"
                                                         Width="242px"
                                                         MaxLength="250"></asp:TextBox>
                                                </td>
                                                <td>Ngày bản án</td>
                                                <td>
                                                    <asp:TextBox
                                                        ID="txtNgayBanAn"
                                                        runat="server"
                                                        CssClass="user"
                                                        Width="100px"
                                                        MaxLength="10"
                                                        onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender
                                                        ID="CalendarExtender1"
                                                        runat="server"
                                                        TargetControlID="txtNgayBanAn"
                                                        Format="dd/MM/yyyy"
                                                        Enabled="true" />
                                                    <cc1:MaskedEditExtender
                                                        ID="MaskedEditExtender2"
                                                        runat="server"
                                                        TargetControlID="txtNgayBanAn"
                                                        Mask="99/99/9999"
                                                        MaskType="Date"
                                                        CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator
                                                        ID="MaskedEditValidator2"
                                                        runat="server"
                                                        ControlExtender="MaskedEditExtender1"
                                                        ControlToValidate="txtNgayBanAn"
                                                        InvalidValueMessage="dd/MM/yyyy"
                                                        Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
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
                                                    <asp:TextBox
                                                        ID="txtTuNgay"
                                                        runat="server"
                                                        CssClass="user"
                                                        Width="100px"
                                                        MaxLength="10"
                                                        onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender
                                                        ID="CalendarExtender2"
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
                                                        ID="CalendarExtender3"
                                                        runat="server"
                                                        TargetControlID="txtDenNgay"
                                                        Format="dd/MM/yyyy"
                                                        Enabled="true" />
                                                    <cc1:MaskedEditExtender
                                                        ID="MaskedEditExtender3"
                                                        runat="server"
                                                        TargetControlID="txtDenNgay"
                                                        Mask="99/99/9999"
                                                        MaskType="Date"
                                                        CultureName="vi-VN"
                                                        ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator
                                                        ID="MaskedEditValidator3"
                                                        runat="server"
                                                        ControlExtender="MaskedEditExtender1"
                                                        ControlToValidate="txtDenNgay"
                                                        InvalidValueMessage="dd/MM/yyyy"
                                                        Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                            </tr>
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
                                                            Value="TTBG_CHONHAN"
                                                            Text="Chưa nhận"
                                                            Selected="True"></asp:ListItem>
                                                        <asp:ListItem
                                                            Value="TTBG_DANHAN"
                                                            Text="Đã nhận"></asp:ListItem>
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
                        <tr>
                            <td align="center">
                                <asp:Button
                                    ID="cmdTimkiem"
                                    runat="server"
                                    CssClass="buttoninput"
                                    Text="Tìm kiếm"
                                    OnClick="cmdTimkiem_Click" />
                                <asp:Button
                                    ID="cmdNhanBanGiao"
                                    runat="server"
                                    CssClass="buttoninput"
                                    Text=" Nhận bàn giao án"
                                    OnClick="cmdNhanan_Click" />
                                <asp:Button
                                    ID="cmdHuyNhan"
                                    runat="server"
                                    CssClass="buttoninput"
                                    Text="Hủy nhận bàn giao án"
                                    OnClientClick="return confirm('Bạn thực sự muốn hủy nhận các án này? ');"
                                    OnClick="cmdHuyNhan_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label
                                    runat="server"
                                    ID="lbthongbao"
                                    ForeColor="Red"></asp:Label>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
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
                                        <%-- 0 | [HIDE] - ID Mapping --%>
                                        <asp:BoundColumn
                                            DataField="MAPPINGID"
                                            Visible="false"></asp:BoundColumn>

                                        <%-- 1 | [HIDE] - ID Vụ việc --%>
                                        <asp:BoundColumn
                                            DataField="VUANID"
                                            Visible="false"></asp:BoundColumn>

                                        <%-- 2 | [HIDE] - Toà án nhận --%>
                                        <asp:BoundColumn
                                            DataField="TOAANNHANID"
                                            HeaderText="Toà án nhận"
                                            Visible="false"></asp:BoundColumn>

                                        <%-- 3 | [HIDE] - Toà án giao --%>
                                        <asp:BoundColumn
                                            DataField="TOAANGIAOID"
                                            HeaderText="Toà án giao"
                                            Visible="false"></asp:BoundColumn>

                                        <%-- 4 | [HIDE] - Mã lý do --%>
                                        <asp:BoundColumn
                                            DataField="TOAANGIAOTEN"
                                            HeaderText="Tên toà án giao"
                                            Visible="false"></asp:BoundColumn>

                                        <%-- 5 | Thứ tự--%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="20px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <%-- 6 | Tick chọn --%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="50px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn bị án</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox
                                                    ID="chkChon"
                                                    AutoPostBack="true"
                                                    ToolTip='<%#Eval("MAPPINGID")%>'
                                                    OnCheckedChanged="chkChon_CheckedChanged"
                                                    runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <%-- 7 | Mã bị án --%>
<%--                                        <asp:BoundColumn
                                            DataField="MABIAN"
                                            HeaderText="Mã bị án"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center"
                                            HeaderStyle-Width="100px"></asp:BoundColumn>--%>

                                        <%-- 8 | Tên bị án --%>
      <%--                                  <asp:BoundColumn
                                            DataField="TENBIAN"
                                            HeaderText="Bị án"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>--%>

                                        <%-- 9 | Mã vụ án --%>
                                        <asp:BoundColumn
                                            DataField="MAVUAN"
                                            HeaderText="Mã vụ án"
                                            ItemStyle-HorizontalAlign="Center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                                        <%-- 10 | Tên vụ án --%>
                                        <asp:BoundColumn
                                            DataField="TENVUAN"
                                            HeaderText="Tên vụ án"
                                            HeaderStyle-Width="300px"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                                               
                                        <%-- 11 | Số bản án --%>
                                        <asp:BoundColumn
                                            DataField="SOBANAN"
                                            HeaderText="Số bản án"
                                            ItemStyle-HorizontalAlign="Center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                                        <%-- 12 | Ngày bản án --%>
                                        <asp:BoundColumn
                                            DataField="NGAYBANAN"
                                            HeaderText="Ngày bản án"
                                            HeaderStyle-Width="100px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center"
                                            DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>

                                        <%-- 13 | Tình trạng GQ --%>
                                        <asp:BoundColumn
                                            DataField="TINHTRANGGQ"
                                            HeaderText="Tình trạng GQ"
                                            ItemStyle-HorizontalAlign="Center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                                        <%-- 12 | Toà án chuyển" --%>
                                        <asp:BoundColumn
                                            DataField="TOAANGIAOTEN"
                                            HeaderText="Toà án chuyển"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ></asp:BoundColumn>

                                        <asp:TemplateColumn HeaderText="Nội dung">
                                            <HeaderStyle Width="150px" HorizontalAlign="Center" />
                                            <ItemTemplate>
                                                <asp:Label ID="lblNoiDung" runat="server" Text="Tách nhập đơn vị"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn
                                            DataField="NGAYGIAO"
                                            HeaderText="Ngày bàn giao"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center"
                                            DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>

                                        <asp:BoundColumn
                                            DataField="NGAYNHAN"
                                            HeaderText="Ngày nhận"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center"
                                            DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <%-- 13 | Thao tác --%>
  <%--                                      <asp:TemplateColumn
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
                                                    Text="Nhận bị án"
                                                    CommandName="HuyNhan"
                                                    CommandArgument='<%#Eval("MAPPINGID") %>'
                                                    OnClientClick="return confirm('Bạn thực sự muốn từ chối án này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn
                                            HeaderStyle-Width="85px"
                                            HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton
                                                    ID="lbtNhanChuyen"
                                                    runat="server"
                                                    ForeColor="#0e7eee"
                                                    CausesValidation="false"
                                                    Text="Nhận án"
                                                    CommandName="Nhan"
                                                    CommandArgument='<%#Eval("MAPPINGID") %>'
                                                    OnClientClick="return confirm('Bạn thực sự muốn nhận án này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>

                                <%--Phân trang--%>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
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
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>

    <%--FORM CONFIRM--%>
    <asp:Panel ID="areaConfirm" runat="server" Visible="false">
        <%--Bảng danh sách bàn giao--%>
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
                    <%-- 0 | ID --%>
                    <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>

                    <%-- 1 | ID Toà án nhận --%>
                    <asp:BoundColumn DataField="TOAANNHANID" Visible="false"></asp:BoundColumn>

                    <%-- 2 | ID Vụ việc --%>
                    <asp:BoundColumn
                        DataField="VuViecId"
                        Visible="false"></asp:BoundColumn>

                    <%-- 3 | Mã Vụ việc --%>
                    <asp:BoundColumn
                        DataField="VuViecMa"
                        HeaderText="Mã Vụ Việc"
                        HeaderStyle-HorizontalAlign="Center"
                        ItemStyle-HorizontalAlign="Center"
                        HeaderStyle-Width="250px"></asp:BoundColumn>

                    <%-- 4 | Tên Vụ việc --%>
                    <asp:BoundColumn
                        DataField="VuViecTen"
                        HeaderText="Tên Vụ Việc"
                        HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                    <%-- 5 | Toà án chuyển --%>
                    <asp:BoundColumn
                        DataField="ToaAnGiaoTen"
                        HeaderText="Toà án chuyển"
                        HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                    <%-- 6 | Nội dung --%>
<%--                    <asp:BoundColumn
                        DataField="LyDoTen"
                        HeaderText="Nội dung"
                        HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>--%>

                    <%-- 7 | Ngày giao --%>
                    <asp:BoundColumn
                        DataField="NgayGiao"
                        HeaderText="Ngày chuyển"
                        HeaderStyle-Width="200px"
                        HeaderStyle-HorizontalAlign="Center"
                        ItemStyle-HorizontalAlign="Center"
                        DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>

                </Columns>
                <HeaderStyle CssClass="header"></HeaderStyle>
                <ItemStyle CssClass="chan"></ItemStyle>
            </asp:DataGrid>
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
                            Text="Nhận bàn giao"
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
    </asp:Panel>
    <script src="../../../../UI/js/Common.js"></script>
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
